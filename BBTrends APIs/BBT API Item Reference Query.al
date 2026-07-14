query 51410 "API Item Reference"
{
    Caption = 'API Item Reference';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apiitemreference';
    EntitySetName = 'apiitemreference';

    elements
    {
        dataitem(Item_Reference; "Item Reference")
        {
            column(Item_No_; "Item No.")
            { }
            column(Reference_Type; "Reference Type")
            { }
            column(Reference_Type_No_; "Reference Type No.")
            { }
            column(Reference_No_; "Reference No.")
            { }
            column(Description; Description)
            { }
            column(Unit_of_Measure; "Unit of Measure")
            { }
        }
    }
}