query 51419 "API Sales Credit Memo"
{
    Caption = 'API Sales Credit Memo';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apisalescreditmemo';
    EntitySetName = 'apisalescreditmemos';

    elements
    {
        dataitem(Sales_Cr_Memo_Header; "Sales Cr.Memo Header")
        {
            column(No; "No.")
            { }
            column(Sell_to_Customer_No; "Sell-to Customer No.")
            { }
            column(Posting_Date; "Posting Date")
            { }
            column(Currency_Code; "Currency Code")
            { }
            column(Currency_Factor; "Currency Factor")
            { }
            column(External_Document_No_; "External Document No.")
            { }
            column(Reference; Reference)
            { }
            column(Your_Reference; "Your Reference")
            { }
            column(Reason_Code; "Reason Code")
            { }
            dataitem(Sales_Cr_Memo_Line; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = Sales_Cr_Memo_Header."No.";
                column(Line_No; "Line No.")
                { }
                column(Type; Type)
                { }
                column(ItemNo; "No.")
                {
                    Caption = 'ItemNo', Comment = 'ESP="NoProducto"';
                }
                column(Location_Code; "Location Code")
                { }
                column(Posting_Group; "Posting Group")
                { }
                column(Shipment_Date; "Shipment Date")
                { }
                column(Description; Description)
                { }
                column(Description_2; "Description 2")
                { }
                column(Unit_of_Measure; "Unit of Measure")
                { }
                column(Quantity; Quantity)
                { }
                column(Unit_Price; "Unit Price")
                { }
                column(Unit_Cost_LCY; "Unit Cost (LCY)")
                { }
                column(VAT; "VAT %")
                { }
                column(Line_Discount; "Line Discount %")
                { }
                column(Line_Discount_Amount; "Line Discount Amount")
                { }
                column(Amount; Amount)
                { }
                column(Amount_Including_VAT; "Amount Including VAT")
                { }
                column(Gross_Weight; "Gross Weight")
                { }
                column(Net_Weight; "Net Weight")
                { }
                column(Unit_Volume; "Unit Volume")
                { }
                column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code")
                { }
                column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code")
                { }
                column(Customer_Price_Group; "Customer Price Group")
                { }
                column(Return_Receipt_No; "Return Receipt No.")
                { }
                column(Return_Receipt_Line_No; "Return Receipt Line No.")
                { }
                column(Gen_Bus_Posting_Group; "Gen. Bus. Posting Group")
                { }
                column(Gen_Prod_Posting_Group; "Gen. Prod. Posting Group")
                { }
                column(VAT_Bus_Posting_Group; "VAT Bus. Posting Group")
                { }
                column(VAT_Prod_Posting_Group; "VAT Prod. Posting Group")
                { }
                column(VAT_Base_Amount; "VAT Base Amount")
                { }
                column(Unit_Cost; "Unit Cost")
                { }
                column(Line_Amount; "Line Amount")
                { }
                column(VAT_Identifier; "VAT Identifier")
                { }
                column(Qty_per_Unit_of_Measure; "Qty. per Unit of Measure")
                { }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                { }
                column(Quantity_Base; "Quantity (Base)")
                { }
                column(Item_Category_Code; "Item Category Code")
                { }
            }
        }
    }

    trigger OnBeforeOpen();
    begin
        SETFILTER(Quantity, '<> %1', 0);
    end;
}

