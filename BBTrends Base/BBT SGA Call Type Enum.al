enum 50002 "SGA Call Type"
{
    //>> BBT SGA Extension
    //ObsoleteState = Pending;
    //<<
    Extensible = true;

    value(0; "Bloqueo documentos")
    { }
    value(1; "Insertar producto")
    { }
    value(2; "Gestion pedido compra")
    { }
    value(3; "Recepcion pedido compra")
    { }
    value(4; "Actualizar documento")
    { }
    value(5; "Documento envio")
    { }
    value(6; "Albaran pedido venta")
    { }
    value(7; "Leer entregas expedidas")
    { }
    value(8; "Actualizar entregas expedidas")
    { }
    value(9; "Insertar devolucion venta")
    { }
    value(10; "Leer recepcion devolucion venta")
    { }
    value(11; "Insertar pedido transferencia")
    { }
    value(12; "Leer pedido transferencia")
    { }
    value(13; "Leer ajustes stock")
    { }
    value(14; "Actualizar ajustes stock")
    { }
    value(15; "Leer cuadre inventario stock")
    { }
    value(16; "Leer confirmacion albaran")
    { }
    value(17; "Insertar confirmacion albaran")
    { }
    value(18; "Insertar devolucion compra")
    { }
    value(19; "Leer devolucion compra")
    { }
    value(20; "Leer entrega almacen")
    { }
    value(21; "Leer packing list")
    { }
    value(22; "Leer campos error")
    { }
    value(23; "Leer campos error stock")
    { }
}
