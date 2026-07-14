query 51412 "API Item Inventory"
{
    Caption = 'API Item Inventory';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apiiteminventory';
    EntitySetName = 'apiiteminventory';

    elements
    {
        dataitem(Item_Ledger_Entry; "Item Ledger Entry")
        {
            column(Location_Code; "Location Code")
            { }
            column(Item_No; "Item No.")
            { }
            column(Sum_Quantity; Quantity)
            {
                ColumnFilter = Sum_Quantity = FILTER(<> 0);
                Method = Sum;
            }
            filter(Posting_Date; "Posting Date")
            { }
        }
    }
    trigger OnBeforeOpen();
    begin
        SETFILTER(Item_No, '<>%1', '');
    end;
}
