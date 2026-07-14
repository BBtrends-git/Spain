TableExtension 50115 "BBT Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(50000; Observations; Text[250])
        {
            Caption = 'Observations';
            Description = '001';
        }
        field(50001; "Import No."; Text[30])
        {
            ObsoleteState = Pending;
            Caption = 'Import No.';
            Description = '002';
        }
        field(50002; "ETD PO"; Date)
        {
            Caption = 'ETD PO';
            Description = '004';
        }
        field(50003; ETA; Date)
        {
            ObsoleteState = Pending;
            Caption = 'ETA';
            Description = '004';
        }
        field(50004; "Base DUA"; Decimal)
        {
            ObsoleteState = Pending;
        }
        field(50005; "Status SGA"; Option)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
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
        field(50009; "EDI - Total Amount"; Decimal)
        {
            Caption = 'EDI - Importe total neto';
            DataClassification = ToBeClassified;
        }
        field(50010; "EDI - Total discount/charges"; Decimal)
        {
            Caption = 'EDI - Importe total dtos./cargos';
            DataClassification = ToBeClassified;
        }
        field(50011; "EDI - Amount Base"; Decimal)
        {
            Caption = 'EDI - Base imponible';
            DataClassification = ToBeClassified;
        }
        field(50012; "EDI - Taxes amt."; Decimal)
        {
            Caption = 'EDI - Importe total impuestos';
            DataClassification = ToBeClassified;
        }
        field(50013; "EDI - Paying amt."; Decimal)
        {
            Caption = 'EDI - Importe a pagar';
            DataClassification = ToBeClassified;
        }
        field(50014; "EDI - Gross amt."; Decimal)
        {
            Caption = 'EDI - Importe total bruto';
            DataClassification = ToBeClassified;
        }
        field(50015; "EDI - Comments"; Blob)
        {
            Caption = 'EDI - Observaciones';
            DataClassification = ToBeClassified;
        }
        field(50016; "EDI - Additional info"; Option)
        {
            Caption = 'EDI - Información adicional';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,71E Condiciones de compra del grupo,72E Cancelar pedido si no es posible la entrega total en fechas solicitadas,73E Entrega sujeta a autorización final,81E Facturar pero no reabastecer,82E Enviar pero no factura,83E Entregar el pedido entero,X42 Venta online';
            OptionMembers = " ","71E","72E","73E","81E","82E","83E",X42,X41,X44,X45,X46;
        }
        field(50017; "EDI - EDI Order"; Boolean)
        {
            Caption = 'EDI - Pedido EDI';
            DataClassification = ToBeClassified;
            Description = '// Es un booleano que identifica los documentos generados por EDI';
        }
        field(50018; "EDI - Additional ref No."; Code[1])
        {
            Caption = 'EDI - Nº referencia adicional';
            DataClassification = ToBeClassified;
            Description = '// La tabla tiene demasiados bytes, el tamaõo original eran 80';
        }
        field(50019; "EDI - Do not send EDI"; Boolean)
        {
            Caption = 'EDI - No enviar por EDI';
            DataClassification = ToBeClassified;
        }
        field(50020; "EDI - Document datetime"; DateTime)
        {
            Caption = 'EDI - Fecha/Hora documento';
            DataClassification = ToBeClassified;
        }
        field(50021; "EDI - Delivery datetime"; DateTime)
        {
            Caption = 'EDI - Fecha/Hora entrega estimada';
            DataClassification = ToBeClassified;
        }
        field(50022; "EDI - Shipping method"; Option)
        {
            Caption = 'EDI - Modo de transporte';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,10 Transporte marítimo,20 Transporte ferroviario,30 Transporte por carretera,40 Transporte aéreo,60 Transporte múltiple';
            OptionMembers = " ","10","20","30","40","60";
        }
        field(50023; "EDI - Shipping Agent Id."; Text[13])
        {
            Caption = 'EDI - Id. Transportista';
            DataClassification = ToBeClassified;
        }
        field(50024; "EDI - Shipping Agent Name"; Text[35])
        {
            Caption = 'EDI - Nombre transportista';
            DataClassification = ToBeClassified;
        }
        field(50025; "EDI - Vehicle plate"; Text[17])
        {
            Caption = 'EDI - Matrícula vehículo';
            DataClassification = ToBeClassified;
        }
        field(50026; "EDI - Message function"; Option)
        {
            Caption = 'EDI - Función mensaje';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,6 Confirmación,7 Duplicado,9 Original,16 Propuesta,31 Copia,42 Confirmación,46 Provisional';
            OptionMembers = " ","6","7","9","16","31","42","46";
        }
        field(50027; "EDI - Shipment cost payment"; Option)
        {
            Caption = 'EDI - Método pago costes trans.';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,DF Definido por el comprador y el proveedor,PC Portes pagados pero cargados al cliente,PP portes pagados';
            OptionMembers = " ",DF,PC,PP;
        }
        field(50028; "EDI - Delivery condition"; Option)
        {
            Caption = 'EDI - Condiciones entrega';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,PD Recogida por el emisor del pedido,EP Enviada por el receptor del pedido,DDP - Entregado con derecho pagados';
            OptionMembers = " ",PD,EP,DDP;
        }
        field(50029; "EDI - Currency Code"; Code[10])
        {
            Caption = 'EDI - Cód. Moneda';
            DataClassification = ToBeClassified;
        }
        field(50030; "EDI - Unique due date"; Date)
        {
            Caption = 'EDI - Fecha vto. único';
            DataClassification = ToBeClassified;
        }
        field(50031; "EDI - Order Type"; Option)
        {
            Caption = 'EDI - Tipo pedido';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,220 Pedido normal,221 Pedido abierto,224 Pedido urgente,226 Pedido parcial,227 Pedido en consigna,22E Propuesta ped. del prov.';
            OptionMembers = " ","220","221","224","226","227","22E";
        }
        field(50032; "EDI - Additional ref type"; Option)
        {
            Caption = 'EDI - Tipo referencia adicional';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,ATZ Nº Autorización,CR Nº Ref. Cliente,CT Nº Contrato,IP Nº Licencia importación,PD Nº Acuerdo promoción,UC Último número de ref. Cliente,AAN (sin documentación)';
            OptionMembers = " ",ATZ,CR,CT,IP,PD,UC,AAN,ZZZ;
        }
        field(50050; "CDI Amount"; Decimal)
        {
            ObsoleteState = Pending;
            Caption = 'CDI Amount', comment = 'ESP="Importe CDI"';
            DataClassification = ToBeClassified;
        }
        field(50051; "CDI Shipping date"; Date)
        {
            ObsoleteState = Pending;
            Caption = 'Shipping date', Comment = 'Fecha Embarque';
            DataClassification = ToBeClassified;
        }
        field(50052; "CDI Due Date"; Date)
        {
            ObsoleteState = Pending;
            Caption = 'Due Date', comment = 'ESP="Fecha vto."';
            DataClassification = ToBeClassified;
        }
        field(50053; "CDI Situation"; Enum "CDI Situation")
        {
            ObsoleteState = Pending;
            Caption = 'Situation', comment = 'ESP="situación"';
            DataClassification = ToBeClassified;
        }
        field(50054; "CDI Currency Code"; Code[10])
        {
            ObsoleteState = Pending;
            Caption = 'Currency Code', comment = 'ESP="Cód. Divisa"';
            DataClassification = ToBeClassified;
            //TableRelation = Currency;
        }
        field(50055; "CDI Bank"; Code[20])
        {
            ObsoleteState = Pending;
            Caption = 'Bank', Comment = 'ESP="Banco"';
            DataClassification = ToBeClassified;
            //TableRelation = "Vendor Bank Account".Code where("Vendor No." = field("Buy-from Vendor No."));
        }
        field(50056; "CDI Bank Ref"; Code[20])
        {
            ObsoleteState = Pending;
            Caption = 'Bank Ref.', Comment = 'ESP="Ref. Banco"';
            DataClassification = ToBeClassified;
        }
        field(50057; "BBT ETA Planning"; Date)
        {
            Caption = 'ETA Planning', comment = 'ESP="Planning ETA"';
            DataClassification = ToBeClassified;
        }
        field(50058; "BBT Proforma"; Boolean)
        {
            Caption = 'Proforma', comment = 'ESP="Proforma"';
            DataClassification = ToBeClassified;
        }
        field(50059; "BBT ETD PI"; Date)
        {
            Caption = 'ETD PI', comment = 'ESP="ETD PI"';
            DataClassification = ToBeClassified;
            //>> BBT 13/05/2026. IMPORT STATUS. Se utiliza el desglose de LeadTimes del Producto
            /*
                trigger OnValidate()
                var
                    EmptyDateformulaVariable: DateFormula;
                begin

                    Clear(EmptyDateformulaVariable);
                    if "BBT ETD PI" <> 0D then begin
                        IF Rec."Lead Time Calculation" <> EmptyDateformulaVariable then
                            "BBT Due Date ETD PI" := CalcDate(rec."Lead Time Calculation", "BBT ETD PI")
                        else
                            "BBT Due Date ETD PI" := "BBT ETD PI";
                    end
                    else
                        Clear("BBT Due Date ETD PI");

                    Rec.Modify();
                end;
            */
            //<<
        }
        field(50060; "BBT LC Opening Date"; Date)
        {
            Caption = 'LC Opening Date', comment = 'ESP="LC Fecha apertura"';
            DataClassification = ToBeClassified;
        }
        field(50061; "BBT LC Status"; Code[20])
        {
            Caption = 'LC Status', comment = 'ESP="Estado LC"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const("Status LC"));
            DataClassification = ToBeClassified;
        }
        field(50062; "BBT LC Date Received"; Date)
        {
            Caption = 'LC Date Received', comment = 'ESP="Fecha LC recibida"';
            DataClassification = ToBeClassified;
        }
        field(50063; "BBT LC No."; Code[20])
        {
            Caption = 'LC No.', comment = 'ESP="Nº LC"';
            DataClassification = ToBeClassified;
        }
        field(50064; "BBT Bank"; Code[20])
        {
            Caption = 'Bank', comment = 'ESP="Banco"';
            TableRelation = "Bank Account";
            DataClassification = ToBeClassified;
        }
        field(50065; "BBT ETD LC"; Date)
        {
            Caption = 'ETD LC', comment = 'ESP="ETD LC"';
            DataClassification = ToBeClassified;
        }
        field(50066; "BBT Due Date ETD PI"; Date)
        {
            Caption = 'Due Date ETD PI', comment = 'ESP="Fecha vencimiento ETD PI"';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50067; "BBT Status"; Code[20])
        {
            Caption = 'Status', comment = 'ESP="Estado"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const("Status"));
            DataClassification = ToBeClassified;
        }
        field(50068; "BBT Situation"; Code[20])
        {
            Caption = 'Situation', comment = 'ESP="Situación"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const(Situation));
            DataClassification = ToBeClassified;
        }
        field(50099; "PL VAT"; Boolean)
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(50100; "Exported to CSV"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50101; "Exported to CSV Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "Exported to Suus"; Boolean)
        {
        }
        field(50103; "Exported to Suus Datetime"; DateTime)
        {
        }
        field(50110; "Inspection status"; Enum "BBT Inspection Status")
        {
            Caption = 'Inspection Status', comment = 'ESP="Estado inspección"';
        }
        field(51128; "Destination Country"; Code[10])
        {
            Caption = 'Destination Country', Comment = 'ESP="País Destino Final"';
            ToolTip = 'Specifies the value of the Destination Country field', Comment = 'ESP="Especifica el destino final del pedido"';
            TableRelation = "Country/Region";
        }
        field(51129; "Total Container Volume"; Decimal)
        {
            Caption = 'Total Container Volume', Comment = 'ESP="Volumen Total Contenedor"';
            ToolTip = 'Specifies the value of the Total Volume field', Comment = 'ESP="Especifica el volumen total contenedor de las líneas del pedido"';
            CalcFormula = sum("Purchase Line"."Container Volume" where("Document Type" = field("Document Type"), "Document No." = field("No.")));
            FieldClass = FlowField;
            Editable = false;
        }
        field(51130; "Product Manager"; Code[20])
        {
            Caption = 'Product Manager', Comment = 'ESP="Responsable de Producto"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const("Product Mgr"));
        }
        field(51168; "Include Import Status"; Boolean)
        {
            //>> Campo para incluir el pedido obligatoriamente en la gestión de los pedidos de importación <<//
            Caption = 'Include in Import Status', Comment = 'ESP="Incluido Estado Pedidos Importación"';
        }
    }
    var
        Text000: label 'Do you want to print receipt %1?';
        Text001: label 'Do you want to print invoice %1?';
        Text002: label 'Do you want to print credit memo %1?';
        Vend: Record Vendor;
        Text024: label 'Do you want to print return shipment %1?';
        Text043: label 'Do you want to print prepayment invoice %1?';
        Text044: label 'Do you want to print prepayment credit memo %1?';

    //>> BBT 13/05/2026. IMPORT STATUS.
    // Se utiliza el desglose de LeadTimes del Producto para el calculo de las fechas: 
    // "Planned Receipt Date" y "Expected Receipt Date" 
    procedure ReCalcDates(var pPurchaseHeader: Record "Purchase Header")
    var
        rPurchaseLine: Record "Purchase Line";
        rItem: Record Item;
        TotalDays: Integer;
        LeadTimeDate: Date;
        LeadTimeDateFormula: DateFormula;
        LTManufacturing: DateFormula;
        LTInspTransit: DateFormula;
        LTLastMile: DateFormula;

    begin
        Clear(rPurchaseLine);
        Clear(LTManufacturing);
        Clear(LTInspTransit);
        Clear(LTLastMile);

        rPurchaseLine.SetRange("Document Type", Rec."Document Type");
        rPurchaseLine.SetRange("Document No.", Rec."No.");
        rPurchaseLine.SetRange(Type, rPurchaseLine.Type::Item);
        //rPurchaseLine.SetFilter(Quantity, '<>%1', 0);
        If rPurchaseLine.FindSet() then begin
            repeat
                rItem.Reset();
                rItem.SetRange("No.", rPurchaseLine."No.");
                if rItem.FindFirst() then begin
                    if Format(rItem."Inspection-Transit LeadTime") <> '' then
                        LTManufacturing := rItem."Manufacturing LeadTime";
                    if Format(rItem."Inspection-Transit LeadTime") <> '' then
                        LTInspTransit := rItem."Inspection-Transit LeadTime";
                    if Format(rItem."Last Mile LeadTime") <> '' then
                        LTLastMile := rItem."Last Mile LeadTime";
                end;

                clear(LeadTimeDate);
                if rPurchaseLine.ETA <> 0D then begin
                    Clear(TotalDays);
                    TotalDays += CalcDate(LTLastMile, Today) - Today;
                    Evaluate(LeadTimeDateFormula, '<' + Format(TotalDays) + 'D>');
                    LeadTimeDate := CalcDate(LeadTimeDateFormula, rPurchaseLine.ETA);
                end
                else if rPurchaseLine."BBT Inspection" <> 0D then begin
                    Clear(TotalDays);
                    TotalDays += CalcDate(LTLastMile, Today) - Today;
                    TotalDays += CalcDate(LTInspTransit, Today) - Today;
                    Evaluate(LeadTimeDateFormula, '<' + Format(TotalDays) + 'D>');
                    LeadTimeDate := CalcDate(LeadTimeDateFormula, rPurchaseLine."BBT Inspection");
                end
                /*
                else if rPurchaseLine."BBT ETA Planning" <> 0D then begin
                    Clear(TotalDays);
                    TotalDays += CalcDate(LTLastMile, Today) - Today;
                    Evaluate(LeadTimeDateFormula, '<' + Format(TotalDays) + 'D>');
                    LeadTimeDate := CalcDate(LeadTimeDateFormula, rPurchaseLine."BBT ETA Planning");
                end
                */
                else if pPurchaseHeader."BBT ETD PI" <> 0D then begin
                    Clear(TotalDays);
                    TotalDays += CalcDate(LTLastMile, Today) - Today;
                    TotalDays += CalcDate(LTInspTransit, Today) - Today;
                    Evaluate(LeadTimeDateFormula, '<' + Format(TotalDays) + 'D>');
                    LeadTimeDate := CalcDate(LeadTimeDateFormula, pPurchaseHeader."BBT ETD PI");

                    pPurchaseHeader.Validate("BBT Due Date ETD PI", LeadTimeDate);
                end
                else if pPurchaseHeader."ETD PO" <> 0D then begin
                    Clear(TotalDays);
                    TotalDays += CalcDate(LTLastMile, Today) - Today;
                    TotalDays += CalcDate(LTInspTransit, Today) - Today;
                    Evaluate(LeadTimeDateFormula, '<' + Format(TotalDays) + 'D>');
                    LeadTimeDate := CalcDate(LeadTimeDateFormula, pPurchaseHeader."ETD PO");
                end
                else begin
                    Clear(TotalDays);
                    TotalDays += CalcDate(LTLastMile, Today) - Today;
                    TotalDays += CalcDate(LTInspTransit, Today) - Today;
                    TotalDays += CalcDate(LTManufacturing, Today) - Today;
                    Evaluate(LeadTimeDateFormula, '<' + Format(TotalDays) + 'D>');
                    LeadTimeDate := CalcDate(LeadTimeDateFormula, pPurchaseHeader."Order Date");
                end;

                if LeadTimeDate <> 0D then begin
                    rPurchaseLine.validate("Planned Receipt Date", LeadTimeDate);
                    rPurchaseLine.validate("Expected Receipt Date", LeadTimeDate);
                    rPurchaseLine.modify;
                end;

            until rPurchaseLine.Next() = 0;
        end;
    end;
    //<<
}
