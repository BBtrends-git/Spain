XmlPort 50038 "Szendex - Tracking Info XML"
{
    Direction = Import;
    Encoding = UTF8;
    Namespaces = soapenv = 'http://schemas.xmlsoap.org/soap/envelope/', dir = 'http://www.direcline.com/';
    Permissions = TableData "Sales Shipment Header" = rimd;

    schema
    {
        textelement(Tracking)
        {
            textelement(headerestado)
            {
                XmlName = 'ESTADO';

                textelement(SOLICITUDRECOGIDA)
                { }
                //BBT. 19/05/2026. Añadido por SZENDEX ¿?
                textelement(SOLICITUDRECOGIDARESTJSON)
                { }
                //<<
                textelement(TIPOTRACKING)
                { }
                textelement(IDORDENSERVICIO)
                { }
                textelement(IDEXPEDICION)
                { }
                textelement(ORDENPEDIDO)
                { }
                textelement(REFERENCIAENTREGA)
                { }
                textelement(ESTADO)
                { }
                textelement(FECHA)
                { }
                textelement(FECHATRACKING)
                { }
                textelement(CODIGOTIPOINCIDENCIA)
                { }
                textelement(TEXTOINCIDENCIA)
                { }
                textelement(DNI)
                { }
                textelement(FIRMA)
                { }
                textelement(OBSERVACIONPOD)
                { }
                textelement(TELEFONOPOD)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        ProcessLine
                    end;
                }
            }
        }
    }
    requestpage
    {
        layout
        { }
        actions
        { }
    }
    var
        GlobalGUID: Text;
        GlobalDeliveryStartingDate: DateTime;
        GlobalDeliveryEndingDate: DateTime;
        GlobalStatusStartingDate: DateTime;
        GlobalStatusEndingDate: DateTime;
        GlobalStartingReference: Text;
        GlobalEndingReference: Text;

    procedure SetParameters(parGUID: Text; DeliveryStartingDate: DateTime; DeliveryEndingDate: DateTime; StatusStartingDate: DateTime; StatusEndingDate: DateTime; StartingReference: Text; EndingReference: Text)
    begin
        GlobalGUID := parGUID;
        GlobalDeliveryStartingDate := DeliveryStartingDate;
        GlobalDeliveryEndingDate := DeliveryEndingDate;
        GlobalStatusStartingDate := StatusStartingDate;
        GlobalStatusEndingDate := StatusEndingDate;
        GlobalStartingReference := StartingReference;
        GlobalEndingReference := EndingReference;
    end;

    local procedure ProcessLine()
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SzendexTrackingStatus: Record 50016;
        DummyDateTime: DateTime;
        StatusEntregado: Text[50];
        Entregado: label 'Entregado';
    begin
        if REFERENCIAENTREGA = '' then exit; //ERROR('El no de tracking es obligatorio');

        SalesShipmentHeader.Reset;
        SalesShipmentHeader.SetRange("Package Tracking No.", REFERENCIAENTREGA);
        if not SalesShipmentHeader.FindSet then exit;
        Clear(StatusEntregado);
        SzendexTrackingStatus.Reset;
        SzendexTrackingStatus.SetRange("Shipment Delivered", true);
        if SzendexTrackingStatus.FindFirst then StatusEntregado := UpperCase(SzendexTrackingStatus.Status);
        Evaluate(DummyDateTime, FECHATRACKING);
        //IF SalesShipmentHeader."Sh. Agent - Tracking Type"<FECHATRACKING THEN BEGIN
        if (SalesShipmentHeader."Sh. Agent - Tracking Date" <= DummyDateTime) or (UpperCase(ESTADO) = StatusEntregado) then begin
            if SalesShipmentHeader."Sh. Agent - Status" <> '' then begin
                SzendexTrackingStatus.Reset;
                SzendexTrackingStatus.SetRange(Status, SalesShipmentHeader."Sh. Agent - Status");
                SzendexTrackingStatus.SetRange(Type, SzendexTrackingStatus.Type::Szendex);
                if SzendexTrackingStatus.FindSet and (SzendexTrackingStatus."Shipment Delivered" or SzendexTrackingStatus."Shipment Finished") then exit;
            end;
            SalesShipmentHeader."Sh. Agent - Tracking Type" := CopyStr(TIPOTRACKING, 1, MaxStrLen(SalesShipmentHeader."Sh. Agent - Tracking Type"));
            //IF EVALUATE(SalesShipmentHeader."Sze - Tracking Date",FECHATRACKING) THEN;
            SalesShipmentHeader."Sh. Agent - Tracking Date" := DummyDateTime;
            SalesShipmentHeader."Sh. Agent - Status" := UpperCase(CopyStr(ESTADO, 1, MaxStrLen(SalesShipmentHeader."Sh. Agent - Status")));
            SalesShipmentHeader.Validate("Sh. Agent - Status");
            //>> BBT 23/02/2023
            if SalesShipmentHeader."Sh. Agent - Status" = UpperCase(Entregado) then
                GrabarPodEnRecordLink(SalesShipmentHeader);
            //<<
            SalesShipmentHeader.Modify;
        end;
        AddStatus(ESTADO);
    end;

    local procedure AddStatus(StatusText: Code[50])
    var
        SzendexTrackingStatus: Record 50016;
    begin
        if StatusText = '' then exit;
        SzendexTrackingStatus.Reset;
        if not SzendexTrackingStatus.Get(StatusText) then begin
            SzendexTrackingStatus.Init;
            SzendexTrackingStatus.Validate(Status, StatusText);
            SzendexTrackingStatus.Insert(true);
        end;
    end;

    local procedure GrabarPodEnRecordLink(var SalesShipmentHeader: Record "Sales Shipment Header")
    var
        RecordLink: Record "Record Link";
        RecordLinkManagement: Codeunit "Record Link Management";
        RecordLinkID: RecordID;
    begin
        if SalesShipmentHeader."Package Tracking No." <> '' then begin
            RecordLink.Init;
            RecordLink."Record ID" := SalesShipmentHeader.RecordId;
            RecordLink.URL1 := 'https://erp.szendex.com/DlWebTrackingVWE/?seg=' + SalesShipmentHeader."Package Tracking No.";
            RecordLink.Description := 'POD - ' + Format(SalesShipmentHeader."No.");
            RecordLink.Type := 0;
            RecordLink.Created := CurrentDatetime;
            RecordLink."User ID" := UserId;
            RecordLink.Company := COMPANYNAME;
            RecordLink.Notify := false;
            RecordLink.Insert;
        end
    end;
}
