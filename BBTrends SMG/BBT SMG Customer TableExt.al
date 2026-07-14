TableExtension 51300 "SMG Customer" extends Customer
{
    fields
    {
        field(51300; "SMG Purchase Group"; Code[20])
        {
            Caption = 'Purchase Group', Comment = 'ESP="Grupo Compra"';
            TableRelation = "SMG Customer Classification".Code where(Type = const("Purchasing Group"));
        }
        field(51301; "SMG Customer Type"; Code[20])
        {
            Caption = 'Customer Type', Comment = 'ESP="Tipo Cliente"';
            TableRelation = "SMG Customer Classification".Code where(Type = const("Customer Type"));
        }
        field(51302; "SMG Platform"; Code[20])
        {
            Caption = 'Platform', Comment = 'ESP="Plataforma"';
            TableRelation = "SMG Customer Classification".Code where(Type = const(Platform));
        }
        field(51303; "SMG National Group"; Code[20])
        {
            Caption = 'National Group', Comment = 'ESP="Grupo Nacional"';
            TableRelation = "SMG Customer Classification".Code where(Type = const("National Group"));
        }
        field(51304; "SMG COLs Conditions"; Boolean)
        {
            Caption = 'Apply Cols Conditions', Comment = 'ESP="Aplica Condiciones COLS"';
            Editable = False;
            FieldClass = FlowField;
            CalcFormula = exist("SMG Cols Conditions" where("Customer No." = field("No.")));
        }
        field(51305; "SMG APOs Conditions"; Boolean)
        {
            Caption = 'Apply Apos Conditions', Comment = 'ESP="Aplica APOs Cliente"';
            Editable = False;
            FieldClass = FlowField;
            CalcFormula = exist("SMG Apos Conditions" where("Condition Classification" = const("SMG APOS Type"::Customer),
                                                           "Condition Code" = field("No.")));
        }
        field(51306; "SMG APOs Conditions Platform"; Boolean)
        {
            Caption = 'Apply APOs Conditions Platform', Comment = 'ESP="Aplica APOs Plataforma"';
            Editable = False;
            FieldClass = FlowField;
            CalcFormula = exist("SMG Apos Conditions" where("Condition Classification" = const("SMG APOS Type"::Platform),
                                                           "Condition Code" = field("SMG Platform")));
        }
        field(51307; "SMG Transport Sales %"; Decimal)
        {
            Caption = 'Transportation Sales %', comment = 'ESP="Transporte ventas %"';
            MaxValue = 100;
            MinValue = 0;
        }
        field(51308; "SMG Devs Fin %"; Decimal)
        {
            Caption = 'Devs. Fin. %', comment = 'ESP="% Devs. Fin."';
            MaxValue = 100;
            MinValue = 0;
        }
        field(51309; "SMG Commission %"; Decimal)
        {
            Caption = 'Commission %', comment = 'ESP="Comisión %"';
            MaxValue = 100;
            MinValue = 0;
        }
        field(51310; "SMG No Apply RAEE"; Boolean)
        {
            Caption = 'NO Apply RAEE', Comment = 'ESP="No aplica RAEE"';
            InitValue = false;
        }
        field(51311; "SMG Customer Sales Discounts"; Boolean)
        {
            Caption = 'Customer Sales Discounts', Comment = 'ESP="Descuentos Venta Cliente"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist("SMG Sales Discounts" where("SMG Apply to" = const("SMG Sales Discount Type"::Customer),
                                                            "SMG Code" = field("No.")));
        }
    }
}