Page 50029 "Sales Statistics Factbox"
{
    Caption = 'Sales Statistics Factbox';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    SourceTable = "Sales Header";
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            field("Lines Amount"; LinesAmount)
            {
                ApplicationArea = Basic;
                Caption = 'Lines Amount';
            }
            field("Line Discount Amount"; LinesDiscountAmount)
            {
                ApplicationArea = Basic;
                Caption = 'Line Discount Amount';
            }
            field(Amount; Rec.Amount)
            {
                ApplicationArea = Basic;
            }
            field(VATAmount; VATAmount)
            {
                ApplicationArea = Basic;
                AutoFormatExpression = Rec."Currency Code";
                AutoFormatType = 1;
                Caption = 'VAT Amount', comment = 'ESP="Importe IVA"';
                Editable = false;
            }
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = Basic;
                AutoFormatExpression = Rec."Currency Code";
                AutoFormatType = 1;
                Caption = 'Total Incl. VAT';
                Editable = false;
            }
        }
    }
    actions
    {
    }
    trigger OnAfterGetCurrRecord()
    begin
        Rec.CalcFields(Rec.Amount, Rec."Amount Including VAT");
        VATAmount:=Rec."Amount Including VAT" - Rec.Amount;
        LinesAmount:=0;
        LinesDiscountAmount:=0;
        rSalesLine.SetRange(rSalesLine."Document Type", Rec."Document Type");
        rSalesLine.SetRange(rSalesLine."Document No.", Rec."No.");
        rSalesLine.FindSet;
        repeat LinesDiscountAmount:=LinesDiscountAmount + rSalesLine."Line Discount Amount";
        until rSalesLine.Next = 0;
        LinesAmount:=Rec.Amount + LinesDiscountAmount;
    end;
    var LinesAmount: Decimal;
    LinesDiscountAmount: Decimal;
    TotalAmount: Decimal;
    TotalDiscount: Decimal;
    VATAmount: Decimal;
    rSalesLine: Record "Sales Line";
}
