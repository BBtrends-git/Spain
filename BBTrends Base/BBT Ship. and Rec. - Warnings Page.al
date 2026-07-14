page 50104 "BBT Ship. and Rec. - Warnings"
{
    ApplicationArea = All;
    Caption = 'Shipping and Reciving Warnings';
    PageType = CardPart;
    RefreshOnActivate = true;
    ShowFilter = false;

    layout
    {
        area(content)
        {
            cuegroup(UnderStockWarning)
            {
                caption = 'Under stock Warning', comment = 'ESP="Aviso bajo stock"';

                field(ItemsUnderStock; ItemsUnderStock)
                {
                    Caption = 'Items with low stock', Comment = 'ESP="Productos con bajo stock"';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    var
                        ItemList: Page "Item List";
                        Item: Record Item;
                    begin
                        Clear(ItemList);
                        ItemList.GetItemsFromTemporary(TempItem);
                        ItemList.RunModal();
                    end;
                }
            }
        }
    }
    var
        ItemsUnderStock: Integer;
        TempItem: Record Item temporary;

    trigger OnAfterGetCurrRecord()
    begin
        ItemsUnderStock := getItemsUnderStock(TempItem);
    end;

    procedure getItemsUnderStock(var rItemsUnderStock: Record Item temporary) dItemsUnderStock: Decimal
    var
        Item: Record Item;
        AvailableStock: Decimal;
    begin
        Clear(dItemsUnderStock);
        rItemsUnderStock.ClearMarks();
        Item.Reset();
        if Item.FindFirst() then begin
            repeat
                Item.CalcFields(Inventory, "Qty. on Purch. Order", "Qty. on Sales Order");
                AvailableStock := Item.Inventory + Item."Qty. on Purch. Order" - Item."Qty. on Sales Order" - Item."Safety Stock Quantity";
                if AvailableStock <= 0 then begin
                    rItemsUnderStock.Reset();
                    if not rItemsUnderStock.FindFirst() then begin
                        rItemsUnderStock.Init();
                        rItemsUnderStock.TransferFields(Item, true);
                        rItemsUnderStock.Insert(false);
                        dItemsUnderStock += 1;
                    end;
                end;
            until Item.Next() = 0;
        end;
    end;
}
