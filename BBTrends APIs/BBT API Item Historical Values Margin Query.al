query 51402 "API Item Hist Values Margin"
{
    Caption = 'API Item Hist Values Margin';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apiitemhistvalmargin';
    EntitySetName = 'apiitemhistvalmargins';

    elements
    {
        dataitem(SMG_Historical_Values_Margin; "SMG Historical Values Margin")
        {
            column(Item_No_; "Item No.")
            { }
            column(HistoricalType; "Type")
            { }
            column(Cost_Amount; "Cost Amount")
            { }
            column(Starting_Date; "Starting Date")
            { }
            column(Ending_Date; "Ending Date")
            { }
        }
    }
}

