query 51426 "API Customer Ledger Entry"
{
    Caption = 'API Customer Ledger Entry';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apicustomerledgerentry';
    EntitySetName = 'apicustomerledgerentrys';

    elements
    {
        dataitem(Customer;
        Customer)
        {
            column(No; "No.")
            { }
            column(Balance_LCY; "Balance (LCY)")
            { }
            dataitem(Cust_Ledger_Entry; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = Customer."No.";

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
        SETFILTER(Balance_LCY, '<> %1', 0);
        SETFILTER(Open, '= %1', true);
    end;
}
