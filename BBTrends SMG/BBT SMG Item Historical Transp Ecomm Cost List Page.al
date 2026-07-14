page 51310 "SMG Hist Transp Ecom Cost List"
{
    Caption = 'SMG Hist Transport Ecomm Cost List', Comment = 'ESP="Hist Coste Transporte Ecomm"';

    DataCaptionFields = "Item No.";
    Editable = true;
    PageType = List;
    SourceTable = "SMG Historical Values Margin";
    SourceTableView = where(Type = filter("Ecomm Transport Cost"));
    DelayedInsert = true;
    SaveValues = true;
    ModifyAllowed = true;
    DeleteAllowed = true;
    InsertAllowed = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("ItemNo"; Rec."Item No.")
                {
                    ApplicationArea = All;
                    //Visible = false;
                    Editable = false;
                }
                field(CostAmount; Rec."Cost Amount")
                {
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    { }

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Starting Date", "Ending Date");
        Rec.Ascending(true);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.Type::"Ecomm Transport Cost";
    end;
}