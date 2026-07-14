PageExtension 51467 "SGA Sales Return Order List" extends "Sales Return Order List"
{
    layout
    {
        addafter(Status)
        {
            field("SGA Status"; Rec."SGA Status")
            {
                ApplicationArea = All;
                Visible = SGAEnable;
                Enabled = SGAEnable;
            }
        }
    }
    var
        cuSGAManagement: Codeunit "SGA Management";
        SGAEnable: Boolean;

    trigger OnOpenPage()
    begin
        SGAEnable := cuSGAManagement.IsSGAEnabled();
    end;
}