PageExtension 50211 "BBT Purchase Return Order" extends "Purchase Return Order"
{
    layout
    {
        addafter("Corrected Invoice No.")
        {
            field("Posting Description"; Rec."Posting Description")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Pay-to County")
        {
            field("Due Date"; Rec."Due Date")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
