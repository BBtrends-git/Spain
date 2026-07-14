TableExtension 50124 "BBT Sales Shipment Header" extends "Sales Shipment Header"
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
        field(50002; "Expedition Date SGA"; DateTime)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Caption = 'Expedition Date SGA';
            Description = 'SGA';
        }
        field(50009; "No. entrega almacen"; Code[20])
        {
            Description = 'SGA';
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
            OptionMembers = " ","71E","72E","73E","81E","82E","83E",X42;
        }
        field(50024; "EDI - EDI Order"; Boolean)
        {
            Caption = 'EDI - Pedido EDI';
            Description = 'EDI';
        }
        field(50025; "EDI - Additional ref No."; Code[80])
        {
            Caption = 'EDI - Nº referencia adicional';
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
            OptionCaption = ' ,Duplicado,Copia,Sustitutiva,Transmisión adicional';
            OptionMembers = " ","7","31","5","43";
        }
        field(50034; "EDI - Contract No."; Code[17])
        {
            Caption = 'EDI - Nº Contrato/Acuerdo';
            Description = 'EDI';
        }
        field(50035; "EDI - Order Type"; Option)
        {
            Caption = 'EDI - Tipo pedido';
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
            OptionMembers = " ","6","7","9","16","31","42","46";
        }
        field(50038; "Exclude packaging enforcement"; Boolean)
        {
            Caption = 'Excluir obligatoriedad embalajes';
            Description = 'EDI';
        }
        field(50040; "Cód. Departamento"; Code[20])
        {
            Description = 'EDI';
        }
        field(50041; "Cód. Sucursal"; Code[20])
        {
            Description = 'EDI';
        }
        field(50042; "Sh. Agent - Tracking Type"; Text[30])
        {
            Caption = 'Tipo tracking transportista';
        }
        field(50043; "Sh. Agent - Status"; Text[50])
        {
            Caption = 'Estado transportista';

            trigger OnValidate()
            begin
                CreateCS;
            end;
        }
        field(50044; "Sh. Agent - Tracking Date"; DateTime)
        {
            Caption = 'Fecha tracking transportista';
        }
        field(50045; "Shipping Agent Int. Type"; Option)
        {
            CalcFormula = lookup("Shipping Agent"."Integration Type" where(Code = field("Shipping Agent Code")));
            Caption = 'Tipo integración transportista';
            Editable = false;
            FieldClass = FlowField;
            OptionMembers = " ",Szendex;
        }
        field(50046; "Packaging Lines Count"; Integer)
        {
            CalcFormula = count(Packaging where("Posted Source No." = field("No.")));
            Caption = 'No. líneas embalajes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50047; "Shipping Agent Label"; Blob)
        {
            Caption = 'Etiqueta transportista';
            Subtype = Bitmap;
        }
        field(50048; "Shipment Finished"; Boolean)
        {
            CalcFormula = lookup("Szendex Tracking Status"."Shipment Finished" where(Status = field("Sh. Agent - Status")));
            Caption = 'Expedición terminada';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50059; "Customer Service No."; Code[20])
        {
            Caption = 'No. servicio cliente';
            Editable = false;
            TableRelation = "Customer Service Header"."No.";
        }
        field(50050; "BBT PL Currency Exchange"; Decimal)
        {
            Caption = 'PL Currency Exchange';
            Editable = false;
        }
        field(50060; "Pedido Web/MarketPlace"; Boolean)
        {
        }
        field(50061; "Shipping ECI Label"; Blob)
        {
            Caption = 'Etiqueta ECI Transportista';
        }
        field(50099; "PL VAT"; Boolean)
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(50111; "Total Gross Weight"; Decimal)
        {
            CalcFormula = sum("Sales Shipment Line"."Line Gross Weight" where("Document No." = field("No.")));
            Caption = 'Gross Weight';
            DecimalPlaces = 0 : 6;
            Description = '003';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50112; "Total Net Weight"; Decimal)
        {
            CalcFormula = sum("Sales Shipment Line"."Line Net Weight" where("Document No." = field("No.")));
            Caption = 'Unit Net Weight';
            DecimalPlaces = 0 : 6;
            Description = '003';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50113; "Total Volume"; Decimal)
        {
            CalcFormula = sum("Sales Shipment Line"."Line Volume" where("Document No." = field("No.")));
            Caption = 'Total Volume';
            DecimalPlaces = 0 : 6;
            Description = '003';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50114; "Number of Packages"; Decimal)
        {
            Caption = 'Number of Packages';
            DecimalPlaces = 0 : 0;
            Description = '004';
        }
        field(50115; Reference; Text[100])
        {
            Caption = 'Referencia';
            Description = '005';
        }
        field(50116; "Transport Shipment No."; Code[20])
        {
            Caption = 'Shipment No.';
            Description = '006';
            TableRelation = "Transport Shipment";
        }
        field(50117; "Total Gross Weight (Actual)"; Decimal)
        {
            Caption = 'Gross Weight';
            DecimalPlaces = 0 : 6;
            Description = '007';
            FieldClass = Normal;
        }
        field(50118; "Total Net Weight (Actual)"; Decimal)
        {
            Caption = 'Unit Net Weight';
            DecimalPlaces = 0 : 6;
            Description = '007';
            FieldClass = Normal;
        }
        field(50119; "Total Volume (Actual)"; Decimal)
        {
            Caption = 'Total Volume';
            DecimalPlaces = 0 : 6;
            Description = '007';
            FieldClass = Normal;
        }
        field(50120; "Warehose Ship No."; Code[20])
        {
            CalcFormula = lookup("Posted Whse. Shipment Line"."Whse. Shipment No." where("Posted Source Document" = const("Posted Shipment"), "Posted Source No." = field("No.")));
            Caption = 'Warehouse Ship No.';
            Description = 'SGA';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50121; "Warehose Ship No.2"; Code[20])
        {
            Caption = 'Warehouse Ship No.';
            Description = 'SGA';
            Editable = false;
        }
        field(50122; "Invoiced Quantity"; Decimal)
        {
            CalcFormula = sum("Sales Shipment Line"."Quantity Invoiced" where("Document No." = field("No.")));
            Caption = 'Invoiced Quantity';
            FieldClass = FlowField;
        }
        field(50350; "Request delivery appointment"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Request delivery appointment', comment = 'ESP="Pedir cita entrega"';
        }
        field(50380; "Logistics conditions"; Text[250])
        {
            Caption = 'Logistics conditions', comment = 'ESP="Condiciones logísticas"';
        }
        field(51110; "Printed Label"; Boolean)
        {
            Caption = 'Printed Label', Comment = 'ESP="Etiqueta Impresa"';
            Enabled = true;
            Editable = true;
            InitValue = false;
        }
        field(51111; "Tracking ECI"; Option)
        {
            Caption = 'Tracking ECI', Comment = 'ESP="Tracking ECI"';
            Enabled = true;
            Editable = true;
            InitValue = " ";

            OptionMembers = " ","ECI.ENV","ECI.ENT";
            OptionCaption = ' ,ECI.ENV,ECI.ENT', Comment = 'ESP=" ,ECI.ENV,ECI.ENT"';
        }
        field(51140; "Shipping Via Agent"; Text[20])
        {
            Caption = 'Shipping Via Agent', Comment = 'ESP="Transporte Via"';
            Enabled = true;
            Editable = true;
        }
        field(51141; "Shipping Via Reference"; Text[50])
        {
            Caption = 'Shipping Via Reference', Comment = 'ESP="Referencia Via"';
            Enabled = true;
            Editable = true;
        }
    }
    keys
    {
        key(NewKey1; "Shipping Agent Code", "Posting Date")
        { }
        key(NewKey2; "Transport Shipment No.")
        { }
    }
    procedure OpenPackaging()
    var
        Packaging: Record Packaging;
        PackagingsList: Page "Packagings List";
    begin
        if Rec."Exclude packaging enforcement" then Error('El documento está marcado para no contemplar la gestión de embalajes');
        Packaging.Reset;
        Packaging.SetRange("Posted Source Type", Database::"Sales Shipment Line");
        Packaging.SetRange("Posted Source No.", Rec."No.");
        if not Packaging.FindSet then Message('No se han encontrado embalajes relacionados');
        Clear(PackagingsList);
        PackagingsList.SetSource(DATABASE::"Sales Shipment Line", rec."No.", 0);
        PackagingsList.SetTableview(Packaging);
        PackagingsList.RunModal;
    end;

    local procedure CreateCS()
    var
        SzendexTrackingStatus: Record "Szendex Tracking Status";
        CustomerServiceHeader: Record "Customer Service Header";
    begin
        if Rec."Sh. Agent - Status" = '' then exit;
        if Rec."Order No." = '' then exit;
        SzendexTrackingStatus.Reset;
        SzendexTrackingStatus.SetRange(Status, Rec."Sh. Agent - Status");
        SzendexTrackingStatus.FindSet;
        if SzendexTrackingStatus."Reason Code" <> '' then begin
            CustomerServiceHeader.Init;
            CustomerServiceHeader.Validate(Status, CustomerServiceHeader.Status::Started);
            CustomerServiceHeader.Validate("Communication Method", CustomerServiceHeader."communication method"::Transporte);
            CustomerServiceHeader.Insert(true);
            CustomerServiceHeader.Validate("User ID", UserId);
            CustomerServiceHeader.Validate("Service Datetime", Rec."Sh. Agent - Tracking Date");
            CustomerServiceHeader.Validate("Reason Code", SzendexTrackingStatus."Reason Code");
            CustomerServiceHeader.Validate("From NAV Doc Type", CustomerServiceHeader."from nav doc type"::Order);
            CustomerServiceHeader.Validate("From NAV Doc. No.", Rec."Order No.");
            CustomerServiceHeader.Validate("External Document No.", Rec."External Document No.");
            CustomerServiceHeader.SetComment('Incidencia transporte Szendex ' + Format(Rec."Sh. Agent - Tracking Date") + ': ' + Rec."Sh. Agent - Status");
            CustomerServiceHeader.Modify(true);
        end;
    end;
}
