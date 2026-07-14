enum 50000 "EDI Document Type"
{
    Extensible = true;
    Caption = 'EDI Document Type', comment = 'ESP="EDI Tipo Documento"';

    value(0; " ")
    { }
    value(1; Order)
    {
        Caption = 'Order', comment = 'ESP="Pedido"';
    }
    value(2; Shipment)
    {
        Caption = 'Shipment', comment = 'ESP="Albarán"';
    }
    value(3; Invoice)
    {
        Caption = 'Invoice', comment = 'ESP="Factura"';
    }
    value(4; "Shipment PDF")
    {
        Caption = 'Shipment PDF', comment = 'ESP="PDF Albarán"';
    }
}
