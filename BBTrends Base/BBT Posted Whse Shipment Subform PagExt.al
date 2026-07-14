PageExtension 51151 "BBT Posted Whse. Shipment Subf" extends "Posted Whse. Shipment Subform"
{
    layout
    {
        addbefore(Quantity)
        {
            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = All;
            }
        }
        addlast(Control1)
        {
            field("Posted Source Document"; Rec."Posted Source Document")
            {
                ApplicationArea = All;
            }
            field("Posted Source No."; Rec."Posted Source No.")
            {
                ApplicationArea = All;
            }
        }
    }
}