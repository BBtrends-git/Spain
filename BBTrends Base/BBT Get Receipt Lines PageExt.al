PageExtension 50186 "BBT Get Receipt Lines" extends "Get Receipt Lines"
{
    layout
    {
        modify("Qty. Rcd. Not Invoiced")
        {
            Editable = false;
        }
        addafter("No.")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
