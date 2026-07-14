TableExtension 50116 "BBT Purchase Line" extends "Purchase Line"
{
    fields
    {
        field(50000; "Modificado SGA"; Boolean)
        {
            //>> SGA Extension
            ObsoleteState = Pending;
            //<<
            Description = 'SGA';
        }
        field(50001; "Container Nr"; Text[30])
        {
            Caption = 'Container Nr', comment = 'ESP="Nº Contenedor"';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ControlExported;
            end;
        }
        field(50002; ETA; Date)
        {
            DataClassification = ToBeClassified;
            Editable = true;

            //>> Se utiliza el desglose de LeadTimes del Producto para el calculo de las fechas: 
            //   "Planned Receipt Date" y "Expected Receipt Date"
            //   Se recalcula con la rutina de la Purchase Header en el evento 'OnAfterModifyEvent' de la Purchade Line
            /*
            trigger OnValidate()
            begin
                Rec.Validate("Expected Receipt Date", ETA);
                Rec.Validate("Planned Receipt Date", ETA);
                Rec.Modify();
            end;
            */
        }
        field(50003; "ETD PO"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = true;

            trigger OnValidate()
            begin
                ControlExported;
            end;
        }
        field(50004; "Expected Delivery Date"; Date)
        {
            ObsoleteState = Pending;
            Caption = 'Expected Delivery Date', Comment = 'ESP="Fecha recepción esperada"';
            DataClassification = ToBeClassified;
            Editable = true;

            trigger OnValidate()
            begin
                ControlExported;
            end;
        }
        field(50005; "Port - POL"; Text[30])
        {
            Caption = 'Port of Loading', comment = 'ESP="Puerto de Origen"';
            DataClassification = ToBeClassified;
            TableRelation = "Shipment Method";

            trigger OnValidate()
            begin
                ControlExported;
            end;
        }
        field(50006; "Port - POD"; Text[30])
        {
            Caption = 'Port of Discharge', Comment = 'ESP="Puerto de Descarga"';
            DataClassification = ToBeClassified;
            TableRelation = "Shipment Method";

            trigger OnValidate()
            begin
                ControlExported;
            end;
        }
        field(50009; "Shipping container"; Code[10])
        {
            Caption = 'Shipping container', comment = 'ESP="Tipo contenedor"';
            DataClassification = ToBeClassified;
            Editable = true;
            TableRelation = "Unit of Measure".Code;

            trigger OnValidate()
            begin
                ControlExported;
            end;
        }
        field(50010; "Receipt Nr"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ControlExported;
            end;
        }
        field(50011; "Receipt Line Nr"; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ControlExported;
            end;
        }
        field(50012; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(50013; "EDI - RE Amt."; Decimal)
        {
            Caption = 'EDI - Importe RE';
            DataClassification = ToBeClassified;
        }
        field(50014; "EDI - Other tax type"; Code[6])
        {
            Caption = 'EDI - Otro tipo impuesto';
            DataClassification = ToBeClassified;
        }
        field(50015; "EDI - Other tax %"; Decimal)
        {
            Caption = 'EDI - % Otro impuesto';
            DataClassification = ToBeClassified;
        }
        field(50016; "EDI - Other tax amt."; Decimal)
        {
            Caption = 'EDI - Importe otro impuesto';
            DataClassification = ToBeClassified;
        }
        field(50017; "EDI - Net weight"; Decimal)
        {
            Caption = 'EDI - Peso neto';
            DataClassification = ToBeClassified;
        }
        field(50018; "EDI - Weight UOM"; Code[6])
        {
            Caption = 'EDI - Ud. Medida peso';
            DataClassification = ToBeClassified;
        }
        field(50019; "EDI - Model description"; Text[25])
        {
            Caption = 'EDI - Descripción modelo';
            DataClassification = ToBeClassified;
        }
        field(50020; "EDI - Color"; Text[25])
        {
            Caption = 'EDI - Color';
            DataClassification = ToBeClassified;
        }
        field(50021; "EDI - Width or size"; Text[25])
        {
            Caption = 'EDI - Anchura o talla';
            DataClassification = ToBeClassified;
        }
        field(50022; "EDI - Item SN"; Code[35])
        {
            Caption = 'EDI - Nº Serie artículo';
            DataClassification = ToBeClassified;
        }
        field(50023; "EDI - Item Lot"; Code[35])
        {
            Caption = 'EDI - Nº Lote artículo';
            DataClassification = ToBeClassified;
        }
        field(50024; "EDI - Manufacturer Item No."; Code[35])
        {
            Caption = 'EDI - Nº Art. Fabricante';
            DataClassification = ToBeClassified;
        }
        field(50025; "EDI - Line Amt. Tax incl."; Decimal)
        {
            Caption = 'EDI - Importe línea impuestos incl.';
            DataClassification = ToBeClassified;
        }
        field(50026; "EDI - Net unit price base"; Decimal)
        {
            Caption = 'EDI - Base precio neto unitario';
            DataClassification = ToBeClassified;
        }
        field(50027; "EDI - Item price taxes incl."; Decimal)
        {
            Caption = 'EDI - Precio art. Impuestos incl.';
            DataClassification = ToBeClassified;
        }
        field(50028; "EDI - Shipment No."; Code[17])
        {
            Caption = 'EDI - Nº Albarán';
            DataClassification = ToBeClassified;
        }
        field(50029; "EDI - Shipment date"; Date)
        {
            Caption = 'EDI - Fecha albarán';
            DataClassification = ToBeClassified;
        }
        field(50030; "EDI - End customer code"; Code[17])
        {
            Caption = 'EDI - Cód. Cliente final';
            DataClassification = ToBeClassified;
        }
        field(50031; "EDI - End customer name"; Text[70])
        {
            Caption = 'EDI - Nombre cliente final';
            DataClassification = ToBeClassified;
        }
        field(50032; "EDI - End customer address"; Text[70])
        {
            Caption = 'EDI - Dirección cliente final';
            DataClassification = ToBeClassified;
        }
        field(50033; "EDI - End customer city"; Text[35])
        {
            Caption = 'EDI - Población cliente final';
            DataClassification = ToBeClassified;
        }
        field(50034; "EDI - End customer post code"; Code[9])
        {
            Caption = 'EDI - CP cliente final';
            DataClassification = ToBeClassified;
        }
        field(50035; "EDI - Item ID/Order Line"; Code[15])
        {
            Caption = 'EDI - Id. Producto/Línea pedido';
            DataClassification = ToBeClassified;
            Description = '// Solo se utiliza para Carrefour';
        }
        field(50036; "EDI - Comments"; Blob)
        {
            Caption = 'EDI - Observaciones';
            DataClassification = ToBeClassified;
        }
        field(50037; "EDI - EAN13/DUN14"; Code[15])
        {
            Caption = 'EDI - EAN13/DUN14';
            DataClassification = ToBeClassified;
        }
        field(50038; "EDI - Item code type"; Code[3])
        {
            Caption = 'EDI - Tipo código artículo';
            DataClassification = ToBeClassified;
        }
        field(50039; "EDI - Promotion variable"; Text[35])
        {
            Caption = 'EDI - Variable promocional';
            DataClassification = ToBeClassified;
        }
        field(50040; "EDI - Extra item EAN"; Code[35])
        {
            Caption = 'EDI - EAN Artículo adicional';
            DataClassification = ToBeClassified;
        }
        field(50041; "EDI - Reimbursed Qty."; Decimal)
        {
            Caption = 'EDI - Cdad. Bonificada';
            DataClassification = ToBeClassified;
        }
        field(50042; "EDI - Line Amount"; Decimal)
        {
            Caption = 'EDI - Importe neto línea';
            DataClassification = ToBeClassified;
        }
        field(50043; "EDI - Gross unit price"; Decimal)
        {
            Caption = 'EDI - Precio bruto unitario';
            DataClassification = ToBeClassified;
        }
        field(50044; "EDI - Net unit price"; Decimal)
        {
            Caption = 'EDI - Precio neto unitario';
            DataClassification = ToBeClassified;
        }
        field(50045; "EDI - Price UOM"; Code[6])
        {
            Caption = 'EDI - Ud. Medida Precio';
            DataClassification = ToBeClassified;
        }
        field(50046; "EDI - Tax type"; Code[6])
        {
            Caption = 'EDI - Tipo impuesto';
            DataClassification = ToBeClassified;
        }
        field(50047; "EDI - Tax %"; Decimal)
        {
            Caption = 'EDI - % Impuesto';
            DataClassification = ToBeClassified;
        }
        field(50048; "EDI - Tax Amt."; Decimal)
        {
            Caption = 'EDI - Importe impuesto';
            DataClassification = ToBeClassified;
        }
        field(50049; "EDI - RE %"; Decimal)
        {
            Caption = 'EDI - % RE';
            DataClassification = ToBeClassified;
        }
        field(50050; "BBT Cntr Type"; Code[20])
        {
            Caption = 'Cntr Type', comment = 'ESP="Tipo Cntr"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const("Cntr Type"));
            DataClassification = ToBeClassified;
        }
        field(50051; "BBT Inspection"; Date)
        {
            Caption = 'Inspection', comment = 'ESP="Inspección"';
            DataClassification = ToBeClassified;
        }
        field(50052; "BBT Result"; Code[20])
        {
            Caption = 'Result', comment = 'ESP="Resultado"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const("Result"));
            DataClassification = ToBeClassified;
        }
        field(50053; "BBT Forwarder"; Code[20])
        {
            Caption = 'Forwarder', comment = 'ESP="Forwarder"';
            TableRelation = Vendor;
            DataClassification = ToBeClassified;
        }
        field(50054; "BBT ENS"; Date)
        {
            Caption = 'ENS', comment = 'ESP="ENS / Liberado"';
            DataClassification = ToBeClassified;
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
        field(50110; "Container Code"; Code[20])
        {
            ObsoleteState = Pending;
            DataClassification = ToBeClassified;
            Caption = 'Container Code', comment = 'ESP="Cód. Contenedor"';
        }
        field(50111; "Container Size/Load"; Enum "BBT Container Size/Load")
        {
            ObsoleteState = Pending;
            Caption = 'Container Size/Load', comment = 'ESP="Tamaño/Carga Contenedor"';
        }
        field(50112; "Forwarder Code"; Code[20])
        {
            ObsoleteState = Pending;
            DataClassification = ToBeClassified;
            Caption = 'Forwarder Code', comment = 'ESP="Código expedidor"';
            TableRelation = "Shipping Agent".Code;
        }
        field(50113; "Forwarder Name"; Text[50])
        {
            ObsoleteState = Pending;
            Caption = 'Forwarder Name', comment = 'ESP="Nombre expedidor"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Shipping Agent".Name where(Code = field("Forwarder Code")));
        }
        field(50114; "Customs Clearance"; Text[150])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customs Clearance', comment = 'ESP="Despacho Aduana"';
        }
        field(50115; "Docs. to Forwarder"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Docs. to Forwarder', comment = 'ESP="Docs. al expedidor"';
        }
        field(50116; SANIDAD; Text[50])
        {
            ObsoleteState = Pending;
            DataClassification = ToBeClassified;
        }
        field(50117; LIBERADO; Text[50])
        {
            ObsoleteState = Pending;
            DataClassification = ToBeClassified;
        }
        field(50118; "DEMORA LÍM."; Date)
        {
            ObsoleteState = Pending;
            DataClassification = ToBeClassified;
        }
        field(50119; "Days in port"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Days in port', comment = 'ESP="Días en el puerto"';
            ToolTip = 'Specifies the value of the days in port', Comment = 'ESP="Especifica los dias en el Puerto"';
            BlankZero = true;
            DecimalPlaces = 0 : 0;
        }
        field(50120; "Warehouse Upload Date"; Date)
        {
            ObsoleteState = Pending;
            DataClassification = ToBeClassified;
            Caption = 'Warehouse Upload Date', comment = 'ESP="Fecha Entrada Almacén"';
        }
        field(50121; "Container Volume"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Container Volume.', comment = 'ESP="Volumen Contenedor"';
        }
        field(50122; "Consolidated Shipment"; Boolean)
        {
            ObsoleteState = Pending;
            DataClassification = ToBeClassified;
            Caption = 'Consolidated Shipment.', comment = 'ESP="Embarque consolidado"';
        }
        field(50123; "Consolidation Reference"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Consolidation Reference.', comment = 'ESP="Referencia consolidacion"';
        }
        field(51131; "Ship Name"; Text[50])
        {
            Caption = 'Ship Name', Comment = 'ESP="Nombre del Barco"';
            ToolTip = 'Specifies the value of the Ship Name field', Comment = 'ESP="Especifica el nombre del barco"';
        }
        field(51139; "BBT Line Status"; Code[20])
        {
            Caption = 'Status', Comment = 'ESP="Estado Importación"';
            ToolTip = 'Specifies the value of the Line Status field', Comment = 'ESP="Especifica el estado de la línea del pedido"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const("Status"));
        }
        field(51145; "BBT ETA Planning"; Date)
        {
            Caption = 'ETA Planning', Comment = 'ESP="ETA Planificada"';
            ToolTip = 'Specifies the value of the ETA Planning field', Comment = 'ESP="Especifica el la fecha ETA planificada"';
        }
        field(51179; "Shipping Tracking URL"; Text[2048])
        {
            Caption = 'Shipping Tracking URL', Comment = 'ESP="URL Seguimiento"';
            ToolTip = 'Specifies the value of the Shipping Tracking URL', Comment = 'ESP="Especifica la URL de Seguimiento del Transporte"';
        }
        field(51180; "Days on the Ship"; integer)
        {
            Caption = 'Days on the Ship', Comment = 'ESP="Dias en el Barco"';
            ToolTip = 'Specifies the value of the days on the ship', Comment = 'ESP="Especifica los dias en el Barco"';
            BlankZero = true;
        }
        field(51181; "Warehouse Upload DateTime"; DateTime)
        {
            Caption = 'Warehouse Upload DateTime', comment = 'ESP="Fecha:Hora Entrada Almacén"';
        }
        field(51182; "Health"; Code[20])
        {
            Caption = 'Health / RHOS', comment = 'ESP="Sanidad / RHOS"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const("Health"));
        }
        field(51183; "Plastics Control"; Code[20])
        {
            Caption = 'Plastics Control', comment = 'ESP="Control Plásticos"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const("Plastics Control"));
        }
        field(51184; "Origin Certificate"; Code[20])
        {
            Caption = 'Origin Certificate', comment = 'ESP="Certificado Origen"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const("Origin Certificate"));
        }
    }

    var
        rPurchaseHeader: Record "Purchase Header";

    trigger OnAfterInsert()
    begin
        rPurchaseHeader.Reset();
        if rPurchaseHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            if rPurchaseHeader."Shipment Method Code" <> '' then begin
                Rec."Port - POL" := rPurchaseHeader."Shipment Method Code"; //Puerto de origen del envio
                rec.Modify();
            end;
        end;
    end;

    local procedure ControlExported()
    begin
        if Rec."Exported to CSV" then Error('File sended');
    end;

    procedure EnviarSGA()
    var
        rPurchaseHeader: Record "Purchase Header";
        rCompanyInformation: Record "Company Information";
    begin
        rPurchaseHeader.Reset();
        rCompanyInformation.Reset();

        rCompanyInformation.Get;
        if rCompanyInformation.SGA then begin
            if Rec."Document Type" = Rec."document type"::Order then begin
                rPurchaseHeader.Get(Rec."Document Type", Rec."Document No.");
                if rPurchaseHeader."Status SGA" <> rPurchaseHeader."status sga"::" " then begin
                    rPurchaseHeader.ModificadoSGA := true;
                    rPurchaseHeader.Modify;
                    Rec."Modificado SGA" := true;
                    Rec.Modify;
                end;
            end;
        end;
    end;

}
