PageExtension 50179 "BBT Sales Quote Archive" extends "Sales Quote Archive"
{
    layout
    {
        addafter("Responsibility Center")
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
