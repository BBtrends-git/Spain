TableExtension 50126 "BBT Sales Invoice Header" extends "Sales Invoice Header"
{
    fields
    {
        field(50000; "Purchase Group"; Code[10])
        {
            Caption = 'Purchase Group';
            Description = '001';
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            ObsoleteState = Pending;
            //TableRelation = "Purchase Group";
            //<<
        }
        field(50001; "Service Zone Code"; Code[10])
        {
            Caption = 'Service Zone Code';
            Description = '002';
            TableRelation = "Service Zone";
        }
        field(50002; "Sales Person Name"; Text[50])
        {
            CalcFormula = lookup("Salesperson/Purchaser".Name where(Code = field("Salesperson Code")));
            Caption = 'Nombre Vendedor';
            Description = '200916';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "Sales Shipment No"; Code[20])
        {
            CalcFormula = lookup("Sales Shipment Header"."No." where("Order No." = field("Order No.")));
            Caption = 'Núm. albarán venta';
            Description = '//04/07/19 TC-006 Mostrar el número de albarán en la factura de venta';
            FieldClass = FlowField;
        }
        field(50011; "Warehose Ship No."; Code[20])
        {
            CalcFormula = lookup("Posted Whse. Shipment Line"."Whse. Shipment No." where("Posted Source Document" = const("Posted Shipment"), "Posted Source No." = field("Sales Shipment No")));
            Caption = 'Warehouse Ship No.';
            Description = '04/07/19 TC-006 Mostrar el número de albarán en la factura de venta';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50012; "EDI - Shipment cost payment"; Option)
        {
            Caption = 'EDI - Método pago costes trans.';
            Description = 'EDI';
            OptionCaption = ' ,DF Definido por el comprador y el proveedor,PC Portes pagados pero cargados al cliente,PP portes pagados';
            OptionMembers = " ",DF,PC,PP;
        }
        field(50013; "EDI - Delivery condition"; Option)
        {
            Caption = 'EDI - Condiciones entrega';
            Description = 'EDI';
            OptionCaption = ' ,PD Recogida por el emisor del pedido,EP Enviada por el receptor del pedido,DDP - Entregado con derecho pagados';
            OptionMembers = " ",PD,EP,DDP;
        }
        field(50014; "EDI - Currency Code"; Code[10])
        {
            Caption = 'EDI - Cód. Moneda';
            Description = 'EDI';
        }
        field(50015; "EDI - Unique due date"; Date)
        {
            Caption = 'EDI - Fecha vto. único';
            Description = 'EDI';
        }
        field(50016; "EDI - Total Amount"; Decimal)
        {
            Caption = 'EDI - Importe total neto';
            Description = 'EDI';
        }
        field(50017; "EDI - Total discount/charges"; Decimal)
        {
            Caption = 'EDI - Importe total dtos./cargos';
            Description = 'EDI';
        }
        field(50018; "EDI - Amount Base"; Decimal)
        {
            Caption = 'EDI - Base imponible';
            Description = 'EDI';
        }
        field(50019; "EDI - Taxes amt."; Decimal)
        {
            Caption = 'EDI - Importe total impuestos';
            Description = 'EDI';
        }
        field(50020; "EDI - Paying amt."; Decimal)
        {
            Caption = 'EDI - Importe a pagar';
            Description = 'EDI';
        }
        field(50021; "EDI - Gross amt."; Decimal)
        {
            Caption = 'EDI - Importe total bruto';
            Description = 'EDI';
        }
        field(50022; "EDI - Comments"; Blob)
        {
            Caption = 'EDI - Observaciones';
            Description = 'EDI';
        }
        field(50023; "EDI - Additional info"; Option)
        {
            Caption = 'EDI - Información adicional';
            Description = 'EDI';
            OptionCaption = ' ,71E Condiciones de compra del grupo,72E Cancelar pedido si no es posible la entrega total en fechas solicitadas,73E Entrega sujeta a autorización final,81E Facturar pero no reabastecer,82E Enviar pero no factura,83E Entregar el pedido entero,X42 Venta online';
            OptionMembers = "","71E","72E","73E","81E","82E","83E","X42";
        }
        field(50024; "EDI - EDI Order"; Boolean)
        {
            Caption = 'EDI - Pedido EDI';
            Description = 'EDI';
        }
        field(50025; "EDI - Additional ref No."; Code[80])
        {
            Caption = 'EDI - Additional ref No.';
            Description = 'EDI';
        }
        field(50026; "EDI - Do not send EDI"; Boolean)
        {
            Caption = 'EDI - No enviar por EDI';
            Description = 'EDI';
        }
        field(50027; "EDI - Document datetime"; DateTime)
        {
            Caption = 'EDI - Fecha/Hora documento';
            Description = 'EDI';
        }
        field(50028; "EDI - Delivery datetime"; DateTime)
        {
            Caption = 'EDI - Fecha/Hora entrega estimada';
            Description = 'EDI';
        }
        field(50029; "EDI - Shipping method"; Option)
        {
            Caption = 'EDI - Modo de transporte';
            Description = 'EDI';
            OptionCaption = ' ,10 Transporte marítimo,20 Transporte ferroviario,30 Transporte por carretera,40 Transporte aéreo,60 Transporte múltiple';
            OptionMembers = " ","10","20","30","40","60";
        }
        field(50030; "EDI - Shipping Agent Id."; Text[13])
        {
            Caption = 'EDI - Id. Transportista';
            Description = 'EDI';
        }
        field(50031; "EDI - Shipping Agent Name"; Text[35])
        {
            Caption = 'EDI - Nombre transportista';
            Description = 'EDI';
        }
        field(50032; "EDI - Vehicle plate"; Text[17])
        {
            Caption = 'EDI - Matrícula vehículo';
            Description = 'EDI';
        }
        field(50033; "EDI - Invoice message function"; Option)
        {
            Caption = 'EDI - Función mensaje fra.';
            Description = 'EDI';
            OptionCaption = ',Copia,Sustitutiva,Transmisión adicional';
            OptionMembers = " ","7","31","5","43";
        }
        field(50034; "EDI - Contract No."; Code[17])
        {
            Caption = 'EDI - Contract No.';
            Description = 'EDI';
        }
        field(50035; "EDI - Order Type"; Option)
        {
            Caption = 'EDI - Order Type';
            Description = 'EDI';
            OptionCaption = ' ,220 Pedido normal,221 Pedido abierto,224 Pedido urgente,226 Pedido parcial,227 Pedido en consigna,22E Propuesta ped. del prov.';
            OptionMembers = " ","220","221","224","226","227","22E";
        }
        field(50036; "EDI - Additional ref type"; Option)
        {
            Caption = 'EDI - Tipo referencia adicional';
            Description = 'EDI';
            OptionCaption = ' ,ATZ Nº Autorización,CR Nº Ref. Cliente,CT Nº Contrato,IP Nº Licencia importación,PD Nº Acuerdo promoción,UC Último número de ref. Cliente,AAN (sin documentación)';
            OptionMembers = " ",ATZ,CR,CT,IP,PD,UC,AAN,ZZZ;
        }
        field(50037; "EDI - Message function"; Option)
        {
            Caption = 'EDI - Función mensaje';
            Description = 'EDI';
            OptionCaption = ' ,6 Confirmación,7 Duplicado,9 Original,16 Propuesta,31 Copia,42 Confirmación,46 Provisional';
            OptionMembers = " ","31","42","46";
        }
        field(50038; "Exclude packaging enforcement"; Boolean)
        {
            Caption = 'Excluir obligatoriedad embalajes';
            Description = 'EDI';
        }
        field(50039; "No. albarán"; Code[20])
        {
            CalcFormula = lookup("Sales Shipment Header"."No." where("Order No." = field("Order No.")));
            Description = 'EDI';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50040; "Cód. Departamento"; Code[20])
        {
            Description = 'EDI';
        }
        field(50041; "Cód. Sucursal"; Code[20])
        {
            Description = 'EDI';
        }
        field(50042; "Sales Shipment No."; Code[20])
        {
            Caption = 'Nº albarán venta';
            Editable = false;
        }
        field(50050; "BBT PL Currency Exchange"; Decimal)
        {
            Caption = 'PL Currency Exchange';
            Editable = false;
        }
        field(50059; "Customer Service No."; Code[20])
        {
            Caption = 'No. servicio cliente';
            Editable = false;
            TableRelation = "Service Header"."No.";
        }
        field(50060; "Order Reference"; Code[35])
        {
            CalcFormula = Lookup("Sales Header"."External Document No." WHERE("Document Type" = CONST(Order), "No." = FIELD("Order No.")));
            Caption = 'Order Reference';
            FieldClass = FlowField;
        }
        field(50099; "PL VAT"; Boolean)
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(50200; "Bill-to Code"; Code[10])
        {
            Caption = 'Bill-to Code';
            TableRelation = "Billing Address".Code WHERE("Customer No." = FIELD("Sell-to Customer No."));

            trigger OnValidate()
            var
                rBillingAddress: Record "Billing Address";
            begin
            end;
        }
    }
}
