TableExtension 51301 "SMG Sales Lines" extends "Sales Line"
{
    fields
    {
        field(51300; "SMG Discount 1 %"; Decimal)
        {
            CaptionClass = rSMGSalesDiscounts.GetDiscountCaption(1);
            Caption = 'Disc. 1 %';
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                if Rec."SMG Discount 1 %" <> xRec."SMG Discount 1 %" then begin
                    TestJobPlanningLine;
                    Rec.TestStatusOpen;
                    CUSMGManagement.SMGCalculateSalesDiscounts(Rec);
                    if CurrFieldNo = Rec.FieldNo(Rec."SMG Discount 1 %") then
                        Rec.Validate(Rec."Line Discount %");
                end;
            end;
        }
        field(51301; "SMG Discount 2 %"; Decimal)
        {
            CaptionClass = rSMGSalesDiscounts.GetDiscountCaption(2);
            Caption = 'Disc. 2 %';
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                if Rec."SMG Discount 2 %" <> xRec."SMG Discount 2 %" then begin
                    TestJobPlanningLine;
                    Rec.TestStatusOpen;
                    CUSMGManagement.SMGCalculateSalesDiscounts(Rec);
                    if CurrFieldNo = Rec.FieldNo(Rec."SMG Discount 2 %") then
                        Rec.Validate(Rec."Line Discount %");
                end;
            end;
        }
        field(51302; "SMG Discount 3 %"; Decimal)
        {
            CaptionClass = rSMGSalesDiscounts.GetDiscountCaption(3);
            Caption = 'Disc. 3 %';
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                if Rec."SMG Discount 3 %" <> xRec."SMG Discount 3 %" then begin
                    TestJobPlanningLine;
                    Rec.TestStatusOpen;
                    CUSMGManagement.SMGCalculateSalesDiscounts(Rec);
                    if CurrFieldNo = Rec.FieldNo(Rec."SMG Discount 3 %") then
                        Rec.Validate(Rec."Line Discount %");
                end;
            end;
        }
        field(51303; "SMG Discount 4 %"; Decimal)
        {
            CaptionClass = rSMGSalesDiscounts.GetDiscountCaption(4);
            Caption = 'Disc. 4 %';
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                if Rec."SMG Discount 4 %" <> xRec."SMG Discount 4 %" then begin
                    TestJobPlanningLine;
                    Rec.TestStatusOpen;
                    CUSMGManagement.SMGCalculateSalesDiscounts(Rec);
                    if CurrFieldNo = Rec.FieldNo(Rec."SMG Discount 4 %") then
                        Rec.Validate(Rec."Line Discount %");
                end;
            end;
        }
        field(51304; "SMG Discount 5 %"; Decimal)
        {
            CaptionClass = rSMGSalesDiscounts.GetDiscountCaption(5);
            Caption = 'Disc. 5 %';
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                if Rec."SMG Discount 5 %" <> xRec."SMG Discount 5 %" then begin
                    TestJobPlanningLine;
                    Rec.TestStatusOpen;
                    CUSMGManagement.SMGCalculateSalesDiscounts(Rec);
                    if CurrFieldNo = Rec.FieldNo(Rec."SMG Discount 5 %") then Rec.Validate(Rec."Line Discount %");
                end;
            end;
        }
        field(51305; "SMG Discount 1 Amount"; Decimal)
        {
            CaptionClass = rSMGSalesDiscounts.GetDiscountAmountCaption(1);
            Caption = 'Discount 1 Amount';
            Editable = false;
        }
        field(51306; "SMG Discount 2 Amount"; Decimal)
        {
            CaptionClass = rSMGSalesDiscounts.GetDiscountAmountCaption(2);
            Caption = 'Discount 2 Amount';
            Editable = false;
        }
        field(51307; "SMG Discount 3 Amount"; Decimal)
        {
            CaptionClass = rSMGSalesDiscounts.GetDiscountAmountCaption(3);
            Caption = 'Discount 3 Amount';
            Editable = false;
        }
        field(51308; "SMG Discount 4 Amount"; Decimal)
        {
            CaptionClass = rSMGSalesDiscounts.GetDiscountAmountCaption(4);
            Caption = 'Discount 4 Amount';
            Editable = false;
        }
        field(51309; "SMG Discount 5 Amount"; Decimal)
        {
            CaptionClass = rSMGSalesDiscounts.GetDiscountAmountCaption(5);
            Caption = 'Discount 5 Amount';
            Editable = false;
        }
        field(51310; "SMG Discounts Total Amount"; Decimal)
        {
            Caption = 'Discounts Total Amount', Comment = 'ESP="Importe Total Descuentos"';
            Editable = false;
        }
        field(51311; "SMG Commission %"; Decimal)
        {
            Caption = 'Commission %', Comment = 'ESP="% Comisión"';
            DecimalPlaces = 2 : 2;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                Rec.Validate(Rec."SMG Commission Amount");
            end;
        }
        field(51312; "SMG Commission Amount"; Decimal)
        {
            Caption = 'Commission Amount', Comment = 'ESP="Importe Comisión"';
            Editable = false;
            trigger OnValidate()
            begin
                Rec."SMG Commission Amount" := ROUND(Rec."Line Amount" * Rec."SMG Commission %" / 100, cuSMGManagement.AmountRoundingPrecision);
            end;
        }
        field(51313; "SMG Net Unit Price"; Decimal)
        {
            Caption = 'Net Unit Price', Comment = 'ESP="Precio Unitario Neto"';
            AutoFormatType = 2;
            Editable = false;
        }
        field(51314; "SMG % APOS Excluded Invoice"; Decimal)
        {
            Caption = '% APOS Excluded Invoice', Comment = 'ESP="Cond. F.F. % APOS"';
            Editable = false;
            MaxValue = 100;
            MinValue = 0;
        }
        field(51315; "SMG % COLS Excluded Invoice"; Decimal)
        {
            Caption = '% COLS Excluded Invoice', Comment = 'ESP="Cond. F.F. % COLS"';
            Editable = false;
            MaxValue = 100;
            MinValue = 0;
        }
        field(51316; "SMG Transport Sales %"; Decimal)
        {
            Caption = 'Transportation Sales %', Comment = 'ESP="% Transporte Ventas"';
            Editable = false;
            MaxValue = 100;
            MinValue = 0;
        }
        field(51317; "SMG Devs Fin %"; Decimal)
        {
            Caption = 'Devs. Fin. %', comment = 'ESP="% Devs. Fin."';
            Editable = false;
            MaxValue = 100;
            MinValue = 0;
        }
        field(51318; "SMG Warranty %"; Decimal)
        {
            Caption = 'Warranty %', Comment = 'ESP="% Garantia"';
            Editable = false;
            MaxValue = 100;
            MinValue = 0;
        }
        field(51319; "SMG Royalty %"; Decimal)
        {
            Caption = 'Royalty %', Comment = 'ESP="% Royalty"';
            Editable = false;
            MaxValue = 100;
            MinValue = 0;
        }
        field(51320; "SMG RAEE Amount"; Decimal)
        {
            Caption = 'RAEE Amount', Comment = 'ESP="Importe RAEE"';
            Editable = false;
        }

        field(51321; "SMG Blocked for Short Margin"; Boolean)
        {
            Caption = 'Blocked for Short Margin', Comment = 'ESP="Bloqueado por Margen Insuficiente"';
            Editable = false;
        }
        field(51322; "SMG Margin %"; Decimal)
        {
            Caption = 'Margin %', Comment = 'ESP="% Margen"';
            Editable = false;
            MaxValue = 100;
            MinValue = 0;
        }
        field(51323; "SMG Unit Margin Amount"; Decimal)
        {
            Caption = 'Unit Margin Amount', comment = 'ESP="Importe Margen Unitario"';
            Editable = false;
        }
    }
    var
        rSMGSalesDiscounts: Record "SMG Sales Discounts";
        cuSMGManagement: Codeunit "SMG Management";
}