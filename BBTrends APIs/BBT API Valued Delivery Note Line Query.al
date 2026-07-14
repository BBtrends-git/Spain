query 51414 "API Valued Delivery Note"
{
    Caption = 'API Valued Delivery Note';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apivalueddeliverynote';
    EntitySetName = 'apivalueddeliverynotes';

    elements
    {
        dataitem(Item_Ledger_Entry; "Item Ledger Entry")
        {
            filter(Entry_Type; "Entry Type")
            { }
            filter(Document_Type; "Document Type")
            { }
            column(Document_No; "Document No.")
            { }
            column(Posting_Date; "Posting Date")
            { }
            column(Document_Line_No; "Document Line No.")
            { }
            column(Sales_Amount_Actual; "Sales Amount (Actual)")
            { }
        }
    }
    trigger OnBeforeOpen();
    var
        ImporteNeto: Decimal;
    begin
        SETRANGE(Entry_Type, 1);
        SETRANGE(Document_Type, 1);
        SETFILTER(Posting_Date, '>=%1', DMY2DATE(1, 1, 2022));
    end;
}
