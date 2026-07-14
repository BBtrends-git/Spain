Table 50009 "Sales Shipment Palet"
{
    fields
    {
        field(1; "Sales Shipment No."; Code[20])
        {
            Caption = 'Sales Shipment No.';
        }
        field(2; "Sales Shipment Line Number"; Integer)
        {
            Caption = 'Sales Shipment Line Number';
        }
        field(3; "Palet No."; Code[20])
        {
            Caption = 'Palet No.';
        }
        field(4; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
            DecimalPlaces = 0 : 6;
            MinValue = 0;

            trigger OnValidate()
            begin
                "PB with Pallet" := "Pallet Weight" + "Gross Weight";
            end;
        }
        field(5; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 0 : 6;
            MinValue = 0;
        }
        field(6; Boxes; Integer)
        {
            Caption = 'Boxes/Units';

            trigger OnValidate()
            begin
                if Boxes <> xRec.Boxes then begin
                    SalesShipLine.Get("Sales Shipment No.", "Sales Shipment Line Number");
                    Item.Get(SalesShipLine."No.");
                    "Gross Weight" := Boxes * Item."Gross Weight";
                    "Net Weight" := Boxes * Item."Net Weight";
                    Volume := Boxes * Item."Unit Volume";
                end;
            end;
        }
        field(7; Volume; Decimal)
        {
            Caption = 'Volume';
        }
        field(8; "No. Series"; Code[20])
        { }
        field(9; "Bulk number"; Integer)
        { }
        field(10; "Pallet Weight"; Decimal)
        {
            Caption = 'Pallet Weight';

            trigger OnValidate()
            begin
                "PB with Pallet" := "Pallet Weight" + "Gross Weight";
            end;
        }
        field(11; "PB with Pallet"; Decimal)
        {
            Caption = 'PB with Pallet';
        }
    }
    keys
    {
        key(Key1; "Sales Shipment No.", "Sales Shipment Line Number", "Palet No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }
    var
        //>> Obsoleto V27
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        //<<
        EmptySerialCode: Code[20];
        SRSPaletsNo: Code[20];

        SalesSetup: Record "Sales & Receivables Setup";
        SalesShipLine: Record "Sales Shipment Line";
        ItemUnitMeasure: Record "Item Unit of Measure";
        Item: Record Item;

    trigger OnInsert()
    begin
        if "Palet No." = '' then begin
            SalesSetup.Get;
            SalesSetup.TestField("Palets Nos.");
            //>> Obsoleto V27
            //NoSeriesMgt.InitSeries(SalesSetup."Palets Nos.", xRec."No. Series", Today, "Palet No.", "No. Series");
            //
            SalesSetup.TestField("Palets Nos.");
            SRSPaletsNo := SalesSetup."Palets Nos.";
            if NoSeries.AreRelated(SalesSetup."Palets Nos.", EmptySerialCode) then
                SRSPaletsNo := EmptySerialCode;
            "Palet No." := NoSeries.GetNextNo(SRSPaletsNo, Today);
            //<<
        end;
        SalesShipLine.Get("Sales Shipment No.", "Sales Shipment Line Number");
        Item.Get(SalesShipLine."No.");
        if ItemUnitMeasure.Get(SalesShipLine."No.", 'PALET') then begin
            "Gross Weight" := ItemUnitMeasure."Gross weight";
            "Net Weight" := ItemUnitMeasure.Weight;
            Boxes := ItemUnitMeasure."Qty. per Unit of Measure";
            Volume := ItemUnitMeasure.Cubage;
        end;
        if ItemUnitMeasure."Qty. per Unit of Measure" = 0 then Boxes := SalesShipLine.Quantity;
        if ItemUnitMeasure."Gross weight" = 0 then "Gross Weight" := Boxes * Item."Gross Weight";
        if ItemUnitMeasure.Weight = 0 then "Net Weight" := Boxes * Item."Net Weight";
        if ItemUnitMeasure.Cubage = 0 then Volume := Boxes * Item."Unit Volume";
    end;



    procedure PesoBruto(_NumAlbaran: Code[20]): Decimal
    begin
        SetRange("Sales Shipment No.", _NumAlbaran);
        CalcSums("Gross Weight");
        exit("Gross Weight");
    end;

    procedure PesoNeto(_NumAlbaran: Code[20]): Decimal
    begin
        SetRange("Sales Shipment No.", _NumAlbaran);
        CalcSums("Net Weight");
        exit("Net Weight");
    end;

    procedure Cajas(_NumAlbaran: Code[20]): Integer
    begin
        SetRange("Sales Shipment No.", _NumAlbaran);
        CalcSums(Boxes);
        exit(Boxes);
    end;

    procedure Palets(_NumAlbaran: Code[20]): Integer
    begin
        SetRange("Sales Shipment No.", _NumAlbaran);
        exit(Count);
    end;

    procedure BulkCount(_NumAlbaran: Code[20]) TotalPalet: Integer
    var
        _i: Integer;
        RecPalet: Record "Sales Shipment Palet";
    begin
        TotalPalet := 0;
        _i := 0;
        RecPalet.Reset;
        RecPalet.SetRange("Sales Shipment No.", _NumAlbaran);
        //if RecPalet.FindSet(true, false) then
        if RecPalet.FindSet() then
            repeat
                TotalPalet += 1;
                _i := _i + 1;
                RecPalet."Bulk number" := _i;
                RecPalet.Modify;
            until RecPalet.Next = 0;
    end;
}
