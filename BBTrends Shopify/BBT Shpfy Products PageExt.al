pageextension 73105 "BBT Shpfy Products Ext" extends "Shpfy Products"
{
    actions
    {
        addafter(AddItems)
        {
            group(Tarifas)
            {
                Caption = 'Prices', Comment = 'ESP="BBT Tarifas"';

                action(BBT_Excel)
                {
                    ApplicationArea = All;
                    Caption = 'BBT Import Excel Prices', Comment = 'ESP="BBT Importar precios Excel"';
                    Image = ImportExcel;
                    trigger OnAction()
                    var
                        BBTShopifyPriceSync: Codeunit "BBT Shpfy Price Sync";
                    begin
                        BBTShopifyPriceSync.BBTReadExcelSheet();
                    end;
                }
                action(BBT_SyncPrices_Man)
                {
                    ApplicationArea = All;
                    Caption = 'BBT Manual Sync Shopify Prices', Comment = 'ESP="BBT Sincronizar manualmente precios Shopify"';
                    Image = PriceAdjustment;
                    trigger OnAction()
                    var
                        BBTShopifyPriceSync: Codeunit "BBT Shpfy Price Sync";
                        rlShopifyVariant: Record "Shpfy Variant";
                        rlItem: Record Item;
                        rlShopifyShop: Record "Shpfy Shop";
                        rlShpfyProduct: Record "Shpfy Product";
                        vShop: Text;
                        Text001: Label 'Do you want to update Shopify''s prices?', Comment = 'ESP="¿Desea actualizar los precios de los productos seleccionados en Shopify?"';
                        Text002: Label 'End of Process', Comment = 'ESP="Proceso finalizado."';
                    begin
                        if Confirm(Text001) then begin
                            rlShpfyProduct.Reset();
                            CurrPage.SetSelectionFilter(rlShpfyProduct);
                            rlShpfyProduct.SetRange(Status, rlShpfyProduct.Status::Active);
                            if rlShpfyProduct.FindSet() then begin
                                repeat
                                    rlShpfyProduct.CalcFields("Item No.");
                                    if rlItem.get(rlShpfyProduct."Item No.") then begin
                                        rlShopifyShop.Get(rlShpfyProduct."Shop Code");
                                        rlShopifyVariant.SetRange("Product Id", rlShpfyProduct.Id);
                                        if rlShopifyVariant.FindSet() then
                                            repeat
                                                BBTShopifyPriceSync.UpdShpfyWebPrice(rlShopifyShop, rlShopifyVariant);
                                            until rlShopifyVariant.Next() = 0;
                                    end;
                                until rlShpfyProduct.Next() = 0;
                            end;
                            Message(Text002);
                        end;
                    end;
                }
                action(BBT_SyncPrices_Auto)
                {
                    ApplicationArea = All;
                    Caption = 'BBT Sync Shopify Prices', Comment = 'ESP="BBT Sincronizar precios Shopify"';
                    Image = PriceAdjustment;
                    trigger OnAction()
                    var
                        BBTShopifyPriceSync: Codeunit "BBT Shpfy Price Sync";
                        rlShopifyVariant: Record "Shpfy Variant";
                        rlItem: Record Item;
                        rlShopifyShop: Record "Shpfy Shop";
                        rlShpfyProduct: Record "Shpfy Product";
                        vShop: Text;
                        Text001: Label 'Do you want to update Shopify''s prices?', Comment = 'ESP="¿Desea actualizar los precios de los productos en Shopify?"';
                        Text002: Label 'End of Process', Comment = 'ESP="Proceso finalizado."';
                    begin
                        if Confirm(Text001) then begin
                            rlShpfyProduct.Reset();
                            rlShpfyProduct.SetRange(Status, rlShpfyProduct.Status::Active);
                            if rlShpfyProduct.FindSet() then begin
                                repeat
                                    rlShpfyProduct.CalcFields("Item No.");
                                    if rlItem.get(rlShpfyProduct."Item No.") then begin
                                        rlShopifyShop.Get(rlShpfyProduct."Shop Code");
                                        rlShopifyVariant.SetRange("Product Id", rlShpfyProduct.Id);
                                        if rlShopifyVariant.FindSet() then
                                            repeat
                                                BBTShopifyPriceSync.UpdShpfyWebPrice(rlShopifyShop, rlShopifyVariant);
                                            until rlShopifyVariant.Next() = 0;
                                    end;
                                until rlShpfyProduct.Next() = 0;
                            end;
                            Message(Text002);
                        end;
                    end;
                }
            }
        }
    }
}
