PageExtension 51456 "SGA Sales Order" extends "Sales Order"
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
        CuSGAManagement: Codeunit "SGA Management";
        SGAEnable: Boolean;

    trigger OnOpenPage()
    begin
        SGAEnable := CuSGAManagement.IsSGAEnabled();
    end;
}