query 51429 "API Sales Order Lines"
{
    Caption = 'API Sales Order Lines';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apisalesorderlines';
    EntitySetName = 'apisalesorderliness';

    elements
    {
        dataitem(SalesLine; "Sales Line")
        {
            column(Shipment_Nr; "Shipment Nr")
            { }
            //column(shi)
        }
    }
}