codeunit 73100 "BBT Shpfy Management"
{
    trigger OnRun()
    begin
    end;

    procedure ActualizaPedido(ShpyOrderID: BigInteger)
    var
        ShpfyOrderAttributes: Record "Shpfy Order Attribute";
        shpfyOrder: Record "Shpfy Order header";
        customer: Record Customer;
        txtMarketplace: Text[50];
    begin
        // Actualiza el nombre 
        shpfyOrder.Get(ShpyOrderID);
        customer.get(shpfyOrder."Sell-to Customer No.");
        shpfyOrder."Sell-to Customer Name" := customer.Name;
        shpfyOrder.Modify();
        txtMarketplace := '';
        if ShpfyOrderAttributes.Get(ShpyOrderID, 'Marketplace') then begin
            // modifica el pedido
            shpfyOrder.Get(ShpyOrderID);
            shpfyOrder."Channel Name" := ShpfyOrderAttributes."Attribute Value";
            shpfyOrder.Modify;
            txtMarketplace := ShpfyOrderAttributes."Attribute Value";
        end;
        ActualizaPedido(ShpyOrderID, txtMarketplace);
        Commit();
    end;

    procedure ActualizaPedido(ShpyOrderID: BigInteger; Marketplace: Text[50])
    var
        ShpyShop: record "Shpfy Shop";
        ShpyOrder: Record "Shpfy Order header";
        shopCode: code[20];
        ListMarketPlaces: Record "Shpfy Shop";
        encontrado: Boolean;
        customer: Record customer;
    begin
        ShpyOrder.Get(ShpyOrderID);
        shopCode := ShpyOrder."Shop Code";
        if not ShpyShop.Get(shopCode) then exit;
        encontrado := false;
        if Marketplace <> '' then begin
            ListMarketPlaces.Reset();
            ListMarketPlaces.SetRange("Marketplace", true);
            ListMarketPlaces.SetRange("ID Marketplace", Marketplace);
            if ListMarketPlaces.FindSet() then
                repeat
                    ShpyOrder."Sell-to Customer No." := ListMarketPlaces."Default Customer No.";
                    ShpyOrder."Bill-to Customer No." := ListMarketPlaces."Default Customer No.";
                    if not customer.get(ListMarketPlaces."Default Customer No.") then error('No existe el cliente');
                    ShpyOrder."Sell-to Customer Name" := customer.Name;
                    ShpyOrder.Modify();
                    encontrado := true;
                until (ListMarketPlaces.Next() = 0);
            if not encontrado then Error('El marketplace %1 no existe', Marketplace);
        end;
        ControlPrecios(ShpyOrderID);
    end;

    procedure ControlPrecios(ShpyOrderID: BigInteger)
    var
        AuxShpfyShop: Record "Shpfy Shop";
        ShpyShop: Record "Shpfy Shop";
        ShpyOrder: Record "Shpfy Order header";
        PriceChanged: Boolean;
        ShpyOrderLine: Record "Shpfy Order Line";
        SalesPrice: Record "Sales Price";
        custNo: Code[20];
        SalesPriceItemBC: Decimal;
        MaxPrice: Decimal;
        MinPrice: Decimal;
        DifPrice: Decimal;
    begin
        if not ShpyOrder.Get(ShpyOrderId) then exit;
        ShpyShop.Get(ShpyOrder."Shop Code");
        DifPrice := ShpyShop."% Diferencia precio";
        custNo := ShpyOrder."Sell-to Customer No.";

        //>> BBT. 25/03/2026. Precios UFESA-PT vs UFESA - DI4-PT vs DI4
        // No se puede utilizar el cliente del pedido porque la tienda real es la misma.
        // Utilizamos el nuevo campo 'Cliente Validacion Precio'
        AuxShpfyShop.Reset();
        AuxShpfyShop.SetRange("Default Customer No.", ShpyOrder."Sell-to Customer No.");
        AuxShpfyShop.SetFilter("Customer Price Validation", '<>%1', Format(''));
        if AuxShpfyShop.FindFirst() then
            custNo := AuxShpfyShop."Customer Price Validation";
        //<<

        //Control de Precios MARKETPLACE
        PriceChanged := false;
        ShpyOrderLine.Reset;
        ShpyOrderLine.SetRange("Shopify Order Id", ShpyOrderID);
        if ShpyOrderLine.FindSet then
            repeat
                SalesPrice.Reset;
                SalesPrice.SetRange("Item No.", ShpyOrderLine."Item No.");
                SalesPrice.SetRange("Sales Type", SalesPrice."sales type"::Customer);
                SalesPrice.SetRange("Sales Code", CustNo);
                SalesPrice.SetFilter("Starting Date", '<=%1', ShpyOrder."Document Date");
                SalesPrice.SetFilter("Ending Date", '%1|>=%2', 0D, ShpyOrder."Document Date");
                if SalesPrice.FindFirst then
                    SalesPriceItemBC := SalesPrice."Unit Price"
                else begin
                    SalesPrice.Reset;
                    SalesPrice.SetRange("Item No.", ShpyOrderLine."Item No.");
                    SalesPrice.SetRange("Sales Type", SalesPrice."sales type"::"Customer Price Group");
                    SalesPrice.SetRange("Sales Code", ShpyShop."Customer Price Group");
                    SalesPrice.SetFilter("Starting Date", '<=%1', ShpyOrder."Document Date");
                    SalesPrice.SetFilter("Ending Date", '%1|>=%2', 0D, ShpyOrder."Document Date");
                    if SalesPrice.FindFirst then
                        SalesPriceItemBC := SalesPrice."Unit Price"
                    else
                        PriceChanged := true;
                end;
                if not PriceChanged then begin
                    MaxPrice := SalesPriceItemBC * (1 + (DifPrice / 100));
                    MinPrice := SalesPriceItemBC * (1 - (DifPrice / 100));
                    if (ShpyOrderLine."Unit Price" > MaxPrice) or (ShpyOrderLine."Unit Price" < MinPrice) then PriceChanged := true;
                end;
            until (ShpyOrderLine.Next = 0) or (PriceChanged);
        ShpyOrder."Blocked per price" := PriceChanged;
        if not PriceChanged then ShpyOrder.Validado := true;
        if ShpyOrder."Financial Status" <> ShpyOrder."Financial Status"::Paid then ShpyOrder.Validado := false;
        ShpyOrder.Modify();
    end;
    // actualizados para pasar por variable el pedido
    procedure ActualizaPedidoVar(var shpfyOrder: Record "Shpfy Order Header")
    var
        ShpfyOrderAttributes: Record "Shpfy Order Attribute";
        customer: Record Customer;
        txtMarketplace: Text[50];
        rlShpfyShop: Record "Shpfy Shop";
    begin
        customer.get(shpfyOrder."Sell-to Customer No.");
        shpfyOrder."Sell-to Customer Name" := customer.Name;
        //>>BBT 01/07/2025. ERROR Provocado en la V26 de Shopify. 
        //if rlShpfyShop.Get(shpfyOrder."Shop Code") then shpfyOrder.Validate("VAT Included", rlShpfyShop."Prices Including VAT");
        if rlShpfyShop.Get(shpfyOrder."Shop Code") then
            shpfyOrder."VAT Included" := rlShpfyShop."Prices Including VAT";
        //<<
        shpfyOrder.Modify();

        txtMarketplace := '';
        if ShpfyOrderAttributes.Get(shpfyOrder."Shopify Order Id", 'Marketplace') then begin
            // modifica el pedido
            shpfyOrder."Channel Name" := ShpfyOrderAttributes."Attribute Value";
            shpfyOrder.Modify;
            txtMarketplace := ShpfyOrderAttributes."Attribute Value";
        end;
        ActualizaPedidoVar2(shpfyOrder, txtMarketplace);
        Commit();
    end;

    procedure ActualizaPedidoVar2(var ShpyOrder: Record "Shpfy Order header"; Marketplace: Text[50])
    var
        ShpyShop: record "Shpfy Shop";
        shopCode: code[20];
        ListMarketPlaces: Record "Shpfy Shop";
        encontrado: Boolean;
        customer: Record customer;
    begin
        shopCode := ShpyOrder."Shop Code";
        if not ShpyShop.Get(shopCode) then exit;
        encontrado := false;
        if Marketplace <> '' then begin
            ListMarketPlaces.Reset();
            ListMarketPlaces.SetRange("Marketplace", true);
            ListMarketPlaces.SetRange("ID Marketplace", Marketplace);
            if ListMarketPlaces.FindSet() then
                repeat
                    ShpyOrder."Sell-to Customer No." := ListMarketPlaces."Default Customer No.";
                    ShpyOrder."Bill-to Customer No." := ListMarketPlaces."Default Customer No.";
                    if not customer.get(ListMarketPlaces."Default Customer No.") then error('No existe el cliente');
                    ShpyOrder."Sell-to Customer Name" := customer.Name;
                    ShpyOrder.Modify();
                    encontrado := true;
                until (ListMarketPlaces.Next() = 0);
            if not encontrado then Error('El marketplace %1 no existe', Marketplace);
        end;
        ControlPreciosVar(ShpyOrder);
    end;

    procedure ControlPreciosVar(var ShpyOrder: Record "Shpfy Order header")
    var
        AuxShpfyShop: Record "Shpfy Shop";
        ShpyShop: record "Shpfy Shop";
        PriceChanged: Boolean;
        ShpyOrderLine: Record "Shpfy Order Line";
        SalesPrice: Record "Sales Price";
        custNo: Code[20];
        SalesPriceItemBC: Decimal;
        MaxPrice: Decimal;
        MinPrice: Decimal;
        DifPrice: Decimal;
    begin
        ShpyShop.Get(ShpyOrder."Shop Code");
        DifPrice := ShpyShop."% Diferencia precio";
        custNo := ShpyOrder."Sell-to Customer No.";

        //>> BBT. 25/03/2026. Precios UFESA-PT vs UFESA - DI4-PT vs DI4
        // No se puede utilizar el cliente del pedido porque la tienda real es la misma.
        // Utilizamos el nuevo campo 'Cliente Validacion Precio'
        AuxShpfyShop.Reset();
        AuxShpfyShop.SetRange("Default Customer No.", ShpyOrder."Sell-to Customer No.");
        AuxShpfyShop.SetFilter("Customer Price Validation", '<>%1', Format(''));
        if AuxShpfyShop.FindFirst() then
            custNo := AuxShpfyShop."Customer Price Validation";
        //<<

        //Control de Precios MARKETPLACE
        PriceChanged := false;
        ShpyOrderLine.Reset;
        ShpyOrderLine.SetRange("Shopify Order Id", ShpyOrder."Shopify Order Id");
        if ShpyOrderLine.FindSet then
            repeat
                SalesPrice.Reset;
                SalesPrice.SetRange("Item No.", ShpyOrderLine."Item No.");
                SalesPrice.SetRange("Sales Type", SalesPrice."sales type"::Customer);
                SalesPrice.SetRange("Sales Code", CustNo);
                SalesPrice.SetFilter("Starting Date", '<=%1', ShpyOrder."Document Date");
                SalesPrice.SetFilter("Ending Date", '%1|>=%2', 0D, ShpyOrder."Document Date");
                if SalesPrice.FindFirst then
                    SalesPriceItemBC := SalesPrice."Unit Price"
                else begin
                    SalesPrice.Reset;
                    SalesPrice.SetRange("Item No.", ShpyOrderLine."Item No.");
                    SalesPrice.SetRange("Sales Type", SalesPrice."sales type"::"Customer Price Group");
                    SalesPrice.SetRange("Sales Code", ShpyShop."Customer Price Group");
                    SalesPrice.SetFilter("Starting Date", '<=%1', ShpyOrder."Document Date");
                    SalesPrice.SetFilter("Ending Date", '%1|>=%2', 0D, ShpyOrder."Document Date");
                    if SalesPrice.FindFirst then
                        SalesPriceItemBC := SalesPrice."Unit Price"
                    else
                        PriceChanged := true;
                end;
                if not PriceChanged then begin
                    MaxPrice := SalesPriceItemBC * (1 + (DifPrice / 100));
                    MinPrice := SalesPriceItemBC * (1 - (DifPrice / 100));
                    if (ShpyOrderLine."Unit Price" > MaxPrice) or (ShpyOrderLine."Unit Price" < MinPrice) then PriceChanged := true;
                end;
            until (ShpyOrderLine.Next = 0) or (PriceChanged);
        ShpyOrder."Blocked per price" := PriceChanged;
        if not PriceChanged then ShpyOrder.Validado := true;
        if ShpyOrder."Financial Status" <> ShpyOrder."Financial Status"::Paid then ShpyOrder.Validado := false;
        ShpyOrder.Modify();
    end;

    procedure SendWhseShptToBBSGA_SHOPIFY(WhseShptNo: Code[20])
    var
        cuSGAManagement: Codeunit "SGA Management";
        cuSGAInterfaces: Codeunit "SGA Interfaces";
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        WhseShipmentRelease: Codeunit "Whse.-Shipment Release";
        Error01: label 'The shipment is not released', Comment = 'ESP="El envio no esta lanzado"';
        Msg01: Label 'The shipment has already been reported to SGA', Comment = 'ESP="Envio ya informado en SGA"';

        CompanyInformation: record "Company Information";
        Proceso: Codeunit "Interface SGA";
    begin
        if WhseShptNo = '' then exit;
        //>> SGA OBSOLETO
        CompanyInformation.Reset();
        if CompanyInformation.Get() then;
        if (CompanyInformation.SGA) then begin
            if WarehouseShipmentHeader."Status SGA" = WarehouseShipmentHeader."status sga"::" " then begin
                WarehouseShipmentHeader.Reset;
                WarehouseShipmentHeader.Get(WhseShptNo);
                if WarehouseShipmentHeader.Status = WarehouseShipmentHeader.Status::Open then
                    WhseShipmentRelease.Release(WarehouseShipmentHeader);
                if WarehouseShipmentHeader.Status = WarehouseShipmentHeader.Status::Released then begin
                    WarehouseShipmentLine.SetRange("No.", WarehouseShipmentHeader."No.");
                    if WarehouseShipmentLine.FindFirst then begin
                        Proceso.ChequeoStockEnvio(WarehouseShipmentHeader."No.");
                        Clear(Proceso);
                        WarehouseShipmentLine.TestField("Source Type", 37);
                        WarehouseShipmentLine.TestField("Source Subtype", 1);
                        if (WarehouseShipmentLine."Source Type" = 39) AND (WarehouseShipmentLine."Source Subtype" = 5) then
                            Proceso.DevCompraDocEnvio(WarehouseShipmentHeader."No.", FALSE)
                        else if (WarehouseShipmentLine."Source Type" = 37) AND (WarehouseShipmentLine."Source Subtype" = 1) then
                            Proceso.PedVentaDocEnvio(WarehouseShipmentHeader."No.", false);
                        Clear(Proceso);
                    end;
                end
                else
                    Error(Error01);
            end
            else
                Message(Msg01);
        end
        //<<
        //>> NEW SGA EXTENSION
        else begin
            if cuSGAManagement.IsSGAEnabled() then begin
                if WarehouseShipmentHeader."SGA Status" = WarehouseShipmentHeader."SGA Status"::" " then begin
                    WarehouseShipmentHeader.Reset;
                    WarehouseShipmentHeader.Get(WhseShptNo);
                    if WarehouseShipmentHeader.Status = WarehouseShipmentHeader.Status::Open then
                        WhseShipmentRelease.Release(WarehouseShipmentHeader);
                    if WarehouseShipmentHeader.Status = WarehouseShipmentHeader.Status::Released then begin
                        WarehouseShipmentLine.SetRange("No.", WarehouseShipmentHeader."No.");
                        if WarehouseShipmentLine.FindFirst then begin
                            cuSGAManagement.CheckStockShipment(WarehouseShipmentHeader."No.");
                            Clear(cuSGAInterfaces);
                            WarehouseShipmentLine.TestField("Source Type", 37);
                            WarehouseShipmentLine.TestField("Source Subtype", 1);
                            if (WarehouseShipmentLine."Source Type" = 39) AND (WarehouseShipmentLine."Source Subtype" = 5) then
                                cuSGAInterfaces.DevCompraDocEnvio(WarehouseShipmentHeader."No.", FALSE)
                            else if (WarehouseShipmentLine."Source Type" = 37) AND (WarehouseShipmentLine."Source Subtype" = 1) then
                                cuSGAInterfaces.PedVentaDocEnvio(WarehouseShipmentHeader."No.", false);
                            Clear(cuSGAInterfaces);
                        end;
                    end
                    else
                        Error(Error01);
                end
                else
                    Message(Msg01);
            end;
        end;
        //<<
    end;
}
