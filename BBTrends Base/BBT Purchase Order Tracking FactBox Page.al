page 51117 "BBT Purchase Tracking Factbox"
{
    Caption = 'Shipping Tracking URL', Comment = 'ESP="URL Seguimiento"';

    PageType = CardPart;
    UsageCategory = None;
    ApplicationArea = All;
    SourceTable = "Purchase Line";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    Editable = true;

    layout
    {
        area(Content)
        {
            field("Shipping Tracking URL"; Rec."Shipping Tracking URL")
            {
                ShowCaption = false;
                ApplicationArea = All;
                //Caption = 'Shipping Tracking URL', Comment = 'ESP="URL Seguimiento"';
                ExtendedDatatype = URL;
                Editable = false;
                //AssistEdit = true;
                Style = StandardAccent;

                trigger OnAssistEdit()
                var
                    rPurchaseLine: Record "Purchase Line";
                begin
                    rPurchaseLine.SetRange("Document Type", Rec."Document Type");
                    rPurchaseLine.SetRange("Document No.", Rec."Document No.");
                    rPurchaseLine.SetRange("Line No.", Rec."Line No.");
                    if rPurchaseLine.FindFirst() then
                        Page.RunModal(Page::"BBT Purchase Line Tracking", rPurchaseLine);

                    CurrPage.Update(false);
                end;

                trigger OnDrillDown()
                begin
                    if Rec."Shipping Tracking URL" <> '' then
                        Hyperlink(Rec."Shipping Tracking URL");
                end;

                /*
                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
                */
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(OpenTracking)
            {
                ApplicationArea = All;
                Caption = 'Shipping Tracking', Comment = 'ESP="Seguimiento"';
                Image = Track;
                Enabled = (Rec."Shipping Tracking URL" <> '');

                trigger OnAction()
                begin
                    if Rec."Shipping Tracking URL" <> '' then
                        Hyperlink(Rec."Shipping Tracking URL");
                end;
            }
        }
    }
}