PageExtension 50234 "BBT Sales Quote Archives" extends "Sales Quote Archives"
{
    layout
    {
        addafter("External Document No.")
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
