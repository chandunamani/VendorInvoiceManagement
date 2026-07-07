using { vendor.invoice as db } from '../db/schema';

service ApproverService
@(path:'/approver')
@(requires:'Approver') {

    entity Invoices as projection on db.Invoices;

    entity ApprovalHistory as projection on db.ApprovalHistory;

}