Page 51299 "SGA Lista Bloqueos"
{
    Caption = 'SGA Lista Bloqueos';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "BBT-IT SGA Blocked Documents";
    UsageCategory = Lists;
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Visible = EnableSGA;
                Enabled = EnableSGA;

                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Visible = EnableSGA;
                    Enabled = EnableSGA;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Visible = EnableSGA;
                    Enabled = EnableSGA;
                }
            }
        }
    }

    var
        EnableSGA: Boolean;
        rCompanyInformation: Record "Company Information";

    trigger OnOpenPage()
    begin
        EnableSGA := false;
        if rCompanyInformation.Get() then
            if rCompanyInformation.SGA then
                EnableSGA := true;
        if not EnableSGA then
            CurrPage.Close();
    end;
}