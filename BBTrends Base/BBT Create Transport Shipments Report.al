Report 50011 "Create Transport Shipments"
{
    Caption = 'Create Transport Shipments', comment = 'ESP="Crear envíos de transporte"';
    Permissions = TableData "Sales Shipment Header" = m,
        TableData "Transport Shipment" = im;
    ProcessingOnly = true;

    dataset
    {
        dataitem(SalesShipmentFilters; "Sales Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Shipment Date", "Shipping Agent Code";

            column(ReportForNavId_1100234001; 1100234001)
            { }
            trigger OnPreDataItem()
            begin
                CheckReportFilters;
                if (SalesShipmentFilters.GetFilter(SalesShipmentFilters."Shipment Date") = '') and (SalesShipmentFilters.GetFilter(SalesShipmentFilters."No.") = '') then Error(Text002, SalesShipmentFilters.FieldCaption(SalesShipmentFilters."Shipment Date"), SalesShipmentFilters.FieldCaption(SalesShipmentFilters."No."));
                CurrReport.Break;
            end;
        }
        dataitem("Shipping Agent"; "Shipping Agent")
        {
            DataItemTableView = sorting(Code);

            column(ReportForNavId_1100234000; 1100234000)
            { }
            trigger OnAfterGetRecord()
            begin
                if GuiAllowed then begin
                    Window.Update(1, "Shipping Agent".Code);
                    Window.Update(2, '');
                    Window.Update(3, 0);
                end;
                SalesShipmentHdr.Reset;
                SalesShipmentHdr.SetCurrentkey("Shipment Date", "Shipping Agent Code");
                SalesShipmentHdr.CopyFilters(SalesShipmentFilters);
                SalesShipmentHdr.SetRange("Shipping Agent Code", "Shipping Agent".Code);
                SalesShipmentHdr.SetFilter("Transport Shipment No.", '=%1', '');
                if SalesShipmentHdr.FindSet then begin
                    TransportShipment.Init;
                    TransportShipment."Shipment No." := '';
                    TransportShipment."Shipment Date" := ShipmentDate;
                    TransportShipment."Transport Date" := TransportDate;
                    TransportShipment."Shipping Agent Code" := SalesShipmentHdr."Shipping Agent Code";
                    TransportShipment.Insert(true);
                    TotalPackages := 0;
                    TotalWeight := 0;
                    TotalVolume := 0;
                    repeat
                        if GuiAllowed then begin
                            RecNo := 0;
                            TotalRecNo := SalesShipmentHdr.Count;
                            Window.Update(2, SalesShipmentHdr."No.");
                            Window.Update(3, 0);
                        end;
                        TotalPackages += SalesShipmentHdr."Number of Packages";
                        TotalWeight += SalesShipmentHdr."Total Gross Weight (Actual)";
                        SalesShipmentHdr."Transport Shipment No." := TransportShipment."Shipment No.";
                        SalesShipmentHdr.Modify;
                        if GuiAllowed then begin
                            RecNo := RecNo + 1;
                            Window.Update(3, ROUND(RecNo / TotalRecNo * 10000, 1));
                        end;
                    until SalesShipmentHdr.Next = 0;
                    TransportShipment."Total Packages" := TotalPackages;
                    TransportShipment."Total Weight" := TotalWeight;
                    TransportShipment.Modify;
                    RegCreated += 1;
                end;
            end;

            trigger OnPostDataItem()
            begin
                if GuiAllowed then begin
                    Window.Close();
                    ShowMessage();
                end;
            end;

            trigger OnPreDataItem()
            begin
                "Shipping Agent".SetFilter("Shipping Agent".Code, SalesShipmentFilters.GetFilter("Shipping Agent Code"));
                if GuiAllowed then Window.Open(Text003 + Text004 + Text005);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', comment = 'ESP="Opciones"';

                    field(ShipmentDate; ShipmentDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Shipment Date', comment = 'ESP="Fecha albarán"';
                    }
                    field(TransportDate; TransportDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Transport Date', comment = 'ESP="Fecha transporte"';
                    }
                }
            }
        }
        actions
        {
        }
        trigger OnOpenPage()
        begin
            ShipmentDate := Today;
            TransportDate := Today;
        end;
    }
    labels
    {
    }
    var
        SalesShipmentHdr: Record "Sales Shipment Header";
        TransportShipment: Record "Transport Shipment";
        ShipmentDate: Date;
        TransportDate: Date;
        Text000: label 'Enter the posting date.', comment = 'ESP="Introduzca la fecha de albarán."';
        Text001: label 'Enter the transport date.', comment = 'ESP="Introduzca la fecha de transporte."';
        Text002: label 'Enter a filter for %1 or %2', comment = 'ESP="Especifique un filtro para %1 o para %2"';
        Text003: label 'Ship. Agent     #1###################\', comment = 'ESP="Trasnportista     #1###################\"';
        Text004: label 'Shipment No.        #2###################\', comment = 'ESP="Nº albarán        #2###################\"';
        Text005: label '@3@@@@@@@@@@@@@@@@@@@@@@';
        TotalPackages: Decimal;
        TotalWeight: Decimal;
        TotalVolume: Decimal;
        Window: Dialog;
        TotalRecNo: Integer;
        RecNo: Integer;
        RegCreatedMsg: label 'A transport shipment has been created', comment = 'ESP="Se ha creado un albarán de transporte."';
        RegsCreatedMsg: label '%1 transport shipments has been created.', comment = 'ESP="Se han creado un total de %1 albaranes de transporte."';
        NoRecordsFoundErr: label 'No records were found. No shipments have been created.', comment = 'ESP="No se han encontrado registros. No se ha creado ningún albarán"';
        RegCreated: Integer;

    local procedure CheckReportFilters()
    begin
        if ShipmentDate = 0D then Error(Text000);
        if TransportDate = 0D then Error(Text001);
    end;

    local procedure CreateShipment()
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
    end;

    local procedure ShowMessage()
    begin
        if RegCreated > 0 then begin
            if RegCreated = 1 then
                Message(RegCreatedMsg)
            else
                Message(RegsCreatedMsg, RegCreated);
        end
        else
            Error(NoRecordsFoundErr);
    end;
}
