TableExtension 50146 "BBT VAT Posting Setup" extends "VAT Posting Setup"
{
    fields
    {
        field(50000; "EDI - VAT Type"; option)
        {
            Caption = 'EDI - Tipo IVA';
            Description = 'EDI';
            OptionCaption = ' ,IVA,IGI,Exento';
            OptionMembers = " ", VAT, IGI, EXT;
        }
    }
}
