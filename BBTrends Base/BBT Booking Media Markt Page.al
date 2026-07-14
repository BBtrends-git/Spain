Page 51100 "BBT Booking Media Markt"
{
    // BBT 18/09/2023. Informe para exportar en CSV los envios a tiendas Media Markt
    // BBT 25/09/2023. Se reestructura la selección del informe para recalcular embalajes erroneos.
    // BBT 07/10/2024. Añadimos un filtro para recuperar directamente una ruta y se añade la funcionalidad 
    //                 para generar los pdfs de los albaranes comprimidos en un .ZIP               

    PageType = Worksheet;
    SourceTable = "Packaging Line";
    UsageCategory = Documents;
    ApplicationArea = all;
    DeleteAllowed = false;
    Permissions = TableData "Sales Shipment Header" = M;

    /**/
    layout
    {
        area(content)
        {
            group(General)
            {
                ShowCaption = false;
                field(RoadMapFilter; RoadMapFilter)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    Caption = 'Roadmap', comment = 'ESP="Ref. Ruta"';
                    ShowMandatory = true;
                    trigger OnValidate()
                    begin
                        if RoadMapFilter <> '' then begin
                            rSSH.DeleteAll();
                            rec.Reset();
                            clear(Rec);
                            rec.SetRange(roadmap, RoadMapFilter);
                            If not rec.FindSet() then begin
                                CurrPage.UPDATE(false);
                                error('No existe la ruta %1', RoadMapFilter)

                            end
                            else begin
                                CurrPage.UPDATE(false);
                                // Buscamos los albaranes del booking
                                rPackaging.Reset;
                                rPackaging.Setrange(Roadmap, RoadMapFilter);
                                if rPackaging.FindSet then
                                    repeat
                                        rSalesShipmentHeader.Reset;
                                        rSalesShipmentHeader.Setrange("No.", rPackaging."Posted Source No.");
                                        if rSalesShipmentHeader.FindFirst() then begin
                                            rSSH.Reset;
                                            rSSH.Setrange("No.", rSalesShipmentHeader."No.");
                                            if not rSSH.FindFirst() then begin
                                                rSSH."No." := rSalesShipmentHeader."No.";
                                                rSSH."Bill-to Customer No." := rSalesShipmentHeader."Bill-to Customer No.";
                                                rSSH.Insert();
                                            end;
                                        end;
                                    until rPackaging.Next() = 0;
                                rSSH.Reset();   //Cuadramos los embalajes
                                if rSSH.FindSet then
                                    repeat
                                        packagingsquare(rSSH."No.");
                                    until rSSH.Next() = 0;
                            end;
                        end;
                    end;
                }
            }
            repeater("Detalle Envios")
            {
                Editable = false;
                field(Center; Centro)
                {
                    ApplicationArea = Basic;
                    Caption = 'Centro';
                    Editable = false;
                }
                field(Reference; Referencia)
                {
                    ApplicationArea = Basic;
                    Caption = 'Referencia';
                    Editable = false;
                }
                field(Filler; Filler)
                {
                    ApplicationArea = Basic;
                    Caption = 'Filler';
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(EAN; EAN)
                {
                    ApplicationArea = Basic;
                    Caption = 'EAN';
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    Editable = false;
                }
                field("Posted Source No."; Rec."Posted Source No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(SSCC; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'SSCC';
                    Editable = false;
                }
                field(Roadmap; Rec.Roadmap)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ruta';
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    Editable = false;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    Editable = false;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    Editable = false;
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    Editable = false;
                }
                field("Posted Source Type"; Rec."Posted Source Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    Editable = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    Editable = false;
                }
                field("Qty. (Base)"; Rec."Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    Editable = false;
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    Editable = false;
                }
                field("No Ped SSCC"; Rec."No Ped SSCC")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    Editable = false;
                }
                field("No Alb SSCC"; Rec."No Alb SSCC")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    Editable = false;
                }
                field("Shipment Posting Date"; Rec."Shipment Posting Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    Editable = false;
                }
                field("Destination Type"; Rec."Destination Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    Editable = false;
                }
                field("Destination No."; Rec."Destination No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    Editable = false;
                }
                field("Destination Name"; Rec."Destination Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    Editable = false;
                }
                field("Whse. Shipment No."; Rec."Whse. Shipment No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    Editable = false;
                }
                field("Posted Whse. Shipment No."; Rec."Posted Whse. Shipment No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    Editable = false;
                }
                field("Caja Picking"; Rec."Caja Picking")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    Editable = false;
                }

            }
        }
    }
    /**/
    actions
    {
        area(Processing)
        {
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = 'Print Sales Shipment', comment = 'ESP="Imprimir Albaranes"';
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                begin
                    if not rSSH.IsEmpty then begin
                        if Confirm('¿ Desea imprimir los albaranes de la ruta %1 ?', false, RoadMapFilter) then begin
                            //dlg.Open('Generando ZIP con los pdfs de los albaranes: ####1####');
                            FileNameZip := '2804585_' + RoadMapFilter + '.zip'; //Numero de proveedor para Media Markt + Numero de Ruta
                            DataCompression.CreateZipArchive();
                            //iCount := 0;
                            //iTotal := rSSH.Count;
                            if rSSH.FindSet then begin
                                repeat

                                    Clear(OutStream);
                                    Clear(InStream);
                                    Clear(TempBlob);

                                    Parameters :=
                                    '<?xml version="1.0" encoding="utf-8"?>' +
                                    '<ReportParameters>' +
                                    '<Options><Field name="NoOfCopies">0</Field></Options>' +
                                    '<DataItems>' +
                                    '<DataItem name="Sales Shipment Header">VERSION(1) SORTING(Field3) WHERE(Field3=1(' +
                                    Format(rSSH."No.") +
                                    '),Field4=1(' +
                                    Format(rSSH."Bill-to Customer No.") +
                                    '))</DataItem>' +
                                    '</DataItems>' +
                                    '</ReportParameters>';

                                    FileNamePdf := '2804585_' + format(rSSH."No.") + '.pdf'; //Numero de proveedor para Media Markt + Numero Albarán
                                    TempBlob.CreateOutStream(OutStream);
                                    Report.SaveAs(50000, Parameters, ReportFormat::Pdf, OutStream);
                                    //FileManagement.BLOBExport(TempBlob, FilenamePdf, true);
                                    TempBlob.CreateInStream(InStream);
                                    DataCompression.AddEntry(InStream, FileNamePdf);

                                //iCount += 1;
                                //if (iCount mod 10) = 0 then
                                //dlg.Update(1, format(iCount) + ' de ' + format(iTotal));

                                until rSSH.Next() = 0;

                                Clear(OutStream);
                                Clear(InStream);
                                Clear(TempBlob);

                                TempBlob.CreateOutStream(OutStream);
                                DataCompression.SaveZipArchive(OutStream);
                                TempBlob.CreateInStream(InStream);
                                DownloadFromStream(InStream, '', '', '', FileNameZip)
                            end;
                        end;
                    end;
                end;
            }
            action(document)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Shipment', comment = 'ESP="Albaran"';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Posted Sales Shipment";
                RunPageLink = "No." = field("Posted Source No.");
                RunPageMode = View;
                trigger OnAction()
                begin
                end;
            }
        }
    }
    /**/
    var
        RoadMapFilter: Code[20];
        rPackaging: Record "Packaging";
        rSalesShipmentHeader: Record "Sales Shipment Header";
        //InterfaceSGA: Codeunit "Interface SGA";
        cuPackaging: Codeunit "BBT Packaging";
        rSSH: Record "Sales Shipment Header" temporary;
        //Detalle Envios
        rCustomer: Record Customer;
        Centro: Text[50];
        Referencia: Text[50];
        Filler: Text[1];
        rItemIdentifier: Record "Item Identifier";
        EAN: Text[20];
        //Pdfs y Zip
        OutStream: OutStream;
        InStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        FileNamePdf: Text;
        Parameters: Text;
        DataCompression: Codeunit "Data Compression";
        FileNameZip: Text;

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
                        rSalesShipmentHeader.CalcFields("Packaging Lines Count");
                        if rSalesShipmentHeader."Packaging Lines Count" = 0 then begin

                            //InterfaceSGA.GetPackagingLinesFromSalesShptHeader(rSalesShipmentHeader);
                            cuPackaging.GetPackagingLinesFromSalesShptHeader(rSalesShipmentHeader);
                            Commit;

                        end;
                    until rSalesShipmentHeader.Next() = 0;
            until rCustomer.Next() = 0;
        end;

        RoadMapFilter := '';
        rCustomer.Reset;
        rItemIdentifier.Reset();
        rec.Reset();
        rec.SetRange("No.", 'Filler');
    end;

    trigger OnClosePage()
    begin
    end;

    trigger OnAfterGetRecord()
    begin
        //Recuperamos datos de las tablas maestras
        Referencia := '';
        rSalesShipmentHeader.Reset;
        rSalesShipmentHeader.SetRange("No.", Rec."Posted Source No.");
        if rSalesShipmentHeader.FindFirst then Referencia := rSalesShipmentHeader."External Document No.";
        Centro := '';
        rCustomer.SetRange("No.", rSalesShipmentHeader."Sell-to Customer No.");
        if rCustomer.FindFirst then Centro := rCustomer.Abbreviation;
        EAN := '';
        rItemIdentifier.Reset;
        rItemIdentifier.SetRange("Item No.", Rec."Item No.");
        rItemIdentifier.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
        if rItemIdentifier.FindFirst then EAN := rItemIdentifier.Code;

    end;

    // Se revisa que cuadren las cantidades de los albaranes con la de los embalajes.
    procedure packagingsquare(SalesShipmentNo: code[20]);
    var
        //cuInterfaceSGA: Codeunit "Interface SGA";
        cuPackaging: Codeunit "BBT Packaging";
        pSalesShipmentHeader: Record "Sales Shipment Header";
        pSalesShipmentLine: Record "Sales Shipment Line";
        pPackaging: Record "Packaging";
        cPackaging: Record "Packaging";
        SumUnitsAlbaran: Integer;
        SumUnitsPacking: Integer;
    begin
        pSalesShipmentHeader.Reset;
        pSalesShipmentHeader.Setrange("No.", SalesShipmentNo);
        if pSalesShipmentHeader.FindFirst() then begin
            clear(SumUnitsAlbaran);
            clear(SumUnitsPacking);

            pSalesShipmentLine.Reset;
            pSalesShipmentLine.setrange("Document No.", pSalesShipmentHeader."No.");
            pSalesShipmentLine.setrange("Type", pSalesShipmentLine."Type"::item);
            pSalesShipmentLine.setfilter("No.", '<>%1', '');
            if pSalesShipmentLine.FindSet then
                repeat
                    SumUnitsAlbaran := SumUnitsAlbaran + pSalesShipmentLine.Quantity;
                until pSalesShipmentLine.Next() = 0;

            pPackaging.Reset;
            pPackaging.Setrange("Posted Source No.", pSalesShipmentHeader."No.");
            if pPackaging.FindSet then begin
                repeat
                    pPackaging.CalcFields(Quantity);
                    SumUnitsPacking := SumUnitsPacking + pPackaging.Quantity;
                until pPackaging.Next() = 0;
            end;

            if SumUnitsAlbaran <> SumUnitsPacking then begin    //Si hay diferencia se vuelven a generar los embalajes 
                cPackaging.Reset;
                cPackaging.SetRange("Posted Source No.", pSalesShipmentHeader."No.");
                if cPackaging.FindSet() then begin
                    cPackaging.DeleteAll(true);
                    commit;
                end;

                //InterfaceSGA.GetPackagingLinesFromSalesShptHeader(rSalesShipmentHeader);
                cuPackaging.GetPackagingLinesFromSalesShptHeader(rSalesShipmentHeader);
                Commit;

            end;
        end;
    end;
}