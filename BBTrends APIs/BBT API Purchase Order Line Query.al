query 51417 "API Purchase Order Line"
{
    Caption = 'API Purchase Order Line';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apipurchaseorderline';
    EntitySetName = 'apipurchaseorderlines';

    elements
    {
        dataitem(Purchase_Line; "Purchase Line")
        {
            column(Document_Type; "Document Type")
            { }
            column(Document_No; "Document No.")
            { }
            column(Buy_from_Vendor_No; "Buy-from Vendor No.")
            { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name")
            { }
            column(Type; "Type")
            { }
            column(No_; "No.")
            { }
            column(Description; "Description")
            { }
            column(Item_Category_Code; "Item Category Code")
            { }
            column(Location_Code; "Location Code")
            { }
            column(Quantity; "Quantity")
            { }
            column(Outstanding_Quantity; "Outstanding Quantity")
            { }
            column(Unit_of_Measure_Code; "Unit of Measure Code")
            { }
            column(Unit_Cost__LCY_; "Unit Cost (LCY)")
            { }
            column(Direct_Unit_Cost; "Direct Unit Cost")
            { }
            column(Currency_Code; "Currency Code")
            { }
            column(Amount; "Amount")
            { }
            column(Expected_Receipt_Date; "Expected Receipt Date")
            { }
        }
    }
    trigger OnBeforeOpen();
    begin
        SetFilter(Document_Type, 'Order');
        SetFilter(Type, 'Item');
        SetFilter(Outstanding_Quantity, '<> %1', 0);
        SetFilter(Item_Category_Code, '%1..%2', '1000', '8999');
    end;
}