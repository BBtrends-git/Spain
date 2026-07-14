PageExtension 50168 "BBT VAT Posting Setup Card" extends "VAT Posting Setup Card"
{
    layout
    {
        addafter("Tax Category")
        {
            field("EDI - VAT Type"; Rec."EDI - VAT Type")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
