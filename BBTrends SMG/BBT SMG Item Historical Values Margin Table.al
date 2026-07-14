table 51305 "SMG Historical Values Margin"
{
    Caption = 'Historical Values for Margin', Comment = 'ESP="Valores Históricos del Margen"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Registration Number"; Integer)
        {
            AutoIncrement = true;
            AllowInCustomizations = Never;
        }
        field(2; Type; enum "SMG Item Hist Margin Type")
        {
            Caption = 'Type', comment = 'ESP="Tipo"';
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.', Comment = 'ESP="No. Producto"';
            AllowInCustomizations = Never;
            NotBlank = true;
        }
        field(4; "Cost Amount"; Decimal)
        {
            Caption = 'Cost Amount', Comment = 'ESP="Importe Coste"';
            NotBlank = true;
        }
        field(5; "Starting Date"; Date)
        {
            Caption = 'Starting Date', Comment = 'ESP="Fecha Inicial"';
            NotBlank = true;
        }
        field(6; "Ending Date"; Date)
        {
            Caption = 'Ending Date', Comment = 'ESP="Fecha Final"';
        }
    }
    keys
    {
        key(Key1; "Registration Number", "Item No.")
        {
            Clustered = true;
        }
        key(Key2; "Item No.")
        { }
    }

    fieldgroups
    { }
}