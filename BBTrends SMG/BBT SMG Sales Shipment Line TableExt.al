TableExtension 51307 "SMG Sales Shipment Line" extends "Sales Shipment Line"
{
    fields
    {
        field(51300; "SMG Discount 1 %"; Decimal)
        {
            CaptionClass = rSMGSalesDiscounts.GetDiscountCaption(1);
            Caption = 'Disc. 1 %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(51301; "SMG Discount 2 %"; Decimal)
        {
            CaptionClass = rSMGSalesDiscounts.GetDiscountCaption(2);
            Caption = 'Disc. 2 %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(51302; "SMG Discount 3 %"; Decimal)
        {
            CaptionClass = rSMGSalesDiscounts.GetDiscountCaption(3);
            Caption = 'Disc. 3 %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(51303; "SMG Discount 4 %"; Decimal)
        {
            CaptionClass = rSMGSalesDiscounts.GetDiscountCaption(4);
            Caption = 'Disc. 4 %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(51304; "SMG Discount 5 %"; Decimal)
        {
            CaptionClass = rSMGSalesDiscounts.GetDiscountCaption(5);
            Caption = 'Disc. 5 %';
            MaxValue = 100;
            MinValue = 0;
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
        }
        field(51312; "SMG Commission Amount"; Decimal)
        {
            Caption = 'Commission Amount', Comment = 'ESP="Importe Comisión"';
            Editable = false;
        }
        field(51313; "SMG Net Unit Price"; Decimal)
        {
            Caption = 'Net Unit Price', Comment = 'ESP="Precio Unitario Neto"';
            Editable = false;
        }
    }
    var
        rSMGSalesDiscounts: Record "SMG Sales Discounts";
}