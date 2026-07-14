table 51300 "SMG Setup"
{
    Caption = 'Margin Management Setup', Comment = 'ESP="Configuración Gestión de Margenes"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            AllowInCustomizations = Never;
            Caption = 'Primary Key';
        }
        field(2; "SMG Enabled"; Boolean)
        {
            Caption = 'SMG Enabled', Comment = 'ESP="SMG Activado"';
        }
        field(3; "Minimum Margin %"; Decimal)
        {
            Caption = 'Minimum Margin %', Comment = 'ESP="% Mínimo de Margen"';
            DecimalPlaces = 2 : 2;
            MaxValue = 100;
            MinValue = 0;
        }
        field(4; "Discount 1 Enabled"; Boolean)
        {
            Caption = 'Discount 1 Enabled', Comment = 'ESP="Descuento 1 Activado"';
        }
        field(5; "Discount 1 Caption"; Text[50])
        {
            Caption = 'Discount 1 Caption', Comment = 'ESP="Nombre Descuento 1"';
        }
        field(6; "Discount 2 Enabled"; Boolean)
        {
            Caption = 'Discount 2 Enabled', Comment = 'ESP="Descuento 2 Activado"';
        }
        field(7; "Discount 2 Caption"; Text[50])
        {
            Caption = 'Discount 2 Caption', Comment = 'ESP="Nombre Descuento 2"';
        }
        field(8; "Discount 3 Enabled"; Boolean)
        {
            Caption = 'Discount 3 Enabled', Comment = 'ESP="Descuento 3 Activado"';
        }
        field(9; "Discount 3 Caption"; Text[50])
        {
            Caption = 'Discount 3 Caption', Comment = 'ESP="Nombre Descuento 3"';
        }
        field(10; "Discount 4 Enabled"; Boolean)
        {
            Caption = 'Discount 4 Enabled', Comment = 'ESP="Descuento 4 Activado"';
        }
        field(11; "Discount 4 Caption"; Text[50])
        {
            Caption = 'Discount 4 Caption', Comment = 'ESP="Nombre Descuento 4"';
        }
        field(12; "Discount 5 Enabled"; Boolean)
        {
            Caption = 'Discount 5 Enabled', Comment = 'ESP="Descuento 5 Activado"';
        }
        field(13; "Discount 5 Caption"; Text[50])
        {
            Caption = 'Discount 5 Caption', Comment = 'ESP="Nombre Descuento 5"';
        }
        field(14; "Purchase Group Enabled"; Boolean)
        {
            Caption = 'Purchase Group Enabled', Comment = 'ESP="Grupo Compra Activo"';
        }
        field(15; "Purch. Group Disc. Enabled"; Boolean)
        {
            Caption = 'Purch. Group Discount', Comment = 'ESP="Dto. Grupo Compra"';
        }
        field(16; "Purchase Group Count"; Integer)
        {
            Caption = 'Purchase Group Count', Comment = 'ESP="Numero de Grupos de Compra"';
            FieldClass = FlowField;
            CalcFormula = count("SMG Customer Classification" where(Type = const("Purchasing Group")));
            Editable = False;
        }
        field(17; "Customer Type Enabled"; Boolean)
        {
            Caption = 'Customer Type Enabled', Comment = 'ESP="Tipo Cliente Activo"';
        }
        field(18; "Customer Type Disc. Enabled"; Boolean)
        {
            Caption = 'Customer Type Discount', Comment = 'ESP="Dto. Tipo Cliente"';
        }
        field(19; "Customer Type Count"; Integer)
        {
            Caption = 'Customer Type Count', Comment = 'ESP="Numero de Tipo de Clientes"';
            FieldClass = FlowField;
            CalcFormula = count("SMG Customer Classification" where(Type = const("Customer Type")));
            Editable = False;
        }
        field(20; "National Group Enabled"; Boolean)
        {
            Caption = 'National Group Enabled', Comment = 'ESP="Grupo Nacional Activo"';
        }
        field(21; "National Group Disc. Enabled"; Boolean)
        {
            Caption = 'National Group Discount', Comment = 'ESP="Dto. Grupo Nacional"';
        }
        field(22; "National Group Count"; Integer)
        {
            Caption = 'National Group Count', Comment = 'ESP="Numero de Grupos Nacionales"';
            FieldClass = FlowField;
            CalcFormula = count("SMG Customer Classification" where(Type = const("National Group")));
            Editable = False;
        }
        field(23; "Platform Enabled"; Boolean)
        {
            Caption = 'Platform Enabled', Comment = 'ESP="Plataforma Activo"';
        }
        field(24; "Platform Disc. Enabled"; Boolean)
        {
            Caption = 'Platform Discount', Comment = 'ESP="Dto. Plataforma"';
        }
        field(25; "Platform Count"; Integer)
        {
            Caption = 'Platform Count', Comment = 'ESP="Numero de Plataformas"';
            FieldClass = FlowField;
            CalcFormula = count("SMG Customer Classification" where(Type = const(Platform)));
            Editable = False;
        }
        field(26; "COLs Conditions Enabled"; Boolean)
        {
            Caption = 'COLs Conditions Enabled', Comment = 'ESP="Condiciones COLs Activo"';
        }
        field(27; "APOs Conditions Enabled"; Boolean)
        {
            Caption = 'APOs Conditions Enabled', Comment = 'ESP="Condiciones APOs Activo"';
        }
        field(28; "Platform APOs Enabled"; Boolean)
        {
            Caption = 'Platform APOs Enabled', Comment = 'ESP="APOs Plataforma Activo"';
        }
        field(29; "Net Price Rounding Precision"; Decimal)
        {
            Caption = 'Net Unit Price Rounding Precision', Comment = 'ESP="Redondeo Precio Neto Unitario"';
            DecimalPlaces = 0 : 5;
            InitValue = 0.01;

            trigger OnValidate()
            var
                Error01: Label 'Inconsistent Precision', Comment = 'ESP="Precisión de Redondeo Inconsistente"';
            begin
                if (rec."Net Price Rounding Precision" <> 1) and
                (rec."Net Price Rounding Precision" <> 0.1) and
                (rec."Net Price Rounding Precision" <> 0.01) and
                (rec."Net Price Rounding Precision" <> 0.001) and
                (rec."Net Price Rounding Precision" <> 0.0001) and
                (rec."Net Price Rounding Precision" <> 0.00001) then
                    Error(Error01);
            end;
        }
    }
    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    { }
}