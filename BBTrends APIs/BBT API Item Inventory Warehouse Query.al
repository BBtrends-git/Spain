query 51413 "API Item Inventory Warehouse"
{
    Caption = 'API Item Inventory Warehouse';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apiiteminventorywarehouse';
    EntitySetName = 'apiiteminventorywarehouses';

    elements
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            column(Location; "Location Code")
            { }
            column(ItemNo; "Item No.")
            { }
            column(SumQuantity; "Remaining Quantity")
            {
                ColumnFilter = SumQuantity = FILTER(<> 0);
                Method = Sum;
            }
        }
    }

    trigger OnBeforeOpen();
    begin
        SetFilter(ItemNo, '%1..%2', '10000000', '89999999');
    end;
}