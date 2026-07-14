PageExtension 51450 "SGA Location Card" extends "Location Card"
{
    layout
    {
        addafter("Address & Contact")
        {
            group(SGATab)
            {
                Caption = 'SGA', Comment = 'ESP="SGA"';
                Visible = SGAEnable;
                Enabled = SGAEnable;

                field("SGA Enabled"; Rec."SGA Enabled")
                {
                    ApplicationArea = ALL;
                }
                field("SGA Warehouse Code"; Rec."SGA Warehouse Code")
                {
                    ApplicationArea = All;
                }
                field("SGA Quality"; Rec."SGA Quality")
                {
                    ApplicationArea = All;
                }
                field("SGA Fictitious Movement"; Rec."SGA Fictitious Movement")
                {
                    ApplicationArea = All;
                }
                field("SGA Allows Returns"; Rec."SGA Allows Returns")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        SGAEnable: Boolean;
        CuSGAManagement: Codeunit "SGA Management";

    trigger OnOpenPage()
    begin
        SGAEnable := CuSGAManagement.IsSGAEnabled()
    end;
}
