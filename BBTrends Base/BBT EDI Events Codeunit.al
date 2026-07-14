codeunit 50008 "BBT EDI Events"
{
    //>> Subscribcion evento OnAfterInsertPostedHeaders para documentar el registro EDI 
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnAfterInsertPostedHeaders', '', false, false)]
    local procedure OnAfterInsertPostedHeaders(SalesHeader: Record "Sales Header"; var ReceiptHeader: Record "Return Receipt Header"; var SalesCrMemoHdr: Record "Sales Cr.Memo Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesShipmentHeader: Record "Sales Shipment Header")
    var
        Location: Record Location;
        Customer: Record Customer;
    begin
        PostEDIInfo(SalesHeader, SalesShipmentHeader, SalesInvoiceHeader);
    end;

    LOCAL PROCEDURE PostEDIInfo(SalesHeader: Record "Sales Header"; var SalesShptHeader: Record "Sales Shipment Header"; var SalesInvHeader: Record "Sales Invoice Header");
    VAR
        EDIDocumentinterlocutor: Record "EDI - Document interlocutor";
        EDITaxLine: Record "EDI - Tax Line";
        EDIDocumentinstallment: Record "EDI - Document installment";
        CompanyInformation: Record "Company Information";
    BEGIN
        CompanyInformation.RESET;
        CompanyInformation.GET;
        IF CompanyInformation."EDI ID" = '' THEN EXIT;
        SalesHeader.TESTFIELD("No.");
        PostPackagings(SalesHeader, SalesShptHeader);
        IF NOT (SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice]) THEN EXIT;
        // Informacián de las partes
        EDIDocumentinterlocutor.RESET;
        EDIDocumentinterlocutor.SETRANGE("Document Type", EDIDocumentinterlocutor."Document Type"::Order);
        EDIDocumentinterlocutor.SETRANGE("Document No.", SalesHeader."No.");
        IF EDIDocumentinterlocutor.FINDSET THEN
            REPEAT
                IF SalesShptHeader."No." <> '' THEN BEGIN
                    EDIDocumentinterlocutor."Document Type" := EDIDocumentinterlocutor."Document Type"::Shipment;
                    EDIDocumentinterlocutor."Document No." := SalesShptHeader."No.";
                    EDIDocumentinterlocutor.INSERT(TRUE);
                END;
                IF SalesInvHeader."No." <> '' THEN BEGIN
                    EDIDocumentinterlocutor."Document Type" := EDIDocumentinterlocutor."Document Type"::Invoice;
                    EDIDocumentinterlocutor."Document No." := SalesInvHeader."No.";
                    EDIDocumentinterlocutor.INSERT(TRUE);
                END;
            UNTIL EDIDocumentinterlocutor.NEXT = 0;
        // Informacián de IVA - No la utilizaremos en la emisián de fichero expediciones, al tirar por el estándar
        // Lo traspasamos con fines consultivos
        EDITaxLine.RESET;
        EDITaxLine.SETRANGE("Document Type", EDITaxLine."Document Type"::Order);
        EDITaxLine.SETRANGE("Document No.", SalesHeader."No.");
        IF EDITaxLine.FINDSET THEN
            REPEAT
                IF SalesShptHeader."No." <> '' THEN BEGIN
                    EDITaxLine."Document Type" := EDITaxLine."Document Type"::Shipment;
                    EDITaxLine."Document No." := SalesShptHeader."No.";
                    EDITaxLine.INSERT(TRUE);
                END;
                IF SalesInvHeader."No." <> '' THEN BEGIN
                    EDITaxLine."Document Type" := EDITaxLine."Document Type"::Invoice;
                    EDITaxLine."Document No." := SalesInvHeader."No.";
                    EDITaxLine.INSERT(TRUE);
                END;
            UNTIL EDITaxLine.NEXT = 0;
        // Informacián de vencimientos - No la utilizaremos en la emisián de fichero expediciones, al tirar por el estándar
        // Lo traspasamos con fines consultivos
        EDIDocumentinstallment.RESET;
        EDIDocumentinstallment.SETRANGE("Document Type", EDIDocumentinstallment."Document Type"::Order);
        EDIDocumentinstallment.SETRANGE("Document No.", SalesHeader."No.");
        IF EDIDocumentinstallment.FINDSET THEN
            REPEAT
                IF SalesShptHeader."No." <> '' THEN BEGIN
                    EDIDocumentinstallment."Document Type" := EDIDocumentinstallment."Document Type"::Shipment;
                    EDIDocumentinstallment."Document No." := SalesShptHeader."No.";
                    EDIDocumentinstallment.INSERT(TRUE);
                END;
                IF SalesInvHeader."No." <> '' THEN BEGIN
                    EDIDocumentinstallment."Document Type" := EDIDocumentinstallment."Document Type"::Invoice;
                    EDIDocumentinstallment."Document No." := SalesInvHeader."No.";
                    EDIDocumentinstallment.INSERT(TRUE);
                END;
            UNTIL EDIDocumentinstallment.NEXT = 0;
    END;

    LOCAL PROCEDURE PostPackagings(SalesHeader: Record "Sales Header"; var SalesShptHeader: Record "Sales Shipment Header");
    VAR
        Packaging: Record Packaging;
    BEGIN
        IF SalesShptHeader."No." = '' THEN EXIT;
        Packaging.RESET;
        Packaging.SETRANGE("Source Type", DATABASE::"Sales Line");
        Packaging.SETRANGE("Source No.", SalesHeader."No.");
        Packaging.SETRANGE("Posted Source No.", '');
        Packaging.MODIFYALL("Posting Date", SalesShptHeader."Posting Date");
        Packaging.MODIFYALL("Posted by", USERID);
        Packaging.MODIFYALL("Posted Source Type", DATABASE::"Sales Shipment Line");
        Packaging.MODIFYALL("Posted Source No.", SalesShptHeader."No.");
    END;
    //<<

    //>>  Suscripcion al evento de registro de ventas para crear la entrada en los movimientos EDI 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', true, true)]
    local procedure BBTOnAfterPostSalesDoc(SalesInvHdrNo: Code[20]; SalesShptHdrNo: Code[20])
    var
        cuEDIFilesManagement: Codeunit "BBT EDI Files Management";
        rSalesShipmentHeader: record "Sales Shipment Header";
        rSalesInvoiceHeader: record "Sales Invoice Header";
    begin
        if SalesShptHdrNo <> '' then begin
            rSalesShipmentHeader.Reset();
            rSalesShipmentHeader.SetRange("No.", SalesShptHdrNo);
            if rSalesShipmentHeader.Findfirst then
                cuEDIFilesManagement.CreateShipmentEDIEntry(rSalesShipmentHeader);
        End;
        if SalesInvHdrNo <> '' then begin
            rSalesInvoiceHeader.Reset();
            rSalesInvoiceHeader.SetRange("No.", SalesInvHdrNo);
            if rSalesInvoiceHeader.Findfirst then
                cuEDIFilesManagement.CreateInvoiceEDIEntry(rSalesInvoiceHeader);
        end
    end;
    //<<

    //>> BBT 01/07/2025. OBSOLETO.
    /*
        //>> Suscripcion al evento del alta del albaran de ventas para crear la entrada en los movimientos EDI 
        [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnAfterSalesShptHeaderInsert', '', false, false)]
        local procedure OnAfterSalesShptHeaderInsert(var SalesShipmentHeader: Record "Sales Shipment Header")
        var
            EDIFileprocessing: Codeunit "EDI - File processing v2 OBS";
        begin
            EDIFileprocessing.CreateShipmentEDIEntry(SalesShipmentHeader); //EDI-001>< 
        end;
        //<<
    */
    //<<
    //>> BBT 01/07/2025. OBSOLETO.
    /*
        //>> Suscripcion al evento de la fcatura de ventas para crear la entrada en los movimientos EDI 
        [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnAfterSalesInvHeaderInsert', '', false, false)]
        local procedure OnAfterSalesInvHeaderInsert(CommitIsSuppressed: Boolean; var SalesInvHeader: Record "Sales Invoice Header")
        var
            EDIFileprocessing: Codeunit "EDI - File processing v2 OBS";
        begin
            EDIFileprocessing.CreateInvoiceEDIEntry(SalesInvHeader); //EDI-001>< 
        end;
        //<<
    */
    //<<

    //>> Comprobamos que existan los bultos. Es imprescindible para los envios de albaranes en EDI.
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnAfterCheckMandatoryFields', '', false, false)]
    local procedure OnAfterCheckMandatoryFields(var SalesHeader: Record "Sales Header")
    var
        Location: Record Location;
    begin
        CheckPackagings(SalesHeader); //EDI-001><
        SalesHeader."Sales Shipment No." := ''; //BBTRENDS><
    end;

    LOCAL PROCEDURE CheckPackagings(VAR SalesHeader: Record "Sales Header");
    VAR
        SalesLine: Record "Sales Line";
        Location: Record Location;
        Packaging: Record Packaging;
        PackagingLine: Record "Packaging Line";
    BEGIN
        IF SalesHeader.ISTEMPORARY THEN EXIT;
        IF SalesHeader."Exclude packaging enforcement" THEN EXIT;
        IF SalesHeader.Ship AND (NOT SalesHeader.IsCreditDocType2) THEN BEGIN
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
            SalesLine.SETRANGE("Document No.", SalesHeader."No.");
            SalesLine.SETRANGE(Type, SalesLine.Type::Item);
            SalesLine.SETFILTER("Qty. to Ship", '>0');
            IF SalesLine.FINDSET THEN
                REPEAT
                    Location.RESET;
                    IF SalesLine."Location Code" <> '' THEN Location.GET(SalesLine."Location Code");
                    PackagingLine.RESET;
                    //PackagingLine.SETRANGE("Posted Source No.",'');
                    PackagingLine.SETRANGE("Source No.", SalesLine."Document No.");
                    PackagingLine.SETRANGE("Source Line No.", SalesLine."Line No.");
                    IF (Location."Sales Shpt.Packaging Mandatory") AND PackagingLine.FINDSET THEN BEGIN // Comprobamos coherencia en distribución de embalajes
                        IF PackagingLine.CalcPackedQty <> PackagingLine.CalcSourceDocQty THEN ERROR('Debe embalar todas la cantidad de producto del documento ' + FORMAT(SalesHeader."Document Type") + ' ' + SalesHeader."No.");
                    END
                    ELSE IF Location."Sales Shpt.Packaging Mandatory" THEN ERROR('Debe especificar los embalajes antes de continuar');
                UNTIL SalesLine.NEXT = 0;
        END;
    END;
    //<<

    //>> Documentar el número de albarán en los pedidos/facturas 
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnBeforeCalcInvoice', '', false, false)]
    local procedure OnBeforeCalcInvoice(SalesHeader: Record "Sales Header")
    var
        Location: Record Location;
        Customer: Record Customer;
    begin
        Customer.RESET;
        Customer.SETRANGE("No.", SalesHeader."Sell-to Customer No.");
        IF Customer.FINDFIRST THEN
            IF NOT Customer."No EDI" THEN
                AddSalesShipmentNo(SalesHeader);
    end;

    PROCEDURE AddSalesShipmentNo(VAR SalesHeader: Record 36);
    VAR
        SalesLine: Record 37;
        SalesShipmentLine: Record 111;
    begin
        SalesHeader.TESTFIELD("Sales Shipment No.", '');
        IF (SalesHeader."Document Type" IN [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::Order]) THEN begin
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
            SalesLine.SETRANGE("Document No.", SalesHeader."No.");
            SalesLine.SETFILTER(Quantity, '<>0');
            CASE SalesHeader."Document Type" OF
                SalesHeader."Document Type"::Order:
                    BEGIN
                        SalesLine.SETFILTER("Qty. to Invoice", '<>0');
                        SalesLine.SETFILTER("Qty. Shipped Not Invoiced", '<>0');
                        IF SalesLine.FINDSET THEN
                            REPEAT
                                SalesShipmentLine.RESET;
                                SalesShipmentLine.SETRANGE("Order No.", SalesLine."Document No.");
                                SalesShipmentLine.SETRANGE("Order Line No.", SalesLine."Line No.");
                                SalesShipmentLine.SETFILTER("Qty. Shipped Not Invoiced", '<>0');
                                SalesShipmentLine.FINDSET;
                                REPEAT
                                    IF (SalesHeader."Sales Shipment No." <> '') AND (SalesHeader."Sales Shipment No." <> SalesShipmentLine."Document No.") THEN
                                        ERROR('Esta factura del pedido ' + SalesHeader."No." + ' contiene más de un albarán');
                                    SalesHeader."Sales Shipment No." := SalesShipmentLine."Document No.";
                                UNTIL SalesShipmentLine.NEXT = 0;
                            UNTIL SalesLine.NEXT = 0;
                    END;
                SalesHeader."Document Type"::Invoice:
                    BEGIN
                        SalesLine.SETFILTER("Shipment No.", '<>%1', '');
                        IF SalesLine.FINDSET THEN
                            REPEAT
                                IF (SalesHeader."Sales Shipment No." <> '') AND (SalesHeader."Sales Shipment No." <> SalesLine."Shipment No.") THEN
                                    ERROR('Esta factura contiene más de un albarán');
                                SalesHeader."Sales Shipment No." := SalesLine."Shipment No.";
                            UNTIL SalesLine.NEXT = 0;
                    END;
                ELSE
                    ERROR('Ha ocurrido un error inesperado. Por favor pongase en contacto con el administrador del sistema');
            END;
        END;
    end;
    //<<

}