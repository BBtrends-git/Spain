TableExtension 50129 "BBT Sales Cr.Memo Line" extends "Sales Cr.Memo Line"
{
    fields
    {
        field(50000; "EAN Code"; Text[14])
        {
            Caption = 'EAN Code';
            Description = '001';
        }
        field(50004; "Discount 1 %"; Decimal)
        {
            ObsoleteState = Pending;            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            //CaptionClass = SalesDisc.GetDiscountCaption(1);
            Caption = 'Disc. 1 %';
            Description = '002';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50005; "Discount 2 %"; Decimal)
        {
            ObsoleteState = Pending;            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            //CaptionClass = SalesDisc.GetDiscountCaption(2);
            Caption = 'Disc. 2 %';
            Description = '002';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50006; "Discount 3 %"; Decimal)
        {
            ObsoleteState = Pending;            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            //CaptionClass = SalesDisc.GetDiscountCaption(3);
            Caption = 'Disc. 3 %';
            Description = '002';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50007; "Discount 4 %"; Decimal)
        {
            ObsoleteState = Pending;            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            //CaptionClass = SalesDisc.GetDiscountCaption(4);
            Caption = 'Disc. 4 %';
            Description = '002';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50009; "Discount 5 %"; Decimal)
        {
            ObsoleteState = Pending;            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            //CaptionClass = SalesDisc.GetDiscountCaption(5);
            Caption = 'Disc. 5 %';
            Description = '002';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50010; "Discount 1 Amount"; Decimal)
        {
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //CaptionClass = SalesDisc.GetDiscAmtCaption(1);
            //<<
            Caption = 'Discount 1 Amount';
            Description = '002';
        }
        field(50011; "Discount 2 Amount"; Decimal)
        {
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //CaptionClass = SalesDisc.GetDiscAmtCaption(2);
            //<<
            Caption = 'Discount 2 Amount';
            Description = '002';
        }
        field(50012; "Discount 3 Amount"; Decimal)
        {
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //CaptionClass = SalesDisc.GetDiscAmtCaption(3);
            //<<
            Caption = 'Discount 3 Amount';
            Description = '002';
        }
        field(50013; "Discount 4 Amount"; Decimal)
        {
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //CaptionClass = SalesDisc.GetDiscAmtCaption(4);
            //<<
            Caption = 'Discount 4 Amount';
            Description = '002';
        }
        field(50014; "Discount 5 Amount"; Decimal)
        {
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //CaptionClass = SalesDisc.GetDiscAmtCaption(5);
            //<<
            Caption = 'Discount 5 Amount';
            Description = '002';
        }
        field(50015; "Discounts Total Amount"; Decimal)
        {
            ObsoleteState = Pending;            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            Caption = 'Discounts Total Amount';
            Description = '002';
        }
        field(50018; "Commission %"; Decimal)
        {
            ObsoleteState = Pending;            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            Caption = 'Commission %';
            DecimalPlaces = 2 : 2;
            Description = '003';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50019; "Commission Amount"; Decimal)
        {
            ObsoleteState = Pending;            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            Caption = 'Commission Amount';
            Description = '003';
        }
        field(50020; "Net Unit Price"; Decimal)
        {
            ObsoleteState = Pending;            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            Caption = 'Net Unit Price';
            Description = '004';
        }
        field(50059; "Customer Service No."; Code[20])
        {
            Caption = 'No. servicio cliente';
            Editable = false;
            TableRelation = "Customer Service Header"."No.";
        }
        field(50060; "Customer Service Line No."; Integer)
        {
            Caption = 'No. línea servicio cliente';
            Editable = false;
            TableRelation = "Customer Service Line"."Line No." where("Document No." = field("Customer Service No."));
        }
        field(50061; "BBT Shipping Charge"; Boolean)
        {
            Caption = 'Shipping Charge', comment = 'ESP="Cargo portes"';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50101; "Service Zone Code"; Code[10])
        {
            CalcFormula = lookup("Sales Cr.Memo Header"."Service Zone Code" where("No." = field("Document No.")));
            Caption = 'Service Zone Code';
            Description = 'INC-2018-06-93710';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50102; "Salesperson Code"; Code[20])
        {
            CalcFormula = lookup("Sales Cr.Memo Header"."Salesperson Code" where("No." = field("Document No.")));
            Caption = 'Salesperson Code';
            Description = '005';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50150; "Purchase Group"; Code[10])
        {
            Caption = 'Purchase Group';
            Description = '002';
            Editable = false;
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Removed;
            //CalcFormula = lookup(Customer."Purchase Group" where("No." = field("Sell-to Customer No.")));
            //FieldClass = FlowField;
            //<<
        }
        field(50151; "Customer Type"; Code[10])
        {
            Caption = 'Customer Type';
            Description = '003';
            Editable = false;
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Removed;
            //CalcFormula = lookup(Customer."Customer Type" where("No." = field("Sell-to Customer No.")));
            //FieldClass = FlowField;
            //<<
        }
        field(50152; Platform; Code[10])
        {
            Caption = 'Platform';
            Description = '003';
            Editable = false;
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Removed;
            //CalcFormula = lookup(Customer.Platform where("No." = field("Sell-to Customer No.")));
            //FieldClass = FlowField;
            //<<
        }
        field(50153; "National Group"; Code[10])
        {
            Caption = 'National Group';
            Description = '003';
            Editable = false;
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Removed;
            //CalcFormula = lookup(Customer."National Group" where("No." = field("Sell-to Customer No.")));
            //FieldClass = FlowField;
            //<<
        }
        field(50154; "Customer Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Sell-to Customer No.")));
            Caption = 'Customer Name';
            Description = '200916';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50155; "Tariff Code"; Code[20])
        {
            CalcFormula = lookup(Item."Tariff No." where("No." = field("No.")));
            Caption = 'Tariff Code';
            Description = 'Cód. arencelario';
            FieldClass = FlowField;
        }
    }
    //>> BBT. 16/03/2026. Implantación de la extensión SMG.
    //var
    //SalesDisc: Record "Sales Discounts";
    //<<
}
