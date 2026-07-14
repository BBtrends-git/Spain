PageExtension 50171 "BBT Purchase Lines" extends "Purchase Lines"
{
    layout
    {
        addafter("Line Amount")
        {
            field("Prod. Order No."; Rec."Prod. Order No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
