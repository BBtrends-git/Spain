pageextension 50016 "BBT Post. Purch. Inv. - Update" extends "Posted Purch. Invoice - Update"
{
    layout
    {
        addlast(General)
        {
            field("Document Date"; Rec."Document Date")
            {
                ApplicationArea = All;
                Visible = false;
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
