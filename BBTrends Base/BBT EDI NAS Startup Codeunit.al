Codeunit 50007 "EDI - NAS Startup"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        CompanyInformation: Record "Company Information";
        SalesShipmentHeader: Record "Sales Shipment Header";
        EDIEDIEntry: Record "EDI - EDI Entry"; // T5013
        //>> BBT. 29/05/2026. Codeunit Obsoletas
        //EDIFileprocessing: Codeunit "EDI - File processing v2 OBS";
        EDIFileprocessing: Codeunit "BBT EDI Files Management";

    begin
        case Rec."Parameter String" of
            'EDI':
                begin
                    CompanyInformation.Reset;
                    CompanyInformation.Get;
                    if CompanyInformation."EDI ID" = '' then exit;
                    // Preparamos los albaranes para intentarlo de nuevo en caso de faltar los embalajes
                    EDIFileprocessing.PrepareShipmentsForRetry;
                    Commit;
                end;
            'PACKAGING':
                GetMissingPackagingInformation;
            'READYJOBENTRIES':
                ReadyJobQueueEntries;
            '':
                begin
                    case ActionType of
                        Actiontype::"Import Packages":
                            begin
                                SalesShipmentHeader.Reset;
                                SalesShipmentHeader.Get(DocNo);
                                GetMissingPackagingInformationForSalesShptHeader(SalesShipmentHeader);
                            end;
                        else
                            Error('Se ha realizado una llamada incorrecta');
                    end;
                end;
            else
                Error('Se ha realizado una llamada incorrecta');
        end;
    end;

    var
        ActionType: Option " ","Import Packages";
        DocNo: Code[20];

    procedure GetMissingPackagingInformation()
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        DummyJobQueueEntry: Record "Job Queue Entry";
        //InterfaceSGA: Codeunit "Interface SGA";
        cuPackaging: Codeunit "BBT Packaging";
        EDINASStartup: Codeunit "EDI - NAS Startup";
    begin
        SalesShipmentHeader.Reset;
        SalesShipmentHeader.SetRange("Posting Date", Today - 7);
        //SalesShipmentHeader.SETRANGE("Packaging Count",0);
        SalesShipmentHeader.SetRange("Packaging Lines Count", 0);
        if SalesShipmentHeader.FindSet then
            repeat
                //InterfaceSGA.GetPackagingLinesFromSalesShptHeader(SalesShipmentHeader);
                cuPackaging.GetPackagingLinesFromSalesShptHeader(SalesShipmentHeader);
                Clear(EDINASStartup);
                Commit();
                EDINASStartup.SetActionInformation(Actiontype::"Import Packages", SalesShipmentHeader."No.");
                if EDINASStartup.Run(DummyJobQueueEntry) then;
                Commit;
            until SalesShipmentHeader.Next = 0;
    end;

    local procedure GetMissingPackagingInformationForSalesShptHeader(SalesShipmentHeader: Record "Sales Shipment Header")
    var
        //InterfaceSGA: Codeunit "Interface SGA";
        cuPackaging: Codeunit "BBT Packaging";
    begin
        //InterfaceSGA.GetPackagingLinesFromSalesShptHeader(SalesShipmentHeader);
        cuPackaging.GetPackagingLinesFromSalesShptHeader(SalesShipmentHeader);
    end;

    procedure SetActionInformation(parActionType: Integer; parDocNo: Code[20])
    begin
        ActionType := parActionType;
        DocNo := parDocNo;
    end;

    local procedure ReadyJobQueueEntries()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.Reset;
        JobQueueEntry.SetRange("Retry on Error", true);
        JobQueueEntry.SetRange(Status, JobQueueEntry.Status::Error);
        if JobQueueEntry.FindSet then
            repeat
                JobQueueEntry.SetStatus(JobQueueEntry.Status::Ready);
            //JobQueueEntry.validate(Status, );
            //if JobQueueEntry.Modify() then;
            until JobQueueEntry.Next = 0;
    end;
}
