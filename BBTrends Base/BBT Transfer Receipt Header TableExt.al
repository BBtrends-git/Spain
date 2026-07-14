TableExtension 50165 "BBT Transfer Receipt Header" extends "Transfer Receipt Header"
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
