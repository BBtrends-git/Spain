Page 50066 "EDI Directory Assignament"
{
    Caption = 'EDI - Directory Assignament', Comment = 'ESP = "Asignación Directorio EDI"';
    PageType = List;
    SourceTable = "EDI Directory Assignament";
    UsageCategory = Documents;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("DESADV Folder"; rec."DESADV Folder")
                {
                    ApplicationArea = All;
                }
                field("INVOIC Folder"; rec."INVOIC Folder")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1100234006; Notes)
            {
                Visible = false;
            }
            systempart(Control1100234005; Links)
            {
                Visible = false;
            }
        }
    }
    actions
    { }
}