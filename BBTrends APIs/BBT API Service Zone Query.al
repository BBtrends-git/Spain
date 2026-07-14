query 51408 "API Service Zone"
{
    Caption = 'API Service Zone';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apiservicezone';
    EntitySetName = 'apiservicezones';
    elements
    {
        dataitem(Service_Zone; "Service Zone")
        {
            column("Code"; "Code")
            { }
            column(Description; Description)
            { }
        }
    }
}
