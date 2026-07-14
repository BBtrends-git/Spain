page 51109 "BBT Purch Import Order History"
{
    ApplicationArea = All;
    Caption = 'History Import Purchase Order', Comment = 'ESP="BBT Histórico Pedidos Importación"';
    PageType = List;
    SourceTable = "Purchase Line";
    UsageCategory = ReportsAndAnalysis;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("BBT Order No."; rec."Document No.")
                { }
                field("BBT Line No."; rec."Line No.")
                { }
                field("OrderDate"; rPurchaseHeader."Order Date")
                {
                    ToolTip = 'Specifies the value of the order date field', Comment = 'ESP="Especifica la fecha del pedido de compra"';
                    Caption = 'Order Date', Comment = 'ESP="Fecha Pedido"';
                }
                field("Search Name"; rVendor."Search Name")
                {
                    ToolTip = 'Specifies the value of the Search Name field', Comment = 'ESP="Especifica el alias del proveedor"';
                    Caption = 'vendor Search Name', Comment = 'ESP="Alias Proveedor"';
                }
                field("BBT Status"; rec."BBT Line Status")
                { }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the no. item field', Comment = 'ESP="Especifica el valor de número del producto"';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the item description field', Comment = 'ESP="Especifica el valor de la descripción del producto"';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the quantity field', Comment = 'ESP="Especifica el valor de la cantidad pedida"';
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ToolTip = 'Specifies the value of the received quantity field', Comment = 'ESP="Especifica el valor de la cantidad recibida"';
                }
                field("Purchaser"; rPurchaseHeader."Purchaser Code")
                {
                    ToolTip = 'Specifies the value of the Purchaser Code field', Comment = 'ESP="Especifica el valor del agente de compras"';
                    Caption = 'Purchaser Code', Comment = 'ESP="Comprador"';
                }
                field("Product Manager"; rPurchaseHeader."Product Manager")
                {
                    ToolTip = 'Specifies the value of the Product Manager field', Comment = 'ESP="Especifica el valor del responsable de producto"';
                    Caption = 'Product Manager', Comment = 'ESP="Responsable Producto (PM)"';
                }
                field("Payment Method Code"; rPurchaseHeader."Payment Method Code")
                {
                    ToolTip = 'Specifies the value of the payment method code field', Comment = 'ESP="Especifica el código del metodo de pago"';
                    Caption = 'Payment Method Code', Comment = 'ESP="Forma de Pago"';
                }
                field("Payment Terms Code"; rPurchaseHeader."Payment Terms Code")
                {
                    ToolTip = 'Specifies the value of the payment terms code field', Comment = 'ESP="Especifica el código del termino de pago"';
                    Caption = 'Payment Terms Code', Comment = 'ESP="Termino de Pago"';
                }
                field("BBT Line Status"; Rec."BBT Line Status")
                {
                    Caption = 'Status', Comment = 'ESP="Estado Importación"';
                    ToolTip = 'Specifies the value of the Line Status field', Comment = 'ESP="Especifica el estado de la línea del pedido"';
                }
                field("ETA Planning"; Rec."BBT ETA Planning")
                {
                    ToolTip = 'Specifies the value of the ETA Planning field', Comment = 'ESP="Especifica el valor de la fecha ETA planificada"';
                    Caption = 'ETA Planning', Comment = 'ESP="Fecha ETA planificada"';
                }
                field("ETD PO"; rPurchaseHeader."ETD PO")
                {
                    ToolTip = 'Specifies the value of the ETD PO field', Comment = 'ESP="Especifica el valor de la fecha ETD"';
                    Caption = 'ETD PO', Comment = 'ESP="Fecha ETD PO"';
                }
                field("Proforma"; rPurchaseHeader."BBT Proforma")
                {
                    ToolTip = 'Specifies the value of the Proforma field', Comment = 'ESP="Especifica la situación de la factura proforma"';
                    Caption = 'Proforma Invoice', Comment = 'ESP="Fra. Proforma"';
                }
                field("ETD PI"; rPurchaseHeader."BBT ETD PI")
                {
                    ToolTip = 'Specifies the value of the ETD PI field', Comment = 'ESP="Especifica el valor de la fecha ETD PI"';
                    Caption = 'ETD PI', Comment = 'ESP="Fecha ETD PI"';
                }
                field("LC Opening Date"; rPurchaseHeader."BBT LC Opening Date")
                {
                    ToolTip = 'Specifies the value of the LC Opening Date field', Comment = 'ESP="Especifica el valor de la fecha de opertura de la LC"';
                    Caption = 'LC Opening Date', Comment = 'ESP="Fecha Opertura LC"';
                }
                field("LC Status"; rPurchaseHeader."BBT LC Status")
                {
                    ToolTip = 'Specifies the value of the LC Status field', Comment = 'ESP="Especifica el valor del estado de la LC"';
                    Caption = 'LC Status', Comment = 'ESP="Estado LC"';
                }
                field("LC Date Received"; rPurchaseHeader."BBT LC Date Received")
                {
                    ToolTip = 'Specifies the value of the LC Date Received field', Comment = 'ESP="Especifica el valor de la fecha de recepción de la LC"';
                    Caption = 'LC Date Received', Comment = 'ESP="Fecha LC recibida"';
                }
                field("LC No."; rPurchaseHeader."BBT LC No.")
                {
                    ToolTip = 'Specifies the value of the LC No. field', Comment = 'ESP="Especifica el valor del número de la LC"';
                    Caption = 'LC No.', Comment = 'ESP="No. LC"';
                }
                field("Bank"; rPurchaseHeader."BBT Bank")
                {
                    ToolTip = 'Specifies the value of the Bank field', Comment = 'ESP="Especifica el valor del código del banco"';
                    Caption = 'LC Bank', Comment = 'ESP="Banco LC"';

                }
                field("ETD LC"; rPurchaseHeader."BBT ETD LC")
                {
                    ToolTip = 'Specifies the value of the ETD LC field', Comment = 'ESP="Especifica el valor de la fecha ETD LC"';
                    Caption = 'ETD LC', Comment = 'ESP="Fecha ETD LC"';
                }
                field("Inspection"; Rec."BBT Inspection")
                {
                    ToolTip = 'Specifies the value of the Inspection field', Comment = 'ESP="Especifica el valor de la inspección"';
                    Caption = 'Inspection', Comment = 'ESP="Inspección"';
                }
                field("Result"; Rec."BBT Result")
                {
                    ToolTip = 'Specifies the value of Result Inspecction field', Comment = 'ESP="Especifica el valor del estado de la inspección"';
                    Caption = 'Result Inspecction', Comment = 'ESP="Estado Inspección"';
                }
                field("Forwarder"; rForwarder.Name)
                {
                    ToolTip = 'Specifies the value of the Forwarder Name field', Comment = 'ESP="Especifica el valor del Nombre del Forwarder"';
                    Caption = 'Forwarder Name', Comment = 'ESP="Nombre Forwarder"';
                }
                field("ENS"; Rec."BBT ENS")
                {
                    ToolTip = 'Specifies the value of the ENS field', Comment = 'ESP="Especifica el valor de la fecha ENS"';
                    Caption = 'ENS', Comment = 'ESP="Fecha ENS"';
                }
                field("Container Type"; Rec."BBT Cntr Type")
                {
                    ToolTip = 'Specifies the value of the container type field', Comment = 'ESP="Especifica el tipo de contenedor"';
                    Caption = 'Container type', Comment = 'ESP="Tipo Contenedor"';
                }
                field("Container No."; Rec."Container Nr")
                {
                    ToolTip = 'Specifies the value of the Container No. field', Comment = 'ESP="Especifica el número de contenedor"';
                    Caption = 'Container No.', Comment = 'ESP="Número Contenedor"';
                }
                field("Container Volume"; Rec."Container Volume")
                {
                    ToolTip = 'Specifies the value of the BBT Container Volume field', Comment = 'ESP="Especifica el volumen Contenedor"';
                    Caption = 'Container Volume', Comment = 'ESP="Volumen Contenedor"';
                    BlankZero = true;
                }
                field("Ship Name"; Rec."Ship Name")
                {
                    ToolTip = 'Specifies the value of the Ship Name field', Comment = 'ESP="Especifica el nombre del barco"';
                    Caption = 'Ship Name', Comment = 'ESP="Nombre Barco"';
                }
                //<< Campo Obsoleto
                /*
                field("Consolidated Shipment"; Rec."Consolidated Shipment")
                {
                    ToolTip = 'Specifies the value of the BBT Consolidated Shipment field', Comment = 'ESP="Especifica el embarque consolidado"';
                    Caption = 'Consolidated Shipment', Comment = 'ESP="Embarque Consolidado"';
                }
                */
                //<<
                field("Consolidation Reference"; Rec."Consolidation Reference")
                {
                    ToolTip = 'Specifies the value of the BBT Consolidation Reference field', Comment = 'ESP="Especifica la referencia del embarque consolidado"';
                    Caption = 'Consolidation Reference', Comment = 'ESP="Referencia Consolidación"';
                }
                field("Port POL"; Rec."Port - POL")
                {
                    ToolTip = 'Specifies the value of the Port POL field', Comment = 'ESP="Especifica el valor del puerto de origen"';
                    Caption = 'Port of Loading', Comment = 'ESP="Puerto Origen"';
                }
                field("Port POD"; Rec."Port - POD")
                {
                    ToolTip = 'Specifies the value of the Port POD field', Comment = 'ESP="Especifica el valor del puerto de descarga"';
                    Caption = 'Port of Discharge', Comment = 'ESP="Puerto Descarga"';
                }
                field("Customs Clearance"; Rec."Customs Clearance")
                {
                    ToolTip = 'Specifies the value of the Customs Clearence', Comment = 'ESP="Especifica el valor del Despacho de Aduanas"';
                    Caption = 'Customs Clearance', comment = 'ESP="Despacho Aduana"';
                }
                field("Docs. to Forwarder"; Rec."Docs. to Forwarder")
                {
                    ToolTip = 'Specifies the value of the Docs Forwarder', Comment = 'ESP="Especifica el valor del Docs Forwarder"';
                    Caption = 'Docs Forwarder', comment = 'ESP="Docs Forwarder"';
                }
                field(Health; Rec.Health)
                {
                    ToolTip = 'Specifies Border Health and Quality Control', Comment = 'ESP="Especifica el Control Sanitario y de Calidad en Frontera"';
                    Caption = 'Health / RHOS', comment = 'ESP="Sanidad / RHOS"';
                }
                field("Plastics Control"; Rec."Plastics Control")
                {
                    ToolTip = 'Specifies the value of the Plastics Control', Comment = 'ESP="Especifica el valor del Control de Plásticos"';
                    Caption = 'Plastics Control', comment = 'ESP="Control Plásticos"';
                }
                field("Origin Certificate"; Rec."Origin Certificate")
                {
                    ToolTip = 'Specifies the value of the Origin Certificat ', Comment = 'ESP="Especifica el valor del Certificado de Origen"';
                    Caption = 'Origin Certificate', comment = 'ESP="Certificado Origen"';
                }
                field("BBT ENS"; Rec."BBT ENS")
                {
                    ToolTip = 'Specifies the value of the ENS field', Comment = 'ESP="Especifica el valor de la fecha ENS / Liberado"';
                    Caption = 'ENS', Comment = 'ESP="Fecha ENS / Liberado"';
                }
                field("ETD"; Rec."ETD PO")
                {
                    ToolTip = 'Specifies the value of the ETD field', Comment = 'ESP="Especifica el valor de la fecha ETD de salida de origen"';
                    Caption = 'ETD', Comment = 'ESP="Fecha ETD"';
                }
                field("BBT ETA"; Rec."ETA")
                {
                    ToolTip = 'Specifies the value of the ETA field', Comment = 'ESP="Especifica el valor de la fecha ETA de llegada a destino"';
                    Caption = 'ETA', Comment = 'ESP="Fecha ETA"';
                }
                field("Days on the Ship"; Rec."Days on the Ship")
                {
                    Caption = 'Days on the Ship', Comment = 'ESP="Dias en el Barco"';
                    ToolTip = 'Specifies the value of the days on the ship', Comment = 'ESP="Especifica los dias en el Barco"';
                }
                field("Days in port"; Rec."Days in port")
                {
                    Caption = 'Days in port', comment = 'ESP="Días en el puerto"';
                    ToolTip = 'Specifies the value of the days in port', Comment = 'ESP="Especifica los dias en el Puerto"';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location', Comment = 'ESP="Especifica el valor del Almacén"';
                    Caption = 'Location Code', Comment = 'ESP="Almacén"';
                }
                field("Warehouse Upload DateTime"; Rec."Warehouse Upload DateTime")
                {
                    ToolTip = 'Specifies the value of the date of arrival at the warehouse', Comment = 'ESP="Especifica la fecha de entrada en el Almacén';
                    Caption = 'Warehouse Upload Date', Comment = 'ESP="Fecha/Hora Entrada Almacén"';
                }
            }

        }
        area(factboxes)
        {
            part(VendorDetailsFactBox; "Vendor Details FactBox")
            {
                SubPageLink = "No." = field("Buy-from Vendor No.");
            }
            part(PurchOrderCommentFactBox; "BBT Purchase Order Com FactBox")
            {
                SubPageLink = "No." = field("Document No."), "Document Type" = field("Document Type");
            }
            part(PurchaseLineFactBox; "Purchase Line FactBox")
            {
                SubPageLink = "No." = field("No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Show Order")
            {
                Caption = 'Show Order', Comment = 'ESP="Mostrar pedido"';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    if PurchaseHeader.Get(Rec."Document Type"::Order, Rec."Document No.") then
                        Page.Run(Page::"Purchase Order", PurchaseHeader);
                end;
            }
            action("Comments")
            {
                Caption = 'Comments', Comment = 'ESP="Comentarios"';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Purch. Comment Sheet";
                RunPageLink = "Document Type" = field("Document Type"), "No." = field("Document No.");
                ToolTip = 'View or add comments for the record', Comment = 'ESP="Ver, Añadir o modificar los comentarios del registro"';
                ApplicationArea = Comments;
            }
        }
    }
    var
        rPurchaseSetup: Record "Purchases & Payables Setup";
        rPurchaseHeader: Record "Purchase Header";
        rVendor: Record Vendor;
        rForwarder: Record Vendor;

    trigger OnOpenPage()
    begin
        rPurchaseSetup.Get();
        rPurchaseSetup.TestField("BBT Vend. Post. Gr. Imp. Ord.");

        Rec.SetRange("Document Type", Rec."Document Type"::Order);
        Rec.SetRange(Type, Rec.Type::Item);
        Rec.SetFilter("Item Category Code", '1*|2*|3*|4*|5*|6*|7*|8*');
        Rec.Setrange("Qty. to Receive", 0);
        Rec.SetRange("Gen. Bus. Posting Group", rPurchaseSetup."BBT Vend. Post. Gr. Imp. Ord.");
    end;

    trigger OnAfterGetRecord()
    begin
        ReadPurchaseHeader(rPurchaseHeader);
        ReadVendor(rVendor);
        ReadForwarder(rForwarder)
    end;

    trigger OnModifyRecord(): Boolean
    begin

    end;

    trigger OnClosePage()
    begin

    end;

    local procedure ReadPurchaseHeader(var pPurchaseHeader: Record "Purchase Header")
    begin
        pPurchaseHeader.Reset();
        pPurchaseHeader.SetRange("Document Type", pPurchaseHeader."Document Type"::Order);
        pPurchaseHeader.SetRange("No.", rec."Document No.");
        if pPurchaseHeader.FindFirst() then;
    end;

    local procedure ReadVendor(var pVendor: Record "Vendor")
    begin
        pVendor.Reset();
        if PVendor.get(Rec."Buy-from Vendor No.") then;
    End;

    local procedure ReadForwarder(var pVendor: Record "Vendor")
    begin
        pVendor.Reset();
        if PVendor.get(Rec."BBT Forwarder") then;
    end;
}
