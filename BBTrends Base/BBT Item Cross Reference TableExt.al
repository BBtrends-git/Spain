TableExtension 50161 "BBT Item Cross Reference" extends "Item Reference"
{
    fields
    {
        field(50000; "Item ID Type"; Option)
        {
            Caption = 'Tipo identificación producto';
            OptionCaption = ' ,Unidad de consumo,Unidad de expedición';
            OptionMembers = " ",CU,DU;
        }
        field(50001; "EAN EDI"; Boolean)
        {
            Description = 'EDI';
        }
    }
}
