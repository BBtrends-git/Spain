query 51201 "RMAs API Unit Pending Transfer"
{
    Caption = 'RMAs API units pending transfer', Comment = 'ESP="RMA API Unidades Pendientes de Transferir"';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apiunitpendingtransfer';
    EntitySetName = 'apiunitpendingtransfers';

    elements
    {
        dataitem(RMAsPostedPackageLine; "RMAs Posted Package Line")
        {
            DataItemTableFilter = "Fully Transferred" = const(false), Quantity = filter('>0');

            column(Posted_Package_No; "Posted Package No.")
            { }
            column(Posted_No; "Posted No.")
            { }
            column(Posted_Package_Line; "Posted Package Line")
            { }
            column(Analysis_Date; "Analysis Date")
            { }
            column(Return_Resource; "Return Resource")
            { }
            column(Item_No; "Item No.")
            { }
            column(EAN_of_Unit; "EAN of Unit")
            { }
            column(Description; Description)
            { }
            column(Quality; Quality)
            { }
            column(Quantity; Quantity)
            { }
            column(Transferred_Quantity; "Transferred Quantity")
            { }
        }
    }

    var
        rRMASetup: Record "RMAs Setup";
        rRMAsPostedPackageLine: Record "RMAs Posted Package Line";

    trigger OnBeforeOpen()
    begin
        rRMASetup.Reset();
        rRMASetup.Get();

        if rRMASetup."Scrap Adjust" then
            SetFilter(Quality, '%1|%2', rRMAsPostedPackageLine.Quality::A, rRMAsPostedPackageLine.Quality::B);
    end;

}