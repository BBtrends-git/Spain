page 51110 "BBT Import Order Status"
{
    ApplicationArea = All;
    Caption = 'Import Purchase Order Status', Comment = 'ESP="BBT Estado Pedidos Importación"';
    PageType = List;
    SourceTable = "BBT Import Order Status";
    UsageCategory = ReportsAndAnalysis;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = false;
    Permissions = tableData "Purchase Line" = M, tableData "Purchase Header" = M, tableData "BBT Import Order Status" = M; //, tableData "BBT Import Order Statuses" = M;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                FreezeColumn = "BBT Line No.";
                field("BBT Session Id"; Rec."BBT Session Id")
                {
                    Editable = false;
                    Style = Strong;
                    Visible = false;
                }
                field("BBT Order No."; Rec."BBT Order No.")
                {
                    Editable = false;
                    Style = Strong;
                    Caption = 'Order No.', Comment = 'ESP="Nº pedido"';
                }
                field("BBT Line No."; Rec."BBT Line No.")
                {
                    Editable = false;
                    Style = Strong;
                    Caption = 'Line No.', Comment = 'ESP="Nº línea"';
                }
                field("OrderDate"; Rec."BBT Order Date")
                {
                    Caption = 'Order Date', Comment = 'ESP="Fecha Pedido"';
                    ToolTip = 'Specifies the value of the order date field', Comment = 'ESP="Especifica la fecha del pedido de compra"';
                    Editable = false;
                    Style = Strong;
                }
                field("Search Name"; Rec."BBT Search Name")
                {
                    ToolTip = 'Specifies the value of the Search Name field', Comment = 'ESP="Especifica el alias del proveedor"';
                    Caption = 'vendor Search Name', Comment = 'ESP="Alias Proveedor"';
                    Editable = false;
                    Style = Strong;
                }
                field("BBT Status"; rec."BBT Status")
                {
                    Caption = 'Status', Comment = 'ESP="Estado"';
                    Editable = true;
                    trigger OnValidate()
                    begin
                        rPurchaseLine.Reset();
                        rPurchaseLine.setrange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then begin
                            rPurchaseLine."BBT Line Status" := Rec."BBT Status";
                            rPurchaseLine.Modify;
                        end;

                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT Status" := Rec."BBT Status";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<
                    end;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field', Comment = 'ESP="Especifica el estatus del pedido"';
                    Caption = 'Order Status', Comment = 'ESP="Estado Pedido"';
                    Editable = false;
                    Visible = false;
                    Style = Strong;
                }
                field("Status SGA"; Rec."Status SGA")
                {
                    ToolTip = 'Specifies the value of the Status SGA field', Comment = 'ESP="Especifica el status del SGA"';
                    Caption = 'Status SGA', Comment = 'ESP="Estado SGA"';
                    Editable = false;
                    Style = Strong;
                    Visible = false;
                }
                field("No."; Rec."BBT Item No.")
                {
                    ToolTip = 'Specifies the value of the no. item field', Comment = 'ESP="Especifica el valor de número del producto"';
                    Caption = 'Item No.', Comment = 'ESP="Producto"';
                    Editable = false;
                    Style = Strong;
                }
                field(Description; Rec."BBT Model")
                {
                    ToolTip = 'Specifies the value of the item description field', Comment = 'ESP="Especifica el valor de la descripción del producto"';
                    Caption = 'Description', Comment = 'ESP="Descripción"';
                    Editable = false;
                    Style = Strong;
                }
                field(Quantity; Rec."BBT Quantity")
                {
                    ToolTip = 'Specifies the value of the quantity field', Comment = 'ESP="Especifica la cantidad pedida"';
                    Caption = 'Quantity', Comment = 'ESP="Cantidad"';
                    Editable = false;
                    Style = Strong;
                }
                field("Quantity Received"; Rec."BBT Quantity Received")
                {
                    ToolTip = 'Specifies the value of the received quantity field', Comment = 'ESP="Especifica la cantidad recibida"';
                    Caption = 'Quantity Received', Comment = 'ESP="Cantidad Recibida"';
                    Editable = false;
                    Style = Strong;
                }
                field("Qty. To receive"; Rec."BBT Qty To receive")
                {
                    ToolTip = 'Specifies the value of the quantity to receive field', Comment = 'ESP="Especifica la cantidad a recibir"';
                    Caption = 'Qty To receive', Comment = 'ESP="Cantidad a Recibir"';
                    Editable = false;
                    Style = Strong;
                }
                field("Direct Unit Cost"; Rec."BBT Direct Unit Cost")
                {
                    ToolTip = 'Specifies the value of the direct unit cost field', Comment = 'ESP="Especifica el valor del coste directo"';
                    Editable = false;
                    Style = Strong;
                }
                field("Line Amount"; Rec."BBT Line Amount")
                {
                    ToolTip = 'Specifies the value of the line amount field', Comment = 'ESP="Especifica el importe de la línea"';
                    Editable = false;
                    Style = Strong;
                }
                field("Currency Code"; Rec."BBT Currency Code")
                {
                    ToolTip = 'Specifies the value of the currency code field', Comment = 'ESP="Especifica el código de la divisa"';
                    Editable = false;
                    Style = Strong;
                }
                field("Purchaser"; Rec."BBT Agent")
                {
                    ToolTip = 'Specifies the value of the Purchaser Code field', Comment = 'ESP="Especifica el valor del agente de compras"';
                    Caption = 'Purchaser Code', Comment = 'ESP="Comprador"';
                    trigger OnValidate()
                    begin
                        Updatefields(Rec);
                        CurrPage.Update();

                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT Agent" := Rec."BBT Agent";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<    
                    end;
                }
                field("Product Manager"; rec."BBT Product Manager")
                {
                    ToolTip = 'Specifies the value of the Product Manager field', Comment = 'ESP="Especifica el valor del responsable de producto"';
                    Caption = 'Product Manager', Comment = 'ESP="Responsable Producto (PM)"';
                    trigger OnValidate()
                    begin
                        Updatefields(Rec);
                        CurrPage.Update();

                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT Product Manager" := Rec."BBT Product Manager";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<
                    end;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ToolTip = 'Specifies the value of the payment method code field', Comment = 'ESP="Especifica el código del metodo de pago"';
                    Caption = 'Payment Method Code', Comment = 'ESP="Forma de Pago"';
                    Editable = false;
                    Style = Strong;
                }
                field("Payment Terms Code"; Rec."BBT Payment Term")
                {
                    ToolTip = 'Specifies the value of the payment terms code field', Comment = 'ESP="Especifica el código del termino de pago"';
                    Caption = 'Payment Terms Code', Comment = 'ESP="Termino de Pago"';
                    Editable = false;
                    Style = Strong;
                }
                field("ETD PO"; Rec."BBT ETD PO")
                {
                    ToolTip = 'Specifies the value of the ETD PO field', Comment = 'ESP="Especifica el valor de la fecha ETD"';
                    Caption = 'ETD PO', Comment = 'ESP="Fecha ETD PO"';
                    Editable = false;
                    Style = StandardAccent;
                }
                field("Proforma"; Rec."BBT Proforma")
                {
                    ToolTip = 'Specifies the value of the Proforma field', Comment = 'ESP="Especifica la situación de la factura proforma"';
                    Caption = 'Proforma Invoice', Comment = 'ESP="Fra. Proforma"';
                    Editable = false;
                    Style = StandardAccent;
                }
                field("ETD PI"; Rec."BBT ETD PI")
                {
                    ToolTip = 'Specifies the value of the ETD PI field', Comment = 'ESP="Especifica el valor de la fecha ETD PI"';
                    Caption = 'ETD PI', Comment = 'ESP="Fecha ETD PI"';
                    Editable = false;
                    Style = StandardAccent;
                }
                field("LC Opening Date"; Rec."BBT LC Opening Date")
                {
                    ToolTip = 'Specifies the value of the LC Opening Date field', Comment = 'ESP="Especifica el valor de la fecha de opertura de la LC"';
                    Caption = 'LC Opening Date', Comment = 'ESP="Fecha Opertura LC"';
                    Editable = false;
                    Style = StandardAccent;
                }
                field("LC Status"; Rec."BBT LC Status")
                {
                    ToolTip = 'Specifies the value of the LC Status field', Comment = 'ESP="Especifica el valor del estado de la LC"';
                    Caption = 'LC Status', Comment = 'ESP="Estado LC"';
                    Editable = false;
                    Style = StandardAccent;
                }
                field("LC Date Received"; Rec."BBT LC Date Received")
                {
                    ToolTip = 'Specifies the value of the LC Date Received field', Comment = 'ESP="Especifica el valor de la fecha de recepción de la LC"';
                    Caption = 'LC Date Received', Comment = 'ESP="Fecha LC Recibida"';
                    Editable = false;
                    Style = StandardAccent;
                }
                field("LC No."; Rec."BBT LC No.")
                {
                    ToolTip = 'Specifies the value of the LC No. field', Comment = 'ESP="Especifica el valor del número de la LC"';
                    Caption = 'LC No.', Comment = 'ESP="No. LC"';
                    Editable = false;
                    Style = StandardAccent;
                }
                field("Bank"; Rec."BBT Bank")
                {
                    ToolTip = 'Specifies the value of the Bank field', Comment = 'ESP="Especifica el valor del código del banco"';
                    Caption = 'LC Bank', Comment = 'ESP="Banco LC"';
                    Editable = false;
                    Style = StandardAccent;
                }
                field("ETD LC"; Rec."BBT ETD LC")
                {
                    ToolTip = 'Specifies the value of the ETD LC field', Comment = 'ESP="Especifica el valor de la fecha ETD LC"';
                    Caption = 'ETD LC', Comment = 'ESP="Fecha ETD LC"';
                    Editable = false;
                    Style = StandardAccent;
                }
                field("ETA Planning"; Rec."BBT ETA Planning")
                {
                    ToolTip = 'Specifies the value of the ETA Planning field', Comment = 'ESP="Especifica el valor de la fecha ETA planificada"';
                    Caption = 'ETA Planning', Comment = 'ESP="Fecha ETA planificada"';
                    trigger OnValidate()
                    begin
                        rPurchaseLine.Reset();
                        rPurchaseLine.setrange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then begin
                            rPurchaseLine."BBT ETA Planning" := Rec."BBT ETA Planning";
                            rPurchaseLine.Modify;
                        end;
                        //>> BBT 13/05/2026. IMPORT STATUS. Se utiliza el desglose de LeadTimes del Producto
                        //// Anulada por tratarse de una fecha aproximada que induce a error
                        //// PurchaseCalcDates();
                        //<<
                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT ETA Planning" := Rec."BBT ETA Planning";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<
                    end;
                }
                field("Inspection"; Rec."BBT Inspection")
                {
                    ToolTip = 'Specifies the value of the Inspection field', Comment = 'ESP="Especifica el valor de la inspección"';
                    Caption = 'Inspection', Comment = 'ESP="Inspección"';
                    trigger OnValidate()
                    begin
                        rPurchaseLine.Reset();
                        rPurchaseLine.setrange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then begin
                            rPurchaseLine."BBT Inspection" := Rec."BBT Inspection";
                            rPurchaseLine.Modify;
                        end;
                        //>> BBT 13/05/2026. IMPORT STATUS. Se utiliza el desglose de LeadTimes del Producto
                        PurchaseCalcDates();
                        //<<

                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT Inspection" := Rec."BBT Inspection";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<
                    end;
                }
                field("Result"; Rec."BBT Result")
                {
                    ToolTip = 'Specifies the value of Result Inspecction field', Comment = 'ESP="Especifica el valor del estado de la inspección"';
                    Caption = 'Result Inspecction', Comment = 'ESP="Estado Inspección"';
                    trigger OnValidate()
                    begin
                        rPurchaseLine.Reset();
                        rPurchaseLine.setrange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then begin
                            rPurchaseLine."BBT Result" := Rec."BBT Result";
                            rPurchaseLine.Modify;
                        end;

                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT Result" := Rec."BBT Result";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<
                    end;
                }
                field("Forwarder"; Rec."BBT Forwarder Name")
                {
                    ToolTip = 'Specifies the value of the Forwarder Name field', Comment = 'ESP="Especifica el valor del Nombre del Forwarder"';

                    trigger OnValidate()
                    begin
                        if Rec."BBT Forwarder Name" <> '' Then begin
                            rVendor.Reset();
                            rVendor.SetRange(Name, Rec."BBT Forwarder Name");
                            if rVendor.FindFirst() then begin
                                Rec."BBT Forwarder" := rVendor."No.";
                                Rec."BBT Forwarder Name" := rVendor.Name;
                            end
                            else begin
                                Clear(Rec."BBT Forwarder");
                                Clear(Rec."BBT Forwarder Name");
                            end;
                        end
                        else begin
                            Clear(Rec."BBT Forwarder");
                        end;

                        rPurchaseLine.Reset();
                        rPurchaseLine.setrange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then begin
                            rPurchaseLine."BBT Forwarder" := Rec."BBT Forwarder";
                            rPurchaseLine.Modify;
                        end;

                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT Forwarder" := Rec."BBT Forwarder";
                                rImportOrderStatusAUX."BBT Forwarder Name" := Rec."BBT Forwarder Name";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<
                    end;
                }
                field("Container Type"; Rec."BBT Cntr Type")
                {
                    ToolTip = 'Specifies the value of the container type field', Comment = 'ESP="Especifica el tipo de contenedor"';
                    Caption = 'Container type', Comment = 'ESP="Tipo Contenedor"';
                    trigger OnValidate()
                    begin
                        rPurchaseLine.Reset();
                        rPurchaseLine.setrange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then begin
                            rPurchaseLine."BBT Cntr Type" := Rec."BBT Cntr Type";
                            rPurchaseLine.Modify;
                        end;

                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT Cntr Type" := Rec."BBT Cntr Type";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<
                    end;
                }
                field("Container No."; Rec."BBT Container No.")
                {
                    ToolTip = 'Specifies the value of the Container No. field', Comment = 'ESP="Especifica el número de contenedor"';
                    Caption = 'Container No.', Comment = 'ESP="Número Contenedor"';
                    trigger OnValidate()
                    begin
                        rPurchaseLine.Reset();
                        rPurchaseLine.setrange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then begin
                            rPurchaseLine."Container Nr" := Rec."BBT Container No.";
                            rPurchaseLine.Modify;
                        end;

                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT Container No." := Rec."BBT Container No.";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<
                    end;
                }
                field("Container Volume"; Rec."BBT Container Volume")
                {
                    ToolTip = 'Specifies the value of the BBT Container Volume field', Comment = 'ESP="Especifica el volumen Contenedor"';
                    Caption = 'Container Volume', Comment = 'ESP="Volumen Contenedor"';
                    Editable = true;
                    BlankZero = true;
                    trigger OnValidate()
                    begin
                        rPurchaseLine.Reset();
                        rPurchaseLine.setrange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then begin
                            rPurchaseLine."Container Volume" := Rec."BBT Container Volume";
                            rPurchaseLine.Modify;
                        end;

                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT Container Volume" := Rec."BBT Container Volume";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<
                    end;
                }
                field("Ship Name"; Rec."BBT Ship Name")
                {
                    ToolTip = 'Specifies the value of the Ship Name field', Comment = 'ESP="Especifica el nombre del barco"';
                    Caption = 'Ship Name', Comment = 'ESP="Nombre Barco"';
                    Editable = true;
                    trigger OnValidate()
                    begin
                        rPurchaseLine.Reset();
                        rPurchaseLine.setrange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then begin
                            rPurchaseLine."Ship Name" := Rec."BBT Ship Name";
                            rPurchaseLine.Modify;
                        end;

                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT Ship Name" := Rec."BBT Ship Name";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<
                    end;
                }
                //>> Campo obsoleto
                /*
                field("Consolidated Shipment"; Rec."BBT Consolidated Shipment")
                {
                    ToolTip = 'Specifies the value of the BBT Consolidated Shipment field', Comment = 'ESP="Especifica el embarque consolidado"';
                    Caption = 'Consolidated Shipment', Comment = 'ESP="Embarque Consolidado"';
                    Editable = true;
                    trigger OnValidate()
                    begin
                        rPurchaseLine.Reset();
                        rPurchaseLine.setrange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then begin
                            rPurchaseLine."Consolidated Shipment" := Rec."BBT Consolidated Shipment";
                            rPurchaseLine.Modify;
                        end;
                    end;
                }
                */
                //<<
                field("Consolidation Reference"; Rec."BBT Consolidation Reference")
                {
                    ToolTip = 'Specifies the value of the BBT Consolidation Reference field', Comment = 'ESP="Especifica la referencia del embarque consolidado"';
                    Caption = 'Consolidation Reference', Comment = 'ESP="Referencia Consolidación"';
                    Editable = true;
                    trigger OnValidate()
                    begin
                        rPurchaseLine.Reset();
                        rPurchaseLine.setrange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then begin
                            rPurchaseLine."Consolidation Reference" := Rec."BBT Consolidation Reference";
                            rPurchaseLine.Modify;
                        end;

                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT Consolidation Reference" := Rec."BBT Consolidation Reference";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<
                    end;
                }
                field(TrackingURL; TrackingURL)
                {
                    ToolTip = 'Specifies the value of the Tracking URL field', Comment = 'ESP="Especifica si existe URL de Seguimiento"';
                    Caption = 'Tracking URL', Comment = 'ESP="URL Seguimiento"';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        rPurchaseLine.SetRange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then
                            if rPurchaseLine."Shipping Tracking URL" <> '' then
                                Hyperlink(rPurchaseLine."Shipping Tracking URL");
                    end;
                }
                field("Port POL"; Rec."BBT Port POL")
                {
                    ToolTip = 'Specifies the value of the Port POL field', Comment = 'ESP="Especifica el valor del puerto de origen"';
                    Caption = 'Port of Loading', Comment = 'ESP="Puerto Origen"';
                    Editable = true;
                    trigger OnValidate()
                    begin
                        rPurchaseLine.Reset();
                        rPurchaseLine.setrange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then begin
                            rPurchaseLine."Port - POL" := Rec."BBT Port POL";
                            rPurchaseLine.Modify;
                        end;

                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT Port POL" := Rec."BBT Port POL";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<
                    end;
                }
                field("Port POD"; Rec."BBT Port POD")
                {
                    ToolTip = 'Specifies the value of the Port POD field', Comment = 'ESP="Especifica el valor del puerto de descarga"';
                    Caption = 'Port of Discharge', Comment = 'ESP="Puerto Descarga"';
                    Editable = true;
                    trigger OnValidate()
                    begin
                        rPurchaseLine.Reset();
                        rPurchaseLine.setrange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then begin
                            rPurchaseLine."Port - POD" := Rec."BBT Port POD";
                            rPurchaseLine.Modify;
                        end;

                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT Port POD" := Rec."BBT Port POD";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<
                    end;
                }
                field("BBT Customs Clearence"; Rec."BBT Customs Clearence")
                {
                    ToolTip = 'Specifies the value of the Customs Clearence', Comment = 'ESP="Especifica el valor del Despacho de Aduanas"';
                    Caption = 'Customs Clearance', comment = 'ESP="Despacho Aduana"';

                    trigger OnValidate()
                    begin
                        rPurchaseLine.Reset();
                        rPurchaseLine.setrange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then begin
                            rPurchaseLine."Customs Clearance" := Rec."BBT Customs Clearence";
                            rPurchaseLine.Modify;
                        end;

                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT Customs Clearence" := Rec."BBT Customs Clearence";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<
                    end;
                }
                field("BBT Docs Forwarder"; Rec."BBT Docs Forwarder")
                {
                    ToolTip = 'Specifies the value of the Docs Forwarder', Comment = 'ESP="Especifica el valor del Docs Forwarder"';
                    Caption = 'Docs Forwarder', comment = 'ESP="Docs Forwarder"';

                    trigger OnValidate()
                    begin
                        rPurchaseLine.Reset();
                        rPurchaseLine.setrange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then begin
                            rPurchaseLine."Docs. to Forwarder" := rec."BBT Docs Forwarder";
                            rPurchaseLine.Modify;
                        end;

                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT Docs Forwarder" := Rec."BBT Docs Forwarder";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<
                    end;
                }
                field("BBT Health"; Rec."BBT Health")
                {
                    ToolTip = 'Specifies Border Health and Quality Control', Comment = 'ESP="Especifica el Control Sanitario y de Calidad en Frontera"';
                    Caption = 'Health / RHOS', comment = 'ESP="Sanidad / RHOS"';

                    trigger OnValidate()
                    begin
                        rPurchaseLine.Reset();
                        rPurchaseLine.setrange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then begin
                            rPurchaseLine.Health := Rec."BBT Health";
                            rPurchaseLine.Modify;
                        end;

                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT Health" := Rec."BBT Health";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<
                    end;
                }
                field("BBT Plastics Control"; Rec."BBT Plastics Control")
                {
                    ToolTip = 'Specifies the value of the Plastics Control', Comment = 'ESP="Especifica el valor del Control de Plásticos"';
                    Caption = 'Plastics Control', comment = 'ESP="Control Plásticos"';

                    trigger OnValidate()
                    begin
                        rPurchaseLine.Reset();
                        rPurchaseLine.setrange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then begin
                            rPurchaseLine."Plastics Control" := Rec."BBT Plastics Control";
                            rPurchaseLine.Modify;
                        end;

                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT Plastics Control" := Rec."BBT Plastics Control";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<
                    end;
                }
                field("BBT Origin Certificate"; Rec."BBT Origin Certificate")
                {
                    ToolTip = 'Specifies the value of the Origin Certificat ', Comment = 'ESP="Especifica el valor del Certificado de Origen"';
                    Caption = 'Origin Certificate', comment = 'ESP="Certificado Origen"';

                    trigger OnValidate()
                    begin
                        rPurchaseLine.Reset();
                        rPurchaseLine.setrange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then begin
                            rPurchaseLine."Origin Certificate" := Rec."BBT Origin Certificate";
                            rPurchaseLine.Modify;
                        end;

                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT Origin Certificate" := Rec."BBT Origin Certificate";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<
                    end;
                }
                field("ENS"; Rec."BBT ENS")
                {
                    ToolTip = 'Specifies the value of the ENS field', Comment = 'ESP="Especifica el valor de la fecha ENS / Liberado"';
                    Caption = 'ENS', Comment = 'ESP="Fecha ENS / Liberado"';
                    trigger OnValidate()
                    begin
                        rPurchaseLine.Reset();
                        rPurchaseLine.setrange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then begin
                            rPurchaseLine."BBT ENS" := Rec."BBT ENS";
                            rPurchaseLine.Modify;
                        end;

                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT ENS" := Rec."BBT ENS";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<
                    end;
                }
                field("ETD"; Rec."BBT ETD")
                {
                    ToolTip = 'Specifies the value of the ETD field', Comment = 'ESP="Especifica el valor de la fecha ETD de salida de origen"';
                    Caption = 'ETD', Comment = 'ESP="Fecha ETD"';
                    Editable = true;
                    trigger OnValidate()
                    begin
                        rPurchaseLine.Reset();
                        rPurchaseLine.setrange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then begin
                            rPurchaseLine."ETD PO" := Rec."BBT ETD";

                            Clear(Rec."BBT Days on the Ship");
                            Clear(rPurchaseLine."Days on the Ship");
                            if (rec."BBT ETD" <> 0D) and (Rec."BBT ETA" <> 0D) then begin
                                Rec."BBT Days on the Ship" := Rec."BBT ETA" - rec."BBT ETD";
                                rPurchaseLine."Days on the Ship" := Rec."BBT Days on the Ship";
                            end;

                            rPurchaseLine.Modify;
                        end;

                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT ETD" := Rec."BBT ETD";
                                rImportOrderStatusAUX."BBT Days on the Ship" := Rec."BBT Days on the Ship";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<
                    end;
                }
                field("BBT Days on the Ship"; Rec."BBT Days on the Ship")
                {
                    Editable = false;
                }
                field("BBT ETA"; Rec."BBT ETA")
                {
                    ToolTip = 'Specifies the value of the ETA field', Comment = 'ESP="Especifica el valor de la fecha ETA de llegada a destino"';
                    Caption = 'ETA', Comment = 'ESP="Fecha ETA"';
                    Editable = true;
                    trigger OnValidate()
                    begin
                        rPurchaseLine.Reset();
                        rPurchaseLine.setrange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then begin
                            rPurchaseLine.ETA := Rec."BBT ETA";

                            Clear(Rec."BBT Days on the Ship");
                            Clear(rPurchaseLine."Days on the Ship");
                            if (rec."BBT ETD" <> 0D) and (Rec."BBT ETA" <> 0D) then begin
                                Rec."BBT Days on the Ship" := Rec."BBT ETA" - rec."BBT ETD";
                                rPurchaseLine."Days on the Ship" := Rec."BBT Days on the Ship";
                            end;

                            Clear(Rec."BBT Days in Port");
                            Clear(rPurchaseLine."Days in Port");
                            if (rec."BBT Warehouse Upload DateTime" <> 0DT) and (Rec."BBT ETA" <> 0D) then begin
                                Rec."BBT Days in Port" := DT2DATE(Rec."BBT Warehouse Upload DateTime") - Rec."BBT ETA" + 1;
                                rPurchaseLine."Days in Port" := Rec."BBT Days in Port";
                            end;

                            rPurchaseLine.Modify;
                        end;

                        //>> BBT 13/05/2026. IMPORT STATUS. Se utiliza el desglose de LeadTimes del Producto
                        PurchaseCalcDates();
                        //<<

                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT ETA" := Rec."BBT ETA";
                                rImportOrderStatusAUX."BBT Days in Port" := Rec."BBT Days in Port";
                                rImportOrderStatusAUX."BBT Days on the Ship" := Rec."BBT Days on the Ship";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<
                    end;
                }
                field("BBT Days in Port"; Rec."BBT Days in Port")
                {
                    Editable = false;
                }
                field("BBT Warehouse Upload DateTime"; Rec."BBT Warehouse Upload DateTime")
                {
                    ToolTip = 'Specifies the value of the date of arrival at the warehouse', Comment = 'ESP="Especifica la fecha de entrada en el Almacén';
                    Caption = 'Warehouse Upload Date', Comment = 'ESP="Fecha/Hora Entrada Almacén"';
                    Editable = true;
                    trigger OnValidate()
                    begin
                        rPurchaseLine.Reset();
                        rPurchaseLine.setrange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then begin
                            rPurchaseLine."Warehouse Upload DateTime" := rec."BBT Warehouse Upload DateTime";

                            Clear(Rec."BBT Days in Port");
                            Clear(rPurchaseLine."Days in Port");
                            if (rec."BBT Warehouse Upload DateTime" <> 0DT) and (Rec."BBT ETA" <> 0D) then begin
                                Rec."BBT Days in Port" := DT2DATE(Rec."BBT Warehouse Upload DateTime") - Rec."BBT ETA" + 1;
                                rPurchaseLine."Days in Port" := Rec."BBT Days in Port";
                            end;

                            rPurchaseLine.Modify;
                        end;

                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT Warehouse Upload DateTime" := Rec."BBT Warehouse Upload DateTime";
                                rImportOrderStatusAUX."BBT Days in Port" := Rec."BBT Days in Port";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<
                    end;
                }
                field("BBT Location Code"; Rec."BBT Location Code")
                {
                    ToolTip = 'Specifies the value of the Location', Comment = 'ESP="Especifica el valor del Almacén"';
                    Caption = 'Location Code', Comment = 'ESP="Almacén"';
                    Editable = true;
                    trigger OnValidate()
                    begin
                        rPurchaseLine.Reset();
                        rPurchaseLine.setrange("Document Type", Rec."BBT Document Type");
                        rPurchaseLine.SetRange("Document No.", Rec."BBT Order No.");
                        rPurchaseLine.SetRange("Line No.", Rec."BBT Line No.");
                        if rPurchaseLine.FindFirst() then begin
                            rPurchaseLine."Location Code" := rec."BBT Location Code";
                            rPurchaseLine.Modify;
                        end;

                        //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                        rImportOrderStatusAUX.Reset();
                        rImportOrderStatusAUX.SetFilter("BBT Session Id", '<>%1', Rec."BBT Session Id");
                        rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                        rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                        rImportOrderStatusAUX.SetRange("BBT Line No.", Rec."BBT Line No.");
                        if rImportOrderStatusAUX.FindSet() then
                            repeat
                                rImportOrderStatusAUX."BBT Location Code" := Rec."BBT Location Code";
                                rImportOrderStatusAUX.Modify();
                            until rImportOrderStatusAUX.Next() = 0;
                        //<<
                    end;
                }
                field("BBT Comm. Planning/Promotions"; Rec."BBT Comm. Planning/Promotions")
                {
                    ToolTip = 'Specifies the value of the Comments field', Comment = 'ESP="Especifica el valor del campo Comentarios"';
                    Caption = 'Comments', Comment = 'ESP="Comentarios"';
                    Editable = false;
                }
            }
            group(InformaciónImport)
            {
                Caption = 'Purchase Order Import Information', Comment = 'ESP="Información Importación"';
                //ShowCaption = false;
                part(PurchHeader; "BBT Purch Import Subform")
                {
                    Editable = true;
                    Enabled = true;
                    //SubPageLink = "No." = field("BBT Order No."), "Document Type" = field("BBT Document Type");
                    SubPageLink = "No." = field("BBT Order No."), "Document Type" = field("BBT Document Type");
                    UpdatePropagation = Both;
                }
            }
        }
        area(factboxes)
        {
            part(VendorDetailsFactBox; "Vendor Details FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("BBT Vendor No.");
            }
            part(PurchOrderCommentFactBox; "BBT Purchase Order Com FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("BBT Order No."), "Document Type" = field("BBT Document Type");
            }
            part(BBTPurchaseTrackingFactbox; "BBT Purchase Tracking Factbox")
            {
                ApplicationArea = All;
                SubPageLink = "Document Type" = field("BBT Document Type"), "Document No." = field("BBT Order No."), "Line No." = field("BBT Line No.");
            }
            part(PurchaseLineFactBox; "Purchase Line FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("BBT Item No.");
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
                    if PurchaseHeader.Get(Rec."BBT Document Type"::Order, Rec."BBT Order No.") then
                        Page.Run(Page::"Purchase Order", PurchaseHeader);
                end;
            }
            action(Comments)
            {
                Caption = 'Comments', Comment = 'ESP="Comentarios"';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Process;
                //RunObject = Page "Purch. Comment Sheet";
                //RunPageLink = "Document Type" = field("BBT Document Type"), "No." = field("BBT Order No.");
                ToolTip = 'View or add comments for the record', Comment = 'ESP="Ver, Añadir o modificar los comentarios del registro"';
                ApplicationArea = Comments;

                trigger OnAction()
                var
                    pPurchCommentSheet: Page "Purch. Comment Sheet";
                    rPurchCommentLine: Record "Purch. Comment Line";
                begin
                    rPurchCommentLine.Reset();
                    rPurchCommentLine.SetRange("Document Type", Rec."BBT Document Type");
                    rPurchCommentLine.SetRange("No.", Rec."BBT Order No.");
                    pPurchCommentSheet.SetTableView(rPurchCommentLine);
                    pPurchCommentSheet.RunModal();

                    //>> Actualización de la 'Import Order Status' para el resto de 'Session ID'
                    rPurchCommentLine.Reset();
                    rPurchCommentLine.SetRange("Document Type", Rec."BBT Document Type");
                    rPurchCommentLine.SetRange("No.", rec."BBT Order No.");
                    rPurchCommentLine.SetFilter(Comment, '<>%1', '');
                    if rPurchCommentLine.Findlast() then;

                    rImportOrderStatusAUX.Reset();
                    rImportOrderStatusAUX.SetRange("BBT Document Type", Rec."BBT Document Type");
                    rImportOrderStatusAUX.SetRange("BBT Order No.", Rec."BBT Order No.");
                    if rImportOrderStatusAUX.FindSet() then
                        repeat
                            rImportOrderStatusAUX."BBT Comm. Planning/Promotions" := rPurchCommentLine.Comment;
                            rImportOrderStatusAUX.Modify();
                        until rImportOrderStatusAUX.Next() = 0;
                    //    
                end;
            }
        }
    }
    var
        // Selección
        rPurchaseSetup: Record "Purchases & Payables Setup";
        rPurchaseLineSelec: Record "Purchase Line";
        rPurchaseHeaderSelec: Record "Purchase Header";
        // Gestion    
        rPurchaseLine: Record "Purchase Line";
        rImportOrderStatusAUX: Record "BBT Import Order Status";
        //rPurchaseHeader: Record "Purchase Header";
        rVendor: Record Vendor;
        //rCountry: Record "Country/Region";
        //CountryName: Text[50];
        //TotalContainerVolume: Decimal;
        TrackingURL: Boolean;
        SessionNumber: Integer;

    trigger OnOpenPage()
    begin
        Clear(SessionNumber);
        SessionNumber := Rec.SessionNumber();
        rImportOrderStatusAUX.InitializeRecord(SessionNumber, Rec);

        //>> Si hay selección, solo los registros de la sesión actual
        rImportOrderStatusAUX.Reset();
        rImportOrderStatusAUX.SetRange("BBT Session Id", SessionId());
        if rImportOrderStatusAUX.FindSet() then
            repeat
                rPurchaseLineSelec.Reset();
                rPurchaseLineSelec.SetRange("Document Type", rPurchaseLineSelec."Document Type"::Order);
                rPurchaseLineSelec.SetRange("Document No.", rImportOrderStatusAUX."BBT Order No.");
                rPurchaseLineSelec.SetRange("Line No.", rImportOrderStatusAUX."BBT Line No.");
                if rPurchaseLineSelec.FindFirst() then begin
                    Rec.MoveData(SessionNumber, Rec, rPurchaseLineSelec);
                    rImportOrderStatusAUX.Delete();
                end;
            until rImportOrderStatusAUX.Next() = 0;
        //<<

        // Si no hay selección.
        Rec.Reset();
        Rec.SetRange("BBT Session Id", SessionNumber);
        if Rec.IsEmpty then begin
            //rImportOrderStatusAUX.InitializeRecord(Rec);

            rPurchaseSetup.Get();
            rPurchaseSetup.TestField("BBT Vend. Post. Gr. Imp. Ord.");

            rPurchaseHeaderSelec.Reset();
            rPurchaseLineSelec.Reset();

            rPurchaseHeaderSelec.SetRange("Document Type", rPurchaseHeaderSelec."Document Type"::Order);
            //rPurchaseHeaderSelec.SetRange("Gen. Bus. Posting Group", rPurchaseSetup."BBT Vend. Post. Gr. Imp. Ord.");
            rPurchaseHeaderSelec.SetRange("Completely Received", false);
            if rPurchaseHeaderSelec.FindSet() then begin
                repeat begin
                    If not rPurchaseHeaderSelec."Include Import Status" then begin
                        //Selección estandar de lineas de pedidos de importación productos acabados (Item Category)
                        rPurchaseLineSelec.Reset();
                        rPurchaseLineSelec.SetRange("Document Type", rPurchaseHeaderSelec."Document Type");
                        rPurchaseLineSelec.SetRange("Document No.", rPurchaseHeaderSelec."No.");
                        rPurchaseLineSelec.SetRange(Type, rPurchaseLineSelec.Type::Item);
                        rPurchaseLineSelec.SetFilter("Item Category Code", '1*|2*|3*|4*|5*|6*|7*|8*');
                        rPurchaseLineSelec.SetFilter("Qty. to Receive", '<>%1', 0);
                        rPurchaseLineSelec.SetRange("Gen. Bus. Posting Group", rPurchaseSetup."BBT Vend. Post. Gr. Imp. Ord.");
                        if rPurchaseLineSelec.FindSet() then
                            repeat
                                Rec.MoveData(SessionNumber, Rec, rPurchaseLineSelec);
                            until rPurchaseLineSelec.Next() = 0;
                    end
                    //Selección Especial de lineas de pedidos de importación para productos diversos
                    else begin
                        rPurchaseLineSelec.Reset();
                        rPurchaseLineSelec.SetRange("Document Type", rPurchaseHeaderSelec."Document Type");
                        rPurchaseLineSelec.SetRange("Document No.", rPurchaseHeaderSelec."No.");
                        rPurchaseLineSelec.SetRange(Type, rPurchaseLineSelec.Type::Item);
                        rPurchaseLineSelec.SetFilter("Qty. to Receive", '<>%1', 0);
                        if rPurchaseLineSelec.FindSet() then
                            repeat
                                Rec.MoveData(SessionNumber, Rec, rPurchaseLineSelec);
                            until rPurchaseLineSelec.Next() = 0;
                    end;
                end;

                until rPurchaseHeaderSelec.Next() = 0;
            end;
            // SOLO los registros de la sesión/selección actual
            Rec.Reset();
            //>>
            //Rec.SetRange("BBT Session Id", SessionId());
            Rec.SetRange("BBT Session Id", SessionNumber);
            //<<
            if Rec.FindSet() then;
        end;
    end;

    trigger OnInit()
    begin

    end;

    trigger OnClosePage()
    begin
        Rec.RemoveRecord(SessionNumber);
    end;

    trigger OnAfterGetRecord()
    begin
        //>> BBT. 08/06/2026. Existe Tracking.
        TrackingURL := false;
        if (Rec."BBT Shipping Tracking URL" <> '') then
            TrackingURL := true;
        //<<
    end;

    //>> BBT 13/05/2026. IMPORT STATUS. Se utiliza el desglose de LeadTimes del Producto
    local procedure PurchaseCalcDates();
    var
        rPurchaseHeader: Record "Purchase Header";
    begin
        rPurchaseHeader.Reset();
        rPurchaseHeader.SetRange("Document Type", Rec."BBT Document Type");
        rPurchaseHeader.SetRange("No.", Rec."BBT Order No.");
        if rPurchaseHeader.FindFirst() then
            rPurchaseHeader.ReCalcDates(rPurchaseHeader);
    end;
    //<<

    local procedure Updatefields(pImportOrder: Record "BBT Import Order Status");
    var
        rPurchaseHeader: Record "Purchase Header";
    begin
        if rPurchaseHeader.Get(pImportOrder."BBT Document Type", pImportOrder."BBT Order No.") then begin
            case true of
                rPurchaseHeader."Purchaser Code" <> pImportOrder."BBT Agent":
                    begin
                        rPurchaseHeader."Purchaser Code" := pImportOrder."BBT Agent";
                        rPurchaseHeader.Modify();
                    end;
                rPurchaseHeader."Product Manager" <> pImportOrder."BBT Product Manager":
                    begin
                        rPurchaseHeader."Product Manager" := pImportOrder."BBT Product Manager";
                        rPurchaseHeader.Modify();
                    end;
            end;
        end;
        CurrPage.Update();
    end;

    procedure UpdateHeaderFields(rPurchaseHeader: Record "Purchase Header");
    var
        rImportOrder: Record "BBT Import Order Status";
    begin
        rImportOrder.Reset();
        //>>
        //rImportOrder.SetRange("BBT Session Id", SessionId());
        //rImportOrder.SetRange("BBT Session Id", SessionNumber);
        //<<
        rImportOrder.SetRange("BBT Document Type", rPurchaseHeader."Document Type"::Order);
        rImportOrder.SetRange("BBT Order No.", rPurchaseHeader."No.");
        if rImportOrder.FindSet() then
            repeat
                if rImportOrder."BBT ETD PO" <> rPurchaseHeader."ETD PO" then
                    rImportOrder."BBT ETD PO" := rPurchaseHeader."ETD PO";
                if rImportOrder."BBT Proforma" <> rPurchaseHeader."BBT Proforma" then
                    rImportOrder."BBT Proforma" := rPurchaseHeader."BBT Proforma";
                if rImportOrder."BBT ETD PI" <> rPurchaseHeader."BBT ETD PI" then
                    rImportOrder."BBT ETD PI" := rPurchaseHeader."BBT ETD PI";
                if rImportOrder."BBT LC Opening Date" <> rPurchaseHeader."BBT LC Opening Date" then
                    rImportOrder."BBT LC Opening Date" := rPurchaseHeader."BBT LC Opening Date";
                if rImportOrder."BBT LC Status" <> rPurchaseHeader."BBT LC Status" then
                    rImportOrder."BBT LC Status" := rPurchaseHeader."BBT LC Status";
                if rImportOrder."BBT LC Date Received" <> rPurchaseHeader."BBT LC Date Received" then
                    rImportOrder."BBT LC Date Received" := rPurchaseHeader."BBT LC Date Received";
                if rImportOrder."BBT LC No." <> rPurchaseHeader."BBT LC No." then
                    rImportOrder."BBT LC No." := rPurchaseHeader."BBT LC No.";
                if rImportOrder."BBT Bank" <> rPurchaseHeader."BBT Bank" then
                    rImportOrder."BBT Bank" := rPurchaseHeader."BBT Bank";
                if rImportOrder."BBT ETD LC" <> rPurchaseHeader."BBT ETD LC" then
                    rImportOrder."BBT ETD LC" := rPurchaseHeader."BBT ETD LC";
                if rImportOrder."BBT Due Date ETD PI" <> rPurchaseHeader."BBT Due Date ETD PI" then
                    rImportOrder."BBT Due Date ETD PI" := rPurchaseHeader."BBT Due Date ETD PI";

                rImportOrder.Modify();

            until rImportOrder.Next() = 0;

        CurrPage.Update();

    end;
}