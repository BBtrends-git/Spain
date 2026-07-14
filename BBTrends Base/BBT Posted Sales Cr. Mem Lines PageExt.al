PageExtension 50135 "BBT Posted Sales Cr. Mem Lines" extends "Posted Sales Credit Memo Lines"
{
    layout
    {
        addfirst(Control1)
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting Date field.';
            }
        }
        addafter("Sell-to Customer No.")
        {
            field("Customer Name"; Rec."Customer Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Name field.';
            }
        }
        modify("Amount Including VAT")
        {
            Visible = false;
        }
        addafter(Description)
        {
            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Amount Including VAT")
        {
            field(CurrencyCode; CurrencyCode)
            {
                ApplicationArea = Basic;
                Caption = 'Currency Code', Comment = 'ESP="Divisa"';
                Visible = true;
            }
            field(LineAmountDL; LineAmountDL)
            {
                ApplicationArea = Basic;
                Caption = 'Line Amount DL', Comment = 'ESP="Importe línea (DL)"';
                Visible = true;
            }
        }
        addafter("Line Discount %")
        {
            field("Service Zone Code"; Rec."Service Zone Code")
            {
                ApplicationArea = Basic;
            }
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
    }
    var
        CurrencyCode: Code[10];
        LineAmountDL: Decimal;
        rSalesCrMemo: Record "Sales Cr.Memo Header";

    trigger OnAfterGetRecord()
    begin
        CurrencyCode := '';
        LineAmountDL := Rec."Amount";
        rSalesCrMemo.Reset();
        if rSalesCrMemo.Get(Rec."Document No.") then begin
            if rSalesCrMemo."Currency Code" <> '' then begin
                CurrencyCode := rSalesCrMemo."Currency Code";
                if rSalesCrMemo."Currency Factor" <> 0 then
                    LineAmountDL := Round(Rec."Amount" / rSalesCrMemo."Currency Factor", 0.01);
            end;
        end;
    end;
}
