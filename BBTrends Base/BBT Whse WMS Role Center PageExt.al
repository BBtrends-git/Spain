pageextension 50005 "BBT Whse. WMS Role Center" extends "Whse. WMS Role Center"
{
    layout
    {
        addfirst(rolecenter)
        {
            part("Warnings"; "BBT Ship. and Rec. - Warnings")
            {
                Caption = 'Warnings', Comment = 'ESP="Avisos"';
                ApplicationArea = All;
            }
        }
    }
}
