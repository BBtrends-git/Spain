Table 50040 "Log NAVSGA Errors"
{
    fields
    {
        field(1; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
        }
        field(2; "No."; Code[20])
        {
        }
        field(3; "Document Type"; Text[30])
        {
            Caption = 'Document Type';
        }
        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(6; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(7; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(8; Description; Text[50])
        {
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
        field(9; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(10; "Last Date"; Date)
        {
            Caption = 'Last Date';
        }
        field(11; "Description  Error"; Text[2000])
        {
            Caption = 'Description Error';
        }
        field(12; Corrected; Boolean)
        {
            Caption = 'Corrected';
        }
    }
    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }
}
