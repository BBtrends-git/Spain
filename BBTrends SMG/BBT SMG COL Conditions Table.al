table 51302 "SMG COLS Conditions"
{
    Caption = 'COLS Conditions', Comment = 'ESP="Condiciones COLS"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Registration Number"; Integer)
        {
            AutoIncrement = true;
            AllowInCustomizations = Never;
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.', Comment = 'ESP="No. Cliente"';
            AllowInCustomizations = Never;
            NotBlank = true;
        }
        field(3; "% COLS Excluded from Invoice"; decimal)
        {
            Caption = '% COLS Excluded from Invoice', Comment = 'ESP="% COLS Fuera Factura"';
            NotBlank = true;
            DecimalPlaces = 2 : 2;
            MaxValue = 100;
            MinValue = 0;
        }
        field(4; "Starting Date"; Date)
        {
            Caption = 'Starting Date', Comment = 'ESP="Fecha Inicial"';
            NotBlank = true;
        }
        field(5; "Ending Date"; Date)
        {
            Caption = 'Ending Date', Comment = 'ESP="Fecha Final"';
        }
    }
    keys
    {
        key(Key1; "Registration Number", "Customer No.")
        {
            Clustered = true;
        }
        key(Key2; "Customer No.")
        { }
    }

    fieldgroups
    { }
}