table 50056 "BBT Import Order Statuses"
{
    //>> ESTA TABLA NO SE USA. LA BUENA ES LA 51106-BBT Purchase Auxiliary Status
    ObsoleteState = Removed;
    //<<

    Caption = 'Import Order Statuses', comment = 'ESP="Estado pedidos importación"';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "BBT Order No."; Code[20])
        {
            Caption = 'Order No.', comment = 'ESP="Nº pedido"';
            NotBlank = true;
            DataClassification = ToBeClassified;
        }
        field(2; "BBT Line No."; Integer)
        {
            Caption = 'Line No.', comment = 'ESP="Nº línea"';
            NotBlank = true;
            DataClassification = ToBeClassified;
        }
        field(3; "BBT Status"; Code[20])
        {
            Caption = 'Status', comment = 'ESP="Estado"';
            TableRelation = "BBT Auxiliary Table States" where("BBT Type" = const("Status"));
            DataClassification = ToBeClassified;
        }
        field(4; "BBT Ref."; Code[20])
        {
            Caption = 'Ref.', comment = 'ESP="Ref."';
            DataClassification = ToBeClassified;
        }
        field(5; "BBT Model"; Text[100])
        {
            Caption = 'Model', comment = 'ESP="Modelo"';
            DataClassification = ToBeClassified;
        }
        field(6; "BBT Quantity"; Decimal)
        {
            Caption = 'Quantity', comment = 'ESP="Cantidad"';
            DataClassification = ToBeClassified;
        }
        field(7; "BBT Cntr Type"; Code[20])
        {
            Caption = 'Cntr Type', comment = 'ESP="Tipo Cntr"';
            TableRelation = "BBT Auxiliary Table States" where("BBT Type" = const("Cntr Type"));
            DataClassification = ToBeClassified;
        }
        field(8; "BBT Vendor No."; Code[20])
        {
            Caption = 'Vendor No.', comment = 'ESP="Nº proveedor"';
            TableRelation = Vendor;
            NotBlank = false;
            DataClassification = ToBeClassified;
        }
        field(9; "BBT PM"; Code[50])
        {
            Caption = 'PM', comment = 'ESP="PM"';
            DataClassification = ToBeClassified;
        }
        field(10; "BBT Port"; Code[10])
        {
            Caption = 'Port', comment = 'ESP="Puerto"';
            DataClassification = ToBeClassified;
        }
        field(11; "BBT Agent"; Code[20])
        {
            Caption = 'Agent', comment = 'ESP="Agente"';
            TableRelation = "Salesperson/Purchaser";
            NotBlank = false;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                SalespersonPurchaser: Record "Salesperson/Purchaser";
            begin
                if SalespersonPurchaser.Get("BBT Agent") then
                    "BBT Agent Name" := SalespersonPurchaser.Name
                else
                    Clear("BBT Agent Name");
            end;
        }
        field(12; "BBT Agent Name"; Text[50])
        {
            Caption = 'Agent Name', comment = 'ESP="Nombre agente"';
            TableRelation = "Salesperson/Purchaser";
            NotBlank = false;
            DataClassification = ToBeClassified;
        }
        field(13; "BBT ETD PO"; Date)
        {
            Caption = 'ETD PO', comment = 'ESP="ETD PO"';
            DataClassification = ToBeClassified;
        }
        field(14; "BBT ETA Planning"; Date)
        {
            Caption = 'ETA Planning', comment = 'ESP="Planning ETA"';
            DataClassification = ToBeClassified;
        }
        field(15; "BBT Proforma"; Boolean)
        {
            Caption = 'Proforma', comment = 'ESP="Proforma"';
            DataClassification = ToBeClassified;
        }
        field(16; "BBT ETD PI"; Date)
        {
            Caption = 'ETD PI', comment = 'ESP="ETD PI"';
            DataClassification = ToBeClassified;
        }
        field(17; "BBT Payment Term"; Code[10])
        {
            Caption = 'Payment Term', comment = 'ESP="Término pago"';
            TableRelation = "Payment Terms";
            DataClassification = ToBeClassified;
        }
        field(18; "BBT LC Opening Date"; Date)
        {
            Caption = 'LC Opening Date', comment = 'ESP="Fecha apertura LC"';
            DataClassification = ToBeClassified;
        }
        field(19; "BBT LC Status"; Code[20])
        {
            Caption = 'LC Status', comment = 'ESP="Estado LC"';
            TableRelation = "BBT Auxiliary Table States" where("BBT Type" = const("Status LC"));
            DataClassification = ToBeClassified;
        }
        field(20; "BBT LC Date Received"; Date)
        {
            Caption = 'LC Date Received', comment = 'ESP="Fecha LC recibida"';
            DataClassification = ToBeClassified;
        }
        field(21; "BBT LC No."; Code[20])
        {
            Caption = 'LC No.', comment = 'ESP="Nº LC"';
            DataClassification = ToBeClassified;
        }
        field(22; "BBT Bank"; Code[20])
        {
            Caption = 'Bank', comment = 'ESP="Banco"';
            TableRelation = "Bank Account";
            NotBlank = false;
            DataClassification = ToBeClassified;
        }
        field(23; "BBT ETD LC"; Date)
        {
            Caption = 'ETD LC', comment = 'ESP="ETD LC"';
            DataClassification = ToBeClassified;
        }
        field(24; "BBT Inspection"; Date)
        {
            Caption = 'Inspection', comment = 'ESP="Inspección"';
            DataClassification = ToBeClassified;
        }
        field(25; "BBT Result"; Code[20])
        {
            Caption = 'Result', comment = 'ESP="Resultado"';
            TableRelation = "BBT Auxiliary Table States" where("BBT Type" = const("Result"));
            DataClassification = ToBeClassified;
        }
        field(26; "BBT Forwarder"; Code[20])
        {
            Caption = 'Forwarder', comment = 'ESP="Forwarder"';
            TableRelation = Vendor;
            NotBlank = false;
            DataClassification = ToBeClassified;
        }
        field(27; "BBT ENS"; Date)
        {
            Caption = 'ENS', comment = 'ESP="ENS"';
            DataClassification = ToBeClassified;
        }
        field(28; "BBT ETD"; Date)
        {
            Caption = 'ETD', comment = 'ESP="ETD"';
            DataClassification = ToBeClassified;
        }
        field(29; "BBT ETA"; Date)
        {
            Caption = 'ETA', comment = 'ESP="ETA"';
            DataClassification = ToBeClassified;
        }
        field(30; "BBT Comm. Planning/Promotions"; Text[80])
        {
            Caption = 'Comments Planning/Promotions', comment = 'ESP="Comentarios planning/promociones"';
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
        field(31; "BBT Type"; Enum "BBT Import Order Status Type")
        {
            Caption = 'Type', comment = 'ESP="Tipo"';
            DataClassification = ToBeClassified;
        }
        field(32; "BBT CDI Amount"; Decimal)
        {
            Caption = 'CDI Amount', comment = 'ESP="Importe CDI"';
            DataClassification = ToBeClassified;
        }
        field(33; "BBT Shipping Date"; Date)
        {
            Caption = 'Shipping Date', comment = 'ESP="F/embarque"';
            DataClassification = ToBeClassified;
        }
        field(34; "BBT CDI Due Date"; Date)
        {
            Caption = 'CDI Due Date', comment = 'ESP="Fecha vto. CDI"';
            DataClassification = ToBeClassified;
        }
        field(35; "BBT Situation"; Code[20])
        {
            Caption = 'Situation', comment = 'ESP="Situación"';
            TableRelation = "BBT Auxiliary Table States" where("BBT Type" = const("Situation"));
            DataClassification = ToBeClassified;
        }
        field(36; "BBT Currency"; Code[10])
        {
            Caption = 'Currency', comment = 'ESP="Divisa"';
            TableRelation = Currency;
            DataClassification = ToBeClassified;
        }
        field(37; "BBT Bank Ref."; Code[20])
        {
            Caption = 'Bank Ref.', comment = 'ESP="Ref. bco."';
            DataClassification = ToBeClassified;
        }
        field(38; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code', comment = 'ESP="Codigo categoria Producto"';
            DataClassification = ToBeClassified;
        }
        field(39; "Qty. To receive"; Decimal)
        {
            Caption = 'Qty. To receive.', comment = 'ESP="Cantidad a recibir"';
            DataClassification = ToBeClassified;
            //TableRelation = "Purchase Line"."Qty. to Receive" where("Order No." = field("BBT Order No."), "Order Line No." = field("BBT Line No."));
        }
        field(40; "Status"; Enum "Purchase Document Status")
        {
            Caption = 'Status', comment = 'ESP="Estado"';
            DataClassification = ToBeClassified;
            // TableRelation = "Purchase Header".status where("No." = field("BBT Order No."));
        }
        field(41; "Status SGA"; option)
        {
            OptionCaption = ' ,SGA Sent,SGA Locked', Comment = 'ESP=" ,Enviado SGA,Bloqueado SGA"';
            OptionMembers = " ","Enviado SGA","Bloqueado SGA";
            //TableRelation = "Purchase Header"."Status SGA" where("No." = field("BBT Order No."));
        }
        field(42; "Payment Method Code"; code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Method Code', comment = 'ESP="Codigo Metodo de pago"';
            TableRelation = "Payment Method";
            //TableRelation = "Purchase Header"."Status SGA" where("No." = field("BBT Order No."));
        }
        field(43; "Lead Time Calculation"; DateFormula)
        {
            DataClassification = ToBeClassified;
            Caption = 'Lead Time Calculation', comment = 'ESP="Cálculo plazo de entrega"';
            //TableRelation = "Purchase Header"."Status SGA" where("No." = field("BBT Order No."));
        }
        field(44; "BBT Container No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'BBT Container No.', comment = 'ESP="BBT No. Contenedor"';
            //TableRelation = "Purchase Header"."Status SGA" where("No." = field("BBT Order No."));
        }
        field(45; "BBT Container Volume"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'BBT Container Volume', comment = 'ESP="BBT Volumen Contenedor"';
            //TableRelation = "Purchase Header"."Status SGA" where("No." = field("BBT Order No."));
        }
        field(46; "BBT Consolidated Shipment"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'BBT Consolidated Shipment', comment = 'ESP="BBT Albaran Consolidado"';
            //TableRelation = "Purchase Header"."Status SGA" where("No." = field("BBT Order No."));
        }
        field(47; "BBT Consolidation Reference"; text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'BBT Consolidation Reference', comment = 'ESP="BBT Referencia Consolidada"';
            //TableRelation = "Purchase Header"."Status SGA" where("No." = field("BBT Order No."));
        }
        field(48; "BBT Search Name"; code[100])
        {
            Caption = 'Search Name', comment = 'ESP="Proveedor"';
            DataClassification = ToBeClassified;
        }
        field(51132; "BBT Document Type"; Enum "Purchase Document Type")
        {
            Caption = 'Document Type', comment = 'ESP="Tipo de Documento"';
        }
        field(51133; "BBT Ship Name"; Text[50])
        {
            Caption = 'Ship Name', comment = 'ESP="Nombre del Barco"';
        }
        field(51134; "BBT Port POL"; Text[30])
        {
            TableRelation = "Shipment Method";
            Caption = 'Port of Loading', comment = 'ESP="Puerto de Origen"';
        }
        field(51135; "BBT Port POD"; Text[30])
        {
            TableRelation = "Shipment Method";
            Caption = 'Port of Discharge', Comment = 'ESP="Puerto de Descarga"';
        }
        field(51137; "BBT Forwarder Name"; Text[100])
        {
            Caption = 'Forwarder Name', Comment = 'ESP="Nombre Forwarder"';
            TableRelation = Vendor;
        }
        field(51138; "BBT Product Manager"; Code[20])
        {
            Caption = 'Product Manager', Comment = 'ESP="Responsable de Producto"';
            TableRelation = "BBT Auxiliary Table States" where("BBT Type" = const("Product Mgr"));
        }
        field(51142; "BBT Order Date"; Date)
        {
            Caption = 'Order Date', Comment = 'ESP="Fecha Pedido"';
        }
        field(51143; "BBT Qty To Receive"; Decimal)
        {
            Caption = 'Qty. to Receive', Comment = 'ESP="Cantidad a Recibir"';
        }
        field(51144; "BBT Quantity Received"; Decimal)
        {
            Caption = 'Quantity Received', Comment = 'ESP="Cantidad Recibida"';
        }
    }
    keys
    {
        key(PK; "BBT Order No.", "BBT Type", "BBT Line No.")
        {
            Clustered = true;
        }
    }
    Procedure MoveData(var pImportOrderStatutes: record "BBT Import Order Statuses"; pPurchaseLine: Record "Purchase Line")
    var
        rVendor: Record Vendor;
        rComment: Record "Purch. Comment Line";
        rPurchaseHeader: Record "Purchase Header";
    begin
        If rPurchaseHeader.Get(pPurchaseLine."Document Type", pPurchaseLine."Document No.") then;

        pImportOrderStatutes.reset;
        pImportOrderStatutes."BBT Document Type" := rPurchaseHeader."Document Type";
        pImportOrderStatutes."BBT Order No." := rPurchaseHeader."No.";
        pImportOrderStatutes."BBT Line No." := pPurchaseLine."Line No.";
        pImportOrderStatutes."BBT Order Date" := rPurchaseHeader."Order Date";
        pImportOrderStatutes."BBT Vendor No." := rPurchaseHeader."Buy-from Vendor No.";
        Clear(pImportOrderStatutes."BBT Search Name");
        if rVendor.Get(pPurchaseLine."Buy-from Vendor No.") then
            pImportOrderStatutes."BBT Search Name" := rVendor."Search Name";
        pImportOrderStatutes."Payment Method Code" := rPurchaseHeader."Payment Method Code";
        pImportOrderStatutes."BBT Payment Term" := rPurchaseHeader."Payment Terms Code";
        pImportOrderStatutes.Status := rPurchaseHeader.Status;
        pImportOrderStatutes."Status SGA" := rPurchaseHeader."Status SGA";
        //
        pImportOrderStatutes."BBT Agent" := rPurchaseHeader."Purchaser Code";
        pImportOrderStatutes."BBT Product Manager" := rPurchaseHeader."Product Manager";
        //
        pImportOrderStatutes."BBT ETD PO" := rPurchaseHeader."ETD PO";
        pImportOrderStatutes."BBT ETA Planning" := rPurchaseHeader."BBT ETA Planning";
        pImportOrderStatutes."BBT Proforma" := rPurchaseHeader."BBT Proforma";
        pImportOrderStatutes."BBT ETD PI" := rPurchaseHeader."BBT ETD PI";
        pImportOrderStatutes."BBT LC Opening Date" := rPurchaseHeader."BBT LC Opening Date";
        pImportOrderStatutes."BBT CDI Due Date" := rPurchaseHeader."BBT Due Date ETD PI";
        pImportOrderStatutes."BBT LC Status" := rPurchaseHeader."BBT LC Status";
        pImportOrderStatutes."BBT LC Date Received" := rPurchaseHeader."BBT LC Date Received";
        pImportOrderStatutes."BBT LC No." := rPurchaseHeader."BBT LC No.";
        pImportOrderStatutes."BBT Bank" := rPurchaseHeader."BBT Bank";
        pImportOrderStatutes."BBT ETD LC" := rPurchaseHeader."BBT ETD LC";
        //
        pImportOrderStatutes."BBT Ref." := pPurchaseLine."No.";
        pImportOrderStatutes."BBT Model" := pPurchaseLine.Description;
        pImportOrderStatutes."BBT Quantity" := pPurchaseLine.Quantity;
        pImportOrderStatutes."BBT Qty To Receive" := pPurchaseLine."Qty. to Receive";
        pImportOrderStatutes."BBT Quantity Received" := pPurchaseLine."Quantity Received";
        pImportOrderStatutes."BBT ETA Planning" := pPurchaseLine."BBT ETA Planning";
        pImportOrderStatutes."BBT Status" := pPurchaseLine."BBT Line Status";
        pImportOrderStatutes."BBT Inspection" := pPurchaseLine."BBT Inspection";
        pImportOrderStatutes."BBT Result" := pPurchaseLine."BBT Result";
        pImportOrderStatutes."BBT Forwarder" := pPurchaseLine."BBT Forwarder";
        Clear(pImportOrderStatutes."BBT Forwarder Name");
        if rVendor.Get(pPurchaseLine."BBT Forwarder") then
            pImportOrderStatutes."BBT Forwarder Name" := rVendor.Name;
        Clear(pImportOrderStatutes."BBT Comm. Planning/Promotions");
        rComment.SetRange("Document Type", rComment."Document Type"::Order);
        rComment.SetRange("No.", pPurchaseLine."Document No.");
        if rComment.FindLast() then
            pImportOrderStatutes."BBT Comm. Planning/Promotions" := rComment.Comment;
        pImportOrderStatutes."BBT ENS" := pPurchaseLine."BBT ENS";
        pImportOrderStatutes."BBT Cntr Type" := pPurchaseLine."BBT Cntr Type";
        pImportOrderStatutes."BBT Container No." := pPurchaseLine."Container Nr";
        pImportOrderStatutes."BBT Container Volume" := pPurchaseLine."Container Volume";
        pImportOrderStatutes."BBT Ship Name" := pPurchaseLine."Ship Name";
        pImportOrderStatutes."BBT Consolidated Shipment" := pPurchaseLine."Consolidated Shipment";
        pImportOrderStatutes."BBT Consolidation Reference" := pPurchaseLine."Consolidation Reference";
        pImportOrderStatutes."BBT Port POL" := pPurchaseLine."Port - POL";
        pImportOrderStatutes."BBT Port POD" := pPurchaseLine."Port - POD";
        pImportOrderStatutes."BBT ETD" := pPurchaseLine."ETD PO";
        pImportOrderStatutes."BBT ETA" := pPurchaseLine.ETA;

        pImportOrderStatutes.Insert;
    end;
}
