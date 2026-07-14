reportextension 50000 "BBT Purchase - Receipt" extends "Purchase - Receipt"
{
    RDLCLayout = './src/ReportExtension/Layouts/PurchaseReceipt.rdl';

    dataset
    {
        add("Purch. Rcpt. Line")
        {
            column(LocationLabel; "Purch. Rcpt. Line"."Location Code")
            { }
            column(LocationLabelCaption; "Purch. Rcpt. Line".FieldCaption("Location Code"))
            { }
        }
    }
}
