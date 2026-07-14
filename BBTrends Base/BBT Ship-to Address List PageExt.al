PageExtension 50154 "BBT Ship-to Address List" extends "Ship-to Address List"
{
    layout
    {
        addafter("Phone No.")
        {
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Country/Region Code")
        {
            field("EDI ID"; Rec."EDI ID")
            {
                ApplicationArea = Basic, Suite;
                Visible = true;
            }
        }
    }
}
