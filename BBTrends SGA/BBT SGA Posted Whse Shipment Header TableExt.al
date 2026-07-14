TableExtension 51462 "SGA Posted Whse Ship Header" extends "Posted Whse. Shipment Header"
{
    fields
    {
        field(51458; "SGA Warehouse Delivery Number"; Code[20])
        {
            Caption = 'Warehouse Delivery Number', Comment = 'ESP="No. Entrega Almacen"';
            Editable = false;
        }
    }
}