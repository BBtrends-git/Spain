Table 51452 "SGA Log Errors"
{
    fields
    {
        field(1; "SGA Serial No"; Code[10])
        {
            Caption = 'SGA Serial No', Comment = 'ESP="No. Serie"';
        }
        field(2; "SGA Error No"; Code[20])
        {
            Caption = 'SGA Error No.', Comment = 'ESP="No. Error"';
        }
        field(3; "SGA Document Type"; Text[30])
        {
            Caption = 'SGA Document Type', Comment = 'ESP="Tipo Documento"';
        }
        field(4; "SGA Document No."; Code[20])
        {
            Caption = 'SGA Document No.', Comment = 'ESP="No. Documento"';
        }
        field(5; "SGA Line No."; Integer)
        {
            Caption = 'SGA Line No.', Comment = 'ESP="No. Línea"';
        }
        field(6; "SGA Posting Date"; Date)
        {
            Caption = 'SGA Posting Date', Comment = 'ESP="Fecha Registro"';
        }
        field(7; "SGA Item No."; Code[20])
        {
            Caption = 'SGA Item No.', Comment = 'ESP="No. Producto"';
        }
        field(8; "SGA Description"; Text[50])
        {
            Caption = 'SGA Description', comment = 'ESP="Descripción"';
        }
        field(9; "SGA Quantity"; Decimal)
        {
            Caption = 'SGA Quantity', Comment = 'ESP="Cantidad"';
            DecimalPlaces = 0 : 5;
        }
        field(10; "SGA Last Date"; Date)
        {
            Caption = 'SGA Last Date', Comment = 'ESP="Ultima Fecha"';
        }
        field(11; "SGA Description Error"; Text[2000])
        {
            Caption = 'SGA Description Error', Comment = 'ESP="Descripción del Error"';
        }
        field(12; "SGA Corrected"; Boolean)
        {
            Caption = 'Corrected', Comment = 'ESP="Corregido"';
        }
    }
    keys
    {
        key(Key1; "SGA Error No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    { }
}