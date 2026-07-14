pageextension 50026 "Price List Lines" extends "Price List Lines"
{
    layout
    {
        addafter("Allow Invoice Disc.")
        {
            field("On Promotion"; Rec."On Promotion")
            {
                ApplicationArea = All;
            }
        }
    }
}
