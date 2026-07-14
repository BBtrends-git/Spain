table 51102 "BBT Import Order Status"
{
    Caption = 'Import Order Status', Comment = 'ESP="Estado Pedidos Importación"';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "BBT Session Id"; Integer)
        {
            Caption = 'Session Id.', Comment = 'ESP="Session Id."';
        }
        field(2; "BBT Document Type"; Enum "Purchase Document Type")
        {
            Caption = 'Document Type', Comment = 'ESP="Tipo de Documento"';
        }
        field(3; "BBT Order No."; Code[20])
        {
            Caption = 'Order No.', Comment = 'ESP="Nº pedido"';
            NotBlank = true;
            DataClassification = ToBeClassified;
        }
        field(4; "BBT Line No."; Integer)
        {
            Caption = 'Line No.', Comment = 'ESP="Nº línea"';
            NotBlank = true;
            DataClassification = ToBeClassified;
        }
        field(5; "BBT Order Date"; Date)
        {
            Caption = 'Order Date', Comment = 'ESP="Fecha Pedido"';
        }
        field(6; "BBT Status"; Code[20])
        {
            Caption = 'Status', Comment = 'ESP="Estado"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const("Status"));
            DataClassification = ToBeClassified;
        }
        field(7; "BBT Item No."; Code[20])
        {
            Caption = 'Item No.', Comment = 'ESP="Producto"';
            DataClassification = ToBeClassified;
        }
        field(8; "BBT Model"; Text[100])
        {
            Caption = 'Model', Comment = 'ESP="Modelo"';
            DataClassification = ToBeClassified;
        }
        field(9; "BBT Quantity"; Decimal)
        {
            Caption = 'Quantity', Comment = 'ESP="Cantidad"';
            DataClassification = ToBeClassified;
        }
        field(10; "BBT Qty To Receive"; Decimal)
        {
            Caption = 'Qty. to Receive', Comment = 'ESP="Cantidad a Recibir"';
        }
        field(11; "BBT Quantity Received"; Decimal)
        {
            Caption = 'Quantity Received', Comment = 'ESP="Cantidad Recibida"';
        }
        field(12; "BBT Cntr Type"; Code[20])
        {
            Caption = 'Cntr Type', Comment = 'ESP="Tipo Cntr"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const("Cntr Type"));
            DataClassification = ToBeClassified;
        }
        field(13; "BBT Vendor No."; Code[20])
        {
            Caption = 'Vendor No.', Comment = 'ESP="Nº proveedor"';
            TableRelation = Vendor;
            DataClassification = ToBeClassified;
        }
        field(14; "BBT Product Manager"; Code[20])
        {
            Caption = 'Product Manager', Comment = 'ESP="Responsable de Producto"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const("Product Mgr"));
        }
        field(15; "BBT Port"; Code[10])
        {
            Caption = 'Port', Comment = 'ESP="Puerto"';
            DataClassification = ToBeClassified;
        }
        field(16; "BBT Agent"; Code[20])
        {
            Caption = 'Agent', Comment = 'ESP="Agente"';
            TableRelation = "Salesperson/Purchaser";
            DataClassification = ToBeClassified;

            //>> BBT. 10/06/2026. No es necesario recuperar el nombre del agente.
            /*
            trigger OnValidate()
            var
                SalespersonPurchaser: Record "Salesperson/Purchaser";
            begin
                if SalespersonPurchaser.Get("BBT Agent") then
                    "BBT Agent Name" := SalespersonPurchaser.Name
                else
                    Clear("BBT Agent Name"); 
            end;
            */
            //<<
        }
        field(17; "BBT Agent Name"; Text[50])
        {
            Caption = 'Agent Name', Comment = 'ESP="Nombre agente"';
            TableRelation = "Salesperson/Purchaser";
            DataClassification = ToBeClassified;
        }
        field(18; "BBT ETD PO"; Date)
        {
            Caption = 'ETD PO', Comment = 'ESP="ETD PO"';
            DataClassification = ToBeClassified;
        }
        field(19; "BBT ETA Planning"; Date)
        {
            Caption = 'ETA Planning', Comment = 'ESP="Planning ETA"';
            DataClassification = ToBeClassified;
        }
        field(20; "BBT Proforma"; Boolean)
        {
            Caption = 'Proforma', Comment = 'ESP="Proforma"';
            DataClassification = ToBeClassified;
        }
        field(21; "BBT ETD PI"; Date)
        {
            Caption = 'ETD PI', Comment = 'ESP="ETD PI"';
            DataClassification = ToBeClassified;
        }
        field(22; "BBT Payment Term"; Code[10])
        {
            Caption = 'Payment Term', Comment = 'ESP="Término pago"';
            TableRelation = "Payment Terms";
            DataClassification = ToBeClassified;
        }
        field(23; "BBT LC Opening Date"; Date)
        {
            Caption = 'LC Opening Date', Comment = 'ESP="Fecha apertura LC"';
            DataClassification = ToBeClassified;
        }
        field(24; "BBT LC Status"; Code[20])
        {
            Caption = 'LC Status', Comment = 'ESP="Estado LC"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const("Status LC"));
            DataClassification = ToBeClassified;
        }
        field(25; "BBT LC Date Received"; Date)
        {
            Caption = 'LC Date Received', Comment = 'ESP="Fecha LC recibida"';
            DataClassification = ToBeClassified;
        }
        field(26; "BBT LC No."; Code[20])
        {
            Caption = 'LC No.', Comment = 'ESP="Nº LC"';
            DataClassification = ToBeClassified;
        }
        field(27; "BBT Bank"; Code[20])
        {
            Caption = 'Bank', Comment = 'ESP="Banco"';
            TableRelation = "Bank Account";
            DataClassification = ToBeClassified;
        }
        field(28; "BBT ETD LC"; Date)
        {
            Caption = 'ETD LC', Comment = 'ESP="ETD LC"';
            DataClassification = ToBeClassified;
        }
        field(29; "BBT Inspection"; Date)
        {
            Caption = 'Inspection', Comment = 'ESP="Inspección"';
            DataClassification = ToBeClassified;
        }
        field(30; "BBT Result"; Code[20])
        {
            Caption = 'Result', Comment = 'ESP="Resultado"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const("Result"));
            DataClassification = ToBeClassified;
        }
        field(31; "BBT Forwarder"; Code[20])
        {
            Caption = 'Forwarder', Comment = 'ESP="Forwarder"';
            TableRelation = Vendor;
            DataClassification = ToBeClassified;
        }
        field(32; "BBT ENS"; Date)
        {
            Caption = 'ENS', Comment = 'ESP="ENS / Liberado"';
            DataClassification = ToBeClassified;
        }
        field(33; "BBT ETD"; Date)
        {
            Caption = 'ETD', Comment = 'ESP="ETD"';
            DataClassification = ToBeClassified;
        }
        field(34; "BBT ETA"; Date)
        {
            Caption = 'ETA', Comment = 'ESP="ETA"';
            DataClassification = ToBeClassified;
        }
        field(35; "BBT Comm. Planning/Promotions"; Text[80])
        {
            Caption = 'Comments Planning/Promotions', Comment = 'ESP="Comentarios planning/promociones"';
            DataClassification = ToBeClassified;
            trigger OnLookup()
            var
                PurchCommentLine: Record "Purch. Comment Line";
                PurchCommentSheet: Page "Purch. Comment Sheet";
            begin
                PurchCommentLine.Reset();
                PurchCommentLine.SetRange("Document Type", PurchCommentLine."Document Type"::"Order");
                PurchCommentLine.SetRange("No.", "BBT Order No.");
                PurchCommentLine.SetRange("Line No.", "BBT Line No.");
                Clear(PurchCommentSheet);
                PurchCommentSheet.SetTableView(PurchCommentLine);
                PurchCommentSheet.RunModal();
            end;
        }
        field(36; "BBT Type"; Enum "BBT States Auxiliary Table")
        {
            ObsoleteState = Pending;
            Caption = 'Type', Comment = 'ESP="Tipo"';
            DataClassification = ToBeClassified;
        }
        field(37; "BBT CDI Amount"; Decimal)
        {
            ObsoleteState = Pending;
            Caption = 'CDI Amount', Comment = 'ESP="Importe CDI"';
            DataClassification = ToBeClassified;
        }
        field(38; "BBT Shipping Date"; Date)
        {
            Caption = 'Shipping Date', Comment = 'ESP="F/embarque"';
            DataClassification = ToBeClassified;
        }
        field(39; "BBT Due Date ETD PI"; Date)
        {
            Caption = 'Due Date ETD PI', Comment = 'ESP="Fecha Vto. ETD PI"';
            DataClassification = ToBeClassified;
        }
        field(40; "BBT Situation"; Code[20])
        {
            Caption = 'Situation', Comment = 'ESP="Situación"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const("Situation"));
            DataClassification = ToBeClassified;
        }
        field(41; "BBT Currency"; Code[10])
        {
            Caption = 'Currency', Comment = 'ESP="Divisa"';
            TableRelation = Currency;
            DataClassification = ToBeClassified;
        }
        field(42; "BBT Bank Ref."; Code[20])
        {
            Caption = 'Bank Ref.', Comment = 'ESP="Ref. bco."';
            DataClassification = ToBeClassified;
        }
        field(43; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code', Comment = 'ESP="Codigo categoria Producto"';
            DataClassification = ToBeClassified;
        }
        field(44; "Status"; Enum "Purchase Document Status")
        {
            Caption = 'Status', Comment = 'ESP="Estado"';
            DataClassification = ToBeClassified;
        }
        field(45; "Status SGA"; option)
        {
            Caption = 'Status SGA', Comment = 'ESP="Estatus SGA"';
            OptionCaption = ' ,SGA Sent,SGA Locked', Comment = 'ESP=" ,Enviado SGA,Bloqueado SGA"';
            OptionMembers = " ","Enviado SGA","Bloqueado SGA";
        }
        field(46; "Payment Method Code"; code[10])
        {

            Caption = 'Payment Method Code', Comment = 'ESP="Codigo Metodo de pago"';
            TableRelation = "Payment Method";
            DataClassification = ToBeClassified;
        }
        field(47; "Lead Time Calculation"; DateFormula)
        {
            DataClassification = ToBeClassified;
            Caption = 'Lead Time Calculation', Comment = 'ESP="Cálculo plazo de entrega"';
        }
        field(48; "BBT Container No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'BBT Container No.', Comment = 'ESP="BBT No. Contenedor"';
        }
        field(49; "BBT Container Volume"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'BBT Container Volume', Comment = 'ESP="BBT Volumen Contenedor"';
        }
        field(50; "BBT Consolidated Shipment"; Boolean)
        {
            ObsoleteState = Pending;
            DataClassification = ToBeClassified;
            Caption = 'BBT Consolidated Shipment', Comment = 'ESP="BBT Albaran Consolidado"';
        }
        field(51; "BBT Consolidation Reference"; text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'BBT Consolidation Reference', Comment = 'ESP="BBT Referencia Consolidada"';
        }
        field(52; "BBT Search Name"; code[100])
        {
            Caption = 'Search Name', Comment = 'ESP="Proveedor"';
            DataClassification = ToBeClassified;
        }
        field(53; "BBT Ship Name"; Text[50])
        {
            Caption = 'Ship Name', Comment = 'ESP="Nombre del Barco"';
        }
        field(54; "BBT Port POL"; Text[30])
        {
            TableRelation = "Shipment Method";
            Caption = 'Port of Loading', Comment = 'ESP="Puerto de Origen"';
        }
        field(55; "BBT Port POD"; Text[30])
        {
            TableRelation = "Shipment Method";
            Caption = 'Port of Discharge', Comment = 'ESP="Puerto de Descarga"';
        }
        field(56; "BBT Forwarder Name"; Text[100])
        {
            Caption = 'Forwarder Name', Comment = 'ESP="Nombre Forwarder"';
            TableRelation = Vendor.Name;
            ValidateTableRelation = false;
        }
        field(57; "BBT Direct Unit Cost"; Decimal)
        {
            Caption = 'Direct Unit Cost', Comment = 'ESP="Coste Unit. Directo"';
        }
        field(58; "BBT Line Amount"; Decimal)
        {
            Caption = 'Line Amount', Comment = 'ESP="Importe Línea"';
        }
        field(59; "BBT Currency Code"; Code[10])
        {
            Caption = 'Currency Code', Comment = 'ESP="Divisa"';
        }
        field(60; "BBT Location Code"; Code[10])
        {
            Caption = 'Location Code', Comment = 'ESP="Almacén"';
            TableRelation = Location;
        }
        field(61; "BBT Days on the Ship"; Integer)
        {
            Caption = 'Days on the Ship', Comment = 'ESP="Dias en el Barco"';
            BlankZero = true;
        }
        field(62; "BBT Days in Port"; Integer)
        {
            Caption = 'Days in Port', Comment = 'ESP="Dias en el Puerto"';
            BlankZero = true;
        }
        field(63; "BBT Warehouse Upload DateTime"; DateTime)
        {
            Caption = 'Warehouse Upload DateTime', comment = 'ESP="Fecha/Hora Entrada Almacén"';
        }
        field(64; "BBT Health"; Code[20])
        {
            Caption = 'Health / RHOS', comment = 'ESP="Sanidad / RHOS"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const("Health"));
        }
        field(65; "BBT Customs Clearence"; Text[150])
        {
            Caption = 'Customs Clearance', comment = 'ESP="Despacho Aduana"';
        }
        field(66; "BBT Docs Forwarder"; Text[50])
        {
            Caption = 'Docs Forwarder', comment = 'ESP="Docs Forwarder"';
        }
        field(67; "BBT Plastics Control"; Code[20])
        {
            Caption = 'Plastics Control', comment = 'ESP="Control Plásticos"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const("Plastics Control"));
        }
        field(68; "BBT Origin Certificate"; Code[20])
        {
            Caption = 'Origin Certificate', comment = 'ESP="Certificado Origen"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const("Origin Certificate"));
        }
        field(69; "BBT Shipping Tracking URL"; Text[2048])
        {
            Caption = 'Shipping Tracking URL', Comment = 'ESP="URL Seguimiento"';
            ToolTip = 'Specifies the value of the Shipping Tracking URL', Comment = 'ESP="Especifica la URL de Seguimiento del Transporte"';
        }
    }
    keys
    {
        key(PK; "BBT Session Id", "BBT Order No.", "BBT Document Type", "BBT Line No.")
        {
            Clustered = true;
        }
    }
    Procedure MoveData(pSessionImport: integer; var pImportOrderStatus: record "BBT Import Order Status"; pPurchaseLine: Record "Purchase Line")
    var
        rVendor: Record Vendor;
        rComment: Record "Purch. Comment Line";
        rPurchaseHeader: Record "Purchase Header";

    begin
        If rPurchaseHeader.Get(pPurchaseLine."Document Type", pPurchaseLine."Document No.") then;

        pImportOrderStatus.reset;
        pImportOrderStatus."BBT Document Type" := rPurchaseHeader."Document Type";
        pImportOrderStatus."BBT Order No." := rPurchaseHeader."No.";
        pImportOrderStatus."BBT Line No." := pPurchaseLine."Line No.";
        pImportOrderStatus."BBT Order Date" := rPurchaseHeader."Order Date";
        pImportOrderStatus."BBT Vendor No." := rPurchaseHeader."Buy-from Vendor No.";
        Clear(pImportOrderStatus."BBT Search Name");
        if rVendor.Get(pPurchaseLine."Buy-from Vendor No.") then
            pImportOrderStatus."BBT Search Name" := rVendor."Search Name";
        pImportOrderStatus."Payment Method Code" := rPurchaseHeader."Payment Method Code";
        pImportOrderStatus."BBT Payment Term" := rPurchaseHeader."Payment Terms Code";
        pImportOrderStatus.Status := rPurchaseHeader.Status;
        //>> NO se usa.
        //pImportOrderStatus."Status SGA" := rPurchaseHeader."Status SGA";
        //<<
        //
        pImportOrderStatus."BBT Agent" := rPurchaseHeader."Purchaser Code";
        pImportOrderStatus."BBT Product Manager" := rPurchaseHeader."Product Manager";
        //
        pImportOrderStatus."BBT ETD PO" := rPurchaseHeader."ETD PO";
        pImportOrderStatus."BBT ETA Planning" := rPurchaseHeader."BBT ETA Planning";
        pImportOrderStatus."BBT Proforma" := rPurchaseHeader."BBT Proforma";
        pImportOrderStatus."BBT ETD PI" := rPurchaseHeader."BBT ETD PI";
        pImportOrderStatus."BBT LC Opening Date" := rPurchaseHeader."BBT LC Opening Date";
        pImportOrderStatus."BBT Due Date ETD PI" := rPurchaseHeader."BBT Due Date ETD PI";
        pImportOrderStatus."BBT LC Status" := rPurchaseHeader."BBT LC Status";
        pImportOrderStatus."BBT LC Date Received" := rPurchaseHeader."BBT LC Date Received";
        pImportOrderStatus."BBT LC No." := rPurchaseHeader."BBT LC No.";
        pImportOrderStatus."BBT Bank" := rPurchaseHeader."BBT Bank";
        pImportOrderStatus."BBT ETD LC" := rPurchaseHeader."BBT ETD LC";
        //
        pImportOrderStatus."BBT Item No." := pPurchaseLine."No.";
        pImportOrderStatus."BBT Model" := pPurchaseLine.Description;
        pImportOrderStatus."BBT Quantity" := pPurchaseLine.Quantity;
        pImportOrderStatus."BBT Qty To Receive" := pPurchaseLine."Qty. to Receive";
        pImportOrderStatus."BBT Quantity Received" := pPurchaseLine."Quantity Received";
        pImportOrderStatus."BBT Direct Unit Cost" := pPurchaseLine."Direct Unit Cost";
        pImportOrderStatus."BBT Line Amount" := pPurchaseLine."Line Amount";
        pImportOrderStatus."BBT Currency Code" := pPurchaseLine."Currency Code";
        pImportOrderStatus."BBT ETA Planning" := pPurchaseLine."BBT ETA Planning";
        pImportOrderStatus."BBT Status" := pPurchaseLine."BBT Line Status";
        pImportOrderStatus."BBT Inspection" := pPurchaseLine."BBT Inspection";
        pImportOrderStatus."BBT Result" := pPurchaseLine."BBT Result";
        pImportOrderStatus."BBT Forwarder" := pPurchaseLine."BBT Forwarder";
        Clear(pImportOrderStatus."BBT Forwarder Name");
        if rVendor.Get(pPurchaseLine."BBT Forwarder") then
            pImportOrderStatus."BBT Forwarder Name" := rVendor.Name;
        Clear(pImportOrderStatus."BBT Comm. Planning/Promotions");
        rComment.SetRange("Document Type", rComment."Document Type"::Order);
        rComment.SetRange("No.", pPurchaseLine."Document No.");
        rComment.SetFilter(rComment.Comment, '<>%1', '');
        if rComment.FindLast() then
            pImportOrderStatus."BBT Comm. Planning/Promotions" := rComment.Comment;
        pImportOrderStatus."BBT ENS" := pPurchaseLine."BBT ENS";
        pImportOrderStatus."BBT Cntr Type" := pPurchaseLine."BBT Cntr Type";
        pImportOrderStatus."BBT Container No." := pPurchaseLine."Container Nr";
        pImportOrderStatus."BBT Container Volume" := pPurchaseLine."Container Volume";
        pImportOrderStatus."BBT Ship Name" := pPurchaseLine."Ship Name";
        //pImportOrderStatus."BBT Consolidated Shipment" := pPurchaseLine."Consolidated Shipment";
        pImportOrderStatus."BBT Consolidation Reference" := pPurchaseLine."Consolidation Reference";
        pImportOrderStatus."BBT Port POL" := pPurchaseLine."Port - POL";
        pImportOrderStatus."BBT Port POD" := pPurchaseLine."Port - POD";
        pImportOrderStatus."BBT ETD" := pPurchaseLine."ETD PO";
        pImportOrderStatus."BBT ETA" := pPurchaseLine.ETA;
        pImportOrderStatus."BBT Location Code" := pPurchaseLine."Location Code";
        pImportOrderStatus."BBT Days on the Ship" := pPurchaseLine."Days on the Ship";
        pImportOrderStatus."BBT Days in Port" := pPurchaseLine."Days in port";
        pImportOrderStatus."BBT Warehouse Upload DateTime" := pPurchaseLine."Warehouse Upload DateTime";
        pImportOrderStatus."BBT Health" := pPurchaseLine.Health;
        pImportOrderStatus."BBT Customs Clearence" := pPurchaseLine."Customs Clearance";
        pImportOrderStatus."BBT Docs Forwarder" := pPurchaseLine."Docs. to Forwarder";
        pImportOrderStatus."BBT Plastics Control" := pPurchaseLine."Plastics Control";
        pImportOrderStatus."BBT Origin Certificate" := pPurchaseLine."Origin Certificate";
        pImportOrderStatus."BBT Shipping Tracking URL" := pPurchaseLine."Shipping Tracking URL";

        //pImportOrderStatus."BBT Session Id" := SessionId();
        pImportOrderStatus."BBT Session Id" := pSessionImport;

        pImportOrderStatus.Insert;
    end;

    procedure SessionNumber(): Integer
    var
        SerieImport: Code[20];
        rNoSeries: record "No. Series";
        cuNoSeries: Codeunit "No. Series";
        SessionImportText: Code[20];
        SessionImport: Integer;
    begin
        SerieImport := 'SPIMPORT-ID';       // Este valor es una constante y debe existir el registro en los números de serie
        Clear(rNoSeries);
        rNoSeries.Get(SerieImport);

        SessionImportText := cuNoSeries.GetNextNo(SerieImport, Today);
        Evaluate(SessionImport, SessionImportText);
        exit(SessionImport);
    end;

    Procedure InitializeRecord(pSessionNumber: Integer; var pImportOrderStatus: record "BBT Import Order Status")
    //var
    //rActiveSesion: Record "Active Session";
    //rIOSAux: Record "BBT Import Order Status" temporary;
    //Txtuserid: Text;
    begin
        //>> Se eliminan registros 'antiguos', de dias anteriores.
        pImportOrderStatus.Reset();
        pImportOrderStatus.SetFilter(SystemCreatedAt, '<%1', CreateDateTime(Today, 0T));
        if pImportOrderStatus.FindSet() then
            pImportOrderStatus.DeleteAll();
        //<<

        //>> Si la sesión tiene registros activos de la misma sesión los borramos
        pImportOrderStatus.Reset();
        pImportOrderStatus.SetRange("BBT Session Id", pSessionNumber);
        if pImportOrderStatus.FindSet() then
            pImportOrderStatus.DeleteAll();
        //<<

        //>> Recuperamos las sesiones que han grabado registros para eliminar las que no esten activas
        /*
        pImportOrderStatus.Reset();
        if pImportOrderStatus.FindSet() then
            repeat
                rIOSAux.SetRange("BBT Session Id", pImportOrderStatus."BBT Session Id");
                if not rIOSAux.FindSet() then begin
                    rIOSAux.Init();
                    rIOSAux."BBT Session Id" := pImportOrderStatus."BBT Session Id";
                    rIOSAux.Insert();
                end;
            until pImportOrderStatus.Next() = 0;

        rIOSAux.Reset();
        if rIOSAux.FindSet() then
            repeat
                Txtuserid := UserId();
                rActiveSesion.Reset();
                rActiveSesion.SetRange("Session ID", rIOSAux."BBT Session Id");
                rActiveSesion.SetRange("User ID", UserId());
                if not rActiveSesion.FindFirst() then begin
                    pImportOrderStatus.SetRange("BBT Session Id", rIOSAux."BBT Session Id");
                    if pImportOrderStatus.FindSet() then
                        pImportOrderStatus.DeleteAll();
                end;
            until rIOSAux.Next() = 0;
        */
        //<<

        Commit();
    end;

    Procedure RemoveRecord(pSessionNumber: Integer)
    var
        rImportOrderStatus: record "BBT Import Order Status";
    begin
        rImportOrderStatus.Reset();
        rImportOrderStatus.SetRange("BBT Session Id", pSessionNumber);
        if rImportOrderStatus.FindSet() then
            rImportOrderStatus.DeleteAll();

        Commit();
    end;
}
