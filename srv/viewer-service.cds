using { vendor.invoice as db } from '../db/schema';

service ViewerService
@(path:'/viewer')
@(requires:'Viewer') {

    @readonly
    entity Vendors as projection on db.Vendors;

    @readonly
    entity Invoices as projection on db.Invoices;

    @readonly
    entity InvoiceItems as projection on db.InvoiceItems;

    @readonly
    entity Attachments as projection on db.Attachments;

    @readonly
    entity ApprovalHistory as projection on db.ApprovalHistory;

}