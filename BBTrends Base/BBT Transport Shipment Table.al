Table 50003 "Transport Shipment"
{
    Caption = 'Transport Shipment';
    DrillDownPageID = "Transport Shipment List";
    LookupPageID = "Transport Shipment List";
    Permissions = TableData "Sales Shipment Header" = m;

    fields
    {
        field(1; "Shipment No."; Code[20])
        {
            Caption = 'Shipment No.', comment = 'ESP="Núm. albarán"';

            trigger OnValidate()
            begin
                if "Shipment No." <> xRec."Shipment No." then begin
                    SalesSetup.Get;
                    //>> V27
                    //NoSeriesMgt.TestManual(SalesSetup."Transport Shipment Nos.");
                    NoSeries.TestManual(SalesSetup."Transport Shipment Nos.");
                    //<<
                end;
            end;
        }
        field(2; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date', comment = 'ESP="Fecha albarán"';
        }
        field(3; "Transport Date"; Date)
        {
            Caption = 'Transport Date', comment = 'ESP="Fecha transporte"';
        }
        field(4; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code', comment = 'ESP="Cód. Transportista"';
            TableRelation = "Shipping Agent";

            trigger OnValidate()
            begin
                CalcFields("Shipping Agent Name");
            end;
        }
        field(5; "Vehicle Registration No."; Text[30])
        {
            Caption = 'Vehicle Registration No.', comment = 'ESP="Matrícula del vehículo"';
        }
        field(6; "Total Packages"; Decimal)
        {
            Caption = 'Total Packages', comment = 'ESP="Total bultos"';
        }
        field(7; "Total Weight"; Decimal)
        {
            Caption = 'Total Weight', comment = 'ESP="Total peso"';
        }
        field(8; "Shipping Agent Name"; Text[50])
        {
            CalcFormula = lookup("Shipping Agent".Name where(Code = field("Shipping Agent Code")));
            Caption = 'Shipping Agent Name', comment = 'ESP="Nombre transportista"';
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key1; "Shipment No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }

    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesShipmentHdr: Record "Sales Shipment Header";
        //>> Obsoleto V27
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        //<<
        EmptySerialCode: Code[20];
        TSNoSerialCode: Code[20];
        Text000: label 'Untitled', comment = 'ESP="Sin título"';
        Text003: label 'You cannot rename a %1.', comment = 'ESP="No se puede cambiar el nombre a %1."';

    trigger OnDelete()
    begin
        SalesShipmentHdr.Reset;
        SalesShipmentHdr.SetCurrentkey("Transport Shipment No.");
        SalesShipmentHdr.SetRange("Transport Shipment No.", "Shipment No.");
        if SalesShipmentHdr.FindSet then SalesShipmentHdr.ModifyAll("Transport Shipment No.", '');
    end;

    trigger OnInsert()
    begin
        if "Shipment No." = '' then begin
            SalesSetup.Get;
            //>> Obsoleto V27
            //NoSeriesMgt.InitSeries(SalesSetup."Transport Shipment Nos.", SalesSetup."Transport Shipment Nos.", "Shipment Date", "Shipment No.", SalesSetup."Transport Shipment Nos.");
            //
            SalesSetup.TestField("Transport Shipment Nos.");
            TSNoSerialCode := SalesSetup."Transport Shipment Nos.";
            if NoSeries.AreRelated(SalesSetup."Transport Shipment Nos.", EmptySerialCode) then
                TSNoSerialCode := EmptySerialCode;
            "Shipment No." := NoSeries.GetNextNo(TSNoSerialCode, Today);
            //<<        
        end;
    end;

    trigger OnRename()
    begin
        Error(Text003, TableCaption);
    end;


    procedure Caption(): Text[100]
    begin
        if "Shipment No." = '' then exit(Text000);
        CalcFields("Shipping Agent Name");
        exit(StrSubstNo('%1 %2', "Shipment No.", "Shipping Agent Name"));
    end;

    procedure InsertShipments(ShipmentNo: Code[20])
    var
        InsertShipmentPage: Page "Posted Sales Shipments";
    begin
        FilterGroup(2);
        SalesShipmentHdr.SetFilter("Transport Shipment No.", '=%1', '');
        FilterGroup(0);
        Clear(InsertShipmentPage);
        InsertShipmentPage.SetTableview(SalesShipmentHdr);
        InsertShipmentPage.LookupMode(true);
        if InsertShipmentPage.RunModal <> Action::LookupOK then exit;
        InsertShipmentPage.getSelected(SalesShipmentHdr);
        if not SalesShipmentHdr.IsEmpty then begin
            SalesShipmentHdr.ModifyAll("Transport Shipment No.", ShipmentNo);
            UpdateTransportShipment(ShipmentNo);
        end;
    end;

    procedure RemoveSelectedShipments(var SalesShipmentHdr: Record "Sales Shipment Header"; ShipmentNo: Code[20])
    begin
        SalesShipmentHdr.ModifyAll("Transport Shipment No.", '');
        UpdateTransportShipment(ShipmentNo);
    end;

    local procedure UpdateTransportShipment(ShipmentNo: Code[20])
    var
        TransportShipment: Record "Transport Shipment";
        TotalPackages: Decimal;
        TotalWeight: Decimal;
    begin
        if ShipmentNo <> '' then begin
            SalesShipmentHdr.Reset;
            SalesShipmentHdr.SetCurrentkey("Transport Shipment No.");
            SalesShipmentHdr.SetRange("Transport Shipment No.", ShipmentNo);
            if SalesShipmentHdr.FindSet then
                repeat
                    TotalPackages += SalesShipmentHdr."Number of Packages";
                    TotalWeight += SalesShipmentHdr."Total Gross Weight (Actual)";
                until SalesShipmentHdr.Next = 0;
            if TransportShipment.Get(ShipmentNo) then begin
                TransportShipment."Total Packages" := TotalPackages;
                TransportShipment."Total Weight" := TotalWeight;
                TransportShipment.Modify;
            end;
        end;
    end;
}
