const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {

    const { InvoiceAnalytics } = this.entities;

    this.after("READ", InvoiceAnalytics, async (data) => {

        const records = Array.isArray(data) ? data : [data];

        let totalInvoices = records.length;
        let totalAmount = 0;
        let approved = 0;
        let submitted = 0;
        let rejected = 0;
        let draft = 0;

        records.forEach(r => {

            totalAmount += Number(r.amount);

            switch (r.status) {

                case "APPROVED":
                    approved++;
                    break;

                case "SUBMITTED":
                    submitted++;
                    break;

                case "REJECTED":
                    rejected++;
                    break;

                case "DRAFT":
                    draft++;
                    break;
            }

        });

        console.log("========== Invoice Analytics ==========");
        console.log("Total Invoices :", totalInvoices);
        console.log("Total Amount   :", totalAmount);
        console.log("Approved       :", approved);
        console.log("Submitted      :", submitted);
        console.log("Rejected       :", rejected);
        console.log("Draft          :", draft);
        console.log("=======================================");

    });

});