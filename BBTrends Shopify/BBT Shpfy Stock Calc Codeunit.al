codeunit 73102 "BBT Shpfy Stock Calculation" implements "Shpfy Stock Calculation"
{
    procedure GetStock(var pItem: Record Item): decimal;
    var
        //rCompanyInfo: Record "Company Information";
        //rShpfyProduct: Record "Shpfy Product";
        rShpfyShop: Record "Shpfy Shop";
        rShpfyVariant: Record "Shpfy Variant";
        rShpfyShopLocation: Record "Shpfy Shop Location";
        AvailableStock: Decimal;
    begin
        //>> BBT 11/07/2025.    Nuevo calculo de la existencia disponible.
        //                      Se resta a la existencia en el almacén las cantidades
        //                      que están ordenadas para enviar.
        //rCompanyInfo.Get();
        //if not rShop.Get(rCompanyInfo."Main Shop") then exit(0);
        //pItem.SetFilter("Location Filter", rShop."Main Location");
        //pItem.Calcfields(Inventory, "Reserved Qty. on Inventory");
        //if pItem."En Liquidación" then exit(pItem.inventory);
        //if (pItem.Inventory - rShop."Stock Mínimo") < 0 then exit(0);
        //exit(pItem.Inventory - rShop."Stock Mínimo");
        Clear(AvailableStock);
        rShpfyVariant.Reset();
        rShpfyVariant.SetRange("Item No.", pItem."No.");
        if rShpfyVariant.FindFirst() then begin
            rShpfyShop.Reset();
            rShpfyShop.SetRange(Code, rShpfyVariant."Shop Code");
            if rShpfyShop.FindFirst() then begin
                rShpfyShopLocation.Reset();
                rShpfyShopLocation.SetRange("Shop Code", rShpfyShop.Code);
                rShpfyShopLocation.SetRange("Is Primary", true);
                rShpfyShopLocation.SetRange(Active, true);
                if rShpfyShopLocation.FindFirst() then begin
                    pItem.SetFilter("Location Filter", rShpfyShopLocation."Location Filter");
                    pItem.CalcFields(Inventory, "Reserved Qty. on Inventory");
                    AvailableStock := pItem.Inventory;                                                              // Inventario en el Almacén
                    AvailableStock -= pItem."Reserved Qty. on Inventory";                                           // Quitamos las reservas
                    AvailableStock -= ShippingQuantity(pItem."No.", rShpfyShopLocation."Default Location Code");    // Quitamos los envios ordenados
                    if not pItem."En Liquidación" then                                                              // Si no está en Liquidación....
                        AvailableStock -= rShpfyShop."Stock Mínimo";                                                // ... Quitamos la cantidad de seguridad 
                end;
            end;
        end;

        if AvailableStock > 0 then
            exit(AvailableStock)
        else
            exit(0);
        //<<
    end;


    local procedure ShippingQuantity(pItemNo: Code[20]; pWarehouse: Code[10]) pQuantity: Decimal;
    var
        rWarehouseShipmentLine: Record "Warehouse Shipment Line";
        cuSGAManagement: Codeunit "SGA Management";
    begin
        pQuantity := 0;
        rWarehouseShipmentLine.Reset();
        rWarehouseShipmentLine.SETRANGE("Item No.", pItemNo);
        rWarehouseShipmentLine.SETRANGE("Location Code", pWarehouse);
        rWarehouseShipmentLine.SETFILTER("Qty. to Ship (Base)", '<>%1', 0);
        if cuSGAManagement.IsSGAEnabled() then
            rWarehouseShipmentLine.SETFILTER("SGA Status", '<>%1', rWarehouseShipmentLine."SGA Status"::" ")
        else
            rWarehouseShipmentLine.SETFILTER("Status SGA", '<>%1', rWarehouseShipmentLine."Status SGA"::" ");
        if rWarehouseShipmentLine.FindSet() then
            repeat
                pQuantity += rWarehouseShipmentLine."Qty. to Ship (Base)";
            until rWarehouseShipmentLine.NEXT = 0;
    end;
}
