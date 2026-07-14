TableExtension 50122 "BBT Comment Line" extends "Comment Line"
{
    fields
    {
        field(50000; "Comment type"; Option)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Caption = 'Comment type';
            Description = 'SGA';
            OptionCaption = ' ,Ship,Manofacturing,Invoice';
            OptionMembers = " ",Ship,Manofacturing,Invoice;
        }
        field(50001; Desactivado; Boolean)
        { }
    }
}
