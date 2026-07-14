codeunit 50011 "BBT Packaging"
{
    trigger OnRun();
    begin
    end;

    var
        PackingError: Text;
        //rCompanyInformation: Record "Company Information";
        //cuInterfaseSGA: Codeunit "Interface SGA";
        //cuSGAManagement: Codeunit "SGA Management";
        //SGACallProcedure: enum "SGA Call to Procedure";
        SGACallType: Enum "SGA Call Type";
        SGAJsonObject: JsonObject;
        ResponseTxt: text;
        ArrayJSONManagement: Codeunit "JSON Management";
        ObjectJSONManagement: Codeunit "JSON Management";
        Comilla: Label '''';
        Index: Integer;
        ValueText: Text;
        BloqueoDocumentoJsonObject: Text;

    procedure GetPackagingLinesFromSalesShptHeader(SalesShipmentHeader: Record "Sales Shipment Header");
    var
        rPostedWhseShipmentHeader: Record "Posted Whse. Shipment Header";
        rPostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        Error01: Label 'No warehouse delivery lines were found for the registered shipment ',
                Comment = 'ESP="No se han encontrado líneas de entrega de almacén para el envío registrado "';
    begin
        //rCompanyInformation.get();

        clear(PackingError);
        SalesShipmentHeader.TestField("No.");
        rPostedWhseShipmentLine.Reset();
        rPostedWhseShipmentLine.SetRange("Posted Source Document", rPostedWhseShipmentLine."Posted Source Document"::"Posted Shipment");
        rPostedWhseShipmentLine.SetRange("Posted Source No.", SalesShipmentHeader."No.");
        if rPostedWhseShipmentLine.Findset() then begin
            rPostedWhseShipmentHeader.Reset();
            if rPostedWhseShipmentHeader.Get(rPostedWhseShipmentLine."No.") then
                //Commit();
                if rPostedWhseShipmentHeader."No." <> '' then begin
                    //if rCompanyInformation.SGA then
                    //cuInterfaseSGA.GetPackagingLines(rPostedWhseShipmentHeader);
                    //else
                    //    if cuSGAManagement.IsSGAEnabled then
                    GetPackagingLines(rPostedWhseShipmentHeader);
                    Commit();
                end;
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
        /**/
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

            until PostedWhseShipmentLine.Next() = 0;

        NoEntregaAlmacen := '';
        SQLLanguage := '5';
        // Primero recuperamos el nº entrega almacén
        Clear(SGAJsonObject);
        Clear(ResponseTxt);
        SGAJsonObject.Add('filter', 'NumeroDocumento eq ' + Comilla + pPostedWhseShipmentHeader."Whse. Shipment No." + Comilla);
        HttpCallPackaging(SGACallType::"Leer entrega almacen", SGAJsonObject);
        //cuSGAManagement.HttpCall(SGACallProcedure::"Read Warehouse Delivery", SGAJsonObject, ResponseTxt);
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
            HttpCallPackaging(SGACallType::"Leer packing list", SGAJsonObject);
            //cuSGAManagement.HttpCall(SGACallProcedure::"Read packing list", SGAJsonObject, ResponseTxt);
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
                            Packaging."Number of Boxes" := 0; // Pendiente Definir
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

    procedure HttpCallPackaging(SGACallType: Enum "SGA Call Type"; SGAJsonObject: JsonObject)
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
            SGACallType::"Leer entrega almacen":
                begin
                    RequestURL := SalesReceivable."SGA-Read location entry Endp";
                end;
            SGACallType::"Leer packing list":
                begin
                    RequestURL := SalesReceivable."SGA-Read packing list Endp";
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

    procedure GetPackingError(): text
    begin
        exit(PackingError);
    end;
}