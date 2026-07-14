TableExtension 50113 "BBT Sales Header" extends "Sales Header"
{
    fields
    {
        modify("Bill-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                rlCustomer: Record Customer;
            begin
                if Rec."Document Type" in [Rec."Document Type"::"Credit Memo", Rec."Document Type"::"Return Order"] then
                    if rlCustomer.Get(Rec."Bill-to Customer No.") then
                        if rlCustomer."SMG Customer Type" = 'ECOMMERCE' then
                            Rec."Cr. Memo Type" := Rec."Cr. Memo Type"::"R5 Corrected Invoice in Simplified Invoices"
                        else
                            Rec."Cr. Memo Type" := Rec."Cr. Memo Type"::"R1 Corrected Invoice";
            end;
        }
        modify("Bill-to City")
        {
            TableRelation = "Post Code".City;
        }
        modify("Ship-to City")
        {
            TableRelation = "Post Code".City;
        }
        modify("Sell-to City")
        {
            TableRelation = "Post Code".City;
        }
        modify("Bill-to Post Code")
        {
            TableRelation = "Post Code";
        }
        modify("Sell-to Post Code")
        {
            TableRelation = "Post Code";
        }
        modify("Ship-to Post Code")
        {
            TableRelation = "Post Code";
        }
        modify(Shipped)
        {
            Caption = 'Shipped';
        }
        field(50000; "Purchase Group"; Code[10])
        {
            Caption = 'Purchase Group';
            Description = '001';
            //TableRelation = "SMG Purchase Group";
            TableRelation = "SMG Customer Classification".Code where(Type = const("Purchasing Group"));
        }
        field(50001; "Service Zone Code"; Code[10])
        {
            Caption = 'Service Zone Code';
            Description = '005';
            TableRelation = "Service Zone";
        }
        field(50005; "Status SGA"; Option)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Caption = 'Status SGA';
            Description = 'SGA';
            Editable = false;
            OptionCaption = ' ,SGA Sent,SGA Locked', Comment = 'ESP=" ,Enviado SGA,Bloqueado SGA"';
            OptionMembers = " ","Enviado SGA","Bloqueado SGA";
        }
        field(50006; "Grabado SGA"; DateTime)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Description = 'SGA';
            Editable = false;
        }
        field(50007; "Leido SGA"; DateTime)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Description = 'SGA';
            Editable = false;
        }
        field(50008; ModificadoSGA; Boolean)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Description = 'SGA';
            Editable = false;
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
            OptionCaption = ' ,71E Condiciones de compra del grupo,72E Cancelar pedido si no es posible la entrega total en fechas solicitadas,73E Entrega sujeta a autorización final,81E Facturar pero no reabastecer,82E Enviar pero no factura,83E Entregar el pedido entero,X42 Venta online,X41 VPR,X44 Pedido suma,X45 PP1,X46,PP2,X17 Pedido para Almacenar';
            OptionMembers = " ","71E","72E","73E","81E","82E","83E",X42,X41,X44,X45,X46,PP2,X17;
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

            trigger OnValidate()
            var
                Packaging: Record Packaging;
            begin
                if Rec."Exclude packaging enforcement" then begin
                    Packaging.Reset;
                    Packaging.SetRange("Source Type", Database::"Sales Line");
                    Packaging.SetRange("Source No.", Rec."No.");
                    if Packaging.FindSet then Error('Debe eliminar los embalajes existentes antes de continuar');
                end;
            end;
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
            TableRelation = "Sales Shipment Header"."Sell-to Customer No.";
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
            TableRelation = "Customer Service Header"."No.";
        }
        field(50060; "Pedido Web/MarketPlace"; Boolean)
        {
        }
        field(50086; "Blocked for Short Margin"; Boolean)
        {
            ObsoleteState = Pending;
            Caption = 'Bloqueado por margen insuficiente';
            Editable = false;
        }
        field(50099; "PL VAT"; Boolean)
        {
            Caption = 'VAT Bus. Posting Group';
        }
        field(50101; "Delivery Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(50114; "Number of Packages"; Decimal)
        {
            Caption = 'Number of Packages';
            DecimalPlaces = 0 : 6;
            Description = '003';
            FieldClass = Normal;
        }
        field(50115; Reference; Text[100])
        {
            Caption = 'Referencia';
            Description = '004';
        }
        field(50200; "Bill-to Code"; Code[10])
        {
            Caption = 'Bill-to Code';
            TableRelation = "Billing Address".Code where("Customer No." = field("Sell-to Customer No."));

            trigger OnValidate()
            var
                rBillingAddress: Record "Billing Address";
            begin
                // FHS
                if Rec."Bill-to Code" <> '' then begin
                    rBillingAddress.Reset();
                    rBillingAddress.SetRange("Customer No.", Rec."Sell-to Customer No.");
                    rBillingAddress.SetRange(Code, Rec."Bill-to Code");
                    if rBillingAddress.FindSet() then begin
                        Rec."Bill-to Name" := rBillingAddress.Name;
                        Rec."Bill-to Name 2" := rBillingAddress."Name 2";
                        Rec."Bill-to Address" := rBillingAddress.Address;
                        Rec."Bill-to Address 2" := rBillingAddress."Address 2";
                        Rec."Bill-to City" := rBillingAddress.City;
                        Rec."Bill-to Post Code" := rBillingAddress."Post Code";
                        Rec."Bill-to County" := rBillingAddress.County;
                        Rec."Bill-to Country/Region Code" := rBillingAddress."Country/Region Code";
                        if rBillingAddress."VAT Bus. Posting Group" <> '' then Rec.Validate("VAT Bus. Posting Group", rBillingAddress."VAT Bus. Posting Group");
                    end;
                end
                else begin
                    Cust.Get(Rec."Bill-to Customer No.");
                    Rec."Bill-to Customer Templ. Code" := '';
                    Rec."Bill-to Name" := Cust.Name;
                    Rec."Bill-to Name 2" := Cust."Name 2";
                    Rec."Bill-to Address" := Cust.Address;
                    Rec."Bill-to Address 2" := Cust."Address 2";
                    Rec."Bill-to City" := Cust.City;
                    Rec."Bill-to Post Code" := Cust."Post Code";
                    Rec."Bill-to County" := Cust.County;
                    Rec."Bill-to Country/Region Code" := Cust."Country/Region Code";
                end;
                // FIN FHS
            end;
        }
        field(50201; "DIR Code"; Boolean)
        {
            ObsoleteState = Pending;        // PRECINTIA 
            Caption = 'Dir Code';
        }
        field(50300; "Send TBAI"; Boolean)
        {
            ObsoleteState = Pending;        // BBT 01/07/2025 
            Caption = 'Enviar TBAI';
            Description = 'TBAI';
        }
        field(50301; "Request delivery appointment"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Request delivery appointment', comment = 'ESP="Pedir cita entrega"';
        }
        field(50360; "Margin %"; Decimal)
        {
            Caption = 'Margin %', comment = 'ESP="% Margen"';
        }
        field(50370; "Fecha ETD PI"; Date)
        {
            //Aviso emisión LC y emisión LC            
            trigger OnValidate()
            var
                PaymentTerms: Record "Payment Terms";
            begin
                Clear("Fecha vencimiento ETD PI");
                if PaymentTerms.Get(Rec."Payment Terms Code") then begin
                    "Fecha vencimiento ETD PI" := CalcDate(PaymentTerms."Due Date Calculation", "Fecha ETD PI");
                end;
            end;
        }
        field(50371; "Fecha vencimiento ETD PI"; Date)
        {
            //Aviso emisión LC y emisión LC            
            Editable = false;
        }
        field(50380; "Logistics conditions"; Text[250])
        {
            Caption = 'Logistics conditions', comment = 'ESP="Condiciones logísticas"';
        }
        field(51116; "EDI - Calificador Referencia 1"; Text[3])
        {
            Caption = 'Reference Qualifier 1', Comment = 'ESP="Calificador Referencia 1"';
            Enabled = true;
            Editable = true;
            Description = 'EDI';
        }
        field(51117; "EDI - Referencia 1"; Text[35])
        {
            Caption = 'Reference 1', Comment = 'ESP="Referencia 1"';
            Enabled = true;
            Editable = true;
            Description = 'EDI';
        }
        field(51118; "EDI - Calificador Referencia 2"; Text[3])
        {
            Caption = 'Reference Qualifier 2', Comment = 'ESP="Calificador Referencia 2"';
            Enabled = true;
            Editable = true;
            Description = 'EDI';
        }
        field(51119; "EDI - Referencia 2"; Text[35])
        {
            Caption = 'Reference 2', Comment = 'ESP="Referencia 2"';
            Enabled = true;
            Editable = true;
            Description = 'EDI';
        }
    }

    procedure UpdateAllLineCommission(NewSalespersonCode: Code[10]; OldSalespersonCode: Code[10])
    var
        Salesperson: Record "Salesperson/Purchaser";
        CommissionPercent: Decimal;
        SalesLinesItemExist: Boolean;
        SalesLine: Record "Sales Line";
    begin
        // - 002
        if NewSalespersonCode = OldSalespersonCode then exit;
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if not SalesLine.FindSet then exit;
        if not HideValidationDialog and GuiAllowed then if not Confirm(UpdateComQst) then exit;
        CommissionPercent := 0;
        if Salesperson.Get(NewSalespersonCode) then CommissionPercent := Salesperson."Commission %";
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.LockTable;
        if SalesLine.FindSet then begin
            repeat
                SalesLine.Validate("SMG Commission %", CommissionPercent);
                SalesLine.Modify;
            until SalesLine.Next = 0;
            Commit;
        end;
        // + 002
    end;

    procedure MeterComentariosEnvio()
    var
        _LinComentarios: Record "Comment Line";
        _LinComentVenta: Record "Sales Comment Line";
        _NumLineaComent: Integer;
    begin
        // SGA
        _LinComentVenta.Reset;
        _LinComentVenta.SetRange("Document Type", _LinComentVenta."document type"::Order);
        _LinComentVenta.SetRange("No.", Rec."No.");
        _LinComentVenta.SetRange("Comment type", _LinComentVenta."comment type"::Ship);
        _LinComentVenta.DeleteAll;
        _LinComentVenta.Reset;
        _LinComentVenta.SetRange("Document Type", _LinComentVenta."document type"::Order);
        _LinComentVenta.SetRange("No.", Rec."No.");
        _LinComentVenta.SetRange("Document Line No.", 0);
        if _LinComentVenta.FindLast then
            _NumLineaComent := _LinComentVenta."Line No."
        else
            _NumLineaComent := 0;
        _LinComentarios.SetRange("Table Name", _LinComentarios."table name"::Customer);
        _LinComentarios.SetRange("No.", Rec."No.");
        _LinComentarios.SetRange("Comment type", _LinComentarios."comment type"::Ship);
        if _LinComentarios.FindSet then
            repeat
                _NumLineaComent += 10000;
                _LinComentVenta.Init;
                _LinComentVenta."Document Type" := _LinComentVenta."document type"::Order;
                _LinComentVenta."No." := Rec."No.";
                _LinComentVenta."Document Line No." := 0;
                _LinComentVenta."Line No." := _NumLineaComent;
                _LinComentVenta.Date := _LinComentarios.Date;
                _LinComentVenta.Code := _LinComentarios.Code;
                _LinComentVenta.Comment := _LinComentarios.Comment;
                _LinComentVenta."Comment type" := _LinComentarios."Comment type";
                _LinComentVenta.Insert;
            until _LinComentarios.Next = 0;
    end;


    procedure IsCreditDocType2(): Boolean
    begin
        exit(Rec."Document Type" in [Rec."document type"::"Return Order", Rec."document type"::"Credit Memo"]);
    end;

    procedure OpenPackaging()
    var
        SalesLine: Record "Sales Line";
        Packaging: Record Packaging;
        PackagingsList: Page "Packagings List";
    begin
        if Rec.IsCreditDocType2 then exit;
        if Rec."Exclude packaging enforcement" then Error('El documento está marcado para no contemplar la gestión de embalajes');
        // SalesLine.RESET;
        // SalesLine.SETRANGE("Document Type","Document Type");
        // SalesLine.SETRANGE("Document No.","No.");
        // SalesLine.SETRANGE(Type,SalesLine.Type::Item);
        // SalesLine.SETFILTER("Qty. to Ship",'<>0');
        // IF NOT SalesLine.FINDSET THEN
        //  ERROR('No se han encontrado líneas a enviar para distribuir en embalajes');
        Rec.TestField(Rec."Location Code");
        Packaging.Reset;
        Packaging.SetRange("Source Type", Database::"Sales Line");
        Packaging.SetRange("Source No.", Rec."No.");
        Packaging.SetRange("Location Code", Rec."Location Code");
        Clear(PackagingsList);
        PackagingsList.SetSource(Database::"Sales Line", Rec."No.", 0);
        PackagingsList.SetLocationCode(Rec."Location Code");
        PackagingsList.SetTableview(Packaging);
        PackagingsList.RunModal;
    end;

    procedure UpdateOutboundWhseHandlingTime()
    var
        IsHandled: Boolean;
        Location: Record Location;
        InvtSetup: Record "Inventory Setup";
    begin
        IsHandled := false;
        if IsHandled then exit;
        if "Location Code" <> '' then begin
            if Location.Get("Location Code") then "Outbound Whse. Handling Time" := Location."Outbound Whse. Handling Time";
        end
        else if InvtSetup.Get() then "Outbound Whse. Handling Time" := InvtSetup."Outbound Whse. Handling Time";
    end;

    var
        _InfoCompany: Record "Company Information";
        //SIIManagement: Codeunit "SII Management";
        Opp: Record Opportunity;
        TempOpportunityEntry: Record "Opportunity Entry" temporary;
        Text000: label 'Do you want to print shipment %1?';
        Text001: label 'Do you want to print invoice %1?';
        Text002: label 'Do you want to print credit memo %1?';
        Text023: label 'Do you want to print return receipt %1?';
        Text043: label 'Wizard Aborted';
        Text055: label 'Do you want to print prepayment invoice %1?';
        Text054: label 'Do you want to print prepayment credit memo %1?';
        ServiceZone: Record "Service Zone";
        UpdateComQst: label 'Do you want to update commission amount for the lines?';
        Cust: Record Customer;
}
