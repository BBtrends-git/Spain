pageextension 50017 "BBT Posted Sales Inv. - Update" extends "Posted Sales Invoice - Update"
{
    layout
    {
        addafter(General)
        {
            group("Shipping Details")
            {
                Caption = 'Shipping Details', Comment = 'ESP="Detalle Envío"';

                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = All;
                    Visible = true;
                    Editable = true;
                }
                field("Package Tracking No."; Rec."Package Tracking No.")
                {
                    ApplicationArea = All;
                    Visible = true;
                    Editable = true;
                }
            }
        }
        addlast("Invoice Details")
        {
            field("Do Not Send To SII"; Rec."Do Not Send To SII")
            {
                ApplicationArea = All;
            }
        }
    }
}
