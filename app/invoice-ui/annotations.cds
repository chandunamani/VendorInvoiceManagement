using VendorInvoiceService as service from '../../srv/service';

annotate service.Invoices with {

    invoiceNumber @mandatory;
    invoiceDate @mandatory;
    dueDate @mandatory;
    amount @mandatory;
    currency @mandatory;
    vendor_ID @mandatory;

    vendor_ID @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Vendors',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : vendor_ID,
                ValueListProperty : 'ID'
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'vendorName'
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'email'
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'country'
            }
        ]
    };

};

annotate service.Invoices with @(

    UI.HeaderInfo : {
        TypeName : 'Invoice',
        TypeNamePlural : 'Invoices',
        Title : {
            $Type : 'UI.DataField',
            Value : invoiceNumber
        },
        Description : {
            $Type : 'UI.DataField',
            Value : status
        }
    },

    UI.SelectionFields : [
        invoiceNumber,
        status,
        currency
    ],

    UI.LineItem : [

        { $Type : 'UI.DataField', Label : 'Invoice Number', Value : invoiceNumber },
        { $Type : 'UI.DataField', Label : 'Invoice Date', Value : invoiceDate },
        { $Type : 'UI.DataField', Label : 'Due Date', Value : dueDate },
        { $Type : 'UI.DataField', Label : 'Amount', Value : amount },
        { $Type : 'UI.DataField', Label : 'Currency', Value : currency },
        { $Type : 'UI.DataField', Label : 'Status', Value : status },
        { $Type : 'UI.DataField', Label : 'Vendor', Value : vendor_ID }

    ],

    UI.FieldGroup #General : {

        $Type : 'UI.FieldGroupType',

        Data : [

            { $Type : 'UI.DataField', Label : 'Invoice Number', Value : invoiceNumber },
            { $Type : 'UI.DataField', Label : 'Invoice Date', Value : invoiceDate },
            { $Type : 'UI.DataField', Label : 'Due Date', Value : dueDate },
            { $Type : 'UI.DataField', Label : 'Amount', Value : amount },
            { $Type : 'UI.DataField', Label : 'Currency', Value : currency },
            { $Type : 'UI.DataField', Label : 'Status', Value : status },
            { $Type : 'UI.DataField', Label : 'Vendor', Value : vendor_ID }

        ]
    },

    UI.Facets : [

        {
            $Type : 'UI.ReferenceFacet',
            ID : 'General',
            Label : 'General Information',
            Target : '@UI.FieldGroup#General'
        },

        {
            $Type : 'UI.ReferenceFacet',
            ID : 'Items',
            Label : 'Invoice Items',
            Target : 'items/@UI.LineItem'
        },

        {
            $Type : 'UI.ReferenceFacet',
            ID : 'Attachments',
            Label : 'Attachments',
            Target : 'attachments/@UI.LineItem'
        },

        {
            $Type : 'UI.ReferenceFacet',
            ID : 'History',
            Label : 'Approval History',
            Target : 'history/@UI.LineItem'
        }

    ],

    UI.Identification : [

        {
            $Type : 'UI.DataFieldForAction',
            Action : 'VendorInvoiceService.SubmitInvoice',
            Label : 'Submit'
        },

        {
            $Type : 'UI.DataFieldForAction',
            Action : 'VendorInvoiceService.ApproveInvoice',
            Label : 'Approve'
        },

        {
            $Type : 'UI.DataFieldForAction',
            Action : 'VendorInvoiceService.RejectInvoice',
            Label : 'Reject'
        },

        {
            $Type : 'UI.DataFieldForAction',
            Action : 'VendorInvoiceService.SyncVendors',
            Label : 'Sync Vendors'
        }

    ]

);

annotate service.InvoiceItems with @(

    UI.LineItem : [
        { $Type : 'UI.DataField', Value : lineNumber },
        { $Type : 'UI.DataField', Value : description },
        { $Type : 'UI.DataField', Value : quantity },
        { $Type : 'UI.DataField', Value : unitPrice },
        { $Type : 'UI.DataField', Value : totalAmount }
    ]

);

annotate service.Attachments with @(

    UI.LineItem : [
        { $Type : 'UI.DataField', Value : fileName },
        { $Type : 'UI.DataField', Value : fileType },
        { $Type : 'UI.DataField', Value : fileSize }
    ]

);

annotate service.ApprovalHistory with @(

    UI.LineItem : [
        { $Type : 'UI.DataField', Value : action },
        { $Type : 'UI.DataField', Value : actor },
        { $Type : 'UI.DataField', Value : comments },
        { $Type : 'UI.DataField', Value : createdAt }
    ]

);