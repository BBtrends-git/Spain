PageExtension 50185 "BBT Location Card" extends "Location Card"
{
    layout
    {
        addafter("Cross-Dock Due Date Calc.")
        {
            //>> Extension SGA. Obsoleto
            field(SGA; rec.SGA)
            {
                ApplicationArea = Basic;
                Enabled = SGAENABLE;
                Visible = SGAENABLE;
            }
            field("SGA Whse Code"; rec."SGA Whse Code")
            {
                ApplicationArea = Basic;
                Enabled = SGAENABLE;
                Visible = SGAENABLE;
            }
            field(Calidad; rec.Calidad)
            {
                ApplicationArea = Basic;
                Enabled = SGAENABLE;
                Visible = SGAENABLE;
            }
            field("Movimiento SGA ficticio"; rec."Movimiento SGA ficticio")
            {
                ApplicationArea = Basic;
                Enabled = SGAENABLE;
                Visible = SGAENABLE;
            }
            field("Allows return SGA"; rec."Allows return SGA")
            {
                ApplicationArea = Basic;
                Enabled = SGAENABLE;
                Visible = SGAENABLE;
            }
            //<< Extension SGA. Obsoleto
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
