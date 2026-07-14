pageextension 50018 "BBT Pstd. Sal. Cr. Memo - Upd." extends "Pstd. Sales Cr. Memo - Update"
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
        addlast(Shipping)
        {
            field("Shipment Date"; Rec."Shipment Date")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }
}
