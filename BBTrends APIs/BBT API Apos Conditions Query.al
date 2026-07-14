query 51403 "API Apos Conditions"
{
    Caption = 'API Apos Conditions';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apiaposcond';
    EntitySetName = 'apiaposconds';

    elements
    {
        dataitem(SMG_APOS_Conditions; "SMG APOS Conditions")
        {
            column(Condition_Classification; "Condition Classification")
            { }
            column(Condition_Code; "Condition Code")
            { }
            column(Description; "Description")
            { }
            column(TP_APOS_Excluded_from_Invoice; "% APOS Excluded from Invoice")
            { }
            column(Brand; Brand)
            { }
            column(Starting_Date; "Starting Date")
            { }
            column(Ending_Date; "Ending Date")
            { }
        }
    }
}
