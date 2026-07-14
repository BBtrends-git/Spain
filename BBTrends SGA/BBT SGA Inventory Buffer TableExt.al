TableExtension 51463 "SGA Inventory Buffer" extends "Inventory Buffer"
{
    fields
    {
        field(51450; "SGA Delivery Number"; Code[20])
        {
            Caption = 'SGA Delivery Number', Comment = 'ESP="No. Entrega Almacén SGA"';
        }
        field(51451; "SGA Date Registration"; Code[25])
        {
            Caption = 'SGA Date Registration', Comment = 'ESP="Fecha Registro SGA"';
        }
    }
}
