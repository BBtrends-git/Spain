reportextension 50003 "BBT Transfer Shipment" extends "Transfer Shipment"
{
    RDLCLayout = './src/ReportExtension/Layouts/TransferShipment.rdl';

    dataset
    {
        add(PageLoop)
        {
            column(External_Document_No; "Transfer Shipment Header"."External Document No.")
            { }
            column(External_Document_No_Caption; "Transfer Shipment Header".FieldCaption("External Document No."))
            { }
        }
    }
}
