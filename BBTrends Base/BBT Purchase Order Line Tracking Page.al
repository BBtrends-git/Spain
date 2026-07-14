Page 51118 "BBT Purchase Line Tracking"
{
    Caption = 'Shipping Tracking URL', Comment = 'ESP="URL Seguimiento"';
    PageType = StandardDialog;
    SourceTable = "Purchase Line";
    ApplicationArea = all;
    Permissions = tableData "Purchase Line" = RM;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = true;
    Editable = true;

    layout
    {
        area(content)
        {
            group(general)
            {
                ShowCaption = false;
                field("Shipping Tracking URL"; Rec."Shipping Tracking URL")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}