page 51215 "RMAs Stock Package Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines', Comment = 'ESP="Líneas"';
    DelayedInsert = false;
    LinksAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "RMAs Stock Package Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                field("Package Line"; Rec."Package Line")
                {
                    ApplicationArea = All;
                    Visible = false;
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
            }
        }
    }
    actions
    { }
}