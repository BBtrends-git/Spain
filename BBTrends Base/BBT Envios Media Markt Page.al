Page 51103 "BBT Envios Media Markt"
{
    // // BBT 14/03/2022. Informe para exportar en CSV los envios a tiendas Media Markt

    PageType = List;
    SourceTable = "Packaging Line";
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Center; Centro)
                {
                    ApplicationArea = Basic;
                    Caption = 'Centro';
                }
                field(Reference; Referencia)
                {
                    ApplicationArea = Basic;
                    Caption = 'Referencia';
                }
                field(Filler; Filler)
                {
                    ApplicationArea = Basic;
                    Caption = 'Filler';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(EAN; EAN)
                {
                    ApplicationArea = Basic;
                    Caption = 'EAN';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Posted Source No."; Rec."Posted Source No.")
                {
                    ApplicationArea = Basic;
                }
                field(SSCC; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'SSCC';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Posted Source Type"; Rec."Posted Source Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Qty. (Base)"; Rec."Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("No Ped SSCC"; Rec."No Ped SSCC")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("No Alb SSCC"; Rec."No Alb SSCC")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Shipment Posting Date"; Rec."Shipment Posting Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Destination Type"; Rec."Destination Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Destination No."; Rec."Destination No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Destination Name"; Rec."Destination Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Whse. Shipment No."; Rec."Whse. Shipment No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Posted Whse. Shipment No."; Rec."Posted Whse. Shipment No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Caja Picking"; Rec."Caja Picking")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Roadmap; Rec.Roadmap)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    { }

    var
        rSalesShipmentHeader: Record "Sales Shipment Header";
        rSalesShipmentLine: Record "Sales Shipment Line";
        rCustomer: Record Customer;
        ClientesMM: Text;
        rGeneralLedgerSetup: Record "General Ledger Setup";
        rPackaging: Record "Packaging";
        ListaAlbaranes: Text;
        FechaIni: Date;
        FechaFin: Date;
        Centro: Text[50];
        Referencia: Text[50];
        Filler: Text[1];
        rItemIdentifier: Record "Item Identifier";
        EAN: Text[20];
        SumUnitsAlbaran: Integer;
        SumUnitsPacking: Integer;
        //InterfaceSGA: Codeunit "Interface SGA";
        cuPackaging: Codeunit "BBT Packaging";

    trigger OnAfterGetRecord()
    begin
        Referencia := '';
        rSalesShipmentHeader.Reset;
        rSalesShipmentHeader.SetRange("No.", Rec."Posted Source No.");
        if rSalesShipmentHeader.FindFirst then
            Referencia := rSalesShipmentHeader."External Document No.";

        Centro := '';
        rCustomer.SetRange("No.", rSalesShipmentHeader."Sell-to Customer No.");
        if rCustomer.FindFirst then
            Centro := rCustomer.Abbreviation;

        EAN := '';
        rItemIdentifier.Reset;
        rItemIdentifier.SetRange("Item No.", Rec."Item No.");
        rItemIdentifier.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
        if rItemIdentifier.FindFirst then
            EAN := rItemIdentifier.Code;
    end;

    trigger OnOpenPage()

    begin
        rCustomer.Reset;
        rCustomer.SetRange("SMG Platform", 'MM');
        if rCustomer.FindSet then begin
            repeat
                rSalesShipmentHeader.Reset;
                rSalesShipmentHeader.Setrange("Sell-to Customer No.", rCustomer."No.");
                rSalesShipmentHeader.Setfilter("Posting Date", '%1..%2', CalcDate('-1M', WORKDATE), WORKDATE);
                if rSalesShipmentHeader.FindSet then
                    repeat
                        clear(SumUnitsAlbaran);
                        clear(SumUnitsPacking);

                        rSalesShipmentLine.Reset;
                        rSalesShipmentLine.setrange("Document No.", rSalesShipmentHeader."No.");
                        rSalesShipmentLine.setrange("Type", rSalesShipmentLine."Type"::item);
                        rSalesShipmentLine.setfilter("No.", '<>%1', '');
                        if rSalesShipmentLine.FindSet then
                            repeat
                                SumUnitsAlbaran := SumUnitsAlbaran + rSalesShipmentLine.Quantity;
                            until rSalesShipmentLine.Next() = 0;

                        rPackaging.Reset;
                        rPackaging.Setrange("Posted Source No.", rSalesShipmentHeader."No.");
                        if rPackaging.FindSet then begin
                            repeat
                                rPackaging.CalcFields(Quantity);
                                SumUnitsPacking := SumUnitsPacking + rPackaging.Quantity;
                            until rPackaging.Next() = 0;
                        end;

                        if SumUnitsAlbaran <> SumUnitsPacking then begin
                            rPackaging.Reset;
                            rPackaging.SetRange("Posted Source No.", rSalesShipmentHeader."No.");
                            if rPackaging.Findset then begin
                                rPackaging.DeleteAll(true);
                                commit;
                            end;

                            //InterfaceSGA.GetPackagingLinesFromSalesShptHeader(rSalesShipmentHeader);
                            cuPackaging.GetPackagingLinesFromSalesShptHeader(rSalesShipmentHeader);
                            Commit;

                        end;

                    until rSalesShipmentHeader.Next() = 0;
            until rCustomer.Next() = 0;
        end;

        Rec.SetFilter(Roadmap, '<>''''');
        Rec.Setfilter("Creation Date", '%1..%2', CalcDate('-2M', WORKDATE), WORKDATE);
        Rec.SetCurrentkey("No.");
        Rec.SetAscending("No.", false);
    end;
}
