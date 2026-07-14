Page 51104 "BBT Prueba CodeUnit"
{
    // BBT 03/06/2024 Pagina para probar CU
    //Permissions = TableData "Purchase Header" = rimd;
    PageType = List;
    //SourceTable = "Purchase Header";
    SourceTable = "EDI - Document installment";
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                /* Purchase Header
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = Basic;
                }
                field("Buy - from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = Basic;
                }
                */
                /* EDI - Document installment"  */
                field("Document Type"; Rec."Document Type")
                { }
                field("Document No."; Rec."Document No.")
                { }
                field("Line No."; Rec."Line No.")
                { }
                field("Payment time ref. type"; Rec."Payment time ref. type")
                { }
                field("Time relation type"; Rec."Time relation type")
                { }
                field("Period type"; Rec."Period type")
                { }
                field("Period number"; Rec."Period number")
                { }
                field("Due date"; Rec."Due date")
                { }
                field(Amount; Rec.Amount)
                { }
                /**/
            }
        }
        /*        
        area(FactBoxes)
        {
            part(PurchOrderCommentFactBox; "BBT-IT Purch Order Com FactBox")
            {
                ApplicationArea = all;
                SubPageLink = "No." = field("No."), "Document Type" = field("Document Type");
            }
        }
        */
    }
    actions
    {
    }
    var
        rEDIEntry: Record "EDI - EDI Entry";
        rItem: Record "Item";
        rSalesShipment: Record "Sales Shipment Header";
        rSalesHeader: Record "Sales Header";
        rSalesInvoice: Record "Sales Invoice Header";
        rSalesLine: Record "Sales Line";
        rCustomer: Record "Customer";
        rVendor: Record "Vendor";
        rPurchaseHeader: Record "Purchase Header";
        rPurchaseInvoice: Record "Purchase Header";
        UtilitiesCU: Codeunit "BBT Utilities Codeunit";
        //EDIFilesProcesing: Codeunit "BBT-IT EDI Files Procesing";
        //BBTShopfyPriceSync: Codeunit "BBT-IT Shopfy Price Sync";
        TextIni: Text;
        TextFin: Text;
        Char160: Text[1];

    //ShipmentAgentsMgt: Codeunit "Shipment Agents Mgt.";
    //LeerDatosSGA: Codeunit "BBT-IT Leer Datos SGA";
    /*
        trigger OnAfterGetRecord()
        begin

        end;
    */
    trigger OnOpenPage()
    begin
        /* XMLPORT Sales Shipment Header    */
        xmlport.Run(51999, false, true);
        /**/
        /* CHAR(160) 
        Char160[1] := 160;
        rItem.Reset();
        If rItem.Get('71605330') then begin
            TextIni := rItem.Description;
            TextFin := ConvertStr(TextIni, Format(Char160), ' ');
        end;
        Clear(Char160);
        */

        /*
        Rec.CalcFields("Shipment Finished");
        rec.Setrange("Shipping Agent Code", 'SZENDEX');
        rec.SetRange("Shipment Finished", false);
        rec.SetRange("Printed Label", false);
        rec.SetFilter("Posting Date", '>%1', CALCDATE('<-15D>', TODAY));
        */
        //>> Probar la CU de obtención de tracking de SZENDEX
        //UtilitiesCU.ValidarUsuarioBPointSZX(true);
        //ShipmentAgentsMgt.UploadShipmentsToSzendex(rec);
        //UtilitiesCU.ObtenerTrackingSZX;

        //rSalesShipment.Init();
        //rSalesShipment.SetRange("Shipment Date", Today);
        //rSalesShipment.SetFilter("Package Tracking No.", '<>%1', '');
        //rSalesShipment.SetRange("No.", Format('EV2517550'));
        //if rSalesShipment.FindSet() then
        //    repeat
        //        UtilitiesCU.ObtenerExpedicionPorNumero(rSalesShipment, '');
        //    until rSalesShipment.Next = 0;
        /*
        if rSalesShipment.FindFirst() then begin
            rSalesShipment."Printed Label" := true;
            rSalesShipment.Modify()
        end;
        */
        //<<
        /*
        LeerDatosSGA.CreateJobAlbVentaSGA();
        */

        /* Prueba EDI. Pedidos Polonia
        EDIFilesProcesing.GetEDIOrders();
        */

        /* Prueba precios para CU Shopify   
        BBTShopfyPriceSync.Run();
        */

        /* Prueba envio de facturas de venta con delay
        EDIFilesProcesing.UploadInvoices();
        */

        /*Probar la CU de obtención de tracking de SZENDEX sin imprimir etiqueta
        UtilitiesCU.DocumentarExpedicionExpres();
        */

        /* MARCAR los albaranes de Ecommerce con la etiqueta impresa   
        IF Confirm('¿ ETiqueta Impresa ?', true) then begin
            SalesShipmentHeader.SetFilter("Package Tracking No.", '<>%1', '');
            SalesShipmentHeader.SetRange("Printed Label", false);
            SalesShipmentHeader.SetRange("Shipping Agent Code", 'SZENDEX');
            SalesShipmentHeader.SetRange("Location Code", 'MARGA');    //Solo para almacén MARGA
                                                                       //SalesShipmentHeader.SetFilter("Posting Date", '<%1', 20240101D);
            if SalesShipmentHeader.FindSet then
                Repeat
                    SalesShipmentHeader."Printed Label" := true;
                    SalesShipmentHeader.Modify;

                until SalesShipmentHeader.NEXT = 0;

            Commit();
        end;
        */

        /* ELIMINAR los borradores de abonos generados con EDI 
        IF Confirm('¿ Eliminar Abonos EDI ?', true) then begin
            SalesHeader.Setrange("EDI - EDI Order", true);
            SalesHeader.Setrange("Document Type", SalesHeader."Document Type"::"Credit Memo");
            //SalesHeader.SetRange("No.", 'AV2307968');
            //SalesHeader.SetFilter("Posting Date", '<%1', 20240101D);
            if SalesHeader.FindSet then
                Repeat
                    SalesLine.SetRange(SalesLine."Document Type", SalesHeader."Document Type");
                    SalesLine.SetRange("Document No.", SalesHeader."No.");
                    if SalesLine.FindSet then
                        Repeat
                            SalesLine.Delete(true);
                        until SalesLine.NEXT = 0;
                    SalesHeader.Delete(true);
                until SalesHeader.NEXT = 0;

            Commit();
        end;
        */
        /* ACTUALIZAR PROCEDENCIA EDI   ************************
        IF Confirm('¿ Actualizar Procedencia EDI ?', true) then begin
            rEDIEntry.Reset;
            //rEDIEntry.SetFilter("Entry No.", '>%1', 60000);
            if rEDIEntry.FindSet then begin
                repeat
                    if rEDIEntry."Document Nos." = '' then begin
                        rEDIEntry.Validate("Source Type", rEDIEntry."Source Type"::" ");
                        rEDIEntry.Validate("Sourde Id", '');
                        rEDIEntry.Validate("Source Name", '');
                    end
                    else
                        case rEDIEntry."Source Type" of
                            rEDIEntry."Source Type"::Customer:
                                begin
                                    rCustomer.Reset();
                                    if rCustomer.Get(rEDIEntry."Sourde Id") then
                                        rEDIEntry."Source Name" := rCustomer.Name;
                                end;
                            rEDIEntry."Source Type"::Vendor:
                                begin
                                    rVendor.Reset();
                                    if rVendor.Get(rEDIEntry."Sourde Id") then
                                        rEDIEntry."Source Name" := rVendor.Name;
                                end;
                            else begin
                                if rEDIEntry."Document Nos." <> '' then begin
                                    if rEDIEntry."Inbound/Outbound" = rEDIEntry."Inbound/Outbound"::Inbound then // Documentos de Entrada
                                        if CopyStr(rEDIEntry."Document Nos.", 1, 2) = 'FC' then begin  //Proveedor
                                            rPurchaseHeader.Reset;
                                            rPurchaseHeader.SetRange("Document Type", rPurchaseHeader."Document Type"::Invoice);
                                            rPurchaseHeader.SetFilter("No.", rEDIEntry."Document Nos.");
                                            if rPurchaseHeader.FindFirst() then begin
                                                rEDIEntry.Validate("Source Type", rEDIEntry."Source Type"::Vendor);
                                                rEDIEntry.Validate("Sourde Id", rPurchaseHeader."Buy-from Vendor No.");
                                                rEDIEntry.Validate("Source Name", rPurchaseHeader."Buy-from Vendor Name");
                                            end;
                                        end
                                        else begin      //Cliente
                                            rSalesHeader.Reset;
                                            rSalesHeader.SetRange("Document Type", rSalesHeader."Document Type"::Order);
                                            rSalesHeader.SetFilter("No.", rEDIEntry."Document Nos.");
                                            if rSalesHeader.FindFirst() then begin
                                                rEDIEntry.Validate("Source Type", rEDIEntry."Source Type"::Customer);
                                                rEDIEntry.Validate("Sourde Id", rSalesHeader."Sell-to Customer No.");
                                                rEDIEntry.Validate("Source Name", rSalesHeader."Sell-to Customer Name");
                                            end;
                                        end;
                                end
                                else begin
                                    if rEDIEntry."Document type" = rEDIEntry."Document type"::Shipment then begin      // Albarán de venta registrado
                                        rSalesShipment.Reset;
                                        rSalesShipment.SetFilter("No.", rEDIEntry."Document Nos.");
                                        if rSalesShipment.FindFirst() then begin
                                            rEDIEntry.Validate("Source Type", rEDIEntry."Source Type"::Customer);
                                            rEDIEntry.Validate("Sourde Id", rSalesShipment."Sell-to Customer No.");
                                            rEDIEntry.Validate("Source Name", rSalesShipment."Sell-to Customer Name");
                                        end;
                                    end
                                    else begin                                                                          // Factura registrada
                                        rSalesInvoice.Reset;
                                        rSalesInvoice.SetFilter("No.", rEDIEntry."Document Nos.");
                                        if rSalesInvoice.FindFirst() then begin
                                            rEDIEntry.Validate("Source Type", rEDIEntry."Source Type"::Customer);
                                            rEDIEntry.Validate("Sourde Id", rSalesInvoice."Sell-to Customer No.");
                                            rEDIEntry.Validate("Source Name", rSalesInvoice."Sell-to Customer Name");
                                        end;
                                    end;

                                end;
                            end;
                        end;
                    rEDIEntry.Modify();
                    Commit();
                until rEDIEntry.Next = 0;
            end;
        end;
        ****************************/
    end;
}
