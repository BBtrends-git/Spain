pageextension 50019 "BBT Post. Purch.Cr.Memo - Upd." extends "Posted Purch. Cr.Memo - Update"
{
    layout
    {
        addlast("Invoice Details")
        {
            group("SII Information")
            {
                Caption = 'SII Information', comment = 'ESP="Información SII"';

                field("Do Not Send To SII"; Rec."Do Not Send To SII")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
