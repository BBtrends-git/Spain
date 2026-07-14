PageExtension 50015 "BBT Transfer Orders" extends "Transfer Orders"
{
    layout
    {
        addafter("No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the External Document No. field.';
            }
            field("Status SGA"; Rec."Status SGA")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Status SGA field.';
                Visible = EnabledSGA;
                Enabled = EnabledSGA;
            }
        }
    }
    var
        rCompanyInformation: Record "Company Information";
        EnabledSGA: Boolean;

    trigger OnOpenPage()
    begin
        rCompanyInformation.Get();
        EnabledSGA := rCompanyInformation.SGA;
    end;
}
