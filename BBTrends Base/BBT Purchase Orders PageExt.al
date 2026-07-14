PageExtension 50126 "BBT Purchase Orders" extends "Purchase Orders"
{
    layout
    {
        addafter("Line Discount %")
        {
            field("Prod. Order No."; Rec."Prod. Order No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
