page 51210 "RMAs Return Info Faxbox"
{
    Caption = 'Sales Return', Comment = 'ESP="Devolución Ventas"';
    Editable = false;
    PageType = CardPart;
    SourceTable = "Sales Header";
    UsageCategory = None;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;

                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = all;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = all;
                }
                field("Your Reference"; Rec."Your Reference")
                {
                    ApplicationArea = all;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = all;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}