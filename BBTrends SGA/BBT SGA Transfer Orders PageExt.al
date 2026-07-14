PageExtension 51462 "SGA Transfer Orders" extends "Transfer Orders"
{
    layout
    {
        addafter(Status)
        {
            field("SGA Status"; Rec."SGA Status")
            {
                ApplicationArea = All;
                Visible = SGAEnabled;
                Enabled = SGAEnabled;
            }
        }
    }
    var
        cuSGAManagement: Codeunit "SGA Management";
        SGAEnabled: Boolean;

    trigger OnOpenPage()
    begin
        SGAEnabled := cuSGAManagement.IsSGAEnabled();
    end;
}