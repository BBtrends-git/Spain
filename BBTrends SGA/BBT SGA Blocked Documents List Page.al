Page 51451 "SGA List Blocked Documents"
{
    Caption = 'SGA List Blocked Documents', Comment = 'SGA Lista de Bloqueos';
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "SGA Blocked Documents";
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("SGA Document Type"; Rec."SGA Document Type")
                {
                    ApplicationArea = All;
                }
                field("SGA Document No."; Rec."SGA Document No.")
                {
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }
    var
        SGAEnabled: Boolean;
        cuSGAManagement: Codeunit "SGA Management";

    trigger OnOpenPage()
    begin
        SGAEnabled := cuSGAManagement.IsSGAEnabled();
        if not SGAEnabled then
            CurrPage.Close();
    end;
}