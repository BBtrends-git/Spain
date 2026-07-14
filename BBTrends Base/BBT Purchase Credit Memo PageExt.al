PageExtension 50123 "BBT Purchase Credit Memo" extends "Purchase Credit Memo"
{
    layout
    {
        addafter("Buy-from Contact")
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
