PageExtension 50205 "BBT Service Zones" extends "Service Zones"
{
    layout
    {
        addafter(Description)
        {
            field("Salesperson Code"; Rec."Salesperson Code")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
