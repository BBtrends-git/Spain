query 51424 "API Sales Return Order"
{
    Caption = 'API Sales Return Order';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apisalesreturnorder';
    EntitySetName = 'apisalesreturnorders';

    elements
    {
        dataitem(Sales_Header; "Sales Header")
        {
            column(Document_Type; "Document Type")
            { }
            column(No; "No.")
            { }
            column(Posting_Date; "Posting Date")
            { }
            column(Order_Date; "Order Date")
            { }
            column(Requested_Delivery_Date; "Requested Delivery Date")
            { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            { }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            { }
            column(Sell_to_Address; "Sell-to Address")
            { }
            column(Sell_to_Address_2; "Sell-to Address 2")
            { }
            column(Sell_to_Post_Code; "Sell-to Post Code")
            { }
            column(Sell_to_City; "Sell-to City")
            { }
            Column(Sell_to_County; "Sell-to County")
            { }
            column(Sell_to_Country_Region_Code; "Sell-to Country/Region Code")
            { }
            column(Sell_to_Contact; "Sell-to Contact")
            { }
            column(Sell_to_Phone_No_; "Sell-to Phone No.")
            { }
            column(Sell_to_E_Mail; "Sell-to E-Mail")
            { }
            column(External_Document_No_; "External Document No.")
            { }
            column(Your_Reference; "Your Reference")
            { }
            column(Last_Posting_No_; "Last Posting No.")
            { }
            column(Location_Code; "Location Code")
            { }
            column(Assigned_User_ID; "Assigned User ID")
            { }
            column(Status; Status)
            { }
            column(Shipping_Agent_Code; "Shipping Agent Code")
            { }
            column(Number_of_Packages; "Number of Packages")
            { }
            column(Reference; Reference)
            { }
            column(Last_Return_Receipt_No_; "Last Return Receipt No.")
            { }
            column(Amount; Amount)
            { }
            column(Amount_Including_VAT; "Amount Including VAT")
            { }
            column(Completely_Shipped; "Completely Shipped")
            { }
            column(Reason_Code; "Reason Code")
            { }
            column(EDI_EDI_Order; "EDI - EDI Order")
            { }
            column(Ship_to_Code; "Ship-to Code")
            { }
            column(Ship_to_Name; "Ship-to Name")
            { }
            column(Ship_to_Address; "Ship-to Address")
            { }
            column(Ship_to_Address_2; "Ship-to Address 2")
            { }
            column(Ship_to_Post_Code; "Ship-to Post Code")
            { }
            column(Ship_to_City; "Ship-to City")
            { }
            column(Ship_to_County; "Ship-to County")
            { }
            column(Ship_to_Country_Region_Code; "Ship-to Country/Region Code")
            { }
            column(Ship_to_Contact; "Ship-to Contact")
            { }
            column(Ship_to_Phone_No_; "Ship-to Phone No.")
            { }
        }
    }
    var
        rSalesHeader: Record "Sales Header";

    trigger OnBeforeOpen();
    begin
        SETFILTER(Document_Type, '= %1', rSalesHeader."Document Type"::"Return Order");
    end;
}
