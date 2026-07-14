query 51250 "SCM API Inventory"
{
    Caption = 'SCM Inventory';
    //UsageCategory = Lists;
    /**/
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtscm';
    APIVersion = 'v2.0';
    EntityName = 'scminventory';
    EntitySetName = 'scminventories';
    /**/

    elements
    {
        dataitem(Item_Ledger_Entry; "Item Ledger Entry")
        {
            column(Item_No; "Item No.")
            { }
            column(Location_Code; "Location Code")
            { }
            column(Sum_Quantity; "Remaining Quantity")
            {
                ColumnFilter = Sum_Quantity = FILTER(<> 0);
                Method = Sum;
            }
        }
    }

    trigger OnBeforeOpen()
    begin
        //SetFilter(Item_No, '20104799');
    end;
}