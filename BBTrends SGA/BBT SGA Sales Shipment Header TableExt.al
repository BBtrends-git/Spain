TableExtension 51455 "SGA Sales Shipment Header" extends "Sales Shipment Header"
{
    fields
    {
        field(51460; "SGA Expedition Date"; DateTime)
        {
            Caption = 'SGA Expedition Date', Comment = 'ESP="Fecha Expedicion SGA"';
        }
        field(51461; "SGA Warehouse Delivery No"; Code[20])
        {
            Caption = 'SGA Warehouse Delivery Number', Comment = 'ESP="No. Entrega Almacen SGA"';
        }
    }
}