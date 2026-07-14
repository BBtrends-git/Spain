PageExtension 50116 "BBT Sales Quote" extends "Sales Quote"
{
    layout
    {
        addafter(Status)
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
