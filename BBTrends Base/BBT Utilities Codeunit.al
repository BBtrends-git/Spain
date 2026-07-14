Codeunit 51100 "BBT Utilities Codeunit"
{
    Permissions = TableData "Sales Shipment Header" = rimd;
    TableNo = "Job Queue Entry";

    var
        ResultText: text;
        TransportistasCallType: Enum "Transportistas Call Type";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        CommunicationStatus: Option " ",Success,Error;


    trigger OnRun()
    var

    begin

        case Rec."Parameter String" of

            'UPDTRACKING-ECI':
                UpdateTrackingECI;              // Actualizar tracking MarketPlace ECI
            'GETTRACKING-SZX':
                ObtenerTrackingSZX;             // Obtener Tracking de SZENDEX
            'DOCEXPEDITION-SZX':
                DocumentarExpedicionExpres;     // Informar de las expediciones de SZENDEX. Ecommerce. 
            else
                Error('Parámetro no reconocido: ' + Rec."Parameter String");

        end;

    end;
    //********************************************************************************************* 
    //   
    // Actualización del tracking ECI
    //
    procedure UpdateTrackingECI()
    var
        ShpfyShop: Record "Shpfy Shop";
        SalesShipmentHeader: Record "Sales Shipment Header";

    begin
        ShpfyShop.Reset;
        ShpfyShop.SetRange("Code", 'ECI');
        //ShpfyShop.SetRange("MarketPlace", true);
        if ShpfyShop.FindFirst then begin

            SalesShipmentHeader.Reset;
            SalesShipmentHeader.SetRange("Sell-to Customer No.", ShpfyShop."Default Customer No.");
            //>>
            //SalesShipmentHeader.SetRange("Sell-to Customer No.", 'C01917');
            //<<
            SalesShipmentHeader.SetFilter("Package Tracking No.", '<> %1', '');
            SalesShipmentHeader.SetFilter("Posting Date", '>%1', CALCDATE('<-30D>', TODAY));
            SalesShipmentHeader.SetFilter("Tracking ECI", '<> %1', SalesShipmentHeader."Tracking ECI"::"ECI.ENT");
            SalesShipmentHeader.SetFilter("External Document No.", '<>%1', '');
            if SalesShipmentHeader.FindSet then
                repeat
                    SalesShipmentHeader.CalcFields("Shipment Finished");
                    case TRUE of
                        //SalesShipmentHeader."Reason Code" = '':
                        SalesShipmentHeader."Tracking ECI" = SalesShipmentHeader."Tracking ECI"::" ":
                            begin
                                ECIUpdateOrderCarrier(SalesShipmentHeader, 1);
                                SalesShipmentHeader.Validate("Tracking ECI", SalesShipmentHeader."Tracking ECI"::"ECI.ENV");
                                if not SalesShipmentHeader.Modify() then
                                    Error('Error en la actualización del registro %1', SalesShipmentHeader."No.");
                                Commit;
                            end;
                        SalesShipmentHeader."Tracking ECI" = SalesShipmentHeader."Tracking ECI"::"ECI.ENV":
                            if (SalesShipmentHeader."Shipment Finished") Then begin
                                if (SalesShipmentHeader."Sh. Agent - Status" = 'ENTREGADO') then
                                    ECIUpdateOrderCarrier(SalesShipmentHeader, 2);

                                SalesShipmentHeader.Validate("Tracking ECI", SalesShipmentHeader."Tracking ECI"::"ECI.ENT");
                                if not SalesShipmentHeader.Modify() then
                                    Error('Error en la actualización del registro %1', SalesShipmentHeader."No.");
                                Commit;
                            end;
                    end;

                until SalesShipmentHeader.Next = 0;
        end;
    end;

    local procedure ECIUpdateOrderCarrier(SalesShipmentHeaderAux: Record "Sales Shipment Header"; State: integer)
    var
        UpdatedOrderCarrierXML: Text;
        TaskResultText: Text;
    begin
        case State of
            1:
                begin
                    UpdatedOrderCarrierXML := '{ "carrier_name": "SZENDEX", "carrier_url": "http://www.szendex.com/seguimiento-de-pedidos/", "tracking_number": "' + SalesShipmentHeaderAux."Package Tracking No." + '" }';
                    TaskResultText := ECIPostPutDataToSite('PUT', 'https://marketplace.elcorteingles.es/api/orders/' + SalesShipmentHeaderAux."External Document No." + '/tracking', UpdatedOrderCarrierXML);
                    UpdatedOrderCarrierXML := '';
                    TaskResultText := ECIPostPutDataToSite('PUT', 'https://marketplace.elcorteingles.es/api/orders/' + SalesShipmentHeaderAux."External Document No." + '/ship ', UpdatedOrderCarrierXML);
                end;
            2:
                begin
                    UpdatedOrderCarrierXML := '{ "order_additional_fields": [ { "code": "fecha-entrega", "value": "' + Format(Today, 0, 9) + 'T' + Format(Time, 0, 9) + '" } ] }';
                    TaskResultText := ECIPostPutDataToSite('PUT', 'https://marketplace.elcorteingles.es/api/orders/' + SalesShipmentHeaderAux."External Document No." + '/additional_fields', UpdatedOrderCarrierXML);
                end;
        end;
        exit;
    end;

    local procedure ECIPostPutDataToSite(Method: Text; SiteURI: Text; XMLText: Text): Text
    var
        TempBlob: codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        HttpRequestHeaders: HttpHeaders;
        HttpHeader: HttpHeaders;
        TaskResultText: Text;
        StartPosition: Integer;
        JsonFormatParameter: label 'io_format=JSON';
        ResponseText: text;
    begin
        // Headers
        clear(HttpResponseMessage);
        HttpClient.DefaultRequestHeaders.Add('Authorization', '8cac1d8a-9380-4173-9aea-214a622ae9ba');
        HttpContent.WriteFrom(XMLText);
        HttpContent.GetHeaders(HttpHeader);
        HttpHeader.Remove('Content-Type');
        HttpHeader.Add('Content-Type', 'application/json');
        case Method of
            'POST':
                if HttpClient.post(SiteURI, HttpContent, HttpResponseMessage) then begin
                end;
            'PUT':
                if HttpClient.Put(SiteURI, HttpContent, HttpResponseMessage) then begin
                end;
            'GET':
                if HttpClient.get(SiteURI, HttpResponseMessage) then begin
                end
                else
                    Error('Método desconocido: ' + Method);
        end;
        HttpResponseMessage.Content.ReadAs(ResponseText);
        if not HttpResponseMessage.IsSuccessStatusCode then begin
            if (HttpResponseMessage.HttpStatusCode <> 400) AND (HttpResponseMessage.HttpStatusCode <> 404) then
                Error('Ha ocurrido un error en la comunicación - ' + Format(HttpResponseMessage.HttpStatusCode) + ': ' + ResponseText);
        end;
        // Comprobar respuesta
        //MESSAGE(FORMAT(Task.Result));
        //TempBlob.INIT;
        //TempBlob.WriteAsText(Task.Result,TEXTENCODING::UTF8);
        //FileManagement.BLOBExport(TempBlob,'respuesta.json',TRUE);
        //MESSAGE(TempBlob.ReadAsTextWithCRLFLineSeparator);
        exit(ResponseText);
    end;
    //*********************************************************************************************
    //
    //  Recuperar Etiqueta ECI - Envio a Centro Comercial
    //
    procedure ECILabelDownload(rSalesShipmentHeader: Record "Sales Shipment Header")
    var
        UpdatedOrderXML: Text;
        TaskResultText: Text;
        Position: Integer;
        UrlLabel: Text;
        IdLabel: Text;
        TempBlob: Codeunit "Temp Blob";
        IStream: InStream;
        Base64Label: Text;
        FileMng: File;
        FileLabel: Text;
        StringLabel: Text;
        RequestURL: Text;
        OStream: OutStream;
    begin
        CLEAR(Position);
        CLEAR(IdLabel);
        CLEAR(UpdatedOrderXML);

        // Lectura del código de la etiqueta. IdLabel
        TaskResultText := ECIPostPutDataToSite('GET', 'https://marketplace.elcorteingles.es/api/orders/documents?order_ids=' + rSalesShipmentHeader."External Document No.", UpdatedOrderXML);
        Position := STRPOS(TaskResultText, '"id":');
        if Position <> 0 then begin
            IdLabel := COPYSTR(TaskResultText, Position + 5, 10);
            Position := STRPOS(IdLabel, ',');
            IdLabel := COPYSTR(IdLabel, 1, Position - 1);
            // WebClient Download File PDF
            RequestURL := 'https://marketplace.elcorteingles.es/api/orders/documents/download?document_ids=' + IdLabel;
            HttpCallECI(RequestURL, TempBlob);
            // Grabar etiqueta en el Albaran
            TempBlob.CreateInStream(IStream);
            rSalesShipmentHeader."Shipping ECI Label".CreateOutStream(OStream);
            CopyStream(OStream, IStream);
            rSalesShipmentHeader.MODIFY;
        end;
    end;

    procedure HttpCallECI(RequestURL: Text; var TempBlob: codeunit "Temp Blob")
    var
        ClientHttp: HttpClient;
        RequestHeaders: HttpHeaders;
        RequestContent: HttpContent;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        contentHeaders: HttpHeaders;
        Body: text;
        ResponseTxt: Text;
        Istream: InStream;
        OStream: OutStream;
        FileTxt: Text;
    begin
        Clear(ClientHttp);
        Clear(RequestHeaders);
        Clear(RequestContent);
        Clear(contentHeaders);
        ClientHttp.DefaultRequestHeaders.Add('Authorization', '8cac1d8a-9380-4173-9aea-214a622ae9ba');
        RequestHeaders := ClientHttp.DefaultRequestHeaders();
        ClientHttp.get(RequestURL, ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode then begin
            ResponseMessage.Content.ReadAs(ResponseTxt);
            Error('%1 : %2 ', RequestURL, ResponseTxt);
        end;
        ResponseMessage.Content.ReadAs(Istream);
        TempBlob.CreateOutstream(OStream);
        CopyStream(OStream, Istream);
    end;

    //*********************************************************************************************
    //
    // Recuperar Tracking de SZENDEX.
    //
    procedure ObtenerTrackingSZX()
    var
        TempBlob: Codeunit "Temp Blob";
        SalesShipmentHeader: Record "Sales Shipment Header";
        FileManagement: Codeunit "File Management";
        IStream: InStream;
        OStream: OutStream;
        SzendexTrackingRequestXML: XmlPort 50037;
        ConnectionGUID: Text;
        XMLText: Text;
        DummyTxt: Text;
        ResultStatus: Integer;
        ResultErrorCode: Code[20];
        ResultErrorText: Text;
        DeliveryStartingDate: DateTime;
        DeliveryEndingDate: DateTime;
        StatusStartingDate: DateTime;
        StatusEndingDate: DateTime;
        StartingReference: Text;
        EndingReference: Text;
    begin
        GetSalesSetup;
        /////////DesconectarUsuarioBPointSZX(true);
        ConnectionGUID := ValidarUsuarioBPointSZX(true);
        if ConnectionGUID = '' then Error('Debe especificar un GUID de conexión válido');
        if SalesReceivablesSetup."Sze - Last Tracking Datetime" = 0DT then
            //>>15/04/2024
            //SalesReceivablesSetup."Sze - Last Tracking Datetime" := CreateDatetime(Today - 30, 0T);
            StatusStartingDate := CREATEDATETIME(TODAY - 30, 0T)
        else
            StatusStartingDate := SalesReceivablesSetup."Sze - Last Tracking Datetime";

        StatusEndingDate := CurrentDatetime;
        //<<

        SalesShipmentHeader.Reset;
        SalesShipmentHeader.SetFilter("Package Tracking No.", '<>%1', '');
        //SalesShipmentHeader.SetRange("Shipping Agent Int. Type", SalesShipmentHeader."shipping agent int. type"::Szendex);
        SalesShipmentHeader.SetRange("Shipping Agent Code", 'SZENDEX');
        SalesShipmentHeader.SetRange("Shipment Finished", false);
        SalesShipmentHeader.SetCurrentkey("Package Tracking No.");
        //>> BBT 15/04/2024
        SalesShipmentHeader.SetFilter(SalesShipmentHeader."Posting Date", '>=%1', DT2DATE(StatusStartingDate));
        //<<
        if SalesShipmentHeader.FindSet then
            repeat // Preparación de parámetros
                StartingReference := SalesShipmentHeader."Package Tracking No.";
                DeliveryStartingDate := CreateDatetime(SalesShipmentHeader."Posting Date", 0T);
                EndingReference := SalesShipmentHeader."Package Tracking No.";
                DeliveryEndingDate := CurrentDatetime;
                //>> 15/04/2024
                //StatusStartingDate := SalesReceivablesSetup."Sze - Last Tracking Datetime";
                //StatusEndingDate := CurrentDatetime;
                //<<
                Clear(TempBlob);
                TempBlob.CreateInstream(IStream);
                TempBlob.CreateOutstream(OStream);
                Clear(SzendexTrackingRequestXML);
                SzendexTrackingRequestXML.SetParameters(ConnectionGUID, DeliveryStartingDate, DeliveryEndingDate, StatusStartingDate, StatusEndingDate, StartingReference, EndingReference);
                SzendexTrackingRequestXML.SetDestination(OStream);
                SzendexTrackingRequestXML.Export;
                XMLText := '';
                while not IStream.eos do begin
                    IStream.ReadText(DummyTxt);
                    XMLText += DummyTxt;
                end;
                Clear(ResultText);
                HttpCallSZX(transportistasCallType::"Obtener tracking", XMLText);
                //ResultText := PostPutDataToSite(SalesReceivablesSetup."SZE - URL", 'POST', XMLText, 'ObtenerTracking');
                FixXMLTags(ResultText);
                //Message(ResultText);

                CheckTrackingResponseSZX(ResultText, ResultStatus, ResultErrorCode, ResultErrorText);
                if ResultStatus <> Communicationstatus::Success then
                    Error('Ha ocurrido el siguiente error en la lectura del tracking: ' + ResultErrorCode + ' ' + ResultErrorText);
            until SalesShipmentHeader.Next = 0;
        ///////////DesconectarUsuarioBPointSZX(true);
    end;

    local procedure CheckLoginResponseSZX(LoginResponseText: Text; var ResultStatus: Integer; var ResultErrorCode: Code[20]; var ResultErrorText: Text; var ConnectionGUID: Text)
    var
        CodeOpeningTag: label '<CODIGO>';
        CodeClosingTag: label '</CODIGO>';
        StartingPosition: Integer;
        EndingPosition: Integer;
        MessageOpeningTag: label '<MENSAJE>';
        MessageClosingTag: label '</MENSAJE>';
        GuidOpeningTag: label '<GUID>';
        GuidClosingTag: label '</GUID>';
    begin
        if LoginResponseText = '' then exit;
        ResultErrorCode := '';
        ResultErrorText := '';
        ResultStatus := 0;
        ConnectionGUID := '';
        if StrPos(LoginResponseText, CodeOpeningTag) <> 0 then begin // Ha habido un error
            // Código error
            StartingPosition := StrPos(LoginResponseText, CodeOpeningTag) + StrLen(CodeOpeningTag);
            EndingPosition := StrPos(LoginResponseText, CodeClosingTag) - StartingPosition; // Longitud del contenido
            ResultErrorCode := CopyStr(LoginResponseText, StartingPosition, EndingPosition);
            // Mensaje error
            StartingPosition := StrPos(LoginResponseText, MessageOpeningTag) + StrLen(MessageOpeningTag);
            EndingPosition := StrPos(LoginResponseText, MessageClosingTag) - StartingPosition; // Longitud del contenido
            ResultErrorText := CopyStr(LoginResponseText, StartingPosition, EndingPosition);
            ResultStatus := Communicationstatus::Error;
        end
        else begin
            // Guid de conexión
            StartingPosition := StrPos(LoginResponseText, GuidOpeningTag) + StrLen(GuidOpeningTag);
            EndingPosition := StrPos(LoginResponseText, GuidClosingTag) - StartingPosition; // Longitud del contenido
            ConnectionGUID := CopyStr(LoginResponseText, StartingPosition, EndingPosition);
            ResultStatus := Communicationstatus::Success;
        end;
    end;

    local procedure CheckGrabacionResponse(ShipmentResponseText: Text; var ResultStatus: Integer; var ResultErrorCode: Code[20]; var ResultErrorText: Text;
                                            var ServiceID: Code[20]; var ServiceSourceOffice: Code[20]; var ShipmentNumber: Code[20];
                                            var DeliveryReference: Code[20]; var Via: Text[20])
    var
        CodeOpeningTag: label '<CODIGO>';
        CodeClosingTag: label '</CODIGO>';
        StartingPosition: Integer;
        EndingPosition: Integer;
        MessageOpeningTag: label '<MENSAJE>';
        MessageClosingTag: label '</MENSAJE>';
        IDOpeningTag: label '<ID>';
        IDClosingTag: label '</ID>';
        OfficeOpeningTag: label '<OFICINAORIGEN>';
        OfficeClosingTag: label '</OFICINAORIGEN>';
        NumberOpeningTag: label '<NUMERO>';
        NumberClosingTag: label '</NUMERO>';
        ReferenceOpeningTag: label '<REFERENCIAENTREGA>';
        ReferenceClosingTag: label '</REFERENCIAENTREGA>';
        ViaOpeningTag: label '<VIA>';
        ViaClosingTag: label '</VIA>';
    begin
        if ShipmentResponseText = '' then
            exit;

        Clear(ResultErrorCode);
        Clear(ResultErrorText);
        Clear(ResultStatus);

        clear(ServiceID);
        Clear(ServiceSourceOffice);
        Clear(ShipmentNumber);
        Clear(DeliveryReference);
        Clear(Via);

        if StrPos(ShipmentResponseText, CodeOpeningTag) <> 0 then begin // Ha habido un error

            // Código error
            StartingPosition := StrPos(ShipmentResponseText, CodeOpeningTag) + StrLen(CodeOpeningTag);
            EndingPosition := StrPos(ShipmentResponseText, CodeClosingTag) - StartingPosition; // Longitud del contenido
            ResultErrorCode := CopyStr(ShipmentResponseText, StartingPosition, EndingPosition);

            // Mensaje error
            StartingPosition := StrPos(ShipmentResponseText, MessageOpeningTag) + StrLen(MessageOpeningTag);
            EndingPosition := StrPos(ShipmentResponseText, MessageClosingTag) - StartingPosition; // Longitud del contenido
            ResultErrorText := CopyStr(ShipmentResponseText, StartingPosition, EndingPosition);

            ResultStatus := Communicationstatus::Error;

        end else begin

            // Id Orden Servicio
            StartingPosition := StrPos(ShipmentResponseText, IDOpeningTag) + StrLen(IDOpeningTag);
            EndingPosition := StrPos(ShipmentResponseText, IDClosingTag) - StartingPosition; // Longitud del contenido
            if (StartingPosition > 0) and (EndingPosition > 0) then
                ServiceID := CopyStr(ShipmentResponseText, StartingPosition, EndingPosition);

            // Oficina origen
            StartingPosition := StrPos(ShipmentResponseText, OfficeOpeningTag) + StrLen(OfficeOpeningTag);
            EndingPosition := StrPos(ShipmentResponseText, OfficeClosingTag) - StartingPosition; // Longitud del contenido
            if (StartingPosition > 0) and (EndingPosition > 0) then
                ServiceSourceOffice := CopyStr(ShipmentResponseText, StartingPosition, EndingPosition);

            // Numero expedición
            StartingPosition := StrPos(ShipmentResponseText, NumberOpeningTag) + StrLen(NumberOpeningTag);
            EndingPosition := StrPos(ShipmentResponseText, NumberClosingTag) - StartingPosition; // Longitud del contenido
            if (StartingPosition > 0) and (EndingPosition > 0) then
                ShipmentNumber := CopyStr(ShipmentResponseText, StartingPosition, EndingPosition);

            // Referencia entrega - Este número lo utilizamos también para la etiqueta
            StartingPosition := StrPos(ShipmentResponseText, ReferenceOpeningTag) + StrLen(ReferenceOpeningTag);
            EndingPosition := StrPos(ShipmentResponseText, ReferenceClosingTag) - StartingPosition; // Longitud del contenido
            if (StartingPosition > 0) and (EndingPosition > 0) then
                DeliveryReference := CopyStr(ShipmentResponseText, StartingPosition, EndingPosition);

            // Via
            StartingPosition := StrPos(ShipmentResponseText, ViaOpeningTag) + StrLen(ViaOpeningTag);
            EndingPosition := StrPos(ShipmentResponseText, ViaClosingTag) - StartingPosition; // Longitud del contenido
            if (StartingPosition > 0) and (EndingPosition > 0) then
                Via := CopyStr(ShipmentResponseText, StartingPosition, EndingPosition);

            ResultStatus := Communicationstatus::Success;
        end;
    end;

    local procedure CheckTrackingResponseSZX(ShipmentResponseText: Text; var ResultStatus: Integer; var ResultErrorCode: Code[20]; var ResultErrorText: Text)
    var
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        SzendexTrackingInfoXML: XmlPort 50038;
        OStream: OutStream;
        IStream: InStream;
        StartingPosition: Integer;
        EndingPosition: Integer;
        CodeOpeningTag: label '<CODIGO>';
        CodeClosingTag: label '</CODIGO>';
        MessageOpeningTag: label '<MENSAJE>';
        MessageClosingTag: label '</MENSAJE>';
        TrackingOpeningTag: label '<ObtenerTrackingResult>';
        TrackingClosingTag: label '</ObtenerTrackingResult>';

    begin
        if ShipmentResponseText = '' then exit;
        ResultErrorCode := '';
        ResultErrorText := '';
        ResultStatus := 0;
        if StrPos(ShipmentResponseText, CodeOpeningTag) <> 0 then begin // Ha habido un error
            // Código error
            StartingPosition := StrPos(ShipmentResponseText, CodeOpeningTag) + StrLen(CodeOpeningTag);
            EndingPosition := StrPos(ShipmentResponseText, CodeClosingTag) - StartingPosition; // Longitud del contenido
            ResultErrorCode := CopyStr(ShipmentResponseText, StartingPosition, EndingPosition);
            // Mensaje error
            StartingPosition := StrPos(ShipmentResponseText, MessageOpeningTag) + StrLen(MessageOpeningTag);
            EndingPosition := StrPos(ShipmentResponseText, MessageClosingTag) - StartingPosition; // Longitud del contenido
            ResultErrorText := CopyStr(ShipmentResponseText, StartingPosition, EndingPosition);

            ResultStatus := Communicationstatus::Error;
        end
        else begin
            ResultStatus := Communicationstatus::Success;
            // Datos tracking
            StartingPosition := StrPos(ShipmentResponseText, TrackingOpeningTag) + StrLen(TrackingOpeningTag);
            EndingPosition := StrPos(ShipmentResponseText, TrackingClosingTag) - StartingPosition; // Longitud del contenido
            ShipmentResponseText := CopyStr(ShipmentResponseText, StartingPosition, EndingPosition);

            if StrPos(ShipmentResponseText, 'ESTADO') = 0 then exit;
            Clear(TempBlob);
            TempBlob.CreateOutstream(OStream);
            TempBlob.CreateInstream(IStream);
            OStream.WriteText(ShipmentResponseText);

            /* Exportar el XML para revisarlo
            Clear(FileManagement);
            FileManagement.BLOBExport(TempBlob, 'respuesta.xml', TRUE);
            */
            SzendexTrackingInfoXML.SetSource(IStream);
            SzendexTrackingInfoXML.Import;
        end;
    end;

    local procedure CheckInfoExpeditionResponse(ShipmentResponseText: Text; var ResultStatus: Integer; var ResultErrorCode: Code[20]; var ResultErrorText: Text; var ReferenciaVia: Text[50])
    var
        CodeOpeningTag: label '<CODIGO>';
        CodeClosingTag: label '</CODIGO>';
        StartingPosition: Integer;
        EndingPosition: Integer;
        MessageOpeningTag: label '<MENSAJE>';
        MessageClosingTag: label '</MENSAJE>';
        ReferenciaViaOpeningTag: label '<REFERENCIA_VIA>';
        ReferenciaViaClosingTag: label '</REFERENCIA_VIA>';
    begin
        if ShipmentResponseText = '' then
            exit;

        Clear(ResultErrorCode);
        Clear(ResultErrorText);
        Clear(ResultStatus);
        Clear(ReferenciaVia);

        if StrPos(ShipmentResponseText, CodeOpeningTag) <> 0 then begin // Ha habido un error

            // Código error
            StartingPosition := StrPos(ShipmentResponseText, CodeOpeningTag) + StrLen(CodeOpeningTag);
            EndingPosition := StrPos(ShipmentResponseText, CodeClosingTag) - StartingPosition; // Longitud del contenido
            ResultErrorCode := CopyStr(ShipmentResponseText, StartingPosition, EndingPosition);

            // Mensaje error
            StartingPosition := StrPos(ShipmentResponseText, MessageOpeningTag) + StrLen(MessageOpeningTag);
            EndingPosition := StrPos(ShipmentResponseText, MessageClosingTag) - StartingPosition; // Longitud del contenido
            ResultErrorText := CopyStr(ShipmentResponseText, StartingPosition, EndingPosition);

            ResultStatus := Communicationstatus::Error;

        end else begin

            // referencia Via
            StartingPosition := StrPos(ShipmentResponseText, ReferenciaViaOpeningTag) + StrLen(ReferenciaViaOpeningTag);
            EndingPosition := StrPos(ShipmentResponseText, ReferenciaViaClosingTag) - StartingPosition; // Longitud del contenido
            if (StartingPosition > 0) and (EndingPosition > 0) then
                ReferenciaVia := CopyStr(ShipmentResponseText, StartingPosition, EndingPosition);

            ResultStatus := Communicationstatus::Success;
        end;
    end;
    //*********************************************************************************************
    //
    // Informar de las expediciones de SZENDEX. Ecommerce.
    // Proceso para la cola de proyectos.
    //
    procedure DocumentarExpedicionExpres()

    var
        rSalesShipmentHeader: Record "Sales Shipment Header";
        rCustomer: Record Customer;
        //InterfaceSGA: Codeunit "Interface SGA";
        cuPackaging: Codeunit "BBT Packaging";
        rShpfyShop: Record "Shpfy Shop";
    begin
        rSalesShipmentHeader.Reset;                                                         //Selecionamos los albaranes pendientes
        rSalesShipmentHeader.SetFilter("Package Tracking No.", '=%1', '');                  //SIN TRACKING
        rSalesShipmentHeader.SetRange("Printed Label", false);                              //ETIQUETA NO IMPRESA
        rSalesShipmentHeader.SetRange("Shipping Agent Code", 'SZENDEX');                    //ENVIOS a SZENDEX
        rSalesShipmentHeader.SetFilter("Location Code", '%1|%2', 'MARGA', 'STOCK');         //SOLO PARA ALMACENES MARGA|STOCK
        //rSalesShipmentHeader.SetRange("Sell-to Country/Region Code", 'ES');               //NACIONAL. Obsoleto tambien se envia a PORTUGAL
        rSalesShipmentHeader.SetRange("Gen. Bus. Posting Group", 'ECOMMERCE');              //ECOMMERCE
        rSalesShipmentHeader.SetFilter("Posting Date", '>%1', CALCDATE('<-15D>', TODAY));   //MAXIMO DE 2 SEMANAS
        if rSalesShipmentHeader.FindSet then
            Repeat
                rShpfyShop.Reset();
                rShpfyShop.SetRange("Default Customer No.", rSalesShipmentHeader."Bill-to Customer No.");
                if rShpfyShop.FindFirst then begin
                    rSalesShipmentHeader.CALCFIELDS("Packaging Lines Count");
                    if (rSalesShipmentHeader."Packaging Lines Count" = 0) then  // Si no hay bultos probamos a recuperarlos.
                        //InterfaceSGA.GetPackagingLinesFromSalesShptHeader(rSalesShipmentHeader);
                        cuPackaging.GetPackagingLinesFromSalesShptHeader(rSalesShipmentHeader);

                    rSalesShipmentHeader.CALCFIELDS("Packaging Lines Count");   // Si ya tenemos bultos informamos la expedición
                    if (rSalesShipmentHeader."Packaging Lines Count" <> 0) then begin
                        GrabarExpedicionExpresOS(rSalesShipmentHeader, '', true);
                        ObtenerExpedicionPorNumero(rSalesShipmentHeader, '');
                    end;
                end;
            until rSalesShipmentHeader.NEXT = 0;
    end;

    //*********************************************************************************************
    //
    //  Documentar la expedición en SZENDEX
    //
    procedure GrabarExpedicionExpresOS(var SalesShipmentHeader: Record "Sales Shipment Header"; ConnectionGUID: Text; IsJobQueue: Boolean)
    var
        TempBlob: Codeunit "Temp Blob";
        SalesShipmentHeader2: Record "Sales Shipment Header";
        IStream: InStream;
        OStream: OutStream;
        //SzendexShipmentXML: XmlPort 50033;
        SzendexShipmentXML: XmlPort "BBT Szendex Shipment XML";
        XMLText: Text;
        DummyTxt: Text;
        ResultStatus: Integer;
        ResultErrorCode: Code[20];
        ResultErrorText: Text;
        ServiceID: Code[20];
        ServiceSourceOffice: Code[20];
        ShipmentNumber: Code[20];
        DeliveryReference: Code[20];
        Via: Text[20];
        ReferenceVia: Text[50];
    begin
        begin
            Clear(ServiceID);
            Clear(ServiceSourceOffice);
            Clear(ShipmentNumber);
            Clear(DeliveryReference);
            Clear(Via);
            Clear(ReferenceVia);
            SalesShipmentHeader.TestField(SalesShipmentHeader."No.");
            SalesShipmentHeader.TestField(SalesShipmentHeader."Shipping Agent Code");
            SalesShipmentHeader.CalcFields("Shipping Agent Int. Type");
            SalesShipmentHeader.TestField("Shipping Agent Int. Type", SalesShipmentHeader."shipping agent int. type"::Szendex);
            //////////if ConnectionGUID = '' then begin
            //////////    DesconectarUsuarioBPoint(false);
            ConnectionGUID := ValidarUsuarioBPointSZX(false);
            //////////end;
            if ConnectionGUID = '' then
                Error('Debe especificar un GUID de conexión válido');

            if SalesShipmentHeader."Package Tracking No." = '' then begin
                Clear(SalesShipmentHeader."Package Tracking No.");
                Clear(SalesShipmentHeader."Shipping Via Agent");
                Clear(TempBlob);

                TempBlob.CreateInstream(IStream, Textencoding::Windows);
                TempBlob.CreateOutstream(OStream, Textencoding::Windows);

                SalesShipmentHeader2.Reset;
                SalesShipmentHeader2.SetRange("No.", SalesShipmentHeader."No.");

                SzendexShipmentXML.SetGUID(ConnectionGUID);
                SzendexShipmentXML.SetTableview(SalesShipmentHeader2);
                SzendexShipmentXML.SetDestination(OStream);
                SzendexShipmentXML.Export;

                XMLText := '';
                while not IStream.eos do begin
                    IStream.ReadText(DummyTxt);
                    XMLText += DummyTxt;
                end;


                Clear(ResultText);
                HttpCallSZX(TransportistasCallType::"Grabar expedicion", XMLText);
                //ResultText := PostPutDataToSite(SalesReceivablesSetup."SZE - URL", 'POST', XMLText, '   ');

                FixXMLTags(ResultText);

                CheckGrabacionResponse(ResultText, ResultStatus, ResultErrorCode, ResultErrorText, ServiceID,
                                         ServiceSourceOffice, ShipmentNumber, DeliveryReference, Via);
                if ResultStatus <> Communicationstatus::Success then begin
                    if not IsJobQueue then
                        Error('Ha ocurrido el siguiente error en la grabación del envío ' + SalesShipmentHeader."No." + ': ' + ResultErrorCode + ' ' + ResultErrorText);
                end
                else begin
                    SalesShipmentHeader."Package Tracking No." := DeliveryReference;
                    SalesShipmentHeader."Shipping Via Agent" := Via;
                end;
            end
            else
                DeliveryReference := SalesShipmentHeader."Package Tracking No.";


            Clear(TempBlob);
            RecuperarEtiquetaSZX(TempBlob, ConnectionGUID, DeliveryReference, SalesShipmentHeader);
            /////SalesShipmentHeader."Shipping Agent Label".CreateOutStream(TempBlob.CreateOutStream());

            SalesShipmentHeader.Modify;

            //>> BBT 01/07/2025 No se usa PRESTA
            //SalesShipmentHeader.UpdatePSHOPOrderStatus(); // Actualizamos en PRESTASHOP
            //<<
            /*
            CLEAR(TempBlob);
            TempBlob.Blob.CREATEOUTSTREAM(OStream);
            OStream.WRITETEXT(ResultText);
            FileManagement.BLOBExport(TempBlob,'respuesta grabacion.xml',TRUE);
            */

            Commit();
        end;

    end;

    //*********************************************************************************************
    //
    //  Recuperar información de la expedición de SZENDEX
    //
    procedure ObtenerExpedicionPorNumero(var SalesShipmentHeader: Record "Sales Shipment Header"; ConnectionGUID: Text)
    var
        SalesShipmentHeaderAux: Record "Sales Shipment Header";

        TempBlob: Codeunit "Temp Blob";
        IStream: InStream;
        OStream: OutStream;

        FileManagement: Codeunit "File Management";
        FileName: Text;

        SzendexExpeditionInformationXML: XmlPort 51102;
        XMLText: Text;
        DummyTxt: Text;

        ResultStatus: Integer;
        ResultErrorCode: Code[20];
        ResultErrorText: Text;

        ReferenceVia: Text[50];
    begin
        Clear(ReferenceVia);
        if SalesShipmentHeader."Package Tracking No." <> '' then begin

            ConnectionGUID := ValidarUsuarioBPointSZX(true);
            if ConnectionGUID = '' then
                Error('Debe especificar un GUID de conexión válido');

            Clear(TempBlob);
            TempBlob.CreateInstream(IStream, Textencoding::Windows);
            TempBlob.CreateOutstream(OStream, Textencoding::Windows);

            SalesShipmentHeaderAux.Reset;
            SalesShipmentHeaderAux.SetRange("No.", SalesShipmentHeader."No.");

            SzendexExpeditionInformationXML.SetGUID(ConnectionGUID);
            SzendexExpeditionInformationXML.SetTableview(SalesShipmentHeaderAux);
            SzendexExpeditionInformationXML.SetDestination(OStream);
            SzendexExpeditionInformationXML.Export;

            XMLText := '';
            while not IStream.eos do begin
                IStream.ReadText(DummyTxt);
                XMLText += DummyTxt;
            end;

            Clear(ResultText);
            HttpCallSZX(TransportistasCallType::"Obtener expedicion", XMLText);
            //ResultText := PostPutDataToSite(SalesReceivablesSetup."SZE - URL", 'POST', XMLText, '   ');

            FixXMLTags(ResultText);
            //Message(ResultText);

            CheckInfoExpeditionResponse(ResultText, ResultStatus, ResultErrorCode, ResultErrorText, ReferenceVia);
            if ResultStatus <> Communicationstatus::Success then
                Error('Error en la documentación de la Expedición ' + SalesShipmentHeader."No." + ': ' + ResultErrorCode + ' ' + ResultErrorText);

            SalesShipmentHeader."Shipping Via Reference" := ReferenceVia;
            SalesShipmentHeader.Modify;

            /*
            FileName := format(SalesShipmentHeader."No.") + '.xml';
            CLEAR(TempBlob);
            OStream.WRITETEXT(ResultText);
            FileManagement.BLOBExport(TempBlob, FileName, false);
            */

            Commit();
        end;
    end;

    //*********************************************************************************************
    //
    //  Recuperar Etiqueta SZENDEX
    //
    local procedure RecuperarEtiquetaSZX(var TempBlob: Codeunit "Temp Blob"; ConnectionGUID: Text; DeliveryReference: Text; var SalesShipmentHeader: Record "Sales Shipment Header")
    var
        FileManagement: Codeunit "File Management";
        SzendexPrintLabelXML: XmlPort 50036;
        IStream: InStream;
        OStream: OutStream;
        XMLText: Text;
        DummyTxt: Text;
        ResultStatus: Integer;
        ResultErrorCode: Code[20];
        ResultErrorText: Text;
    //LabelName: Text;
    begin
        if DeliveryReference = '' then exit;
        if ConnectionGUID = '' then Error('Debe especificar un GUID de conexión válido');

        GetSalesSetup;
        Clear(TempBlob);

        TempBlob.CreateInstream(IStream);
        TempBlob.CreateOutstream(OStream);

        SzendexPrintLabelXML.SetParameters(ConnectionGUID, DeliveryReference);
        SzendexPrintLabelXML.SetDestination(OStream);
        SzendexPrintLabelXML.Export;

        XMLText := '';
        while not IStream.eos do begin
            IStream.ReadText(DummyTxt);
            XMLText += DummyTxt;
        end;

        Clear(ResultText);
        HttpCallSZX(TransportistasCallType::"Imprimir etiqueta", XMLText);

        FixXMLTags(ResultText);

        CheckLabelPrintResponse(ResultText, ResultStatus, ResultErrorCode, ResultErrorText, TempBlob);
        if ResultStatus <> Communicationstatus::Success then
            Error('Ha ocurrido el siguiente error en la impresión de la expedición ' + DeliveryReference + ': ' + ResultErrorCode + ' ' + ResultErrorText)
        else begin
            //>> BBT 28/01/2025. Cambio en la creación de la etiqueta de SZENDEX
            //LabelName := SalesShipmentHeader."No." + '.pdf';
            //TempBlob.CreateInStream(IStream);
            //DownloadFromStream(IStream, '', '', '', LabelName);
            //
            TempBlob.CreateInStream(IStream);
            SalesShipmentHeader."Shipping Agent Label".CreateOutStream(OStream);
            CopyStream(OStream, IStream);
            SalesShipmentHeader.Modify();
        end;
        //<<
    end;

    //*********************************************************************************************
    //
    //  Imprimir Etiqueta SZENDEX
    //  BBT 28/01/2025. Cambio en la creación de la etiqueta de SZENDEX
    //
    procedure ImprimitEtiquetaSZX(var SalesShipmentHeader: Record "Sales Shipment Header")
    var
        TempBlob: Codeunit "Temp Blob";
        IStream: InStream;
        LabelName: Text;
    begin
        Clear(TempBlob);
        SalesShipmentHeader.CalcFields("Shipping Agent Label");
        if SalesShipmentHeader."Shipping Agent Label".HasValue then begin
            SalesShipmentHeader."Shipping Agent Label".CreateInStream(IStream);
            LabelName := SalesShipmentHeader."No." + '.pdf';
            if DownloadFromStream(IStream, '', '', '', LabelName) then begin
                SalesShipmentHeader."Printed Label" := True;
                SalesShipmentHeader.Modify;
            end;
        end;
    end;
    //*********************************************************************************************

    local procedure CheckLabelPrintResponse(LoginResponseText: Text; var ResultStatus: Integer; var ResultErrorCode: Code[20]; var ResultErrorText: Text; var TempBlob: Codeunit "Temp Blob")
    var
        CodeOpeningTag: label '<CODIGO>';
        CodeClosingTag: label '</CODIGO>';
        StartingPosition: Integer;
        EndingPosition: Integer;
        MessageOpeningTag: label '<MENSAJE>';
        MessageClosingTag: label '</MENSAJE>';
        LabelOpeningTag: label '<ImprimirEtiqueta>';
        LabelClosingTag: label '</ImprimirEtiqueta>';
        Base64Label: Text;
        PDFTextFile: Text;
        Base64Convert: Codeunit "Base64 Convert";
        InStr: InStream;
        OutStr: OutStream;
    begin
        if LoginResponseText = '' then exit;

        ResultErrorCode := '';
        ResultErrorText := '';
        ResultStatus := 0;

        if StrPos(LoginResponseText, CodeOpeningTag) <> 0 then begin // Ha habido un error

            // Código error
            StartingPosition := StrPos(LoginResponseText, CodeOpeningTag) + StrLen(CodeOpeningTag);
            EndingPosition := StrPos(LoginResponseText, CodeClosingTag) - StartingPosition; // Longitud del contenido
            ResultErrorCode := CopyStr(LoginResponseText, StartingPosition, EndingPosition);

            // Mensaje error
            StartingPosition := StrPos(LoginResponseText, MessageOpeningTag) + StrLen(MessageOpeningTag);
            EndingPosition := StrPos(LoginResponseText, MessageClosingTag) - StartingPosition; // Longitud del contenido
            ResultErrorText := CopyStr(LoginResponseText, StartingPosition, EndingPosition);

            ResultStatus := Communicationstatus::Error;
        end else begin

            // Etiqueta en base64
            StartingPosition := StrPos(LoginResponseText, LabelOpeningTag) + StrLen(LabelOpeningTag);
            EndingPosition := StrPos(LoginResponseText, LabelClosingTag) - StartingPosition; // Longitud del contenido
            Base64Label := CopyStr(LoginResponseText, StartingPosition, EndingPosition);
            //TempBlob.Init;
            //TempBlob.WriteAsText(Base64Label,TEXTENCODING::Windows);
            TempBlob.CreateOutStream(OutStr);
            Base64Convert.FromBase64(Base64Label, OutStr);
            //TempBlob.INIT;
            //TempBlob.WriteAsText(PDFTextFile,TEXTENCODING::Windows);

            ResultStatus := Communicationstatus::Success;
        end;
    end;
    //
    //*********************************************************************************************
    local procedure DesconectarUsuarioBPointSZX(UserTracking: Boolean)
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        OStream: OutStream;
        IStream: InStream;
        SzendexLogoutXML: XmlPort 50034;
        SzendexLogoutTrackingXML: XmlPort 50053;
        XMLText: Text;
        DummyTxt: Text;
        ResultStatus: Integer;
        ResultErrorCode: Code[20];
        ResultErrorText: Text;
        ConnectionGUID: Text;
    begin
        GetSalesSetup;
        Clear(TempBlob);
        TempBlob.CreateInstream(IStream);
        TempBlob.CreateOutstream(OStream);
        if UserTracking then begin
            SzendexLogoutTrackingXML.SetDestination(OStream);
            SzendexLogoutTrackingXML.Export;
        end
        else begin
            SzendexLogoutXML.SetDestination(OStream);
            SzendexLogoutXML.Export;
        end;
        XMLText := '';
        while not IStream.eos do begin
            IStream.ReadText(DummyTxt);
            XMLText += DummyTxt;
        end;
        Clear(ResultText);
        HttpCallSZX(transportistasCallType::"Desconectar usuario", XMLText);
        //ResultText := PostPutDataToSite(SalesReceivablesSetup."SZE - URL", 'POST', XMLText, 'DesconectarUsuarioBPoint');
        FixXMLTags(ResultText);
        /*  PARA VER ResulText:
            CLEAR(TempBlob);
            TempBlob.Blob.CREATEOUTSTREAM(OStream);
            OStream.WRITETEXT(ResultText);
            FileManagement.BLOBExport(TempBlob,'respuesta logout.xml',TRUE);
        */
        CheckLoginResponseSZX(ResultText, ResultStatus, ResultErrorCode, ResultErrorText, ConnectionGUID);
        if ResultStatus <> Communicationstatus::Success then Error('Ha ocurrido el siguiente error en la desconexión: ' + ResultErrorCode + ' ' + ResultErrorText);
        //MESSAGE('Código: '+ResultErrorCode+' Mensaje: '+ResultErrorText+' Guid: '+ConnectionGUID);
    end;

    local procedure ValidarUsuarioBPointSZX(UserTracking: Boolean): Text
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        OStream: OutStream;
        IStream: InStream;
        //>> BBT 19/12/2024 Nueva version Szendex - Login V3
        //SzendexLoginXML: XmlPort "Szendex - Login XML";                   // XmlPort 50032;
        //SzendexLoginTrackingXML: XmlPort "Szendex - Login Tracking XML";  // XmlPort 50052;
        SzendexLoginXMLv3: XmlPort "BBT Szendex Login V3";                  // XmlPort 51100  
        SzendexLoginTrackingXMLv3: XmlPort "BBT SZX Login Tracking V3";     // XmlPort 51101
        //<<
        XMLText: Text;
        DummyTxt: Text;
        ResultStatus: Integer;
        ResultErrorCode: Code[20];
        ResultErrorText: Text;
        ConnectionGUID: Text;
    begin
        GetSalesSetup;
        Clear(TempBlob);
        TempBlob.CreateInstream(IStream);
        TempBlob.CreateOutstream(OStream);
        if UserTracking then begin
            SzendexLoginTrackingXMLv3.SetDestination(OStream);
            SzendexLoginTrackingXMLv3.Export;
        end
        else begin
            SzendexLoginXMLv3.SetDestination(OStream);
            SzendexLoginXMLv3.Export;
        end;

        XMLText := '';
        while not IStream.eos do begin
            IStream.ReadText(DummyTxt);
            XMLText += DummyTxt;
        end;
        Clear(ResultText);
        HttpCallSZX(transportistasCallType::"Validar usuario", XMLText);
        //ResultText := PostPutDataToSite(SalesReceivablesSetup."SZE - URL", 'POST', XMLText, 'ValidarUsuarioBPoint');
        FixXMLTags(ResultText);
        /* PARA VER ResultText:
            CLEAR(TempBlob);
            TempBlob.Blob.CREATEOUTSTREAM(OStream);
            OStream.WRITETEXT(ResultText);
            FileManagement.BLOBExport(TempBlob,'respuesta.xml',TRUE);
        */
        CheckLoginResponseSZX(ResultText, ResultStatus, ResultErrorCode, ResultErrorText, ConnectionGUID);
        if ResultStatus <> Communicationstatus::Success then Error('Ha ocurrido el siguiente error en la autenticación: ' + ResultErrorCode + ' ' + ResultErrorText);
        //MESSAGE('Código: '+ResultErrorCode+' Mensaje: '+ResultErrorText+' Guid: '+ConnectionGUID);
        exit(ConnectionGUID);
    end;

    procedure HttpCallSZX(TransportCallType: Enum "Transportistas Call Type"; BodyText: text)
    var
        ClientHttp: HttpClient;
        RequestHeaders: HttpHeaders;
        RequestContent: HttpContent;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        contentHeaders: HttpHeaders;
        RequestURL: text;
        Body: text;
        TransportistasJsonObject: JsonObject;
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get();
        Clear(ClientHttp);
        Clear(RequestHeaders);
        Clear(RequestContent);
        Clear(contentHeaders);
        SalesSetup.TestField("SZE - Endpoint");
        RequestURL := SalesSetup."SZE - Endpoint";
        Clear(TransportistasJsonObject);
        case TransportCallType of
            TransportCallType::"Validar usuario":
                begin
                    TransportistasJsonObject.Add('body', BodyText);
                    //>>BBT 19/12/2024 Nueva version Szendex - Login V3
                    //TransportistasJsonObject.Add('calltype', 'ValidarUsuarioBPoint');
                    TransportistasJsonObject.Add('calltype', 'ValidarUsuarioBPointV3');
                    //<<
                end;
            TransportCallType::"Desconectar usuario":
                begin
                    TransportistasJsonObject.Add('body', BodyText);
                    TransportistasJsonObject.Add('calltype', 'DesconectarUsuarioBPoint');
                end;
            TransportCallType::"Grabar expedicion":
                begin
                    TransportistasJsonObject.Add('body', BodyText);
                    TransportistasJsonObject.Add('calltype', 'GrabarExpedicionExpresOS');
                end;
            TransportCallType::"Obtener tracking":
                begin
                    TransportistasJsonObject.Add('body', BodyText);
                    TransportistasJsonObject.Add('calltype', 'ObtenerTracking');
                end;
            TransportCallType::"Imprimir etiqueta":
                begin
                    TransportistasJsonObject.Add('body', BodyText);
                    TransportistasJsonObject.Add('calltype', 'ImprimirEtiqueta');
                end;
            //>> BBT 15/04/2025 Obtener información de la VIA de entrega (GLS)    
            TransportCallType::"Obtener expedicion":
                begin
                    TransportistasJsonObject.Add('body', BodyText);
                    TransportistasJsonObject.Add('calltype', 'ObtenerExpedicionPorNumero');
                end;
            //<<
            else
                Error('No existe el criterio indicado : %1', TransportCallType);
        end;
        RequestHeaders := ClientHttp.DefaultRequestHeaders();
        TransportistasJsonObject.WriteTo(Body);
        RequestContent.WriteFrom(Body);
        RequestContent.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');
        ClientHttp.Post(RequestURL, RequestContent, ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode then begin
            ResponseMessage.Content.ReadAs(ResultText);
            Error(ResultText);
        end;
        ResponseMessage.Content.ReadAs(ResultText);
    end;
    //*********************************************************************************************
    local procedure GetSalesSetup()
    begin
        SalesReceivablesSetup.Reset;
        SalesReceivablesSetup.Get;
        SalesReceivablesSetup.TestField("SZE - Username");
        SalesReceivablesSetup.TestField("SZE - Password");
        SalesReceivablesSetup.TestField("SZE - URL");
        SalesReceivablesSetup.TestField("SZE - User Tracking");
        SalesReceivablesSetup.TestField("SZE - Pass Tracking");
    end;

    local procedure FixXMLTags(var XMLText: Text)
    begin
        if XMLText = '' then exit;
        ReplaceString(XMLText, '&lt;', '<');
        ReplaceString(XMLText, '&gt;', '>');
    end;

    local procedure ReplaceString(var String: Text; StringToReplace: Text; StringToReplaceWith: Text)
    var
        Counter: Integer;
    begin
        Counter := 0;
        while StrPos(String, StringToReplace) <> 0 do begin
            String := CopyStr(String, 1, StrPos(String, StringToReplace) - 1) + StringToReplaceWith + CopyStr(String, StrPos(String, StringToReplace) + StrLen(StringToReplace));
            Counter += 1;
        end;
    end;
}
