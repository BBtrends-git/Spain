PageExtension 50167 "BBT VAT Posting Setup" extends "VAT Posting Setup"
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
