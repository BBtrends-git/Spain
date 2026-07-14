query 51415 "API Warehouse Shipments"
{
    Caption = 'API Warehouse Shipments';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apiwarehouseshipment';
    EntitySetName = 'apiwarehouseshipments';

    elements
    {
        dataitem(Warehouse_Shipment_Header; "Warehouse Shipment Header")
        {
            column(No; "No.")
            { }
            column(Document_Status; "Document Status")
            { }
            column(Posting_Date; "Posting Date")
            { }
            column(Shipment_Date; "Shipment Date")
            { }
            column(Destination_No_; "Destination No.")
            { }
            column(Grabado_SGA; "Grabado SGA")
            { }
            column(Leido_SGA; "Leido SGA")
            { }
            column(Source_No_; "Source No.")
            { }
            column(SystemCreatedAt; SystemCreatedAt)
            { }
        }
    }
}