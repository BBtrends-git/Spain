PageExtension 50258 "BBT Prod. Order Routing" extends "Prod. Order Routing"
{
    layout
    {
        modify("Location Code")
        {
            Editable = true;
        }
        modify("From-Production Bin Code")
        {
            Visible = false;
        }
        addafter("No.")
        {
            field("Input Quantity"; Rec."Input Quantity")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
