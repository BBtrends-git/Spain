PageExtension 50107 "BBT Location List" extends "Location List"
{
    layout
    {
        addafter(Name)
        {
            field(SGA; rec.SGA)
            {
                ApplicationArea = All;
                Visible = SGAENABLE;
            }
            field("SGA Whse Code"; rec."SGA Whse Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }
    var
        SGAENABLE: Boolean;

    trigger OnOpenPage()
    begin
        EnabledSGA;
    end;

    local procedure EnabledSGA()
    var
        _InfoCompany: Record "Company Information";
    begin
        _InfoCompany.Get;
        SGAENABLE := _InfoCompany.SGA;
    end;
}
