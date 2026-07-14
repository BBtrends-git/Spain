query 51409 "API Sales Orders"
{
    Caption = 'API Sales Orders';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apisalesorder';
    EntitySetName = 'apisalesorders';

    elements
    {
        dataitem(Sales_Header; "Sales Header")
        {
            filter(Document_Type; "Document Type")
            { }
            column(No; "No.")
            { }
            column(Order_Date; "Order Date")
            { }
            column(Sell_to_Customer_No; "Sell-to Customer No.")
            { }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            { }
            column(External_Document_No; "External Document No.")
            { }
            column(Your_Reference; "Your Reference")
            { }
            column(Ship_to_Code; "Ship-to Code")
            { }
            column(Ship_to_Name; "Ship-to Name")
            { }
            column(Shipment_Date; "Shipment Date")
            { }
            column(Requested_Delivery_Date; "Requested Delivery Date")
            { }
            column(Shipping_Agent_Code; "Shipping Agent Code")
            { }
            column(Payment_Method_Code; "Payment Method Code")
            { }
            column(Payment_Terms_Code; "Payment Terms Code")
            { }
            column(Currency_Code; "Currency Code")
            { }
            column(Currency_Factor; "Currency Factor")
            { }
            column(Customer_Price_Group; "Customer Price Group")
            { }
            column(Salesperson_Code; "Salesperson Code")
            { }
            column(Amount; Amount)
            { }
            column(Amount_Including_VAT; "Amount Including VAT")
            { }
            column(Service_Zone_Code; "Service Zone Code")
            { }
            filter(Completely_Shipped; "Completely Shipped")
            { }
            dataitem(Sales_Line; "Sales Line")
            {
                DataItemLink = "Document Type" = Sales_Header."Document Type", "Document No." = Sales_Header."No.";

                column(Line_No; "Line No.")
                { }
                filter(Type; Type)
                { }
                column(Item_No; "No.")
                { }
                column(Location_Code; "Location Code")
                { }
                column(Description; Description)
                { }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                { }
                column(Quantity; Quantity)
                { }
                column(Outstanding_Quantity; "Outstanding Quantity")
                { }
                column(Qty_to_Ship; "Qty. to Ship")
                { }
                column(Quantity_Shipped; "Quantity Shipped")
                { }
                column(Qty_to_Invoice; "Qty. to Invoice")
                { }
                column(Shipped_Not_Invoiced; "Shipped Not Invoiced")
                { }
                column(Quantity_Invoiced; "Quantity Invoiced")
                { }
                column(Unit_Price; "Unit Price")
                { }
                column(Line_Amount; Amount)
                { }
                column(Line_Amount_Including_VAT; "Amount Including VAT")
                { }
                column(Margin; "SMG Margin %")
                { }
                column(NetUnitPrice; "SMG Net Unit Price")
                { }
                column(SMG_Margin; "SMG Margin %")
                { }
                column(SMG_NetUnitPrice; "SMG Net Unit Price")
                { }
            }
        }
    }
    trigger OnBeforeOpen();
    begin
        SETRANGE(Document_Type, 1);
        SETRANGE(Completely_Shipped, false);
        SETRANGE(Type, 2);
        SETFILTER(Outstanding_Quantity, '<>%1', 0);
    end;
}
