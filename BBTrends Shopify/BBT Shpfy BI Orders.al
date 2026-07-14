query 73100 "BBT Shpfy BI Orders"
{
    Caption = 'BI Shopify Orders', Comment = 'ESP="BI Pedidos Shopify"';
    elements
    {
        dataitem(Shpf_Order_Header; "Shpfy Order Header")
        {
            column(Shpfy_Order_Id; "Shopify Order Id")
            { }
            column(Shpfy_Order_No; "Shopify Order No.")
            { }
            column(Document_Date; "Document Date")
            { }
            column(Sellto_Customer_No; "Sell-to Customer No.")
            { }
            column(Sellto_Customer_Name; "Sell-to Customer Name")
            { }
            column(Sell_to_Country_Region_Code; "Sell-to Country/Region Code")
            { }
            column(Sell_to_Post_Code; "Sell-to Post Code")
            { }
            column(App_name; "App Name")
            { }
            column(Channel_name; "Channel Name")
            { }
            column(Sales_Order_No; "Sales Order No.")
            { }
            column(Financial_Status; "Financial Status")
            { }
            column(Fulfillment_Status; "Fulfillment Status")
            { }
            column(Closed; Closed)
            { }
            column(Total_Amount; "Total Amount")
            { }
            column(Presentment_Total_Amount; "Presentment Total Amount")
            { }
            column(VAT_Included; "VAT Included")
            { }
            column(VAT_Amount; "VAT Amount")
            { }
            column(Shipping_Charges_Amount; "Shipping Charges Amount")
            { }
            column(Currency_Code; "Currency Code")
            { }
            dataitem(Shpfy_Order_Line; "Shpfy Order Line")
            {
                DataItemLink = "Shopify Order Id" = Shpf_Order_Header."Shopify Order Id";

                column("Line_Id"; "Line Id")
                { }
                column(item_No; "Item No.")
                { }
                column(Shopify_Product_Id; "Shopify Product Id")
                { }
                column(Description; Description)
                { }
                column(Variant_Code; "Variant Code")
                { }
                column(Shopify_Variant_Id; "Shopify Variant Id")
                { }
                column(Variant_Description; "Variant Description")
                { }
                column(Quantity; Quantity)
                { }
                column(Fulfillable_Quantity; "Fulfillable Quantity")
                { }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                { }
                column(Unit_price; "Unit Price")
                { }
                column(Discount_Amount; "Discount Amount")
                { }
                column(Presentment_Unit_Price; "Presentment Unit Price")
                { }
                column(Presentment_Discount_Amount; "Presentment Discount Amount")
                { }
                column(Taxable; Taxable)
                { }
                column(Gift_Card; "Gift Card")
                { }
            }
        }
    }
}


