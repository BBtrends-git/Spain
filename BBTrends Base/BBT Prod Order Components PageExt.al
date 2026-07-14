PageExtension 50259 "BBT Prod. Order Components" extends "Prod. Order Components"
{
    layout
    {
        addfirst(Control1)
        {
            field("Prod. Order No."; Rec."Prod. Order No.")
            {
                ApplicationArea = Basic;
            }
            field("Prod. Order Line No."; Rec."Prod. Order Line No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
