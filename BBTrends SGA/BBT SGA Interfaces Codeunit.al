codeunit 51452 "SGA Interfaces"
{
    Permissions = tabledata "Sales Shipment Header" = rm,
                tabledata "Sales Shipment Line" = rm;

    trigger OnRun();
    begin
    end;

    var
        rSGASetup: Record "SGA Setup";
        cuSGAManagement: Codeunit "SGA Management";
        SQLEstructura: Text[1024];
        rTempDoc: Record "Vendor Payment Buffer" temporary;
        Comilla: Label '''';
        LineaLote: Label '''Lote: %1  / Ctd.: %2''';
        ResponseTxt: text;
        SGACallProcedure: enum "SGA Call to Procedure";
        SGAJsonObject: JsonObject;
        ArrayJSONManagement: Codeunit "JSON Management";
        ObjectJSONManagement: Codeunit "JSON Management";
        Index: Integer;
        ValueText: Text;
        BloqueoDocumentoJsonObject: Text;


    //>> Tabla de Bloqueos
    procedure GrabarTablaBloqueo();
    var
        rSGABlockedDocuments: Record "SGA Blocked Documents";

    begin
        if not cuSGAManagement.IsSGAEnabled() then exit;
        cuSGAManagement.InitializeSGAConfiguration(rSGASetup);

        // Reseteo de la tabla de bloqueos.
        rSGABlockedDocuments.Reset();
        rSGABlockedDocuments.DeleteAll();

        rTempDoc.Reset();
        rTempDoc.DeleteAll();

        Clear(SGAJsonObject);
        SGAJsonObject.Add('filter', 'IdEmpresaERP eq ''' + CompanyName + '''');
        cuSGAManagement.HttpCall(SGACallProcedure::"Document Blocking", SGAJsonObject, ResponseTxt);
        //Read Json
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for Index := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            rTempDoc.init;
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, Index);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroDocumento', ValueText);
            rTempDoc."Vendor No." := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('TipoDocumento', ValueText);
            rTempDoc."Currency Code" := ValueText;
            if not rTempDoc.Find() then
                rTempDoc.Insert();
        end;

        if rTempDoc.FindSet() then
            repeat
                CASE rTempDoc."Currency Code" OF
                    '300':
                        begin
                            rSGABlockedDocuments.Reset();
                            rSGABlockedDocuments.SetRange("SGA Document Type", rSGABlockedDocuments."SGA Document Type"::Purchase);
                            rSGABlockedDocuments.SetRange("SGA Document No.", rTempDoc."Vendor No.");
                            if not rSGABlockedDocuments.FindFirst() then begin
                                rSGABlockedDocuments.Init();
                                rSGABlockedDocuments.Validate("SGA Document Type", rSGABlockedDocuments."SGA Document Type"::Purchase);
                                rSGABlockedDocuments.Validate("SGA Document No.", rTempDoc."Vendor No.");
                                rSGABlockedDocuments.Insert();
                            end;
                        end;
                    '200' .. '209':
                        begin
                            rSGABlockedDocuments.Reset();
                            rSGABlockedDocuments.SetRange("SGA Document Type", rSGABlockedDocuments."SGA Document Type"::Sales);
                            rSGABlockedDocuments.SetRange("SGA Document No.", rTempDoc."Vendor No.");
                            if not rSGABlockedDocuments.FindFirst() then begin
                                rSGABlockedDocuments.Init();
                                rSGABlockedDocuments.Validate("SGA Document Type", rSGABlockedDocuments."SGA Document Type"::Sales);
                                rSGABlockedDocuments.Validate("SGA Document No.", rTempDoc."Vendor No.");
                                rSGABlockedDocuments.Insert();
                            end;
                        end;
                    '370':
                        begin
                            rSGABlockedDocuments.Reset();
                            rSGABlockedDocuments.SetRange("SGA Document Type", rSGABlockedDocuments."SGA Document Type"::"Sales Return");
                            rSGABlockedDocuments.SetRange("SGA Document No.", rTempDoc."Vendor No.");
                            if not rSGABlockedDocuments.FindFirst() then begin
                                rSGABlockedDocuments.Init();
                                rSGABlockedDocuments.Validate("SGA Document Type", rSGABlockedDocuments."SGA Document Type"::"Sales Return");
                                rSGABlockedDocuments.Validate("SGA Document No.", rTempDoc."Vendor No.");
                                rSGABlockedDocuments.Insert();
                            end;
                        end;
                    '270':
                        begin
                            rSGABlockedDocuments.Reset();
                            rSGABlockedDocuments.SetRange("SGA Document Type", rSGABlockedDocuments."SGA Document Type"::"Purchase Return");
                            rSGABlockedDocuments.SetRange("SGA Document No.", rTempDoc."Vendor No.");
                            if not rSGABlockedDocuments.FindFirst() then begin
                                rSGABlockedDocuments.Init();
                                rSGABlockedDocuments.Validate("SGA Document Type", rSGABlockedDocuments."SGA Document Type"::"Purchase Return");
                                rSGABlockedDocuments.Validate("SGA Document No.", rTempDoc."Vendor No.");
                                rSGABlockedDocuments.Insert();
                            end;
                        end;
                    '310' .. '319':
                        begin
                            rSGABlockedDocuments.Reset();
                            rSGABlockedDocuments.SetRange("SGA Document Type", rSGABlockedDocuments."SGA Document Type"::Transfer);
                            rSGABlockedDocuments.SetRange("SGA Document No.", rTempDoc."Vendor No.");
                            if not rSGABlockedDocuments.FindFirst() then begin
                                rSGABlockedDocuments.Init();
                                rSGABlockedDocuments.Validate("SGA Document Type", rSGABlockedDocuments."SGA Document Type"::Transfer);
                                rSGABlockedDocuments.Validate("SGA Document No.", rTempDoc."Vendor No.");
                                rSGABlockedDocuments.Insert();
                            end;
                        end;
                    '210' .. '219':
                        begin
                            rSGABlockedDocuments.Reset();
                            rSGABlockedDocuments.SetRange("SGA Document Type", rSGABlockedDocuments."SGA Document Type"::Transfer);
                            rSGABlockedDocuments.SetRange("SGA Document No.", rTempDoc."Vendor No.");
                            if not rSGABlockedDocuments.FindFirst() then begin
                                rSGABlockedDocuments.Init();
                                rSGABlockedDocuments.Validate("SGA Document Type", rSGABlockedDocuments."SGA Document Type"::Transfer);
                                rSGABlockedDocuments.Validate("SGA Document No.", rTempDoc."Vendor No.");
                                rSGABlockedDocuments.Insert();
                            end;
                        end;
                end;
            until rTempDoc.Next() = 0;
    end;

    procedure LeerTablaBloqueo();
    var
        rSGABlockedDocuments: Record "SGA Blocked Documents";
        rPurchaseHeader: Record "Purchase Header";
        rSalesHeader: Record "Sales Header";
        rTransferHeader: Record "Transfer Header";
        rWarehouseShipmentHeader: Record "Warehouse Shipment Header";
        rWarehouseShipmentLine: Record "Warehouse Shipment Line";

    begin
        if not cuSGAManagement.IsSGAEnabled() then exit;
        cuSGAManagement.InitializeSGAConfiguration(rSGASetup);

        rSGABlockedDocuments.Reset();
        if rSGABlockedDocuments.FindSet() then
            repeat
                case rSGABlockedDocuments."SGA Document Type" of
                    rSGABlockedDocuments."SGA Document Type"::Sales:
                        begin
                            if rWarehouseShipmentHeader.get(rSGABlockedDocuments."SGA Document No.") then begin
                                // Documentos Envios Almacén
                                rWarehouseShipmentHeader."SGA Status" := rWarehouseShipmentHeader."SGA Status"::"SGA Locked";
                                rWarehouseShipmentHeader.Modify();
                                // Pedidos Ventas
                                rWarehouseShipmentLine.Reset();
                                rWarehouseShipmentLine.SetRange("No.", rSGABlockedDocuments."SGA Document No.");
                                rWarehouseShipmentLine.SetRange("Source Type", 37);
                                rWarehouseShipmentLine.SetRange("Source Subtype", 1);
                                rWarehouseShipmentLine.SetRange("Source Document", rWarehouseShipmentLine."Source Document"::"Sales Order");
                                rWarehouseShipmentLine.SetFilter("Qty. to Ship (Base)", '<>%1', 0);
                                if rWarehouseShipmentLine.FindSet() then
                                    repeat begin
                                        if rSalesHeader.Get(rWarehouseShipmentLine."Source Subtype",
                                                            rWarehouseShipmentLine."Source No.") then begin
                                            Evaluate(rSalesHeader."SGA Status", format(rSalesHeader."SGA Status"::"SGA Locked"));
                                            rSalesHeader.Modify();
                                        end;
                                    end;
                                    until rWarehouseShipmentLine.Next() = 0;
                            end;
                        end;
                    rSGABlockedDocuments."SGA Document Type"::"Sales Return":
                        if rSalesHeader.get(rSalesHeader."Document Type"::"Return Order", rSGABlockedDocuments."SGA Document No.") then begin
                            Evaluate(rSalesHeader."SGA Status", format(rSalesHeader."SGA Status"::"SGA Locked"));
                            rSalesHeader.Modify();
                        end;
                    rSGABlockedDocuments."SGA Document Type"::Purchase:
                        if rPurchaseHeader.get(rPurchaseHeader."Document Type"::Order, rSGABlockedDocuments."SGA Document No.") then begin
                            Evaluate(rPurchaseHeader."SGA Status", format(rPurchaseHeader."SGA Status"::"SGA Locked"));
                            rPurchaseHeader.Modify();
                        end;
                    rSGABlockedDocuments."SGA Document Type"::"Purchase Return":
                        if rPurchaseHeader.get(rPurchaseHeader."Document Type"::"Return Order", rSGABlockedDocuments."SGA Document No.") then begin
                            Evaluate(rPurchaseHeader."SGA Status", format(rPurchaseHeader."SGA Status"::"SGA Locked"));
                            rPurchaseHeader.Modify();
                        end;
                    rSGABlockedDocuments."SGA Document Type"::Transfer:
                        if rTransferHeader.get(rSGABlockedDocuments."SGA Document No.") then begin
                            Evaluate(rTransferHeader."SGA Status", format(rTransferHeader."SGA Status"::"SGA Locked"));
                            rTransferHeader.Modify();
                        end;
                end;
            until rSGABlockedDocuments.Next() = 0;
    end;
    //<<

    //>> Productos
    procedure GestionProducto(pItem: Record Item);
    var
        rItemIdentifier: Record "Item Identifier";
        rItemUDBase: Record "Item Unit of Measure";
        rItemUDCaja: Record "Item Unit of Measure";
        rItemUDPalet: Record "Item Unit of Measure";
        EAN13: Code[13];
        EAN14: Code[14];
        QuantBox: Decimal;
        FV: Option F,T;
        ControlLoteTXT: Text[1];
        LoteEntradaTXT: Text[1];
        LoteSalidasTXT: Text[1];
        DescripProducto: Text[100];
        Descripcorta: Text[100];
        CategoryLen: Integer;
    begin
        if not cuSGAManagement.IsSGAEnabled() then exit;
        cuSGAManagement.InitializeSGAConfiguration(rSGASetup);

        if not pItem."SGA Item Management" then exit;

        clear(EAN13);
        Clear(EAN14);
        Clear(QuantBox);
        clear(ControlLoteTXT);
        Clear(LoteEntradaTXT);
        Clear(LoteSalidasTXT);
        rItemIdentifier.SetRange("Item No.", pItem."No.");
        rItemIdentifier.SetRange("Unit of Measure Code", pItem."Base Unit of Measure");
        if rItemIdentifier.FindFirst() then EAN13 := rItemIdentifier.Code;
        rItemIdentifier.SetRange("Item No.", pItem."No.");
        rItemIdentifier.SetRange("Unit of Measure Code", rSGASetup."Box Unit");
        if rItemIdentifier.FindFirst() then EAN14 := rItemIdentifier.Code;
        rItemUDCaja.Reset();
        rItemUDCaja.SetRange("Item No.", pItem."No.");
        rItemUDCaja.SetRange(Code, rSGASetup."Box Unit");
        if rItemUDCaja.FindFirst() then
            QuantBox := rItemUDCaja."Qty. per Unit of Measure"
        else
            CLEAR(rItemUDCaja);
        rItemUDPalet.Reset();
        rItemUDPalet.SetRange("Item No.", pItem."No.");
        rItemUDPalet.SetRange(Code, rSGASetup."Palet Unit");
        if NOT rItemUDPalet.FindFirst() then CLEAR(rItemUDPalet);
        rItemUDBase.Reset();
        rItemUDBase.SetRange("Item No.", pItem."No.");
        rItemUDBase.SetRange(Code, pItem."Base Unit of Measure");
        if NOT rItemUDBase.FindFirst() then CLEAR(rItemUDBase);
        if pItem."SGA Batch Management" then
            ControlLoteTXT := 'T'
        else
            ControlLoteTXT := 'F';
        if pItem."SGA Forced Batch Purchases" then
            LoteEntradaTXT := 'T'
        else
            LoteEntradaTXT := 'F';
        if pItem."SGA Forced Batch Sales" then
            LoteSalidasTXT := 'T'
        else
            LoteSalidasTXT := 'F';

        DescripProducto := pItem.Description;
        Descripcorta := pItem.Description;

        cuSGAManagement.ReemplazarCaracter(DescripProducto, '''', ',');
        cuSGAManagement.ReemplazarCaracter(Descripcorta, '''', ',');
        CategoryLen := strlen(pItem."Item Category Code");

        // Montar JSON
        Clear(SGAJsonObject);
        SGAJsonObject.Add('IdEmpresaERP', COMPANYNAME);
        SGAJsonObject.Add('CodigoArticulo', pItem."No.");
        SGAJsonObject.Add('GTIN13', EAN13);
        SGAJsonObject.Add('GTIN14', EAN14);
        SGAJsonObject.Add('CantidadPorGTIN14', QuantBox);
        SGAJsonObject.Add('DescripcionCorta', Descripcorta);
        SGAJsonObject.Add('Descripcion1', DescripProducto);
        SGAJsonObject.Add('Sector', pItem."Gen. Prod. Posting Group");
        SGAJsonObject.Add('SubSector', CopyStr(pItem."Item Category Code", 1, 2));
        SGAJsonObject.Add('Seccion', CopyStr(pItem."Item Category Code", CategoryLen - 1, 2));
        SGAJsonObject.Add('UnidadMedidaBasica', pItem."Base Unit of Measure");
        SGAJsonObject.Add('PesoNetoKG', rItemUDBase.Weight);
        SGAJsonObject.Add('PesoBrutoKG', rItemUDBase."Gross weight");
        SGAJsonObject.Add('VolumenL', rItemUDBase.Cubage);
        SGAJsonObject.Add('DimX', rItemUDBase.Length);
        SGAJsonObject.Add('DimY', rItemUDBase.Width);
        SGAJsonObject.Add('DimZ', rItemUDBase.Height);
        SGAJsonObject.Add('ControlLote', ControlLoteTXT);
        SGAJsonObject.Add('LoteEntradasERP', LoteEntradaTXT);
        SGAJsonObject.Add('LoteSalidasERP', LoteSalidasTXT);
        SGAJsonObject.Add('ControlCaducidad', 'F');
        SGAJsonObject.Add('PesoVariable', 'F');
        SGAJsonObject.Add('Kit', 'F');
        SGAJsonObject.Add('Stock', 'T');
        SGAJsonObject.Add('FechaAltaEnlace', cuSGAManagement.GetFechaHoraTrabajo);
        SGAJsonObject.Add('PesoNetoKG_CAJ', rItemUDCaja.Weight);
        SGAJsonObject.Add('PesoBrutoKG_CAJ', rItemUDCaja."Gross weight");
        SGAJsonObject.Add('VolumenL_CAJ', rItemUDCaja.Cubage);
        SGAJsonObject.Add('DimX_CAJ', rItemUDCaja.Length);
        SGAJsonObject.Add('DimY_CAJ', rItemUDCaja.Width);
        SGAJsonObject.Add('DimZ_CAJ', rItemUDCaja.Height);
        SGAJsonObject.Add('PesoNetoKG_PAL', rItemUDPalet.Weight);
        SGAJsonObject.Add('PesoBrutoKG_PAL', rItemUDPalet."Gross weight");
        SGAJsonObject.Add('VolumenL_PAL', rItemUDPalet.Cubage);
        SGAJsonObject.Add('DimX_PAL', rItemUDPalet.Length);
        SGAJsonObject.Add('DimY_PAL', rItemUDPalet.Width);
        SGAJsonObject.Add('DimZ_PAL', rItemUDPalet.Height);
        //HttpCall(SGACallType::"Insertar producto", SGAJsonObject);
        cuSGAManagement.HttpCall(SGACallProcedure::"Insert Product", SGAJsonObject, ResponseTxt);
        pItem.Modify();
    end;
    //<<

    //>> Pedido de Compra
    procedure GestionPedidoCompra(pNumDoc: Code[20]);
    var
        rItem: Record Item;
        rCountry: Record "Country/Region";
        rLocation: Record Location;
        rPurchaseHeader: Record "Purchase Header";
        rPurchaseLine: Record "Purchase Line";
        FechaTrabajoDT: DateTime;
        FechaServicio: DateTime;
        FechaServicioTxt: Text[50];
        MarcarPedido: Boolean;
        Name: Text[100];
        Address: Text[100];
        Address2: Text[100];
        City: Text[50];
        County: Text[50];
        Error01: Label 'The receiving warehouse must be of type Quality for product %1 on line number %2',
                Comment = 'ESP="El almacen de recepción debe ser del tipo Calidad para el producto %1 en el nº linea %2"';
        Error02: Label 'Nothing to send to the SGA', Comment = 'ESP="Nada para enviar al SGA"';
    begin
        if not cuSGAManagement.IsSGAEnabled() then exit;
        cuSGAManagement.InitializeSGAConfiguration(rSGASetup);

        MarcarPedido := false;
        rPurchaseHeader.Get(rPurchaseHeader."Document Type"::Order, pNumDoc);
        rPurchaseHeader.TestField("Document Type");
        rPurchaseHeader.TestField("Buy-from Vendor No.");
        rPurchaseHeader.TestField("Pay-to Vendor No.");
        rPurchaseHeader.TestField("Posting Date");
        rPurchaseHeader.TestField("Document Date");
        rPurchaseHeader.TestField("Payment Method Code");
        rPurchaseHeader.TestField("Payment Terms Code");
        rPurchaseLine.SetRange("Document Type", rPurchaseHeader."Document Type");
        rPurchaseLine.SetRange("Document No.", rPurchaseHeader."No.");
        rPurchaseLine.SetRange(Type, rPurchaseLine.Type::Item);
        rPurchaseLine.SetFilter(Quantity, '<>%1', 0);
        rPurchaseLine.SetFilter("Outstanding Quantity", '>%1', 0);
        if rPurchaseLine.Findset() then
            repeat
                rItem.Get(rPurchaseLine."No.");
                if rItem."SGA Item Management" then begin
                    rLocation.Get(rPurchaseLine."Location Code");
                    if not rLocation."SGA Quality" then
                        Error(Error01, rPurchaseLine."No.", rPurchaseLine."Line No.");

                    if NOT rCountry.Get(rPurchaseHeader."Buy-from Country/Region Code") then Clear(rCountry);
                    if rPurchaseHeader."Requested Receipt Date" = 0D then
                        FechaServicioTxt := 'NULL'
                    else begin
                        FechaServicio := CreateDateTime(rPurchaseHeader."Requested Receipt Date", 0T);
                    end;
                    MarcarPedido := true;
                    Name := rPurchaseHeader."Buy-from Vendor Name";
                    Address := rPurchaseHeader."Buy-from Address";
                    Address2 := rPurchaseHeader."Buy-from Address 2";
                    City := rPurchaseHeader."Buy-from City";
                    County := rPurchaseHeader."Buy-from County";
                    cuSGAManagement.ReemplazarCaracter(Name, '''', '');
                    cuSGAManagement.ReemplazarCaracter(Address, '''', '');
                    cuSGAManagement.ReemplazarCaracter(Address2, '''', '');
                    cuSGAManagement.ReemplazarCaracter(City, '''', '');
                    cuSGAManagement.ReemplazarCaracter(County, '''', '');

                    // Montar JSON
                    Clear(SGAJsonObject);
                    SGAJsonObject.Add('CodigoAlmacenWMS', rLocation."SGA Warehouse Code");
                    SGAJsonObject.Add('IdAlmacenERP', rPurchaseLine."Location Code");
                    SGAJsonObject.Add('CodigoAlmacenOrigenWMS', rLocation."SGA Warehouse Code");
                    SGAJsonObject.Add('IdAlmacenOrigenERP', rPurchaseLine."Location Code");
                    SGAJsonObject.Add('IdEmpresaERP', COMPANYNAME);
                    SGAJsonObject.Add('TipoDocumento', '300');
                    SGAJsonObject.Add('NumeroDocumento', rPurchaseHeader."No.");
                    SGAJsonObject.Add('CodigoOrdenante', rPurchaseHeader."Buy-from Vendor No.");
                    SGAJsonObject.Add('NombreComercial', DELCHR(Name, '=', ''''''''));
                    SGAJsonObject.Add('Direccion', DELCHR(Address + ' ' + Address2, '=', ''''''''));
                    SGAJsonObject.Add('CP', rPurchaseHeader."Buy-from Post Code");
                    SGAJsonObject.Add('Poblacion', DELCHR(City, '=', ''''''''));
                    SGAJsonObject.Add('Provincia', County);
                    SGAJsonObject.Add('CodigoPaisISO', rPurchaseHeader."Buy-from Country/Region Code");
                    SGAJsonObject.Add('Pais', rCountry.Name);
                    SGAJsonObject.Add('ServicioDocumento', '{C,P}');
                    SGAJsonObject.Add('FechaAlta', cuSGAManagement.GetFechaHoraTrabajo);
                    if FechaServicioTxt = 'NULL' then
                        SGAJsonObject.Add('FechaServicioPrevista', FechaServicioTxt)
                    else
                        SGAJsonObject.Add('FechaServicioPrevista', FechaServicio);
                    SGAJsonObject.Add('NumeroLinea', FORMAT(rPurchaseLine."Line No."));
                    SGAJsonObject.Add('CodigoArticulo', rPurchaseLine."No.");
                    SGAJsonObject.Add('CantidadPedidaUMB', rPurchaseLine."Quantity (Base)");
                    SGAJsonObject.Add('SituacionStock', '');
                    SGAJsonObject.Add('FechaAltaEnlace', cuSGAManagement.GetFechaHoraTrabajo);
                    //HttpCall(SGACallType::"Gestion pedido compra", SGAJsonObject);
                    cuSGAManagement.HttpCall(SGACallProcedure::"Purchase Order Management", SGAJsonObject, ResponseTxt);
                end;
            until rPurchaseLine.Next() = 0;
        //rPurchaseLine.MODifYALL("Modificado SGA", false);
        //rPurchaseHeader.ModificadoSGA := false;
        if MarcarPedido then begin
            rPurchaseHeader."SGA Status" := rPurchaseHeader."SGA Status"::"SGA Sent";
            rPurchaseHeader."SGA Inserted" := CurrentDateTime;
            rPurchaseHeader.Modify();
        end
        else
            Error(Error02);
    end;
    //<<

    //>> Recepción Pedido Compra
    procedure RecepPedCompra();
    var
        rTempLotes: Record "Inventory Buffer" temporary;
        rTempLineas: Record "Inventory Buffer" temporary;
        rTempPedidos: Record "Inventory Buffer" temporary;
        rTempPurchCommentLine: Record "Purch. Comment Line" temporary;
        rPurchCommentLine: Record "Purch. Comment Line";
        rPurchaseLine: Record "Purchase Line";
        rPurchaseHeader: Record "Purchase Header";
        rTempLineasID: Record "SGA Temporal SQL" temporary;
        rTempCabPedCompra: Record "Purchase Header" temporary;
        rTempLinCompra: Record "Purchase Line" temporary;
        //cuReleasePurchDoc: Codeunit "Release Purchase Document";
        Almacen: Code[10];
        TipoDocumento: Code[3];
        NumDocumentoTipo: Code[25];
        NumLineaTxt: Text[25];
        CodArticulo: Code[20];
        CantidadRecibirTxT: Text[25];
        NumLote: Text[25];
        FechaAltaTxt: Text[25];
        Numlinea: Integer;
        CantidadRecibirDec: Decimal;
        CantidadRecibir: Integer;
        Tipo: Code[3];
        NumDocumento: Code[20];
        TextoError: Text[250];
        NumLineaComentario: Integer;
        IDBigTxt: Text;
        IDBig: BigInteger;
        FechaAltaDateTime: DateTime;
        FechaAlta: Date;
        idioma: Text[2];
        Error01: Label 'The purchase order does not exist', Comment = 'ESP="No existe el pedido de compra"';
        Error02: Label 'The line does not exist', Comment = 'ESP="Línea no existe"';
        Error03: Label 'Outstanding quantity is less than the quantity to be received',
                Comment = 'ESP="Cantidad pendiente menor que cantidad a recibir';

    begin
        if not cuSGAManagement.IsSGAEnabled() then exit;
        cuSGAManagement.InitializeSGAConfiguration(rSGASetup);

        idioma := '5'; //Idioma ESP.
        rTempCabPedCompra.Reset();
        rTempLinCompra.Reset();
        rTempCabPedCompra.DeleteAll();
        rTempLinCompra.DeleteAll();
        rTempLineas.Reset();
        rTempLineas.DeleteAll();
        rTempLotes.Reset();
        rTempLotes.DeleteAll();
        rTempLineasID.Reset();
        rTempLineasID.DeleteAll();
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'TipoDocumento eq ''300'' AND IdEmpresaERP eq ''' + CompanyName +
                         ''' and FechaProcesoEnlace eq null and (Resultado eq null or Resultado eq '''')');
        //HttpCall(SGACallType::"Recepcion pedido compra", SGAJsonObject);
        cuSGAManagement.HttpCall(SGACallProcedure::"Purchase Order Receipt", SGAJsonObject, ResponseTxt);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for Index := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, Index);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('IdAlmacenERP', ValueText);
            Almacen := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('TipoDocumento', ValueText);
            Tipo := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroDocumento', ValueText);
            NumDocumento := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroLinea', ValueText);
            NumLineaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CodigoArticulo', ValueText);
            CodArticulo := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CantidadServidaUMB', ValueText);
            CantidadRecibirTxT := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroLote', ValueText);
            NumLote := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('FechaAltaEnlace', ValueText);
            FechaAltaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('ROWID', ValueText);
            IDBigTxt := ValueText;
            Evaluate(IDBig, IDBigTxt);
            Evaluate(Numlinea, NumLineaTxt);

            //>> BBT 28/08/2025. La cantidad debe ser entera (sin decimales)
            if idioma <> '0' then
                Evaluate(CantidadRecibirDec, CantidadRecibirTxT)
            else
                cuSGAManagement.ConverTextoADecimal(CantidadRecibirTxT, CantidadRecibirDec);

            CantidadRecibir := cuSGAManagement.ConvertDecimalAEntero(CantidadRecibirDec);
            //<<    

            Evaluate(FechaAlta, FechaAltaTxt);
            // ExtraerNumDocTipo(_NumDocumentoTipo,_Tipo,_NumDocumento);
            rTempLineasID.Init();
            rTempLineasID.ID := IDBig;
            rTempLineasID.Tipo := Tipo;
            rTempLineasID."No. Documento" := NumDocumento;
            rTempLineasID.Insert();
            rTempPedidos.Init();
            rTempPedidos."Item No." := NumDocumento;
            if NOT rTempPedidos.Find() then rTempPedidos.Insert();
            rTempPedidos."SGA Date Registration" := FechaAltaTxt;
            rTempPedidos.Modify();
            rTempLineas.Init();
            rTempLineas."Item No." := NumDocumento;
            rTempLineas."Variant Code" := Tipo;
            rTempLineas."Dimension Entry No." := Numlinea;
            if NOT rTempLineas.Find() then rTempLineas.Insert();
            rTempLineas.Quantity += CantidadRecibir;
            rTempLineas.Modify();
            if NumLote <> '' then begin
                rTempLotes.Init();
                rTempLotes."Item No." := NumDocumento;
                rTempLotes."Variant Code" := Tipo;
                rTempLotes."Dimension Entry No." := Numlinea;
                rTempLotes."Serial No." := NumLote;
                if NOT rTempLotes.Find() then rTempLotes.Insert();
                rTempLotes.Quantity := CantidadRecibir;
                rTempLotes.Modify();
            end;
        end;
        // Actualizar pedido a recibir
        // Registrar
        rTempPedidos.Reset();
        rTempLineas.Reset();
        rTempLotes.Reset();
        if rTempPedidos.Findset() then
            repeat
                rTempCabPedCompra.Reset();
                rTempLinCompra.Reset();
                rTempCabPedCompra.DeleteAll();
                rTempLinCompra.DeleteAll();
                TextoError := '';
                rTempPurchCommentLine.Reset();
                rTempPurchCommentLine.DeleteAll();
                if NOT rPurchaseHeader.Get(rPurchaseHeader."Document Type"::Order, rTempPedidos."Item No.") then TextoError := Error01;
                if TextoError = '' then begin
                    rTempCabPedCompra.INIT;
                    rTempCabPedCompra := rPurchaseHeader;
                    rTempCabPedCompra.Insert();
                    if NOT AbrirPedidoCompra(rPurchaseHeader) then TextoError := CopyStr(GetLastErrorText, 1, 250);
                end;
                if TextoError = '' then begin
                    Evaluate(FechaAlta, rTempPedidos."SGA Date Registration");
                    if NOT validarFechaRegistroCompra(rPurchaseHeader, FechaAlta) then
                        TextoError := CopyStr(GetLastErrorText, 1, 250)
                    else
                        rPurchaseHeader.Modify();
                end;
                if TextoError = '' then begin
                    rPurchaseHeader.Modify();
                    rPurchaseLine.Reset();
                    rPurchaseLine.SetRange("Document Type", rPurchaseLine."Document Type"::Order);
                    rPurchaseLine.SetRange("Document No.", rTempPedidos."Item No.");
                    if rPurchaseLine.FindSet(true) then
                        repeat
                            rTempLinCompra.INIT;
                            rTempLinCompra := rPurchaseLine;
                            rTempLinCompra.Insert();
                            if rPurchaseLine."Qty. to Receive" <> 0 then begin
                                if NOT ValidarCantRecibBase(rPurchaseLine, 0) then TextoError := CopyStr(GetLastErrorText, 1, 250);
                                rPurchaseLine.Modify();
                            end;
                        until rPurchaseLine.Next() = 0;
                    rPurchaseLine.Reset();
                    rPurchCommentLine.Reset();
                    rPurchCommentLine.SetRange("Document Type", rPurchaseHeader."Document Type");
                    rPurchCommentLine.SetRange("No.", rPurchaseHeader."No.");
                    if rPurchCommentLine.FINDLAST then
                        NumLineaComentario := rPurchCommentLine."Line No."
                    else
                        NumLineaComentario := 0;
                    rTempLineas.SetRange("Variant Code", '300');
                    rTempLineas.SetRange("Item No.", rPurchaseHeader."No.");
                    if rTempLineas.Findset() then
                        repeat
                            if NOT rPurchaseLine.Get(rPurchaseHeader."Document Type", rPurchaseHeader."No.", rTempLineas."Dimension Entry No.") then
                                TextoError := Error02
                            else if rPurchaseLine."Outstanding Qty. (Base)" < rTempLineas.Quantity then TextoError := Error03;
                            if TextoError = '' then
                                if not ValidarCantRecibBase(rPurchaseLine, rTempLineas.Quantity) then
                                    TextoError := CopyStr(GetLastErrorText, 1, 250)
                                else
                                    rPurchaseLine.Modify();
                            if TextoError = '' then;
                            //Se meteran en comentario de linea
                            begin
                                rTempLotes.SetRange("Item No.", rPurchaseHeader."No.");
                                rTempLotes.SetRange("Variant Code", '300');
                                rTempLotes.SetRange("Dimension Entry No.", rPurchaseLine."Line No.");
                                if rTempLotes.Findset() then
                                    repeat
                                        NumLineaComentario += 10000;
                                        rPurchCommentLine.INIT;
                                        rPurchCommentLine."Document Type" := rPurchaseHeader."Document Type";
                                        rPurchCommentLine."No." := rPurchaseHeader."No.";
                                        rPurchCommentLine."Document Line No." := rPurchaseLine."Line No.";
                                        rPurchCommentLine."Line No." := NumLineaComentario;
                                        rPurchCommentLine.Comment := 'Lote: ' + rTempLotes."Serial No." + ' / Ctd.: ' + FORMAT(rTempLotes.Quantity, 0);
                                        rPurchCommentLine.Insert();
                                        rTempPurchCommentLine := rPurchCommentLine;
                                        rTempPurchCommentLine.Insert();
                                    until rTempLotes.Next() = 0;
                            end;
                        until rTempLineas.Next() = 0;
                end;
                if TextoError = '' then
                    if NOT RegistrarCompra(rPurchaseHeader) then begin
                        TextoError := CopyStr(GetLastErrorText, 1, 250);
                        rTempPurchCommentLine.Reset();
                        if rTempPurchCommentLine.Findset() then begin
                            rPurchCommentLine := rTempPurchCommentLine;
                            if rPurchCommentLine.Find() then rPurchCommentLine.Delete();
                        end;
                    end
                    else begin
                        rPurchaseHeader."SGA Readed" := CurrentDateTime;
                        rPurchaseHeader.Modify();
                    end;
                if TextoError = '' then
                    TextoError := 'CORRECTO'
                else begin
                    rPurchaseHeader.Reset();
                    CLEAR(rPurchaseHeader);
                    if rTempCabPedCompra.FINDFIRST then begin
                        rPurchaseHeader.INIT;
                        if rPurchaseHeader.Get(rTempCabPedCompra."Document Type", rTempCabPedCompra."No.") then begin
                            rPurchaseHeader.TransferFields(rTempCabPedCompra, false);
                            rPurchaseHeader.Modify();
                        end;
                    end;
                    rTempLinCompra.Reset();
                    rPurchaseLine.Reset();
                    Clear(rPurchaseLine);
                    if rTempLinCompra.Findset() then
                        repeat
                            rPurchaseLine.INIT;
                            if rPurchaseLine.Get(rTempLinCompra."Document Type", rTempLinCompra."Document No.", rTempLinCompra."Line No.") then begin
                                rPurchaseLine.TransferFields(rTempLinCompra, false);
                                rPurchaseLine.Modify();
                            end;
                        until rTempLinCompra.Next() = 0;
                end;
                cuSGAManagement.ReemplazarCaracter(TextoError, '''', '');
                rTempLineasID.Reset();
                rTempLineasID.SetRange(Tipo, '300');
                rTempLineasID.SetRange("No. Documento", rTempPedidos."Item No.");
                if rTempLineasID.Findset() then
                    repeat
                        Clear(SGAJsonObject);
                        SGAJsonObject.Add('FechaProcesoEnlace', cuSGAManagement.GetFechaHoraTrabajo());
                        SGAJsonObject.Add('Resultado', TextoError);
                        SGAJsonObject.Add('RowId', FORMAT(rTempLineasID.ID));
                        //HttpCall(SGACallType::"Actualizar documento", SGAJsonObject);
                        cuSGAManagement.HttpCall(SGACallProcedure::"Update Document", SGAJsonObject, ResponseTxt);
                    until rTempLineasID.Next() = 0;
            until rTempPedidos.Next() = 0;
    end;
    //<<

    //>> Pedidos de venta - Documento de envío (DEAs)
    procedure PedVentaDocEnvio(pNumEnvio: Code[20]; pBorrar: Boolean);
    var
        rTempLinEnvio: Record "Warehouse Shipment Line" temporary;
        rTempCabVenta: Record "Inventory Buffer" temporary;
        rWarehouseShipmentHeader: Record "Warehouse Shipment Header";
        rWarehouseShipmentLine: Record "Warehouse Shipment Line";
        rSalesHeader: Record "Sales Header";
        rPais: Record "Country/Region";
        rLocation: Record Location;
        rShipmentAgent: Record "Shipping Agent";
        rWarehouseCommentLine: Record "Warehouse Comment Line";
        rCustomer: Record Customer;
        Comentarios: Text;
        FechaServicio: DateTime;
        Name: Text[100];
        Address: Text[100];
        Address2: Text[100];
        City: Text[50];
        County: Text[50];
        NombreDeEnvio: Text[100];
        TipoDocumento: Integer;
        TipodocumentoTxt: Text[5];
        Error01: Label 'The shipment has been submitted.', Comment = 'ESP="El envio esta lanzado"';
        Error02: Label 'The shipment must be submitted.', Comment = 'ESP="El envio debe de estar lanzado"';
        Error03: label 'The Shipping Address Type is incorrect.', Comment = 'ESP="El Tipo de Dirección de Envío es incorrecto"';
        // BBT 10/02/2024 Variables para averiguar el tipo de dirección de envio
        cuCustomerMgt: Codeunit "Customer Mgt.";
        SalesShipToOptions: Enum "Sales Ship-to Options";
        ShipToOptions: Enum "Sales Ship-to Options";
        BillToOptions: Enum "Sales Bill-to Options";

    begin
        if not cuSGAManagement.IsSGAEnabled() then exit;
        cuSGAManagement.InitializeSGAConfiguration(rSGASetup);

        rWarehouseShipmentHeader.Get(pNumEnvio);

        rTempCabVenta.Reset();
        rTempCabVenta.DeleteAll();
        if pBorrar then begin
            if rWarehouseShipmentHeader.Status <> rWarehouseShipmentHeader.Status::Open then Error(Error01);
        end
        else if rWarehouseShipmentHeader.Status <> rWarehouseShipmentHeader.Status::Released then Error(Error02);
        Comentarios := '';
        rWarehouseCommentLine.Reset();
        rWarehouseCommentLine.SetRange("Table Name", rWarehouseCommentLine."Table Name"::"Whse. Shipment");
        rWarehouseCommentLine.SetRange("No.", pNumEnvio);
        if rWarehouseCommentLine.Findset() then
            repeat
                Comentarios += rWarehouseCommentLine.Comment + ' ';
            until rWarehouseCommentLine.Next() = 0;
        if STRLEN(Comentarios) <> 0 then Comentarios := CopyStr(Comentarios, 1, STRLEN(Comentarios) - 1);
        rTempLinEnvio.Reset();
        rWarehouseShipmentLine.SetRange("Source Type", 37);
        rWarehouseShipmentLine.SetRange("Source Subtype", 1);
        rWarehouseShipmentLine.SetRange("No.", pNumEnvio);
        if rWarehouseShipmentLine.Findset() then
            repeat
                rTempLinEnvio.Reset();
                rTempLinEnvio.SetRange("Item No.", rWarehouseShipmentLine."Item No.");
                if NOT rTempLinEnvio.FINDFIRST then begin
                    rTempLinEnvio.Reset();
                    rTempLinEnvio := rWarehouseShipmentLine;
                    rTempLinEnvio.Insert();
                end
                else begin
                    rTempLinEnvio."Qty. to Ship (Base)" += rWarehouseShipmentLine."Qty. to Ship (Base)";
                    rTempLinEnvio.Modify();
                end;
            until rWarehouseShipmentLine.Next() = 0;
        //>> Averiguamos la fecha de entrega (PV: Fecha Entrega Requerida VS  DEA: Fecha Envío) 
        // Si el DEA ya tiene fecha la mantenemos
        Clear(FechaServicio);
        if rWarehouseShipmentHeader."Shipment Date" <> 0D then begin
            FechaServicio := CreateDateTime(rWarehouseShipmentHeader."Shipment Date", 0T);
        end
        else begin // Buscamos la fecha requerida más próxima de los pedidos de venta del DEA
            rTempLinEnvio.Reset();
            if rTempLinEnvio.Findset() then begin
                repeat
                    rSalesHeader.Get(rTempLinEnvio."Source Subtype", rWarehouseShipmentLine."Source No.");
                    if rSalesHeader."Requested Delivery Date" <> 0D then begin
                        if (FechaServicio = 0DT) then
                            FechaServicio := CreateDateTime(rSalesHeader."Requested Delivery Date", 0T)
                        else if FechaServicio > CreateDateTime(rSalesHeader."Requested Delivery Date", 0T) then
                            FechaServicio := CreateDateTime(rSalesHeader."Requested Delivery Date", 0T);
                    end;
                until rTempLinEnvio.Next() = 0;
            end;
        end;
        // si la fecha de envio es menor(o igual) a la fecha actual no la ponemos
        if FechaServicio <> 0DT then
            if FechaServicio <= CreateDateTime(WorkDate, 0T) then
                Clear(FechaServicio);
        //<< 
        rTempLinEnvio.Reset();
        if rTempLinEnvio.FindSet() then begin
            repeat
                rSalesHeader.Get(rTempLinEnvio."Source Subtype", rWarehouseShipmentLine."Source No.");
                TipoDocumento := 200;
                rCustomer.Get(rSalesHeader."Sell-to Customer No.");
                rLocation.Get(rWarehouseShipmentHeader."Location Code");
                //>> Obsolete
                //TipoDocumento := TipoDocumento + rCustomer."Customer Pool";
                //<<
                TipodocumentoTxt := FORMAT(TipoDocumento);
                rTempCabVenta.INIT;
                rTempCabVenta."Item No." := rSalesHeader."No.";
                if NOT rTempCabVenta.Find() then begin
                    rSalesHeader."SGA Status" := rSalesHeader."SGA Status"::"SGA Sent";
                    rSalesHeader.Modify();
                    rTempCabVenta.Insert();
                end;
                if rSalesHeader."Ship-to Code" = '' then begin
                    if NOT rPais.Get(rSalesHeader."Sell-to Country/Region Code") then CLEAR(rPais);
                end
                else begin
                    if NOT rPais.Get(rSalesHeader."Ship-to Country/Region Code") then CLEAR(rPais);
                end;
                if NOT rShipmentAgent.Get(rSalesHeader."Shipping Agent Code") then CLEAR(rShipmentAgent);
                //>>
                //if rSalesHeader."Requested Delivery Date" = 0D then
                //    _FechaServicioTxt := 'NULL'
                //else begin
                //    _FechaServicio := CreateDateTime(rWarehouseShipmentHeader."Shipment Date", 0T);
                //end;
                //<<
                NombreDeEnvio := '';
                Clear(SGAJsonObject);
                SGAJsonObject.Add('CodigoAlmacenWMS', rLocation."SGA Warehouse Code");
                SGAJsonObject.Add('IdAlmacenERP', rWarehouseShipmentHeader."Location Code");
                SGAJsonObject.Add('CodigoAlmacenOrigenWMS', rLocation."SGA Warehouse Code");
                SGAJsonObject.Add('IdAlmacenOrigenERP', rWarehouseShipmentHeader."Location Code");
                SGAJsonObject.Add('IdEmpresaERP', CompanyName);
                SGAJsonObject.Add('TipoDocumento', TipodocumentoTxt);
                SGAJsonObject.Add('NumeroDocumento', rWarehouseShipmentHeader."No.");

                //>> BBT 10/02/2024 Procedure STD para averiguar el tipo de dirección de envio
                cuCustomerMgt.CalculateShipBillToOptions(ShiptoOptions, BilltoOptions, rSalesHeader);
                case ShiptoOptions of
                    SalesShipToOptions::"Default (Sell-to Address)":   //Dirección Predeterminada. Dirección Envío ficha del cliente
                        begin
                            Address := rSalesHeader."Sell-to Address";
                            Address2 := rSalesHeader."Sell-to Address 2";
                            City := rSalesHeader."Sell-to City";
                            County := rSalesHeader."Sell-to County";
                            SGAJsonObject.Add('CodigoOrdenante', rSalesHeader."Sell-to Customer No.");
                            SGAJsonObject.Add('CP', rSalesHeader."Sell-to Post Code");
                            SGAJsonObject.Add('CodigoPaisISO', rSalesHeader."Sell-to Country/Region Code");
                        end;
                    SalesShipToOptions::"Alternate Shipping Address":  //Dirección Alternativa. Direcciones de Envío del cliente
                        begin
                            Address := rSalesHeader."Ship-to Address";
                            Address2 := rSalesHeader."Ship-to Address 2";
                            City := rSalesHeader."Ship-to City";
                            County := rSalesHeader."Ship-to County";
                            SGAJsonObject.Add('CodigoOrdenante', rSalesHeader."Sell-to Customer No.");
                            SGAJsonObject.Add('CP', rSalesHeader."Ship-to Post Code");
                            SGAJsonObject.Add('CodigoPaisISO', rSalesHeader."Ship-to Country/Region Code");
                        end;
                    SalesShipToOptions::"Custom Address":      // Dirección Personalizada
                        begin
                            Address := rSalesHeader."Ship-to Address";
                            Address2 := rSalesHeader."Ship-to Address 2";
                            City := rSalesHeader."Ship-to City";
                            County := rSalesHeader."Ship-to County";
                            SGAJsonObject.Add('CodigoOrdenante', rSalesHeader."Sell-to Customer No.");
                            SGAJsonObject.Add('CP', rSalesHeader."Ship-to Post Code");
                            SGAJsonObject.Add('CodigoPaisISO', rSalesHeader."Ship-to Country/Region Code");
                        end;
                    else
                        Error(Error03);
                end;
                cuSGAManagement.ReemplazarCaracter(Address, '''', '');
                cuSGAManagement.ReemplazarCaracter(Address2, '''', '');
                cuSGAManagement.ReemplazarCaracter(City, '''', '');
                cuSGAManagement.ReemplazarCaracter(County, '''', '');
                SGAJsonObject.Add('Direccion', Address + ' ' + Address2);
                SGAJsonObject.Add('Poblacion', City);
                SGAJsonObject.Add('Provincia', County);
                //<<
                Name := rSalesHeader."Sell-to Customer Name";
                cuSGAManagement.ReemplazarCaracter(Name, '''', '');
                NombreDeEnvio := rSalesHeader."Ship-to Name";
                SGAJsonObject.Add('NombreDeEnvio', NombreDeEnvio);
                cuSGAManagement.ReemplazarCaracter(NombreDeEnvio, '''', '');
                SGAJsonObject.Add('NombreComercial', Name);
                SGAJsonObject.Add('Pais', rPais.Name);
                SGAJsonObject.Add('CodigoTransportista', rSalesHeader."Shipping Agent Code");
                SGAJsonObject.Add('NombreTransportista', rShipmentAgent.Name);
                SGAJsonObject.Add('ServicioDocumento', '{C,P}');
                SGAJsonObject.Add('FechaAlta', cuSGAManagement.GetFechaHoraTrabajo);
                //>>
                //if _FechaServicioTxt = 'NULL' then
                //    SGAJsonObject.Add('FechaServicioPrevista', _FechaServicioTxt)
                //else
                //    SGAJsonObject.Add('FechaServicioPrevista', _FechaServicio);
                if FechaServicio <> 0DT then
                    SGAJsonObject.Add('FechaServicioPrevista', FechaServicio)
                else
                    SGAJsonObject.Add('FechaServicioPrevista', 'NULL');
                //<<    
                SGAJsonObject.Add('NumeroLinea', FORMAT(rTempLinEnvio."Line No."));
                SGAJsonObject.Add('CodigoArticulo', rTempLinEnvio."Item No.");
                SGAJsonObject.Add('CantidadPedidaUMB', rTempLinEnvio."Qty. to Ship (Base)");
                SGAJsonObject.Add('ComentariosLinea', Comentarios);
                SGAJsonObject.Add('FechaAltaEnlace', cuSGAManagement.GetFechaHoraTrabajo);
                SGAJsonObject.Add('Libre1', rSalesHeader.Reference);
                //HttpCall(SGACallType::"Documento envio", SGAJsonObject);
                cuSGAManagement.HttpCall(SGACallProcedure::"Shipping Document", SGAJsonObject, ResponseTxt);

            until rTempLinEnvio.Next() = 0;
            if not pBorrar then begin
                rWarehouseShipmentHeader."SGA Status" := rWarehouseShipmentHeader."SGA Status"::"SGA Sent";
                rWarehouseShipmentHeader."SGA Inserted" := CreateDateTime(workdate, Time);
                rWarehouseShipmentHeader."SGA Modified" := false;
                rWarehouseShipmentHeader.Modify();
            end;
        end;
    end;

    //>>  Documento de Envío - Albarán Pedido de Venta
    procedure AlbVentaDocEnvio();
    var
        rWarehouseShipmentHeader: Record "Warehouse Shipment Header";
        rWarehouseShipmentLine: Record "Warehouse Shipment Line";
        rSalesHeader: Record "Sales Header";
        rWarehouseRequest: Record "Warehouse Request";
        rWarehouseLineComment: Record "SGA Warehouse line Comment";
        rLinEnvioTemp: Record "Warehouse Shipment Line" temporary;
        rTempLineas: Record "Inventory Buffer" temporary;
        rTempLotes: Record "Inventory Buffer" temporary;
        rTempEnvio: Record "Inventory Buffer" temporary;
        rTempPurchCommentLine: Record "SGA Warehouse line Comment" temporary;
        rTempComentarioLinea2: Record "SGA Warehouse line Comment" temporary;
        rTempLinEnvio: Record "Warehouse Shipment Line" temporary;
        rTempPostedLines: Record "Posted Whse. Shipment Line";
        rAuxShipmentLine: Record "Warehouse Shipment Line";
        rTempLineasID: Record "SGA Temporal SQL" temporary;
        Almacen: Code[10];
        NoDoc: Code[20];
        NoEntAlm: Code[25];
        NumLineaTxt: Text[20];
        Numlinea: Integer;
        CodArticulo: Code[20];
        CantidadTxt: Text[20];
        NumeroLote: Text[25];
        FechaAltaTxt: Text[20];
        FechaAltaDateTime: DateTime;
        FechaAlta: Date;
        IDBigTxt: Text;
        IdBig: BigInteger;
        Ok: Boolean;
        Tipo: Code[10];
        NumLineaComentario: Integer;
        CantidadDec: Decimal;
        Cantidad: Integer;
        TextoError: Text;
        Error01: Label 'The shipment does not exist', Comment = 'ESP="El Envio NO Existe"';
        Error03: Label 'The quantity to be sent is greater than the outstanding quantity.',
                Comment = 'ESP="La cantidad a enviar es mayor que la cantidad pendiente"';
        Cant: Decimal;
        CantAux: Decimal;
        Idioma: Text[2];
    begin
        // SGA Enabled
        if not cuSGAManagement.IsSGAEnabled() then exit;
        cuSGAManagement.InitializeSGAConfiguration(rSGASetup);

        Idioma := '5';
        rTempEnvio.Reset();
        rTempEnvio.DeleteAll();
        rTempLineas.Reset();
        rTempLineas.DeleteAll();
        rTempLineasID.Reset();
        rTempLineasID.DeleteAll();
        rTempLotes.Reset();
        rTempLotes.DeleteAll();
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'StartsWith(TipoDocumento ,''20'') and FechaProcesoEnlace eq null and (Resultado eq null OR Resultado eq '''') ' +
                            ' and IdEmpresaERP eq ''' + CompanyName + '''');
        //HttpCall(SGACallType::"Albaran pedido venta", SGAJsonObject);
        cuSGAManagement.HttpCall(SGACallProcedure::"Sales Order Delivery Note", SGAJsonObject, ResponseTxt);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for Index := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, Index);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('IdAlmacenERP', ValueText);
            Almacen := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('TipoDocumento', ValueText);
            Tipo := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroDocumento', ValueText);
            NoDoc := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroEntregaAlmacen', ValueText);
            NoEntAlm := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroLinea', ValueText);
            NumLineaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CodigoArticulo', ValueText);
            CodArticulo := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CantidadServidaUMB', ValueText);
            CantidadTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroLote', ValueText);
            NumeroLote := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('FechaAltaEnlace', ValueText);
            FechaAltaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('ROWID', ValueText);
            IDBigTxt := ValueText;
            Evaluate(IdBig, IDBigTxt);
            Ok := Evaluate(FechaAltaDateTime, FechaAltaTxt);
            Evaluate(Numlinea, NumLineaTxt);

            //>> BBT 28/08/2025. La cantidad debe ser entera (sin decimales)
            if Idioma <> '0' then
                Evaluate(CantidadDec, CantidadTxt)
            else
                cuSGAManagement.ConverTextoADecimal(CantidadTxt, CantidadDec);

            Cantidad := cuSGAManagement.ConvertDecimalAEntero(CantidadDec);
            //<<

            rTempLineasID.Init();
            rTempLineasID.ID := IdBig;
            rTempLineasID.Tipo := Tipo;
            rTempLineasID."No. Documento" := NoDoc;
            rTempLineasID.Insert();
            rTempEnvio.Init();
            rTempEnvio."Item No." := NoDoc;
            if NOT rTempEnvio.Find() then begin
                rTempEnvio."SGA Delivery Number" := NoEntAlm;
                rTempEnvio.Insert();
            end;

            rTempLineas.Init();
            rTempLineas."Item No." := NoDoc;
            rTempLineas."Variant Code" := Tipo;
            rTempLineas."Dimension Entry No." := Numlinea;
            rTempLineas."Bin Code" := CodArticulo;
            if NOT rTempLineas.Find() then rTempLineas.Insert();
            rTempLineas.Quantity += Cantidad;
            rTempLineas."SGA Delivery Number" := NoEntAlm;
            rTempLineas.Modify();

            if NumeroLote <> '' then begin
                rTempLotes.INIT;
                rTempLotes."Item No." := NoDoc;
                rTempLotes."Variant Code" := Tipo;
                rTempLotes."Bin Code" := CodArticulo;
                rTempLotes."Serial No." := NumeroLote;
                if not rTempLotes.Find() then rTempLotes.Insert();
                rTempLotes.Quantity := Cantidad;
                rTempLotes.Modify();
            end;

        end;
        // >> BBT 23/10/2024 
        // Comprobamos que la cantidad que el TWO informa para enviar no sea mayor que la que hay en el DEA.
        // En el caso de segundos envios parciales puede darse el caso de discrepancias
        rTempLineas.Reset();
        rAuxShipmentLine.Reset();
        if rTempLineas.Findset() then begin
            repeat
                CantAux := 0;
                rAuxShipmentLine.SetRange("No.", rTempLineas."Item No.");
                rAuxShipmentLine.SetRange("Item No.", rTempLineas."Bin Code");
                if rAuxShipmentLine.FindSet() then begin
                    repeat
                        CantAux += rAuxShipmentLine."Qty. (Base)";
                    until rAuxShipmentLine.Next() = 0;

                    if rTempLineas.Quantity > CantAux then begin
                        rTempLineas.Quantity := CantAux;
                        rTempLineas.Modify()
                    end;
                end
                //>> BBT 25/11/2024 Puede ser que en un envio parcial anterior alguna de las lineas que llegan del TWO
                //                  ya este totalmente enviada y por lo tanto ya no este en el DEA
                else begin
                    repeat
                        CantAux := 0;
                        rTempPostedLines.SetRange("Whse. Shipment No.", rTempLineas."Item No.");
                        rTempPostedLines.SetRange("Item No.", rTempLineas."Bin Code");
                        if rTempPostedLines.Findset() then begin
                            repeat
                                CantAux += rTempPostedLines."Qty. (Base)";
                            until rTempPostedLines.Next() = 0;

                            if rTempLineas.Quantity <= CantAux then begin
                                rTempLineas.Quantity := 0;
                                rTempLineas.Modify();
                            end;
                        end;
                    until rTempLineas.Next() = 0;
                end;
            //<< BBT 25/11/2024
            until rTempLineas.Next() = 0;
        end;
        //<< BBT 23/10/2024

        // Actualizar pedido a recibir
        // Registrar
        rTempEnvio.Reset();
        rTempLineas.Reset();
        rTempLotes.Reset();
        if rTempEnvio.Findset() then
            repeat
                TextoError := '';
                rTempPurchCommentLine.Reset();
                rTempPurchCommentLine.DeleteAll();
                rTempComentarioLinea2.Reset();
                rTempComentarioLinea2.DeleteAll();

                //>> Comprobación de que existe el DEA
                if NOT rWarehouseShipmentHeader.Get(rTempEnvio."Item No.") then TextoError := Error01;
                //<<
                if TextoError = '' then begin
                    rTempLinEnvio.Reset();
                    rTempLinEnvio.DeleteAll();
                    rLinEnvioTemp.Reset();
                    rLinEnvioTemp.DeleteAll();
                    rWarehouseShipmentLine.SetRange("No.", rWarehouseShipmentHeader."No.");
                    if rWarehouseShipmentLine.Findset() then
                        repeat
                            rTempLinEnvio.INIT;
                            rTempLinEnvio := rWarehouseShipmentLine;
                            rTempLinEnvio.Insert();
                            if (rWarehouseShipmentLine."Source Type" = 37) AND (rWarehouseShipmentLine."Source Subtype" = 1) then
                                if rSalesHeader.Get(rWarehouseShipmentLine."Source Subtype", rWarehouseShipmentLine."Source No.") then begin
                                    rSalesHeader."Shipping No." := '';
                                    if rSalesHeader.Status <> rSalesHeader.Status::Released then begin
                                        rSalesHeader.Status := rSalesHeader.Status::Released;
                                        if rWarehouseRequest.Get(rWarehouseRequest.Type::Outbound, rWarehouseShipmentLine."Location Code", rWarehouseShipmentLine."Source Type", rWarehouseShipmentLine."Source Subtype", rWarehouseShipmentLine."Source No.") then
                                            if rWarehouseRequest."Document Status" <> rWarehouseRequest."Document Status"::Released then begin
                                                rWarehouseRequest."Document Status" := rWarehouseRequest."Document Status"::Released;
                                                rWarehouseRequest.Modify();
                                            end;
                                    end;
                                    rSalesHeader.Modify();
                                end;
                        until rWarehouseShipmentLine.Next() = 0;
                    if rWarehouseShipmentLine.FindSet(true) then
                        repeat
                            rLinEnvioTemp.INIT;
                            rLinEnvioTemp := rWarehouseShipmentLine;
                            rLinEnvioTemp.Insert();
                            if ValidarCantEnviarBase(rLinEnvioTemp, 0) then begin
                                rLinEnvioTemp.Modify();
                                rWarehouseLineComment.SetRange("Document Type", rWarehouseLineComment."Document Type"::Ship);
                                rWarehouseLineComment.SetRange("No.", rWarehouseShipmentLine."No.");
                                rWarehouseLineComment.SetRange("Document Line No.", rWarehouseShipmentLine."Line No.");
                                if rWarehouseLineComment.Findset() then
                                    repeat
                                        rTempPurchCommentLine := rWarehouseLineComment;
                                        rTempPurchCommentLine.Insert();
                                    until rWarehouseLineComment.Next() = 0;
                            end
                            else
                                TextoError := CopyStr(GetLastErrorText, 1, 250);
                        until (rWarehouseShipmentLine.Next() = 0) OR (TextoError <> '');
                    if TextoError = '' then begin
                        rTempLineas.SetRange("Variant Code", '200', '209');
                        rTempLineas.SetRange("Item No.", rWarehouseShipmentHeader."No.");
                        if rTempLineas.Findset() then
                            repeat // Cambiar para agrupacion
                                rLinEnvioTemp.SetRange("No.", rTempLineas."Item No.");
                                rLinEnvioTemp.SetRange("Item No.", rTempLineas."Bin Code");
                                rLinEnvioTemp.SetFilter("Qty. Outstanding (Base)", '<>0');
                                if rLinEnvioTemp.FindSet(true) then
                                    repeat
                                        if rLinEnvioTemp."Qty. Outstanding (Base)" >= rTempLineas.Quantity then begin
                                            Cant := rTempLineas.Quantity;
                                            if ValidarCantEnviarBase(rLinEnvioTemp, rLinEnvioTemp."Qty. to Ship (Base)" + rTempLineas.Quantity) then begin
                                                rTempLineas.Quantity := 0;
                                                rTempLineas.Modify();
                                                rLinEnvioTemp.Validate("SGA Quantity (Base)", rLinEnvioTemp."SGA Quantity (Base)" + rLinEnvioTemp."Qty. to Ship (Base)");
                                                rLinEnvioTemp."SGA Warehouse Delivery Number" := rTempLineas."SGA Delivery Number";
                                                rLinEnvioTemp.Modify();
                                                ComentariosLoteEnvios(rTempLotes, rTempPurchCommentLine, Cant, rLinEnvioTemp);
                                                // Meter comentarios con lotes hasta _Cant = 0
                                            end
                                            else
                                                TextoError := CopyStr(GetLastErrorText, 1, 250);
                                        end
                                        else if ValidarCantEnviarBase(rLinEnvioTemp, rLinEnvioTemp."Qty. Outstanding (Base)") then begin
                                            Cant := rLinEnvioTemp."Qty. Outstanding (Base)";
                                            rTempLineas.Quantity -= rLinEnvioTemp."Qty. Outstanding (Base)";
                                            rTempLineas.Modify();
                                            rLinEnvioTemp.Validate("SGA Quantity (Base)", rLinEnvioTemp."SGA Quantity (Base)" + rLinEnvioTemp."Qty. to Ship (Base)");
                                            rLinEnvioTemp."SGA Warehouse Delivery Number" := rTempLineas."SGA Delivery Number";
                                            rLinEnvioTemp.Modify();
                                            ComentariosLoteEnvios(rTempLotes, rTempPurchCommentLine, Cant, rLinEnvioTemp);
                                            // Meter comentarios con lotes hasta _Cant = 0
                                        end
                                        else
                                            TextoError := CopyStr(GetLastErrorText, 1, 250);
                                    until (rLinEnvioTemp.Next() = 0) OR (rTempLineas.Quantity = 0);
                                if rTempLineas.Quantity > 0 then TextoError := Error03;
                            until (TextoError <> '') OR (rTempLineas.Next() = 0);
                    end;
                    if TextoError = '' then begin
                        rLinEnvioTemp.Reset();
                        if rLinEnvioTemp.Findset() then
                            repeat
                                rWarehouseShipmentLine := rLinEnvioTemp;
                                rWarehouseShipmentLine.Modify();
                            until rLinEnvioTemp.Next() = 0;
                        rTempPurchCommentLine.Reset();
                        rTempComentarioLinea2.Reset();
                        rTempComentarioLinea2.DeleteAll();
                        if rTempPurchCommentLine.Findset() then
                            repeat
                                rWarehouseLineComment := rTempPurchCommentLine;
                                if rWarehouseLineComment.Insert() then begin
                                    rTempComentarioLinea2 := rWarehouseLineComment;
                                    rTempComentarioLinea2.Insert();
                                end;
                            until rTempPurchCommentLine.Next() = 0;

                        //REGISTRAR ENVIO
                        if NOT RegistrarEnvio(rWarehouseShipmentLine) then begin
                            TextoError := CopyStr(GetLastErrorText, 1, 250);
                            rTempComentarioLinea2.Reset();
                            if rTempComentarioLinea2.Findset() then begin
                                rWarehouseLineComment := rTempComentarioLinea2;
                                if rWarehouseLineComment.Find() then rWarehouseLineComment.Delete();
                            end;
                            rTempLinEnvio.Reset();
                            rWarehouseShipmentLine.Reset();
                            Clear(rWarehouseShipmentLine);
                            if rTempLinEnvio.Findset() then
                                repeat
                                    rWarehouseShipmentLine.Init();
                                    if rWarehouseShipmentLine.Get(rTempLinEnvio."No.", rTempLinEnvio."Line No.") then begin
                                        rWarehouseShipmentLine.TransferFields(rTempLinEnvio, false);
                                        //>> <<//
                                        rWarehouseShipmentLine.Modify();
                                    end;
                                until rTempLinEnvio.Next() = 0;
                        end
                        else begin
                            if rWarehouseShipmentHeader.Find() then begin
                                rWarehouseShipmentHeader."SGA Readed" := CurrentDateTime;
                                rWarehouseShipmentHeader.Modify();
                            end;
                        end;
                    end;
                end;
                if TextoError = '' then TextoError := 'CORRECTO';
                cuSGAManagement.ReemplazarCaracter(TextoError, '''', '');
                rTempLineasID.Reset();
                rTempLineasID.SetRange(Tipo, '200', '209');
                rTempLineasID.SetRange("No. Documento", rTempEnvio."Item No.");
                if rTempLineasID.Findset() then
                    repeat
                        Clear(SGAJsonObject);
                        SGAJsonObject.Add('FechaProcesoEnlace', cuSGAManagement.GetFechaHoraTrabajo());
                        SGAJsonObject.Add('Resultado', TextoError);
                        SGAJsonObject.Add('RowId', FORMAT(rTempLineasID.ID));
                        //HttpCall(SGACallType::"Actualizar documento", SGAJsonObject);
                        cuSGAManagement.HttpCall(SGACallProcedure::"Update Document", SGAJsonObject, ResponseTxt);
                    until rTempLineasID.Next() = 0;
                TextoError := '';
            until rTempEnvio.Next() = 0;
    end;
    //<<

    //>> Documento de Envío - Fecha Expedición
    // BBT. 01/07/2026. No es necesario. Se actualizará la fecha en el 'SGAInterfaces.EntregasExpedidas'
    /*
    procedure FechaExpedicion();
    var
        //CabAlbVenta: Record "Sales Shipment Header";
        LinAlbVenta: Record "Sales Shipment Line";
        LinEnvioReg: Record "Posted Whse. Shipment Line";
        rLineasProcess: Record "SGA Temporal SQL" temporary;
        Almacen: Code[10];
        NoEnvio: Code[20];
        FechaExpedicionTXT: Text[25];
        FechaExpedicion: DateTime;
        OK: Boolean;
        TextoError: Text[255];
        Error01: Label 'Invalid issue date', Comment = 'ESP="Fecha expedición no valida"';
        Error02: Label 'Delivery note does not exist.', Comment = 'ESP="El albarán no existe"';
        IDBig: BigInteger;
        IDBigTxt: Text;
        FechaTrabajo: DateTime;
    begin
        // SGA Enabled
        if not cuSGAManagement.IsSGAEnabled() then exit;
        cuSGAManagement.InitializeSGAConfiguration(rSGASetup);

        rLineasProcess.Reset();
        rLineasProcess.DeleteAll();
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'FechaProcesoEnlace eq null and (Resultado eq null OR Resultado eq '''') and IdEmpresaERP eq ''' + CompanyName + '''');
        //HttpCall(SGACallType::"Leer entregas expedidas", SGAJsonObject);
        cuSGAManagement.HttpCall(SGACallProcedure::"Read Dispatched Deliveries", SGAJsonObject, ResponseTxt);
        //Read Json
        LinEnvioReg.SetCurrentKey("Whse. Shipment No.");
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for Index := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, Index);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('IdAlmacenERP', ValueText);
            Almacen := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroEntregaAlmacen', ValueText);
            NoEnvio := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('FechaExpedicionEntrega', ValueText);
            FechaExpedicionTXT := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('ROWID', ValueText);
            IDBigTxt := ValueText;
            TextoError := '';
            Evaluate(IDBig, IDBigTxt);
            OK := Evaluate(FechaExpedicion, FechaExpedicionTXT);
            if NOT OK then TextoError := Error01;
            if TextoError = '' then begin
                LinEnvioReg.SetRange("Whse. Shipment No.", NoEnvio);
                LinEnvioReg.SetRange("Posted Source Document", LinEnvioReg."Posted Source Document"::"Posted Shipment");
                if LinEnvioReg.FINDFIRST then begin
                    LinAlbVenta.SetRange("Document No.", LinEnvioReg."Posted Source No.");
                    if LinAlbVenta.FindSet(true) then begin
                        repeat
                            LinAlbVenta."SGA Expedition Date" := FechaExpedicion;
                            LinAlbVenta.Modify();
                        until LinAlbVenta.Next() = 0;
                    end
                    else
                        TextoError := Error02;
                end;
            end;
            if TextoError = '' then TextoError := 'CORRECTO';
            rLineasProcess.ID := IDBig;
            cuSGAManagement.ReemplazarCaracter(TextoError, '''', '');
            rLineasProcess.Error := TextoError;
            rLineasProcess.Insert();
        end;
        rLineasProcess.Reset();
        if rLineasProcess.Findset() then
            repeat
                Clear(SGAJsonObject);
                SGAJsonObject.Add('FechaProcesoEnlace', cuSGAManagement.GetFechaHoraTrabajo());
                SGAJsonObject.Add('Resultado', rLineasProcess.Error);
                SGAJsonObject.Add('RowId', FORMAT(rLineasProcess.ID));
                //HttpCall(SGACallType::"Actualizar entregas expedidas", SGAJsonObject);
                cuSGAManagement.HttpCall(SGACallProcedure::"Update Shipped Deliveries", SGAJsonObject, ResponseTxt);
            until rLineasProcess.Next() = 0;
    end;
    */
    //<<

    //>> Gestión Devolución de Venta
    procedure GestionDevolucionVenta(pNumDoc: Code[20]);
    var
        rSalesHeader: Record "Sales Header";
        rSalesLine: Record "Sales Line";
        rItem: Record Item;
        rCountry: Record "Country/Region";
        rLocation: Record Location;
        FechaTrabajoDT: DateTime;
        Procesarlinea: Boolean;
        FechaServicio: DateTime;
        FechaServicioTxt: Text[50];
        Name: Text[100];
        Address: Text[100];
        Address2: Text;
        City: Text[50];
        County: Text[50];
        Error01: Label 'There is a line item without a warehouse.',
                Comment = 'ESP="Exite una línea sin almacén"';
        Error02: Label 'Warehouse %1 does not exist.',
                Comment = 'ESP="El almacén %1 no existe"';
        Error03: Label 'Warehouse %1 does not allow returns in the SGA',
                Comment = 'ESP="EL almacén %1 no permite devoluciones en SGA"';
    begin
        if not cuSGAManagement.IsSGAEnabled() then exit;
        cuSGAManagement.InitializeSGAConfiguration(rSGASetup);

        rSalesHeader.Get(rSalesHeader."Document Type"::"Return Order", pNumDoc);
        rSalesHeader.TestField("Document Type");
        rSalesHeader.TestField("Sell-to Customer No.");
        rSalesHeader.TestField("Bill-to Customer No.");
        rSalesHeader.TestField("Posting Date");
        rSalesHeader.TestField("Document Date");
        rSalesHeader.TestField("Payment Method Code");
        rSalesHeader.TestField("Payment Terms Code");
        rSalesLine.SetRange("Document Type", rSalesHeader."Document Type");
        rSalesLine.SetRange("Document No.", rSalesHeader."No.");
        rSalesLine.SetRange(Type, rSalesLine.Type::Item);
        if rSalesLine.Findset() then
            repeat
                if rSalesLine.Type = rSalesLine.Type::Item then begin
                    if rSalesLine."Location Code" = '' then Error(Error01);
                    if not rLocation.Get(rSalesLine."Location Code") then Error(Error02, rSalesLine."Location Code");
                    if not rLocation."SGA Allows returns" then Error(Error03, rSalesLine."Location Code");
                end;
            until rSalesLine.Next() = 0;
        if rSalesLine.Findset() then
            repeat
                Procesarlinea := true;
                if rSalesLine.Type = rSalesLine.Type::Item then begin
                    rItem.Get(rSalesLine."No.");
                    Procesarlinea := rItem."SGA Item Management";
                end;
                if Procesarlinea then begin
                    if NOT rCountry.Get(rSalesHeader."Sell-to Country/Region Code") then CLEAR(rCountry);
                    if rSalesHeader."Requested Delivery Date" = 0D then
                        FechaServicioTxt := 'NULL'
                    else begin
                        FechaServicio := CreateDateTime(rSalesHeader."Requested Delivery Date", 0T);
                    end;
                    rLocation.Get(rSalesLine."Location Code");
                    Name := rSalesHeader."Sell-to Customer Name";
                    Address := rSalesHeader."Sell-to Address";
                    Address2 := rSalesHeader."Sell-to Address 2";
                    City := rSalesHeader."Sell-to City";
                    County := rSalesHeader."Sell-to County";
                    cuSGAManagement.ReemplazarCaracter(Name, '''', '');
                    cuSGAManagement.ReemplazarCaracter(Address, '''', '');
                    cuSGAManagement.ReemplazarCaracter(Address2, '''', '');
                    cuSGAManagement.ReemplazarCaracter(City, '''', '');
                    cuSGAManagement.ReemplazarCaracter(County, '''', '');
                    Clear(SGAJsonObject);
                    SGAJsonObject.Add('CodigoAlmacenWMS', rLocation."SGA Warehouse Code");
                    SGAJsonObject.Add('IdAlmacenERP', rSalesLine."Location Code");
                    SGAJsonObject.Add('CodigoAlmacenOrigenWMS', rLocation."SGA Warehouse Code");
                    SGAJsonObject.Add('IdAlmacenOrigenERP', rSalesLine."Location Code");
                    SGAJsonObject.Add('IdEmpresaERP', COMPANYNAME);
                    SGAJsonObject.Add('TipoDocumento', '370');
                    SGAJsonObject.Add('NumeroDocumento', rSalesHeader."No.");
                    SGAJsonObject.Add('CodigoOrdenante', rSalesHeader."Sell-to Customer No.");
                    SGAJsonObject.Add('NombreComercial', DELCHR(Name, '=', ''''''''));
                    SGAJsonObject.Add('Direccion', DELCHR(Address + ' ' + Address2, '=', ''''''''));
                    SGAJsonObject.Add('CP', rSalesHeader."Sell-to Post Code");
                    SGAJsonObject.Add('Poblacion', DELCHR(City, '=', ''''''''));
                    SGAJsonObject.Add('Provincia', County);
                    SGAJsonObject.Add('CodigoPaisISO', rSalesHeader."Sell-to Country/Region Code");
                    SGAJsonObject.Add('Pais', rCountry.Name);
                    SGAJsonObject.Add('ServicioDocumento', '{C,P}');
                    SGAJsonObject.Add('FechaAlta', cuSGAManagement.GetFechaHoraTrabajo);
                    SGAJsonObject.Add('FechaServicioPrevista', cuSGAManagement.GetFechaHoraTrabajo());
                    SGAJsonObject.Add('NumeroLinea', FORMAT(rSalesLine."Line No."));
                    SGAJsonObject.Add('CodigoArticulo', rSalesLine."No.");
                    SGAJsonObject.Add('CantidadPedidaUMB', rSalesLine."Return Qty. to Receive (Base)");
                    SGAJsonObject.Add('SituacionStock', '');
                    SGAJsonObject.Add('FechaAltaEnlace', cuSGAManagement.GetFechaHoraTrabajo);
                    //HttpCall(SGACallType::"Insertar devolucion venta", SGAJsonObject);
                    cuSGAManagement.HttpCall(SGACallProcedure::"Insert Sales Return", SGAJsonObject, ResponseTxt);
                end;
            until rSalesLine.Next() = 0;
        rSalesHeader."SGA Status" := rSalesHeader."SGA Status"::"SGA Sent";
        rSalesHeader."SGA Inserted" := CurrentDateTime;
        rSalesHeader.Modify();
    end;
    //<<

    //>>Recepción devolución venta
    procedure RecepDevVentas();
    var
        rTempPedidos: Record "Inventory Buffer" temporary;
        rTempLineas: Record "Inventory Buffer" temporary;
        rTempLotes: Record "Inventory Buffer" temporary;
        rSalesCommentLine: Record "Sales Comment Line";
        rTempPurchCommentLine: Record "Sales Comment Line" temporary;
        rSalesline: Record "Sales Line";
        rSalesHeader: Record "Sales Header";
        rTempSalesHeader: Record "Sales Header" temporary;
        rTempSalesLine: Record "Sales Line" temporary;
        rTempLineasID: Record "SGA Temporal SQL" temporary;
        Almacen: Code[10];
        TipoDocumento: Code[3];
        NumDocumentoTipo: Code[25];
        NumLineaTxt: Text[25];
        CodArticulo: Code[20];
        CantidadRecibirTxT: Text[25];
        NumLote: Text[25];
        FechaAltaTxt: Text[25];
        Numlinea: Integer;
        CantidadRecibirDec: Decimal;
        CantidadRecibir: Integer;
        Tipo: Code[3];
        NumDocumento: Code[20];
        Error01: Label 'No sales return exists', Comment = 'ESP="No existe la devolución de ventas"';
        Error02: Label 'Line does not exist', Comment = 'ESP="Línea no existe"';
        Error03: Label 'Outstanding quantity less than quantity to be received',
                Comment = 'ESP="Cantidad pendiente menor que cantidad a recibir"';
        Ok: Boolean;
        NumLineaComentario: Integer;
        IDBigTxt: Text;
        IDBig: BigInteger;
        TextoError: Text[250];
        Idioma: Text[2];

    begin
        if not cuSGAManagement.IsSGAEnabled() then exit;
        cuSGAManagement.InitializeSGAConfiguration(rSGASetup);

        Idioma := '5';
        rTempLineas.Reset();
        rTempLineas.DeleteAll();
        rTempLotes.Reset();
        rTempLotes.DeleteAll();
        rTempLineasID.Reset();
        rTempLineasID.DeleteAll();
        rTempPedidos.Reset();
        rTempPedidos.DeleteAll();
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'TipoDocumento eq ''370'' and IdEmpresaERP eq ''' + CompanyName +
                                    ''' and FechaProcesoEnlace eq null and (Resultado eq null OR Resultado eq '''')');
        //HttpCall(SGACallType::"Leer recepcion devolucion venta", SGAJsonObject);
        cuSGAManagement.HttpCall(SGACallProcedure::"Read Sales Return Receipt", SGAJsonObject, ResponseTxt);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for Index := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, Index);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('IdAlmacenERP', ValueText);
            Almacen := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('TipoDocumento', ValueText);
            TipoDocumento := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroDocumento', ValueText);
            NumDocumentoTipo := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroLinea', ValueText);
            NumLineaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CodigoArticulo', ValueText);
            CodArticulo := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CantidadPedidaUMB', ValueText);
            CantidadRecibirTxT := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroLote', ValueText);
            NumLote := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('FechaAltaEnlace', ValueText);
            FechaAltaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('FechaAltaEnlace', ValueText);
            FechaAltaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('ROWID', ValueText);
            IDBigTxt := ValueText;
            Evaluate(IDBig, IDBigTxt);
            Evaluate(Numlinea, NumLineaTxt);

            //>> BBT 28/08/2025. La cantidad debe ser entera (sin decimales)
            if Idioma <> '0' then
                Evaluate(CantidadRecibirDec, CantidadRecibirTxT)
            else
                cuSGAManagement.ConverTextoADecimal(CantidadRecibirTxT, CantidadRecibirDec);

            CantidadRecibir := cuSGAManagement.ConvertDecimalAEntero(CantidadRecibirDec);
            //<<

            //ExtraerNumDocTipo(_NumDocumentoTipo,_Tipo,_NumDocumento);
            NumDocumento := NumDocumentoTipo;
            Tipo := TipoDocumento;
            rTempLineasID.INIT;
            rTempLineasID.ID := IDBig;
            rTempLineasID.Tipo := Tipo;
            rTempLineasID."No. Documento" := NumDocumento;
            rTempLineasID.Insert();
            rTempPedidos.INIT;
            rTempPedidos."Item No." := NumDocumento;
            if NOT rTempPedidos.Find() then rTempPedidos.Insert();
            rTempLineas.INIT;
            rTempLineas."Item No." := NumDocumento;
            rTempLineas."Variant Code" := Tipo;
            rTempLineas."Dimension Entry No." := Numlinea;
            if NOT rTempLineas.Find() then rTempLineas.Insert();
            rTempLineas.Quantity += CantidadRecibir;
            rTempLineas.Modify();
            if NumLote <> '' then begin
                rTempLotes.INIT;
                rTempLotes."Item No." := NumDocumento;
                rTempLotes."Variant Code" := Tipo;
                rTempLotes."Dimension Entry No." := Numlinea;
                rTempLotes."Serial No." := NumLote;
                if NOT rTempLotes.Find() then rTempLotes.Insert();
                rTempLotes.Quantity := CantidadRecibir;
                rTempLotes.Modify();
            end;
        end;
        // Actualizar pedido a recibir
        // Registrar
        rTempPedidos.Reset();
        rTempLineas.Reset();
        rTempLotes.Reset();
        if rTempPedidos.Findset() then
            repeat
                rTempSalesHeader.Reset();
                rTempSalesLine.Reset();
                rTempSalesHeader.DeleteAll();
                rTempSalesLine.DeleteAll();
                TextoError := '';
                rTempPurchCommentLine.Reset();
                rTempPurchCommentLine.DeleteAll();
                if NOT rSalesHeader.Get(rSalesHeader."Document Type"::"Return Order", rTempPedidos."Item No.") then TextoError := Error01;
                if TextoError = '' then begin
                    rTempSalesHeader.INIT;
                    rTempSalesHeader := rSalesHeader;
                    rTempSalesHeader.Insert();
                    rSalesline.SetRange("Document Type", rSalesline."Document Type"::"Return Order");
                    rSalesline.SetRange("Document No.", rTempPedidos."Item No.");
                    if rSalesline.FindSet(true) then
                        repeat
                            rTempSalesLine.INIT;
                            rTempSalesLine := rSalesline;
                            rTempSalesLine.Insert();
                            if NOT ValidarCantDevVentaBase(rSalesline, 0) then
                                TextoError := CopyStr(GetLastErrorText, 1, 250)
                            else
                                rSalesline.Modify();
                        until (rSalesline.Next() = 0) OR (TextoError <> '');
                    rSalesline.Reset();
                    if TextoError = '' then begin
                        rSalesCommentLine.Reset();
                        rSalesCommentLine.SetRange("Document Type", rSalesHeader."Document Type");
                        rSalesCommentLine.SetRange("No.", rSalesHeader."No.");
                        if rSalesCommentLine.FINDLAST then
                            NumLineaComentario := rSalesCommentLine."Line No."
                        else
                            NumLineaComentario := 0;
                        rTempLineas.SetRange("Variant Code", '370');
                        rTempLineas.SetRange("Item No.", rSalesHeader."No.");
                        if rTempLineas.Findset() then
                            repeat
                                if NOT rSalesline.Get(rSalesHeader."Document Type", rSalesHeader."No.", rTempLineas."Dimension Entry No.") then
                                    TextoError := Error02
                                else if rSalesline."Outstanding Qty. (Base)" < rTempLineas.Quantity then TextoError := Error03;
                                if TextoError = '' then if NOT ValidarCantDevVentaBase(rSalesline, rTempLineas.Quantity) then TextoError := CopyStr(GetLastErrorText, 1, 250);
                                if TextoError = '' then;
                                //Se meteran en comentario de linea
                                begin
                                    rTempLotes.SetRange("Item No.", rSalesHeader."No.");
                                    rTempLotes.SetRange("Variant Code", '370');
                                    rTempLotes.SetRange("Dimension Entry No.", rSalesline."Line No.");
                                    if rTempLotes.Findset() then
                                        repeat
                                            NumLineaComentario += 10000;
                                            rSalesCommentLine.INIT;
                                            rSalesCommentLine."Document Type" := rSalesHeader."Document Type";
                                            rSalesCommentLine."No." := rSalesHeader."No.";
                                            rSalesCommentLine."Document Line No." := rSalesline."Line No.";
                                            rSalesCommentLine."Line No." := NumLineaComentario;
                                            rSalesCommentLine.Comment := 'Lote: ' + rTempLotes."Serial No." + ' / Ctd.: ' + FORMAT(rTempLotes.Quantity, 0);
                                            rSalesCommentLine.Insert();
                                            rTempPurchCommentLine := rSalesCommentLine;
                                            rTempPurchCommentLine.Insert();
                                        until rTempLotes.Next() = 0;
                                end;
                            until rTempLineas.Next() = 0;
                    end;
                    if TextoError = '' then
                        if NOT RegistrarDevVenta(rSalesHeader) then begin
                            TextoError := CopyStr(GetLastErrorText, 1, 250);
                            rTempPurchCommentLine.Reset();
                            if rTempPurchCommentLine.Findset() then begin
                                rSalesCommentLine := rTempPurchCommentLine;
                                if rSalesCommentLine.Find() then rSalesCommentLine.Delete();
                            end;
                            rTempSalesHeader.Reset();
                            rSalesHeader.Reset();
                            CLEAR(rSalesHeader);
                            if rTempSalesHeader.FINDFIRST then begin
                                rSalesHeader.INIT;
                                if rSalesHeader.Get(rTempSalesHeader."Document Type", rTempSalesHeader."No.") then begin
                                    rSalesHeader.TRANSFERFIELDS(rTempSalesHeader, false);
                                    rSalesHeader."Posting Date" := WorkDate();   // Fecha registro es la WorkDate
                                    rSalesHeader.Modify();
                                end;
                            end;
                            rTempSalesLine.Reset();
                            rSalesline.Reset();
                            CLEAR(rSalesline);
                            if rTempSalesLine.Findset() then
                                repeat
                                    rSalesline.INIT;
                                    if rSalesline.Get(rTempSalesLine."Document Type", rTempSalesLine."Document No.", rTempSalesLine."Line No.") then begin
                                        rSalesline.TransferFields(rTempSalesLine, false);
                                        rSalesline.Modify();
                                    end;
                                until rTempSalesLine.Next() = 0;
                        end
                        else begin
                            rSalesHeader."SGA Readed" := CurrentDateTime;
                            if rSalesHeader.MODifY then;
                        end;
                end;
                if TextoError = '' then TextoError := 'CORRECTO';
                cuSGAManagement.ReemplazarCaracter(TextoError, '''', '');
                rTempLineasID.Reset();
                rTempLineasID.SetRange(Tipo, '370');
                rTempLineasID.SetRange("No. Documento", rTempPedidos."Item No.");
                if rTempLineasID.Findset() then
                    repeat
                        Clear(SGAJsonObject);
                        SGAJsonObject.Add('FechaProcesoEnlace', cuSGAManagement.GetFechaHoraTrabajo());
                        SGAJsonObject.Add('Resultado', TextoError);
                        SGAJsonObject.Add('RowId', Format(rTempLineasID.ID));
                        //HttpCall(SGACallType::"Actualizar documento", SGAJsonObject);
                        cuSGAManagement.HttpCall(SGACallProcedure::"Update Document", SGAJsonObject, ResponseTxt);
                    until rTempLineasID.Next() = 0;
            until rTempPedidos.Next() = 0;
    end;

    //>> Pedido Transferencia ERP-->SGA
    procedure "PedidoTransferencia-->SGA"(pNumDoc: Code[20]; pDirection: Option Ship,Receive,Receive2; var pTempLineasOLD: Record "Transfer Line" temporary; pBorrar: Boolean);
    var
        rTransferHeader: Record "Transfer Header";
        rLocation: Record Location;
        rTransferLine: Record "Transfer Line";
        AlmEnvioSGA: Boolean;
        AlmRecepSGA: Boolean;
        Tipo: Code[3];
        Cantidad: Decimal;
        FechaServicio: DateTime;
        FechaServicioTxt: Text;
        CodAlmEnvioSGA: Text[10];
        CodAlmRecepSGA: Text[10];
    begin
        if not cuSGAManagement.IsSGAEnabled() then exit;
        cuSGAManagement.InitializeSGAConfiguration(rSGASetup);

        rTransferHeader.Get(pNumDoc);
        rLocation.Get(rTransferHeader."Transfer-from Code");
        AlmEnvioSGA := rLocation."SGA Enabled";
        CodAlmEnvioSGA := rLocation."SGA Warehouse Code";
        rLocation.Get(rTransferHeader."Transfer-to Code");
        AlmRecepSGA := rLocation."SGA Enabled";
        CodAlmRecepSGA := rLocation."SGA Warehouse Code";
        rTransferLine.Reset();
        rTransferLine.SetRange("Document No.", rTransferHeader."No.");
        rTransferLine.SetRange("Derived From Line No.", 0);
        rTransferLine.SetFilter("Item No.", '<>%1', '');
        if rTransferLine.Findset() then
            repeat
                pTempLineasOLD.Get(rTransferLine."Document No.", rTransferLine."Line No.");
                Tipo := '';
                Cantidad := 0;
                CASE pDirection OF
                    pDirection::Ship:
                        begin
                            Tipo := '210';
                            Cantidad := pTempLineasOLD."Qty. to Ship (Base)";
                        end;
                    pDirection::Receive:
                        begin
                            Tipo := '310';
                            if pTempLineasOLD."Qty. to Ship (Base)" > 0 then
                                Cantidad := pTempLineasOLD."Qty. to Ship (Base)"
                            else
                                Cantidad := pTempLineasOLD."Qty. Shipped (Base)";
                        end;
                    pDirection::Receive2:
                        begin
                            Tipo := '310';
                            Cantidad := pTempLineasOLD."Qty. to Receive (Base)";
                        end;
                end;
                if rTransferHeader."Posting Date" = 0D then
                    FechaServicioTxt := 'NULL'
                else begin
                    FechaServicio := CreateDateTime(rTransferHeader."Posting Date", 0T);
                end;
                Clear(SGAJsonObject);
                SGAJsonObject.Add('CodigoAlmacenWMS', CodAlmRecepSGA);
                SGAJsonObject.Add('IdAlmacenERP', rTransferLine."Transfer-to Code");
                SGAJsonObject.Add('CodigoAlmacenOrigenWMS', CodAlmEnvioSGA);
                SGAJsonObject.Add('IdAlmacenOrigenERP', rTransferLine."Transfer-from Code");
                SGAJsonObject.Add('IdEmpresaERP', COMPANYNAME);
                SGAJsonObject.Add('TipoDocumento', Tipo);
                SGAJsonObject.Add('NumeroDocumento', rTransferHeader."No.");
                SGAJsonObject.Add('FechaAlta', cuSGAManagement.GetFechaHoraTrabajo);
                if FechaServicioTxt = 'NULL' then
                    SGAJsonObject.Add('FechaServicioPrevista', FechaServicioTxt)
                else
                    SGAJsonObject.Add('FechaServicioPrevista', FechaServicio);
                SGAJsonObject.Add('NumeroLinea', FORMAT(rTransferLine."Line No."));
                SGAJsonObject.Add('CodigoArticulo', rTransferLine."Item No.");
                SGAJsonObject.Add('CantidadPedidaUMB', Cantidad);
                SGAJsonObject.Add('FechaAltaEnlace', cuSGAManagement.GetFechaHoraTrabajo);
                //HttpCall(SGACallType::"Insertar pedido transferencia", SGAJsonObject);
                cuSGAManagement.HttpCall(SGACallProcedure::"Insert Transfer Order", SGAJsonObject, ResponseTxt);
            until rTransferLine.Next() = 0;
        if NOT pBorrar then begin
            rTransferHeader."SGA Status" := rTransferHeader."SGA Status"::"SGA Sent";
            rTransferHeader."SGA Inserted" := CurrentDateTime;
            rTransferHeader.Modify();
        end;
    end;
    //<<

    //>> Pedido transferencia ERP <-- SGA
    procedure "PedidoTransferencia<--SGA"();
    var
        rTempLineas: Record "Inventory Buffer" temporary;
        rTempPedidos: Record "Inventory Buffer" temporary;
        rTempLineasID: Record "SGA Temporal SQL" temporary;
        rTempTransferLine: Record "Transfer Line" temporary;
        rTransferHeader: Record "Transfer Header";
        rTransferLine: Record "Transfer Line";
        rLocationFrom: Record Location;
        rLocationTo: Record Location;
        Almacen: Code[10];
        TipoDocumento: Code[3];
        NumLineaTxt: Text[25];
        CodArticulo: Code[20];
        CantidadRecibirTxT: Text[25];
        NumLote: Text[25];
        FechaAltaTxt: Text[25];
        Numlinea: Integer;
        CantidadRecibirDec: Decimal;
        CantidadRecibir: Integer;
        Tipo: Code[3];
        NumDocumento: Code[20];
        TextoError: Text[250];
        IDBigTxt: Text;
        IDBig: BigInteger;
        Idioma: Text[2];
        Error01: Label 'Line does not exist', Comment = 'ESP="La línea no existe"';
        Error02: Label 'Transfer order does not exist', Comment = 'ESP="El pedido de transferencia no existe"';
        ErrorAntes: Boolean;
        AlmacenOrigen: Code[10];
    begin
        if not cuSGAManagement.IsSGAEnabled() then exit;
        cuSGAManagement.InitializeSGAConfiguration(rSGASetup);

        Idioma := '5';
        rTempLineasID.Reset();
        rTempLineasID.DeleteAll();
        rTempLineas.Reset();
        rTempLineas.DeleteAll();
        rTempPedidos.Reset();
        rTempPedidos.DeleteAll();
        TextoError := '';
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', '(StartsWith(TipoDocumento ,''31'') or StartsWith(TipoDocumento ,''21''))and FechaProcesoEnlace eq null and (Resultado eq null OR Resultado eq '''') and IdEmpresaERP eq ''' + CompanyName + '''');
        //HttpCall(SGACallType::"Leer pedido transferencia", SGAJsonObject);
        cuSGAManagement.HttpCall(SGACallProcedure::"Read Transfer Order", SGAJsonObject, ResponseTxt);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for Index := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, Index);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('IdAlmacenERP', ValueText);
            Almacen := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('IdAlmacenOrigenERP', ValueText);
            AlmacenOrigen := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('TipoDocumento', ValueText);
            TipoDocumento := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroDocumento', ValueText);
            NumDocumento := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroLinea', ValueText);
            NumLineaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CodigoArticulo', ValueText);
            CodArticulo := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CantidadServidaUMB', ValueText);
            CantidadRecibirTxT := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroLote', ValueText);
            NumLote := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('FechaAltaEnlace', ValueText);
            FechaAltaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('ROWID', ValueText);
            IDBigTxt := ValueText;
            Evaluate(IDBig, IDBigTxt);
            Evaluate(Numlinea, NumLineaTxt);

            //>> BBT 28/08/2025. La cantidad debe ser entera (sin decimales)
            if Idioma <> '0' then
                Evaluate(CantidadRecibirDec, CantidadRecibirTxT)
            else
                cuSGAManagement.ConverTextoADecimal(CantidadRecibirTxT, CantidadRecibirDec);

            CantidadRecibir := cuSGAManagement.ConvertDecimalAEntero(CantidadRecibirDec);
            //<<

            if CodArticulo <> '' then begin
                rTempLineasID.INIT;
                rTempLineasID.ID := IDBig;
                rTempLineasID.Tipo := TipoDocumento;
                rTempLineasID."No. Documento" := NumDocumento;
                rTempLineasID.Insert();
                rTempPedidos.INIT;
                rTempPedidos."Bin Code" := NumDocumento;
                rTempPedidos."Variant Code" := TipoDocumento;
                if NOT rTempPedidos.Find() then rTempPedidos.Insert();
                rTempLineas.INIT;
                rTempLineas."Bin Code" := NumDocumento;
                rTempLineas."Variant Code" := TipoDocumento;
                rTempLineas."Dimension Entry No." := Numlinea;
                rTempLineas."Item No." := CodArticulo;
                if NOT rTempLineas.Find() then rTempLineas.Insert();
                rTempLineas.Quantity += CantidadRecibir;
                rTempLineas.Modify();
            end;
        end;
        rTempPedidos.Reset();
        rTempPedidos.SetFilter("Variant Code", '21?');
        if rTempPedidos.Findset() then begin
            repeat
                ErrorAntes := false;
                TextoError := '';
                rTransferLine.Reset();
                rTransferLine.SetRange("Document No.", rTempPedidos."Bin Code");
                rTransferLine.SetRange("Derived From Line No.", 0);
                rTransferLine.SetFilter("Item No.", '<>%1', '');
                if rTransferLine.FindSet(true) then
                    repeat
                        if NOT ValidarCantEnviarTrans(rTransferLine, 0) then
                            TextoError := CopyStr(GetLastErrorText, 1, 250)
                        else
                            rTransferLine.Modify();
                    until (rTransferLine.Next() = 0) OR (TextoError <> '');
                rTransferLine.Reset();
                if TextoError = '' then begin
                    rTempLineas.Reset();
                    rTempTransferLine.Reset();
                    rTempTransferLine.DeleteAll();
                    rTempLineas.SetRange("Bin Code", rTempPedidos."Bin Code");
                    rTempLineas.SetRange("Variant Code", rTempPedidos."Variant Code");
                    if rTempLineas.Findset() then
                        repeat
                            if rTransferLine.Get(rTempLineas."Bin Code", rTempLineas."Dimension Entry No.") then begin
                                rTempTransferLine.Init();
                                ;
                                rTempTransferLine := rTransferLine;
                                rTempTransferLine.Insert();
                            end
                            else begin
                                TextoError := Error01;
                                ErrorAntes := true;
                            end;
                        until (rTempLineas.Next() = 0) OR (TextoError <> '');
                end;
                if TextoError = '' then
                    if rTempLineas.Findset() then
                        repeat
                            if rTransferLine.Get(rTempLineas."Bin Code", rTempLineas."Dimension Entry No.") then begin
                                if NOT ValidarCantEnviarTrans(rTransferLine, rTempLineas.Quantity) then
                                    TextoError := CopyStr(GetLastErrorText, 1, 250)
                                else
                                    rTransferLine.Modify();
                            end
                            else
                                TextoError := Error01;
                        until (rTempLineas.Next() = 0) OR (TextoError <> '');
                if NOT rTransferHeader.Get(rTempPedidos."Bin Code") then TextoError := Error02;
                if TextoError = '' then if NOT RegistrarEnvioTrans(rTransferHeader) then TextoError := CopyStr(GetLastErrorText, 1, 250);
                if TextoError = '' then begin
                    TextoError := 'CORRECTO';
                end
                else if not ErrorAntes then begin
                    rTempTransferLine.Reset();
                    rTransferLine.Reset();
                    CLEAR(rTransferLine);
                    if rTempTransferLine.Findset() then
                        repeat
                            rTransferLine.INIT;
                            if rTransferLine.Get(rTempTransferLine."Document No.", rTempTransferLine."Line No.") then begin
                                rTransferLine.TRANSFERFIELDS(rTempTransferLine, false);
                                rTransferLine.Modify();
                            end;
                        until rTempTransferLine.Next() = 0;
                end;
                rTempLineasID.Reset();
                rTempLineasID.SetFilter(Tipo, '21?');
                rTempLineasID.SetRange("No. Documento", rTransferHeader."No.");
                rTempLineasID.MODifYALL(Error, TextoError);
            until rTempPedidos.Next() = 0;
            //>> 06/2022. USO DE VARIOS ALMACENES SGA
            // Cuando el almacén de salida es SGA y el de recepción tambien es SGA
            // Se procesa la acción de enviar (210) que viene del SGA --> se crea una
            // transacción de recepción (310) en almacen de recepción con SGA
            //
            rTempPedidos.Reset();
            rTempPedidos.SetFilter("Variant Code", '21?');
            if rTempPedidos.Findset() then
                repeat
                    rTransferHeader.Reset();
                    rLocationFrom.Reset();
                    rLocationTo.Reset();
                    rTransferHeader.Get(rTempPedidos."Bin Code");
                    rLocationFrom.Get(rTransferHeader."Transfer-from Code");
                    rLocationTo.Get(rTransferHeader."Transfer-to Code");
                    if rLocationFrom."SGA Enabled" AND rLocationTo."SGA Enabled" then begin //Los 2 almacenes son SGA
                        rTempLineasID.Reset();
                        rTempLineasID.SetFilter(Tipo, '21?');
                        rTempLineasID.SetRange("No. Documento", rTempPedidos."Bin Code");
                        rTempLineasID.SetRange(Error, 'CORRECTO'); //Solo se procesan las 210 que son CORRECTAS
                        if rTempLineasID.Findset() then begin
                            rTempLineas.Reset();
                            rTempLineas.SetRange("Bin Code", rTempPedidos."Bin Code");
                            rTempLineas.SetRange("Variant Code", rTempPedidos."Variant Code");
                            if rTempLineas.Findset() then begin
                                //  El procedimiento "PedidoTransferencia-->SGA" traspasa todas las lineas de la transferencia.
                                //  No hace falta pasarle linea a linea (NO se usa el repeat para leer todas las lineas)
                                //          repeat
                                rTransferLine.SetCurrentKey("Document No.", "Line No.");
                                if rTransferLine.Get(rTempLineas."Bin Code", rTempLineas."Dimension Entry No.") then begin
                                    "PedidoTransferencia-->SGA"(rTransferHeader."No.", 2, rTransferLine, true);
                                end;
                                //          until (rTempLineas.Next() = 0);
                            end;
                        end;
                    end;
                until rTempPedidos.Next() = 0;
            //
            //<< 06/2022. USO DE VARIOS ALMACENES SGA
        end;
        rTempPedidos.Reset();
        rTempPedidos.SetFilter("Variant Code", '31?');
        if rTempPedidos.Findset() then
            repeat
                TextoError := '';
                ErrorAntes := false;
                rTransferLine.Reset();
                rTransferLine.SetRange("Document No.", rTempPedidos."Bin Code");
                rTransferLine.SetRange("Derived From Line No.", 0);
                rTransferLine.SetFilter("Item No.", '<>%1', '');
                if rTransferLine.FindSet(true) then
                    repeat
                        if NOT ValidarCantRecepTrans(rTransferLine, 0) then
                            TextoError := CopyStr(GetLastErrorText, 1, 250)
                        else
                            rTransferLine.Modify();
                    until (rTransferLine.Next() = 0) OR (TextoError <> '');
                rTransferLine.Reset();
                if TextoError = '' then begin
                    rTempTransferLine.Reset();
                    rTempTransferLine.DeleteAll();
                    rTempLineas.Reset();
                    rTempLineas.SetRange("Bin Code", rTempPedidos."Bin Code");
                    rTempLineas.SetRange("Variant Code", rTempPedidos."Variant Code");
                    if rTempLineas.Findset() then
                        repeat
                            if rTransferLine.Get(rTempLineas."Bin Code", rTempLineas."Dimension Entry No.") then begin
                                rTempTransferLine.INIT;
                                rTempTransferLine := rTransferLine;
                                rTempTransferLine.Insert();
                            end
                            else begin
                                TextoError := Error01;
                                ErrorAntes := true;
                            end;
                        until (rTempLineas.Next() = 0) OR (TextoError <> '');
                end;
                if TextoError = '' then
                    if rTempLineas.Findset() then
                        repeat
                            if rTransferLine.Get(rTempLineas."Bin Code", rTempLineas."Dimension Entry No.") then
                                if NOT ValidarCantRecepTrans(rTransferLine, rTempLineas.Quantity) then
                                    TextoError := CopyStr(GetLastErrorText, 1, 250)
                                else
                                    rTransferLine.Modify();
                        until (rTempLineas.Next() = 0) OR (TextoError <> '');
                //>> BBT 22/12/2025. Asignamos la fecha actual como la de registro        
                //if NOT rTransferHeader.Get(rTempPedidos."Bin Code") then _TextoError := 'El pedido de transferencia no existe.';
                if rTransferHeader.Get(rTempPedidos."Bin Code") then begin
                    rTransferHeader."Posting Date" := WorkDate();   // Fecha de Registro es la WorkDate
                    rTransferHeader.Modify();
                end
                else
                    TextoError := 'El pedido de transferencia no existe.';
                //<<
                if TextoError = '' then
                    if NOT RegistrarRecepTrans(rTransferHeader) then TextoError := CopyStr(GetLastErrorText, 1, 250);
                if TextoError = '' then
                    TextoError := 'CORRECTO'
                else if NOT ErrorAntes then begin
                    rTempTransferLine.Reset();
                    rTransferLine.Reset();
                    CLEAR(rTransferLine);
                    if rTempTransferLine.Findset() then
                        repeat
                            rTransferLine.INIT;
                            if rTransferLine.Get(rTempTransferLine."Document No.", rTempTransferLine."Line No.") then begin
                                rTransferLine.TRANSFERFIELDS(rTempTransferLine, false);
                                rTransferLine.Modify();
                            end;
                        until rTempTransferLine.Next() = 0;
                end;
                rTempLineasID.Reset();
                rTempLineasID.SetFilter(Tipo, '31?');
                rTempLineasID.SetRange("No. Documento", rTransferHeader."No.");
                rTempLineasID.MODifYALL(Error, TextoError);
            until rTempPedidos.Next() = 0;
        rTempLineasID.Reset();
        cuSGAManagement.ReemplazarCaracter(TextoError, '''', '');
        if rTempLineasID.Findset() then
            repeat
                Clear(SGAJsonObject);
                SGAJsonObject.Add('FechaProcesoEnlace', cuSGAManagement.GetFechaHoraTrabajo());
                SGAJsonObject.Add('Resultado', TextoError);
                SGAJsonObject.Add('RowId', FORMAT(rTempLineasID.ID));
                //HttpCall(SGACallType::"Actualizar documento", SGAJsonObject);
                cuSGAManagement.HttpCall(SGACallProcedure::"Update Document", SGAJsonObject, ResponseTxt);
            until rTempLineasID.Next() = 0;
    end;
    //<<

    // Ajuste Movimientos de Regularización Stock SGA -->> ERP
    procedure AjustesStock();
    var
        rItemJournalLine: Record "Item Journal Line";
        rNoSeries: Codeunit "No. Series";
        rItemJournalBatch: Record "Item Journal Batch";
        rItem: Record Item;
        TextoError: Text[250];
        FechaTxt: Text[50];
        FechaHora: DateTime;
        Fecha: Date;
        Error01: Label 'Incorrect registration date', Comment = 'ESP="Fecha registro incorrecta"';
        Error02: Label 'Jump', Comment = 'ESP="Saltar"';
        Error03: Label 'Does not exist as a item ', Comment = 'ESP="No existe el producto "';
        CantidadTxt: Text[25];
        CantidadDec: Decimal;
        Cantidad: Integer;
        CodProducto: Code[20];
        Almacen: Code[10];
        IDBig: BigInteger;
        IDBigTxt: Text;
        NumDoc: Code[20];
        idioma: Text[2];
        Filtros: array[2] of Text[30];
        ii: Integer;
        Saltar: Boolean;
        DescripTM: Text[250];
        MovSGA: Text[250];
    begin
        if not cuSGAManagement.IsSGAEnabled() then exit;
        cuSGAManagement.InitializeSGAConfiguration(rSGASetup);

        idioma := '5';
        rItemJournalBatch.Get(rSGASetup."Journal Template Name", rSGASetup."Journal Batch Name");
        rItemJournalBatch.TestField("No. Series");

        CLEAR(rNoSeries);
        Filtros[1] := ' AND CantidadMovimiento gt 0'; //gt es mayor que --> _i = 1 : Primero los movimientos positivos
        Filtros[2] := ' AND CantidadMovimiento lt 0'; //lt es menor que --> _i = 2 : Segundo los movimientos negativos
        FOR ii := 1 TO 2 DO begin
            TextoError := '';
            rItemJournalLine.SetRange("Journal Template Name", rSGASetup."Journal Template Name");
            rItemJournalLine.SetRange("Journal Batch Name", rSGASetup."Journal Batch Name");
            rItemJournalLine.DeleteAll();
            Clear(SGAJsonObject);
            Clear(ResponseTxt);
            SGAJsonObject.Add('filter', 'FechaProcesoEnlace eq null and CodigoArticulo ne '''' and (Resultado eq null OR Resultado eq '''')' + Filtros[ii]);
            //HttpCall(SGACallType::"Leer ajustes stock", SGAJsonObject);
            cuSGAManagement.HttpCall(SGACallProcedure::"Read Stock Adjustments", SGAJsonObject, ResponseTxt);
            //Read Json
            Clear(ArrayJSONManagement);
            Clear(ObjectJSONManagement);
            ArrayJSONManagement.InitializeCollection(ResponseTxt);
            //>> Solo cogemos numero de serie SGA si hay lineas pendientes de procesar.
            if ArrayJSONManagement.GetCollectionCount() > 0 then
                NumDoc := rNoSeries.GetNextNo(rItemJournalBatch."No. Series", TODAY, true);
            //<<
            for Index := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
                ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, Index);
                ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
                ObjectJSONManagement.GetStringPropertyValueByName('CodigoArticulo', ValueText);
                CodProducto := ValueText;
                ObjectJSONManagement.GetStringPropertyValueByName('CantidadMovimiento', ValueText);
                CantidadTxt := ValueText;
                ObjectJSONManagement.GetStringPropertyValueByName('IdAlmacenERP', ValueText);
                Almacen := ValueText;
                ObjectJSONManagement.GetStringPropertyValueByName('ROWID', ValueText);
                IDBigTxt := ValueText;
                ObjectJSONManagement.GetStringPropertyValueByName('DescripcionTipoMovimiento', ValueText);
                DescripTM := ValueText;
                ObjectJSONManagement.GetStringPropertyValueByName('NumeroMovimiento', ValueText);
                MovSGA := ValueText;
                ObjectJSONManagement.GetStringPropertyValueByName('FechaMovimiento', ValueText);
                FechaTxt := ValueText;

                Evaluate(IDBig, IDBigTxt);

                //>> BBT 28/08/2025. La cantidad debe ser entera (sin decimales)
                if idioma <> '0' then
                    Evaluate(CantidadDec, CantidadTxt)
                else
                    cuSGAManagement.ConverTextoADecimal(CantidadTxt, CantidadDec);

                Cantidad := cuSGAManagement.ConvertDecimalAEntero(CantidadDec);
                //<<

                Saltar := false;
                TextoError := '';
                if ii = 2 then
                    if rItem.Get(CodProducto) then begin
                        rItem.SetRange("Location Filter", Almacen);
                        rItem.CALCFIELDS(Inventory);
                        Saltar := rItem.Inventory < ABS(Cantidad);
                        //Message('Inventario: ' + format(rItem.Inventory) + ' | Cantidad' + format(ABS(_Cantidad)));
                        if Saltar then TextoError := Error02;
                    end
                    else
                        TextoError := Error03 + CodProducto;
                //Message('vuelta ' + format(_i) + 'Inventario: ' + format(rItem.Inventory) + ' | Cantidad' + format(ABS(_Cantidad)) + ' | producto' + format((_IDBig)) + ' | producto' + rItem."no." + ' | Saltar:' + format(_Saltar));
                if NOT Saltar then begin
                    if TextoError = '' then begin
                        if NOT Evaluate(FechaHora, FechaTxt) then TextoError := Error01;
                    end;
                    if TextoError = '' then begin
                        Fecha := DT2DATE(FechaHora);
                        rItemJournalLine.INIT;
                        rItemJournalLine."Journal Template Name" := rSGASetup."Journal Template Name";
                        rItemJournalLine."Journal Batch Name" := rSGASetup."Journal Batch Name";
                        rItemJournalLine."Line No." := GetLastJournalLine(rItemJournalLine."Journal Template Name", rItemJournalLine."Journal Batch Name");
                        rItemJournalLine."Location Code" := Almacen;
                        rItemJournalLine."Posting Date" := Fecha;
                        rItemJournalLine."Document No." := NumDoc;
                        //>> BBT 20251201. Ponemos el 'Tipo de Entrada' como 'Ajuste Positivo' porque por defecto es 'Compras' y si el producto está bloqueado 
                        //                 de compras da error en el validate del producto.
                        //                 En la procedure 'CantidadLineaDiario' se cambia el 'Tipo de Entrada' al ajuste correcto.              
                        rItemJournalLine."Entry Type" := rItemJournalLine."Entry Type"::"Positive Adjmt.";
                        //<<
                        rItemJournalLine.Insert();


                        if NOT ProductoLineaDiario(rItemJournalLine, CodProducto) then TextoError := CopyStr(GetLastErrorText, 1, 250);
                        if TextoError = '' then if NOT CantidadLineaDiario(rItemJournalLine, Cantidad) then TextoError := CopyStr(GetLastErrorText, 1, 250);
                        if TextoError = '' then begin
                            //>> BBT. 07/02/2022. Identificacion movimientos de ajuste de SGA
                            rItemJournalLine."Transaction Type" := '00';
                            rItemJournalLine.Description := CopyStr(DescripTM, 1, 50);
                            rItemJournalLine."External Document No." := CopyStr(MovSGA, 1, 35);
                            //<<
                            rItemJournalLine.Modify();

                            if NOT RegistrarLineaDiario(rItemJournalLine) then TextoError := CopyStr(GetLastErrorText, 1, 250);
                        end;
                    end;

                    if TextoError = '' then TextoError := 'CORRECTO';
                    cuSGAManagement.ReemplazarCaracter(TextoError, '''', '');

                    //>> Marcamos cada registro despues de su procesamiento
                    Clear(SGAJsonObject);
                    SGAJsonObject.Add('FechaProcesoEnlace', cuSGAManagement.GetFechaHoraTrabajo());
                    SGAJsonObject.Add('Resultado', TextoError);
                    SGAJsonObject.Add('RowId', FORMAT(IDBig));
                    //HttpCall(SGACallType::"Actualizar ajustes stock", SGAJsonObject);
                    cuSGAManagement.HttpCall(SGACallProcedure::"Update Stock Adjustments", SGAJsonObject, ResponseTxt);
                    //<<
                end
            end;
        end;
    end;
    //<<

    //>> BBT 01/07/2026. OBSOLETO. NO SE USA.
    /*
    //>> Comparativa Inventario SAG vs ERP
    procedure CuadreInventario(pJournalTemplateName: Code[10]; pJournalBatchName: Code[10]; pFiltroAlmacen: Text[250]);
    var
        rTempLineas: Record "Invoice Posting Buffer" temporary;
        rTempLineasAcrear: Record "Invoice Posting Buffer" temporary;
        rSGATemporalSQL: Record "SGA Temporal SQL" temporary;
        rItemJournalLine: Record "Item Journal Line";
        FechaTxt: Text[50];
        FechaHora: DateTime;
        Fecha: Date;
        CantidadTxt: Text[25];
        CantidadDec: Decimal;
        Cantidad: Integer;
        CodProducto: Code[20];
        Almacen: Code[10];
        TextoError: Text[250];
        Canti: Integer;
        NumLinea: Integer;
        NumDoc: Code[20];
        Idioma: Text[2];
        Dialogo: Dialog;
    begin
        if not cuSGAManagement.IsSGAEnabled() then exit;
        cuSGAManagement.InitializeSGAConfiguration(rSGASetup);

        Idioma := '5';
        TextoError := '';
        rTempLineas.Reset();
        rTempLineas.DeleteAll();
        rSGATemporalSQL.Reset();
        rSGATemporalSQL.DeleteAll();
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'IdEmpresaERP eq ''' + CompanyName + ''''); 
        //HttpCall(SGACallType::"Leer cuadre inventario stock", SGAJsonObject);
        cuSGAManagement.HttpCall(SGACallProcedure::"Read Stock Inventory Reconciliation", SGAJsonObject, ResponseTxt);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        Dialogo.OPEN('Producto: #1############');
        for Index := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, Index);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('IdAlmacenERP', ValueText);
            Almacen := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CodigoArticulo', ValueText);
            CodProducto := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CantidadAbsoluta', ValueText);
            CantidadTxt := ValueText;
            TextoError := '';
            Dialogo.UPDATE(1, CodProducto);

            //>> BBT 28/08/2025. La cantidad debe ser entera (sin decimales)
            if Idioma <> '0' then
                Evaluate(CantidadDec, CantidadTxt)
            else
                cuSGAManagement.ConverTextoADecimal(CantidadTxt, CantidadDec);

            Cantidad := cuSGAManagement.ConvertDecimalAEntero(CantidadDec);
            //<<  

            CLEAR(rTempLineas);
            rTempLineas.INIT;
            rTempLineas."G/L Account" := CodProducto;
            rTempLineas."Gen. Bus. Posting Group" := Almacen;
            if NOT rTempLineas.Find() then rTempLineas.Insert();
            rTempLineas.Quantity += Cantidad;
            rTempLineas.Modify();
        end;
        Dialogo.Close();
        rTempLineas.Reset();
        if NOT rTempLineas.ISEMPTY then begin
            rItemJournalLine.Reset();
            rItemJournalLine.SetRange("Journal Template Name", pJournalTemplateName);
            rItemJournalLine.SetRange("Journal Batch Name", pJournalBatchName);
            if rItemJournalLine.FindSet(true) then
                repeat
                    rItemJournalLine.Validate("Qty. (Phys. Inventory)", 0);
                    rItemJournalLine.Modify();
                until rItemJournalLine.Next() = 0;
            Dialogo.OPEN('Producto: #1############');
            rTempLineas.Reset();
            rTempLineas.SetFilter("Gen. Bus. Posting Group", pFiltroAlmacen);
            if rTempLineas.Findset() then
                repeat
                    Dialogo.UPDATE(1, rTempLineas."G/L Account");
                    rItemJournalLine.SetRange("Item No.", rTempLineas."G/L Account");
                    rItemJournalLine.SetRange("Location Code", rTempLineas."Gen. Bus. Posting Group");
                    if rItemJournalLine.FINDFIRST then begin
                        rItemJournalLine.Validate("Qty. (Phys. Inventory)", rTempLineas.Quantity);
                        rItemJournalLine.Modify();
                    end
                    else begin
                        rTempLineasAcrear := rTempLineas;
                        rTempLineasAcrear.Insert();
                    end;
                until rTempLineas.Next() = 0;
            NumLinea := 0;
            rTempLineasAcrear.Reset();
            if rTempLineasAcrear.Findset() then begin
                rItemJournalLine.SetRange("Item No.");
                rItemJournalLine.SetRange("Location Code");
                if rItemJournalLine.FINDLAST then begin
                    NumLinea := rItemJournalLine."Line No.";
                    NumDoc := rItemJournalLine."Document No.";
                end
                else begin
                    NumLinea := 0;
                    NumDoc := 'INV';
                end;
                rItemJournalLine.Reset();
                repeat
                    NumLinea += 10000;
                    rItemJournalLine.INIT;
                    rItemJournalLine."Journal Template Name" := pJournalTemplateName;
                    rItemJournalLine."Journal Batch Name" := pJournalBatchName;
                    rItemJournalLine."Line No." := NumLinea;
                    rItemJournalLine."Document No." := NumDoc;
                    rItemJournalLine.Validate("Entry Type", rItemJournalLine."Entry Type"::"Positive Adjmt.");
                    rItemJournalLine.Validate("Posting Date", TODAY);
                    rItemJournalLine.Validate("Item No.", rTempLineasAcrear."G/L Account");
                    rItemJournalLine.Validate("Location Code", rTempLineasAcrear."Gen. Bus. Posting Group");
                    rItemJournalLine.Validate("Phys. Inventory", true);
                    rItemJournalLine.Validate("Qty. (Phys. Inventory)", rTempLineasAcrear.Quantity);
                    rItemJournalLine.Insert();
                until rTempLineasAcrear.Next() = 0;
            end;
        end;
        rItemJournalLine.Reset();
        rItemJournalLine.SetRange("Journal Template Name", pJournalTemplateName);
        rItemJournalLine.SetRange("Journal Batch Name", pJournalBatchName);
        if rItemJournalLine.FindSet(true) then
            repeat
                if rItemJournalLine."Qty. (Calculated)" = rItemJournalLine."Qty. (Phys. Inventory)" then rItemJournalLine.DELETE;
            until rItemJournalLine.Next() = 0;
        Dialogo.Close();
    end;
    */
    //<<

    // Confirmación Albarán de Envio
    procedure DocEnvConfirmAlb(pAlmacen: Code[10]; pAlbaran: Code[20]; pEnvio: Code[20]);
    var
        rLocation: Record Location;
    begin
        if not cuSGAManagement.IsSGAEnabled() then exit;
        cuSGAManagement.InitializeSGAConfiguration(rSGASetup);

        rLocation.Get(pAlmacen);
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'IdAlmacenERP eq ''' + pAlmacen + '''' + ' and NumeroEntregaAlmacen eq ''' + pEnvio + '''' +
                        ' and NumeroAlbaran eq ''' + pAlbaran + '''' + ' and IdEmpresaERP eq ''' + CompanyName + '''');
        //HttpCall(SGACallType::"Leer confirmacion albaran", SGAJsonObject);
        cuSGAManagement.HttpCall(SGACallProcedure::"Read Delivery Note Confirmation", SGAJsonObject, ResponseTxt);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        if ArrayJSONManagement.GetCollectionCount() = 0 then begin
            Clear(SGAJsonObject);
            SGAJsonObject.Add('CodigoAlmacenWMS', rLocation."SGA Warehouse Code");
            SGAJsonObject.Add('IdAlmacenERP', pAlmacen);
            SGAJsonObject.Add('IdEmpresaERP', COMPANYNAME);
            SGAJsonObject.Add('NumeroEntregaAlmacen', pEnvio);
            SGAJsonObject.Add('NumeroAlbaran', pAlbaran);
            SGAJsonObject.Add('FechaAltaEnlace', cuSGAManagement.GetFechaHoraTrabajo());
            //HttpCall(SGACallType::"Insertar confirmacion albaran", SGAJsonObject);
            cuSGAManagement.HttpCall(SGACallProcedure::"Insert Delivery Note Confirmation", SGAJsonObject, ResponseTxt);
        end;
    end;
    //<<


    //>> Informar la Devolucion Compra. NO SE USA.
    procedure DevCompraDocEnvio(pNumEnvio: Code[20]; pBorrar: Boolean);
    var
        rTempLinEnvio: Record "Warehouse Shipment Line" temporary;
        rWarehouseShipmentHeader: Record "Warehouse Shipment Header";
        rWarehouseShipmentLine: Record "Warehouse Shipment Line";
        rPurchaseHeader: Record "Purchase Header";
        rPurchaseLine: Record "Purchase Line";
        rCountry: Record "Country/Region";
        rShipmentAgent: Record "Shipping Agent";
        rLocation: Record Location;
        rWarehouseCommentLine: Record "Warehouse Comment Line";
        FechaTrabajoDT: DateTime;
        FechaServicio: DateTime;
        FechaServicioTxt: Text[50];
        Comentarios: Text;
        Name: Text[100];
        Address: Text[100];
        Address2: Text[100];
        City: Text[50];
        County: Text[50];
        Error01: Label 'The shipment has been submitted.', Comment = 'ESP="El envio esta lanzado"';
        Error02: Label 'The shipment must be submitted.', Comment = 'ESP="El envio debe de estar lanzado"';
    begin
        if not cuSGAManagement.IsSGAEnabled() then exit;
        cuSGAManagement.InitializeSGAConfiguration(rSGASetup);

        rWarehouseShipmentHeader.Get(pNumEnvio);
        rLocation.Get(rWarehouseShipmentHeader."Location Code");
        CLEAR(SQLEstructura);
        if pBorrar then begin
            if rWarehouseShipmentHeader.Status <> rWarehouseShipmentHeader.Status::Open then
                Error(Error01)
            else
                if rWarehouseShipmentHeader.Status <> rWarehouseShipmentHeader.Status::Released then
                    Error(Error02);
        end;
        rTempLinEnvio.Reset();
        rWarehouseShipmentLine.SetRange("Source Type", 39);
        rWarehouseShipmentLine.SetRange("Source Subtype", 5);
        rWarehouseShipmentLine.SetRange("No.", pNumEnvio);
        if rWarehouseShipmentLine.Findset() then
            repeat
                rTempLinEnvio.Reset();
                rTempLinEnvio.SetRange("Item No.", rWarehouseShipmentLine."Item No.");
                if NOT rTempLinEnvio.FINDFIRST then begin
                    rTempLinEnvio.Reset();
                    rTempLinEnvio := rWarehouseShipmentLine;
                    rTempLinEnvio.Insert();
                end
                else begin
                    rTempLinEnvio."Qty. to Ship (Base)" += rWarehouseShipmentLine."Qty. to Ship (Base)";
                    rTempLinEnvio.Modify();
                end;
            until rWarehouseShipmentLine.Next() = 0;
        if rTempLinEnvio.Findset() then begin
            repeat
                rPurchaseHeader.Get(rTempLinEnvio."Source Subtype", rWarehouseShipmentLine."Source No.");
                if NOT rCountry.Get(rPurchaseHeader."Buy-from Country/Region Code") then CLEAR(rCountry);
                if rTempLinEnvio."Shipment Date" = 0D then
                    FechaServicioTxt := 'NULL'
                else begin
                    FechaServicio := CreateDateTime(rTempLinEnvio."Shipment Date", 0T);
                end;
                Name := rPurchaseHeader."Buy-from Vendor Name";
                Address := rPurchaseHeader."Buy-from Address";
                Address2 := rPurchaseHeader."Buy-from Address 2";
                City := rPurchaseHeader."Buy-from City";
                County := rPurchaseHeader."Buy-from County";
                cuSGAManagement.ReemplazarCaracter(Name, '''', '');
                cuSGAManagement.ReemplazarCaracter(Address, '''', '');
                cuSGAManagement.ReemplazarCaracter(Address2, '''', '');
                cuSGAManagement.ReemplazarCaracter(City, '''', '');
                cuSGAManagement.ReemplazarCaracter(County, '''', '');
                Clear(SGAJsonObject);
                SGAJsonObject.Add('CodigoAlmacenWMS', rLocation."SGA Warehouse Code");
                SGAJsonObject.Add('IdAlmacenERP', rWarehouseShipmentHeader."Location Code");
                SGAJsonObject.Add('CodigoAlmacenOrigenWMS', rLocation."SGA Warehouse Code");
                SGAJsonObject.Add('IdAlmacenOrigenERP', rWarehouseShipmentHeader."Location Code");
                SGAJsonObject.Add('IdEmpresaERP', COMPANYNAME);
                SGAJsonObject.Add('TipoDocumento', '270');
                SGAJsonObject.Add('NumeroDocumento', rWarehouseShipmentHeader."No.");
                SGAJsonObject.Add('CodigoOrdenante', rPurchaseHeader."Buy-from Vendor No.");
                SGAJsonObject.Add('NombreComercial', Name);
                SGAJsonObject.Add('Direccion', Address + ' ' + Address2);
                SGAJsonObject.Add('CP', rPurchaseHeader."Buy-from Post Code");
                SGAJsonObject.Add('Poblacion', City);
                SGAJsonObject.Add('Provincia', County);
                SGAJsonObject.Add('CodigoPaisISO', rPurchaseHeader."Buy-from Country/Region Code");
                SGAJsonObject.Add('Pais', rCountry.Name);
                SGAJsonObject.Add('FechaAlta', cuSGAManagement.GetFechaHoraTrabajo);
                if FechaServicioTxt = 'NULL' then
                    SGAJsonObject.Add('FechaServicioPrevista', FechaServicioTxt)
                else
                    SGAJsonObject.Add('FechaServicioPrevista', FechaServicio);
                SGAJsonObject.Add('NumeroLinea', FORMAT(rTempLinEnvio."Line No."));
                SGAJsonObject.Add('CodigoArticulo', rTempLinEnvio."Item No.");
                SGAJsonObject.Add('CantidadPedidaUMB', rTempLinEnvio."Qty. to Ship (Base)");
                SGAJsonObject.Add('FechaAltaEnlace', cuSGAManagement.GetFechaHoraTrabajo);
                //HttpCall(SGACallType::"Insertar devolucion compra", SGAJsonObject);
                cuSGAManagement.HttpCall(SGACallProcedure::"Insert Purchase Return", SGAJsonObject, ResponseTxt);
            until rTempLinEnvio.Next() = 0;
            if NOT pBorrar then begin
                rWarehouseShipmentHeader."SGA Status" := rWarehouseShipmentHeader."SGA Status"::"SGA Sent";
                rWarehouseShipmentHeader."SGA Inserted" := CreateDateTime(WorkDate, Time);
                rWarehouseShipmentHeader."SGA Modified" := false;
                rWarehouseShipmentHeader.Modify();
            end;
        end;
    end;
    //<<

    //>> Documento de Envío - Albarán Devolucion compra. NO SE USA.
    procedure AlbDevCompraDocEnvio();
    var
        rWarehouseShipmentHeader: Record "Warehouse Shipment Header";
        rTempLineas: Record "Inventory Buffer" temporary;
        rTempLotes: Record "Inventory Buffer" temporary;
        rWarehouseLineComment: Record "SGA Warehouse line Comment";
        rTempPurchCommentLine: Record "SGA Warehouse line Comment" temporary;
        rTempComentarioLinea2: Record "SGA Warehouse line Comment" temporary;
        rWarehouseShipmentLine: Record "Warehouse Shipment Line";
        rLinEnvioTemp: Record "Warehouse Shipment Line" temporary;
        rTempLineasID: Record "SGA Temporal SQL" temporary;
        rTempLinEnvio: Record "Warehouse Shipment Line" temporary;
        rTempEnvio: Record "Inventory Buffer" temporary;
        Almacen: Code[10];
        NoDoc: Code[20];
        NoEntAlm: Code[25];
        NumLineaTxt: Text[20];
        Numlinea: Integer;
        CodArticulo: Code[20];
        CantidadTxt: Text[20];
        NumeroLote: Text[25];
        FechaAltaTxt: Text[20];
        FechaAltaDateTime: DateTime;
        FechaAlta: Date;
        IDBigTxt: Text;
        IdBig: BigInteger;
        Ok: Boolean;
        Tipo: Code[10];
        NumLineaComentario: Integer;
        CantidadDec: Decimal;
        Cantidad: Integer;
        TextoError: Text;
        Error01: Label 'The shipment does not exist.', Comment = 'ESP="El envio no existe"';
        Error03: Label 'The quantity to send is greater than the quantity',
                Comment = 'ESP="La cantidad a enviar es mayor que la cantidad"';
        Cant: Decimal;
        Idioma: Text[2];
    begin
        // SGA Enabled
        if not cuSGAManagement.IsSGAEnabled() then exit;
        cuSGAManagement.InitializeSGAConfiguration(rSGASetup);

        Idioma := '5';
        rTempLineas.Reset();
        rTempLineas.DeleteAll();
        rTempLineasID.Reset();
        rTempLineasID.DeleteAll();
        rTempLotes.Reset();
        rTempLotes.DeleteAll();
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'TipoDocumento eq ''270'' and FechaProcesoEnlace eq null and' +
                        ' (Resultado eq null OR Resultado eq '''') AND IdEmpresaERP eq ''' + CompanyName + '''');
        //HttpCall(SGACallType::"Leer devolucion compra", SGAJsonObject);
        cuSGAManagement.HttpCall(SGACallProcedure::"Read Purchase Return", SGAJsonObject, ResponseTxt);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for Index := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, Index);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('IdAlmacenERP', ValueText);
            Almacen := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('TipoDocumento', ValueText);
            Tipo := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroDocumento', ValueText);
            NoDoc := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroEntregaAlmacen', ValueText);
            NoEntAlm := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroLinea', ValueText);
            NumLineaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CodigoArticulo', ValueText);
            CodArticulo := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CantidadPedidaUMB', ValueText);
            CantidadTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroLote', ValueText);
            NumeroLote := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('FechaAltaEnlace', ValueText);
            FechaAltaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('ROWID', ValueText);
            IDBigTxt := ValueText;
            Evaluate(IdBig, IDBigTxt);
            Ok := Evaluate(FechaAltaDateTime, FechaAltaTxt);
            Evaluate(Numlinea, NumLineaTxt);

            //>> BBT 28/08/2025. La cantidad debe ser entera (sin decimales)
            if Idioma <> '0' then
                Evaluate(CantidadDec, CantidadTxt)
            else
                cuSGAManagement.ConverTextoADecimal(CantidadTxt, CantidadDec);

            Cantidad := cuSGAManagement.ConvertDecimalAEntero(CantidadDec);
            //<<   

            rTempLineasID.INIT;
            rTempLineasID.ID := IdBig;
            rTempLineasID.Tipo := Tipo;
            rTempLineasID."No. Documento" := NoDoc;
            rTempLineasID.Insert();
            rTempEnvio.INIT;
            rTempEnvio."Item No." := NoDoc;
            if NOT rTempEnvio.Find() then rTempEnvio.Insert();
            rTempLineas.INIT;
            rTempLineas."Item No." := NoDoc;
            rTempLineas."Variant Code" := Tipo;
            rTempLineas."Dimension Entry No." := Numlinea;
            rTempLineas."Bin Code" := CodArticulo;
            if NOT rTempLineas.Find() then rTempLineas.Insert();
            rTempLineas.Quantity += Cantidad;
            rTempLineas."SGA Delivery Number" := NoEntAlm;
            rTempLineas.Modify();
            if NumeroLote <> '' then begin
                rTempLotes.INIT;
                rTempLotes."Item No." := NoDoc;
                rTempLotes."Variant Code" := Tipo;
                rTempLotes."Bin Code" := CodArticulo;
                //rTempLotes."Dimension Entry No."  := _Numlinea;
                rTempLotes."Serial No." := NumeroLote;
                if NOT rTempLotes.Find() then rTempLotes.Insert();
                rTempLotes.Quantity := Cantidad;
                rTempLotes.Modify();
            end;
        end;
        // Actualizar Dev a recibir
        // Registrar
        rTempEnvio.Reset();
        rTempLineas.Reset();
        rTempLotes.Reset();
        if rTempEnvio.Findset() then
            repeat
                TextoError := '';
                rTempPurchCommentLine.Reset();
                rTempPurchCommentLine.DeleteAll();
                rTempComentarioLinea2.Reset();
                rTempComentarioLinea2.DeleteAll();
                if NOT rWarehouseShipmentHeader.Get(rTempEnvio."Item No.") then TextoError := Error01;
                if TextoError = '' then begin
                    rLinEnvioTemp.Reset();
                    rLinEnvioTemp.DeleteAll();
                    rTempLinEnvio.Reset();
                    rTempLinEnvio.DeleteAll();
                    rWarehouseShipmentLine.SetRange("No.", rWarehouseShipmentHeader."No.");
                    if rWarehouseShipmentLine.Findset() then
                        repeat
                            rTempLinEnvio.INIT;
                            rTempLinEnvio := rWarehouseShipmentLine;
                            rTempLinEnvio.Insert();
                        until rWarehouseShipmentLine.Next() = 0;
                    if rWarehouseShipmentLine.FindSet(true) then
                        repeat
                            rLinEnvioTemp := rWarehouseShipmentLine;
                            rLinEnvioTemp.Insert();
                            if ValidarCantEnviarBase(rLinEnvioTemp, 0) then begin
                                rLinEnvioTemp.Modify();
                                rWarehouseLineComment.SetRange("Document Type", rWarehouseLineComment."Document Type"::Ship);
                                rWarehouseLineComment.SetRange("No.", rWarehouseShipmentLine."No.");
                                rWarehouseLineComment.SetRange("Document Line No.", rWarehouseShipmentLine."Line No.");
                                if rWarehouseLineComment.Findset() then
                                    repeat
                                        rTempPurchCommentLine := rWarehouseLineComment;
                                        rTempPurchCommentLine.Insert();
                                    until rWarehouseLineComment.Next() = 0;
                            end
                            else
                                TextoError := CopyStr(GetLastErrorText, 1, 250);
                        until (rWarehouseShipmentLine.Next() = 0) OR (TextoError <> '');
                    if TextoError = '' then begin
                        rTempLineas.SetRange("Variant Code", '270');
                        rTempLineas.SetRange("Item No.", rWarehouseShipmentHeader."No.");
                        if rTempLineas.Findset() then
                            repeat // Cambiar para agrupacion
                                rLinEnvioTemp.SetRange("No.", rTempLineas."Item No.");
                                rLinEnvioTemp.SetRange("Item No.", rTempLineas."Bin Code");
                                rLinEnvioTemp.SetFilter("Qty. Outstanding (Base)", '<>0');
                                if rLinEnvioTemp.FindSet(true) then
                                    repeat
                                        if rLinEnvioTemp."Qty. Outstanding (Base)" >= rTempLineas.Quantity then begin
                                            Cant := rTempLineas.Quantity;
                                            if ValidarCantEnviarBase(rLinEnvioTemp, rLinEnvioTemp."Qty. to Ship (Base)" + rTempLineas.Quantity) then begin
                                                rTempLineas.Quantity := 0;
                                                rTempLineas.Modify();
                                                rLinEnvioTemp.Validate("SGA Quantity (Base)", rLinEnvioTemp."SGA Quantity (Base)" + rLinEnvioTemp."Qty. to Ship (Base)");
                                                rLinEnvioTemp."SGA Warehouse Delivery Number" := rTempLineas."SGA Delivery Number";
                                                rLinEnvioTemp.Modify();
                                                ComentariosLoteEnvios(rTempLotes, rTempPurchCommentLine, Cant, rLinEnvioTemp);
                                                // Meter comentarios con lotes hasta _cant = 0
                                            end
                                            else
                                                TextoError := CopyStr(GetLastErrorText, 1, 250);
                                        end
                                        else if ValidarCantEnviarBase(rLinEnvioTemp, rLinEnvioTemp."Qty. Outstanding (Base)") then begin
                                            Cant := rLinEnvioTemp."Qty. Outstanding (Base)";
                                            rTempLineas.Quantity -= rLinEnvioTemp."Qty. Outstanding (Base)";
                                            rLinEnvioTemp.Validate("SGA Quantity (Base)", rLinEnvioTemp."SGA Quantity (Base)" + rLinEnvioTemp."Qty. to Ship (Base)");
                                            rTempLineas.Modify();
                                            rLinEnvioTemp."SGA Warehouse Delivery Number" := rTempLineas."SGA Delivery Number";
                                            rLinEnvioTemp.Modify();
                                            ComentariosLoteEnvios(rTempLotes, rTempPurchCommentLine, Cant, rLinEnvioTemp);
                                            // Meter comentarios con lotes hasta _cant = 0
                                        end
                                        else
                                            TextoError := CopyStr(GetLastErrorText, 1, 250);
                                    until (rLinEnvioTemp.Next() = 0) OR (rTempLineas.Quantity = 0);
                                if rTempLineas.Quantity > 0 then TextoError := Error03;
                            until (TextoError <> '') OR (rTempLineas.Next() = 0);
                    end;
                    if TextoError = '' then begin
                        rLinEnvioTemp.Reset();
                        if rLinEnvioTemp.Findset() then
                            repeat
                                rWarehouseShipmentLine := rLinEnvioTemp;
                                rWarehouseShipmentLine.Modify();
                            until rLinEnvioTemp.Next() = 0;
                        rTempPurchCommentLine.Reset();
                        rTempComentarioLinea2.Reset();
                        rTempComentarioLinea2.DeleteAll();
                        if rTempPurchCommentLine.Findset() then
                            repeat
                                rWarehouseLineComment := rTempPurchCommentLine;
                                if rWarehouseLineComment.INSERT then begin
                                    rTempComentarioLinea2 := rWarehouseLineComment;
                                    rTempComentarioLinea2.Insert();
                                end;
                            until rTempPurchCommentLine.Next() = 0;
                        if NOT RegistrarEnvio(rWarehouseShipmentLine) then begin        //REGISTRAR DEVOLUCION
                            TextoError := CopyStr(GetLastErrorText, 1, 250);
                            rTempComentarioLinea2.Reset();
                            if rTempComentarioLinea2.Findset() then begin
                                rWarehouseLineComment := rTempComentarioLinea2;
                                if rWarehouseLineComment.Find() then rWarehouseLineComment.Delete();
                            end;
                        end
                        else begin
                            rWarehouseShipmentHeader."SGA Readed" := CurrentDateTime;
                            if rWarehouseShipmentHeader.Modify() then;
                        end;
                    end;
                end;
                if TextoError = '' then
                    TextoError := 'CORRECTO'
                else begin
                    rTempLinEnvio.Reset();
                    rWarehouseShipmentLine.Reset();
                    CLEAR(rWarehouseShipmentLine);
                    if rTempLinEnvio.Findset() then
                        repeat
                            rWarehouseShipmentLine.INIT;
                            if rWarehouseShipmentLine.Get(rTempLinEnvio."No.", rTempLinEnvio."Line No.") then begin
                                rWarehouseShipmentLine.TRANSFERFIELDS(rTempLinEnvio, false);
                                rWarehouseShipmentLine.Modify();
                            end;
                        until rTempLinEnvio.Next() = 0;
                end;
                cuSGAManagement.ReemplazarCaracter(TextoError, '''', '');
                rTempLineasID.Reset();
                rTempLineasID.SetRange(Tipo, '270');
                rTempLineasID.SetRange("No. Documento", rTempEnvio."Item No.");
                if rTempLineasID.Findset() then
                    repeat
                        Clear(SGAJsonObject);
                        SGAJsonObject.Add('FechaProcesoEnlace', cuSGAManagement.GetFechaHoraTrabajo());
                        SGAJsonObject.Add('Resultado', TextoError);
                        SGAJsonObject.Add('RowId', FORMAT(rTempLineasID.ID));
                        //HttpCall(SGACallType::"Actualizar documento", SGAJsonObject);
                        cuSGAManagement.HttpCall(SGACallProcedure::"Update Document", SGAJsonObject, ResponseTxt);
                    until rTempLineasID.Next() = 0;
                TextoError := '';
            until rTempEnvio.Next() = 0;
    end;
    //<<

    //>> Actualización Entregas Expedidas
    procedure EntregasExpedidas();
    var
        rSalesShipmentHeader: Record "Sales Shipment Header";
        rSGATemporalSQL: Record "SGA Temporal SQL" temporary;
        IdAlmacenERP: Code[25];
        NumeroEntregaAlmacen: Code[25];
        FechaExpedicionEntrega: DateTime;
        IDBig: BigInteger;
        IDBigTxt: Text;
        FechaExpedicionEntregaTxt: Text;
        TextoError: Text;
        Error01: Label 'Incorrect date', Comment = 'ESP="Fecha incorrecta"';
        Error02: Label 'Does not exist the delivery note with delivery number ',
                Comment = 'ESP="No existe el albarán con número de entrega "';
    begin
        // SGA Enabled
        if not cuSGAManagement.IsSGAEnabled() then exit;
        cuSGAManagement.InitializeSGAConfiguration(rSGASetup);

        rTempDoc.Reset();
        rTempDoc.DeleteAll();
        rSGATemporalSQL.Reset();
        rSGATemporalSQL.DeleteAll();
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'FechaProcesoEnlace eq null and (Resultado eq null OR Resultado eq '''')');
        //HttpCall(SGACallType::"Leer entregas expedidas", SGAJsonObject);
        cuSGAManagement.HttpCall(SGACallProcedure::"Read Dispatched Deliveries", SGAJsonObject, ResponseTxt);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for Index := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            rSalesShipmentHeader.Reset();
            TextoError := '';
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, Index);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('IdAlmacenERP', ValueText);
            IdAlmacenERP := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroEntregaAlmacen', ValueText);
            NumeroEntregaAlmacen := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('FechaExpedicionEntrega', ValueText);
            FechaExpedicionEntregaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('ROWID', ValueText);
            IDBigTxt := ValueText;
            Evaluate(IDBig, IDBigTxt);
            if NOT Evaluate(FechaExpedicionEntrega, FechaExpedicionEntregaTxt) then TextoError := Error01;
            if TextoError = '' then begin
                rSalesShipmentHeader.SetRange("SGA Warehouse Delivery No", NumeroEntregaAlmacen);
                if rSalesShipmentHeader.FindSet(true) then begin
                    rSalesShipmentHeader."SGA Expedition Date" := FechaExpedicionEntrega;
                    rSalesShipmentHeader.Modify();
                end
                else
                    TextoError := Error02 + NumeroEntregaAlmacen;
            end;
            if TextoError = '' then TextoError := 'CORRECTO';
            rSGATemporalSQL.INIT;
            rSGATemporalSQL.ID := IDBig;
            rSGATemporalSQL.Error := TextoError;
            if NOT rSGATemporalSQL.INSERT then rSGATemporalSQL.Modify();
        end;
        rSGATemporalSQL.Reset();
        if rSGATemporalSQL.Findset() then begin
            repeat
                Clear(SGAJsonObject);
                SGAJsonObject.Add('FechaProcesoEnlace', cuSGAManagement.GetFechaHoraTrabajo());
                SGAJsonObject.Add('Resultado', rSGATemporalSQL.Error);
                SGAJsonObject.Add('RowId', FORMAT(rSGATemporalSQL.ID));
                //HttpCall(SGACallType::"Actualizar entregas expedidas", SGAJsonObject);
                cuSGAManagement.HttpCall(SGACallProcedure::"Update Shipped Deliveries", SGAJsonObject, ResponseTxt);
            until rSGATemporalSQL.Next() = 0;
        end;
    end;
    //<<
    //**************************************************************Global functions**********************************************************************************//
    [TryFunction]
    local procedure AbrirPedidoCompra(var pPurchaseHeader: Record "Purchase Header");
    var
        rReleasePurchDoc: Codeunit "Release Purchase Document";
    begin
        rReleasePurchDoc.Reopen(pPurchaseHeader);
    end;

    [TryFunction]
    local procedure validarFechaRegistroCompra(var pPurchaseHeader: Record "Purchase Header"; pFecha: Date);
    begin
        pPurchaseHeader.SetHideValidationDialog(true);
        pPurchaseHeader.Validate("Posting Date", pFecha);
    end;

    [TryFunction]
    local procedure ValidarCantRecibBase(var pPurchaseLine: Record "Purchase Line"; pCantidad: Decimal);
    begin
        pPurchaseLine.Validate("Qty. to Receive (Base)", pCantidad);
    end;

    local procedure RegistrarCompra(var pPurchaseHeader: Record "Purchase Header"): Boolean;
    var
        cuPurchPost: Codeunit "Purch.-Post";
    begin
        CLEAR(cuPurchPost);
        pPurchaseHeader.Receive := true;
        pPurchaseHeader.Ship := false;
        pPurchaseHeader.Invoice := false;
        COMMIT;
        if cuPurchPost.RUN(pPurchaseHeader) then
            exit(true)
        else
            exit(false);
    end;

    [TryFunction]
    local procedure ValidarCantEnviarBase(var pWarehouseShipmentLine: Record "Warehouse Shipment Line"; pCantidad: Decimal);
    begin
        pWarehouseShipmentLine.Validate("Qty. to Ship (Base)", pCantidad);
    end;

    local procedure ComentariosLoteEnvios(var pTempLotes: Record "Inventory Buffer" temporary; var pTempPurchCommentLine: Record "SGA Warehouse line Comment" temporary; pCant: Decimal; pLinEnvioTemp: Record "Warehouse Shipment Line" temporary);
    var
        _NumeroLinea: Integer;
    begin
        pTempPurchCommentLine.Reset();
        pTempPurchCommentLine.SetRange("Document Type", pTempPurchCommentLine."Document Type"::Ship);
        pTempPurchCommentLine.SetRange(pTempPurchCommentLine."No.", pLinEnvioTemp."No.");
        pTempPurchCommentLine.SetRange("Document Line No.", pLinEnvioTemp."Line No.");
        if pTempPurchCommentLine.FINDLAST then
            _NumeroLinea := pTempPurchCommentLine."Line No."
        else
            _NumeroLinea := 0;
        pTempLotes.SetRange("Item No.", pLinEnvioTemp."No.");
        pTempLotes.SetRange("Variant Code", '200');
        pTempLotes.SetRange("Bin Code", pLinEnvioTemp."Item No.");
        pTempLotes.SetFilter(Quantity, '<>%1', 0);
        if pTempLotes.FindSet(true) then
            repeat
                _NumeroLinea += 10000;
                pTempPurchCommentLine.INIT;
                pTempPurchCommentLine."Document Type" := pTempPurchCommentLine."Document Type"::Ship;
                pTempPurchCommentLine."No." := pLinEnvioTemp."No.";
                pTempPurchCommentLine."Document Line No." := pLinEnvioTemp."Line No.";
                pTempPurchCommentLine."Line No." := _NumeroLinea;
                if pTempLotes.Quantity > pCant then begin
                    pTempPurchCommentLine.Comment := STRSUBSTNO(LineaLote, pTempLotes."Serial No.", FORMAT(pCant));
                    pCant := 0;
                    pTempLotes.Quantity := pTempLotes.Quantity - pCant;
                end
                else begin
                    pTempPurchCommentLine.Comment := STRSUBSTNO(LineaLote, pTempLotes."Serial No.", FORMAT(pTempLotes.Quantity));
                    pCant := pCant - pTempLotes.Quantity;
                    pTempLotes.Quantity := 0;
                end;
                pTempPurchCommentLine.Insert();
                pTempLotes.Modify();
            until (pTempLotes.Next() = 0) OR (pCant = 0);
    end;

    local procedure RegistrarEnvio(pWarehouseShipmentLine: Record "Warehouse Shipment Line"): Boolean;
    var
        cuWhsePostShipment: Codeunit "Whse.-Post Shipment";
        rWarehouseShipmentHeader: Record "Warehouse Shipment Header";
    begin
        //>> BBT 06/07/2026. La Fecha de registro es la workdate del sistema.
        rWarehouseShipmentHeader.Reset();
        rWarehouseShipmentHeader.SetRange("No.", pWarehouseShipmentLine."No.");
        if rWarehouseShipmentHeader.FindFirst() then begin
            rWarehouseShipmentHeader."Posting Date" := WorkDate();
            rWarehouseShipmentHeader.Modify();
        end;
        //<<

        Commit();

        CLEAR(cuWhsePostShipment);
        cuWhsePostShipment.SetPostingSettings(false);
        cuWhsePostShipment.SetPrint(true);
        if cuWhsePostShipment.RUN(pWarehouseShipmentLine) then
            exit(true)
        else
            exit(false);
    end;

    [TryFunction]
    local procedure ValidarCantDevVentaBase(var pSalesLine: Record "Sales Line"; pCantidad: Decimal);
    begin
        pSalesLine.Validate("Qty. to Ship (Base)", pCantidad);
    end;

    local procedure RegistrarDevVenta(var pSalesHeader: Record "Sales Header"): Boolean;
    var
        cuSalesPost: Codeunit "Sales-Post";
    begin
        COMMIT;
        CLEAR(cuSalesPost);
        pSalesHeader.Ship := false;
        pSalesHeader.Invoice := false;
        pSalesHeader.Receive := true;
        if cuSalesPost.RUN(pSalesHeader) then
            exit(true)
        else
            exit(false);
    end;

    [TryFunction]
    local procedure ValidarCantEnviarTrans(var pLinTransferencia: Record "Transfer Line"; pCant: Decimal);
    begin
        pLinTransferencia.Validate(pLinTransferencia."Qty. to Ship (Base)", pCant);
    end;

    [TryFunction]
    local procedure ValidarCantRecepTrans(var pLinTransferencia: Record "Transfer Line"; pCant: Decimal);
    begin
        pLinTransferencia.Validate("Qty. to Receive (Base)", pCant);
    end;

    local procedure RegistrarEnvioTrans(var pTransferHeader: Record "Transfer Header"): Boolean;
    var
        cuRegEnvioTranfer: Codeunit "TransferOrder-Post Shipment";
    begin
        //>> BBT 06/07/2026. La Fecha de registro es la workdate del sistema.
        pTransferHeader."Posting Date" := WorkDate();
        pTransferHeader.Modify();
        //<<
        COMMIT;
        CLEAR(cuRegEnvioTranfer);
        cuRegEnvioTranfer.SetHideValidationDialog(true);
        if cuRegEnvioTranfer.RUN(pTransferHeader) then
            exit(true)
        else
            exit(false);
    end;

    local procedure RegistrarRecepTrans(var pTransferHeader: Record "Transfer Header"): Boolean;
    var
        cuRecRecepTransfer: Codeunit "TransferOrder-Post Receipt";
    begin
        //>> BBT 06/07/2026. La Fecha de registro es la workdate del sistema.
        pTransferHeader."Posting Date" := WorkDate();
        pTransferHeader.Modify();
        //<<
        COMMIT;
        CLEAR(cuRecRecepTransfer);
        cuRecRecepTransfer.SetHideValidationDialog(true);
        if cuRecRecepTransfer.RUN(pTransferHeader) then
            exit(true)
        else
            exit(false);
    end;

    procedure EnvioSGA(var pTransferHeader: Record "Transfer Header"; var pTipo: Integer; var pTempLineasOLD: Record "Transfer Line" temporary; pBorrar: Boolean);
    var
        MSG01: Label 'Execution completed', Comment = 'ESP="Envio Completado"';
    begin
        pTransferHeader.Modify();
        "PedidoTransferencia-->SGA"(pTransferHeader."No.", pTipo, pTempLineasOLD, pBorrar);
        Message(MSG01);
    end;

    [TryFunction]
    local procedure ProductoLineaDiario(var pLinDiarioProducto: Record "Item Journal Line"; pItem: Code[20]);
    begin
        pLinDiarioProducto.Validate("Item No.", pItem);
    end;

    [TryFunction]
    local procedure CantidadLineaDiario(var pLinDiarioProducto: Record "Item Journal Line"; pQuantity: Decimal);
    begin
        if pQuantity < 0 then
            pLinDiarioProducto."Entry Type" := pLinDiarioProducto."Entry Type"::"Negative Adjmt."
        else
            pLinDiarioProducto."Entry Type" := pLinDiarioProducto."Entry Type"::"Positive Adjmt.";

        pLinDiarioProducto.Validate(Quantity, ABS(pQuantity));
    end;

    local procedure RegistrarLineaDiario(pLinDiarioProducto: Record "Item Journal Line"): Boolean;
    var
        cuItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        rItemJnlLine: Record "Item Journal Line";
        rItemLedgerEntry: Record "Item Ledger Entry";
    begin
        COMMIT;
        Clear(rItemLedgerEntry);
        //>> revisión error duplicados
        //Comprobamos si ya existe el numero de documento, si existe no hacemos nada y saltamos // 05/12/2023 AJUSTESTOCK
        // Es el Numero de Documento Externo
        rItemLedgerEntry.SetRange("External Document No.", pLinDiarioProducto."External Document No.");
        rItemLedgerEntry.SetRange("Transaction Type", '00');
        //<<
        if NOT rItemLedgerEntry.FindFirst() then begin
            CLEAR(cuItemJnlPostLine);
            if cuItemJnlPostLine.RUN(pLinDiarioProducto) then
                exit(true)
            else
                exit(false);
        end
        else begin
            pLinDiarioProducto.Delete();
            exit(true);
        end;
    end;

    procedure BorradoEnvios(_NumEnvio: Code[20]);
    var
        rWarehouseShipmentHeader: Record "Warehouse Shipment Header";
        rWarehouseShipmentLine: Record "Warehouse Shipment Line";
        rTempPedidos: Record "Inventory Buffer" temporary;
        Error01: Label 'Lines sent to the SGA pending processing', Comment = 'ESP="Líneas enviadas al SGA pendientes de proceso"';
        Error02: Label 'The shipment has been scheduled', Comment = 'ESP="El envio esta lanzado"';
    begin
        rWarehouseShipmentHeader.Get(_NumEnvio);
        rWarehouseShipmentLine.Reset();
        rWarehouseShipmentLine.SetRange("No.", _NumEnvio);
        rWarehouseShipmentLine.SetFilter("Qty. to Ship", '<>%1', 0);
        if NOT rWarehouseShipmentLine.ISEMPTY then
            Error(Error01)
        else begin
            rWarehouseShipmentLine.Reset();
            if rWarehouseShipmentHeader.Status = rWarehouseShipmentHeader.Status::Open then begin
                rWarehouseShipmentLine.SetRange("No.", _NumEnvio);
                if rWarehouseShipmentLine.FINDFIRST then begin
                    if (rWarehouseShipmentLine."Source Type" = 39) AND (rWarehouseShipmentLine."Source Subtype" = 5) then
                        DevCompraDocEnvio(_NumEnvio, true)          // NO se usa la devolución del pedido de compra.
                    else if (rWarehouseShipmentLine."Source Type" = 37) AND (rWarehouseShipmentLine."Source Subtype" = 1) then
                        PedVentaDocEnvio(_NumEnvio, true);
                end;
            end
            else
                Error(Error02);
        end;
    end;

    procedure BorradoPedTrans(_NumPedTrans: Code[20]);
    var
        rTransferLine: Record "Transfer Line";
        rTransferHeader: Record "Transfer Header";
        rLocation: Record Location;
        Tipo: Integer;
        rTempTransferLne: Record "Transfer Line" temporary;
        Error01: Label 'Lines sent to the SGA pending processing', Comment = 'ESP="Líneas enviadas al SGA pendientes de proceso"';
    begin
        rTransferHeader.Get(_NumPedTrans);
        rTransferLine.Reset();
        rTransferLine.SetRange("Document No.", _NumPedTrans);
        rTransferLine.SetFilter("Qty. to Ship", '<>%1', 0);
        if NOT rTransferLine.ISEMPTY then
            Error(Error01)
        else begin
            rTransferLine.Reset();
            rTransferLine.SetRange("Document No.", _NumPedTrans);
            rTransferLine.SetRange("Derived From Line No.", 0);
            if rTransferLine.FIND('-') then
                repeat
                    rTempTransferLne := rTransferLine;
                    rTempTransferLne.Insert();
                until rTransferLine.Next() = 0;
            if rLocation.Get(rTransferHeader."Transfer-from Code") AND rLocation."SGA Enabled" then
                Tipo := 0
            else
                Tipo := 1;
            EnvioSGA(rTransferHeader, Tipo, rTempTransferLne, true);
        end;
    end;

    /*
    procedure GetPackagingLinesFromSalesShptHeader(SalesShipmentHeader: Record "Sales Shipment Header");
    var
        rPostedWhseShipmentHeader: Record "Posted Whse. Shipment Header";
        rPostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        Error01: Label 'No warehouse delivery lines were found for the registered shipment ',
                Comment = 'ESP="No se han encontrado líneas de entrega de almacén para el envío registrado "';
    begin
        clear(PackingError);
        SalesShipmentHeader.TestField("No.");
        rPostedWhseShipmentLine.Reset();
        rPostedWhseShipmentLine.SetRange("Posted Source Document", rPostedWhseShipmentLine."Posted Source Document"::"Posted Shipment");
        rPostedWhseShipmentLine.SetRange("Posted Source No.", SalesShipmentHeader."No.");
        if rPostedWhseShipmentLine.Findset() then begin
            rPostedWhseShipmentHeader.Reset();
            if rPostedWhseShipmentHeader.Get(rPostedWhseShipmentLine."No.") then
                //Commit();
                if rPostedWhseShipmentHeader."No." <> '' then GetPackagingLines(rPostedWhseShipmentHeader);
            //Commit();
        end
        else
            PackingError := Error01 + SalesShipmentHeader."No.";
    end;

    procedure GetPackagingLines(var pPostedWhseShipmentHeader: Record "Posted Whse. Shipment Header");
    var
        rlSalesShipmentHeader: Record "Sales Shipment Header";
        rlItemUnitofMeasure: Record "Item Unit of Measure";
        rlItem: Record Item;
        Packaging: Record Packaging;
        PackagingLine: Record "Packaging Line";
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        rItem: Record Item;
        PostedSourceNo: Code[20];
        PostedSourceType: Integer;
        SQLLanguage: Code[10];
        NoEntregaAlmacen: Text;
        IDBigTxt: Text;
        SSCC: Text;
        Weight: Decimal;
        Volume: Decimal;
        WeightTxt: Text;
        VolumeTxt: Text;
        ItemNo: Text;
        Qty: Decimal;
        Qtytxt: Text;
        LineNo: Integer;
        TipoActivo: Text;
        HojaRuta: Code[20];
        PackagingInsertedModified: Boolean;
        Error01: label 'No packaging was found for the warehouse delivery ',
                Comment = 'ESP="No se han encontrado embalajes para la entrega de almacén "';
        Error02: label 'No warehouse delivery was found for the registered shipment ',
                Comment = 'ESP="No se ha encontrado una entrega de almacén para el envío registrado "';
    begin
        // Embalajes - De la tabla [TWO_BBTRendS].[scm_custom].[BBT_W2E_PackingList]
        pPostedWhseShipmentHeader.TestField("Whse. Shipment No.");
        PostedWhseShipmentLine.Reset();
        PostedWhseShipmentLine.SetRange("No.", pPostedWhseShipmentHeader."No.");
        if PostedWhseShipmentLine.FindSet() then
            repeat
                if PostedSourceNo = '' then
                    PostedSourceNo := PostedWhseShipmentLine."Posted Source No."
                else if PostedSourceNo <> PostedWhseShipmentLine."Posted Source No." then
                    Error('Se han detectado diferentes documentos en el envío registrado ' + pPostedWhseShipmentHeader."No.");
                Packaging.Reset();
                Packaging.SetRange("Source Type", PostedWhseShipmentLine."Source Type");
                Packaging.SetRange("Source No.", PostedWhseShipmentLine."Source No.");
                //Packaging.SetRange("Posted Source Type",PostedSourceType);
                Packaging.SetRange("Posted Source No.", PostedWhseShipmentLine."Posted Source No.");
                if Packaging.FindSet() then
                    Packaging.DeleteAll(true);
            ////////exit;///////
            until PostedWhseShipmentLine.Next() = 0;

        NoEntregaAlmacen := '';
        SQLLanguage := '5';
        // Primero recuperamos el nº entrega almacén
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'NumeroDocumento eq ' + Comilla + pPostedWhseShipmentHeader."Whse. Shipment No." + Comilla);
        //HttpCall(SGACallType::"Leer entrega almacen", SGAJsonObject);
        cuSGAManagement.HttpCall(SGACallProcedure::"Read Warehouse Delivery", SGAJsonObject, ResponseTxt);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for Index := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, Index);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroEntregaAlmacen', ValueText);
            NoEntregaAlmacen := ValueText;
        end;
        Clear(PackingError);
        PackagingInsertedModified := false;
        if NoEntregaAlmacen <> '' then begin // Buscamos los SSCC
            Clear(SGAJsonObject);
            Clear(ResponseTxt);
            SGAJsonObject.Add('filter', 'NumeroEntregaAlmacen eq ' + Comilla + NoEntregaAlmacen + Comilla);
            //HttpCall(SGACallType::"Leer packing list", SGAJsonObject);
            cuSGAManagement.HttpCall(SGACallProcedure::"Read packing list", SGAJsonObject, ResponseTxt);
            //Read Json
            Clear(ArrayJSONManagement);
            Clear(ObjectJSONManagement);
            ArrayJSONManagement.InitializeCollection(ResponseTxt);
            for Index := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
                SSCC := '';
                Weight := 0;
                Volume := 0;
                ItemNo := '';
                Qty := 0;
                TipoActivo := '';
                HojaRuta := '';
                ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, Index);
                ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
                ObjectJSONManagement.GetStringPropertyValueByName('SSCC', ValueText);
                SSCC := ValueText;
                ObjectJSONManagement.GetStringPropertyValueByName('Peso', ValueText);
                WeightTxt := ValueText;
                ObjectJSONManagement.GetStringPropertyValueByName('Volumen', ValueText);
                VolumeTxt := ValueText;
                ObjectJSONManagement.GetStringPropertyValueByName('CodigoArticulo', ValueText);
                ItemNo := ValueText;
                ObjectJSONManagement.GetStringPropertyValueByName('CantidadAbsoluta', ValueText);
                Qtytxt := ValueText;
                ObjectJSONManagement.GetStringPropertyValueByName('TipoActivo', ValueText);
                TipoActivo := ValueText;
                ObjectJSONManagement.GetStringPropertyValueByName('HojaDeRuta', ValueText);
                HojaRuta := ValueText;
                Evaluate(Weight, WeightTxt);
                Evaluate(Volume, VolumeTxt);
                Evaluate(Qty, Qtytxt);
                if (SSCC <> '') AND (ItemNo <> '') AND (Qty <> 0) then begin
                    rItem.Reset();
                    rItem.Get(ItemNo);
                    PostedWhseShipmentLine.Reset();
                    PostedWhseShipmentLine.SetRange("No.", pPostedWhseShipmentHeader."No.");
                    PostedWhseShipmentLine.SetRange("Item No.", ItemNo);
                    if PostedWhseShipmentLine.Findset() then begin
                        CASE PostedWhseShipmentLine."Posted Source Document" of
                            PostedWhseShipmentLine."Posted Source Document"::"Posted Shipment":
                                PostedSourceType := DATABASE::"Sales Shipment Line";
                            PostedWhseShipmentLine."Posted Source Document"::"Posted Return Shipment":
                                PostedSourceType := DATABASE::"Return Shipment Header";
                            PostedWhseShipmentLine."Posted Source Document"::"Posted Transfer Shipment":
                                PostedSourceType := DATABASE::"Transfer Shipment Header";
                            else
                                Error('Opción no contemplada (' + PostedWhseShipmentLine.FieldCaption("Posted Source Document") + ' ' +
                                FORMAT(PostedWhseShipmentLine."Posted Source Document") +
                                '). Por favor póngase en contacto con el administrador del sistema');
                        end;
                        Packaging.Reset();
                        if NOT Packaging.Get(SSCC) then begin
                            Packaging.Init();
                            ;
                            Packaging."No." := SSCC;
                            Packaging."Creation Date" := Today;
                            Packaging."Created by" := UserId;
                            Packaging."Location Code" := pPostedWhseShipmentHeader."Location Code";
                            Packaging."Posted by" := '';
                            Packaging."Info Code" := Packaging."Info Code"::"50";
                            Packaging."Terms and Conditions Code" := Packaging."Terms and Conditions Code"::"1"; // Pagado por el proveedor
                            Packaging.Roadmap := HojaRuta;
                            CASE TipoActivo of
                                'CAJ':
                                    Packaging."Type Code" := Packaging."Type Code"::CT;
                                else
                                    Packaging."Type Code" := Packaging."Type Code"::"201";
                            end;
                            Packaging."Shipping Payment Responsible" := Packaging."Shipping Payment Responsible"::"3"; // Pagado por el proveedor
                            Packaging."Net Weight 1 (AAC)" := Weight;
                            Packaging."Net Weight Type" := Packaging."Net Weight Type"::" ";
                            Packaging."Net Weight UOM" := '';
                            Packaging."Gross Weight 1 (AAD)" := Weight; // PendIENTE DEFINIR - ES EL MISMO QUE EL PESO DEL PRODUCTO? DEBERÍAMOS COGER EL PESO COMPLETO DE LAS LÍNEAS?
                            Packaging."Gross Weight Type" := Packaging."Gross Weight Type"::" ";
                            Packaging."Gross Weight UOM" := '';
                            Packaging."Height Dimension 1 (HT)" := 0;
                            Packaging."Height Type" := Packaging."Height Type"::" ";
                            Packaging."Height UOM" := '';
                            Packaging."Width Dimension 1 (WD)" := 0;
                            Packaging."Width Type" := Packaging."Width Type"::" ";
                            Packaging."Width UOM" := '';
                            Packaging."Length Dimension 1 (LN)" := 0;
                            Packaging."Length Type" := Packaging."Length Type"::" ";
                            Packaging."Length UOM" := '';
                            Packaging."Handling Instructions Code" := Packaging."Handling Instructions Code"::" ";
                            Packaging."Number of Boxes" := 0; // PendIENTE DEFINIR
                            Packaging."Source Type" := PostedWhseShipmentLine."Source Type";
                            Packaging."Source No." := PostedWhseShipmentLine."Source No.";
                            Packaging."Posted Source Type" := PostedSourceType;
                            Packaging."Posted Source No." := PostedWhseShipmentLine."Posted Source No.";

                            if rlSalesShipmentHeader.Get(PostedWhseShipmentLine."Posted Source No.") then
                                if rlSalesShipmentHeader."Gen. Bus. Posting Group" = 'ECOMMERCE' then
                                    if rlItem.Get(PostedWhseShipmentLine."Item No.") then
                                        if rlItemUnitofMeasure.Get(rlItem."No.", rlItem."Base Unit of Measure") then begin
                                            Packaging."Height Dimension 1 (HT)" := rlItemUnitofMeasure.Height;
                                            Packaging."Width Dimension 1 (WD)" := rlItemUnitofMeasure.Width;
                                            Packaging."Length Dimension 1 (LN)" := rlItemUnitofMeasure.Length;
                                        end;

                            Packaging.Insert(true);
                        end;
                        Packaging.TestField("No.");
                        Packaging."Number of Boxes" += Qty;
                        //Packaging."Gross Weight 1 (AAD)" += Weight;
                        Packaging.Modify();

                        PackagingInsertedModified := true;
                        PackagingLine.Reset();
                        PackagingLine.SetRange("No.", Packaging."No.");
                        PackagingLine.SetRange("Item No.", ItemNo);
                        if NOT PackagingLine.Findset() then begin
                            PackagingLine.Reset();
                            PackagingLine.SetRange("No.", Packaging."No.");
                            if PackagingLine.FindLast() then;
                            LineNo := PackagingLine."Line No." + 10000;
                            PackagingLine.INIT;
                            PackagingLine."No." := Packaging."No.";
                            PackagingLine."Line No." := LineNo;
                            PackagingLine."Source Type" := PostedWhseShipmentLine."Source Type";
                            PackagingLine."Source No." := PostedWhseShipmentLine."Source No.";
                            PackagingLine."Source Line No." := PostedWhseShipmentLine."Source Line No.";
                            PackagingLine."Posted Source Type" := PostedSourceType;
                            PackagingLine."Posted Source No." := PostedWhseShipmentLine."Posted Source No.";
                            PackagingLine."Item No." := PostedWhseShipmentLine."Item No.";
                            PackagingLine."Unit of Measure Code" := rItem."Base Unit of Measure";

                            PackagingLine.Insert(true);
                        end;
                        PackagingLine.Quantity += Qty;
                        PackagingLine."Qty. (Base)" += Qty;
                        PackagingLine.Modify();
                        Commit();
                    end;
                end;
            end;
            if not PackagingInsertedModified then PackingError := Error01 + NoEntregaAlmacen;
        end else
            PackingError := Error02 + pPostedWhseShipmentHeader."No.";
    end;
    */
    procedure LimpiarCamposError();
    var
        IDBigTxt: Text;
        Test: BigInteger;
    begin
        //Documentos
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'Resultado ne null and Resultado ne ''CORRECTO'' and Resultado ne ''''');
        //HttpCall(SGACallType::"Leer campos error", SGAJsonObject);
        cuSGAManagement.HttpCall(SGACallProcedure::"Read Error Fields", SGAJsonObject, ResponseTxt);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for Index := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, Index);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('ROWID', ValueText);
            IDBigTxt := ValueText;
            Clear(SGAJsonObject);
            SGAJsonObject.Add('FechaProcesoEnlace', '');
            SGAJsonObject.Add('Resultado', '');
            SGAJsonObject.Add('RowId', IDBigTxt);
            //HttpCall(SGACallType::"Actualizar documento", SGAJsonObject);
            cuSGAManagement.HttpCall(SGACallProcedure::"Update Document", SGAJsonObject, ResponseTxt);
        end;
        //Stock
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'Resultado ne ''CORRECTO'' and Resultado ne ''''');
        //HttpCall(SGACallType::"Leer campos error stock", SGAJsonObject);
        cuSGAManagement.HttpCall(SGACallProcedure::"Read Stock Error Fields", SGAJsonObject, ResponseTxt);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for Index := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            Test := ArrayJSONManagement.GetCollectionCount();
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, Index);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('ROWID', ValueText);
            IDBigTxt := ValueText;
            Clear(SGAJsonObject);
            SGAJsonObject.Add('FechaProcesoEnlace', '');
            SGAJsonObject.Add('Resultado', '');
            SGAJsonObject.Add('RowId', IDBigTxt);
            //HttpCall(SGACallType::"Actualizar ajustes stock", SGAJsonObject);
            cuSGAManagement.HttpCall(SGACallProcedure::"Update Stock Adjustments", SGAJsonObject, ResponseTxt);
        end;
    end;

    procedure LeerCamposError();
    var
        _NoSerie: Code[20];
        _NoSeriesCode: Code[20];
        /*
        _DocumentNo: Code[20];
        NoSerie: Record "No. Series";
        */
        NoSeriesLine: Record "No. Series Line";
        //>> Obsoleto V27
        //NoSeriesManagement: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        //<<
        EmptySerialCode: Code[20];
        ErrorSerialCode: Code[20];

        LogNAVSGAErrors: Record "SGA Log Errors";
        x: Integer;
        y: Integer;
        _NoDoc: Text[20];
        _Resultado: Text[2000];
        _FechaAltaTxt: Text[20];
        _FechaProcesoTxt: Text[20];
    begin
        // Marcamos todas las lineas como corregidas
        LogNAVSGAErrors.ModifyAll("SGA Corrected", true);
        //Documentos
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'Resultado ne null and Resultado ne ''CORRECTO'' and Resultado ne '''' and IdEmpresaERP eq ''' + CompanyName + '''');
        //SGAJsonObject.Add('filter', (Resultado eq null or Resultado eq '''')'); 
        //HttpCall(SGACallType::"Leer campos error", SGAJsonObject);
        cuSGAManagement.HttpCall(SGACallProcedure::"Read Error Fields", SGAJsonObject, ResponseTxt);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for Index := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, Index);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroDocumento', ValueText);
            _NoDoc := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('Resultado', ValueText);
            _Resultado := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('FechaAltaEnlace', ValueText);
            _FechaAltaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('FechaProcesoEnlace', ValueText);
            _FechaProcesoTxt := ValueText;
            CLEAR(LogNAVSGAErrors);
            LogNAVSGAErrors.SetRange("SGA Document No.", _NoDoc);
            if LogNAVSGAErrors.FindFirst() then begin
                LogNAVSGAErrors."SGA Description Error" := _Resultado;
                Evaluate(LogNAVSGAErrors."SGA Posting Date", _FechaAltaTxt);
                Evaluate(LogNAVSGAErrors."SGA Last Date", _FechaProcesoTxt);
                LogNAVSGAErrors."SGA Corrected" := false;
                LogNAVSGAErrors.Modify();
            end
            else begin
                LogNAVSGAErrors.INIT;
                NoSeriesLine.SetRange("Series Code", 'SGAERROR');
                if NoSeriesLine.FINDFIRST then begin
                    _NoSeriesCode := NoSeriesLine."Series Code";
                    if NoSeries.AreRelated(NoSeriesLine."Series Code", EmptySerialCode) then
                        _NoSeriesCode := EmptySerialCode;
                    _NoSerie := NoSeries.GetNextNo(_NoSeriesCode, Today);
                end;
                LogNAVSGAErrors."SGA Serial No" := _NoSeriesCode;
                LogNAVSGAErrors."SGA Error No" := _NoSerie;
                LogNAVSGAErrors."SGA Document No." := _NoDoc;
                LogNAVSGAErrors."SGA Description Error" := _Resultado;
                Evaluate(LogNAVSGAErrors."SGA Posting Date", _FechaAltaTxt);
                Evaluate(LogNAVSGAErrors."SGA Last Date", _FechaProcesoTxt);
                LogNAVSGAErrors."SGA Corrected" := false;
                LogNAVSGAErrors.Insert();
            end;
        end;
    end;

    /*
    procedure SGAGetPackingError(): text
    begin
        exit(PackingError);
    end;
    */

    local procedure GetLastJournalLine(JournalTemplateName: Code[10]; JournalBatchName: code[10]): Integer
    var
        ItemJournalLine: Record "Item Journal Line";
    begin
        clear(ItemJournalLine);
        ItemJournalLine.setrange("Journal Template Name", JournalTemplateName);
        ItemJournalLine.SetRange("Journal Batch Name", JournalBatchName);
        if ItemJournalLine.FindLast() then
            exit(ItemJournalLine."Line No." + 10000)
        else
            exit(10000);
    end;
}
