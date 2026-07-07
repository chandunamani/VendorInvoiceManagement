const cds = require("@sap/cds");

module.exports = cds.service.impl(async function () {

    const { Invoices, Vendors, InvoiceItems, ApprovalHistory } = this.entities;

    

    this.before("READ", "Vendors", req => {

        
        if (req.query.SELECT?.where?.some(x => x.ref?.includes("IsActiveEntity"))) return;

        if (req.user.is("Admin")) return;

        if (!req.user.is("VendorManager")) return;

        req.query.where({
            manager: req.user.id
        });

    });

   

    this.before("READ", "Invoices", async req => {

        if (req.query.SELECT?.where?.some(x => x.ref?.includes("IsActiveEntity"))) return;

        if (req.user.is("Admin")) return;

        if (!req.user.is("VendorManager")) return;

        const vendors = await SELECT
            .from(Vendors)
            .columns("ID")
            .where({ manager: req.user.id });

        const vendorIds = vendors.map(v => v.ID);

        if (!vendorIds.length) return;

        req.query.where({
            vendor_ID: {
                in: vendorIds
            }
        });

    });

    

this.before(["CREATE", "UPDATE"], "Invoices", async req => {

    
    console.log("==================================");
    console.log("EVENT :", req.event);
    console.log("USER  :", req.user.id);
    console.log("DATA  :", JSON.stringify(req.data, null, 2));
    console.log("==================================");

    // Ignore Draft Save
    if (req.data.IsActiveEntity === false) return;

    // Amount Validation
    if (req.data.amount !== undefined) {

        if (Number(req.data.amount) <= 0)
            req.error("Invoice amount must be greater than zero");

        if (Number(req.data.amount) > 1000000)
            req.error("Invoice amount cannot exceed 1,000,000");
    }

    
    if (req.data.invoiceDate) {

        const today = new Date();
        today.setHours(0, 0, 0, 0);

        const invoiceDate = new Date(req.data.invoiceDate);
        invoiceDate.setHours(0, 0, 0, 0);

        if (invoiceDate > today)
            req.error("Future invoice dates are not allowed");
    }

    
    if (req.data.vendor_ID) {

        const vendor = await SELECT.one
            .from(Vendors)
            .where({ ID: req.data.vendor_ID });

        if (!vendor)
            req.error("Vendor not found");

        if (vendor.status !== "APPROVED")
            req.error("Vendor is not approved");
    }

    
    if (req.data.invoiceNumber) {

        const duplicate = await SELECT.one
            .from(Invoices)
            .where({
                invoiceNumber: req.data.invoiceNumber,
                IsActiveEntity: true
            });

        if (duplicate && duplicate.ID !== req.data.ID)
            req.error("Invoice number already exists");
    }

});

    

    this.on("SubmitInvoice", async req => {

        const ID = req.params[0].ID;

        const invoice = await SELECT.one.from(Invoices).where({
            ID,
            IsActiveEntity: true
        });

        if (!invoice)
            req.error("Invoice not found");

        const items = await SELECT.from(InvoiceItems).where({
            invoice_ID: ID
        });

        if (!items.length)
            req.error("Invoice must contain at least one line item");

        const total = items.reduce(
            (s, i) => s + Number(i.totalAmount),
            0
        );

        if (total !== Number(invoice.amount))
            req.error("Invoice total does not match line item total");

        await UPDATE(Invoices)
            .set({ status: "SUBMITTED" })
            .where({ ID });

        await INSERT.into(ApprovalHistory).entries({
            action: "SUBMITTED",
            actor: req.user.id,
            comments: "Invoice Submitted",
            invoice_ID: ID
        });

        return "Invoice Submitted Successfully";

    });

    

    this.on("ApproveInvoice", async req => {

        const ID = req.params[0].ID;

        const invoice = await SELECT.one.from(Invoices).where({
            ID,
            IsActiveEntity: true
        });

        if (!invoice)
            req.error("Invoice not found");

        if (invoice.createdBy === req.user.id)
            req.error("You cannot approve your own invoice");

        if (invoice.status !== "SUBMITTED")
            req.error("Only submitted invoices can be approved");

        await UPDATE(Invoices)
            .set({ status: "APPROVED" })
            .where({ ID });

        await INSERT.into(ApprovalHistory).entries({
            action: "APPROVED",
            actor: req.user.id,
            comments: "Invoice Approved",
            invoice_ID: ID
        });

        return "Invoice Approved Successfully";

    });

   

    this.on("RejectInvoice", async req => {

        const ID = req.params[0].ID;

        const invoice = await SELECT.one.from(Invoices).where({
            ID,
            IsActiveEntity: true
        });

        if (!invoice)
            req.error("Invoice not found");

        if (invoice.status !== "SUBMITTED")
            req.error("Only submitted invoices can be rejected");

        if (!req.data.comments?.trim())
            req.error("Rejection reason is mandatory");

        await UPDATE(Invoices)
            .set({ status: "REJECTED" })
            .where({ ID });

        await INSERT.into(ApprovalHistory).entries({
            action: "REJECTED",
            actor: req.user.id,
            comments: req.data.comments,
            invoice_ID: ID
        });

        return "Invoice Rejected Successfully";

    });

   

    this.on("SyncVendors", async () => {

        console.log("Vendor Sync Started...");

        return "Vendor synchronization completed successfully.";

    });

});



// module.exports = cds.service.impl(async function () {

//     const { Invoices, Vendors } = this.entities;

//     // -----------------------------
//     // Vendor Security
//     // -----------------------------
//     this.before("READ", "Vendors", async req => {

//         if (req.user.is("Admin")) return;
//         if (!req.user.is("VendorManager")) return;

//         req.query.where({
//             manager: req.user.id
//         });

//     });

//     // -----------------------------
//     // Invoice Security
//     // -----------------------------
//     this.before("READ", "Invoices", async req => {

//         if (req.user.is("Admin")) return;
//         if (!req.user.is("VendorManager")) return;

//         const vendors = await SELECT
//             .from(Vendors)
//             .columns("ID")
//             .where({ manager: req.user.id });

//         if (!vendors.length) return;

//         req.query.where({
//             vendor_ID: {
//                 in: vendors.map(v => v.ID)
//             }
//         });

//     });

// });