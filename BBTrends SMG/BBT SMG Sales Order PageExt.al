PageExtension 51302 "SMG Sales Order" extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            field("SMG Blocked for Short Margin"; Rec."SMG Blocked for Short Margin")
            {
                ApplicationArea = All;
                Enabled = SMGEnabled;
                Visible = SMGEnabled;
            }
            field("SMG Total Margin %"; Rec."SMG Total Margin %")
            {
                ApplicationArea = All;
                Enabled = SMGEnabled;
                Visible = False;
            }
        }
    }

    var
        cuSMGManagement: Codeunit "SMG Management";
        SMGEnabled: Boolean;

    trigger OnOpenPage()
    begin
        SMGEnabled := cuSMGManagement.IsMarginEnabled;
    end;
}