reportextension 50009 "BBT Transfer Order" extends "Transfer Order"
{
    RDLCLayout = './src/ReportExtension/Layouts/TransferOrder.rdl';

    dataset
    {
        add("Transfer Header")
        {
            column(Transfer_to_Code__TransferHdr; "Transfer Header"."Transfer-to Code")
            { }
            column(Transfer_from_Code__TransferHdr; "Transfer Header"."Transfer-from Code")
            { }
        }
        add(PageLoop)
        {
            column(External_Document_No; "Transfer Header"."External Document No.")
            { }
            column(External_Document_No_Caption; "Transfer Header".FieldCaption("External Document No."))
            { }
        }
    }
    labels
    {
        TransferToCaptionLbl = 'Transfer-to:', comment = 'ESP="Transferir a:"';
        TransferFromCaptionLbl = 'Transfer-from:', comment = 'ESP="Transferido de:"';
    }
}
