using { vendor.invoice as db } from '../db/schema';

service AdminService
@(path:'/admin')
@(requires:'Admin') {

    @odata.draft.enabled
    entity Invoices as projection on db.Invoices;

    entity Vendors as projection on db.Vendors;

    entity InvoiceItems as projection on db.InvoiceItems;

    entity Attachments as projection on db.Attachments;

    entity ApprovalHistory as projection on db.ApprovalHistory;

}