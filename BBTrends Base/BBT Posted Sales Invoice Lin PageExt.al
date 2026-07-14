PageExtension 50009 "BBT Posted Sales Invoice Lin" extends "Posted Sales Invoice Lines"
{
    layout
    {
        addafter("No.")
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting Date field.';
            }
            field("Customer Name"; Rec."Customer Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Name field.';
            }
        }
        addafter(Description)
        {
            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = Basic;
            }
        }
        addbefore("Line Discount Amount")
        {
            field("Line Amount"; Rec."Line Amount")
            {
                ApplicationArea = Basic;
            }
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
            field("Service Zone Code"; Rec."Service Zone Code")
            {
                ApplicationArea = Basic;
            }
            field("Ship-to Code"; Rec."Ship-to Code")
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
        rSalesInvoice: Record "Sales Invoice Header";

    trigger OnAfterGetRecord()
    begin
        CurrencyCode := '';
        LineAmountDL := Rec."Amount";
        rSalesInvoice.Reset();
        if rSalesInvoice.Get(Rec."Document No.") then begin
            if rSalesInvoice."Currency Code" <> '' then begin
                CurrencyCode := rSalesInvoice."Currency Code";
                if rSalesInvoice."Currency Factor" <> 0 then
                    LineAmountDL := Round(Rec."Amount" / rSalesInvoice."Currency Factor", 0.01);
            end;
        end;
    end;
}
