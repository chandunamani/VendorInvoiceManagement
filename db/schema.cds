namespace vendor.invoice;

using { cuid, managed } from '@sap/cds/common';

type VendorStatus : String enum {
    APPROVED;
    PENDING;
    SUSPENDED;
}

type InvoiceStatus : String enum {
    DRAFT;
    SUBMITTED;
    APPROVED;
    REJECTED;
    PAID;
}

entity Vendors : cuid, managed {

    vendorName  : String(100);
    email       : String(100);
    phone       : String(20);
    country     : String(50);
    currency    : String(5);
    taxId       : String(30);
    address     : String(255);
    status      : VendorStatus;
    manager     : String(100);

    invoices : Association to many Invoices
        on invoices.vendor = $self;
}

entity Invoices : cuid, managed {

    invoiceNumber : String(30);
    invoiceDate   : Date;
    dueDate       : Date;
    amount        : Decimal(15,2);
    currency      : String(5);
    status        : InvoiceStatus;

    vendor_ID     : UUID;
    vendor         : Association to Vendors
        on vendor.ID = vendor_ID;

    items : Composition of many InvoiceItems
        on items.invoice = $self;

    attachments : Composition of many Attachments
        on attachments.invoice = $self;

    history : Composition of many ApprovalHistory
        on history.invoice = $self;
}

entity InvoiceItems : cuid {

    lineNumber  : Integer;
    description : String(255);
    quantity    : Integer;
    unitPrice   : Decimal(15,2);
    totalAmount : Decimal(15,2);

    invoice : Association to Invoices;
}

entity Attachments : cuid, managed {

    fileName : String(255);
    fileType : String(50);
    fileSize : Integer;

    invoice : Association to Invoices;
}

entity ApprovalHistory : cuid, managed {

    action   : String(20);
    actor    : String(100);
    comments : String(500);

    invoice : Association to Invoices;
}