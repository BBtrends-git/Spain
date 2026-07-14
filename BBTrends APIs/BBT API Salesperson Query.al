query 51406 "API Salesperson"
{
    Caption = 'API Salesperson';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apisalesperson';
    EntitySetName = 'apisalespersons';

    elements
    {
        dataitem(Salesperson_Purchaser; "Salesperson/Purchaser")
        {
            column("Code"; "Code")
            { }
            column(Name; Name)
            { }
            column(E_Mail; "E-Mail")
            { }
            column(Phone_No_; "Phone No.")
            { }
        }
    }
}
