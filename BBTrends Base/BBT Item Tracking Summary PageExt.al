PageExtension 50206 "BBT Item Tracking Summary" extends "Item Tracking Summary"
{
    layout
    {
        addafter("Selected Quantity")
        {
            field("Cód. OF"; Rec."Cód. OF")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
