codeunit 51450 "SGA Management"
{
    trigger OnRun();
    begin
    end;

    //>> Generics Procedures
    procedure IsSGAEnabled(): Boolean
    var
        rSGASetup: record "SGA Setup";
    begin
        rSGASetup.Reset();
        rSGASetup.Get();
        if rSGASetup."SGA Enabled" then
            exit(true)
        else
            exit(false);
    end;

    procedure InitializeSGAConfiguration(var pSGASetUp: Record "SGA Setup")
    begin
        pSGASetUp.Reset();
        pSGASetUp.Get();
    end;

    procedure SGAWarehouse(pWarehouseCode: Code[10]): Boolean;
    var
        rLocation: Record Location;
    begin
        if rLocation.Get(pWarehouseCode) then
            exit(rLocation."SGA Enabled")
        else
            exit(false);
    end;

    procedure ReemplazarCaracter(var _Texto: Text[250]; _Reemplazar: Text[1]; _Por: Text[1]);
    begin
        _Texto := _Texto.Replace(_Reemplazar, _Por);
    end;

    procedure GetFechaHoraTrabajo(): DateTime;
    var
        _FechaTrabajoDT: DateTime;
        ReturnDate: DateTime;
    begin
        _FechaTrabajoDT := CREATEDATETIME(WORKDATE, TIME);
        exit(_FechaTrabajoDT); //2018-07-16 12:23:50.000
    end;

    procedure ConverTextoADecimal(_NumerodecimalTXT: Text[25]; var _NumeroDecimal: Decimal): Boolean;
    begin
        _NumeroDecimal := 0;
        _NumerodecimalTXT := DELCHR(_NumerodecimalTXT, '=', ',');
        ReemplazarCaracter(_NumerodecimalTXT, '.', ',');
        if NOT Evaluate(_NumeroDecimal, _NumerodecimalTXT) then EXIT(false);
    end;

    Procedure ConvertDecimalAEntero(pDecimal: Decimal): Integer;
    begin
        exit(round(pDecimal, 1))
    end;

    procedure CalcularEAN(pCodigo: Code[13]; pTipo: Option EAN13,EAN14): Code[14];
    var
        Codi: Code[13];
        Cadena: Text[100];
        Ean: Code[14];
        Mascara: Text[13];
        Control: Code[1];
        Tipo: Option EAN13,EAN14;
        LongCodigo: Integer;
    begin
        Codi := pCodigo;
        Cadena := 'abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZ\/-_.,:;+ ';
        Ean := DELCHR(Codi, '=', Cadena);
        if pTipo = pTipo::EAN13 then
            LongCodigo := 12
        else
            LongCodigo := 13;
        if STRLEN(Ean) < LongCodigo then Error('El código debe de ser de' + FORMAT(LongCodigo) + ' dígitos');
        if pTipo = pTipo::EAN13 then
            Mascara := '131313131313'
        else
            Mascara := '3131313131313';
        Control := format(StrCheckSum(Ean, Mascara));
        Ean := Ean + Control;
        EXIT(Ean);
    end;
    //<<

    //>> Comprobaciones 
    procedure SGACantUseLocation(pLocationCode: Code[10]): Boolean
    var
        rLocation: Record Location;
    begin
        rLocation.Reset();
        if rLocation.Get(pLocationCode) then
            exit(not rLocation."SGA Enabled")
        else
            exit(true)
    end;

    procedure AlmRegDevVenta(pSalesHeader: Record "Sales Header") pError: Boolean;
    var
        rLocation: Record Location;
        rSalesLine: Record "Sales Line";
        rItem: Record Item;
    begin
        pError := false;
        rSalesLine.Reset();
        rSalesLine.SetRange("Document Type", pSalesHeader."Document Type");
        rSalesLine.SetRange("Document No.", pSalesHeader."No.");
        rSalesLine.SetRange(Type, rSalesLine.Type::Item);
        rSalesLine.SetFilter("Return Qty. to Receive", '<>%1', 0);
        if rSalesLine.Findset() then
            repeat
                rItem.Get(rSalesLine."No.");
                rLocation.Get(rSalesLine."Location Code");
                if pSalesHeader."Document Type" = pSalesHeader."Document Type"::"Return Order" then begin
                    if rSalesLine."Shipment No." = '' then pError := rLocation."SGA Enabled" AND rItem."SGA Item Management";
                end
                else
                    pError := rLocation."SGA Enabled" AND rItem."SGA Item Management";
            until (rSalesLine.Next() = 0) OR pError;
    end;

    procedure AlmRegManualDiario(pLindiarioProducto: Record "Item Journal Line") pError: Boolean;
    var
        rLinDiarioLocal: Record "Item Journal Line";
        rAlmacen: Record Location;
    begin
        pError := false;
        rLinDiarioLocal.Reset();
        rLinDiarioLocal.SetRange("Journal Template Name", pLindiarioProducto."Journal Template Name");
        rLinDiarioLocal.SetRange("Journal Batch Name", pLindiarioProducto."Journal Batch Name");
        if rLinDiarioLocal.Findset() then
            repeat
                if rAlmacen.Get(rLinDiarioLocal."Location Code") then pError := rAlmacen."SGA Enabled";
            until (rLinDiarioLocal.Next() = 0) or pError;
        EXIT(pError);
    end;

    procedure AlmRegPedCompra(rPurchaseHeader: Record "Purchase Header") pError: Boolean;
    var
        rAlmacen: Record Location;
        rPurchaseLine: Record "Purchase Line";
        rItem: Record Item;
    begin
        pError := false;
        rPurchaseLine.Reset();
        rPurchaseLine.SetRange("Document Type", rPurchaseHeader."Document Type");
        rPurchaseLine.SetRange("Document No.", rPurchaseHeader."No.");
        rPurchaseLine.SetRange(Type, rPurchaseLine.Type::Item);
        rPurchaseLine.SetFilter("Qty. to Receive", '<>%1', 0);
        if rPurchaseLine.Findset() then
            repeat
                rItem.Get(rPurchaseLine."No.");
                rAlmacen.Get(rPurchaseLine."Location Code");
                if rPurchaseHeader."Document Type" = rPurchaseHeader."Document Type"::Invoice then begin
                    if rPurchaseLine."Receipt No." = '' then pError := rAlmacen."SGA Enabled" AND rItem."SGA Item Management";
                end
                else
                    pError := rAlmacen."SGA Enabled" AND rItem."SGA Item Management";
            until (rPurchaseLine.Next() = 0) OR pError;
    end;

    procedure CheckStockShipment(pNumEnvio: Code[20]);
    var
        rWarehouseShipmentLine: Record "Warehouse Shipment Line";
        rItem: Record Item;
        CantidadLinEnvio: Decimal;
        CantidadLinTransfer: Decimal;
        Error01: Label 'Insufficient product stock %1 in warehouse %2. Quantity to ship %3, quantity in stock %4',
                Comment = 'Existencia infuficiente del producto %1 en almacén %2. Cantidad a enviar %3, cantidad disponible %4';
    begin
        rWarehouseShipmentLine.Reset();
        rWarehouseShipmentLine.SetRange("No.", pNumEnvio);
        rWarehouseShipmentLine.SetFilter("Qty. to Ship (Base)", '<>%1', 0);
        if rWarehouseShipmentLine.Findset() then
            repeat
                CantidadLinEnvio := 0;
                CantidadLinTransfer := 0;
                if rItem.Get(rWarehouseShipmentLine."Item No.") then begin
                    rItem.SetRange("Location Filter", rWarehouseShipmentLine."Location Code");
                    rItem.CalcFields(Inventory);
                    CantidadLinEnvio := QuantityInShipments(pNumenvio, rItem."No.", rWarehouseShipmentLine."Location Code", rWarehouseShipmentLine."Line No.");
                    CantidadLinTransfer := QuantityInTransfers('', rItem."No.", rWarehouseShipmentLine."Location Code", 0);
                    if (rItem.Inventory - CantidadLinEnvio - CantidadLinTransfer) < rWarehouseShipmentLine."Qty. to Ship (Base)" then
                        Error(Error01, rItem."No.", rWarehouseShipmentLine."Location Code", rWarehouseShipmentLine."Qty. to Ship (Base)",
                                    rItem.Inventory - CantidadLinEnvio - CantidadLinTransfer);
                end;
            until rWarehouseShipmentLine.Next() = 0;
    end;

    procedure CheckStockTransfer(pNumTransfer: Code[20]);
    var
        rItem: Record Item;
        //rWarehouseShipmentLine: Record "Warehouse Shipment Line";
        rTransferLine: Record "Transfer Line";
        //rTransferLine2: Record "Transfer Line";
        rLocation: Record Location;
        CantidadLinEnvio: Decimal;
        CantidadLinTransfer: Decimal;
        Error01: Label 'Insufficient stock of product %1 in warehouse %2. Quantity to be shipped %3, quantity available %4',
                Comment = 'ESP="Existencia infuficiente del producto %1 en almacén %2. Cantidad a enviar %3, cantidad disponible %4"';
    begin
        rTransferLine.Reset();
        rTransferLine.SetRange("Document No.", pNumTransfer);
        rTransferLine.SetFilter("Qty. to Ship (Base)", '<>%1', 0);
        if rTransferLine.Findset() then
            repeat
                rLocation.Get(rTransferLine."Transfer-from Code");
                CantidadLinEnvio := 0;
                CantidadLinTransfer := 0;
                if rLocation."SGA Enabled" then begin
                    if rItem.Get(rTransferLine."Item No.") then begin
                        rItem.SetRange("Location Filter", rTransferLine."Transfer-from Code");
                        rItem.CALCFIELDS(Inventory);
                        rLocation.Get(rTransferLine."Transfer-from Code");
                        CantidadLinEnvio := QuantityInShipments('', rItem."No.", rTransferLine."Transfer-from Code", 0);
                        CantidadLinTransfer := QuantityInTransfers(pNumTransfer, rItem."No.", rTransferLine."Transfer-from Code", rTransferLine."Line No.");
                        if (rItem.Inventory - CantidadLinEnvio - CantidadLinTransfer) < rTransferLine."Qty. to Ship (Base)" then
                            Error(Error01, rItem."No.", rTransferLine."Transfer-from Code", rTransferLine."Qty. to Ship (Base)",
                                        rItem.Inventory - CantidadLinEnvio - CantidadLinTransfer);
                    end;
                end;
            until rTransferLine.Next() = 0;
    end;

    local procedure QuantityInShipments(pNumEnvio: Code[20]; pCodProducto: Code[20]; pAlmacen: Code[10]; pNumLinEnvio: Integer) pCantidadLinEnvio: Decimal;
    var
        rWarehouseShipmentLine: Record "Warehouse Shipment Line";
    begin
        Clear(pCantidadLinEnvio);
        rWarehouseShipmentLine.Reset();
        rWarehouseShipmentLine.SETFILTER("Qty. to Ship (Base)", '<>%1', 0);
        rWarehouseShipmentLine.SETFILTER("SGA Status", '<>%1', rWarehouseShipmentLine."SGA Status"::" ");
        rWarehouseShipmentLine.SETRANGE("Item No.", pCodProducto);
        rWarehouseShipmentLine.SETRANGE("Location Code", pAlmacen);
        if rWarehouseShipmentLine.FindSet() then
            repeat
                if (rWarehouseShipmentLine."No." <> pNumEnvio) OR (rWarehouseShipmentLine."Line No." <> pNumLinEnvio) OR (pNumEnvio = '') then
                    pCantidadLinEnvio += rWarehouseShipmentLine."Qty. to Ship (Base)";
            until rWarehouseShipmentLine.Next() = 0;
    end;

    local procedure QuantityInTransfers(pNumTransfer: Code[20]; pCodProducto: Code[20]; pAlmacen: Code[10]; pNumLinTransfer: Integer) pCantidadLinTrans: Decimal;
    var
        rTransferLine: Record "Transfer Line";
        rLocation: Record Location;
    begin
        Clear(pCantidadLinTrans);
        rLocation.get(pAlmacen);
        if rLocation."SGA Enabled" then begin
            rTransferLine.Reset();
            rTransferLine.SETFILTER("Qty. to Ship (Base)", '<>%1', 0);
            //rTransferLine.SETFILTER("SGA Status", '<>%1', rTransferLine."SGA Status"::" ");
            rTransferLine.SETRANGE("Item No.", pCodProducto);
            rTransferLine.SETRANGE("Transfer-from Code", pAlmacen);
            if rTransferLine.FINDSET then
                repeat
                    if (rTransferLine."Document No." <> pNumTransfer) OR (rTransferLine."Line No." <> pNumLinTransfer) OR (pNumTransfer = '') then
                        pCantidadLinTrans += rTransferLine."Qty. to Ship (Base)";
                until rTransferLine.Next() = 0;
        end;
    end;
    //<<

    //>> BC <<==>> SQLs Procedures
    procedure HttpCall(pSGACallProcedure: Enum "SGA Call to Procedure"; pSGAJsonObject: JsonObject; var pResponseTxt: Text)
    var
        rSGASetup: record "SGA Setup";
        ClientHttp: HttpClient;
        RequestHeaders: HttpHeaders;
        RequestContent: HttpContent;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        contentHeaders: HttpHeaders;
        RequestURL: text;
        Body: text;

    begin
        InitializeSGAConfiguration(rSGASetup);

        Clear(ClientHttp);
        Clear(RequestHeaders);
        Clear(RequestContent);
        Clear(contentHeaders);
        case pSGACallProcedure of
            pSGACallProcedure::"Document Blocking":                 // Value 0
                begin
                    RequestURL := rSGASetup."SGA Document Block Endp";
                end;
            pSGACallProcedure::"Insert Product":                    // Value 1
                begin
                    RequestURL := rSGASetup."SGA Insert Item Endp";
                end;
            pSGACallProcedure::"Purchase Order Management":         // Value 2 
                begin
                    RequestURL := rSGASetup."SGA Purch Order Mngmnt Endp";
                end;
            pSGACallProcedure::"Purchase Order Receipt":            // Value 3
                begin
                    RequestURL := rSGASetup."SGA Purchase Order Recep Endp";
                end;
            pSGACallProcedure::"Update Document":                   // Value 4
                begin
                    RequestURL := rSGASetup."SGA Update Document Endp";
                end;
            pSGACallProcedure::"Shipping Document":                 // Value 5
                begin
                    RequestURL := rSGASetup."SGA Shipment Document Endp";
                end;
            pSGACallProcedure::"Sales Order Delivery Note":         // Value 6
                begin
                    RequestURL := rSGASetup."SGA Shipment Sales Order Endp";
                end;
            pSGACallProcedure::"Read Dispatched Deliveries":        // Value 7
                begin
                    RequestURL := rSGASetup."SGA Read Exped Shipment Endp";
                end;
            pSGACallProcedure::"Update Shipped Deliveries":         // Value 8
                begin
                    RequestURL := rSGASetup."SGA Update Exped shipment Endp";
                end;
            pSGACallProcedure::"Insert Sales Return":               // Value 9
                begin
                    RequestURL := rSGASetup."SGA Insert SalesReturn Endp"
                end;
            pSGACallProcedure::"Read Sales Return Receipt":         // Value 10
                begin
                    RequestURL := rSGASetup."SGA Read Recp SalesReturn Endp"
                end;
            pSGACallProcedure::"Insert Transfer Order":             // Value 11
                begin
                    RequestURL := rSGASetup."SGA Insert Transfer Order Endp";
                end;
            pSGACallProcedure::"Read Transfer Order":               // Value 12
                begin
                    RequestURL := rSGASetup."SGA Read Transfer Order Endp";
                end;
            pSGACallProcedure::"Read Stock Adjustments":            // Value 13
                begin
                    RequestURL := rSGASetup."SGA Read Stock Adjust Endp";
                end;
            pSGACallProcedure::"Update Stock Adjustments":          // Value 14
                begin
                    RequestURL := rSGASetup."SGA Update Stock Adjust Endp";
                end;
            pSGACallProcedure::"Read Stock Inventory Reconciliation": // Value 15
                begin
                    RequestURL := '';       // ????????????
                end;
            pSGACallProcedure::"Read Delivery Note Confirmation":   // Value 16
                begin
                    RequestURL := rSGASetup."SGA Read Shipment Confirm Endp";
                end;
            pSGACallProcedure::"Insert Delivery Note Confirmation": // Value 17
                begin
                    RequestURL := rSGASetup."SGA Insert Shipm Confirm Endp";
                end;
            pSGACallProcedure::"Insert Purchase Return":            // Value 18
                begin
                    RequestURL := rSGASetup."SGA Insert Pur Return Ord Endp";
                end;
            pSGACallProcedure::"Read Purchase Return":              // Value 19
                begin
                    RequestURL := rSGASetup."SGA Read Pur Return Order Endp";
                end;
            pSGACallProcedure::"Read Warehouse Delivery":           // Value 20
                begin
                    RequestURL := rSGASetup."SGA Read Location Entry Endp";
                end;
            pSGACallProcedure::"Read packing list":                 // Value 21
                begin
                    RequestURL := rSGASetup."SGA Read Packing List Endp";
                end;
            pSGACallProcedure::"Read Error Fields":                 // Value 22
                begin
                    RequestURL := rSGASetup."SGA Read Error Fields Endp";
                end;
            pSGACallProcedure::"Read Stock Error Fields":           // Value 23
                begin
                    RequestURL := rSGASetup."SGA Read Err Fields Stock Endp";
                end;
        end;
        RequestHeaders := ClientHttp.DefaultRequestHeaders();
        pSGAJsonObject.WriteTo(Body);
        RequestContent.WriteFrom(Body);
        RequestContent.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');
        ClientHttp.Post(RequestURL, RequestContent, ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode then begin
            ResponseMessage.Content.ReadAs(pResponseTxt);
            Error(pResponseTxt);
        end;
        ResponseMessage.Content.ReadAs(pResponseTxt);
    end;
    //<<
}