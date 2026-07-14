codeunit 73101 "BBT Shpfy Events"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Shpfy Order Events", 'OnAfterImportShopifyOrderHeader', '', true, true)]
    local procedure OnAfterImportShopifyOrderHeader(var ShopifyOrderHeader: Record "Shpfy Order Header")
    var
        //01
        rlShpfyShop: Record "Shpfy Shop";
        rlShpfyOrderHeader: Record "Shpfy Order Header";
        //02
        rMarketplaceShop: Record "Shpfy Shop";
        rShopifyOrderAttributes: Record "Shpfy Order Attribute";
        ChannelValue: text;
        ChannelSKU: text;
        //03 
        rShpfyTag: Record "Shpfy Tag";
    begin
        //01>> Asegurar que los pedidos llevan IVA incluido (si la tienda lo tiene configurado)
        if rlShpfyShop.Get(ShopifyOrderHeader."Shop Code") then
            if rlShpfyOrderHeader.Get(ShopifyOrderHeader."Shopify Order Id") then begin
                //>>BBT 01/07/2025. ERROR Provocado en la V26 de Shopify.
                //rlShpfyOrderHeader.Validate("VAT Included", rlShpfyShop."Prices Including VAT"); 
                rlShpfyOrderHeader."VAT Included" := rlShpfyShop."Prices Including VAT";
                //<<
                rlShpfyOrderHeader.Modify();
            end;
        //<<01

        ///02>> BBT 18/02/2025. Marketplace TikTok. El MKTPlace llega por el atributo Channel no por el Marketplace
        //                      Marketplace TikTok / SKU TikTok  -- Shopify Attribue = Channel valor 'TikTok'
        Clear(ChannelValue);
        Clear(ChannelSKU);
        if rShopifyOrderAttributes.Get(ShopifyOrderHeader."Shopify Order Id", 'Channel') then
            ChannelValue := rShopifyOrderAttributes."Attribute Value";

        if ChannelValue <> '' then begin
            rMarketplaceShop.Reset();
            rMarketplaceShop.SetRange("Marketplace", true);
            rMarketplaceShop.SetRange("ID Marketplace", ChannelValue);
            if not rMarketplaceShop.FindFirst then
                Error('No existe el marketplace: %1', ChannelValue)
            else begin
                // Comprobar que es el Channel TikTok - Hay que pasar los datos a las variables de Marketplace
                if ChannelValue <> 'TikTok' then Error('Channel %1 no homologado como TikTok', ChannelValue);

                // Marketplace SKU = TikTok Shop order number
                if rShopifyOrderAttributes.Get(ShopifyOrderHeader."Shopify Order Id", 'TikTok Shop order number') then begin
                    ChannelSKU := rShopifyOrderAttributes."Attribute Value";

                    if not rShopifyOrderAttributes.Get(ShopifyOrderHeader."Shopify Order Id", 'Marketplace SKU') then begin
                        rShopifyOrderAttributes.Reset();
                        rShopifyOrderAttributes."Order Id" := ShopifyOrderHeader."Shopify Order Id";
                        rShopifyOrderAttributes."Key" := 'Marketplace SKU';
                        rShopifyOrderAttributes."Attribute Value" := ChannelSku;
                        rShopifyOrderAttributes.Insert();
                    end
                    else begin
                        rShopifyOrderAttributes."Attribute Value" := ChannelSku;
                        rShopifyOrderAttributes.Modify();
                    end;
                end;

                // Marketplace = Channel
                if rShopifyOrderAttributes.Get(ShopifyOrderHeader."Shopify Order Id", 'Channel') then begin
                    ChannelValue := rShopifyOrderAttributes."Attribute Value";

                    if not rShopifyOrderAttributes.Get(ShopifyOrderHeader."Shopify Order Id", 'Marketplace') then begin
                        rShopifyOrderAttributes.Reset();
                        rShopifyOrderAttributes."Order Id" := ShopifyOrderHeader."Shopify Order Id";
                        rShopifyOrderAttributes."Key" := 'Marketplace';
                        rShopifyOrderAttributes."Attribute Value" := ChannelValue;
                        rShopifyOrderAttributes.Insert();
                    end
                    else begin
                        rShopifyOrderAttributes."Attribute Value" := ChannelValue;
                        rShopifyOrderAttributes.Modify();
                    end;
                end;
            end;
        end;
        //<<02

        //03>>
        //>> BBT 01/10/2025. Nueva tienda Di4-PT. Usando la misma URL que la ES
        //                   Se trata como si fuera un Marketplace. Viene marcado con una etiqueta desde la web Shopify
        rShpfyTag.Reset();
        rShopifyOrderAttributes.Reset();
        rShpfyTag.SetRange("Parent Table No.", 30118);
        rShpfyTag.SetRange("Parent Id", ShopifyOrderHeader."Shopify Order Id");
        rShpfyTag.SetFilter(Tag, '=%1', 'di4-pt');
        // Marketplace = Tag (di4-pt)
        if rShpfyTag.FindFirst() then begin
            if not rShopifyOrderAttributes.Get(ShopifyOrderHeader."Shopify Order Id", 'Marketplace') then begin
                rShopifyOrderAttributes.Init();
                rShopifyOrderAttributes."Order Id" := ShopifyOrderHeader."Shopify Order Id";
                rShopifyOrderAttributes."Key" := 'Marketplace';
                rShopifyOrderAttributes."Attribute Value" := rShpfyTag.Tag;
                rShopifyOrderAttributes.Insert();
            end
            else begin
                rShopifyOrderAttributes."Attribute Value" := rShpfyTag.Tag;
                rShopifyOrderAttributes.Modify();
            end;
        end;
        //<<
        //>> BBT 19/01/2026. Nueva tienda Ufesa-PT. Usando la misma URL que la ES
        //                   Se trata como si fuera un Marketplace. Viene marcado con una etiqueta desde la web Shopify
        rShpfyTag.Reset();
        rShopifyOrderAttributes.Reset();
        rShpfyTag.SetRange("Parent Table No.", 30118);
        rShpfyTag.SetRange("Parent Id", ShopifyOrderHeader."Shopify Order Id");
        rShpfyTag.SetFilter(Tag, '=%1', 'ufesa-pt');
        // Marketplace = Tag (ufesa-pt)
        if rShpfyTag.FindFirst() then begin
            if not rShopifyOrderAttributes.Get(ShopifyOrderHeader."Shopify Order Id", 'Marketplace') then begin
                rShopifyOrderAttributes.Init();
                rShopifyOrderAttributes."Order Id" := ShopifyOrderHeader."Shopify Order Id";
                rShopifyOrderAttributes."Key" := 'Marketplace';
                rShopifyOrderAttributes."Attribute Value" := rShpfyTag.Tag;
                rShopifyOrderAttributes.Insert();
            end
            else begin
                rShopifyOrderAttributes."Attribute Value" := rShpfyTag.Tag;
                rShopifyOrderAttributes.Modify();
            end;
        end;
        //<<
        //>> BBT 21/05/2026. Nueva tienda ECI Portugal. Usando la misma URL que la ES
        //                   Se trata como si fuera un Marketplace. Viene marcado con una etiqueta desde la web Shopify
        rShpfyTag.Reset();
        rShopifyOrderAttributes.Reset();
        rShpfyTag.SetRange("Parent Table No.", 30118);
        rShpfyTag.SetRange("Parent Id", ShopifyOrderHeader."Shopify Order Id");
        rShpfyTag.SetFilter(Tag, '=%1', 'eci_pt');
        // Marketplace = Tag (eci_pt)
        if rShpfyTag.FindFirst() then begin
            if not rShopifyOrderAttributes.Get(ShopifyOrderHeader."Shopify Order Id", 'Marketplace') then begin
                rShopifyOrderAttributes.Init();
                rShopifyOrderAttributes."Order Id" := ShopifyOrderHeader."Shopify Order Id";
                rShopifyOrderAttributes."Key" := 'Marketplace';
                rShopifyOrderAttributes."Attribute Value" := rShpfyTag.Tag;
                rShopifyOrderAttributes.Insert();
            end
            else begin
                rShopifyOrderAttributes."Attribute Value" := rShpfyTag.Tag;
                rShopifyOrderAttributes.Modify();
            end;
        end;
        //<<
        //>> BBT 25/05/2026. Nueva tienda ECI Portugal. Usando la misma URL que la ES
        //                   Se trata como si fuera un Marketplace. Viene marcado con una etiqueta desde la web Shopify
        rShpfyTag.Reset();
        rShopifyOrderAttributes.Reset();
        rShpfyTag.SetRange("Parent Table No.", 30118);
        rShpfyTag.SetRange("Parent Id", ShopifyOrderHeader."Shopify Order Id");
        rShpfyTag.SetFilter(Tag, '=%1', 'eci_di4_pt');
        // Marketplace = Tag (eci_pt)
        if rShpfyTag.FindFirst() then begin
            if not rShopifyOrderAttributes.Get(ShopifyOrderHeader."Shopify Order Id", 'Marketplace') then begin
                rShopifyOrderAttributes.Init();
                rShopifyOrderAttributes."Order Id" := ShopifyOrderHeader."Shopify Order Id";
                rShopifyOrderAttributes."Key" := 'Marketplace';
                rShopifyOrderAttributes."Attribute Value" := rShpfyTag.Tag;
                rShopifyOrderAttributes.Insert();
            end
            else begin
                rShopifyOrderAttributes."Attribute Value" := rShpfyTag.Tag;
                rShopifyOrderAttributes.Modify();
            end;
        end;
        //<<
        //<<03

        //04>>
        //>> BBT 01/07/2026. Nueva tienda PCCOMPONENTES-PT. Usando la misma URL que la ES
        //                   Se trata como si fuera un Marketplace. Viene marcado con una etiqueta desde la web Shopify
        rShpfyTag.Reset();
        rShopifyOrderAttributes.Reset();
        rShpfyTag.SetRange("Parent Table No.", 30118);
        rShpfyTag.SetRange("Parent Id", ShopifyOrderHeader."Shopify Order Id");
        rShpfyTag.SetFilter(Tag, '=%1', 'pcomponentes_pt');
        // Marketplace = Tag (pcomponentes_pt)
        if rShpfyTag.FindFirst() then begin
            if not rShopifyOrderAttributes.Get(ShopifyOrderHeader."Shopify Order Id", 'Marketplace') then begin
                rShopifyOrderAttributes.Init();
                rShopifyOrderAttributes."Order Id" := ShopifyOrderHeader."Shopify Order Id";
                rShopifyOrderAttributes."Key" := 'Marketplace';
                rShopifyOrderAttributes."Attribute Value" := rShpfyTag.Tag;
                rShopifyOrderAttributes.Insert();
            end
            else begin
                rShopifyOrderAttributes."Attribute Value" := rShpfyTag.Tag;
                rShopifyOrderAttributes.Modify();
            end;
        end;
        //<<
        //>> BBT 01/07/2026. Nueva tienda PCCOMPONENTES-FR. Usando la misma URL que la ES
        //                   Se trata como si fuera un Marketplace. Viene marcado con una etiqueta desde la web Shopify
        rShpfyTag.Reset();
        rShopifyOrderAttributes.Reset();
        rShpfyTag.SetRange("Parent Table No.", 30118);
        rShpfyTag.SetRange("Parent Id", ShopifyOrderHeader."Shopify Order Id");
        rShpfyTag.SetFilter(Tag, '=%1', 'pcomponentes_fr');
        // Marketplace = Tag (pcomponentes_fr)
        if rShpfyTag.FindFirst() then begin
            if not rShopifyOrderAttributes.Get(ShopifyOrderHeader."Shopify Order Id", 'Marketplace') then begin
                rShopifyOrderAttributes.Init();
                rShopifyOrderAttributes."Order Id" := ShopifyOrderHeader."Shopify Order Id";
                rShopifyOrderAttributes."Key" := 'Marketplace';
                rShopifyOrderAttributes."Attribute Value" := rShpfyTag.Tag;
                rShopifyOrderAttributes.Insert();
            end
            else begin
                rShopifyOrderAttributes."Attribute Value" := rShpfyTag.Tag;
                rShopifyOrderAttributes.Modify();
            end;
        end;
        //<<
        //04<<

    end;
    //>> Validación de los precios del pedido
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Shpfy Order Events", 'OnBeforeProcessSalesDocument', '', true, true)]
    local procedure OnBeforeProcessSalesDocument(var ShopifyOrderHeader: Record "Shpfy Order Header")
    var
        cuShopifyMgt: Codeunit "BBT Shpfy Management";
        rShpfyDocLinkToDoc: Record "Shpfy Doc. Link To Doc.";
    begin
        // Comprobamos que no exista ya un pedido de ventas creado
        rShpfyDocLinkToDoc.Reset();
        rShpfyDocLinkToDoc.SetRange("Shopify Document Type", rShpfyDocLinkToDoc."Shopify Document Type"::"Shopify Shop Order");
        rShpfyDocLinkToDoc.SetRange("Shopify Document Id", ShopifyOrderHeader."Shopify Order Id");
        if rShpfyDocLinkToDoc.FindFirst() then
            Error('Pedido vinculado al %1', rShpfyDocLinkToDoc."Document Type");

        // Si el pedido no está cerrado, comprobamos los precios y rellenamos los valores necesarios
        if not ShopifyOrderHeader.Closed then begin
            cuShopifyMgt.ActualizaPedidoVar(ShopifyOrderHeader);
            if ShopifyOrderHeader.Validado = false then Error('El pedido no está validado');
        end;
    end;
    //<<
    //>> Cambios diversos en la información del pedido
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Shpfy Order Events", 'OnAfterCreateSalesHeader', '', true, true)]
    local procedure OnAfterCreateSalesHeader(OrderHeader: Record "Shpfy Order Header"; var SalesHeader: Record "Sales Header")
    var
        ShpfyOrderAttributes: Record "Shpfy Order Attribute";
    begin
        //SalesHeader."External Document No." := StrSubstNo('SHOPIFY %1', OrderHeader."Shopify Order No.");
        // 20240122 Solicitado por Joan
        SalesHeader."External Document No." := StrSubstNo('%1', OrderHeader."Shopify Order No.");
        SalesHeader."Pedido Web/MarketPlace" := true;
        // obtiene el número de pedido del marketplace
        if ShpfyOrderAttributes.Get(OrderHeader."Shopify Order Id", 'Marketplace SKU') then begin
            // modifica el pedido
            SalesHeader."External Document No." := StrSubstNo('%1', ShpfyOrderAttributes."Attribute Value");
        end;
        // pais
        if SalesHeader."Ship-to Country/Region Code" = 'ES' then SalesHeader.Validate("Ship-to Post Code");
        if SalesHeader."Bill-to Country/Region Code" = 'ES' then SalesHeader.Validate("Bill-to Post Code");
        if SalesHeader."Sell-to Country/Region Code" = 'ES' then SalesHeader.Validate("Sell-to Post Code");
        SalesHeader."Ship-to Address" := CopyStr(SalesHeader."Ship-to Address", 1, 50);
        SalesHeader."Ship-to Address 2" := CopyStr(SalesHeader."Ship-to Address 2", 1, 50);
        // Solicitado por Joan 29/11/2023
        SalesHeader."Bill-to Address" := CopyStr(SalesHeader."Bill-to Address", 1, 50);
        SalesHeader."Bill-to Address 2" := CopyStr(SalesHeader."Bill-to Address 2", 1, 50);
        SalesHeader."Sell-to Address" := CopyStr(SalesHeader."Sell-to Address", 1, 50);
        SalesHeader."Sell-to Address 2" := CopyStr(SalesHeader."Sell-to Address 2", 1, 50);
        if strlen(SalesHeader."Sell-to Phone No.") > 15 then begin
            SalesHeader."Sell-to Phone No." := DelChr(SalesHeader."Sell-to Phone No.", '=');
            SalesHeader."Sell-to Phone No." := CopyStr(SalesHeader."Sell-to Phone No.", 1, 15);
        end;
        // En los pedidos del corte inglés, el campo "ship-to name" se rellena con __ __
        // hay que poner EL CORTE INGLÉS
        // 1.0.0.26
        if (SalesHeader."Sell-to Customer No." = 'C01917') and (strlen(SalesHeader."Ship-to Name") < 8) then SalesHeader."Ship-to Name" := 'EL CORTE INGLÉS';
        // 120324 1.0.0.27 El email se recorta a 50 caracteres
        if (SalesHeader."Sell-to Customer No." = 'C01917') and (StrLen(SalesHeader."Sell-to E-Mail") = 50) then SalesHeader."Sell-to E-Mail" := StrSubstNo('%1-elcorteingles@lengow.com', SalesHeader."External Document No.");
        if OrderHeader."VAT Included" then SalesHeader.Validate("Prices Including VAT", OrderHeader."VAT Included");
        SalesHeader.Modify();
    end;
    //<<

    //>> Aplicación del vale de descuento
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Shpfy Order Events", OnAfterCreateItemSalesLine, '', true, true)]
    //ShopifyOrderHeader: Record "Shpfy Order Header"; ShopifyOrderLine: Record "Shpfy Order Line"; SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var Handled: Boolean
    local procedure OnAfterCreateItemSalesLine(ShopifyOrderHeader: Record "Shpfy Order Header"; ShopifyOrderLine: Record "Shpfy Order Line"; SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    var
        //>> BBT. SMG Extension.
        //cuSMGManagement: Codeunit "SMG Management";
        //SMGEnable: Boolean;
        //<<
        percDto: Decimal;
    begin
        if ShopifyOrderLine."Discount Amount" = 0 then exit;
        percDto := ((ShopifyOrderLine."Discount Amount" / ShopifyOrderLine.quantity) / ShopifyOrderLine."Unit Price") * 100;
        //>> BBT. SMG Extension.
        //if not cuSMGManagement.IsMarginEnabled() then begin
        //    SalesLine.Validate("Discount 2 %", percDto);
        //    salesLine.validate("Line Discount Amount", salesline."Discounts Total Amount");
        //end
        //else begin
        SalesLine.Validate("SMG Discount 2 %", percDto);
        salesLine.validate("Line Discount Amount", salesline."SMG Discounts Total Amount");
        //end;
        //<<
        SalesLine.Modify(true);
    end;
    //<<
    //>> Se ejecuta después de haber generado el documento.
    //  Crea el DEA y lo envia al SGA
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Shpfy Order Events", 'OnAfterProcessSalesDocument', '', true, true)]
    local procedure OnAfterProcessSalesDocument(var SalesHeader: Record "Sales Header"; OrderHeader: Record "Shpfy Order Header")
    var
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        cuShopifyManagement: Codeunit "BBT Shpfy Management";
    begin
        ReleaseSalesDocument.PerformManualRelease(SalesHeader); // Lanzar pedido
        GetSourceDocOutbound.CreateFromSalesOrder(SalesHeader); // Crear env. almacén
        WarehouseShipmentHeader.GET(GetWhseShptNoFromSalesOrder(SalesHeader));
        cuShopifyManagement.SendWhseShptToBBSGA_SHOPIFY(WarehouseShipmentHeader."No."); // Enviar a SGA
    end;

    local procedure GetWhseShptNoFromSalesOrder(SalesHeader: Record "Sales Header"): Code[20]
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
    begin
        WarehouseShipmentLine.Reset;
        WarehouseShipmentLine.SetRange("Source No.", SalesHeader."No.");
        if WarehouseShipmentLine.FindLast then;
        exit(WarehouseShipmentLine."No.");
    end;
    //<<

    //>> Actualiza el campo No. Pedido Venta despues de borrar el PV
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterDeleteEvent', '', true, false)]
    local procedure OnDeleteSalesHeader(var Rec: Record "Sales Header")
    var
        rShpfyOrderHeader: Record "Shpfy Order Header";
    begin
        if Rec.IsTemporary() then
            exit;

        if (Rec."Document Type" = Rec."Document Type"::Order) then begin
            rShpfyOrderHeader.Reset();
            rShpfyOrderHeader.SetRange("Shopify Order Id", rec."Shpfy Order Id");
            rShpfyOrderHeader.SetRange("Shopify Order No.", rec."Shpfy Order No.");
            if rShpfyOrderHeader.FindFirst() then
                if rShpfyOrderHeader."Sales Order No." = Rec."No." then begin
                    clear(rShpfyOrderHeader."Sales Order No.");
                    rShpfyOrderHeader.Modify();
                end;
        end;
    end;
    //<<
}
