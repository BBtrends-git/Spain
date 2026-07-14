page 51233 "RMAs Archived Package Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines', Comment = 'ESP="Líneas"';
    DelayedInsert = false;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "RMAs Posted Package Line";
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                field("Posted Package No."; Rec."Posted Package No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Posted No."; Rec."Posted No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Posted Package Line"; Rec."Posted Package Line")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }

                field("Return Resource"; Rec."Return Resource")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Analysis Date"; Rec."Analysis Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Return Order No."; Rec."Return Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("EAN of Unit"; Rec."EAN of Unit")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Transferred Quantity"; Rec."Transferred Quantity")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Adjusted Quantity"; Rec."Adjusted Quantity")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quality; Rec.Quality)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Condition; Rec.Condition)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Lot Number"; Rec."Lot Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Return Reason"; Rec."Return Reason")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Incident; Rec.Incident)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Incident Reason"; Rec."Incident Reason")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    actions
    { }
}