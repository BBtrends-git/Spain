codeunit 50000 "Interface SGA"
{
    //>> BBT SGA Extension
    ObsoleteState = Pending;
    //<<
    trigger OnRun();
    begin
    end;

    var
        sql_Estructura: Text[1024];
        TempDoc: Record "Vendor Payment Buffer" temporary;
        Comilla: Label '''';
        LineaLote: Label '''Lote: %1  / Ctd.: %2''';
        ResponseTxt: text;
        SGACallType: Enum "SGA Call Type";
        SGAJsonObject: JsonObject;
        ArrayJSONManagement: Codeunit "JSON Management";
        ObjectJSONManagement: Codeunit "JSON Management";
        i: Integer;
        ValueText: Text;
        BloqueoDocumentoJsonObject: Text;
        PackingError: Text;

    procedure GrabarTablaBloqueo();
    var
        _SGABlockedDocuments: Record "BBT-IT SGA Blocked Documents";

    begin
        // Reseteo de la tabla de bloqueos.
        _SGABlockedDocuments.Reset();
        _SGABlockedDocuments.DeleteAll();
        // Punto 1 Tabla Bloqueos
        TempDoc.Reset();
        TempDoc.DeleteAll();
        //_InfoCompany.GET;
        //_WarehouseSetup.GET;
        Clear(SGAJsonObject);
        SGAJsonObject.Add('filter', 'IdEmpresaERP eq ''' + CompanyName + ''''); //Cambiar BB Trends por COMPANYNAME
        HttpCall(SGACallType::"Bloqueo documentos", SGAJsonObject);
        //Read Json
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for i := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            TempDoc.init;
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, i);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroDocumento', ValueText);
            TempDoc."Vendor No." := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('TipoDocumento', ValueText);
            TempDoc."Currency Code" := ValueText;
            IF not TempDoc.FIND then TempDoc.Insert();
        end;
        if TempDoc.FindSet() then
            REPEAT
                CASE TempDoc."Currency Code" OF
                    '300':
                        begin
                            _SGABlockedDocuments.Reset();
                            _SGABlockedDocuments.SetRange("Document Type", _SGABlockedDocuments."Document Type"::Purchase);
                            _SGABlockedDocuments.SetRange("Document No.", TempDoc."Vendor No.");
                            if not _SGABlockedDocuments.FindFirst() then begin
                                _SGABlockedDocuments.Init();
                                _SGABlockedDocuments.Validate("Document Type", _SGABlockedDocuments."Document Type"::Purchase);
                                _SGABlockedDocuments.Validate("Document No.", TempDoc."Vendor No.");
                                _SGABlockedDocuments.Insert();
                            end;
                        end;
                    '200' .. '209':
                        begin
                            _SGABlockedDocuments.Reset();
                            _SGABlockedDocuments.SetRange("Document Type", _SGABlockedDocuments."Document Type"::Sales);
                            _SGABlockedDocuments.SetRange("Document No.", TempDoc."Vendor No.");
                            if not _SGABlockedDocuments.FindFirst() then begin
                                _SGABlockedDocuments.Init();
                                _SGABlockedDocuments.Validate("Document Type", _SGABlockedDocuments."Document Type"::Sales);
                                _SGABlockedDocuments.Validate("Document No.", TempDoc."Vendor No.");
                                _SGABlockedDocuments.Insert();
                            end;
                        end;
                    '370':
                        begin
                            _SGABlockedDocuments.Reset();
                            _SGABlockedDocuments.SetRange("Document Type", _SGABlockedDocuments."Document Type"::"Sales Return");
                            _SGABlockedDocuments.SetRange("Document No.", TempDoc."Vendor No.");
                            if not _SGABlockedDocuments.FindFirst() then begin
                                _SGABlockedDocuments.Init();
                                _SGABlockedDocuments.Validate("Document Type", _SGABlockedDocuments."Document Type"::"Sales Return");
                                _SGABlockedDocuments.Validate("Document No.", TempDoc."Vendor No.");
                                _SGABlockedDocuments.Insert();
                            end;
                        end;
                    '270':
                        begin
                            _SGABlockedDocuments.Reset();
                            _SGABlockedDocuments.SetRange("Document Type", _SGABlockedDocuments."Document Type"::"Purchase Return");
                            _SGABlockedDocuments.SetRange("Document No.", TempDoc."Vendor No.");
                            if not _SGABlockedDocuments.FindFirst() then begin
                                _SGABlockedDocuments.Init();
                                _SGABlockedDocuments.Validate("Document Type", _SGABlockedDocuments."Document Type"::"Purchase Return");
                                _SGABlockedDocuments.Validate("Document No.", TempDoc."Vendor No.");
                                _SGABlockedDocuments.Insert();
                            end;
                        end;
                    '310' .. '319':
                        begin
                            _SGABlockedDocuments.Reset();
                            _SGABlockedDocuments.SetRange("Document Type", _SGABlockedDocuments."Document Type"::Transfer);
                            _SGABlockedDocuments.SetRange("Document No.", TempDoc."Vendor No.");
                            if not _SGABlockedDocuments.FindFirst() then begin
                                _SGABlockedDocuments.Init();
                                _SGABlockedDocuments.Validate("Document Type", _SGABlockedDocuments."Document Type"::Transfer);
                                _SGABlockedDocuments.Validate("Document No.", TempDoc."Vendor No.");
                                _SGABlockedDocuments.Insert();
                            end;
                        end;
                    '210' .. '219':
                        begin
                            _SGABlockedDocuments.Reset();
                            _SGABlockedDocuments.SetRange("Document Type", _SGABlockedDocuments."Document Type"::Transfer);
                            _SGABlockedDocuments.SetRange("Document No.", TempDoc."Vendor No.");
                            if not _SGABlockedDocuments.FindFirst() then begin
                                _SGABlockedDocuments.Init();
                                _SGABlockedDocuments.Validate("Document Type", _SGABlockedDocuments."Document Type"::Transfer);
                                _SGABlockedDocuments.Validate("Document No.", TempDoc."Vendor No.");
                                _SGABlockedDocuments.Insert();
                            end;
                        end;
                end;
            until TempDoc.NEXT = 0;
    end;

    procedure LeerTablaBloqueo();
    var
        _SGABlockedDocuments: Record "BBT-IT SGA Blocked Documents";
        _CabCompra: Record "Purchase Header";
        _CabTransfer: Record "Transfer Header";
        _Cabenvio: Record "Warehouse Shipment Header";
        _LinEnvio: Record "Warehouse Shipment Line";
        _Cabventa: Record "Sales Header";
    begin
        _SGABlockedDocuments.Reset();
        if _SGABlockedDocuments.FindSet() then
            repeat
                case _SGABlockedDocuments."Document Type" of
                    _SGABlockedDocuments."Document Type"::Sales:
                        begin
                            if _Cabenvio.get(_SGABlockedDocuments."Document No.") then begin
                                // Documentos Envios Almacén
                                _Cabenvio."Status SGA" := _Cabenvio."Status SGA"::"Bloqueado SGA";
                                _Cabenvio.Modify();
                                // Pedidos Ventas
                                _LinEnvio.Reset();
                                _LinEnvio.SetRange("No.", _SGABlockedDocuments."Document No.");
                                _LinEnvio.SetRange("Source Type", 37);
                                _LinEnvio.SetRange("Source Subtype", 1);
                                _LinEnvio.SetRange("Source Document", _LinEnvio."Source Document"::"Sales Order");
                                _LinEnvio.SetFilter("Qty. to Ship (Base)", '<>%1', 0);
                                if _LinEnvio.FindSet() then
                                    repeat begin
                                        _Cabventa.GET(_LinEnvio."Source Subtype", _LinEnvio."Source No.");
                                        _Cabventa."Status SGA" := _Cabventa."Status SGA"::"Bloqueado SGA";
                                        _Cabventa.Modify();
                                    end;
                                    until _LinEnvio.Next() = 0;
                            end;
                        end;
                    _SGABlockedDocuments."Document Type"::Purchase:
                        if _CabCompra.get(_CabCompra."Document Type"::Order, _SGABlockedDocuments."Document No.") then begin
                            _CabCompra."Status SGA" := _CabCompra."Status SGA"::"Bloqueado SGA";
                            _CabCompra.Modify();
                        end;
                    _SGABlockedDocuments."Document Type"::Transfer:
                        if _CabTransfer.get(_SGABlockedDocuments."Document No.") then begin
                            _CabTransfer."Status SGA" := _CabTransfer."Status SGA"::"Bloqueado SGA";
                            _CabTransfer.MODIFY;
                        end;
                    _SGABlockedDocuments."Document Type"::"Sales Return":
                        if _Cabventa.get(_Cabventa."Document Type"::"Return Order", _SGABlockedDocuments."Document No.") then begin
                            _Cabventa."Status SGA" := _Cabventa."Status SGA"::"Bloqueado SGA";
                            _Cabventa.Modify();
                        end;
                    _SGABlockedDocuments."Document Type"::"Purchase Return":
                        if _CabCompra.get(_CabCompra."Document Type"::"Return Order", _SGABlockedDocuments."Document No.") then begin
                            _CabCompra."Status SGA" := _CabCompra."Status SGA"::"Bloqueado SGA";
                            _CabCompra.Modify();
                        end;
                end;
            until _SGABlockedDocuments.Next() = 0;
    end;
    /************* 24/11/2025 Proceso Anterior
        procedure LeerTablaBloqueo();
        var
            _WarehouseSetup: Record "Warehouse Setup";
            NumdocTipoTxt: Code[25];
            NumLineaTXT: Code[25];
            NumDoc: Code[20];
            Tipodoc: Code[25];
            NumLinea: Integer;
            _IDBigTxt: Text;
            _IDBig: BigInteger;
            _CabCompra: Record "Purchase Header";
            _Cabenvio: Record "Warehouse Shipment Header";
            _Cabventa: Record "Sales Header";
            _LinEnvio: Record "Warehouse Shipment Line";
            _TempCabVenta: Record "Inventory Buffer" temporary;
            _CabTransfer: Record "Transfer Header";
            _InfoCompany: Record "Company Information";
        begin
            // Punto 1 Tabla Bloqueos
            TempDoc.RESET;
            TempDoc.DELETEALL;
            _InfoCompany.GET;
            _WarehouseSetup.GET;
            Clear(SGAJsonObject);
            SGAJsonObject.Add('filter', 'IdEmpresaERP eq ''' + CompanyName + ''''); 
            HttpCall(SGACallType::"Bloqueo documentos", SGAJsonObject);
            //Read Json
            ArrayJSONManagement.InitializeCollection(ResponseTxt);
            for i := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
                TempDoc.init;
                ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, i);
                ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
                ObjectJSONManagement.GetStringPropertyValueByName('NumeroDocumento', ValueText);
                TempDoc."Vendor No." := ValueText;
                ObjectJSONManagement.GetStringPropertyValueByName('TipoDocumento', ValueText);
                TempDoc."Currency Code" := ValueText;
                IF NOT TempDoc.FIND THEN TempDoc.INSERT;
            end;
            IF TempDoc.FINDSET THEN
                REPEAT
                    CASE TempDoc."Currency Code" OF
                        '300':
                            IF _CabCompra.GET(_CabCompra."Document Type"::Order, TempDoc."Vendor No.") THEN BEGIN
                                _CabCompra."Status SGA" := _CabCompra."Status SGA"::"Bloqueado SGA";
                                _CabCompra.MODIFY;
                            END;
                        '200' .. '209':
                            IF _Cabenvio.GET(TempDoc."Vendor No.") THEN BEGIN
                                _TempCabVenta.RESET;
                                _TempCabVenta.DELETEALL;
                                _Cabventa.RESET;
                                _Cabenvio."Status SGA" := _Cabenvio."Status SGA"::"Bloqueado SGA";
                                _Cabenvio.MODIFY;
                                _LinEnvio.RESET;
                                _LinEnvio.SETRANGE("No.", _Cabenvio."No.");
                                _LinEnvio.SETRANGE("Source Type", 37);
                                _LinEnvio.SETRANGE("Source Subtype", 1);
                                _LinEnvio.SETRANGE("Source Document", _LinEnvio."Source Document"::"Sales Order");
                                _LinEnvio.SETFILTER("Qty. to Ship (Base)", '<>%1', 0);
                                IF _LinEnvio.FINDSET THEN
                                    REPEAT
                                        _TempCabVenta.INIT;
                                        _TempCabVenta."Item No." := _LinEnvio."Source No.";
                                        IF NOT _TempCabVenta.FIND THEN BEGIN
                                            _Cabventa.GET(_LinEnvio."Source Subtype", _LinEnvio."Source No.");
                                            _Cabventa."Status SGA" := _Cabventa."Status SGA"::"Bloqueado SGA";
                                            _Cabventa.MODIFY;
                                            _TempCabVenta.INSERT;
                                        END;
                                    UNTIL _LinEnvio.NEXT = 0;
                            END;
                        '370':
                            IF _Cabventa.GET(_Cabventa."Document Type"::"Return Order", TempDoc."Vendor No.") THEN BEGIN
                                _Cabventa."Status SGA" := _Cabventa."Status SGA"::"Bloqueado SGA";
                                _Cabventa.MODIFY;
                            END;
                        '270':
                            IF _CabCompra.GET(_CabCompra."Document Type"::"Return Order", TempDoc."Vendor No.") THEN BEGIN
                                _CabCompra."Status SGA" := _CabCompra."Status SGA"::"Bloqueado SGA";
                                _CabCompra.MODIFY;
                            END;
                        '310' .. '319':
                            IF _CabTransfer.GET(TempDoc."Vendor No.") THEN BEGIN
                                _CabTransfer."Status SGA" := _CabTransfer."Status SGA"::"Bloqueado SGA";
                                _CabTransfer.MODIFY;
                            END;
                        '210' .. '219':
                            IF _CabTransfer.GET(TempDoc."Vendor No.") THEN BEGIN
                                _CabTransfer."Status SGA" := _CabTransfer."Status SGA"::"Bloqueado SGA";
                                _CabTransfer.MODIFY;
                            END;
                    END;
                UNTIL TempDoc.NEXT = 0;
        end;
    **************/
    procedure GestionProducto(_Producto: Record Item);
    var
        _ItemIdentifier: Record "Item Identifier";
        _ItemUDCaja: Record "Item Unit of Measure";
        _ItemUDPalet: Record "Item Unit of Measure";
        _EAN13: Code[13];
        _EAN14: Code[14];
        _QuantBox: Decimal;
        _WarehouseSetup: Record "Warehouse Setup";
        _FV: Option F,T;
        _ControlLoteTXT: Text[1];
        _LoteEntradaTXT: Text[1];
        _LoteSalidasTXT: Text[1];
        _DescripProducto: Text[100];
        _Descripcorta: Text[100];
        _ItemUDBase: Record "Item Unit of Measure";
        _InfoCompany: Record "Company Information";
        CategoryLen: Integer;
    begin
        IF _Producto."No SGA management" THEN EXIT;
        _EAN13 := '';
        _EAN14 := '';
        _QuantBox := 0;
        _ControlLoteTXT := '';
        _LoteEntradaTXT := '';
        _LoteSalidasTXT := '';
        _WarehouseSetup.GET;
        _InfoCompany.GET;
        _ItemIdentifier.SETRANGE("Item No.", _Producto."No.");
        _ItemIdentifier.SETRANGE("Unit of Measure Code", _Producto."Base Unit of Measure");
        IF _ItemIdentifier.FINDSET THEN _EAN13 := _ItemIdentifier.Code;
        _ItemIdentifier.SETRANGE("Item No.", _Producto."No.");
        _ItemIdentifier.SETRANGE("Unit of Measure Code", _WarehouseSetup."Box Unit");
        IF _ItemIdentifier.FINDSET THEN _EAN14 := _ItemIdentifier.Code;
        _ItemUDCaja.RESET;
        _ItemUDCaja.SETRANGE("Item No.", _Producto."No.");
        _ItemUDCaja.SETRANGE(Code, _WarehouseSetup."Box Unit");
        IF _ItemUDCaja.FINDSET THEN
            _QuantBox := _ItemUDCaja."Qty. per Unit of Measure"
        ELSE
            CLEAR(_ItemUDCaja);
        _ItemUDPalet.RESET;
        _ItemUDPalet.SETRANGE("Item No.", _Producto."No.");
        _ItemUDPalet.SETRANGE(Code, _WarehouseSetup."Palet Unit");
        IF NOT _ItemUDPalet.FINDSET THEN CLEAR(_ItemUDPalet);
        _ItemUDBase.RESET;
        _ItemUDBase.SETRANGE("Item No.", _Producto."No.");
        _ItemUDBase.SETRANGE(Code, _Producto."Base Unit of Measure");
        IF NOT _ItemUDBase.FINDSET THEN CLEAR(_ItemUDBase);
        IF _Producto."SGA lot management" THEN
            _ControlLoteTXT := 'T'
        ELSE
            _ControlLoteTXT := 'F';
        IF _Producto."Forced buy SGA" THEN
            _LoteEntradaTXT := 'T'
        ELSE
            _LoteEntradaTXT := 'F';
        IF _Producto."Forced sales SGA" THEN
            _LoteSalidasTXT := 'T'
        ELSE
            _LoteSalidasTXT := 'F';
        _DescripProducto := _Producto.Description;
        //>> BBT 05/11/2025. Se igualan las descripciones en el TWO
        //_Descripcorta := _Producto."Search Description";
        _Descripcorta := _Producto.Description;
        //<>
        ReemplazarCaracter(_DescripProducto, '''', ',');
        ReemplazarCaracter(_Descripcorta, '''', ',');
        CategoryLen := strlen(_Producto."Item Category Code");
        //Compongo JSON
        Clear(SGAJsonObject);
        SGAJsonObject.Add('IdEmpresaERP', COMPANYNAME);
        SGAJsonObject.Add('CodigoArticulo', _Producto."No.");
        SGAJsonObject.Add('GTIN13', _EAN13);
        SGAJsonObject.Add('GTIN14', _EAN14);
        SGAJsonObject.Add('CantidadPorGTIN14', _QuantBox);
        SGAJsonObject.Add('DescripcionCorta', _Descripcorta);
        SGAJsonObject.Add('Descripcion1', _DescripProducto);
        SGAJsonObject.Add('Sector', _Producto."Gen. Prod. Posting Group");
        SGAJsonObject.Add('SubSector', CopyStr(_Producto."Item Category Code", 1, 2));
        SGAJsonObject.Add('Seccion', CopyStr(_Producto."Item Category Code", CategoryLen - 1, 2));
        SGAJsonObject.Add('UnidadMedidaBasica', _Producto."Base Unit of Measure");
        SGAJsonObject.Add('PesoNetoKG', _ItemUDBase.Weight);
        SGAJsonObject.Add('PesoBrutoKG', _ItemUDBase."Gross weight");
        SGAJsonObject.Add('VolumenL', _ItemUDBase.Cubage);
        SGAJsonObject.Add('DimX', _ItemUDBase.Length);
        SGAJsonObject.Add('DimY', _ItemUDBase.Width);
        SGAJsonObject.Add('DimZ', _ItemUDBase.Height);
        SGAJsonObject.Add('ControlLote', _ControlLoteTXT);
        SGAJsonObject.Add('LoteEntradasERP', _LoteEntradaTXT);
        SGAJsonObject.Add('LoteSalidasERP', _LoteSalidasTXT);
        SGAJsonObject.Add('ControlCaducidad', 'F');
        SGAJsonObject.Add('PesoVariable', 'F');
        SGAJsonObject.Add('Kit', 'F');
        SGAJsonObject.Add('Stock', 'T');
        SGAJsonObject.Add('FechaAltaEnlace', GetFechaTrabajo);
        SGAJsonObject.Add('PesoNetoKG_CAJ', _ItemUDCaja.Weight);
        SGAJsonObject.Add('PesoBrutoKG_CAJ', _ItemUDCaja."Gross weight");
        SGAJsonObject.Add('VolumenL_CAJ', _ItemUDCaja.Cubage);
        SGAJsonObject.Add('DimX_CAJ', _ItemUDCaja.Length);
        SGAJsonObject.Add('DimY_CAJ', _ItemUDCaja.Width);
        SGAJsonObject.Add('DimZ_CAJ', _ItemUDCaja.Height);
        SGAJsonObject.Add('PesoNetoKG_PAL', _ItemUDPalet.Weight);
        SGAJsonObject.Add('PesoBrutoKG_PAL', _ItemUDPalet."Gross weight");
        SGAJsonObject.Add('VolumenL_PAL', _ItemUDPalet.Cubage);
        SGAJsonObject.Add('DimX_PAL', _ItemUDPalet.Length);
        SGAJsonObject.Add('DimY_PAL', _ItemUDPalet.Width);
        SGAJsonObject.Add('DimZ_PAL', _ItemUDPalet.Height);
        HttpCall(SGACallType::"Insertar producto", SGAJsonObject);
        _Producto.ModificadoSGA := FALSE;
        _Producto.MODIFY;
    end;

    procedure GestionPedidoCompra(_NumDoc: Code[20]);
    var
        _WarehouseSetup: Record "Warehouse Setup";
        _FechaTrabajoDT: DateTime;
        _CabCompra: Record "Purchase Header";
        _Lincompra: Record "Purchase Line";
        _Procesarlinea: Boolean;
        _Producto: Record Item;
        _Pais: Record "Country/Region";
        _FechaServicio: DateTime;
        _FechaServicioTxt: Text[50];
        _Location: Record Location;
        _MarcarPedido: Boolean;
        Error01: Label 'El almacen de recepción debe ser del tipo Calidad para el producto %1 en el nº linea %2';
        _Name: Text[100];
        _Address: Text[100];
        _Address2: Text[100];
        _City: Text[50];
        _County: Text[50];
        _InfoCompany: Record "Company Information";
    begin
        // Punto 4 Pedido de compra.
        _InfoCompany.GET;
        _WarehouseSetup.GET;
        _MarcarPedido := FALSE;
        _CabCompra.GET(_CabCompra."Document Type"::Order, _NumDoc);
        _CabCompra.TESTFIELD("Document Type");
        _CabCompra.TESTFIELD("Buy-from Vendor No.");
        _CabCompra.TESTFIELD("Pay-to Vendor No.");
        _CabCompra.TESTFIELD("Posting Date");
        _CabCompra.TESTFIELD("Document Date");
        _CabCompra.TESTFIELD("Payment Method Code");
        _CabCompra.TESTFIELD("Payment Terms Code");
        _Lincompra.SETRANGE("Document Type", _CabCompra."Document Type");
        _Lincompra.SETRANGE("Document No.", _CabCompra."No.");
        _Lincompra.SETRANGE(Type, _Lincompra.Type::Item);
        IF _CabCompra.ModificadoSGA THEN _Lincompra.SETRANGE("Modificado SGA", TRUE);
        IF _Lincompra.FINDSET THEN
            REPEAT
                _Procesarlinea := TRUE;
                IF _Lincompra.Type = _Lincompra.Type::Item THEN BEGIN
                    _Producto.GET(_Lincompra."No.");
                    _Procesarlinea := NOT _Producto."No SGA management";
                    IF _Procesarlinea THEN BEGIN
                        _Location.GET(_Lincompra."Location Code");
                        IF NOT _Location.Calidad THEN ERROR(Error01, _Lincompra."No.", _Lincompra."Line No.");
                    END;
                END;
                IF _Procesarlinea THEN BEGIN
                    IF NOT _Pais.GET(_CabCompra."Buy-from Country/Region Code") THEN CLEAR(_Pais);
                    IF _CabCompra."Requested Receipt Date" = 0D THEN
                        _FechaServicioTxt := 'NULL'
                    ELSE BEGIN
                        _FechaServicio := CREATEDATETIME(_CabCompra."Requested Receipt Date", 0T);
                    END;
                    _MarcarPedido := TRUE;
                    _Name := _CabCompra."Buy-from Vendor Name";
                    _Address := _CabCompra."Buy-from Address";
                    _Address2 := _CabCompra."Buy-from Address 2";
                    _City := _CabCompra."Buy-from City";
                    _County := _CabCompra."Buy-from County";
                    ReemplazarCaracter(_Name, '''', '');
                    ReemplazarCaracter(_Address, '''', '');
                    ReemplazarCaracter(_Address2, '''', '');
                    ReemplazarCaracter(_City, '''', '');
                    ReemplazarCaracter(_County, '''', '');
                    // metemos la linea del producto en sql
                    //Compongo JSON
                    Clear(SGAJsonObject);
                    SGAJsonObject.Add('CodigoAlmacenWMS', _Location."SGA Whse Code");
                    SGAJsonObject.Add('IdAlmacenERP', _Lincompra."Location Code");
                    SGAJsonObject.Add('CodigoAlmacenOrigenWMS', _Location."SGA Whse Code");
                    SGAJsonObject.Add('IdAlmacenOrigenERP', _Lincompra."Location Code");
                    SGAJsonObject.Add('IdEmpresaERP', COMPANYNAME);
                    SGAJsonObject.Add('TipoDocumento', '300');
                    SGAJsonObject.Add('NumeroDocumento', _CabCompra."No.");
                    SGAJsonObject.Add('CodigoOrdenante', _CabCompra."Buy-from Vendor No.");
                    SGAJsonObject.Add('NombreComercial', DELCHR(_Name, '=', ''''''''));
                    SGAJsonObject.Add('Direccion', DELCHR(_Address + ' ' + _Address2, '=', ''''''''));
                    SGAJsonObject.Add('CP', _CabCompra."Buy-from Post Code");
                    SGAJsonObject.Add('Poblacion', DELCHR(_City, '=', ''''''''));
                    SGAJsonObject.Add('Provincia', _County);
                    SGAJsonObject.Add('CodigoPaisISO', _CabCompra."Buy-from Country/Region Code");
                    SGAJsonObject.Add('Pais', _Pais.Name);
                    SGAJsonObject.Add('ServicioDocumento', '{C,P}');
                    SGAJsonObject.Add('FechaAlta', GetFechaTrabajo);
                    if _FechaServicioTxt = 'NULL' then
                        SGAJsonObject.Add('FechaServicioPrevista', _FechaServicioTxt)
                    else
                        SGAJsonObject.Add('FechaServicioPrevista', _FechaServicio);
                    SGAJsonObject.Add('NumeroLinea', FORMAT(_Lincompra."Line No."));
                    SGAJsonObject.Add('CodigoArticulo', _Lincompra."No.");
                    SGAJsonObject.Add('CantidadPedidaUMB', _Lincompra."Quantity (Base)");
                    SGAJsonObject.Add('SituacionStock', '');
                    SGAJsonObject.Add('FechaAltaEnlace', GetFechaTrabajo);
                    HttpCall(SGACallType::"Gestion pedido compra", SGAJsonObject);
                END;
            UNTIL _Lincompra.NEXT = 0;
        _Lincompra.MODIFYALL("Modificado SGA", FALSE);
        _CabCompra.ModificadoSGA := FALSE;
        IF _MarcarPedido THEN BEGIN
            _CabCompra."Status SGA" := _CabCompra."Status SGA"::"Enviado SGA";
            _CabCompra."Grabado SGA" := CURRENTDATETIME;
            _CabCompra.MODIFY;
        END
        ELSE
            MESSAGE('Nada para enviar al SGA');
    end;

    procedure RecepPedCompra();
    var
        _TempLotes: Record "Inventory Buffer" temporary;
        _TempLineas: Record "Inventory Buffer" temporary;
        _Almacen: Code[10];
        _TipoDocumento: Code[3];
        _NumDocumentoTipo: Code[25];
        _NumLineaTxt: Text[25];
        _CodArticulo: Code[20];
        _CantidadRecibirTxT: Text[25];
        _NumLote: Text[25];
        _FechaAltaTxt: Text[25];
        _TempPedidos: Record "Inventory Buffer" temporary;
        _Numlinea: Integer;
        _CantidadRecibirDec: Decimal;
        _CantidadRecibir: Integer;
        _Tipo: Code[3];
        _NumDocumento: Code[20];
        _LinPedCompra: Record "Purchase Line";
        _CabPedCompra: Record "Purchase Header";
        _TextoError: Text[250];
        Error01: Label 'No existe el pedido de compra.';
        Error02: Label 'Línea no existe.';
        Error03: Label 'Cantidad pendiente menor que cantidad a recibir.';
        Ok: Boolean;
        _ComentarioLinea: Record "Purch. Comment Line";
        _TempComentarioLinea: Record "Purch. Comment Line" temporary;
        _NumLineaComentario: Integer;
        _TempLineasID: Record "Temp SQL" temporary;
        _IDBigTxt: Text;
        _IDBig: BigInteger;
        _FechaAltaDateTime: DateTime;
        _FechaAlta: Date;
        _ReleasePurchDoc: Codeunit "Release Purchase Document";
        _idioma: Text[2];
        _TempCabPedCompra: Record "Purchase Header" temporary;
        _TempLinCompra: Record "Purchase Line" temporary;
        _InfoCompany: Record "Company Information";
    begin
        // Punto 5 Recepción pedidos de compra
        _idioma := '5'; //Idioma ESP.
        _InfoCompany.GET;
        _TempCabPedCompra.RESET;
        _TempLinCompra.RESET;
        _TempCabPedCompra.DELETEALL;
        _TempLinCompra.DELETEALL;
        _TempLineas.RESET;
        _TempLineas.DELETEALL;
        _TempLotes.RESET;
        _TempLotes.DELETEALL;
        _TempLineasID.RESET;
        _TempLineasID.DELETEALL;
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'TipoDocumento eq ''300'' AND IdEmpresaERP eq ''' + CompanyName + ''' and FechaProcesoEnlace eq null and (Resultado eq null or Resultado eq '''')');
        HttpCall(SGACallType::"Recepcion pedido compra", SGAJsonObject);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for i := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, i);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('IdAlmacenERP', ValueText);
            _Almacen := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('TipoDocumento', ValueText);
            _Tipo := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroDocumento', ValueText);
            _NumDocumento := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroLinea', ValueText);
            _NumLineaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CodigoArticulo', ValueText);
            _CodArticulo := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CantidadServidaUMB', ValueText);
            _CantidadRecibirTxT := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroLote', ValueText);
            _NumLote := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('FechaAltaEnlace', ValueText);
            _FechaAltaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('ROWID', ValueText);
            _IDBigTxt := ValueText;
            EVALUATE(_IDBig, _IDBigTxt);
            EVALUATE(_Numlinea, _NumLineaTxt);

            //>> BBT 28/08/2025. La cantidad debe ser entera (sin decimales)
            IF _idioma <> '0' THEN
                EVALUATE(_CantidadRecibirDec, _CantidadRecibirTxT)
            ELSE
                ConverTextoADecimal(_CantidadRecibirTxT, _CantidadRecibirDec);

            _CantidadRecibir := ConvertDecimalAEntero(_CantidadRecibirDec);
            //<<    

            EVALUATE(_FechaAlta, _FechaAltaTxt);
            // ExtraerNumDocTipo(_NumDocumentoTipo,_Tipo,_NumDocumento);
            _TempLineasID.INIT;
            _TempLineasID.ID := _IDBig;
            _TempLineasID.Tipo := _Tipo;
            _TempLineasID."No. Documento" := _NumDocumento;
            _TempLineasID.INSERT;
            _TempPedidos.INIT;
            _TempPedidos."Item No." := _NumDocumento;
            IF NOT _TempPedidos.FIND THEN _TempPedidos.INSERT;
            _TempPedidos."Delivery Number" := _FechaAltaTxt;
            _TempPedidos.MODIFY;
            _TempLineas.INIT;
            _TempLineas."Item No." := _NumDocumento;
            _TempLineas."Variant Code" := _Tipo;
            _TempLineas."Dimension Entry No." := _Numlinea;
            IF NOT _TempLineas.FIND THEN _TempLineas.INSERT;
            _TempLineas.Quantity += _CantidadRecibir;
            _TempLineas.MODIFY;
            IF _NumLote <> '' THEN BEGIN
                _TempLotes.INIT;
                _TempLotes."Item No." := _NumDocumento;
                _TempLotes."Variant Code" := _Tipo;
                _TempLotes."Dimension Entry No." := _Numlinea;
                _TempLotes."Serial No." := _NumLote;
                IF NOT _TempLotes.FIND THEN _TempLotes.INSERT;
                _TempLotes.Quantity := _CantidadRecibir;
                _TempLotes.MODIFY;
            END;
        end;
        // Actualizar pedido a recibir
        // Registrar
        _TempPedidos.RESET;
        _TempLineas.RESET;
        _TempLotes.RESET;
        IF _TempPedidos.FINDSET THEN
            REPEAT
                _TempCabPedCompra.RESET;
                _TempLinCompra.RESET;
                _TempCabPedCompra.DELETEALL;
                _TempLinCompra.DELETEALL;
                _TextoError := '';
                _TempComentarioLinea.RESET;
                _TempComentarioLinea.DELETEALL;
                IF NOT _CabPedCompra.GET(_CabPedCompra."Document Type"::Order, _TempPedidos."Item No.") THEN _TextoError := Error01;
                IF _TextoError = '' THEN BEGIN
                    _TempCabPedCompra.INIT;
                    _TempCabPedCompra := _CabPedCompra;
                    _TempCabPedCompra.INSERT;
                    IF NOT AbrirPedidoCompra(_CabPedCompra) THEN _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250);
                END;
                IF _TextoError = '' THEN BEGIN
                    EVALUATE(_FechaAlta, _TempPedidos."Delivery Number");
                    IF NOT validarFechaRegistroCompra(_CabPedCompra, _FechaAlta) THEN
                        _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250)
                    ELSE
                        _CabPedCompra.MODIFY;
                END;
                IF _TextoError = '' THEN BEGIN
                    _CabPedCompra.MODIFY;
                    _LinPedCompra.RESET;
                    _LinPedCompra.SETRANGE("Document Type", _LinPedCompra."Document Type"::Order);
                    _LinPedCompra.SETRANGE("Document No.", _TempPedidos."Item No.");
                    IF _LinPedCompra.FINDSET(TRUE) THEN
                        REPEAT
                            _TempLinCompra.INIT;
                            _TempLinCompra := _LinPedCompra;
                            _TempLinCompra.INSERT;
                            IF _LinPedCompra."Qty. to Receive" <> 0 THEN BEGIN
                                IF NOT ValidarCantRecibBase(_LinPedCompra, 0) THEN _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250);
                                _LinPedCompra.MODIFY;
                            END;
                        UNTIL _LinPedCompra.NEXT = 0;
                    _LinPedCompra.RESET;
                    _ComentarioLinea.RESET;
                    _ComentarioLinea.SETRANGE("Document Type", _CabPedCompra."Document Type");
                    _ComentarioLinea.SETRANGE("No.", _CabPedCompra."No.");
                    IF _ComentarioLinea.FINDLAST THEN
                        _NumLineaComentario := _ComentarioLinea."Line No."
                    ELSE
                        _NumLineaComentario := 0;
                    _TempLineas.SETRANGE("Variant Code", '300');
                    _TempLineas.SETRANGE("Item No.", _CabPedCompra."No.");
                    IF _TempLineas.FINDSET THEN
                        REPEAT
                            IF NOT _LinPedCompra.GET(_CabPedCompra."Document Type", _CabPedCompra."No.", _TempLineas."Dimension Entry No.") THEN
                                _TextoError := Error02
                            ELSE IF _LinPedCompra."Outstanding Qty. (Base)" < _TempLineas.Quantity THEN _TextoError := Error03;
                            IF _TextoError = '' THEN
                                IF NOT ValidarCantRecibBase(_LinPedCompra, _TempLineas.Quantity) THEN
                                    _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250)
                                ELSE
                                    _LinPedCompra.MODIFY;
                            IF _TextoError = '' THEN;
                            //Se meteran en comentario de linea
                            BEGIN
                                _TempLotes.SETRANGE("Item No.", _CabPedCompra."No.");
                                _TempLotes.SETRANGE("Variant Code", '300');
                                _TempLotes.SETRANGE("Dimension Entry No.", _LinPedCompra."Line No.");
                                IF _TempLotes.FINDSET THEN
                                    REPEAT
                                        _NumLineaComentario += 10000;
                                        _ComentarioLinea.INIT;
                                        _ComentarioLinea."Document Type" := _CabPedCompra."Document Type";
                                        _ComentarioLinea."No." := _CabPedCompra."No.";
                                        _ComentarioLinea."Document Line No." := _LinPedCompra."Line No.";
                                        _ComentarioLinea."Line No." := _NumLineaComentario;
                                        _ComentarioLinea.Comment := 'Lote: ' + _TempLotes."Serial No." + ' / Ctd.: ' + FORMAT(_TempLotes.Quantity, 0);
                                        _ComentarioLinea.INSERT;
                                        _TempComentarioLinea := _ComentarioLinea;
                                        _TempComentarioLinea.INSERT;
                                    UNTIL _TempLotes.NEXT = 0;
                            END;
                        UNTIL _TempLineas.NEXT = 0;
                END;
                IF _TextoError = '' THEN
                    IF NOT RegistrarCompra(_CabPedCompra) THEN BEGIN
                        _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250);
                        _TempComentarioLinea.RESET;
                        IF _TempComentarioLinea.FINDSET THEN BEGIN
                            _ComentarioLinea := _TempComentarioLinea;
                            IF _ComentarioLinea.FIND THEN _ComentarioLinea.DELETE;
                        END;
                    END
                    ELSE BEGIN
                        _CabPedCompra."Leido SGA" := CURRENTDATETIME;
                        _CabPedCompra.MODIFY;
                    END;
                IF _TextoError = '' THEN
                    _TextoError := 'CORRECTO'
                ELSE BEGIN
                    _CabPedCompra.RESET;
                    CLEAR(_CabPedCompra);
                    IF _TempCabPedCompra.FINDFIRST THEN BEGIN
                        _CabPedCompra.INIT;
                        IF _CabPedCompra.GET(_TempCabPedCompra."Document Type", _TempCabPedCompra."No.") THEN BEGIN
                            _CabPedCompra.TRANSFERFIELDS(_TempCabPedCompra, FALSE);
                            _CabPedCompra.MODIFY;
                        END;
                    END;
                    _TempLinCompra.RESET;
                    _LinPedCompra.RESET;
                    CLEAR(_LinPedCompra);
                    IF _TempLinCompra.FINDSET THEN
                        REPEAT
                            _LinPedCompra.INIT;
                            IF _LinPedCompra.GET(_TempLinCompra."Document Type", _TempLinCompra."Document No.", _TempLinCompra."Line No.") THEN BEGIN
                                _LinPedCompra.TRANSFERFIELDS(_TempLinCompra, FALSE);
                                _LinPedCompra.MODIFY;
                            END;
                        UNTIL _TempLinCompra.NEXT = 0;
                END;
                ReemplazarCaracter(_TextoError, '''', '');
                _TempLineasID.RESET;
                _TempLineasID.SETRANGE(Tipo, '300');
                _TempLineasID.SETRANGE("No. Documento", _TempPedidos."Item No.");
                IF _TempLineasID.FINDSET THEN
                    REPEAT
                        Clear(SGAJsonObject);
                        SGAJsonObject.Add('FechaProcesoEnlace', GetFechaTrabajo());
                        SGAJsonObject.Add('Resultado', _TextoError);
                        SGAJsonObject.Add('RowId', FORMAT(_TempLineasID.ID));
                        HttpCall(SGACallType::"Actualizar documento", SGAJsonObject);
                    UNTIL _TempLineasID.NEXT = 0;
            UNTIL _TempPedidos.NEXT = 0;
    end;

    /*   DEAs    */
    procedure PedVentaDocEnvio(_NumEnvio: Code[20]; _Borrar: Boolean);
    var
        //_WarehouseSetup: Record "Warehouse Setup";
        //_FechaTrabajoDT: DateTime;
        _FechaServicio: DateTime;
        //_FechaServicioTxt: Text[50];
        _CabEnvio: Record "Warehouse Shipment Header";
        _LinEnvo: Record "Warehouse Shipment Line";
        _CabVenta: Record "Sales Header";
        //_LinVenta: Record "Sales Line";
        _Pais: Record "Country/Region";
        _Transportista: Record "Shipping Agent";
        _LinComentario: Record "Warehouse Comment Line";
        _Comentarios: Text;
        _TemplinEnvio: Record "Warehouse Shipment Line" temporary;
        _Name: Text[100];
        _Address: Text[100];
        _Address2: Text[100];
        _City: Text[50];
        _County: Text[50];
        _TempCabVenta: Record "Inventory Buffer" temporary;
        _NombreDeEnvio: Text[50];
        _TipoDocumento: Integer;
        _Cliente: Record Customer;
        _TipodocumentoTxt: Text[5];
        _InfoCompany: Record "Company Information";
        _Location: Record Location;

        //>> BBT 10/02/2024 Variables para averiguar el tipo de dirección de envio
        _CustomerMgt: Codeunit "Customer Mgt.";
        STO: Enum "Sales Ship-to Options";
        _ShipToOptions: Enum "Sales Ship-to Options";
        _BillToOptions: Enum "Sales Bill-to Options";
    //<<
    begin
        // Punto 8 Pedidos de venta - Documento de envío
        _CabEnvio.GET(_NumEnvio);
        _InfoCompany.GET;
        //CLEAR(sql_Estructura);
        _TempCabVenta.RESET;
        _TempCabVenta.DELETEALL;
        IF _Borrar THEN BEGIN
            IF _CabEnvio.Status <> _CabEnvio.Status::Open THEN ERROR('El envio esta lanzado');
        END
        ELSE IF _CabEnvio.Status <> _CabEnvio.Status::Released THEN ERROR('El envio debe de estar lanzado');
        _Comentarios := '';
        _LinComentario.RESET;
        _LinComentario.SETRANGE("Table Name", _LinComentario."Table Name"::"Whse. Shipment");
        _LinComentario.SETRANGE("No.", _NumEnvio);
        IF _LinComentario.FINDSET THEN
            REPEAT
                _Comentarios += _LinComentario.Comment + ' ';
            UNTIL _LinComentario.NEXT = 0;
        IF STRLEN(_Comentarios) <> 0 THEN _Comentarios := COPYSTR(_Comentarios, 1, STRLEN(_Comentarios) - 1);
        _TemplinEnvio.RESET;
        _LinEnvo.SETRANGE("Source Type", 37);
        _LinEnvo.SETRANGE("Source Subtype", 1);
        _LinEnvo.SETRANGE("No.", _NumEnvio);
        IF _LinEnvo.FINDSET THEN
            REPEAT
                _TemplinEnvio.RESET;
                _TemplinEnvio.SETRANGE("Item No.", _LinEnvo."Item No.");
                IF NOT _TemplinEnvio.FINDFIRST THEN BEGIN
                    _TemplinEnvio.RESET;
                    _TemplinEnvio := _LinEnvo;
                    _TemplinEnvio.INSERT;
                END
                ELSE BEGIN
                    _TemplinEnvio."Qty. to Ship (Base)" += _LinEnvo."Qty. to Ship (Base)";
                    _TemplinEnvio.MODIFY;
                END;
            UNTIL _LinEnvo.NEXT = 0;
        //>> Averiguamos la fecha de entrega (PV: Fecha Entrega Requerida VS  DEA: Fecha Envío) 
        //Clear(_FechaServicioTxt);
        // Si el DEA ya tiene fecha la mantenemos
        Clear(_FechaServicio);
        if _CabEnvio."Shipment Date" <> 0D then begin
            _FechaServicio := CREATEDATETIME(_CabEnvio."Shipment Date", 0T);
        end
        else begin // Buscamos la fecha requerida más próxima de los pedidos de venta del DEA
            _TemplinEnvio.RESET;
            IF _TemplinEnvio.FINDSET THEN begin
                REPEAT
                    _CabVenta.GET(_TemplinEnvio."Source Subtype", _LinEnvo."Source No.");
                    if _CabVenta."Requested Delivery Date" <> 0D then begin
                        if (_FechaServicio = 0DT) then
                            _FechaServicio := CREATEDATETIME(_CabVenta."Requested Delivery Date", 0T)
                        else if _FechaServicio > CREATEDATETIME(_CabVenta."Requested Delivery Date", 0T) then
                            _FechaServicio := CREATEDATETIME(_CabVenta."Requested Delivery Date", 0T);
                    end;
                UNTIL _TemplinEnvio.NEXT = 0;
            end;
        end;
        // si la fecha de envio es menor(o igual) a la fecha actual no la ponemos
        if _FechaServicio <> 0DT then
            if _FechaServicio <= CREATEDATETIME(WORKDATE, 0T) then
                Clear(_FechaServicio);
        //<< 
        _TemplinEnvio.RESET;
        IF _TemplinEnvio.FINDSET THEN BEGIN
            REPEAT
                _CabVenta.GET(_TemplinEnvio."Source Subtype", _LinEnvo."Source No.");
                _TipoDocumento := 200;
                _Cliente.GET(_CabVenta."Sell-to Customer No.");
                _Location.GET(_CabEnvio."Location Code");
                _TipoDocumento := _TipoDocumento + _Cliente."Customer Pool";
                _TipodocumentoTxt := FORMAT(_TipoDocumento);
                _TempCabVenta.INIT;
                _TempCabVenta."Item No." := _CabVenta."No.";
                IF NOT _TempCabVenta.FIND THEN BEGIN
                    _CabVenta."Status SGA" := _CabVenta."Status SGA"::"Enviado SGA";
                    _CabVenta.MODIFY;
                    _TempCabVenta.INSERT;
                END;
                IF _CabVenta."Ship-to Code" = '' THEN BEGIN
                    IF NOT _Pais.GET(_CabVenta."Sell-to Country/Region Code") THEN CLEAR(_Pais);
                END
                ELSE BEGIN
                    IF NOT _Pais.GET(_CabVenta."Ship-to Country/Region Code") THEN CLEAR(_Pais);
                END;
                IF NOT _Transportista.GET(_CabVenta."Shipping Agent Code") THEN CLEAR(_Transportista);
                //>>
                //IF _CabVenta."Requested Delivery Date" = 0D THEN
                //    _FechaServicioTxt := 'NULL'
                //ELSE BEGIN
                //    _FechaServicio := CREATEDATETIME(_CabEnvio."Shipment Date", 0T);
                //END;
                //<<
                _NombreDeEnvio := '';
                Clear(SGAJsonObject);
                SGAJsonObject.Add('CodigoAlmacenWMS', _Location."SGA Whse Code");
                SGAJsonObject.Add('IdAlmacenERP', _CabEnvio."Location Code");
                SGAJsonObject.Add('CodigoAlmacenOrigenWMS', _Location."SGA Whse Code");
                SGAJsonObject.Add('IdAlmacenOrigenERP', _CabEnvio."Location Code");
                SGAJsonObject.Add('IdEmpresaERP', COMPANYNAME);
                SGAJsonObject.Add('TipoDocumento', _TipodocumentoTxt);
                SGAJsonObject.Add('NumeroDocumento', _CabEnvio."No.");

                //>> BBT 10/02/2024 Procedure STD para averiguar el tipo de dirección de envio
                _CustomerMgt.CalculateShipBillToOptions(_ShiptoOptions, _BilltoOptions, _CabVenta);
                case _ShiptoOptions of
                    STO::"Default (Sell-to Address)":   //Dirección Predeterminada. Dirección Envío ficha del cliente
                        begin
                            _Address := _CabVenta."Sell-to Address";
                            _Address2 := _CabVenta."Sell-to Address 2";
                            _City := _CabVenta."Sell-to City";
                            _County := _CabVenta."Sell-to County";
                            SGAJsonObject.Add('CodigoOrdenante', _CabVenta."Sell-to Customer No.");
                            SGAJsonObject.Add('CP', _CabVenta."Sell-to Post Code");
                            SGAJsonObject.Add('CodigoPaisISO', _CabVenta."Sell-to Country/Region Code");
                        end;
                    STO::"Alternate Shipping Address":  //Dirección Alternativa. Direcciones de Envío del cliente
                        begin
                            _Address := _CabVenta."Ship-to Address";
                            _Address2 := _CabVenta."Ship-to Address 2";
                            _City := _CabVenta."Ship-to City";
                            _County := _CabVenta."Ship-to County";
                            SGAJsonObject.Add('CodigoOrdenante', _CabVenta."Sell-to Customer No.");
                            SGAJsonObject.Add('CP', _CabVenta."Ship-to Post Code");
                            SGAJsonObject.Add('CodigoPaisISO', _CabVenta."Ship-to Country/Region Code");
                        end;
                    STO::"Custom Address":      // Dirección Personalizada
                        begin
                            _Address := _CabVenta."Ship-to Address";
                            _Address2 := _CabVenta."Ship-to Address 2";
                            _City := _CabVenta."Ship-to City";
                            _County := _CabVenta."Ship-to County";
                            SGAJsonObject.Add('CodigoOrdenante', _CabVenta."Sell-to Customer No.");
                            SGAJsonObject.Add('CP', _CabVenta."Ship-to Post Code");
                            SGAJsonObject.Add('CodigoPaisISO', _CabVenta."Ship-to Country/Region Code");
                        end;
                    else
                        Error('El tipo de Dirección de Envío es incorrecto');
                end;
                ReemplazarCaracter(_Address, '''', '');
                ReemplazarCaracter(_Address2, '''', '');
                ReemplazarCaracter(_City, '''', '');
                ReemplazarCaracter(_County, '''', '');
                SGAJsonObject.Add('Direccion', _Address + ' ' + _Address2);
                SGAJsonObject.Add('Poblacion', _City);
                SGAJsonObject.Add('Provincia', _County);
                //<<
                _Name := _CabVenta."Sell-to Customer Name";
                ReemplazarCaracter(_Name, '''', '');
                _NombreDeEnvio := _CabVenta."Ship-to Name";
                SGAJsonObject.Add('NombreDeEnvio', _NombreDeEnvio);
                ReemplazarCaracter(_NombreDeEnvio, '''', '');
                SGAJsonObject.Add('NombreComercial', _Name);
                SGAJsonObject.Add('Pais', _Pais.Name);
                SGAJsonObject.Add('CodigoTransportista', _CabVenta."Shipping Agent Code");
                SGAJsonObject.Add('NombreTransportista', _Transportista.Name);
                SGAJsonObject.Add('ServicioDocumento', '{C,P}');
                SGAJsonObject.Add('FechaAlta', GetFechaTrabajo);
                //>>
                //if _FechaServicioTxt = 'NULL' then
                //    SGAJsonObject.Add('FechaServicioPrevista', _FechaServicioTxt)
                //else
                //    SGAJsonObject.Add('FechaServicioPrevista', _FechaServicio);
                if _FechaServicio <> 0DT then
                    SGAJsonObject.Add('FechaServicioPrevista', _FechaServicio)
                else
                    SGAJsonObject.Add('FechaServicioPrevista', 'NULL');
                //<<    
                SGAJsonObject.Add('NumeroLinea', FORMAT(_TemplinEnvio."Line No."));
                SGAJsonObject.Add('CodigoArticulo', _TemplinEnvio."Item No.");
                SGAJsonObject.Add('CantidadPedidaUMB', _TemplinEnvio."Qty. to Ship (Base)");
                SGAJsonObject.Add('ComentariosLinea', _Comentarios);
                SGAJsonObject.Add('FechaAltaEnlace', GetFechaTrabajo);
                SGAJsonObject.Add('Libre1', _CabVenta.Reference);

                HttpCall(SGACallType::"Documento envio", SGAJsonObject);
            UNTIL _TemplinEnvio.NEXT = 0;
            IF NOT _Borrar THEN BEGIN
                _CabEnvio."Status SGA" := _CabEnvio."Status SGA"::"Enviado SGA";
                _CabEnvio."Grabado SGA" := CREATEDATETIME(WORKDATE, TIME);
                _CabEnvio.ModificadoSGA := FALSE;
                _CabEnvio.MODIFY;
            END;
        END;
    end;
    /**/
    procedure AlbVentaDocEnvio();
    var
        _Almacen: Code[10];
        _NoDoc: Code[20];
        _NoEntAlm: Code[25];
        _NumLineaTxt: Text[20];
        _Numlinea: Integer;
        _CodArticulo: Code[20];
        _CantidadTxt: Text[20];
        _NumeroLote: Text[25];
        _FechaAltaTxt: Text[20];
        _FechaAltaDateTime: DateTime;
        _FechaAlta: Date;
        _IDBigTxt: Text;
        _IdBig: BigInteger;
        _Ok: Boolean;
        _Tipo: Code[10];
        _TempLineas: Record "Inventory Buffer" temporary;
        _TempLotes: Record "Inventory Buffer" temporary;
        _ComentarioLinea: Record "Warehouse line Comment";
        _TempComentarioLinea: Record "Warehouse line Comment" temporary;
        _TempComentarioLinea2: Record "Warehouse line Comment" temporary;
        _NumLineaComentario: Integer;
        _CantidadDec: Decimal;
        _Cantidad: Integer;
        _TempEnvio: Record "Inventory Buffer" temporary;
        _TextoError: Text;
        _CabEnvio: Record "Warehouse Shipment Header";
        Error01: Label 'El Envio NO Existe';
        _LinEnvio: Record "Warehouse Shipment Line";
        _LinenvioTemp: Record "Warehouse Shipment Line" temporary;
        Error03: Label 'La cantidad a enviar es mayor que la cantidad.';
        _Cant: Decimal;
        _CantAux: Decimal;
        _TempLineasID: Record "Temp SQL" temporary;
        _idioma: Text[2];
        _TempLinEnvio: Record "Warehouse Shipment Line" temporary;
        _cabVenta: Record "Sales Header";
        _WarehouseReq: Record "Warehouse Request";
        _InfoCompany: Record "Company Information";
        _TempPostedLines: Record "Posted Whse. Shipment Line";
        _AuxShipmentLine: Record "Warehouse Shipment Line";
    begin
        // Punto 9 Documento de Envío - Albarán Pedido de Venta
        _idioma := '5';
        _TempEnvio.RESET;
        _TempEnvio.DELETEALL;
        _TempLineas.RESET;
        _TempLineas.DELETEALL;
        _TempLineasID.RESET;
        _TempLineasID.DELETEALL;
        _TempLotes.RESET;
        _TempLotes.DELETEALL;
        _InfoCompany.GET;
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'StartsWith(TipoDocumento ,''20'') and FechaProcesoEnlace eq null and (Resultado eq null OR Resultado eq '''') ' +
        //                            'CodigoAlmacenERP eq ''' + FiltroAlmacen + '''' +
                            ' and IdEmpresaERP eq ''' + CompanyName + '''');
        HttpCall(SGACallType::"Albaran pedido venta", SGAJsonObject);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for i := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, i);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('IdAlmacenERP', ValueText);
            _Almacen := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('TipoDocumento', ValueText);
            _Tipo := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroDocumento', ValueText);
            _NoDoc := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroEntregaAlmacen', ValueText);
            _NoEntAlm := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroLinea', ValueText);
            _NumLineaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CodigoArticulo', ValueText);
            _CodArticulo := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CantidadServidaUMB', ValueText);
            _CantidadTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroLote', ValueText);
            _NumeroLote := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('FechaAltaEnlace', ValueText);
            _FechaAltaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('ROWID', ValueText);
            _IDBigTxt := ValueText;
            EVALUATE(_IdBig, _IDBigTxt);
            _Ok := EVALUATE(_FechaAltaDateTime, _FechaAltaTxt);
            EVALUATE(_Numlinea, _NumLineaTxt);

            //>> BBT 28/08/2025. La cantidad debe ser entera (sin decimales)
            IF _idioma <> '0' THEN
                EVALUATE(_CantidadDec, _CantidadTxt)
            ELSE
                ConverTextoADecimal(_CantidadTxt, _CantidadDec);

            _Cantidad := ConvertDecimalAEntero(_CantidadDec);
            //<<

            _TempLineasID.INIT;
            _TempLineasID.ID := _IdBig;
            _TempLineasID.Tipo := _Tipo;
            _TempLineasID."No. Documento" := _NoDoc;
            _TempLineasID.INSERT;
            _TempEnvio.INIT;
            _TempEnvio."Item No." := _NoDoc;
            IF NOT _TempEnvio.FIND THEN BEGIN
                _TempEnvio."Delivery Number" := _NoEntAlm;
                _TempEnvio.INSERT;
            END;
            _TempLineas.INIT;
            _TempLineas."Item No." := _NoDoc;
            _TempLineas."Variant Code" := _Tipo;
            _TempLineas."Dimension Entry No." := _Numlinea;
            _TempLineas."Bin Code" := _CodArticulo;
            IF NOT _TempLineas.FIND THEN _TempLineas.INSERT;
            _TempLineas.Quantity += _Cantidad;
            _TempLineas."Delivery Number" := _NoEntAlm;
            _TempLineas.MODIFY;
            IF _NumeroLote <> '' THEN BEGIN
                _TempLotes.INIT;
                _TempLotes."Item No." := _NoDoc;
                _TempLotes."Variant Code" := _Tipo;
                _TempLotes."Bin Code" := _CodArticulo;
                //_TempLotes."Dimension Entry No."  := _Numlinea;
                _TempLotes."Serial No." := _NumeroLote;
                IF NOT _TempLotes.FIND THEN _TempLotes.INSERT;
                _TempLotes.Quantity := _Cantidad;
                _TempLotes.MODIFY;
            END;
        end;
        // >> BBT 23/10/2024 
        // Comprobamos que la cantidad que el TWO informa para enviar no sea mayor que la que hay en el DEA.
        // En el caso de segundos envios parciales puede darse el caso de discrepancias
        _TempLineas.RESET;
        _AuxShipmentLine.RESET;
        if _TempLineas.FINDSET then begin
            repeat
                _CantAux := 0;
                _AuxShipmentLine.SETRANGE("No.", _TempLineas."Item No.");
                _AuxShipmentLine.SETRANGE("Item No.", _TempLineas."Bin Code");
                if _AuxShipmentLine.FINDSET then begin
                    repeat
                        _CantAux += _AuxShipmentLine."Qty. (Base)";
                    until _AuxShipmentLine.NEXT = 0;

                    if _TempLineas.Quantity > _CantAux then begin
                        _TempLineas.Quantity := _CantAux;
                        _TempLineas.MODIFY
                    end;
                end
                //>> BBT 25/11/2024 Puede ser que en un envio parcial anterior alguna de las lineas que llegan del TWO
                //                  ya este totalmente enviada y por lo tanto ya no este en el DEA
                else begin
                    repeat
                        _CantAux := 0;
                        _TempPostedLines.SETRANGE("Whse. Shipment No.", _TempLineas."Item No.");
                        _TempPostedLines.SETRANGE("Item No.", _TempLineas."Bin Code");
                        if _TempPostedLines.FINDSET then begin
                            repeat
                                _CantAux += _TempPostedLines."Qty. (Base)";
                            until _TempPostedLines.NEXT = 0;

                            if _TempLineas.Quantity <= _CantAux then begin
                                _TempLineas.Quantity := 0;
                                _TempLineas.MODIFY;
                            end;
                        end;
                    until _TempLineas.NEXT = 0;
                end;
            //<< BBT 25/11/2024
            until _TempLineas.NEXT = 0;
        end;
        //<< BBT 23/10/2024

        // Actualizar pedido a recibir
        // Registrar
        _TempEnvio.RESET;
        _TempLineas.RESET;
        _TempLotes.RESET;
        IF _TempEnvio.FINDSET THEN
            REPEAT
                _TextoError := '';
                _TempComentarioLinea.RESET;
                _TempComentarioLinea.DELETEALL;
                _TempComentarioLinea2.RESET;
                _TempComentarioLinea2.DELETEALL;
                IF NOT _CabEnvio.GET(_TempEnvio."Item No.") THEN _TextoError := Error01;
                IF _TextoError = '' THEN BEGIN
                    _TempLinEnvio.RESET;
                    _TempLinEnvio.DELETEALL;
                    _LinenvioTemp.RESET;
                    _LinenvioTemp.DELETEALL;
                    _LinEnvio.SETRANGE("No.", _CabEnvio."No.");
                    IF _LinEnvio.FINDSET THEN
                        REPEAT
                            _TempLinEnvio.INIT;
                            _TempLinEnvio := _LinEnvio;
                            _TempLinEnvio.INSERT;
                            IF (_LinEnvio."Source Type" = 37) AND (_LinEnvio."Source Subtype" = 1) THEN
                                IF _cabVenta.GET(_LinEnvio."Source Subtype", _LinEnvio."Source No.") THEN BEGIN
                                    _cabVenta."Shipping No." := '';
                                    IF _cabVenta.Status <> _cabVenta.Status::Released THEN BEGIN
                                        _cabVenta.Status := _cabVenta.Status::Released;
                                        IF _WarehouseReq.GET(_WarehouseReq.Type::Outbound, _LinEnvio."Location Code", _LinEnvio."Source Type", _LinEnvio."Source Subtype", _LinEnvio."Source No.") THEN
                                            IF _WarehouseReq."Document Status" <> _WarehouseReq."Document Status"::Released THEN BEGIN
                                                _WarehouseReq."Document Status" := _WarehouseReq."Document Status"::Released;
                                                _WarehouseReq.MODIFY;
                                            END;
                                    END;
                                    _cabVenta.MODIFY;
                                END;
                        UNTIL _LinEnvio.NEXT = 0;
                    IF _LinEnvio.FINDSET(TRUE) THEN
                        REPEAT
                            _LinenvioTemp.INIT;
                            _LinenvioTemp := _LinEnvio;
                            _LinenvioTemp.INSERT;
                            IF ValidarCantEnviarBase(_LinenvioTemp, 0) THEN BEGIN
                                _LinenvioTemp.MODIFY;
                                _ComentarioLinea.SETRANGE("Document Type", _ComentarioLinea."Document Type"::Ship);
                                _ComentarioLinea.SETRANGE("No.", _LinEnvio."No.");
                                _ComentarioLinea.SETRANGE("Document Line No.", _LinEnvio."Line No.");
                                IF _ComentarioLinea.FINDSET THEN
                                    REPEAT
                                        _TempComentarioLinea := _ComentarioLinea;
                                        _TempComentarioLinea.INSERT;
                                    UNTIL _ComentarioLinea.NEXT = 0;
                            END
                            ELSE
                                _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250);
                        UNTIL (_LinEnvio.NEXT = 0) OR (_TextoError <> '');
                    IF _TextoError = '' THEN BEGIN
                        _TempLineas.SETRANGE("Variant Code", '200', '209');
                        _TempLineas.SETRANGE("Item No.", _CabEnvio."No.");
                        IF _TempLineas.FINDSET THEN
                            REPEAT // Cambiar para agrupacion
                                _LinenvioTemp.SETRANGE("No.", _TempLineas."Item No.");
                                _LinenvioTemp.SETRANGE("Item No.", _TempLineas."Bin Code");
                                _LinenvioTemp.SETFILTER("Qty. Outstanding (Base)", '<>0');
                                IF _LinenvioTemp.FINDSET(TRUE) THEN
                                    REPEAT
                                        IF _LinenvioTemp."Qty. Outstanding (Base)" >= _TempLineas.Quantity THEN BEGIN
                                            _Cant := _TempLineas.Quantity;
                                            IF ValidarCantEnviarBase(_LinenvioTemp, _LinenvioTemp."Qty. to Ship (Base)" + _TempLineas.Quantity) THEN BEGIN
                                                _TempLineas.Quantity := 0;
                                                _TempLineas.MODIFY;
                                                _LinenvioTemp.VALIDATE("Qty. SGA (Base)", _LinenvioTemp."Qty. SGA (Base)" + _LinenvioTemp."Qty. to Ship (Base)");
                                                _LinenvioTemp."Warehouse delivery number" := _TempLineas."Delivery Number";
                                                _LinenvioTemp.MODIFY;
                                                ComentariosLoteEnvios(_TempLotes, _TempComentarioLinea, _Cant, _LinenvioTemp);
                                                // Meter comentarios con lotes hasta _Cant = 0
                                            END
                                            ELSE
                                                _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250);
                                        END
                                        ELSE IF ValidarCantEnviarBase(_LinenvioTemp, _LinenvioTemp."Qty. Outstanding (Base)") THEN BEGIN
                                            _Cant := _LinenvioTemp."Qty. Outstanding (Base)";
                                            _TempLineas.Quantity -= _LinenvioTemp."Qty. Outstanding (Base)";
                                            _LinenvioTemp.VALIDATE("Qty. SGA (Base)", _LinenvioTemp."Qty. SGA (Base)" + _LinenvioTemp."Qty. to Ship (Base)");
                                            _TempLineas.MODIFY;
                                            _LinenvioTemp."Warehouse delivery number" := _TempLineas."Delivery Number";
                                            _LinenvioTemp.MODIFY;
                                            ComentariosLoteEnvios(_TempLotes, _TempComentarioLinea, _Cant, _LinenvioTemp);
                                            // Meter comentarios con lotes hasta _Cant = 0
                                        END
                                        ELSE
                                            _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250);
                                    UNTIL (_LinenvioTemp.NEXT = 0) OR (_TempLineas.Quantity = 0);
                                IF _TempLineas.Quantity > 0 THEN _TextoError := Error03;
                            UNTIL (_TextoError <> '') OR (_TempLineas.NEXT = 0);
                    END;
                    IF _TextoError = '' THEN BEGIN
                        _LinenvioTemp.RESET;
                        IF _LinenvioTemp.FINDSET THEN
                            REPEAT
                                _LinEnvio := _LinenvioTemp;
                                _LinEnvio.MODIFY;
                            UNTIL _LinenvioTemp.NEXT = 0;
                        _TempComentarioLinea.RESET;
                        _TempComentarioLinea2.RESET;
                        _TempComentarioLinea2.DELETEALL;
                        IF _TempComentarioLinea.FINDSET THEN
                            REPEAT
                                _ComentarioLinea := _TempComentarioLinea;
                                IF _ComentarioLinea.INSERT THEN BEGIN
                                    _TempComentarioLinea2 := _ComentarioLinea;
                                    _TempComentarioLinea2.INSERT;
                                END;
                            UNTIL _TempComentarioLinea.NEXT = 0;
                        IF NOT RegistrarEnvio(_LinEnvio) THEN BEGIN
                            _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250);
                            _TempComentarioLinea2.RESET;
                            IF _TempComentarioLinea2.FINDSET THEN BEGIN
                                _ComentarioLinea := _TempComentarioLinea2;
                                IF _ComentarioLinea.FIND THEN _ComentarioLinea.DELETE;
                            END;
                            _TempLinEnvio.RESET;
                            _LinEnvio.RESET;
                            CLEAR(_LinEnvio);
                            IF _TempLinEnvio.FINDSET THEN
                                REPEAT
                                    _LinEnvio.INIT;
                                    IF _LinEnvio.GET(_TempLinEnvio."No.", _TempLinEnvio."Line No.") THEN BEGIN
                                        _LinEnvio.TRANSFERFIELDS(_TempLinEnvio, FALSE);
                                        _LinEnvio.MODIFY;
                                    END;
                                UNTIL _TempLinEnvio.NEXT = 0;
                        END
                        ELSE BEGIN
                            IF _CabEnvio.FIND THEN BEGIN
                                _CabEnvio."Leido SGA" := CURRENTDATETIME;
                                _CabEnvio.MODIFY;
                            END;
                        END;
                    END;
                END;
                IF _TextoError = '' THEN _TextoError := 'CORRECTO';
                ReemplazarCaracter(_TextoError, '''', '');
                _TempLineasID.RESET;
                _TempLineasID.SETRANGE(Tipo, '200', '209');
                _TempLineasID.SETRANGE("No. Documento", _TempEnvio."Item No.");
                IF _TempLineasID.FINDSET THEN
                    REPEAT
                        Clear(SGAJsonObject);
                        SGAJsonObject.Add('FechaProcesoEnlace', GetFechaTrabajo());
                        SGAJsonObject.Add('Resultado', _TextoError);
                        SGAJsonObject.Add('RowId', FORMAT(_TempLineasID.ID));
                        HttpCall(SGACallType::"Actualizar documento", SGAJsonObject);
                    UNTIL _TempLineasID.NEXT = 0;
                _TextoError := '';
            UNTIL _TempEnvio.NEXT = 0;
    end;
    /**/
    procedure FechaExpedicion();
    var
        LinEnvioReg: Record "Posted Whse. Shipment Line";
        CabAlbVenta: Record "Sales Shipment Header";
        LinAlbVenta: Record "Sales Shipment Line";
        _Almacen: Code[10];
        _NoEnvio: Code[20];
        _FechaExpedicionTXT: Text[25];
        _FechaExpedicion: DateTime;
        _OK: Boolean;
        _TextoError: Text[255];
        Error01: Label 'Fecha expedición no valida.';
        _LineasProcess: Record "Temp SQL" temporary;
        Error02: Label 'El albarán no existe.';
        _IDBig: BigInteger;
        _IDBigTxt: Text;
        _FechaTrabajo: DateTime;
        _InfoCompany: Record "Company Information";
    begin
        // Punto 10 Documento de Envío - Fecha Expedición
        // Problema multiempresa
        _InfoCompany.GET;
        _LineasProcess.RESET;
        _LineasProcess.DELETEALL;
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'FechaProcesoEnlace eq null and (Resultado eq null OR Resultado eq '''') and IdEmpresaERP eq ''' + CompanyName + '''');
        HttpCall(SGACallType::"Leer entregas expedidas", SGAJsonObject);
        //Read Json
        LinEnvioReg.SETCURRENTKEY("Whse. Shipment No.");
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for i := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, i);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('IdAlmacenERP', ValueText);
            _Almacen := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroEntregaAlmacen', ValueText);
            _NoEnvio := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('FechaExpedicionEntrega', ValueText);
            _FechaExpedicionTXT := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('ROWID', ValueText);
            _IDBigTxt := ValueText;
            _TextoError := '';
            EVALUATE(_IDBig, _IDBigTxt);
            _OK := EVALUATE(_FechaExpedicion, _FechaExpedicionTXT);
            IF NOT _OK THEN _TextoError := Error01;
            IF _TextoError = '' THEN BEGIN
                LinEnvioReg.SETRANGE("Whse. Shipment No.", _NoEnvio);
                LinEnvioReg.SETRANGE("Posted Source Document", LinEnvioReg."Posted Source Document"::"Posted Shipment");
                IF LinEnvioReg.FINDFIRST THEN BEGIN
                    LinAlbVenta.SETRANGE("Document No.", LinEnvioReg."Posted Source No.");
                    IF LinAlbVenta.FINDSET(TRUE) THEN BEGIN
                        REPEAT
                            LinAlbVenta."Expedition Date SGA" := _FechaExpedicion;
                            LinAlbVenta.MODIFY;
                        UNTIL LinAlbVenta.NEXT = 0;
                    END
                    ELSE
                        _TextoError := Error02;
                END;
            END;
            IF _TextoError = '' THEN _TextoError := 'CORRECTO';
            _LineasProcess.ID := _IDBig;
            ReemplazarCaracter(_TextoError, '''', '');
            _LineasProcess.Error := _TextoError;
            _LineasProcess.INSERT;
        end;
        _LineasProcess.RESET;
        IF _LineasProcess.FINDSET THEN
            REPEAT
                Clear(SGAJsonObject);
                SGAJsonObject.Add('FechaProcesoEnlace', GetFechaTrabajo());
                SGAJsonObject.Add('Resultado', _LineasProcess.Error);
                SGAJsonObject.Add('RowId', FORMAT(_LineasProcess.ID));
                HttpCall(SGACallType::"Actualizar entregas expedidas", SGAJsonObject);
            UNTIL _LineasProcess.NEXT = 0;
    end;

    procedure GestionDevolucionVenta(_NumDoc: Code[20]);
    var
        _WarehouseSetup: Record "Warehouse Setup";
        _FechaTrabajoDT: DateTime;
        _CabVenta: Record "Sales Header";
        _LinVenta: Record "Sales Line";
        _Procesarlinea: Boolean;
        _Producto: Record Item;
        _Pais: Record "Country/Region";
        _FechaServicio: DateTime;
        _FechaServicioTxt: Text[50];
        _Name: Text[100];
        _Address: Text[100];
        _Address2: Text[100];
        _City: Text[50];
        _County: Text[50];
        _InfoCompany: Record "Company Information";
        _Location: Record Location;
    begin
        // Punto 11 Devolucón de venta
        _WarehouseSetup.GET;
        _InfoCompany.GET;
        _CabVenta.GET(_CabVenta."Document Type"::"Return Order", _NumDoc);
        _CabVenta.TESTFIELD("Document Type");
        _CabVenta.TESTFIELD("Sell-to Customer No.");
        _CabVenta.TESTFIELD("Bill-to Customer No.");
        _CabVenta.TESTFIELD("Posting Date");
        _CabVenta.TESTFIELD("Document Date");
        _CabVenta.TESTFIELD("Payment Method Code");
        _CabVenta.TESTFIELD("Payment Terms Code");
        _LinVenta.SETRANGE("Document Type", _CabVenta."Document Type");
        _LinVenta.SETRANGE("Document No.", _CabVenta."No.");
        _LinVenta.SETRANGE(Type, _LinVenta.Type::Item);
        IF _LinVenta.FINDSET THEN
            REPEAT
                IF _LinVenta.Type = _LinVenta.Type::Item THEN BEGIN
                    IF _LinVenta."Location Code" = '' THEN ERROR('Exite una línea sin almacén.');
                    IF NOT _Location.GET(_LinVenta."Location Code") THEN ERROR('El almacén %1 no existe', _LinVenta."Location Code");
                    IF NOT _Location."Allows return SGA" THEN ERROR('EL almacén %1 no permite devoluciones en SGA.', _LinVenta."Location Code");
                END;
            UNTIL _LinVenta.NEXT = 0;
        IF _LinVenta.FINDSET THEN
            REPEAT
                _Procesarlinea := TRUE;
                IF _LinVenta.Type = _LinVenta.Type::Item THEN BEGIN
                    _Producto.GET(_LinVenta."No.");
                    _Procesarlinea := NOT _Producto."No SGA management";
                END;
                IF _Procesarlinea THEN BEGIN
                    IF NOT _Pais.GET(_CabVenta."Sell-to Country/Region Code") THEN CLEAR(_Pais);
                    IF _CabVenta."Requested Delivery Date" = 0D THEN
                        _FechaServicioTxt := 'NULL'
                    ELSE BEGIN
                        _FechaServicio := CREATEDATETIME(_CabVenta."Requested Delivery Date", 0T);
                    END;
                    _Location.GET(_LinVenta."Location Code");
                    _Name := _CabVenta."Sell-to Customer Name";
                    _Address := _CabVenta."Sell-to Address";
                    _Address2 := _CabVenta."Sell-to Address 2";
                    _City := _CabVenta."Sell-to City";
                    _County := _CabVenta."Sell-to County";
                    ReemplazarCaracter(_Name, '''', '');
                    ReemplazarCaracter(_Address, '''', '');
                    ReemplazarCaracter(_Address2, '''', '');
                    ReemplazarCaracter(_City, '''', '');
                    ReemplazarCaracter(_County, '''', '');
                    Clear(SGAJsonObject);
                    SGAJsonObject.Add('CodigoAlmacenWMS', _Location."SGA Whse Code");
                    SGAJsonObject.Add('IdAlmacenERP', _LinVenta."Location Code");
                    SGAJsonObject.Add('CodigoAlmacenOrigenWMS', _Location."SGA Whse Code");
                    SGAJsonObject.Add('IdAlmacenOrigenERP', _LinVenta."Location Code");
                    SGAJsonObject.Add('IdEmpresaERP', COMPANYNAME);
                    SGAJsonObject.Add('TipoDocumento', '370');
                    SGAJsonObject.Add('NumeroDocumento', _CabVenta."No.");
                    SGAJsonObject.Add('CodigoOrdenante', _CabVenta."Sell-to Customer No.");
                    SGAJsonObject.Add('NombreComercial', DELCHR(_Name, '=', ''''''''));
                    SGAJsonObject.Add('Direccion', DELCHR(_Address + ' ' + _Address2, '=', ''''''''));
                    SGAJsonObject.Add('CP', _CabVenta."Sell-to Post Code");
                    SGAJsonObject.Add('Poblacion', DELCHR(_City, '=', ''''''''));
                    SGAJsonObject.Add('Provincia', _County);
                    SGAJsonObject.Add('CodigoPaisISO', _CabVenta."Sell-to Country/Region Code");
                    SGAJsonObject.Add('Pais', _Pais.Name);
                    SGAJsonObject.Add('ServicioDocumento', '{C,P}');
                    SGAJsonObject.Add('FechaAlta', GetFechaTrabajo);
                    SGAJsonObject.Add('FechaServicioPrevista', GetFechaTrabajo());
                    SGAJsonObject.Add('NumeroLinea', FORMAT(_LinVenta."Line No."));
                    SGAJsonObject.Add('CodigoArticulo', _LinVenta."No.");
                    SGAJsonObject.Add('CantidadPedidaUMB', _LinVenta."Return Qty. to Receive (Base)");
                    SGAJsonObject.Add('SituacionStock', '');
                    SGAJsonObject.Add('FechaAltaEnlace', GetFechaTrabajo);
                    HttpCall(SGACallType::"Insertar devolucion venta", SGAJsonObject);
                END;
            UNTIL _LinVenta.NEXT = 0;
        _CabVenta.ModificadoSGA := FALSE;
        _CabVenta."Status SGA" := _CabVenta."Status SGA"::"Enviado SGA";
        _CabVenta."Grabado SGA" := CURRENTDATETIME;
        _CabVenta.MODIFY;
    end;

    procedure RecepDevVentas();
    var
        _TempLineas: Record "Inventory Buffer" temporary;
        _TempLotes: Record "Inventory Buffer" temporary;
        _Almacen: Code[10];
        _TipoDocumento: Code[3];
        _NumDocumentoTipo: Code[25];
        _NumLineaTxt: Text[25];
        _CodArticulo: Code[20];
        _CantidadRecibirTxT: Text[25];
        _NumLote: Text[25];
        _FechaAltaTxt: Text[25];
        _TempPedidos: Record "Inventory Buffer" temporary;
        _Numlinea: Integer;
        _CantidadRecibirDec: Decimal;
        _CantidadRecibir: Integer;
        _Tipo: Code[3];
        _NumDocumento: Code[20];
        _LinDevolVenta: Record "Sales Line";
        _CabDevolVenta: Record "Sales Header";
        Error01: Label 'No existe la devolución de ventas.';
        Error02: Label 'Línea no existe.';
        Error03: Label 'Cantidad pendiente menor que cantidad a recibir.';
        Ok: Boolean;
        _ComentarioLinea: Record "Sales Comment Line";
        _TempComentarioLinea: Record "Sales Comment Line" temporary;
        _NumLineaComentario: Integer;
        _TempLineasID: Record "Temp SQL" temporary;
        _IDBigTxt: Text;
        _IDBig: BigInteger;
        _TextoError: Text[250];
        _idioma: Text[2];
        _TempCabDevVenta: Record "Sales Header" temporary;
        _TempLinDevVenta: Record "Sales Line" temporary;
        _InfoCompany: Record "Company Information";
    begin
        // Punto 12 Recepción devolución venta
        _idioma := '5';
        _TempLineas.RESET;
        _TempLineas.DELETEALL;
        _TempLotes.RESET;
        _TempLotes.DELETEALL;
        _TempLineasID.RESET;
        _TempLineasID.DELETEALL;
        _TempPedidos.RESET;
        _TempPedidos.DELETEALL;
        _InfoCompany.GET;
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'TipoDocumento eq ''370'' and IdEmpresaERP eq ''' + CompanyName + ''' and FechaProcesoEnlace eq null and (Resultado eq null OR Resultado eq '''')'); //Cambiar BB Trends por COMPANYNAME
        HttpCall(SGACallType::"Leer recepcion devolucion venta", SGAJsonObject);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for i := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, i);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('IdAlmacenERP', ValueText);
            _Almacen := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('TipoDocumento', ValueText);
            _TipoDocumento := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroDocumento', ValueText);
            _NumDocumentoTipo := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroLinea', ValueText);
            _NumLineaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CodigoArticulo', ValueText);
            _CodArticulo := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CantidadPedidaUMB', ValueText);
            _CantidadRecibirTxT := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroLote', ValueText);
            _NumLote := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('FechaAltaEnlace', ValueText);
            _FechaAltaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('FechaAltaEnlace', ValueText);
            _FechaAltaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('ROWID', ValueText);
            _IDBigTxt := ValueText;
            EVALUATE(_IDBig, _IDBigTxt);
            EVALUATE(_Numlinea, _NumLineaTxt);

            //>> BBT 28/08/2025. La cantidad debe ser entera (sin decimales)
            IF _idioma <> '0' THEN
                EVALUATE(_CantidadRecibirDec, _CantidadRecibirTxT)
            ELSE
                ConverTextoADecimal(_CantidadRecibirTxT, _CantidadRecibirDec);

            _CantidadRecibir := ConvertDecimalAEntero(_CantidadRecibirDec);
            //<<

            //ExtraerNumDocTipo(_NumDocumentoTipo,_Tipo,_NumDocumento);
            _NumDocumento := _NumDocumentoTipo;
            _Tipo := _TipoDocumento;
            _TempLineasID.INIT;
            _TempLineasID.ID := _IDBig;
            _TempLineasID.Tipo := _Tipo;
            _TempLineasID."No. Documento" := _NumDocumento;
            _TempLineasID.INSERT;
            _TempPedidos.INIT;
            _TempPedidos."Item No." := _NumDocumento;
            IF NOT _TempPedidos.FIND THEN _TempPedidos.INSERT;
            _TempLineas.INIT;
            _TempLineas."Item No." := _NumDocumento;
            _TempLineas."Variant Code" := _Tipo;
            _TempLineas."Dimension Entry No." := _Numlinea;
            IF NOT _TempLineas.FIND THEN _TempLineas.INSERT;
            _TempLineas.Quantity += _CantidadRecibir;
            _TempLineas.MODIFY;
            IF _NumLote <> '' THEN BEGIN
                _TempLotes.INIT;
                _TempLotes."Item No." := _NumDocumento;
                _TempLotes."Variant Code" := _Tipo;
                _TempLotes."Dimension Entry No." := _Numlinea;
                _TempLotes."Serial No." := _NumLote;
                IF NOT _TempLotes.FIND THEN _TempLotes.INSERT;
                _TempLotes.Quantity := _CantidadRecibir;
                _TempLotes.MODIFY;
            END;
        end;
        // Actualizar pedido a recibir
        // Registrar
        _TempPedidos.RESET;
        _TempLineas.RESET;
        _TempLotes.RESET;
        IF _TempPedidos.FINDSET THEN
            REPEAT
                _TempCabDevVenta.RESET;
                _TempLinDevVenta.RESET;
                _TempCabDevVenta.DELETEALL;
                _TempLinDevVenta.DELETEALL;
                _TextoError := '';
                _TempComentarioLinea.RESET;
                _TempComentarioLinea.DELETEALL;
                IF NOT _CabDevolVenta.GET(_CabDevolVenta."Document Type"::"Return Order", _TempPedidos."Item No.") THEN _TextoError := Error01;
                IF _TextoError = '' THEN BEGIN
                    _TempCabDevVenta.INIT;
                    _TempCabDevVenta := _CabDevolVenta;
                    _TempCabDevVenta.INSERT;
                    _LinDevolVenta.SETRANGE("Document Type", _LinDevolVenta."Document Type"::"Return Order");
                    _LinDevolVenta.SETRANGE("Document No.", _TempPedidos."Item No.");
                    IF _LinDevolVenta.FINDSET(TRUE) THEN
                        REPEAT
                            _TempLinDevVenta.INIT;
                            _TempLinDevVenta := _LinDevolVenta;
                            _TempLinDevVenta.INSERT;
                            IF NOT ValidarCantDevVentaBase(_LinDevolVenta, 0) THEN
                                _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250)
                            ELSE
                                _LinDevolVenta.MODIFY;
                        UNTIL (_LinDevolVenta.NEXT = 0) OR (_TextoError <> '');
                    _LinDevolVenta.RESET;
                    IF _TextoError = '' THEN BEGIN
                        _ComentarioLinea.RESET;
                        _ComentarioLinea.SETRANGE("Document Type", _CabDevolVenta."Document Type");
                        _ComentarioLinea.SETRANGE("No.", _CabDevolVenta."No.");
                        IF _ComentarioLinea.FINDLAST THEN
                            _NumLineaComentario := _ComentarioLinea."Line No."
                        ELSE
                            _NumLineaComentario := 0;
                        _TempLineas.SETRANGE("Variant Code", '370');
                        _TempLineas.SETRANGE("Item No.", _CabDevolVenta."No.");
                        IF _TempLineas.FINDSET THEN
                            REPEAT
                                IF NOT _LinDevolVenta.GET(_CabDevolVenta."Document Type", _CabDevolVenta."No.", _TempLineas."Dimension Entry No.") THEN
                                    _TextoError := Error02
                                ELSE IF _LinDevolVenta."Outstanding Qty. (Base)" < _TempLineas.Quantity THEN _TextoError := Error03;
                                IF _TextoError = '' THEN IF NOT ValidarCantDevVentaBase(_LinDevolVenta, _TempLineas.Quantity) THEN _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250);
                                IF _TextoError = '' THEN;
                                //Se meteran en comentario de linea
                                BEGIN
                                    _TempLotes.SETRANGE("Item No.", _CabDevolVenta."No.");
                                    _TempLotes.SETRANGE("Variant Code", '370');
                                    _TempLotes.SETRANGE("Dimension Entry No.", _LinDevolVenta."Line No.");
                                    IF _TempLotes.FINDSET THEN
                                        REPEAT
                                            _NumLineaComentario += 10000;
                                            _ComentarioLinea.INIT;
                                            _ComentarioLinea."Document Type" := _CabDevolVenta."Document Type";
                                            _ComentarioLinea."No." := _CabDevolVenta."No.";
                                            _ComentarioLinea."Document Line No." := _LinDevolVenta."Line No.";
                                            _ComentarioLinea."Line No." := _NumLineaComentario;
                                            _ComentarioLinea.Comment := 'Lote: ' + _TempLotes."Serial No." + ' / Ctd.: ' + FORMAT(_TempLotes.Quantity, 0);
                                            _ComentarioLinea.INSERT;
                                            _TempComentarioLinea := _ComentarioLinea;
                                            _TempComentarioLinea.INSERT;
                                        UNTIL _TempLotes.NEXT = 0;
                                END;
                            UNTIL _TempLineas.NEXT = 0;
                    END;
                    IF _TextoError = '' THEN
                        IF NOT RegistrarDevVenta(_CabDevolVenta) THEN BEGIN
                            _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250);
                            _TempComentarioLinea.RESET;
                            IF _TempComentarioLinea.FINDSET THEN BEGIN
                                _ComentarioLinea := _TempComentarioLinea;
                                IF _ComentarioLinea.FIND THEN _ComentarioLinea.DELETE;
                            END;
                            _TempCabDevVenta.RESET;
                            _CabDevolVenta.RESET;
                            CLEAR(_CabDevolVenta);
                            IF _TempCabDevVenta.FINDFIRST THEN BEGIN
                                _CabDevolVenta.INIT;
                                IF _CabDevolVenta.GET(_TempCabDevVenta."Document Type", _TempCabDevVenta."No.") THEN BEGIN
                                    _CabDevolVenta.TRANSFERFIELDS(_TempCabDevVenta, FALSE);
                                    _CabDevolVenta.MODIFY;
                                END;
                            END;
                            _TempLinDevVenta.RESET;
                            _LinDevolVenta.RESET;
                            CLEAR(_LinDevolVenta);
                            IF _TempLinDevVenta.FINDSET THEN
                                REPEAT
                                    _LinDevolVenta.INIT;
                                    IF _LinDevolVenta.GET(_TempLinDevVenta."Document Type", _TempLinDevVenta."Document No.", _TempLinDevVenta."Line No.") THEN BEGIN
                                        _LinDevolVenta.TRANSFERFIELDS(_TempLinDevVenta, FALSE);
                                        _LinDevolVenta.MODIFY;
                                    END;
                                UNTIL _TempLinDevVenta.NEXT = 0;
                        END
                        ELSE BEGIN
                            _CabDevolVenta."Leido SGA" := CURRENTDATETIME;
                            IF _CabDevolVenta.MODIFY THEN;
                        END;
                END;
                IF _TextoError = '' THEN _TextoError := 'CORRECTO';
                ReemplazarCaracter(_TextoError, '''', '');
                _TempLineasID.RESET;
                _TempLineasID.SETRANGE(Tipo, '370');
                _TempLineasID.SETRANGE("No. Documento", _TempPedidos."Item No.");
                IF _TempLineasID.FINDSET THEN
                    REPEAT
                        Clear(SGAJsonObject);
                        SGAJsonObject.Add('FechaProcesoEnlace', GetFechaTrabajo());
                        SGAJsonObject.Add('Resultado', _TextoError);
                        SGAJsonObject.Add('RowId', FORMAT(_TempLineasID.ID));
                        HttpCall(SGACallType::"Actualizar documento", SGAJsonObject);
                    UNTIL _TempLineasID.NEXT = 0;
            UNTIL _TempPedidos.NEXT = 0;
    end;

    procedure "PedidoTransferencia-->SGA"(_NumDoc: Code[20]; _Direction: Option Ship,Receive,Receive2; var _TempLineasOLD: Record "Transfer Line" temporary; _Borrar: Boolean);
    var
        _Cabtransfer: Record "Transfer Header";
        _AlmEnvioSGA: Boolean;
        _AlmRecepSGA: Boolean;
        _RecAlmacen: Record Location;
        _Lintransfer: Record "Transfer Line";
        _Tipo: Code[3];
        _Cantidad: Decimal;
        _FechaServicio: DateTime;
        _FechaServicioTxt: Text;
        _InfoCompany: Record "Company Information";
        _CodAlmEnvioSGA: Text[10];
        _CodAlmRecepSGA: Text[10];
    begin
        _InfoCompany.GET;
        _Cabtransfer.GET(_NumDoc);
        _RecAlmacen.GET(_Cabtransfer."Transfer-from Code");
        _AlmEnvioSGA := _RecAlmacen.SGA;
        _CodAlmEnvioSGA := _RecAlmacen."SGA Whse Code";
        _RecAlmacen.GET(_Cabtransfer."Transfer-to Code");
        _AlmRecepSGA := _RecAlmacen.SGA;
        _CodAlmRecepSGA := _RecAlmacen."SGA Whse Code";
        _Lintransfer.RESET;
        _Lintransfer.SETRANGE("Document No.", _Cabtransfer."No.");
        _Lintransfer.SETRANGE("Derived From Line No.", 0);
        _Lintransfer.SETFILTER("Item No.", '<>%1', '');
        IF _Lintransfer.FINDSET THEN
            REPEAT
                _TempLineasOLD.GET(_Lintransfer."Document No.", _Lintransfer."Line No.");
                _Tipo := '';
                _Cantidad := 0;
                CASE _Direction OF
                    _Direction::Ship:
                        BEGIN
                            _Tipo := '210';
                            _Cantidad := _TempLineasOLD."Qty. to Ship (Base)";
                        END;
                    _Direction::Receive:
                        BEGIN
                            _Tipo := '310';
                            //_Cantidad := _TempLineasOLD."Qty. to Receive (Base)";
                            //>> 02/07/2023
                            //_Cantidad := _TempLineasOLD."Qty. to Ship (Base)";
                            IF _TempLineasOLD."Qty. to Ship (Base)" > 0 THEN
                                _Cantidad := _TempLineasOLD."Qty. to Ship (Base)"
                            ELSE
                                _Cantidad := _TempLineasOLD."Qty. Shipped (Base)";
                            //<< 02/07/2023
                        END;
                    _Direction::Receive2:
                        BEGIN
                            _Tipo := '310';
                            _Cantidad := _TempLineasOLD."Qty. to Receive (Base)";
                        END;
                END;
                IF _Cabtransfer."Posting Date" = 0D THEN
                    _FechaServicioTxt := 'NULL'
                ELSE BEGIN
                    _FechaServicio := CREATEDATETIME(_Cabtransfer."Posting Date", 0T);
                END;
                Clear(SGAJsonObject);
                SGAJsonObject.Add('CodigoAlmacenWMS', _CodAlmRecepSGA);
                SGAJsonObject.Add('IdAlmacenERP', _Lintransfer."Transfer-to Code");
                SGAJsonObject.Add('CodigoAlmacenOrigenWMS', _CodAlmEnvioSGA);
                SGAJsonObject.Add('IdAlmacenOrigenERP', _Lintransfer."Transfer-from Code");
                SGAJsonObject.Add('IdEmpresaERP', COMPANYNAME);
                SGAJsonObject.Add('TipoDocumento', _Tipo);
                SGAJsonObject.Add('NumeroDocumento', _Cabtransfer."No.");
                SGAJsonObject.Add('FechaAlta', GetFechaTrabajo);
                if _FechaServicioTxt = 'NULL' then
                    SGAJsonObject.Add('FechaServicioPrevista', _FechaServicioTxt)
                else
                    SGAJsonObject.Add('FechaServicioPrevista', _FechaServicio);
                SGAJsonObject.Add('NumeroLinea', FORMAT(_Lintransfer."Line No."));
                SGAJsonObject.Add('CodigoArticulo', _Lintransfer."Item No.");
                SGAJsonObject.Add('CantidadPedidaUMB', _Cantidad);
                SGAJsonObject.Add('FechaAltaEnlace', GetFechaTrabajo);
                HttpCall(SGACallType::"Insertar pedido transferencia", SGAJsonObject);
            UNTIL _Lintransfer.NEXT = 0;
        IF NOT _Borrar THEN BEGIN
            _Cabtransfer."Status SGA" := _Cabtransfer."Status SGA"::"Enviado SGA";
            _Cabtransfer."Grabado SGA" := CURRENTDATETIME;
            _Cabtransfer.MODIFY;
        END;
    end;

    procedure "PedidoTransferencia<--SGA"();
    var
        _TempLineas: Record "Inventory Buffer" temporary;
        _TempPedidos: Record "Inventory Buffer" temporary;
        _Almacen: Code[10];
        _TipoDocumento: Code[3];
        _NumLineaTxt: Text[25];
        _CodArticulo: Code[20];
        _CantidadRecibirTxT: Text[25];
        _NumLote: Text[25];
        _FechaAltaTxt: Text[25];
        _Numlinea: Integer;
        _CantidadRecibirDec: Decimal;
        _CantidadRecibir: Integer;
        _Tipo: Code[3];
        _NumDocumento: Code[20];
        _TextoError: Text[250];
        _TempLineasID: Record "Temp SQL" temporary;
        _IDBigTxt: Text;
        _IDBig: BigInteger;
        _Cabtransfer: Record "Transfer Header";
        _Lintransfer: Record "Transfer Line";
        _idioma: Text[2];
        Text50000: Label 'La línea no existe.';
        _TempLinTransfer: Record "Transfer Line" temporary;
        _ErrorAntes: Boolean;
        _InfoCompany: Record "Company Information";
        _AlmacenOrigen: Code[10];
        _LocationFrom: Record Location;
        _LocationTo: Record Location;
        _Correcto: Boolean;
    begin
        _TempLineasID.RESET;
        _TempLineasID.DELETEALL;
        _TempLineas.RESET;
        _TempLineas.DELETEALL;
        _TempPedidos.RESET;
        _TempPedidos.DELETEALL;
        _TextoError := '';
        _idioma := '5';
        _InfoCompany.GET;
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', '(StartsWith(TipoDocumento ,''31'') or StartsWith(TipoDocumento ,''21''))and FechaProcesoEnlace eq null and (Resultado eq null OR Resultado eq '''') and IdEmpresaERP eq ''' + CompanyName + ''''); //Cambiar BB Trends por COMPANYNAME
        HttpCall(SGACallType::"Leer pedido transferencia", SGAJsonObject);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for i := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, i);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('IdAlmacenERP', ValueText);
            _Almacen := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('IdAlmacenOrigenERP', ValueText);
            _AlmacenOrigen := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('TipoDocumento', ValueText);
            _TipoDocumento := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroDocumento', ValueText);
            _NumDocumento := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroLinea', ValueText);
            _NumLineaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CodigoArticulo', ValueText);
            _CodArticulo := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CantidadServidaUMB', ValueText);
            _CantidadRecibirTxT := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroLote', ValueText);
            _NumLote := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('FechaAltaEnlace', ValueText);
            _FechaAltaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('ROWID', ValueText);
            _IDBigTxt := ValueText;
            EVALUATE(_IDBig, _IDBigTxt);
            EVALUATE(_Numlinea, _NumLineaTxt);

            //>> BBT 28/08/2025. La cantidad debe ser entera (sin decimales)
            IF _idioma <> '0' THEN
                EVALUATE(_CantidadRecibirDec, _CantidadRecibirTxT)
            ELSE
                ConverTextoADecimal(_CantidadRecibirTxT, _CantidadRecibirDec);

            _CantidadRecibir := ConvertDecimalAEntero(_CantidadRecibirDec);
            //<<

            IF _CodArticulo <> '' THEN BEGIN
                _TempLineasID.INIT;
                _TempLineasID.ID := _IDBig;
                _TempLineasID.Tipo := _TipoDocumento;
                _TempLineasID."No. Documento" := _NumDocumento;
                _TempLineasID.INSERT;
                _TempPedidos.INIT;
                _TempPedidos."Bin Code" := _NumDocumento;
                _TempPedidos."Variant Code" := _TipoDocumento;
                IF NOT _TempPedidos.FIND THEN _TempPedidos.INSERT;
                _TempLineas.INIT;
                _TempLineas."Bin Code" := _NumDocumento;
                _TempLineas."Variant Code" := _TipoDocumento;
                _TempLineas."Dimension Entry No." := _Numlinea;
                _TempLineas."Item No." := _CodArticulo;
                IF NOT _TempLineas.FIND THEN _TempLineas.INSERT;
                _TempLineas.Quantity += _CantidadRecibir;
                _TempLineas.MODIFY;
            END;
        end;
        _TempPedidos.RESET;
        _TempPedidos.SETFILTER("Variant Code", '21?');
        IF _TempPedidos.FINDSET THEN BEGIN
            REPEAT
                _ErrorAntes := FALSE;
                _TextoError := '';
                _Lintransfer.RESET;
                _Lintransfer.SETRANGE("Document No.", _TempPedidos."Bin Code");
                _Lintransfer.SETRANGE("Derived From Line No.", 0);
                _Lintransfer.SETFILTER("Item No.", '<>%1', '');
                IF _Lintransfer.FINDSET(TRUE) THEN
                    REPEAT
                        IF NOT ValidarCantEnviarTrans(_Lintransfer, 0) THEN
                            _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250)
                        ELSE
                            _Lintransfer.MODIFY;
                    UNTIL (_Lintransfer.NEXT = 0) OR (_TextoError <> '');
                _Lintransfer.RESET;
                IF _TextoError = '' THEN BEGIN
                    _TempLineas.RESET;
                    _TempLinTransfer.RESET;
                    _TempLinTransfer.DELETEALL;
                    _TempLineas.SETRANGE("Bin Code", _TempPedidos."Bin Code");
                    _TempLineas.SETRANGE("Variant Code", _TempPedidos."Variant Code");
                    IF _TempLineas.FINDSET THEN
                        REPEAT
                            IF _Lintransfer.GET(_TempLineas."Bin Code", _TempLineas."Dimension Entry No.") THEN BEGIN
                                ;
                                _TempLinTransfer.INIT;
                                _TempLinTransfer := _Lintransfer;
                                _TempLinTransfer.INSERT;
                            END
                            ELSE BEGIN
                                _TextoError := Text50000;
                                _ErrorAntes := TRUE;
                            END;
                        UNTIL (_TempLineas.NEXT = 0) OR (_TextoError <> '');
                END;
                IF _TextoError = '' THEN
                    IF _TempLineas.FINDSET THEN
                        REPEAT
                            IF _Lintransfer.GET(_TempLineas."Bin Code", _TempLineas."Dimension Entry No.") THEN BEGIN
                                IF NOT ValidarCantEnviarTrans(_Lintransfer, _TempLineas.Quantity) THEN
                                    _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250)
                                ELSE
                                    _Lintransfer.MODIFY;
                            END
                            ELSE
                                _TextoError := Text50000;
                        UNTIL (_TempLineas.NEXT = 0) OR (_TextoError <> '');
                IF NOT _Cabtransfer.GET(_TempPedidos."Bin Code") THEN _TextoError := 'El pedido de transferencia no existe.';
                IF _TextoError = '' THEN IF NOT RegistrarEnvioTrans(_Cabtransfer) THEN _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250);
                IF _TextoError = '' THEN BEGIN
                    _TextoError := 'CORRECTO';
                END
                ELSE IF NOT _ErrorAntes THEN BEGIN
                    _TempLinTransfer.RESET;
                    _Lintransfer.RESET;
                    CLEAR(_Lintransfer);
                    IF _TempLinTransfer.FINDSET THEN
                        REPEAT
                            _Lintransfer.INIT;
                            IF _Lintransfer.GET(_TempLinTransfer."Document No.", _TempLinTransfer."Line No.") THEN BEGIN
                                _Lintransfer.TRANSFERFIELDS(_TempLinTransfer, FALSE);
                                _Lintransfer.MODIFY;
                            END;
                        UNTIL _TempLinTransfer.NEXT = 0;
                END;
                _TempLineasID.RESET;
                _TempLineasID.SETFILTER(Tipo, '21?');
                _TempLineasID.SETRANGE("No. Documento", _Cabtransfer."No.");
                _TempLineasID.MODIFYALL(Error, _TextoError);
            UNTIL _TempPedidos.NEXT = 0;
            //>> 06/2022. USO DE VARIOS ALMACENES SGA
            // Cuando el almacén de salida es SGA y el de recepción tambien es SGA
            // Se procesa la acción de enviar (210) que viene del SGA --> se crea una
            // transacción de recepción (310) en almacen de recepción con SGA
            //
            _TempPedidos.RESET;
            _TempPedidos.SETFILTER("Variant Code", '21?');
            IF _TempPedidos.FINDSET THEN
                REPEAT
                    _Cabtransfer.RESET;
                    _LocationFrom.RESET;
                    _LocationTo.RESET;
                    _Cabtransfer.GET(_TempPedidos."Bin Code");
                    _LocationFrom.GET(_Cabtransfer."Transfer-from Code");
                    _LocationTo.GET(_Cabtransfer."Transfer-to Code");
                    IF _LocationFrom.SGA AND _LocationTo.SGA THEN BEGIN //Los 2 almacenes son SGA
                        _TempLineasID.RESET;
                        _TempLineasID.SETFILTER(Tipo, '21?');
                        _TempLineasID.SETRANGE("No. Documento", _TempPedidos."Bin Code");
                        _TempLineasID.SETRANGE(Error, 'CORRECTO'); //Solo se procesan las 210 que son CORRECTAS
                        IF _TempLineasID.FINDSET THEN BEGIN
                            _TempLineas.RESET;
                            _TempLineas.SETRANGE("Bin Code", _TempPedidos."Bin Code");
                            _TempLineas.SETRANGE("Variant Code", _TempPedidos."Variant Code");
                            IF _TempLineas.FINDSET THEN begin
                                //  El procedimiento "PedidoTransferencia-->SGA" traspasa todas las lineas de la transferencia.
                                //  No hace falta pasarle linea a linea (NO se usa el REPEAT para leer todas las lineas)
                                //          REPEAT
                                _Lintransfer.SETCURRENTKEY("Document No.", "Line No.");
                                IF _Lintransfer.GET(_TempLineas."Bin Code", _TempLineas."Dimension Entry No.") THEN BEGIN
                                    "PedidoTransferencia-->SGA"(_Cabtransfer."No.", 2, _Lintransfer, TRUE);
                                END;
                                //          UNTIL (_TempLineas.NEXT = 0);
                            end;
                        END;
                    END;
                UNTIL _TempPedidos.NEXT = 0;
            //
            //<< 06/2022. USO DE VARIOS ALMACENES SGA
        END;
        _TempPedidos.RESET;
        _TempPedidos.SETFILTER("Variant Code", '31?');
        IF _TempPedidos.FINDSET THEN
            REPEAT
                _TextoError := '';
                _ErrorAntes := FALSE;
                _Lintransfer.RESET;
                _Lintransfer.SETRANGE("Document No.", _TempPedidos."Bin Code");
                _Lintransfer.SETRANGE("Derived From Line No.", 0);
                _Lintransfer.SETFILTER("Item No.", '<>%1', '');
                IF _Lintransfer.FINDSET(TRUE) THEN
                    REPEAT
                        IF NOT ValidarCantRecepTrans(_Lintransfer, 0) THEN
                            _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250)
                        ELSE
                            _Lintransfer.MODIFY;
                    UNTIL (_Lintransfer.NEXT = 0) OR (_TextoError <> '');
                _Lintransfer.RESET;
                IF _TextoError = '' THEN BEGIN
                    _TempLinTransfer.RESET;
                    _TempLinTransfer.DELETEALL;
                    _TempLineas.RESET;
                    _TempLineas.SETRANGE("Bin Code", _TempPedidos."Bin Code");
                    _TempLineas.SETRANGE("Variant Code", _TempPedidos."Variant Code");
                    IF _TempLineas.FINDSET THEN
                        REPEAT
                            IF _Lintransfer.GET(_TempLineas."Bin Code", _TempLineas."Dimension Entry No.") THEN BEGIN
                                ;
                                _TempLinTransfer.INIT;
                                _TempLinTransfer := _Lintransfer;
                                _TempLinTransfer.INSERT;
                            END
                            ELSE BEGIN
                                _TextoError := Text50000;
                                _ErrorAntes := TRUE;
                            END;
                        UNTIL (_TempLineas.NEXT = 0) OR (_TextoError <> '');
                END;
                IF _TextoError = '' THEN
                    IF _TempLineas.FINDSET THEN
                        REPEAT
                            IF _Lintransfer.GET(_TempLineas."Bin Code", _TempLineas."Dimension Entry No.") THEN
                                IF NOT ValidarCantRecepTrans(_Lintransfer, _TempLineas.Quantity) THEN
                                    _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250)
                                ELSE
                                    _Lintransfer.MODIFY;
                        UNTIL (_TempLineas.NEXT = 0) OR (_TextoError <> '');
                //>> BBT 22/12/2025. Asignamos la fecha actual como la de registro        
                //IF NOT _Cabtransfer.GET(_TempPedidos."Bin Code") THEN _TextoError := 'El pedido de transferencia no existe.';
                IF _Cabtransfer.GET(_TempPedidos."Bin Code") then begin
                    _Cabtransfer."Posting Date" := Today;
                    _Cabtransfer.Modify();
                end
                else
                    _TextoError := 'El pedido de transferencia no existe.';
                //<<
                IF _TextoError = '' THEN
                    IF NOT RegistrarRecepTrans(_Cabtransfer) THEN _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250);
                IF _TextoError = '' THEN
                    _TextoError := 'CORRECTO'
                ELSE IF NOT _ErrorAntes THEN BEGIN
                    _TempLinTransfer.RESET;
                    _Lintransfer.RESET;
                    CLEAR(_Lintransfer);
                    IF _TempLinTransfer.FINDSET THEN
                        REPEAT
                            _Lintransfer.INIT;
                            IF _Lintransfer.GET(_TempLinTransfer."Document No.", _TempLinTransfer."Line No.") THEN BEGIN
                                _Lintransfer.TRANSFERFIELDS(_TempLinTransfer, FALSE);
                                _Lintransfer.MODIFY;
                            END;
                        UNTIL _TempLinTransfer.NEXT = 0;
                END;
                _TempLineasID.RESET;
                _TempLineasID.SETFILTER(Tipo, '31?');
                _TempLineasID.SETRANGE("No. Documento", _Cabtransfer."No.");
                _TempLineasID.MODIFYALL(Error, _TextoError);
            UNTIL _TempPedidos.NEXT = 0;
        _TempLineasID.RESET;
        ReemplazarCaracter(_TextoError, '''', '');
        IF _TempLineasID.FINDSET THEN
            REPEAT
                Clear(SGAJsonObject);
                SGAJsonObject.Add('FechaProcesoEnlace', GetFechaTrabajo());
                SGAJsonObject.Add('Resultado', _TextoError);
                SGAJsonObject.Add('RowId', FORMAT(_TempLineasID.ID));
                HttpCall(SGACallType::"Actualizar documento", SGAJsonObject);
            UNTIL _TempLineasID.NEXT = 0;
    end;

    procedure AjustesStock();
    var
        ////_TempSQL: Record "Temp SQL" temporary;
        _ItemJournalLine: Record "Item Journal Line";
        _WarehouseSetup: Record "Warehouse Setup";
        _TextoError: Text[250];
        _FechaTxt: Text[50];
        _FechaHora: DateTime;
        _Fecha: Date;
        Error1: Label 'Fecha registro incorrecta.';
        _CantidadTxt: Text[25];
        _CantidadDec: Decimal;
        _Cantidad: Integer;
        //Error2: Label 'Cantidad invalida.';
        _CodProducto: Code[20];
        _Almacen: Code[10];
        _IDBig: BigInteger;
        _IDBigTxt: Text;
        _Seccion: Record "Item Journal Batch";
        //_GestionNs: Codeunit NoSeriesManagement;
        _GestionNs: Codeunit "No. Series";
        _NumDoc: Code[20];
        _idioma: Text[2];
        _Filtros: array[2] of Text[30];
        _i: Integer;
        _InfoCompany: Record "Company Information";
        _REcItem: Record Item;
        _Saltar: Boolean;
        _DescripTM: Text[250];
        _MovSGA: Text[250];
    begin
        // Punto 14 movimientos
        _idioma := '5';
        _WarehouseSetup.GET;
        _InfoCompany.GET;
        _Seccion.GET(_WarehouseSetup."Journal Template Name", _WarehouseSetup."Journal Batch Name");
        _Seccion.TESTFIELD("No. Series");

        CLEAR(_GestionNs);
        _Filtros[1] := ' AND CantidadMovimiento gt 0'; //gt es mayor que --> _i = 1 : Primero los movimientos positivos
        _Filtros[2] := ' AND CantidadMovimiento lt 0'; //lt es menor que --> _i = 2 : Segundo los movimientos negativos
        FOR _i := 1 TO 2 DO BEGIN
            _TextoError := '';
            _ItemJournalLine.SETRANGE("Journal Template Name", _WarehouseSetup."Journal Template Name");
            _ItemJournalLine.SETRANGE("Journal Batch Name", _WarehouseSetup."Journal Batch Name");
            _ItemJournalLine.DELETEALL;
            Clear(SGAJsonObject);
            Clear(ResponseTxt);
            SGAJsonObject.Add('filter', 'FechaProcesoEnlace eq null and CodigoArticulo ne '''' and (Resultado eq null OR Resultado eq '''')' + _Filtros[_i]);
            HttpCall(SGACallType::"Leer ajustes stock", SGAJsonObject);
            //Read Json
            Clear(ArrayJSONManagement);
            Clear(ObjectJSONManagement);
            ArrayJSONManagement.InitializeCollection(ResponseTxt);
            //>> Solo cogemos numero de serie SGA si hay lineas pendientes de procesar.
            if ArrayJSONManagement.GetCollectionCount() > 0 then
                _NumDoc := _GestionNs.GetNextNo(_Seccion."No. Series", TODAY, TRUE);
            //<<
            for i := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
                ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, i);
                ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
                ObjectJSONManagement.GetStringPropertyValueByName('CodigoArticulo', ValueText);
                _CodProducto := ValueText;
                ObjectJSONManagement.GetStringPropertyValueByName('CantidadMovimiento', ValueText);
                _CantidadTxt := ValueText;
                ObjectJSONManagement.GetStringPropertyValueByName('IdAlmacenERP', ValueText);
                _Almacen := ValueText;
                ObjectJSONManagement.GetStringPropertyValueByName('ROWID', ValueText);
                _IDBigTxt := ValueText;
                ObjectJSONManagement.GetStringPropertyValueByName('DescripcionTipoMovimiento', ValueText);
                _DescripTM := ValueText;
                ObjectJSONManagement.GetStringPropertyValueByName('NumeroMovimiento', ValueText);
                _MovSGA := ValueText;
                ObjectJSONManagement.GetStringPropertyValueByName('FechaMovimiento', ValueText);
                _FechaTxt := ValueText;

                EVALUATE(_IDBig, _IDBigTxt);

                //>> BBT 28/08/2025. La cantidad debe ser entera (sin decimales)
                IF _idioma <> '0' THEN
                    EVALUATE(_CantidadDec, _CantidadTxt)
                ELSE
                    ConverTextoADecimal(_CantidadTxt, _CantidadDec);

                _Cantidad := ConvertDecimalAEntero(_CantidadDec);
                //<<

                _Saltar := FALSE;
                _TextoError := '';
                IF _i = 2 THEN
                    IF _REcItem.GET(_CodProducto) THEN BEGIN
                        _REcItem.SETRANGE("Location Filter", _Almacen);
                        _REcItem.CALCFIELDS(Inventory);
                        _Saltar := _REcItem.Inventory < ABS(_Cantidad);
                        //Message('Inventario: ' + format(_REcItem.Inventory) + ' | Cantidad' + format(ABS(_Cantidad)));
                        IF _Saltar THEN _TextoError := 'Saltar';
                    END
                    else
                        _TextoError := 'El producto : ' + _CodProducto + ' no existe';
                //Message('vuelta ' + format(_i) + 'Inventario: ' + format(_REcItem.Inventory) + ' | Cantidad' + format(ABS(_Cantidad)) + ' | producto' + format((_IDBig)) + ' | producto' + _REcItem."no." + ' | Saltar:' + format(_Saltar));
                IF NOT _Saltar THEN BEGIN
                    IF _TextoError = '' THEN BEGIN
                        IF NOT EVALUATE(_FechaHora, _FechaTxt) THEN _TextoError := Error1;
                    END;
                    IF _TextoError = '' THEN BEGIN
                        _Fecha := DT2DATE(_FechaHora);
                        _ItemJournalLine.INIT;
                        _ItemJournalLine."Journal Template Name" := _WarehouseSetup."Journal Template Name";
                        _ItemJournalLine."Journal Batch Name" := _WarehouseSetup."Journal Batch Name";
                        _ItemJournalLine."Line No." := getLastJournalLine(_ItemJournalLine."Journal Template Name", _ItemJournalLine."Journal Batch Name");
                        _ItemJournalLine."Location Code" := _Almacen;
                        _ItemJournalLine."Posting Date" := _Fecha;
                        _ItemJournalLine."Document No." := _NumDoc;
                        //>> BBT 20251201. Ponemos el 'Tipo de Entrada' como 'Ajuste Positivo' porque por defecto es 'Compras' y si el producto está bloqueado 
                        //                 de compras da error en el validate del producto.
                        //                 En la procedure 'CantidadLineaDiario' se cambia el 'Tipo de Entrada' al ajuste correcto.              
                        _ItemJournalLine."Entry Type" := _ItemJournalLine."Entry Type"::"Positive Adjmt.";
                        //<<
                        _ItemJournalLine.INSERT;


                        IF NOT ProductoLineaDiario(_ItemJournalLine, _CodProducto) THEN _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250);
                        IF _TextoError = '' THEN IF NOT CantidadLineaDiario(_ItemJournalLine, _Cantidad) THEN _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250);
                        IF _TextoError = '' THEN BEGIN
                            //>> BBT. 07/02/2022. Identificacion movimientos de ajuste de SGA
                            _ItemJournalLine."Transaction Type" := '00';
                            _ItemJournalLine.Description := COPYSTR(_DescripTM, 1, 50);
                            _ItemJournalLine."External Document No." := COPYSTR(_MovSGA, 1, 35);
                            //<<
                            _ItemJournalLine.MODIFY;

                            IF NOT RegistrarLineaDiario(_ItemJournalLine) THEN _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250);
                        END;
                    END;

                    IF _TextoError = '' THEN _TextoError := 'CORRECTO';
                    ReemplazarCaracter(_TextoError, '''', '');

                    //>> Marcamos cada registro despues de su procesamiento
                    Clear(SGAJsonObject);
                    SGAJsonObject.Add('FechaProcesoEnlace', GetFechaTrabajo());
                    SGAJsonObject.Add('Resultado', _TextoError);
                    SGAJsonObject.Add('RowId', FORMAT(_IDBig));
                    HttpCall(SGACallType::"Actualizar ajustes stock", SGAJsonObject);
                    //<<
                END
            END;
        END;
    end;

    procedure CuadreInventario(_JournalTemplateName: Code[10]; "_Journal Batch Name": Code[10]; _FiltroAlmacen: Text[250]);
    var
        _WarehouseSetup: Record "Warehouse Setup";
        //_TempLineas: Record "Invoice Post. Buffer" temporary;
        _TempLineas: Record "Invoice Posting Buffer" temporary;
        _FechaTxt: Text[50];
        _FechaHora: DateTime;
        _Fecha: Date;
        _CantidadTxt: Text[25];
        _CantidadDec: Decimal;
        _Cantidad: Integer;
        _CodProducto: Code[20];
        _Almacen: Code[10];
        _TempSQL: Record "Temp SQL" temporary;
        _TextoError: Text[250];
        Error001: Label 'Problema con cantidad.';
        _Itemjournallines: Record "Item Journal Line";
        _Canti: Integer;
        //_TempLineasAcrear: Record "Invoice Post. Buffer" temporary;
        _TempLineasAcrear: Record "Invoice Posting Buffer" temporary;
        _NumLinea: Integer;
        _NumDoc: Code[20];
        _Idioma: Text[2];
        _Dialogo: Dialog;
        _InfoCompany: Record "Company Information";
    begin
        // Punto 15 Comparativa Stock
        _Idioma := '5';
        _TextoError := '';
        _WarehouseSetup.GET;
        _InfoCompany.GET;
        _TempLineas.RESET;
        _TempLineas.DELETEALL;
        _TempSQL.RESET;
        _TempSQL.DELETEALL;
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'IdEmpresaERP eq ''' + CompanyName + ''''); //Cambiar por COMPANYNAME
        HttpCall(SGACallType::"Leer cuadre inventario stock", SGAJsonObject);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        _Dialogo.OPEN('Producto: #1############');
        for i := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, i);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('IdAlmacenERP', ValueText);
            _Almacen := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CodigoArticulo', ValueText);
            _CodProducto := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CantidadAbsoluta', ValueText);
            _CantidadTxt := ValueText;
            _TextoError := '';
            _Dialogo.UPDATE(1, _CodProducto);

            //>> BBT 28/08/2025. La cantidad debe ser entera (sin decimales)
            IF _Idioma <> '0' THEN
                EVALUATE(_CantidadDec, _CantidadTxt)
            ELSE
                ConverTextoADecimal(_CantidadTxt, _CantidadDec);

            _Cantidad := ConvertDecimalAEntero(_CantidadDec);
            //<<  

            CLEAR(_TempLineas);
            _TempLineas.INIT;
            _TempLineas."G/L Account" := _CodProducto;
            _TempLineas."Gen. Bus. Posting Group" := _Almacen;
            IF NOT _TempLineas.FIND THEN _TempLineas.INSERT;
            _TempLineas.Quantity += _Cantidad;
            _TempLineas.MODIFY;
        end;
        _Dialogo.CLOSE;
        _TempLineas.RESET;
        IF NOT _TempLineas.ISEMPTY THEN BEGIN
            _Itemjournallines.RESET;
            _Itemjournallines.SETRANGE("Journal Template Name", _JournalTemplateName);
            _Itemjournallines.SETRANGE("Journal Batch Name", "_Journal Batch Name");
            IF _Itemjournallines.FINDSET(TRUE) THEN
                REPEAT
                    _Itemjournallines.VALIDATE("Qty. (Phys. Inventory)", 0);
                    _Itemjournallines.MODIFY;
                UNTIL _Itemjournallines.NEXT = 0;
            _Dialogo.OPEN('Producto: #1############');
            _TempLineas.RESET;
            _TempLineas.SETFILTER("Gen. Bus. Posting Group", _FiltroAlmacen);
            IF _TempLineas.FINDSET THEN
                REPEAT
                    _Dialogo.UPDATE(1, _TempLineas."G/L Account");
                    _Itemjournallines.SETRANGE("Item No.", _TempLineas."G/L Account");
                    _Itemjournallines.SETRANGE("Location Code", _TempLineas."Gen. Bus. Posting Group");
                    IF _Itemjournallines.FINDFIRST THEN BEGIN
                        _Itemjournallines.VALIDATE("Qty. (Phys. Inventory)", _TempLineas.Quantity);
                        _Itemjournallines.MODIFY;
                    END
                    ELSE BEGIN
                        _TempLineasAcrear := _TempLineas;
                        _TempLineasAcrear.INSERT;
                    END;
                UNTIL _TempLineas.NEXT = 0;
            _NumLinea := 0;
            _TempLineasAcrear.RESET;
            IF _TempLineasAcrear.FINDSET THEN BEGIN
                _Itemjournallines.SETRANGE("Item No.");
                _Itemjournallines.SETRANGE("Location Code");
                IF _Itemjournallines.FINDLAST THEN BEGIN
                    _NumLinea := _Itemjournallines."Line No.";
                    _NumDoc := _Itemjournallines."Document No.";
                END
                ELSE BEGIN
                    _NumLinea := 0;
                    _NumDoc := 'INV';
                END;
                _Itemjournallines.RESET;
                REPEAT
                    _NumLinea += 10000;
                    _Itemjournallines.INIT;
                    _Itemjournallines."Journal Template Name" := _JournalTemplateName;
                    _Itemjournallines."Journal Batch Name" := "_Journal Batch Name";
                    _Itemjournallines."Line No." := _NumLinea;
                    _Itemjournallines."Document No." := _NumDoc;
                    _Itemjournallines.VALIDATE("Entry Type", _Itemjournallines."Entry Type"::"Positive Adjmt.");
                    _Itemjournallines.VALIDATE("Posting Date", TODAY);
                    _Itemjournallines.VALIDATE("Item No.", _TempLineasAcrear."G/L Account");
                    _Itemjournallines.VALIDATE("Location Code", _TempLineasAcrear."Gen. Bus. Posting Group");
                    _Itemjournallines.VALIDATE("Phys. Inventory", TRUE);
                    _Itemjournallines.VALIDATE("Qty. (Phys. Inventory)", _TempLineasAcrear.Quantity);
                    _Itemjournallines.INSERT;
                UNTIL _TempLineasAcrear.NEXT = 0;
            END;
        END;
        _Itemjournallines.RESET;
        _Itemjournallines.SETRANGE("Journal Template Name", _JournalTemplateName);
        _Itemjournallines.SETRANGE("Journal Batch Name", "_Journal Batch Name");
        IF _Itemjournallines.FINDSET(TRUE) THEN
            REPEAT
                IF _Itemjournallines."Qty. (Calculated)" = _Itemjournallines."Qty. (Phys. Inventory)" THEN _Itemjournallines.DELETE;
            UNTIL _Itemjournallines.NEXT = 0;
        _Dialogo.CLOSE;
    end;

    procedure DocEnvConfirmAlb(_almacen: Code[10]; _Albaran: Code[20]; _Envio: Code[20]);
    var
        _CompanyInfo: Record "Company Information";
        _Location: Record Location;
    begin
        _CompanyInfo.GET;
        _Location.GET(_almacen);
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'IdAlmacenERP eq ''' + _almacen + '''' + ' and NumeroEntregaAlmacen eq ''' + _Envio + '''' + ' and NumeroAlbaran eq ''' + _Albaran + '''' + ' and IdEmpresaERP eq ''' + COMPANYNAME + '''');
        HttpCall(SGACallType::"Leer confirmacion albaran", SGAJsonObject);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        if ArrayJSONManagement.GetCollectionCount() = 0 then begin
            Clear(SGAJsonObject);
            SGAJsonObject.Add('CodigoAlmacenWMS', _Location."SGA Whse Code");
            SGAJsonObject.Add('IdAlmacenERP', _almacen);
            SGAJsonObject.Add('IdEmpresaERP', COMPANYNAME);
            SGAJsonObject.Add('NumeroEntregaAlmacen', _Envio);
            SGAJsonObject.Add('NumeroAlbaran', _Albaran);
            SGAJsonObject.Add('FechaAltaEnlace', GetFechaTrabajo());
            HttpCall(SGACallType::"Insertar confirmacion albaran", SGAJsonObject);
        END;
    end;

    procedure DevCompraDocEnvio(_NumEnvio: Code[20]; _Borrar: Boolean);
    var
        _WarehouseSetup: Record "Warehouse Setup";
        _FechaTrabajoDT: DateTime;
        _FechaServicio: DateTime;
        _FechaServicioTxt: Text[50];
        _CabEnvio: Record "Warehouse Shipment Header";
        _LinEnvo: Record "Warehouse Shipment Line";
        _CabCompra: Record "Purchase Header";
        _LinCompra: Record "Purchase Line";
        _Pais: Record "Country/Region";
        _Transportista: Record "Shipping Agent";
        _LinComentario: Record "Warehouse Comment Line";
        _Comentarios: Text;
        _TemplinEnvio: Record "Warehouse Shipment Line" temporary;
        _Name: Text[100];
        _Address: Text[100];
        _Address2: Text[100];
        _City: Text[50];
        _County: Text[50];
        _InfoCompany: Record "Company Information";
        _Location: Record Location;
    begin
        // Punto 6 Devolucion compra - Documento de envío
        _CabEnvio.GET(_NumEnvio);
        _InfoCompany.GET;
        _Location.GET(_CabEnvio."Location Code");
        CLEAR(sql_Estructura);
        IF _Borrar THEN BEGIN
            IF _CabEnvio.Status <> _CabEnvio.Status::Open THEN
                ERROR('El envio esta lanzado')
            ELSE IF _CabEnvio.Status <> _CabEnvio.Status::Released THEN ERROR('El envio debe de estar lanzado');
        END;
        _TemplinEnvio.RESET;
        _LinEnvo.SETRANGE("Source Type", 39);
        _LinEnvo.SETRANGE("Source Subtype", 5);
        _LinEnvo.SETRANGE("No.", _NumEnvio);
        IF _LinEnvo.FINDSET THEN
            REPEAT
                _TemplinEnvio.RESET;
                _TemplinEnvio.SETRANGE("Item No.", _LinEnvo."Item No.");
                IF NOT _TemplinEnvio.FINDFIRST THEN BEGIN
                    _TemplinEnvio.RESET;
                    _TemplinEnvio := _LinEnvo;
                    _TemplinEnvio.INSERT;
                END
                ELSE BEGIN
                    _TemplinEnvio."Qty. to Ship (Base)" += _LinEnvo."Qty. to Ship (Base)";
                    _TemplinEnvio.MODIFY;
                END;
            UNTIL _LinEnvo.NEXT = 0;
        IF _TemplinEnvio.FINDSET THEN BEGIN
            REPEAT
                _CabCompra.GET(_TemplinEnvio."Source Subtype", _LinEnvo."Source No.");
                IF NOT _Pais.GET(_CabCompra."Buy-from Country/Region Code") THEN CLEAR(_Pais);
                IF _TemplinEnvio."Shipment Date" = 0D THEN
                    _FechaServicioTxt := 'NULL'
                ELSE BEGIN
                    _FechaServicio := CREATEDATETIME(_TemplinEnvio."Shipment Date", 0T);
                END;
                _Name := _CabCompra."Buy-from Vendor Name";
                _Address := _CabCompra."Buy-from Address";
                _Address2 := _CabCompra."Buy-from Address 2";
                _City := _CabCompra."Buy-from City";
                _County := _CabCompra."Buy-from County";
                ReemplazarCaracter(_Name, '''', '');
                ReemplazarCaracter(_Address, '''', '');
                ReemplazarCaracter(_Address2, '''', '');
                ReemplazarCaracter(_City, '''', '');
                ReemplazarCaracter(_County, '''', '');
                Clear(SGAJsonObject);
                SGAJsonObject.Add('CodigoAlmacenWMS', _Location."SGA Whse Code");
                SGAJsonObject.Add('IdAlmacenERP', _CabEnvio."Location Code");
                SGAJsonObject.Add('CodigoAlmacenOrigenWMS', _Location."SGA Whse Code");
                SGAJsonObject.Add('IdAlmacenOrigenERP', _CabEnvio."Location Code");
                SGAJsonObject.Add('IdEmpresaERP', COMPANYNAME);
                SGAJsonObject.Add('TipoDocumento', '270');
                SGAJsonObject.Add('NumeroDocumento', _CabEnvio."No.");
                SGAJsonObject.Add('CodigoOrdenante', _CabCompra."Buy-from Vendor No.");
                SGAJsonObject.Add('NombreComercial', _Name);
                SGAJsonObject.Add('Direccion', _Address + ' ' + _Address2);
                SGAJsonObject.Add('CP', _CabCompra."Buy-from Post Code");
                SGAJsonObject.Add('Poblacion', _City);
                SGAJsonObject.Add('Provincia', _County);
                SGAJsonObject.Add('CodigoPaisISO', _CabCompra."Buy-from Country/Region Code");
                SGAJsonObject.Add('Pais', _Pais.Name);
                SGAJsonObject.Add('FechaAlta', GetFechaTrabajo);
                if _FechaServicioTxt = 'NULL' then
                    SGAJsonObject.Add('FechaServicioPrevista', _FechaServicioTxt)
                else
                    SGAJsonObject.Add('FechaServicioPrevista', _FechaServicio);
                SGAJsonObject.Add('NumeroLinea', FORMAT(_TemplinEnvio."Line No."));
                SGAJsonObject.Add('CodigoArticulo', _TemplinEnvio."Item No.");
                SGAJsonObject.Add('CantidadPedidaUMB', _TemplinEnvio."Qty. to Ship (Base)");
                SGAJsonObject.Add('FechaAltaEnlace', GetFechaTrabajo);
                HttpCall(SGACallType::"Insertar devolucion compra", SGAJsonObject);
            UNTIL _TemplinEnvio.NEXT = 0;
            IF NOT _Borrar THEN BEGIN
                _CabEnvio."Status SGA" := _CabEnvio."Status SGA"::"Enviado SGA";
                _CabEnvio."Grabado SGA" := CREATEDATETIME(WORKDATE, TIME);
                _CabEnvio.ModificadoSGA := FALSE;
                _CabEnvio.MODIFY;
            END;
        END;
    end;

    procedure AlbDevCompraDocEnvio();
    var
        _Almacen: Code[10];
        _NoDoc: Code[20];
        _NoEntAlm: Code[25];
        _NumLineaTxt: Text[20];
        _Numlinea: Integer;
        _CodArticulo: Code[20];
        _CantidadTxt: Text[20];
        _NumeroLote: Text[25];
        _FechaAltaTxt: Text[20];
        _FechaAltaDateTime: DateTime;
        _FechaAlta: Date;
        _IDBigTxt: Text;
        _IdBig: BigInteger;
        _Ok: Boolean;
        _Tipo: Code[10];
        _TempLineas: Record "Inventory Buffer" temporary;
        _TempLotes: Record "Inventory Buffer" temporary;
        _ComentarioLinea: Record "Warehouse line Comment";
        _TempComentarioLinea: Record "Warehouse line Comment" temporary;
        _TempComentarioLinea2: Record "Warehouse line Comment" temporary;
        _NumLineaComentario: Integer;
        _CantidadDec: Decimal;
        _Cantidad: Integer;
        _TempEnvio: Record "Inventory Buffer" temporary;
        _TextoError: Text;
        _CabEnvio: Record "Warehouse Shipment Header";
        Error01: Label 'El envio no existe';
        _LinEnvio: Record "Warehouse Shipment Line";
        _LinenvioTemp: Record "Warehouse Shipment Line" temporary;
        Error03: Label 'La cantidad a enviar es mayor que la cantidad.';
        _cant: Decimal;
        _TempLineasID: Record "Temp SQL" temporary;
        _idioma: Text[2];
        _TempLinEnvio: Record "Warehouse Shipment Line" temporary;
        _InfoCompany: Record "Company Information";
    begin
        // Punto 7 Documento de Envío - Albarán Devolucion compra
        _idioma := '5';
        _TempLineas.RESET;
        _TempLineas.DELETEALL;
        _TempLineasID.RESET;
        _TempLineasID.DELETEALL;
        _TempLotes.RESET;
        _TempLotes.DELETEALL;
        _InfoCompany.GET;
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'TipoDocumento eq ''270'' and FechaProcesoEnlace eq null and (Resultado eq null OR Resultado eq '''') AND IdEmpresaERP eq ''' + CompanyName + ''''); //Cambiar BB Trends por COMPANYNAMEç
        HttpCall(SGACallType::"Leer devolucion compra", SGAJsonObject);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for i := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, i);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('IdAlmacenERP', ValueText);
            _Almacen := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('TipoDocumento', ValueText);
            _Tipo := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroDocumento', ValueText);
            _NoDoc := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroEntregaAlmacen', ValueText);
            _NoEntAlm := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroLinea', ValueText);
            _NumLineaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CodigoArticulo', ValueText);
            _CodArticulo := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('CantidadPedidaUMB', ValueText);
            _CantidadTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroLote', ValueText);
            _NumeroLote := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('FechaAltaEnlace', ValueText);
            _FechaAltaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('ROWID', ValueText);
            _IDBigTxt := ValueText;
            EVALUATE(_IdBig, _IDBigTxt);
            _Ok := EVALUATE(_FechaAltaDateTime, _FechaAltaTxt);
            EVALUATE(_Numlinea, _NumLineaTxt);

            //>> BBT 28/08/2025. La cantidad debe ser entera (sin decimales)
            IF _idioma <> '0' THEN
                EVALUATE(_CantidadDec, _CantidadTxt)
            ELSE
                ConverTextoADecimal(_CantidadTxt, _CantidadDec);

            _Cantidad := ConvertDecimalAEntero(_CantidadDec);
            //<<   

            _TempLineasID.INIT;
            _TempLineasID.ID := _IdBig;
            _TempLineasID.Tipo := _Tipo;
            _TempLineasID."No. Documento" := _NoDoc;
            _TempLineasID.INSERT;
            _TempEnvio.INIT;
            _TempEnvio."Item No." := _NoDoc;
            IF NOT _TempEnvio.FIND THEN _TempEnvio.INSERT;
            _TempLineas.INIT;
            _TempLineas."Item No." := _NoDoc;
            _TempLineas."Variant Code" := _Tipo;
            _TempLineas."Dimension Entry No." := _Numlinea;
            _TempLineas."Bin Code" := _CodArticulo;
            IF NOT _TempLineas.FIND THEN _TempLineas.INSERT;
            _TempLineas.Quantity += _Cantidad;
            _TempLineas."Delivery Number" := _NoEntAlm;
            _TempLineas.MODIFY;
            IF _NumeroLote <> '' THEN BEGIN
                _TempLotes.INIT;
                _TempLotes."Item No." := _NoDoc;
                _TempLotes."Variant Code" := _Tipo;
                _TempLotes."Bin Code" := _CodArticulo;
                //_TempLotes."Dimension Entry No."  := _Numlinea;
                _TempLotes."Serial No." := _NumeroLote;
                IF NOT _TempLotes.FIND THEN _TempLotes.INSERT;
                _TempLotes.Quantity := _Cantidad;
                _TempLotes.MODIFY;
            END;
        end;
        // Actualizar Dev a recibir
        // Registrar
        _TempEnvio.RESET;
        _TempLineas.RESET;
        _TempLotes.RESET;
        IF _TempEnvio.FINDSET THEN
            REPEAT
                _TextoError := '';
                _TempComentarioLinea.RESET;
                _TempComentarioLinea.DELETEALL;
                _TempComentarioLinea2.RESET;
                _TempComentarioLinea2.DELETEALL;
                IF NOT _CabEnvio.GET(_TempEnvio."Item No.") THEN _TextoError := Error01;
                IF _TextoError = '' THEN BEGIN
                    _LinenvioTemp.RESET;
                    _LinenvioTemp.DELETEALL;
                    _TempLinEnvio.RESET;
                    _TempLinEnvio.DELETEALL;
                    _LinEnvio.SETRANGE("No.", _CabEnvio."No.");
                    IF _LinEnvio.FINDSET THEN
                        REPEAT
                            _TempLinEnvio.INIT;
                            _TempLinEnvio := _LinEnvio;
                            _TempLinEnvio.INSERT;
                        UNTIL _LinEnvio.NEXT = 0;
                    IF _LinEnvio.FINDSET(TRUE) THEN
                        REPEAT
                            _LinenvioTemp := _LinEnvio;
                            _LinenvioTemp.INSERT;
                            IF ValidarCantEnviarBase(_LinenvioTemp, 0) THEN BEGIN
                                _LinenvioTemp.MODIFY;
                                _ComentarioLinea.SETRANGE("Document Type", _ComentarioLinea."Document Type"::Ship);
                                _ComentarioLinea.SETRANGE("No.", _LinEnvio."No.");
                                _ComentarioLinea.SETRANGE("Document Line No.", _LinEnvio."Line No.");
                                IF _ComentarioLinea.FINDSET THEN
                                    REPEAT
                                        _TempComentarioLinea := _ComentarioLinea;
                                        _TempComentarioLinea.INSERT;
                                    UNTIL _ComentarioLinea.NEXT = 0;
                            END
                            ELSE
                                _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250);
                        UNTIL (_LinEnvio.NEXT = 0) OR (_TextoError <> '');
                    IF _TextoError = '' THEN BEGIN
                        _TempLineas.SETRANGE("Variant Code", '270');
                        _TempLineas.SETRANGE("Item No.", _CabEnvio."No.");
                        IF _TempLineas.FINDSET THEN
                            REPEAT // Cambiar para agrupacion
                                _LinenvioTemp.SETRANGE("No.", _TempLineas."Item No.");
                                _LinenvioTemp.SETRANGE("Item No.", _TempLineas."Bin Code");
                                _LinenvioTemp.SETFILTER("Qty. Outstanding (Base)", '<>0');
                                IF _LinenvioTemp.FINDSET(TRUE) THEN
                                    REPEAT
                                        IF _LinenvioTemp."Qty. Outstanding (Base)" >= _TempLineas.Quantity THEN BEGIN
                                            _cant := _TempLineas.Quantity;
                                            IF ValidarCantEnviarBase(_LinenvioTemp, _LinenvioTemp."Qty. to Ship (Base)" + _TempLineas.Quantity) THEN BEGIN
                                                _TempLineas.Quantity := 0;
                                                _TempLineas.MODIFY;
                                                _LinenvioTemp.VALIDATE("Qty. SGA (Base)", _LinenvioTemp."Qty. SGA (Base)" + _LinenvioTemp."Qty. to Ship (Base)");
                                                _LinenvioTemp."Warehouse delivery number" := _TempLineas."Delivery Number";
                                                _LinenvioTemp.MODIFY;
                                                ComentariosLoteEnvios(_TempLotes, _TempComentarioLinea, _cant, _LinenvioTemp);
                                                // Meter comentarios con lotes hasta _cant = 0
                                            END
                                            ELSE
                                                _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250);
                                        END
                                        ELSE IF ValidarCantEnviarBase(_LinenvioTemp, _LinenvioTemp."Qty. Outstanding (Base)") THEN BEGIN
                                            _cant := _LinenvioTemp."Qty. Outstanding (Base)";
                                            _TempLineas.Quantity -= _LinenvioTemp."Qty. Outstanding (Base)";
                                            _LinenvioTemp.VALIDATE("Qty. SGA (Base)", _LinenvioTemp."Qty. SGA (Base)" + _LinenvioTemp."Qty. to Ship (Base)");
                                            _TempLineas.MODIFY;
                                            _LinenvioTemp."Warehouse delivery number" := _TempLineas."Delivery Number";
                                            _LinenvioTemp.MODIFY;
                                            ComentariosLoteEnvios(_TempLotes, _TempComentarioLinea, _cant, _LinenvioTemp);
                                            // Meter comentarios con lotes hasta _cant = 0
                                        END
                                        ELSE
                                            _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250);
                                    UNTIL (_LinenvioTemp.NEXT = 0) OR (_TempLineas.Quantity = 0);
                                IF _TempLineas.Quantity > 0 THEN _TextoError := Error03;
                            UNTIL (_TextoError <> '') OR (_TempLineas.NEXT = 0);
                    END;
                    IF _TextoError = '' THEN BEGIN
                        _LinenvioTemp.RESET;
                        IF _LinenvioTemp.FINDSET THEN
                            REPEAT
                                _LinEnvio := _LinenvioTemp;
                                _LinEnvio.MODIFY;
                            UNTIL _LinenvioTemp.NEXT = 0;
                        _TempComentarioLinea.RESET;
                        _TempComentarioLinea2.RESET;
                        _TempComentarioLinea2.DELETEALL;
                        IF _TempComentarioLinea.FINDSET THEN
                            REPEAT
                                _ComentarioLinea := _TempComentarioLinea;
                                IF _ComentarioLinea.INSERT THEN BEGIN
                                    _TempComentarioLinea2 := _ComentarioLinea;
                                    _TempComentarioLinea2.INSERT;
                                END;
                            UNTIL _TempComentarioLinea.NEXT = 0;
                        IF NOT RegistrarEnvio(_LinEnvio) THEN BEGIN
                            _TextoError := COPYSTR(GETLASTERRORTEXT, 1, 250);
                            _TempComentarioLinea2.RESET;
                            IF _TempComentarioLinea2.FINDSET THEN BEGIN
                                _ComentarioLinea := _TempComentarioLinea2;
                                IF _ComentarioLinea.FIND THEN _ComentarioLinea.DELETE;
                            END;
                        END
                        ELSE BEGIN
                            _CabEnvio."Leido SGA" := CURRENTDATETIME;
                            IF _CabEnvio.MODIFY THEN;
                        END;
                    END;
                END;
                IF _TextoError = '' THEN
                    _TextoError := 'CORRECTO'
                ELSE BEGIN
                    _TempLinEnvio.RESET;
                    _LinEnvio.RESET;
                    CLEAR(_LinEnvio);
                    IF _TempLinEnvio.FINDSET THEN
                        REPEAT
                            _LinEnvio.INIT;
                            IF _LinEnvio.GET(_TempLinEnvio."No.", _TempLinEnvio."Line No.") THEN BEGIN
                                _LinEnvio.TRANSFERFIELDS(_TempLinEnvio, FALSE);
                                _LinEnvio.MODIFY;
                            END;
                        UNTIL _TempLinEnvio.NEXT = 0;
                END;
                ReemplazarCaracter(_TextoError, '''', '');
                _TempLineasID.RESET;
                _TempLineasID.SETRANGE(Tipo, '270');
                _TempLineasID.SETRANGE("No. Documento", _TempEnvio."Item No.");
                IF _TempLineasID.FINDSET THEN
                    REPEAT
                        Clear(SGAJsonObject);
                        SGAJsonObject.Add('FechaProcesoEnlace', GetFechaTrabajo());
                        SGAJsonObject.Add('Resultado', _TextoError);
                        SGAJsonObject.Add('RowId', FORMAT(_TempLineasID.ID));
                        HttpCall(SGACallType::"Actualizar documento", SGAJsonObject);
                    UNTIL _TempLineasID.NEXT = 0;
                _TextoError := '';
            UNTIL _TempEnvio.NEXT = 0;
    end;

    procedure EntregasExpedidas();
    var
        _IdAlmacenERP: Code[25];
        _NumeroEntregaAlmacen: Code[25];
        _FechaExpedicionEntrega: DateTime;
        _IDBig: BigInteger;
        _IDBigTxt: Text;
        _FechaExpedicionEntregaTxt: Text;
        _TempSQL: Record "Temp SQL" temporary;
        _TextoError: Text;
        _CabAlbaranVenta: Record "Sales Shipment Header";
    begin
        TempDoc.RESET;
        TempDoc.DELETEALL;
        _TempSQL.RESET;
        _TempSQL.DELETEALL;
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'FechaProcesoEnlace eq null and (Resultado eq null OR Resultado eq '''')');
        HttpCall(SGACallType::"Leer entregas expedidas", SGAJsonObject);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for i := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            _CabAlbaranVenta.RESET;
            _TextoError := '';
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, i);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('IdAlmacenERP', ValueText);
            _IdAlmacenERP := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroEntregaAlmacen', ValueText);
            _NumeroEntregaAlmacen := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('FechaExpedicionEntrega', ValueText);
            _FechaExpedicionEntregaTxt := ValueText;
            ObjectJSONManagement.GetStringPropertyValueByName('ROWID', ValueText);
            _IDBigTxt := ValueText;
            EVALUATE(_IDBig, _IDBigTxt);
            IF NOT EVALUATE(_FechaExpedicionEntrega, _FechaExpedicionEntregaTxt) THEN _TextoError := 'Fecha incorrecta';
            IF _TextoError = '' THEN BEGIN
                _CabAlbaranVenta.SETRANGE("No. entrega almacen", _NumeroEntregaAlmacen);
                IF _CabAlbaranVenta.FINDSET(TRUE) THEN BEGIN
                    _CabAlbaranVenta."Expedition Date SGA" := _FechaExpedicionEntrega;
                    _CabAlbaranVenta.MODIFY;
                END
                ELSE
                    _TextoError := 'El albarán con número de entrega ' + _NumeroEntregaAlmacen + ' no existe';
            END;
            IF _TextoError = '' THEN _TextoError := 'Correcto';
            _TempSQL.INIT;
            _TempSQL.ID := _IDBig;
            _TempSQL.Error := _TextoError;
            IF NOT _TempSQL.INSERT THEN _TempSQL.MODIFY;
        end;
        _TempSQL.RESET;
        IF _TempSQL.FINDSET THEN BEGIN
            REPEAT
                Clear(SGAJsonObject);
                SGAJsonObject.Add('FechaProcesoEnlace', GetFechaTrabajo());
                SGAJsonObject.Add('Resultado', _TempSQL.Error);
                SGAJsonObject.Add('RowId', FORMAT(_TempSQL.ID));
                HttpCall(SGACallType::"Actualizar entregas expedidas", SGAJsonObject);
            UNTIL _TempSQL.NEXT = 0;
        END;
    end;
    //**************************************************************Global functions**********************************************************************************//
    procedure HttpCall(SGACallType: Enum "SGA Call Type"; SGAJsonObject: JsonObject)
    var
        ClientHttp: HttpClient;
        RequestHeaders: HttpHeaders;
        RequestContent: HttpContent;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        contentHeaders: HttpHeaders;
        RequestURL: text;
        Body: text;
        SalesReceivable: record "Sales & Receivables Setup";
    begin
        Clear(SalesReceivable);
        SalesReceivable.Get();
        Clear(ClientHttp);
        Clear(RequestHeaders);
        Clear(RequestContent);
        Clear(contentHeaders);
        case SGACallType of
            SGACallType::"Bloqueo documentos":
                begin
                    RequestURL := SalesReceivable."SGA - Document Block Endpoint"; //'https://prod-151.westeurope.logic.azure.com:443/workflows/1579c749a496412a8104f27910b49795/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=avklokRBDYLtHQy-rpVwB7MRiqSX6ULltT_90b0Q9Ik';
                end;
            SGACallType::"Insertar producto":
                begin
                    RequestURL := SalesReceivable."SGA - Insert Item Endpoint"; //'https://prod-99.westeurope.logic.azure.com:443/workflows/d6163a79507e4e628f59f72689874171/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=KQ_qxHzKOvnLOtucxz-zxP64WSsKAgQUPhJp78FTmkM';
                end;
            SGACallType::"Gestion Pedido Compra":
                begin
                    RequestURL := SalesReceivable."SGA - Purch Order Mngmnt. Endp"; //'https://prod-12.westeurope.logic.azure.com:443/workflows/cd46dc96dfd04e65903c568783e100ee/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=D77KO8NnRB7h0qjb_ozT6zMD69kY5N8TQnFMnyUyFmE';
                end;
            SGACallType::"Recepcion pedido compra":
                begin
                    RequestURL := SalesReceivable."SGA-Purchase Order Recep. Endp"; //'https://prod-67.westeurope.logic.azure.com:443/workflows/a9eb30263eb34535aee611f7585a7450/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=WLN7fuqhW_Er0o65oMmmGstZyy_W114yfQddGslA7hc';
                end;
            SGACallType::"Actualizar documento":
                begin
                    RequestURL := SalesReceivable."SGA-Update Document Endpoint"; //'https://prod-242.westeurope.logic.azure.com:443/workflows/192836f27397402192ce20e13bad6e42/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=dkZ0x3QtQ6zsRAiy9-i0oc24TGGZTa9l_PnLGn8B0OM';
                end;
            SGACallType::"Documento envio":
                begin
                    RequestURL := SalesReceivable."SGA-Shipment Document Endpoint"; //'https://prod-53.westeurope.logic.azure.com:443/workflows/756f4995e95c4c2d9a2a209a69f8c49f/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=hbrJ7EePuxKcylw71dzVrSZkSdv4QGeELrUm00OUs8c';
                end;
            SGACallType::"Albaran pedido venta":
                begin
                    RequestURL := SalesReceivable."SGA-Shipment S.Order Endpoint"; //'https://prod-141.westeurope.logic.azure.com:443/workflows/46d897f60a534e73a35847e11d970ac9/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=q6SKwN48ul5p6-2p5fqCPCy3JJ0NZP7kFdbUKIZvK7E';
                end;
            SGACallType::"Leer entregas expedidas":
                begin
                    RequestURL := SalesReceivable."SGA-Read exped. shipment Endp"; //'https://prod-10.westeurope.logic.azure.com:443/workflows/c1906b6ec7cc492a8cc317344d8d1e96/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=oP3u003QS_Gxg66WdXZSC6XtszhOR1wRiKK6fZ00eTE';
                end;
            SGACallType::"Actualizar entregas expedidas":
                begin
                    RequestURL := SalesReceivable."SGA-Update exped. ship. Endp"; //'https://prod-248.westeurope.logic.azure.com:443/workflows/1fbb32160add4444ba0f982b26907376/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=HJchYvzSMJL7NTivFnYJEDK5rg6c7LSJEkBSjIgwW6s';
                end;
            SGACallType::"Insertar devolucion venta":
                begin
                    RequestURL := SalesReceivable."SGA-Insert S.Credit Memo. Endp"; //'https://prod-89.westeurope.logic.azure.com:443/workflows/f005d73dff394481a7ae9178797cc430/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=eQ65hkHDRtp_UWSLqBfhOk0KY1S1RVMDLBpaS9DnXM0';
                end;
            SGACallType::"Leer recepcion devolucion venta":
                begin
                    RequestURL := SalesReceivable."SGA-Read Recep. S.Credit Memo."; //'https://prod-217.westeurope.logic.azure.com:443/workflows/4d93f24ba0ca46268614b2172d0e7de6/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=62B-gSVJ1oeA8d90Y2mFGpjo1Z9iYBjDLA5KwrUDhY0';
                end;
            SGACallType::"Insertar pedido transferencia":
                begin
                    RequestURL := SalesReceivable."SGA-Insert Transfer Order Endp"; //'https://prod-171.westeurope.logic.azure.com:443/workflows/276d025b96c54786a5ec4ed9057e493a/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=XgWsZcK5hSNApe_gZIrBLvbQhj_9TpyMcRLFFuV0Co0';
                end;
            SGACallType::"Leer pedido transferencia":
                begin
                    RequestURL := SalesReceivable."SGA-Read Transfer Order Endp"; //'https://prod-99.westeurope.logic.azure.com:443/workflows/16753270c87e454f8a93c5b0f7b3da8c/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=SHRUMScEHaMZ54nHHh4ljVOWDuPIRdvMIiLDcKgCuco';
                end;
            SGACallType::"Leer ajustes stock":
                begin
                    RequestURL := SalesReceivable."SGA-Read Stock Adjust. Endp"; //'https://prod-193.westeurope.logic.azure.com:443/workflows/ae55346fe97a48e9ac4238871bff63ef/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=jHjnX1EXD94CtjXrPABqUER24S2eCHk81TvDrHfXUJc';
                end;
            SGACallType::"Actualizar ajustes stock":
                begin
                    RequestURL := SalesReceivable."SGA-Update Stock Adjust. Endp"; //'https://prod-120.westeurope.logic.azure.com:443/workflows/78b3c462e2654947b26f688aa2e66305/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=Q6jzPz27BcJj4fxTXOlW43_XLAsDLLZvpHb_JtfDGLU';
                end;
            SGACallType::"Leer confirmacion albaran":
                begin
                    RequestURL := SalesReceivable."SGA-Read shipm. confirm. Endp"; //'https://prod-100.westeurope.logic.azure.com:443/workflows/8c38110e01f14859b46933c80a2bc6a3/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=zzuZ1EwYb2jP2YJHVyZEh3oXPOawQ8R1t3ophzHXHUA';
                end;
            SGACallType::"Insertar confirmacion albaran":
                begin
                    RequestURL := SalesReceivable."SGA-Insert shipm. confirm Endp"; //'https://prod-152.westeurope.logic.azure.com:443/workflows/5c4a1cd92ef54b57ba35a65417a8ba42/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=EX42mlnJkn_RbyULmfB-rIBfkM_HqxZo6YTO6-nRTJA';
                end;
            SGACallType::"Insertar devolucion compra":
                begin
                    RequestURL := SalesReceivable."SGA-Insert p.return order Endp"; //'https://prod-98.westeurope.logic.azure.com:443/workflows/f4e964b9053d40768362e7fdcc6f73da/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=YZOEsrgRYTMzWsob_jjNk_ch9_SmgsWfERJLoLJarqs';
                end;
            SGACallType::"Leer devolucion compra":
                begin
                    RequestURL := SalesReceivable."SGA-Read p.return order Endp"; //'https://prod-241.westeurope.logic.azure.com:443/workflows/ef9ab832c9db47709b9c85201da02222/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=04Fc0LysHZodfMKlGQ1j5FXqhB7-chxoqodA92HiYkk';
                end;
            SGACallType::"Leer entrega almacen":
                begin
                    RequestURL := SalesReceivable."SGA-Read location entry Endp"; //'https://prod-132.westeurope.logic.azure.com:443/workflows/9edb2603700246b5932e43d8406468ec/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=jEiRbEK411Tk4KGAsWkL1dlpKEhFNG0nInefKpJivLg';
                end;
            SGACallType::"Leer packing list":
                begin
                    RequestURL := SalesReceivable."SGA-Read packing list Endp"; //'https://prod-193.westeurope.logic.azure.com:443/workflows/7e2b79b42eac4ee7ac9c4084e87d1c7f/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=rT9gIe_tK4ixKsVvNdolrU8LbNeg4ZlYQVwC53xh8Dg';
                end;
            SGACallType::"Leer campos error":
                begin
                    RequestURL := SalesReceivable."SGA-Read error fields Endp"; //'https://prod-147.westeurope.logic.azure.com:443/workflows/ad720d0589fa444db2688731e9e623c9/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=jkRQVzteCNHEoo_ZaKM2N2DYgBtv2dpfM1Xqjpp8oXQ';
                end;
            SGACallType::"Leer campos error stock":
                begin
                    RequestURL := SalesReceivable."SGA-Read error fields stock"; //'https://prod-00.westeurope.logic.azure.com:443/workflows/ec19f081df094320b490963db0d3ac20/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=n7bsu9ILTcD8reozNeqPq7zsqqRCUjWnc3QXuFke5QA';
                end;
        end;
        RequestHeaders := ClientHttp.DefaultRequestHeaders();
        SGAJsonObject.WriteTo(Body);
        RequestContent.WriteFrom(Body);
        RequestContent.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');
        ClientHttp.Post(RequestURL, RequestContent, ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode then begin
            ResponseMessage.Content.ReadAs(ResponseTxt);
            Error(ResponseTxt);
        end;
        ResponseMessage.Content.ReadAs(ResponseTxt);
    end;

    local procedure ReemplazarCaracter(var _Texto: Text[250]; _Reemplazar: Text[1]; _Por: Text[1]);
    begin
        _Texto := _Texto.Replace(_Reemplazar, _Por);
    end;

    local procedure GetFechaTrabajo(): DateTime;
    var
        _FechaTrabajoDT: DateTime;
        ReturnDate: DateTime;
    begin
        _FechaTrabajoDT := CREATEDATETIME(WORKDATE, TIME);
        exit(_FechaTrabajoDT); //2018-07-16 12:23:50.000
    end;

    local procedure ConverTextoADecimal(_NumerodecimalTXT: Text[25]; var _NumeroDecimal: Decimal): Boolean;
    begin
        _NumeroDecimal := 0;
        _NumerodecimalTXT := DELCHR(_NumerodecimalTXT, '=', ',');
        ReemplazarCaracter(_NumerodecimalTXT, '.', ',');
        IF NOT EVALUATE(_NumeroDecimal, _NumerodecimalTXT) THEN EXIT(FALSE);
    end;

    Local Procedure ConvertDecimalAEntero(pDecimal: Decimal): Integer;
    begin
        exit(round(pDecimal, 1))
    end;


    [TryFunction]
    local procedure AbrirPedidoCompra(var _CabCompra: Record "Purchase Header");
    var
        _ReleasePurchDoc: Codeunit "Release Purchase Document";
    begin
        _ReleasePurchDoc.Reopen(_CabCompra);
    end;

    [TryFunction]
    local procedure validarFechaRegistroCompra(var _CabCompra: Record "Purchase Header"; _Fecha: Date);
    begin
        _CabCompra.SetHideValidationDialog(TRUE);
        _CabCompra.VALIDATE("Posting Date", _Fecha);
    end;

    [TryFunction]
    local procedure ValidarCantRecibBase(var _LinCompra: Record "Purchase Line"; _Cantidad: Decimal);
    begin
        _LinCompra.VALIDATE("Qty. to Receive (Base)", _Cantidad);
    end;

    local procedure RegistrarCompra(var _Cabcompra: Record "Purchase Header"): Boolean;
    var
        _CU90: Codeunit "Purch.-Post";
    begin
        CLEAR(_CU90);
        _Cabcompra.Receive := TRUE;
        _Cabcompra.Ship := FALSE;
        _Cabcompra.Invoice := FALSE;
        COMMIT;
        IF _CU90.RUN(_Cabcompra) THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    [TryFunction]
    local procedure ValidarCantEnviarBase(var _LinEnvio: Record "Warehouse Shipment Line"; _Cantidad: Decimal);
    begin
        _LinEnvio.VALIDATE("Qty. to Ship (Base)", _Cantidad);
    end;

    local procedure ComentariosLoteEnvios(var _TempLotes: Record "Inventory Buffer" temporary; var _TempComentarioLinea: Record "Warehouse line Comment" temporary; _Cant: Decimal; _LinenvioTemp: Record "Warehouse Shipment Line" temporary);
    var
        _NumeroLinea: Integer;
    begin
        _TempComentarioLinea.RESET;
        _TempComentarioLinea.SETRANGE("Document Type", _TempComentarioLinea."Document Type"::Ship);
        _TempComentarioLinea.SETRANGE(_TempComentarioLinea."No.", _LinenvioTemp."No.");
        _TempComentarioLinea.SETRANGE("Document Line No.", _LinenvioTemp."Line No.");
        IF _TempComentarioLinea.FINDLAST THEN
            _NumeroLinea := _TempComentarioLinea."Line No."
        ELSE
            _NumeroLinea := 0;
        _TempLotes.SETRANGE("Item No.", _LinenvioTemp."No.");
        _TempLotes.SETRANGE("Variant Code", '200');
        _TempLotes.SETRANGE("Bin Code", _LinenvioTemp."Item No.");
        _TempLotes.SETFILTER(Quantity, '<>%1', 0);
        IF _TempLotes.FINDSET(TRUE) THEN
            REPEAT
                _NumeroLinea += 10000;
                _TempComentarioLinea.INIT;
                _TempComentarioLinea."Document Type" := _TempComentarioLinea."Document Type"::Ship;
                _TempComentarioLinea."No." := _LinenvioTemp."No.";
                _TempComentarioLinea."Document Line No." := _LinenvioTemp."Line No.";
                _TempComentarioLinea."Line No." := _NumeroLinea;
                IF _TempLotes.Quantity > _Cant THEN BEGIN
                    _TempComentarioLinea.Comment := STRSUBSTNO(LineaLote, _TempLotes."Serial No.", FORMAT(_Cant));
                    _Cant := 0;
                    _TempLotes.Quantity := _TempLotes.Quantity - _Cant;
                END
                ELSE BEGIN
                    _TempComentarioLinea.Comment := STRSUBSTNO(LineaLote, _TempLotes."Serial No.", FORMAT(_TempLotes.Quantity));
                    _Cant := _Cant - _TempLotes.Quantity;
                    _TempLotes.Quantity := 0;
                END;
                _TempComentarioLinea.INSERT;
                _TempLotes.MODIFY;
            UNTIL (_TempLotes.NEXT = 0) OR (_Cant = 0);
    end;

    local procedure RegistrarEnvio(_Linenvio: Record "Warehouse Shipment Line"): Boolean;
    var
        WhsePostShipment: Codeunit "Whse.-Post Shipment";
    begin
        COMMIT;
        CLEAR(WhsePostShipment);
        WhsePostShipment.SetPostingSettings(FALSE);
        WhsePostShipment.SetPrint(TRUE);
        IF WhsePostShipment.RUN(_Linenvio) THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    [TryFunction]
    local procedure ValidarCantDevVentaBase(var _LinVenta: Record "Sales Line"; _Cantidad: Decimal);
    begin
        _LinVenta.VALIDATE("Qty. to Ship (Base)", _Cantidad);
    end;

    local procedure RegistrarDevVenta(var _Cabventa: Record "Sales Header"): Boolean;
    var
        _CU80: Codeunit "Sales-Post";
    begin
        COMMIT;
        CLEAR(_CU80);
        _Cabventa.Ship := FALSE;
        _Cabventa.Invoice := FALSE;
        _Cabventa.Receive := TRUE;
        IF _CU80.RUN(_Cabventa) THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    [TryFunction]
    local procedure ValidarCantEnviarTrans(var _LinTransferencia: Record "Transfer Line"; _Cant: Decimal);
    begin
        _LinTransferencia.VALIDATE(_LinTransferencia."Qty. to Ship (Base)", _Cant);
    end;

    [TryFunction]
    local procedure ValidarCantRecepTrans(var _LinTransferencia: Record "Transfer Line"; _Cant: Decimal);
    begin
        _LinTransferencia.VALIDATE("Qty. to Receive (Base)", _Cant);
    end;

    local procedure RegistrarEnvioTrans(var _Cabtransfer: Record "Transfer Header"): Boolean;
    var
        _RegEnvioTranfer: Codeunit "TransferOrder-Post Shipment";
    begin
        COMMIT;
        CLEAR(_RegEnvioTranfer);
        _RegEnvioTranfer.SetHideValidationDialog(TRUE);
        IF _RegEnvioTranfer.RUN(_Cabtransfer) THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    local procedure RegistrarRecepTrans(var _CabTransfer: Record "Transfer Header"): Boolean;
    var
        _RecRecepTransfer: Codeunit "TransferOrder-Post Receipt";
    begin
        COMMIT;
        CLEAR(_RecRecepTransfer);
        _RecRecepTransfer.SetHideValidationDialog(TRUE);
        IF _RecRecepTransfer.RUN(_CabTransfer) THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    procedure EnvioSGA(var _Cabtransfer: Record "Transfer Header"; var _Tipo: Integer; var _TempLineasOLD: Record "Transfer Line" temporary; _Borrar: Boolean);
    begin
        //_Cabtransfer.ModificadoSGA := TRUE;
        _Cabtransfer.MODIFY;
        IF _Tipo = 0 THEN BEGIN
        END;
        "PedidoTransferencia-->SGA"(_Cabtransfer."No.", _Tipo, _TempLineasOLD, _Borrar);
        MESSAGE('Envio completado');
    end;

    procedure AlmRegManualDiario(_LindiarioProducto: Record "Item Journal Line") _Error: Boolean;
    var
        _LinDiarioLocal: Record "Item Journal Line";
        _Almacen: Record Location;
    begin
        _Error := FALSE;
        _LinDiarioLocal.RESET;
        _LinDiarioLocal.SETRANGE("Journal Template Name", _LindiarioProducto."Journal Template Name");
        _LinDiarioLocal.SETRANGE("Journal Batch Name", _LindiarioProducto."Journal Batch Name");
        IF _LinDiarioLocal.FINDSET THEN
            REPEAT
                IF _Almacen.GET(_LinDiarioLocal."Location Code") THEN _Error := _Almacen.SGA;
            UNTIL (_LinDiarioLocal.NEXT = 0) OR _Error;
        EXIT(_Error);
    end;

    procedure AlmRegPedCompra(_CabCompra: Record "Purchase Header") _Error: Boolean;
    var
        _Almacen: Record Location;
        _LinCompra: Record "Purchase Line";
        _Producto: Record Item;
    begin
        _Error := FALSE;
        _LinCompra.RESET;
        _LinCompra.SETRANGE("Document Type", _CabCompra."Document Type");
        _LinCompra.SETRANGE("Document No.", _CabCompra."No.");
        _LinCompra.SETRANGE(Type, _LinCompra.Type::Item);
        _LinCompra.SETFILTER("Qty. to Receive", '<>%1', 0);
        IF _LinCompra.FINDSET THEN
            REPEAT
                _Producto.GET(_LinCompra."No.");
                _Almacen.GET(_LinCompra."Location Code");
                IF _CabCompra."Document Type" = _CabCompra."Document Type"::Invoice THEN BEGIN
                    IF _LinCompra."Receipt No." = '' THEN _Error := _Almacen.SGA AND NOT (_Producto."No SGA management");
                END
                ELSE
                    _Error := _Almacen.SGA AND NOT (_Producto."No SGA management");
            UNTIL (_LinCompra.NEXT = 0) OR _Error;
    end;

    procedure AlmacenSGA(_CodAlmacen: Code[10]): Boolean;
    var
        _Almacen: Record Location;
    begin
        _Almacen.GET(_CodAlmacen);
        EXIT(_Almacen.SGA);
    end;

    [TryFunction]
    local procedure ProductoLineaDiario(var _LinDiarioProducto: Record "Item Journal Line"; _Item: Code[20]);
    begin
        _LinDiarioProducto.VALIDATE("Item No.", _Item);
    end;

    [TryFunction]
    local procedure CantidadLineaDiario(var _LinDiarioProducto: Record "Item Journal Line"; _Quantity: Decimal);
    begin
        IF _Quantity < 0 THEN
            _LinDiarioProducto."Entry Type" := _LinDiarioProducto."Entry Type"::"Negative Adjmt."
        ELSE
            _LinDiarioProducto."Entry Type" := _LinDiarioProducto."Entry Type"::"Positive Adjmt.";

        _LinDiarioProducto.VALIDATE(Quantity, ABS(_Quantity));
    end;

    local procedure RegistrarLineaDiario(_LinDiarioProducto: Record "Item Journal Line"): Boolean;
    var
        _CU22: Codeunit "Item Jnl.-Post Line";
        ItemJnlLine: Record "Item Journal Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        COMMIT;
        Clear(ItemLedgerEntry);
        //>> revisión error duplicados
        //Comprobamos si ya existe el numero de documento, si existe no hacemos nada y saltamos // 05/12/2023 AJUSTESTOCK
        // Es el Numero de Documento Externo
        ItemLedgerEntry.SetRange("External Document No.", _LinDiarioProducto."External Document No.");
        ItemLedgerEntry.SetRange("Transaction Type", '00');
        //<<
        IF NOT ItemLedgerEntry.FindFirst() then begin
            CLEAR(_CU22);
            IF _CU22.RUN(_LinDiarioProducto) THEN
                EXIT(TRUE)
            ELSE
                EXIT(FALSE);
        end
        else begin
            _LinDiarioProducto.Delete();
            exit(true);
        end;
    end;

    //>> Pasada a la PAGE 50219 -  BBT Item Identifiers. 
    /*
    procedure CalcularEAN(_Codigo: Code[13]; _Tipo: Option EAN13,EAN14): Code[14];
    var
        Codi: Code[13];
        Cadena: Text[100];
        Ean: Code[14];
        Mascara: Text[13];
        Control: Code[1];
        Tipo: Option EAN13,EAN14;
        LongCodigo: Integer;
    begin
        Codi := _Codigo;
        Cadena := 'abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZ\/-_.,:;+ ';
        Ean := DELCHR(Codi, '=', Cadena);
        IF _Tipo = _Tipo::EAN13 THEN
            LongCodigo := 12
        ELSE
            LongCodigo := 13;
        IF STRLEN(Ean) < LongCodigo THEN ERROR('El código debe de ser de' + FORMAT(LongCodigo) + ' dígitos');
        IF _Tipo = _Tipo::EAN13 THEN
            Mascara := '131313131313'
        ELSE
            Mascara := '3131313131313';
        Control := FORMAT(STRCHECKSUM(Ean, Mascara));
        Ean := Ean + Control;
        EXIT(Ean);
    end;
    */

    procedure ExtraerNumDocTipo(_TipoyNum: Code[25]; var _Tipo: Code[3]; var _No: Code[20]);
    var
        _Longitud: Integer;
    begin
        _Longitud := STRLEN(_TipoyNum);
        IF _Longitud >= 4 THEN BEGIN
            _Tipo := COPYSTR(_TipoyNum, _Longitud - 2, 3);
            _No := COPYSTR(_TipoyNum, 1, _Longitud - 3);
        END
        ELSE
            ERROR('Longitud del código incorrecta');
    end;

    procedure ChequeoStockEnvio(_Numenvio: Code[20]);
    var
        _LinEnvio: Record "Warehouse Shipment Line";
        _Item: Record Item;
        _CantidadLinEnvio: Decimal;
        _CantidadLinTransfer: Decimal;
    begin
        _LinEnvio.RESET;
        _LinEnvio.SETRANGE("No.", _Numenvio);
        _LinEnvio.SETFILTER("Qty. to Ship (Base)", '<>%1', 0);
        IF _LinEnvio.FINDSET THEN
            REPEAT
                _CantidadLinEnvio := 0;
                _CantidadLinTransfer := 0;
                IF _Item.GET(_LinEnvio."Item No.") THEN BEGIN
                    _Item.SETRANGE("Location Filter", _LinEnvio."Location Code");
                    _Item.CALCFIELDS(Inventory);
                    _CantidadLinEnvio := CantEnvios(_Numenvio, _Item."No.", _LinEnvio."Location Code", _LinEnvio."Line No.");
                    _CantidadLinTransfer := CantTransfer('', _Item."No.", _LinEnvio."Location Code", 0);
                    IF (_Item.Inventory - _CantidadLinEnvio - _CantidadLinTransfer) < _LinEnvio."Qty. to Ship (Base)" THEN
                        ERROR('Existencia infuficiente del producto %1 en almacén %2. Cantidad a enviar %3, cantidad en stock %4',
                            _Item."No.", _LinEnvio."Location Code", _LinEnvio."Qty. to Ship (Base)", _Item.Inventory - _CantidadLinEnvio - _CantidadLinTransfer);
                END;
            UNTIL _LinEnvio.NEXT = 0;
    end;

    procedure ChequeoStockTransfer(_NumTransfer: Code[20]);
    var
        _Item: Record Item;
        _LinEnvio: Record "Warehouse Shipment Line";
        _CantidadLinEnvio: Decimal;
        _CantidadLinTransfer: Decimal;
        _LinTransfer: Record "Transfer Line";
        _LinTransfer2: Record "Transfer Line";
        _RecAlmacen: Record Location;
    begin
        _LinTransfer.RESET;
        _LinTransfer.SETRANGE("Document No.", _NumTransfer);
        _LinTransfer.SETFILTER("Qty. to Ship (Base)", '<>%1', 0);
        IF _LinTransfer.FINDSET THEN
            REPEAT
                _RecAlmacen.GET(_LinTransfer."Transfer-from Code");
                _CantidadLinEnvio := 0;
                _CantidadLinTransfer := 0;
                IF _RecAlmacen.SGA THEN BEGIN
                    IF _Item.GET(_LinTransfer."Item No.") THEN BEGIN
                        _Item.SETRANGE("Location Filter", _LinTransfer."Transfer-from Code");
                        _Item.CALCFIELDS(Inventory);
                        _RecAlmacen.GET(_LinTransfer."Transfer-from Code");
                        _CantidadLinEnvio := CantEnvios('', _Item."No.", _LinTransfer."Transfer-from Code", 0);
                        _CantidadLinTransfer := CantTransfer(_NumTransfer, _Item."No.", _LinTransfer."Transfer-from Code", _LinTransfer."Line No.");
                        //>> BBT. 02-02-2022. Error calculo disponible.
                        //            IF (_Item.Inventory - _CantidadLinEnvio - _CantidadLinTransfer) < _LinEnvio."Qty. to Ship (Base)" THEN
                        //              ERROR('Existencia infuficiente del producto %1 en almacén %2. Cantidad a enviar %3, cantidad en stock %4',
                        //              _Item."No.",_LinEnvio."Location Code",_LinEnvio."Qty. to Ship (Base)",_Item.Inventory - _CantidadLinEnvio - _CantidadLinTransfer);
                        IF (_Item.Inventory - _CantidadLinEnvio - _CantidadLinTransfer) < _LinTransfer."Qty. to Ship (Base)" THEN
                            ERROR('Existencia infuficiente del producto %1 en almacén %2. Cantidad a enviar %3, cantidad disponible %4',
                                 _Item."No.", _LinTransfer."Transfer-from Code", _LinTransfer."Qty. to Ship (Base)", _Item.Inventory - _CantidadLinEnvio - _CantidadLinTransfer);
                        //<<
                    END;
                END;
            UNTIL _LinTransfer.NEXT = 0;
    end;

    local procedure CantEnvios(_NumEnvio: Code[20]; _CodProducto: Code[20]; _Almacen: Code[10]; _NumLinEnvio: Integer) _CantidadLinEnvio: Decimal;
    var
        _LinEnvio: Record "Warehouse Shipment Line";
    begin
        _CantidadLinEnvio := 0;
        _LinEnvio.RESET;
        //IF _NumEnvio <> '' THEN
        //  _LinEnvio.SETFILTER("No.",'<>%1',_NumEnvio);
        _LinEnvio.SETFILTER("Qty. to Ship (Base)", '<>%1', 0);
        _LinEnvio.SETFILTER("Status SGA", '<>%1', _LinEnvio."Status SGA"::" ");
        _LinEnvio.SETRANGE("Item No.", _CodProducto);
        _LinEnvio.SETRANGE("Location Code", _Almacen);
        IF _LinEnvio.FINDSET THEN
            REPEAT
                IF (_LinEnvio."No." <> _NumEnvio) OR (_LinEnvio."Line No." <> _NumLinEnvio) OR (_NumEnvio = '') THEN _CantidadLinEnvio += _LinEnvio."Qty. to Ship (Base)";
            UNTIL _LinEnvio.NEXT = 0;
    end;

    local procedure CantTransfer(_NumTransfer: Code[20]; _CodProducto: Code[20]; _Almacen: Code[10]; _NumLinTransfer: Integer) _CantidadLinTrans: Decimal;
    var
        _LinTransfer: Record "Transfer Line";
        _RecAlmacen: Record Location;
    begin
        _CantidadLinTrans := 0;
        _RecAlmacen.GET(_Almacen);
        IF _RecAlmacen.SGA THEN BEGIN
            _LinTransfer.RESET;
            //IF _NumTransfer <> '' THEN
            //  _LinTransfer.SETFILTER("Document No.",'<>%1',_NumTransfer);
            _LinTransfer.SETFILTER("Qty. to Ship (Base)", '<>%1', 0);
            _LinTransfer.SETFILTER("Status SGA", '<>%1', _LinTransfer."Status SGA"::" ");
            _LinTransfer.SETRANGE("Item No.", _CodProducto);
            _LinTransfer.SETRANGE("Transfer-from Code", _Almacen);
            IF _LinTransfer.FINDSET THEN
                REPEAT
                    IF (_LinTransfer."Document No." <> _NumTransfer) OR (_LinTransfer."Line No." <> _NumLinTransfer) OR (_NumTransfer = '') THEN _CantidadLinTrans += _LinTransfer."Qty. to Ship (Base)";
                UNTIL _LinTransfer.NEXT = 0;
        END;
    end;

    procedure BorradoEnvios(_NumEnvio: Code[20]);
    var
        _CabEnvio: Record "Warehouse Shipment Header";
        _LinEnvio: Record "Warehouse Shipment Line";
        _TempPedidos: Record "Inventory Buffer" temporary;
    begin
        _CabEnvio.GET(_NumEnvio);
        _LinEnvio.RESET;
        _LinEnvio.SETRANGE("No.", _NumEnvio);
        _LinEnvio.SETFILTER("Qty. to Ship", '<>%1', 0);
        IF NOT _LinEnvio.ISEMPTY THEN
            ERROR('Líneas enviadas al SGA pendientes de proceso')
        ELSE BEGIN
            _LinEnvio.RESET;
            IF _CabEnvio.Status = _CabEnvio.Status::Open THEN BEGIN
                _LinEnvio.SETRANGE("No.", _NumEnvio);
                IF _LinEnvio.FINDFIRST THEN BEGIN
                    IF (_LinEnvio."Source Type" = 39) AND (_LinEnvio."Source Subtype" = 5) THEN
                        DevCompraDocEnvio(_NumEnvio, TRUE)
                    ELSE IF (_LinEnvio."Source Type" = 37) AND (_LinEnvio."Source Subtype" = 1) THEN
                        PedVentaDocEnvio(_NumEnvio, TRUE);
                END;
            END
            ELSE
                ERROR('El envio esta lanzado');
        END;
    end;

    procedure BorradoPedTrans(_NumPedTrans: Code[20]);
    var
        _LinTransfer: Record "Transfer Line";
        _CabTransfer: Record "Transfer Header";
        _Location: Record Location;
        _Tipo: Integer;
        _TempTransferLne: Record "Transfer Line" temporary;
    begin
        _CabTransfer.GET(_NumPedTrans);
        _LinTransfer.RESET;
        _LinTransfer.SETRANGE("Document No.", _NumPedTrans);
        _LinTransfer.SETFILTER("Qty. to Ship", '<>%1', 0);
        IF NOT _LinTransfer.ISEMPTY THEN
            ERROR('Líneas enviadas al SGA pendientes de proceso')
        ELSE BEGIN
            _LinTransfer.RESET;
            _LinTransfer.SETRANGE("Document No.", _NumPedTrans);
            _LinTransfer.SETRANGE("Derived From Line No.", 0);
            IF _LinTransfer.FIND('-') THEN
                REPEAT
                    _TempTransferLne := _LinTransfer;
                    _TempTransferLne.INSERT;
                UNTIL _LinTransfer.NEXT = 0;
            IF _Location.GET(_CabTransfer."Transfer-from Code") AND _Location.SGA THEN
                _Tipo := 0
            ELSE
                _Tipo := 1;
            EnvioSGA(_CabTransfer, _Tipo, _TempTransferLne, TRUE);
        END;
    end;

    procedure GetPackagingLinesFromSalesShptHeader(SalesShipmentHeader: Record "Sales Shipment Header");
    var
        PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header";
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
    begin
        SalesShipmentHeader.TESTFIELD("No.");
        PostedWhseShipmentLine.RESET;
        PostedWhseShipmentLine.SETRANGE("Posted Source Document", PostedWhseShipmentLine."Posted Source Document"::"Posted Shipment");
        PostedWhseShipmentLine.SETRANGE("Posted Source No.", SalesShipmentHeader."No.");
        IF PostedWhseShipmentLine.FINDSET THEN BEGIN
            PostedWhseShipmentHeader.RESET;
            PostedWhseShipmentHeader.GET(PostedWhseShipmentLine."No.");
            Commit();
            IF PostedWhseShipmentHeader."No." <> '' THEN GetPackagingLines(PostedWhseShipmentHeader);
            Commit();
        END
        else
            PackingError := 'No se han encontrado líneas de entrega de almacén para el envío registrado ' + SalesShipmentHeader."No.";
    end;

    procedure GetPackagingLines(var PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header");
    var
        Error01: Label 'El envio no existe.';
        Error03: Label 'La cantidad a enviar es mayor que la cantidad.';
        Packaging: Record Packaging;
        PackagingLine: Record "Packaging Line";
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        Item: Record Item;
        PostedSourceNo: Code[20];
        PostedSourceType: Integer;
        SQLLanguage: Code[10];
        Apostrophe: Label '''';
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
        rlSalesShipmentHeader: Record "Sales Shipment Header";
        rlItemUnitofMeasure: Record "Item Unit of Measure";
        rlItem: Record Item;
    begin
        // Embalajes - De la tabla [TWO_BBTRENDS].[scm_custom].[BBT_W2E_PackingList]
        PostedWhseShipmentHeader.TESTFIELD("Whse. Shipment No.");
        PostedWhseShipmentLine.RESET;
        PostedWhseShipmentLine.SETRANGE("No.", PostedWhseShipmentHeader."No.");
        PostedWhseShipmentLine.FINDSET;
        REPEAT
            IF PostedSourceNo = '' THEN
                PostedSourceNo := PostedWhseShipmentLine."Posted Source No."
            ELSE IF PostedSourceNo <> PostedWhseShipmentLine."Posted Source No." THEN ERROR('Se han detectado diferentes documentos en el envío registrado ' + PostedWhseShipmentHeader."No.");
            Packaging.RESET;
            Packaging.SETRANGE("Source Type", PostedWhseShipmentLine."Source Type");
            Packaging.SETRANGE("Source No.", PostedWhseShipmentLine."Source No.");
            //Packaging.SETRANGE("Posted Source Type",PostedSourceType);
            Packaging.SETRANGE("Posted Source No.", PostedWhseShipmentLine."Posted Source No.");
            if Packaging.FindSet then
                Packaging.DeleteAll(TRUE);
        ////////exit;///////
        UNTIL PostedWhseShipmentLine.NEXT = 0;

        NoEntregaAlmacen := '';
        SQLLanguage := '5';
        // Primero recuperamos el nº entrega almacén
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'NumeroDocumento eq ' + Apostrophe + PostedWhseShipmentHeader."Whse. Shipment No." + Apostrophe);
        HttpCall(SGACallType::"Leer entrega almacen", SGAJsonObject);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for i := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, i);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('NumeroEntregaAlmacen', ValueText);
            NoEntregaAlmacen := ValueText;
        end;
        Clear(PackingError);
        PackagingInsertedModified := false;
        IF NoEntregaAlmacen <> '' THEN BEGIN // Buscamos los SSCC
            Clear(SGAJsonObject);
            Clear(ResponseTxt);
            SGAJsonObject.Add('filter', 'NumeroEntregaAlmacen eq ' + Apostrophe + NoEntregaAlmacen + Apostrophe);
            HttpCall(SGACallType::"Leer packing list", SGAJsonObject);
            //Read Json
            Clear(ArrayJSONManagement);
            Clear(ObjectJSONManagement);
            ArrayJSONManagement.InitializeCollection(ResponseTxt);
            for i := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
                SSCC := '';
                Weight := 0;
                Volume := 0;
                ItemNo := '';
                Qty := 0;
                TipoActivo := '';
                HojaRuta := '';
                ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, i);
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
                EVALUATE(Weight, WeightTxt);
                EVALUATE(Volume, VolumeTxt);
                EVALUATE(Qty, Qtytxt);
                if (SSCC <> '') AND (ItemNo <> '') AND (Qty <> 0) then begin
                    Item.RESET;
                    Item.GET(ItemNo);
                    PostedWhseShipmentLine.RESET;
                    PostedWhseShipmentLine.SETRANGE("No.", PostedWhseShipmentHeader."No.");
                    PostedWhseShipmentLine.SETRANGE("Item No.", ItemNo);
                    if PostedWhseShipmentLine.FINDSET then begin
                        CASE PostedWhseShipmentLine."Posted Source Document" OF
                            PostedWhseShipmentLine."Posted Source Document"::"Posted Shipment":
                                PostedSourceType := DATABASE::"Sales Shipment Line";
                            PostedWhseShipmentLine."Posted Source Document"::"Posted Return Shipment":
                                PostedSourceType := DATABASE::"Return Shipment Header";
                            PostedWhseShipmentLine."Posted Source Document"::"Posted Transfer Shipment":
                                PostedSourceType := DATABASE::"Transfer Shipment Header";
                            ELSE
                                ERROR('Opción no contemplada (' + PostedWhseShipmentLine.FIELDCAPTION("Posted Source Document") + ' ' + FORMAT(PostedWhseShipmentLine."Posted Source Document") + '). Por favor póngase en contacto con el administrador del sistema');
                        END;
                        Packaging.RESET;
                        IF NOT Packaging.GET(SSCC) THEN BEGIN
                            Packaging.INIT;
                            Packaging."No." := SSCC;
                            Packaging."Creation Date" := TODAY;
                            Packaging."Created by" := USERID;
                            Packaging."Location Code" := PostedWhseShipmentHeader."Location Code";
                            Packaging."Posted by" := '';
                            Packaging."Info Code" := Packaging."Info Code"::"50";
                            Packaging."Terms and Conditions Code" := Packaging."Terms and Conditions Code"::"1"; // Pagado por el proveedor
                            Packaging.Roadmap := HojaRuta;
                            CASE TipoActivo OF
                                'CAJ':
                                    Packaging."Type Code" := Packaging."Type Code"::CT;
                                ELSE
                                    Packaging."Type Code" := Packaging."Type Code"::"201";
                            END;
                            Packaging."Shipping Payment Responsible" := Packaging."Shipping Payment Responsible"::"3"; // Pagado por el proveedor
                            Packaging."Net Weight 1 (AAC)" := Weight;
                            Packaging."Net Weight Type" := Packaging."Net Weight Type"::" ";
                            Packaging."Net Weight UOM" := '';
                            Packaging."Gross Weight 1 (AAD)" := Weight; // PENDIENTE DEFINIR - ES EL MISMO QUE EL PESO DEL PRODUCTO? DEBERÍAMOS COGER EL PESO COMPLETO DE LAS LÍNEAS?
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
                            Packaging."Number of Boxes" := 0; // PENDIENTE DEFINIR
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

                            Packaging.INSERT(TRUE);
                        END;
                        Packaging.TESTFIELD("No.");
                        Packaging."Number of Boxes" += Qty;
                        //Packaging."Gross Weight 1 (AAD)" += Weight;
                        Packaging.MODIFY;

                        PackagingInsertedModified := true;
                        PackagingLine.RESET;
                        PackagingLine.SETRANGE("No.", Packaging."No.");
                        PackagingLine.SETRANGE("Item No.", ItemNo);
                        IF NOT PackagingLine.FINDSET THEN BEGIN
                            PackagingLine.RESET;
                            PackagingLine.SETRANGE("No.", Packaging."No.");
                            IF PackagingLine.FINDLAST THEN;
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
                            PackagingLine."Unit of Measure Code" := Item."Base Unit of Measure";

                            PackagingLine.INSERT(TRUE);
                        END;
                        PackagingLine.Quantity += Qty;
                        PackagingLine."Qty. (Base)" += Qty;
                        PackagingLine.MODIFY;
                        Commit();
                    end;
                end;
            end;
            if not PackagingInsertedModified then PackingError := 'No se han encontrado embalajes para la entrega de almacén ' + NoEntregaAlmacen;
        end else
            PackingError := 'No se ha encontrado una entrega de almacén para el envío registrado ' + PostedWhseShipmentHeader."No.";
    end;

    procedure AlmRegDevVenta(_CabVenta: Record "Sales Header") _error: Boolean;
    var
        _Almacen: Record Location;
        _LinVenta: Record "Sales Line";
        _Producto: Record Item;
    begin
        _error := FALSE;
        _LinVenta.RESET;
        _LinVenta.SETRANGE("Document Type", _CabVenta."Document Type");
        _LinVenta.SETRANGE("Document No.", _CabVenta."No.");
        _LinVenta.SETRANGE(Type, _LinVenta.Type::Item);
        _LinVenta.SETFILTER("Return Qty. to Receive", '<>%1', 0);
        IF _LinVenta.FINDSET THEN
            REPEAT
                _Producto.GET(_LinVenta."No.");
                _Almacen.GET(_LinVenta."Location Code");
                IF _CabVenta."Document Type" = _CabVenta."Document Type"::"Return Order" THEN BEGIN
                    IF _LinVenta."Shipment No." = '' THEN _error := _Almacen.SGA AND NOT (_Producto."No SGA management");
                END
                ELSE
                    _error := _Almacen.SGA AND NOT (_Producto."No SGA management");
            UNTIL (_LinVenta.NEXT = 0) OR _error;
    end;

    procedure LimpiarCamposError();
    var
        _IDBigTxt: Text;
        test: BigInteger;
    begin
        //Documentos
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'Resultado ne null and Resultado ne ''CORRECTO'' and Resultado ne ''''');
        HttpCall(SGACallType::"Leer campos error", SGAJsonObject);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for i := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, i);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('ROWID', ValueText);
            _IDBigTxt := ValueText;
            Clear(SGAJsonObject);
            SGAJsonObject.Add('FechaProcesoEnlace', '');
            SGAJsonObject.Add('Resultado', '');
            SGAJsonObject.Add('RowId', _IDBigTxt);
            HttpCall(SGACallType::"Actualizar documento", SGAJsonObject);
        end;
        //Stock
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'Resultado ne ''CORRECTO'' and Resultado ne ''''');
        HttpCall(SGACallType::"Leer campos error stock", SGAJsonObject);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for i := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            test := ArrayJSONManagement.GetCollectionCount();
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, i);
            ObjectJSONManagement.InitializeObject(BloqueoDocumentoJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('ROWID', ValueText);
            _IDBigTxt := ValueText;
            Clear(SGAJsonObject);
            SGAJsonObject.Add('FechaProcesoEnlace', '');
            SGAJsonObject.Add('Resultado', '');
            SGAJsonObject.Add('RowId', _IDBigTxt);
            HttpCall(SGACallType::"Actualizar ajustes stock", SGAJsonObject);
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

        LogNAVSGAErrors: Record "Log NAVSGA Errors";
        x: Integer;
        y: Integer;
        _NoDoc: Text[20];
        _Resultado: Text[2000];
        _FechaAltaTxt: Text[20];
        _FechaProcesoTxt: Text[20];
    begin
        // Marcamos todas las lineas como corregidas
        LogNAVSGAErrors.MODIFYALL(Corrected, TRUE);
        //Documentos
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'Resultado ne null and Resultado ne ''CORRECTO'' and Resultado ne '''' and IdEmpresaERP eq ''' + CompanyName + '''');
        //SGAJsonObject.Add('filter', (Resultado eq null or Resultado eq '''')'); 
        HttpCall(SGACallType::"Leer campos error", SGAJsonObject);
        //Read Json
        Clear(ArrayJSONManagement);
        Clear(ObjectJSONManagement);
        ArrayJSONManagement.InitializeCollection(ResponseTxt);
        for i := 0 to ArrayJSONManagement.GetCollectionCount() - 1 do begin
            ArrayJSONManagement.GetObjectFromCollectionByIndex(BloqueoDocumentoJsonObject, i);
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
            LogNAVSGAErrors.SETRANGE("Document No.", _NoDoc);
            //LogNAVSGAErrors.SETRANGE(Corrected,LogNAVSGAErrors.Corrected::YES);
            IF LogNAVSGAErrors.FINDFIRST THEN BEGIN
                LogNAVSGAErrors."Description  Error" := _Resultado;
                EVALUATE(LogNAVSGAErrors."Posting Date", _FechaAltaTxt);
                EVALUATE(LogNAVSGAErrors."Last Date", _FechaProcesoTxt);
                LogNAVSGAErrors.Corrected := FALSE;
                LogNAVSGAErrors.MODIFY;
            END
            ELSE BEGIN
                LogNAVSGAErrors.INIT;
                NoSeriesLine.SETRANGE("Series Code", 'SGAERROR');
                IF NoSeriesLine.FINDFIRST THEN begin
                    //>> Obsoleto V27
                    //NoSeriesManagement.InitSeries(NoSeriesLine."Series Code", LogNAVSGAErrors."No. Series", TODAY, LogNAVSGAErrors."No.", LogNAVSGAErrors."No. Series");
                    //
                    _NoSeriesCode := NoSeriesLine."Series Code";
                    if NoSeries.AreRelated(NoSeriesLine."Series Code", EmptySerialCode) then
                        _NoSeriesCode := EmptySerialCode;
                    _NoSerie := NoSeries.GetNextNo(_NoSeriesCode, Today);
                    //<<
                end;
                LogNAVSGAErrors."No. Series" := _NoSeriesCode;
                LogNAVSGAErrors."No." := _NoSerie;
                LogNAVSGAErrors."Document No." := _NoDoc;
                LogNAVSGAErrors."Description  Error" := _Resultado;
                EVALUATE(LogNAVSGAErrors."Posting Date", _FechaAltaTxt);
                EVALUATE(LogNAVSGAErrors."Last Date", _FechaProcesoTxt);
                LogNAVSGAErrors.Corrected := FALSE;
                LogNAVSGAErrors.INSERT;
            END;
        END;
    end;

    procedure GetPackingError(): text
    begin
        exit(PackingError);
    end;

    local procedure getLastJournalLine(JournalTemplateName: Code[10]; JournalBatchName: code[10]): Integer
    var
        ItemJournalLine: Record "Item Journal Line";
    begin
        clear(ItemJournalLine);
        ItemJournalLine.setrange("Journal Template Name", JournalTemplateName);
        ItemJournalLine.SetRange("Journal Batch Name", JournalBatchName);
        IF ItemJournalLine.FindLast() then
            exit(ItemJournalLine."Line No." + 10000)
        else
            exit(10000);
    end;
}
