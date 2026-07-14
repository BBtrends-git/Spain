query 51427 "API Vendor Ledger Entry"
{
    Caption = 'API Vendor Ledger Entry';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apivendorledgerentry';
    EntitySetName = 'apivendorledgerentrys';

    elements
    {
        dataitem(Vendor; Vendor)
        {
            column(No; "No.")
            { }
            column(Balance_LCY; "Balance (LCY)")
            { }
            dataitem(Vendor_Ledger_Entry; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = Vendor."No.";

                column(Posting_Date; "Posting Date")
                { }
                column(Document_Type; "Document Type")
                { }
                column(Document_No; "Document No.")
                { }
                column(Description; Description)
                { }
                column(External_Document_No; "External Document No.")
                { }
                column(Open; Open)
                { }
                column(Currency_Code; "Currency Code")
                { }
                column(Payment_Method_Code; "Payment Method Code")
                { }
                column(Payment_Terms_Code; "Payment Terms Code")
                { }
                column(Due_Date; "Due Date")
                { }
                column(Remaining_Amount; "Remaining Amount")
                { }
                column(Remaining_Amt_LCY; "Remaining Amt. (LCY)")
                { }
                column(Entry_No; "Entry No.")
                { }
            }
        }
    }
    trigger OnBeforeOpen();
    begin
        SETFILTER(No, '%1..%2', 'PCL00000', 'PCL99999');
        SETFILTER(Balance_LCY, '<> %1', 0);
        SETFILTER(Open, '= %1', true);
    end;
}
