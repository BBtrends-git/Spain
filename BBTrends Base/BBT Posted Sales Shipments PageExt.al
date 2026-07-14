PageExtension 50000 "BBT Posted Sales Shipments" extends "Posted Sales Shipments"
{
    layout
    {
        addafter("No.")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the sales order that this invoice was posted from.';
            }
        }
        addafter("Package Tracking No.")
        {
            field("Sh. Agent - Status"; Rec."Sh. Agent - Status")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Estado transportista field.';
            }
            field("Warehose Ship No."; Rec."Warehose Ship No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Warehouse Ship No. field.';
            }
            field("Sh. Agent - Tracking Date"; Rec."Sh. Agent - Tracking Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipment Agent Tracking date field.';
            }
        }
        addafter("Package Tracking No.")
        {
            field("Printed Label "; Rec."Printed Label")
            {
                ApplicationArea = Basic;
                visible = true;
            }
        }
        addafter("Sh. Agent - Tracking Date")
        {
            field("Tracking ECI"; Rec."Tracking ECI")
            {
                ApplicationArea = Basic;
                visible = false;
            }
            field("Shipping Via Agent"; Rec."Shipping Via Agent")
            {
                ApplicationArea = Basic;
                visible = true;
                Editable = false;
            }
            field("Shipping Via Reference"; Rec."Shipping Via Reference")
            {
                ApplicationArea = Basic;
                visible = true;
                Editable = false;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action(ImprimirEtiquetas)
            {
                ApplicationArea = Basic;
                Caption = 'Imp. Etiquetas';
                Ellipsis = false;
                Image = CalculateWarehouseAdjustment;
                //Promoted = true;
                //PromotedCategory = Process;
                //PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesShipmentHeader: Record "Sales Shipment Header";
                    //InterfaceSGA: Codeunit "Interface SGA";
                    cuPackaging: Codeunit "BBT Packaging";
                    BBTUtilities: Codeunit "BBT Utilities Codeunit";
                    //ShipmentAgentsMgt: Codeunit "Shipment Agents Mgt.";
                    FileManagement: Codeunit "File Management";
                    LabelName: Text;
                    TempBlob: Codeunit "Temp Blob";
                    IStream: InStream;
                begin
                    CurrPage.SETSELECTIONFILTER(SalesShipmentHeader);
                    SalesShipmentHeader.FINDSET;
                    repeat
                        //SalesShipmentHeader.SetLoadFields("Shipping ECI Label");
                        //SalesShipmentHeader.SetLoadFields("Shipping Agent Label");
                        SalesShipmentHeader.CALCFIELDS("Shipping Agent Int. Type");     //Comprobamos que el tipo de expedición es de SZENDEX
                        IF (SalesShipmentHeader."Shipping Agent Int. Type" = SalesShipmentHeader."Shipping Agent Int. Type"::Szendex) THEN BEGIN

                            SalesShipmentHeader.CALCFIELDS("Packaging Lines Count");
                            if (SalesShipmentHeader."Packaging Lines Count" = 0) then  // Si no hay bultos probamos a recuperarlos.
                                //InterfaceSGA.GetPackagingLinesFromSalesShptHeader(SalesShipmentHeader);
                                cuPackaging.GetPackagingLinesFromSalesShptHeader(SalesShipmentHeader);

                            SalesShipmentHeader.CALCFIELDS("Packaging Lines Count");    // Si ya tenemos bultos informamos la expedición
                            if (SalesShipmentHeader."Packaging Lines Count" <> 0) then begin
                                //>>BBT 20240113
                                //ShipmentAgentsMgt.GrabarExpedicionExpresOS(SalesShipmentHeader, '') // Etiqueta Logistica

                                //>>> BBT 28/01/2025. Cambio en la creación de la etiqueta de SZENDEX
                                SalesShipmentHeader.CALCFIELDS("Shipping Agent Label");
                                if NOT SalesShipmentHeader."Shipping Agent Label".HasValue then
                                    BBTUtilities.GrabarExpedicionExpresOS(SalesShipmentHeader, '', false);

                                SalesShipmentHeader.CALCFIELDS("Shipping Agent Label");
                                IF SalesShipmentHeader."Shipping Agent Label".HasValue then begin
                                    BBTUtilities.ImprimitEtiquetaSZX(SalesShipmentHeader);
                                end else
                                    Error('No se ha podido recuperar la etiqueta del albarán: ' + SalesShipmentHeader."No.");
                                //<<<

                                //<<
                            end else
                                ERROR('No existen líneas de embalajes para el albarán: ' + SalesShipmentHeader."No.");
                        END;

                        //>> Recuperar / Imprimir etiquetas MARKETPLACE - ECI
                        CASE SalesShipmentHeader."Sell-to Customer No." OF
                            'C01917': //ECI
                                BEGIN
                                    SalesShipmentHeader.CALCFIELDS("Shipping ECI Label");
                                    if NOT SalesShipmentHeader."Shipping ECI Label".HASVALUE then
                                        BBTUtilities.ECILabelDownload(SalesShipmentHeader);

                                    SalesShipmentHeader.CALCFIELDS("Shipping ECI Label");
                                    IF SalesShipmentHeader."Shipping ECI Label".HASVALUE then
                                        IF Confirm('¿ Desea imprimir la etiqueta ECI ?', true) then begin
                                            Clear(TempBlob);
                                            SalesShipmentHeader.CALCFIELDS("Shipping ECI Label");
                                            SalesShipmentHeader."Shipping ECI Label".CreateInStream(IStream);
                                            LabelName := 'ECI LABEL-' + rec."No." + '.pdf';
                                            File.DownloadFromStream(IStream, '', '', '', LabelName);
                                        end;
                                END;
                        END;
                        //<<
                        COMMIT;

                    until SalesShipmentHeader.NEXT = 0;
                end;
            }

            action(ImprimirEtiquetaECI)
            {
                ApplicationArea = Basic;
                Caption = 'Imprimir Etiqueta ECI';
                Ellipsis = true;
                Image = CalculateWarehouseAdjustment;
                //Promoted = true;
                //PromotedCategory = Process;
                //PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesShipmentHeader: Record "Sales Shipment Header";
                    BBTUtilities: Codeunit "BBT Utilities Codeunit";
                    LabelName: Text;
                    TempBlob: Codeunit "Temp Blob";
                    IStream: InStream;
                begin
                    CurrPage.SETSELECTIONFILTER(SalesShipmentHeader);
                    SalesShipmentHeader.FINDSET;

                    SalesShipmentHeader.CALCFIELDS("Shipping ECI Label");
                    if NOT SalesShipmentHeader."Shipping ECI Label".HASVALUE then
                        BBTUtilities.ECILabelDownload(SalesShipmentHeader);

                    rec.CALCFIELDS("Shipping ECI Label");
                    IF rec."Shipping ECI Label".HASVALUE THEN BEGIN
                        rec."Shipping ECI Label".CreateInStream(IStream);
                        LabelName := 'ECI LABEL-' + rec."No." + '.pdf';
                        File.DownloadFromStream(IStream, '', '', '', LabelName);
                    END;
                end;
            }
            action(Embalajes)
            {
                ApplicationArea = Basic;
                Caption = 'Embalajes';
                Ellipsis = true;
                Image = CopyItem;

                trigger OnAction()
                begin
                    Rec.OpenPackaging();
                end;
            }
            action(Recuperarembalajes)
            {
                //>> New SGA Extension.
                ObsoleteState = Pending;
                //<<
                ApplicationArea = Basic;
                Caption = 'Recuperar embalajes';
                Ellipsis = true;
                Image = CopyItem;
                Enabled = EnabledSGA;
                Visible = EnabledSGA;

                trigger OnAction()
                var
                    SalesShipmentHeader: Record "Sales Shipment Header";
                    InterfaceSGA: Codeunit "Interface SGA";
                begin
                    CurrPage.SETSELECTIONFILTER(SalesShipmentHeader);
                    SalesShipmentHeader.FINDSET;
                    REPEAT
                        InterfaceSGA.GetPackagingLinesFromSalesShptHeader(SalesShipmentHeader);
                        if InterfaceSGA.GetPackingError() <> '' then
                            Error(InterfaceSGA.GetPackingError())
                        else
                            Commit();
                    UNTIL SalesShipmentHeader.NEXT = 0;
                    Message('Proceso finalizado');
                end;
            }
            action(SGARetrievePackaging)
            {
                ApplicationArea = Basic;
                Caption = 'Retrieve Packaging', Comment = 'ESP="Recuperar Embalajes"';
                Ellipsis = true;
                Image = CopyItem;
                Visible = true;  //SGAEnabled;
                Enabled = true;  //SGAEnabled;

                trigger OnAction()
                var
                    rSalesShipmentHeader: Record "Sales Shipment Header";
                    cuPackaging: Codeunit "BBT Packaging";
                begin
                    CurrPage.SetSelectionFilter(rSalesShipmentHeader);
                    if rSalesShipmentHeader.FindSet() then
                        repeat
                            cuPackaging.GetPackagingLinesFromSalesShptHeader(rSalesShipmentHeader);
                            if cuPackaging.GetPackingError() <> '' then
                                Error(cuPackaging.GetPackingError())
                            else
                                Commit();
                        until rSalesShipmentHeader.Next() = 0;
                end;
            }
        }
        addlast(Promoted)
        {
            actionref(UpdateDocument_Promoted; "Update Document")
            { }
            actionref(ImpEtiquetas_Promoted; "ImprimirEtiquetas")
            { }
            actionref(ImpEtiquetaECI_Promoted; "ImprimirEtiquetaECI")
            { }
            actionref(TrackPackage_Promoted; "&Track Package")
            { }
        }
    }

    var
        rCompanyInformation: Record "Company Information";
        EnabledSGA: Boolean;
        //>> New Extension SGA
        //cuSGAManagement: Codeunit "SGA Management";
        SGAEnabled: Boolean;
    //<<

    trigger OnOpenPage()
    begin
        SGAEnabled := false;
        //SGAEnabled := cuSGAManagement.IsSGAEnabled();

        EnabledSGA := false;
        rCompanyInformation.Reset();
        rCompanyInformation.get();
        if rCompanyInformation.SGA then
            EnabledSGA := true;
    end;

    procedure GetSelected(VAR NewShipmentHdr: Record "Sales Shipment Header")
    var
    begin
        CurrPage.SETSELECTIONFILTER(NewShipmentHdr);
    end;

}
