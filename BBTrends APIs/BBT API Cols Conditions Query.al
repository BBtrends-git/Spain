query 51404 "API Cols Conditions"
{
    Caption = 'API Cols Conditions';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apiacolscond';
    EntitySetName = 'apicolsconds';

    elements
    {
        dataitem(SMG_COLS_Conditions; "SMG COLS Conditions")
        {
            column(Customer_No_; "Customer No.")
            { }
            column(TP_COLS_Excluded_from_Invoice; "% COLS Excluded from Invoice")
            { }
            column(Starting_Date; "Starting Date")
            { }
            column(Ending_Date; "Ending Date")
            { }
        }
    }
}