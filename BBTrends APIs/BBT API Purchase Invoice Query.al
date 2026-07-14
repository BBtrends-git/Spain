query 51422 "API Purchase Invoice"
{
    Caption = 'API Purchase Invoice';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apipurchaseinvoice';
    EntitySetName = 'apipurchaseinvoices';

    elements
    {
        dataitem(Purch_Inv_Header; "Purch. Inv. Header")
        {
            column(No; "No.")
            { }
            column(Buy_from_Vendor_No; "Buy-from Vendor No.")
            { }
            column(Posting_Date; "Posting Date")
            { }
            column(Currency_Code; "Currency Code")
            { }
            column(Currency_Factor; "Currency Factor")
            { }
            column(Import_No_; "Import No.")
            { }
            dataitem(Purch_Inv_Line; "Purch. Inv. Line")
            {
                DataItemLink = "Document No." = Purch_Inv_Header."No.";

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
                column(Expected_Receipt_Date; "Expected Receipt Date")
                { }
                column(Description; Description)
                { }
                column(Description_2; "Description 2")
                { }
                column(Unit_of_Measure; "Unit of Measure")
                { }
                column(Quantity; Quantity)
                { }
                column(Direct_Unit_Cost; "Direct Unit Cost")
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
                column(Receipt_No; "Receipt No.")
                { }
                column(Receipt_Line_No; "Receipt Line No.")
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
