using { vendor.invoice as db } from '../db/schema';

service VendorInvoiceService
@(path:'/odata/v4/vendor-invoice')
@(requires:'authenticated-user') {

    @odata.draft.enabled

    @restrict: [
        { grant:'READ', to:['Viewer','Admin','VendorManager','Approver'] },
        { grant:['CREATE','UPDATE','DELETE'], to:['Admin','VendorManager'] }
    ]
    entity Invoices as projection on db.Invoices actions {

        @requires:'VendorManager'
        action SubmitInvoice() returns String;

        @requires:['Approver','Admin']
        action ApproveInvoice() returns String;

        @requires:['Approver','Admin']
        action RejectInvoice(
            comments : String
        ) returns String;

    };

    @requires:'Admin'
    action SyncVendors() returns String;

    @restrict: [
        { grant:'READ', to:['Viewer','Admin','VendorManager','Approver'] },
        { grant:['CREATE','UPDATE','DELETE'], to:['Admin','VendorManager'] }
    ]
    entity Vendors as projection on db.Vendors;

    @restrict: [
        { grant:'READ', to:['Viewer','Admin','VendorManager','Approver'] },
        { grant:['CREATE','UPDATE','DELETE'], to:['Admin','VendorManager'] }
    ]
    entity InvoiceItems as projection on db.InvoiceItems;

    @restrict: [
        { grant:'READ', to:['Viewer','Admin','VendorManager','Approver'] },
        { grant:['CREATE','UPDATE','DELETE'], to:['Admin','VendorManager'] }
    ]
    entity Attachments as projection on db.Attachments;

    @restrict: [
        { grant:'READ', to:['Viewer','Admin','VendorManager','Approver'] }
    ]
    entity ApprovalHistory as projection on db.ApprovalHistory;

}