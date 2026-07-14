query 51416 "API Sales Shipments"
{
    Caption = 'API Sales Shipments';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apisalesshipment';
    EntitySetName = 'apisalesshipments';

    elements
    {
        dataitem(Sales_Shipment_Header; "Sales Shipment Header")
        {
            column(No; "No.")
            { }
            column(Sell_to_Customer; "Sell-to Customer No.")
            { }
            column(Order_No; "Order No.")
            { }
            column(Warehouse_Ship_No; "Warehose Ship No.")
            { }
            column(Order_Date; "Order Date")
            { }
            column(Posting_Date; "Posting Date")
            { }
            column(Shipment_Date; "Shipment Date")
            { }
            column(Document_Date; "Document Date")
            { }
            column(External_Document_No; "External Document No.")
            { }
            column(Package_Tracking_No; "Package Tracking No.")
            { }
            column(Sh_Agent_Status; "Sh. Agent - Status")
            { }
            column(Sh_Agent_Tracking_Date; "Sh. Agent - Tracking Date")
            { }
            column(Shipping_Agent_Code; "Shipping Agent Code")
            { }
            column(Shipment_Finished; "Shipment Finished")
            { }
            column(SystemCreatedAt; SystemCreatedAt)
            { }
            column(Location_Code; "Location Code")
            { }
        }
    }
}