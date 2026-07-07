using { vendor.invoice as db } from '../db/schema';

service VendorService
@(path:'/vendor')
@(requires:'VendorManager') {

    entity Vendors as projection on db.Vendors;

    entity Invoices as projection on db.Invoices;

    entity InvoiceItems as projection on db.InvoiceItems;

    entity Attachments as projection on db.Attachments;

}