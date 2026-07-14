PageExtension 50139 "BBT Posted Purchase Invoice" extends "Posted Purchase Invoice"
{
    layout
    {
        addafter("Buy-from Contact")
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
        }
        addafter("Responsibility Center")
        {
            field("Import No."; Rec."Import No.")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Base DUA"; Rec."Base DUA")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
