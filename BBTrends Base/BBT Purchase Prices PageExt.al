PageExtension 50214 "BBT Purchase Prices" extends "Purchase Prices"
{
    layout
    {
        addafter("Vendor No.")
        {
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Item No.")
        {
            field("Item Description"; Rec."Item Description")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
