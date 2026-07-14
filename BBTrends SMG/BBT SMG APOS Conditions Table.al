table 51303 "SMG APOS Conditions"
{
    Caption = 'APOS Conditions', Comment = 'ESP="Condiciones APOS"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Registration Number"; Integer)
        {
            AutoIncrement = true;
            AllowInCustomizations = Never;
        }
        field(2; "Condition Classification"; enum "SMG APOS Type")
        {
            AllowInCustomizations = Never;
            Caption = 'Condition Classification', comment = 'ESP="Clasificación"';
        }
        field(3; "Condition Code"; Code[20])
        {
            AllowInCustomizations = Never;
            Caption = 'Condition Code', Comment = 'ESP="Código Clasificación"';
        }
        field(4; "Description"; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(5; "% APOS Excluded from Invoice"; decimal)
        {
            Caption = '% APOS Excluded from Invoice', Comment = 'ESP="% APOS Fuera Factura"';
            DecimalPlaces = 2 : 2;
            MaxValue = 100;
            MinValue = 0;
        }
        field(6; "Brand"; Code[20])
        {
            AllowInCustomizations = Never;
            Caption = 'Brand', Comment = 'ESP="Marca"';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(7; "Starting Date"; Date)
        {
            AllowInCustomizations = Never;
            Caption = 'Starting Date', Comment = 'ESP="Fecha Inicial"';
        }
        field(8; "Ending Date"; Date)
        {
            Caption = 'Ending Date', Comment = 'ESP="Fecha Final"';
        }
    }
    keys
    {
        key(Key1; "Registration Number", "Condition Classification", "Condition Code")
        {
            Clustered = true;
        }
        key(Key2; "Condition Classification", "Condition Code")
        { }
    }

    fieldgroups
    { }

}