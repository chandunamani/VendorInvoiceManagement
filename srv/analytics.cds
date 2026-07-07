using { vendor.invoice as db } from '../db/schema';

service AnalyticsService @(path:'/analytics') {

    @readonly
    entity InvoiceAnalytics as select from db.Invoices {
        key ID,
        invoiceNumber,
        amount,
        currency,
        status,
        vendor.vendorName as vendorName
    };

}