codeunit 50044 "Item Ledger Entry Events"
{
    [EventSubscriber(ObjectType::Table, database::"Item Ledger Entry", 'OnBeforeVerifyOnInventory', '', false, false)]
    local procedure OnBeforeVerifyOnInventory(ErrorMessageText: Text; var IsHandled: Boolean; var ItemLedgerEntry: Record "Item Ledger Entry")
    var
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        rLot: Record "Lot No. Information";
        Item: Record Item;
        IsNotOnInventoryErr: Label 'You have insufficient quantity of Item %1 on inventory.';
    begin
        IF NOT ItemLedgerEntry.Open THEN EXIT;
        IF ItemLedgerEntry.Quantity >= 0 THEN EXIT;
        CASE ItemLedgerEntry."Entry Type" OF //-RFB-001
                                             //"Entry Type"::Consumption,"Entry Type"::"Assembly Consumption","Entry Type"::Transfer:
                                             //  ERROR(IsNotOnInventoryErr,"Item No.");
            ItemLedgerEntry."Entry Type"::"Assembly Consumption", ItemLedgerEntry."Entry Type"::Transfer:
                ERROR(IsNotOnInventoryErr, ItemLedgerEntry."Item No.");
            //+RFB-001
            ELSE BEGIN
                Item.GET(ItemLedgerEntry."Item No.");
                IF Item.PreventNegativeInventory THEN ERROR(IsNotOnInventoryErr, ItemLedgerEntry."Item No.");
            END;
        END;
    end;
}
