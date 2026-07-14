page 51227 "RMAs Item Identifiers Subform"
{
    Caption = '';
    DataCaptionFields = "Code", "Item No.";
    PageType = ListPart;
    SourceTable = "Item Identifier";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    Caption = 'Code', Comment = 'ESP="EAN"';
                    ApplicationArea = All;
                }
            }
        }
    }
}