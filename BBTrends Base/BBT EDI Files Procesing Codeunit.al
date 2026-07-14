codeunit 50019 "BBT EDI Files Procesing"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        rCompanyInformation: Record "Company Information";
        rSalessetup: record "Sales & Receivables Setup";
    begin
        rCompanyInformation.Reset;
        rCompanyInformation.Get;
        if rCompanyInformation."EDI ID" = '' then exit;

        rSalessetup.Get();
        case rec."Parameter String" of
            rSalesSetup."EDI Download Invs. Parameter":
                GetEDIInvoices();
            rSalesSetup."EDI Download Orders Parameter":
                GetEDIOrders();
            rSalesSetup."EDI Download Returns Parameter":
                GetEDIReturns();
            rSalessetup."EDI Process Orders Parameter":
                ProcessOrders();
            rSalessetup."EDI Upload Shipment Parameter":
                UploadShipments();
            rSalesSetup."EDI Upload Invoice Parameter":
                UploadInvoices();
        //rSalesSetup."EDI Upload PDF Parameter":
        //    UploadShipmentPDFS();
        end;
    end;

    /*  EDI parametro descarga facturas : DOWNLOADINVOICES    */
    procedure GetEDIInvoices()
    var
        rSalesSetup: record "Sales & Receivables Setup";
    begin
        rSalesSetup.Get();
        rSalesSetup.Testfield("EDI Download PA Endpoint");
        rSalesSetup.TestField("EDI - Invoices d01b FTP folder");
        GetDocuments(rSalesSetup."EDI Download PA Endpoint", rSalesSetup."EDI - Invoices d01b FTP folder");
        rSalesSetup.TestField("EDI - Invoices d93a FTP folder");
        GetDocuments(rSalesSetup."EDI Download PA Endpoint", rSalesSetup."EDI - Invoices d93a FTP folder");
    end;
    /*
        procedure GetInvoices(EndPoint: text; Folder: text)
        var
            Client: HttpClient;
            RequestHeaders: HttpHeaders;
            RequestContent: HttpContent;
            ResponseMessage: HttpResponseMessage;
            ResponseText: Text;
            RequestBodyJson: JsonObject;
            contentHeaders: HttpHeaders;
            Body: Text;
        begin
            RequestHeaders := Client.DefaultRequestHeaders();
            RequestBodyJson := GetOrderContent(Folder);
            RequestBodyJson.WriteTo(Body);
            RequestContent.WriteFrom(Body);
            RequestContent.GetHeaders(contentHeaders);
            contentHeaders.Clear();
            contentHeaders.Add('Content-Type', 'application/json');
            Client.Post(EndPoint, RequestContent, ResponseMessage);
            if not ResponseMessage.IsSuccessStatusCode then begin
                ResponseMessage.Content.ReadAs(ResponseText);
                error(ResponseText);
            end;
        end;
    */
    /*  EDI parametro descarga pedidos: DOWNLOADORDERS  */
    procedure GetEDIOrders()
    var
        rSalesSetup: record "Sales & Receivables Setup";
    begin
        rSalesSetup.Get();
        rSalesSetup.Testfield("EDI Download PA Endpoint");
        rSalesSetup.TestField("EDI - Orders d01b FTP folder");
        GetDocuments(rSalesSetup."EDI Download PA Endpoint", rSalesSetup."EDI - Orders d01b FTP folder");
        rSalesSetup.TestField("EDI - Orders d93a FTP folder");
        GetDocuments(rSalesSetup."EDI Download PA Endpoint", rSalesSetup."EDI - Orders d93a FTP folder");
        rSalesSetup.TestField("EDI - Orders d96a FTP folder");
        GetDocuments(rSalesSetup."EDI Download PA Endpoint", rSalesSetup."EDI - Orders d96a FTP folder");
        //>> BBT 19/02/2025. EDI Polonia
        rSalesSetup.Testfield("EDI PL - Download PA Endpoint");
        GetDocuments(rSalesSetup."EDI PL - Download PA Endpoint", rSalesSetup."EDI - Orders d01b FTP folder");
        //<<
    end;
    /*
    procedure GetOrders(EndPoint: text; Folder: text)
    var
        Client: HttpClient;
        RequestHeaders: HttpHeaders;
        RequestContent: HttpContent;
        ResponseMessage: HttpResponseMessage;
        ResponseText: Text;
        RequestBodyJson: JsonObject;
        contentHeaders: HttpHeaders;
        Body: Text;
    begin
        RequestHeaders := Client.DefaultRequestHeaders();
        RequestBodyJson := GetOrderContent(Folder);
        RequestBodyJson.WriteTo(Body);
        RequestContent.WriteFrom(Body);
        RequestContent.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');
        Client.Post(EndPoint, RequestContent, ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode then begin
            ResponseMessage.Content.ReadAs(ResponseText);
            error(ResponseText);
        end;
    end;
    */
    /*  EDI parametro descarga devoluciones: DOWNLOADRETURN  */
    procedure GetEDIReturns()
    var
        rSalesSetup: record "Sales & Receivables Setup";
    begin
        rSalesSetup.Get();
        rSalesSetup.Testfield("EDI Download PA Endpoint");
        //>> BBT. No se usa la carpeta d01b
        //rSalesSetup.TestField("EDI - Returns d01b FTP Folder");
        //GetDocuments(rSalesSetup."EDI Download PA Endpoint", rSalesSetup."EDI - Returns d01b FTP Folder");
        //<<
        rSalesSetup.TestField("EDI - Returns d96a FTP Folder");
        GetDocuments(rSalesSetup."EDI Download PA Endpoint", rSalesSetup."EDI - Returns d96a FTP Folder");
    end;

    procedure GetDocuments(EndPoint: text; Folder: text)
    var
        Client: HttpClient;
        RequestHeaders: HttpHeaders;
        RequestContent: HttpContent;
        ResponseMessage: HttpResponseMessage;
        ResponseText: Text;
        RequestBodyJson: JsonObject;
        contentHeaders: HttpHeaders;
        Body: Text;
    begin
        RequestHeaders := Client.DefaultRequestHeaders();
        RequestBodyJson := GetOrderContent(Folder);
        RequestBodyJson.WriteTo(Body);
        RequestContent.WriteFrom(Body);
        RequestContent.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');
        Client.Post(EndPoint, RequestContent, ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode then begin
            ResponseMessage.Content.ReadAs(ResponseText);
            error(ResponseText);
        end;
    end;

    /*  EDI parametro procesamiento pedidos :   PROCESSORDERS   */
    local procedure ProcessOrders()
    var
        rEDIEntry: record "EDI - EDI Entry";
        EDIFilesManagement: Codeunit "BBT EDI Files Management";
        rEDIEntry2: Record "EDI - EDI Entry";
    begin
        rEDIEntry.SetRange("Processed at", 0DT);
        rEDIEntry.SetRange("Inbound/Outbound", rEDIEntry."Inbound/Outbound"::Inbound);
        if rEDIEntry.FindSet() then
            repeat
                Clear(rEDIEntry2);
                rEDIEntry2.SetRange("File name", rEDIEntry."File name");
                rEDIEntry2.SetFilter("Processed at", '<>%1', CreateDateTime(0D, 0T));
                rEDIEntry2.setrange(Uploaded, true);
                IF not rEDIEntry2.FindFirst() then begin
                    if EDIFilesManagement.Run(rEDIEntry) then begin
                        rEDIEntry.Get(rEDIEntry."Entry No.");
                        rEDIEntry.Validate("Has error", false);
                        rEDIEntry.Validate("Last error text", '');
                        if rEDIEntry."Inbound/Outbound" = rEDIEntry."inbound/outbound"::Inbound then
                            rEDIEntry.Validate("Document Nos.", EDIFilesManagement.GetDocumentNo);
                    end
                    else begin
                        rEDIEntry.Get(rEDIEntry."Entry No.");
                        rEDIEntry.Validate("Has error", true);
                        rEDIEntry.Validate("Last error text", GetLastErrorText);
                        if rEDIEntry."Inbound/Outbound" = rEDIEntry."inbound/outbound"::Inbound then
                            rEDIEntry.Validate("Document Nos.", '');
                    end;
                    rEDIEntry.Validate("Processed at", CurrentDatetime);
                    rEDIEntry.Validate(Uploaded, true);
                    rEDIEntry.Modify(true);
                    Commit();
                end
                else begin
                    rEDIEntry.Validate("Has error", true);
                    rEDIEntry.Validate("Last error text", 'Registro repetido');
                    rEDIEntry.Validate("Processed at", CurrentDatetime);
                    rEDIEntry.Validate(Uploaded, true);
                    rEDIEntry.Modify(true);
                    Commit();
                end;
            until rEDIEntry.Next() = 0;
    end;
    /*  EDI parámetro subida albaranes :    UPLOADSHIPMENTS */
    procedure UploadShipments()
    var
        rEDIEntry: record "EDI - EDI Entry";
        EDIFilesManagement: Codeunit "BBT EDI Files Management";
    begin
        //>> Primero eliminamos errores para reintentar subir los albaranes. SOLO los de una semana antes.
        EDIFilesManagement.PrepareShipmentsForRetry();
        //<<
        rEDIEntry.SetRange("Processed at", 0DT);
        rEDIEntry.SetRange("Upload in progress", false);
        rEDIEntry.SetRange("Inbound/Outbound", rEDIEntry."Inbound/Outbound"::Outbound);
        rEDIEntry.SetRange("Document type", rEDIEntry."Document type"::Shipment);
        rEDIEntry.SetRange(Uploaded, false);
        if rEDIEntry.FindSet() then
            repeat
                if EDIFilesManagement.Run(rEDIEntry) then begin
                    rEDIEntry.Get(rEDIEntry."Entry No.");
                    rEDIEntry.Validate("Has error", false);
                    rEDIEntry.Validate("Last error text", '');
                    if rEDIEntry."Inbound/Outbound" = rEDIEntry."inbound/outbound"::Inbound then
                        rEDIEntry.Validate("Document Nos.", EDIFilesManagement.GetDocumentNo);
                end
                else begin
                    rEDIEntry.Get(rEDIEntry."Entry No.");
                    rEDIEntry.Validate("Has error", true);
                    rEDIEntry.Validate("Last error text", GetLastErrorText);
                    if rEDIEntry."Inbound/Outbound" = rEDIEntry."inbound/outbound"::Inbound then
                        rEDIEntry.Validate("Document Nos.", '');
                end;
                rEDIEntry.Validate("Processed at", CurrentDatetime);
                rEDIEntry.Validate("Received/Sent at", CurrentDatetime);
                rEDIEntry.Validate(Uploaded, true);
                rEDIEntry.Modify(true);
                Commit();
            until rEDIEntry.Next() = 0;
    end;

    /*  EDI parametro subida facturas:    UPLOADINVOICES    */
    procedure UploadInvoices()
    var
        rEDIEntry: record "EDI - EDI Entry";
        rSalesReceivablesSetup: Record "Sales & Receivables Setup";
        rlSalesInvoiceHeader: Record "Sales Invoice Header";
        rlCustomer: Record Customer;
        EDIFilesManagement: Codeunit "BBT EDI Files Management";
        vRealPostingDate: Date;
        Delay: DateFormula;
        Text001Err: Label 'The work date is less than the one established in the customer card.',
                    Comment = 'ESP="La fecha de trabajo es inferior a la establecida en la ficha del cliente."';
    begin
        rSalesReceivablesSetup.Get;
        rEDIEntry.SetRange("Inbound/Outbound", rEDIEntry."Inbound/Outbound"::Outbound);
        rEDIEntry.SetRange("Document type", rEDIEntry."Document type"::Invoice);
        rEDIEntry.SetRange("Upload in progress", false);
        rEDIEntry.SetRange("Processed at", 0DT);
        rEDIEntry.SetRange(Uploaded, false);
        if rEDIEntry.FindSet() then
            repeat
                if rSalesReceivablesSetup."EDI - Sales Invoice Auto Send" then begin
                    if rlSalesInvoiceHeader.Get(rEDIEntry."Document Nos.") then;
                    Clear(vRealPostingDate);
                    if rlCustomer.Get(rlSalesInvoiceHeader."Sell-to Customer No.") then begin
                        Evaluate(Delay, '<0D>');
                        if Format(rlCustomer."BBT EDI Invoice Sending Delay") <> '' then
                            Delay := rlCustomer."BBT EDI Invoice Sending Delay";
                        vRealPostingDate := CalcDate(Delay, rlSalesInvoiceHeader."Posting Date");
                        if WorkDate() >= vRealPostingDate then begin
                            if EDIFilesManagement.Run(rEDIEntry) then begin
                                rEDIEntry.Get(rEDIEntry."Entry No.");
                                rEDIEntry.Validate("Has error", false);
                                rEDIEntry.Validate("Last error text", '');
                                if rEDIEntry."Inbound/Outbound" = rEDIEntry."inbound/outbound"::Inbound then
                                    rEDIEntry.Validate("Document Nos.", EDIFilesManagement.GetDocumentNo);
                            end
                            else begin
                                rEDIEntry.Get(rEDIEntry."Entry No.");
                                rEDIEntry.Validate("Has error", true);
                                rEDIEntry.Validate("Last error text", GetLastErrorText);
                                if rEDIEntry."Inbound/Outbound" = rEDIEntry."inbound/outbound"::Inbound then
                                    rEDIEntry.Validate("Document Nos.", '');
                            end;
                            rEDIEntry.Validate("Processed at", CurrentDatetime);
                            rEDIEntry.Validate(Uploaded, true);
                            rEDIEntry.Modify(true);
                            Commit();
                        end;
                    end;
                end;
            until rEDIEntry.Next() = 0;
    end;

    /*  EDI parámetro proceso subida PDF :  UPLOADPDF   */
    /*
            procedure UploadShipmentPDFS()
            var
                EDIEntry: record "EDI - EDI Entry";
                SalesReceivablesSetup: record "Sales & Receivables Setup";
            begin
                SalesReceivablesSetup.Get();
                SalesReceivablesSetup.TestField("PDF - Sales Shpt. FTP ECI");
                EDIEntry.SetRange("Upload in progress", false);
                EDIEntry.SetRange("Inbound/Outbound", EDIEntry."Inbound/Outbound"::Outbound);
                EDIEntry.SetRange("Document type", EDIEntry."Document type"::"Shipment PDF");
                if EDIEntry.FindSet() then
                    repeat
                        UploadEdifile(EDIEntry, SalesReceivablesSetup."PDF - Sales Shpt. FTP ECI")
                    until EDIEntry.Next() = 0;
            end;
    */

    procedure GetFileDataContect(EdiFile: record "EDI - EDI Entry"; Folder: text) Json: JsonObject
    var
        PropertiesJson: JsonObject;
        ContentTxt: text;
        Text: text;
        IStream: InStream;
        EnvironmentInfo: codeunit "Environment Information";
        CRLF: text[2];
    begin
        CRLF := '';
        CRLF[1] := 13;
        CRLF[2] := 10;
        EdiFile.CalcFields("File Blob");
        EdiFile."File Blob".CreateInStream(IStream); //TODO , TextEncoding::Windows);
        while not IStream.eos do begin
            IStream.ReadText(Text);
            ContentTxt += text + CRLF;
        end;
        //ContentTxt := ConvertText(ContentTxt);
        Json.Add('fileName', EdiFile."File name");
        Json.Add('fileContent', ContentTxt);
        Json.Add('folder', folder);
        Json.add('systemid', GetId(EdiFile.SystemId));
        json.Add('companyid', GetCompanyId);
        Json.Add('environment', EnvironmentInfo.GetEnvironmentName());
    end;

    procedure UploadShipmentFileToFTP(var EDIEDIEntry: Record "EDI - EDI Entry")
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        rShipAux: Record "Sales Shipment Header";
        rCust: Record Customer;
        rEDIDirectoryAssignament: Record "EDI Directory Assignament";
    begin
        begin
            SalesReceivablesSetup.Reset;
            SalesReceivablesSetup.Get;
            SalesReceivablesSetup.TestField("EDI - Sales Shpt. FTP MM");    //d01b
            SalesReceivablesSetup.TestField("EDI - Sales Shpt. FTP ECI");   //d96a

            if EDIEDIEntry."Document type" <> EDIEDIEntry."document type"::Shipment then // Este error no debería saltar nunca
                Error('Existe un error inesperado - Por favor póngase en contacto con el administrador del sistema para continuar');

            EDIEDIEntry.TestField("Document Nos.");
            EDIEDIEntry.CalcFields("File Blob");
            if not EDIEDIEntry."File Blob".Hasvalue then
                Error('Ha habido un error inesperado en la generación del fichero');

            rShipAux.Reset;
            rShipAux.SetRange("No.", EDIEDIEntry."Document Nos.");
            if not rShipAux.FindFirst then
                Error('No existe el documento %1', EDIEDIEntry."Document Nos.")
            else begin
                rCust.Reset;
                rCust.SetRange("No.", rShipAux."Sell-to Customer No.");
                if rCust.FindSet then begin
                    //>> BBT 10/12/2024. Las carpetas se asignan de los Directorios indicados en la ficha de los clientes.
                    rEDIDirectoryAssignament.Reset();
                    rEDIDirectoryAssignament.SetRange("Code", rCust."EDI Directory");
                    if rEDIDirectoryAssignament.FindFirst() then begin
                        case
                            rEDIDirectoryAssignament."DESADV Folder" of
                            rEDIDirectoryAssignament."DESADV Folder"::d01b:
                                UploadEdifile(EDIEDIEntry, SalesReceivablesSetup."EDI - Sales Shpt. FTP MM");
                            rEDIDirectoryAssignament."DESADV Folder"::d96a:
                                UploadEdifile(EDIEDIEntry, SalesReceivablesSetup."EDI - Sales Shpt. FTP ECI")
                            else
                                Error('No hay carpeta para envios de albaránes del grupo cliente %1', rCust."EDI Directory");
                        end;
                    end else begin
                        Error('No hay carpeta para envios de albaránes del grupo cliente %1', rCust."EDI Directory");
                    end;
                    //<<
                    /*  
                    //HAY UNA CARPETA PARA MM Y OTRA PARA ECI                   
                    if (rCust."Purchase Group" = 'CORTICOR') or (rCust."Purchase Group" = 'NORAUTO') then
                        UploadEdifile(EDIEDIEntry, SalesReceivablesSetup."EDI - Sales Shpt. FTP ECI")   //    /envio/desadv_d96a/
                    else
                        if rCust."Purchase Group" = 'MM' then
                            UploadEdifile(EDIEDIEntry, SalesReceivablesSetup."EDI - Sales Shpt. FTP MM")    //  /envio/desadv_d01b/
                        else
                            if rCust."Purchase Group" = 'CARREFOUR' then
                                UploadEdifile(EDIEDIEntry, SalesReceivablesSetup."EDI - Sales Shpt. FTP Carrefou")  // Esta vacio
                            else
                                //UploadEdifile(EDIEDIEntry, SalesReceivablesSetup."EDI - Sales Shpt. FTP ECI");   //  /envio/desadv_d96a/
                                Error('No hay carpeta para envios albarán del grupo cliente %1', rCust."Purchase Group");
                    */
                end;
            end;
        end;
    end;

    procedure UploadInvoiceFileToFTP(var EDIEDIEntry: Record "EDI - EDI Entry")
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        rInvAux: Record "Sales Invoice Header";
        rCust: Record Customer;
        rEDIDirectoryAssignament: Record "EDI Directory Assignament";
    begin
        begin
            SalesReceivablesSetup.Reset;
            SalesReceivablesSetup.Get;
            SalesReceivablesSetup.TestField("EDI - Sales Invoice FTP d93a");
            SalesReceivablesSetup.TestField("EDI - Sales Invoice FTP d01b");
            SalesReceivablesSetup.TestField("EDI - Sales Invoice FTP d96a");

            if EDIEDIEntry."Document type" <> EDIEDIEntry."document type"::Invoice then // Este error no debería saltar nunca
                Error('Existe un error inesperado - Por favor póngase en contacto con el administrador del sistema para continuar');

            EDIEDIEntry.TestField("Document Nos.");
            EDIEDIEntry.CalcFields("File Blob");
            if not EDIEDIEntry."File Blob".Hasvalue then
                Error('Ha habido un error inesperado en la generación del fichero');

            rInvAux.Reset;
            rInvAux.SetRange("No.", EDIEDIEntry."Document Nos.");
            if not rInvAux.FindFirst then
                Error('No existe el documento %1', EDIEDIEntry."Document Nos.")
            else begin
                rCust.Reset;
                rCust.SetRange("No.", rInvAux."Sell-to Customer No.");
                if rCust.FindSet then begin
                    //>> BBT 10/12/2024.  Las carpetas se asignan de los Directorios indicados en la ficha de los clientes.
                    rEDIDirectoryAssignament.Reset();
                    rEDIDirectoryAssignament.SetRange("Code", rCust."EDI Directory");
                    if rEDIDirectoryAssignament.FindFirst() then begin
                        case
                            rEDIDirectoryAssignament."INVOIC Folder" of
                            rEDIDirectoryAssignament."INVOIC Folder"::d01b:
                                UploadEdifile(EDIEDIEntry, SalesReceivablesSetup."EDI - Sales Invoice FTP d01b");
                            rEDIDirectoryAssignament."INVOIC Folder"::d93a:
                                UploadEdifile(EDIEDIEntry, SalesReceivablesSetup."EDI - Sales Invoice FTP d93a");
                            rEDIDirectoryAssignament."INVOIC Folder"::d96a:
                                UploadEdifile(EDIEDIEntry, SalesReceivablesSetup."EDI - Sales Invoice FTP d96a")
                            else
                                Error('No hay carpeta para envío de facturas del grupo cliente %1', rCust."EDI Directory");
                        end;
                    end else begin
                        Error('No hay carpeta para envío de facturas del grupo cliente %1', rCust."EDI Directory");
                    end;
                    //<<
                    /*
                    if (rCust."Purchase Group" = 'MM') or (rCust."Purchase Group" = 'SONAE') then
                        UploadEdifile(EDIEDIEntry, SalesReceivablesSetup."EDI - Sales Invoice FTP d01b")
                    else if (rCust."Purchase Group" = 'AMAZON') then
                        UploadEdifile(EDIEDIEntry, SalesReceivablesSetup."EDI - Sales Invoice FTP d96a")
                    else
                        UploadEdifile(EDIEDIEntry, SalesReceivablesSetup."EDI - Sales Invoice FTP d93a")
                    */
                end;
            end;
            Commit();
            EDIEDIEntry.Get(EDIEDIEntry."Entry No.");
            EDIEDIEntry.Validate("Received/Sent at", CurrentDatetime);
            EDIEDIEntry.Validate("Processed at", CurrentDatetime);
            EDIEDIEntry.Modify(true);
        end;
    end;

    procedure UploadEdifile(EdiFiles: record "EDI - EDI Entry"; Folder: text)
    var
        SalesSetup: record "Sales & Receivables Setup";
        Client: HttpClient;
        RequestHeaders: HttpHeaders;
        RequestContent: HttpContent;
        ResponseMessage: HttpResponseMessage;
        ResponseText: Text;
        RequestBodyJson: JsonObject;
        contentHeaders: HttpHeaders;
        Body: Text;
        EDIUploadEndPoint: Text[1024];
    begin
        SalesSetup.Get();
        case EdiFiles."Document type" of
            Edifiles."Document type"::"Shipment PDF":
                begin
                    SalesSetup.TestField("EDI Upload PDF PA Endpoint");
                end;
            Edifiles."Document type"::Shipment, Edifiles."Document type"::Invoice:
                begin
                    SalesSetup.TestField("EDI Upload PA Endpoint");
                    SalesSetup.TestField("EDI PL - Upload PA Endpoint");

                    Clear(EDIUploadEndPoint);
                    EDIUploadEndPoint := SalesSetup."EDI Upload PA Endpoint";
                    if EdiFiles."PL Entry" then
                        EDIUploadEndPoint := SalesSetup."EDI PL - Upload PA Endpoint";
                end;
        end;
        RequestHeaders := Client.DefaultRequestHeaders();
        RequestBodyJson := GetFileDataContect(EdiFiles, Folder);
        RequestBodyJson.WriteTo(Body);
        RequestContent.WriteFrom(Body);
        RequestContent.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');
        EdiFiles."Upload in progress" := true;
        EdiFiles.Validate("Received/Sent at", CurrentDatetime);
        case EdiFiles."Document type" of
            Edifiles."Document type"::"Shipment PDF":
                begin
                    If Client.Post(SalesSetup."EDI Upload PDF PA Endpoint", RequestContent, ResponseMessage) then begin
                        EdiFiles.Uploaded := true;
                        if not ResponseMessage.IsSuccessStatusCode then begin
                            EdiFiles.Uploaded := false;
                            EdiFiles."Upload in progress" := false;
                        end;
                    end;
                end;
            Edifiles."Document type"::Shipment, Edifiles."Document type"::Invoice:
                begin
                    If Client.Post(EDIUploadEndPoint, RequestContent, ResponseMessage) or (ResponseMessage.HttpStatusCode = 400) then begin
                        EdiFiles.Uploaded := true;
                        if (not ResponseMessage.IsSuccessStatusCode) then begin
                            EdiFiles.Uploaded := false;
                            EdiFiles."Upload in progress" := false;
                            Error('Error Response Message: %1 %2', ResponseMessage.HttpStatusCode, ResponseMessage.ReasonPhrase);
                        end;
                    end;
                end;
        end;
        EdiFiles.Modify();
    end;
    /*
        procedure SendShipmentReportToEDIEntry(var EDIEDIEntry: Record "EDI - EDI Entry")
        var
            SalesShipmentHeader: Record "Sales Shipment Header";
            Customer: Record Customer;
            SalesReceivablesSetup: Record "Sales & Receivables Setup";
            Base64: codeunit "Base64 Convert";
            PdfFileName: Text;
            OnlyFileName: Text;
            EDIEntryPDF: record "EDI - EDI Entry";
            EDIInvoice: report "Sales - Shipment 2";
            SalesShipment2: record "Sales Shipment Header";
            RecRef: RecordRef;
            TempBlob: codeunit "Temp Blob";
            OStream: OutStream;
            IStream: InStream;
            OStreampdf: OutStream;
            FileContent: text;
        begin
            SalesShipmentHeader.Reset;
            SalesShipmentHeader.Get(EDIEDIEntry."Document Nos.");
            SalesShipmentHeader.TestField("EDI - Do not send EDI", false);
            //SalesShipmentHeader.SETRANGE(SalesShipmentHeader."No.",'AV8-10281');
            if SalesShipmentHeader.FindFirst then begin
                Customer.Reset;
                Customer.Get(SalesShipmentHeader."Sell-to Customer No.");
                if Customer."Purchase Group" = 'MM' then begin
                    SalesReceivablesSetup.Get;
                    OnlyFileName := '800539_' + CopyStr(SalesShipmentHeader."No.", 5, 5) + '.pdf';
                    SalesShipment2.SETRANGE("No.", SalesShipmentHeader."No.");
                    SalesShipment2.SetRecFilter();
                    RecRef.GetTable(SalesShipment2);
                    TempBlob.CreateOutStream(OStream);
                    SaveReportAsPDFInStream(OStream, 50000, SalesShipment2);
                    Tempblob.CreateInStream(IStream);
                    FileContent := base64.ToBase64(IStream);
                    EDIEntryPDF.Insert(true);
                    EDIEntryPDF."Document type" := EDIEntryPDF."Document type"::"Shipment PDF";
                    EDIEntryPDF."File name" := OnlyFileName;
                    EDIEntryPDF."File Blob".CreateOutStream(OStreampdf);
                    OStreampdf.WriteText(FileContent);
                    EDIEntryPDF."Inbound/Outbound" := EDIEntryPDF."Inbound/Outbound"::Outbound;
                    EDIEntryPDF.Modify();
                end;

            end;
        end;
    */
    /*
    procedure SaveReportAsPDFInStream(var OStream: OutStream; ReportId: Integer; RecordVariant: Variant)
    var
        recRef: RecordRef;
        isRead: InStream;
        txtFileName: Text;
        txtFilePDF: TextBuilder;
        txtBlob: Text;
    begin
        recRef.GetTable(RecordVariant);
        Report.SaveAs(ReportId, '', ReportFormat::Pdf, OStream, recRef);
    end;
    */


    /* PROCEDURES AUXILIARES    
    local procedure ConvertText(StringIni: Text): Text
    var
        NewString: Text;
        BaseText: label 'áàéèíìòóùúÁÀÉÈÍÌÓÒÚÙäëïöüÄËÏÖÜâêîôûÂÊÎÔÛºªçÇñÑ';
        CorrectedText: label 'aaeeiioouuAAEEIIOOUUaeiouAEIOUaeiouAEIOUoacCnN';
    begin

        Clear(NewString);

        NewString := ConvertStr(StringIni, BaseText, CorrectedText);

        exit(NewString);
    end;
*/
    local procedure GetOrderContent(Folder: Text) Json: JsonObject
    var
        PropertiesJson: JsonObject;
        ContentTxt: text;
        Text: text;
        IStream: InStream;
        EnvironmentInfo: codeunit "Environment Information";
    begin
        Json.Add('folder', folder);
        json.Add('companyid', GetCompanyId);
        Json.Add('environment', EnvironmentInfo.GetEnvironmentName());
    end;

    local procedure GetCompanyId(): Text
    var
        Company: record Company;
    begin
        Company.Get(CompanyName);
        exit(GetId(Company.SystemId));
    end;

    local procedure GetId(GUID: text): text
    begin
        exit(DELCHR(format(guid), '=', '{}'))
    end;


}