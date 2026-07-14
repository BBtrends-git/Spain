TableExtension 50164 "BBT Transfer Shipment Header" extends "Transfer Shipment Header"
{
    fields
    {
        field(50059; "Customer Service No."; Code[20])
        {
            Caption = 'No. servicio cliente';
            Editable = false;
            TableRelation = "Customer Service Header"."No.";
        }
    }
}
