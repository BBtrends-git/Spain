table 51450 "SGA Setup"
{
    Caption = 'SGA Management Setup', Comment = 'ESP="Configuración SGA"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            AllowInCustomizations = Never;
            Caption = 'Primary Key';
        }
        field(2; "SGA Enabled"; Boolean)
        {
            Caption = 'SGA Enabled', Comment = 'ESP="SGA Activado"';
        }
        field(3; "Box Unit"; Code[10])
        {
            Caption = 'Box unit', Comment = 'ESP="Unidad de Caja"';
            TableRelation = "Unit of Measure";
        }
        field(4; "Palet Unit"; Code[10])
        {
            Caption = 'Palet Unit', Comment = 'ESP="Unidad de Palet"';
            TableRelation = "Unit of Measure";
        }
        field(5; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name', Comment = 'ESP="Libro Diario Ajustes Producto"';
            TableRelation = "Item Journal Template" where("Page ID" = const(40), Recurring = const(false), Type = const(Item));
        }
        field(6; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name', Comment = 'ESP="Seccion Diario Ajustes Producto"';
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
        field(7; "Inv Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name', Comment = 'ESP="Libro Diario Ajustes Inventario"';
            TableRelation = "Item Journal Template" where("Page ID" = const(392), Recurring = const(false), Type = const("Phys. Inventory"));
        }
        field(8; "Inv Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name', Comment = 'ESP="Seccion Diario Ajustes Inventario"';
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
        field(9; "SGA Document Block Endp"; Text[1024])
        {
            Caption = 'Document Block Endpoint', comment = 'ESP="Bloqueo Documentos Endpoint"';
        }
        field(10; "SGA Insert Item Endp"; Text[1024])
        {
            Caption = 'Insert Item Endpoint', comment = 'ESP="Insertar Producto Endpoint"';
        }
        field(11; "SGA Purch Order Mngmnt Endp"; Text[1024])
        {
            Caption = 'Purchase Order Mngmnt Endpoint', comment = 'ESP="Gestión Pedido Compra Endpoint"';
        }
        field(12; "SGA Purchase Order Recep Endp"; Text[1024])
        {
            Caption = 'Purchase Order Recep. Endpoint', comment = 'ESP="Recepción Pedido Compra Endpoint"';
        }
        field(13; "SGA Update Document Endp"; Text[1024])
        {
            Caption = 'Update Document Endpoint', comment = 'ESP="Actualizar Documento Endpoint"';
        }
        field(14; "SGA Shipment Document Endp"; Text[1024])
        {
            Caption = 'Shipment Document Endpoint', comment = 'ESP="Documento Envio Endpoint"';
        }
        field(15; "SGA Shipment Sales Order Endp"; Text[1024])
        {
            Caption = 'Shipment Shipment Sales Order Endpoint', comment = 'ESP="Albaran Pedido Venta Endpoint"';
        }
        field(16; "SGA Read Exped Shipment Endp"; Text[1024])
        {
            Caption = 'Read Expedition Shipment Endpoint', comment = 'ESP="Leer Entregas Expedidas Endpoint"';
        }
        field(17; "SGA Update Exped shipment Endp"; Text[1024])
        {
            Caption = 'Update Expedition Shipment Endpoint', comment = 'ESP="Actualizar Entregas Expedidas Endpoint"';
        }
        field(18; "SGA Insert SalesReturn Endp"; Text[1024])
        {
            Caption = 'Insert Sales Return Endpoint', comment = 'ESP="Insertar Devolucion Venta Endpoint"';
        }
        field(19; "SGA Read Recp SalesReturn Endp"; Text[1024])
        {
            Caption = 'Read Recep Sales Return Endpoint', comment = 'ESP="Leer Recepcion Devolucion Venta Endpoint"';
        }
        field(20; "SGA Read Transfer Order Endp"; Text[1024])
        {
            Caption = 'Read Transfer Order Endpoint', comment = 'ESP="Leer pedido Transferencia Endpoint"';
        }
        field(21; "SGA Read Stock Adjust Endp"; Text[1024])
        {
            Caption = 'Read Stock Adjust Endpoint', comment = 'ESP="Leer Ajustes Stock Endpoint"';
        }
        field(22; "SGA Update Stock Adjust Endp"; Text[1024])
        {
            Caption = 'Update Stock Adjust Endpoint', comment = 'ESP="Actualizar Ajustes Stock Endpoint"';
        }
        field(23; "SGA Read Shipment Confirm Endp"; Text[1024])
        {
            Caption = 'Read Shipment Confirm Endpoint', comment = 'ESP="Leer Confirmacion Albaran Endpoint"';
        }
        field(24; "SGA Insert Shipm Confirm Endp"; Text[1024])
        {
            Caption = 'Insert Shipment Confirm Endpoint', comment = 'ESP="Insertar Confirmacion Albaran Endpoint"';
        }
        field(25; "SGA Insert Pur Return Ord Endp"; Text[1024])
        {
            Caption = 'Insert Purchase Return Order Endpoint', comment = 'ESP="Insertar Devolucion Compra Endpoint"';
        }
        field(26; "SGA Read Pur Return Order Endp"; Text[1024])
        {
            Caption = 'Read Purchase return Order Endpoint', comment = 'ESP="Leer Devolucion Compra Endpoint"';
        }
        field(27; "SGA Read Location Entry Endp"; Text[1024])
        {
            Caption = 'Read Location Entry Endpoint', comment = 'ESP="Leer Entrega Almacen Endpoint"';
        }
        field(28; "SGA Read Packing List Endp"; Text[1024])
        {
            Caption = 'Read Packing List Endpoint', comment = 'ESP="Leer Packing List Endpoint"';
        }
        field(29; "SGA Read Error Fields Endp"; Text[1024])
        {
            Caption = 'Read Error Fields Endpoint', comment = 'ESP="Leer Campos Error Endpoint"';
        }
        field(30; "SGA Read Err Fields Stock Endp"; Text[1024])
        {
            Caption = 'Read Error Fields Stock Endpoint', comment = 'ESP="Leer Campos Error Stock Endpoint"';
        }
        field(31; "SGA Insert Transfer Order Endp"; Text[1024])
        {
            Caption = 'SGA Insert Transfer Order Endpoint', comment = 'ESP="Insert Pedido Transferencia Endpoint"';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    { }
}