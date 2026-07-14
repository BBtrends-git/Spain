reportextension 50002 "BBT Transfer Receipt" extends "Transfer Receipt"
{
    RDLCLayout = './src/ReportExtension/Layouts/TransferReceipt.rdl';

    dataset
    {
        add(PageLoop)
        {
            column(External_Document_No; "Transfer Receipt Header"."External Document No.")
            { }
            column(External_Document_No_Caption; "Transfer Receipt Header".FieldCaption("External Document No."))
            { }
        }
    }
}
