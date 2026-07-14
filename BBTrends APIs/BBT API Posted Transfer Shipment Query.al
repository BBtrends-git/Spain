query 51418 "API Posted Transfer Shipment"
{
    Caption = 'API Posted Transfer Shipment';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apipostedtransfershipment';
    EntitySetName = 'apipostedtransfershipments';

    elements
    {
        dataitem(Transfer_Shipment_Header; "Transfer Shipment Header")
        {
            column(No_; "No.")
            { }
            column(External_Document_No_; "External Document No.")
            { }
            column(Transfer_Order_No_; "Transfer Order No.")
            { }
            column(Transfer_from_Code; "Transfer-from Code")
            { }
            column(Transfer_to_Code; "Transfer-to Code")
            { }
            column(Posting_Date; "Posting Date")
            { }
            dataitem(Transfer_Shipment_Line; "Transfer Shipment Line")
            {
                DataItemLink = "Document No." = Transfer_Shipment_Header."No.";

                column(Line_No_; "Line No.")
                { }
                column(Item_No_; "Item No.")
                { }
                column(Description; Description)
                { }
                column(Quantity; Quantity)
                { }

            }
        }
    }
}