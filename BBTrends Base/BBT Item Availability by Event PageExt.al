PageExtension 50182 "BBT Item Availability by Event" extends "Item Availability by Event"
{
    layout
    {
        addafter("Period Start")
        {
            field("Description  Item No."; Rec."Description  Item No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
