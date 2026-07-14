TableExtension 50173 "BBT Return Receipt Header" extends "Return Receipt Header"
{
    fields
    {
        field(50059; "Customer Service No."; Code[20])
        {
            Caption = 'No. servicio cliente';
            Editable = false;
            TableRelation = "Customer Service Header"."No.";
        }
        field(50114; "Number of Packages"; Decimal)
        {
            Caption = 'Number of Packages';
            DecimalPlaces = 0 : 6;
            Description = 'INC-2017-02-67667';
        }
        field(50115; Reference; Text[100])
        {
            Caption = 'Referencia';
            Description = 'INC-2017-02-67667';
        }
    }
}
