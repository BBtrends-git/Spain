TableExtension 50128 "BBT Sales Cr.Memo Header" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50001; "Service Zone Code"; Code[10])
        {
            Caption = 'Service Zone Code';
            Description = 'INC-2018-06-93710';
            TableRelation = "Service Zone";
        }
        field(50002; "Sales Person Name"; Text[50])
        {
            CalcFormula = lookup("Salesperson/Purchaser".Name where(Code = field("Salesperson Code")));
            Caption = 'Nombre Vendedor';
            Description = '200916';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50050; "BBT PL Currency Exchange"; Decimal)
        {
            Caption = 'PL Currency Exchange';
            Editable = false;
        }
        field(50059; "Customer Service No."; Code[20])
        {
            Caption = 'Nº servicio cliente';
            Editable = false;
            TableRelation = "Customer Service Header"."No.";
        }
        field(50099; "PL VAT"; Boolean)
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        /* field(50100; "Shipping Agent Code"; Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Agent Code',comment = 'ESP="Cód. Transportista"';
            Description = 'INC-2017-02-67667';
            TableRelation = "Shipping Agent";
        } 
        */
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
