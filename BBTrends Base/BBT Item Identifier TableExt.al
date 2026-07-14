TableExtension 50179 "BBT Item Identifier" extends "Item Identifier"
{
    fields
    {
        field(50000; "Item ID Type"; Option)
        {
            Caption = 'Tipo identificación producto';
            Description = 'EDI';
            OptionCaption = ' ,Unidad de consumo,Unidad de expedición';
            OptionMembers = " ",CU,DU;
        }
        field(50001; "EAN EDI"; Boolean)
        {
            Description = 'EDI';
        }
    }
}
