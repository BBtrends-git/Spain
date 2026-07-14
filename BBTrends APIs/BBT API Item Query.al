query 51401 "API Item"
{
    Caption = 'API Item';
    QueryType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apiitem';
    EntitySetName = 'apiitems';

    elements
    {
        dataitem(Item; Item)
        {
            column(No; "No.")
            { }
            column(Description; Description)
            { }
            column(Description_2; "Description 2")
            { }
            column(Base_Unit_of_Measure; "Base Unit of Measure")
            { }
            column(Item_Category_Code; "Item Category Code")
            { }
            column(Inventory; Inventory)
            { }
            column("Type"; "Type")
            { }
            column(Costing_Method; "Costing Method")
            { }
            column(Unit_Cost; "Unit Cost")
            { }
            column(Standard_Cost; "Standard Cost")
            { }
            column(Last_Direct_Cost; "Last Direct Cost")
            { }
            column(Gross_Weight; "Gross Weight")
            { }
            column(Net_Weight; "Net Weight")
            { }
            column(Inventory_Posting_Group; "Inventory Posting Group")
            { }
            column(VAT_Prod_Posting_Group; "VAT Prod. Posting Group")
            { }
            column(Gen_Prod_Posting_Group; "Gen. Prod. Posting Group")
            { }
            column(Replenishment_System; "Replenishment System")
            { }
            column(Manufacturing_Policy; "Manufacturing Policy")
            { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code")
            { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code")
            { }
            column(Tariff_No; "Tariff No.")
            { }
            column(GTIN; GTIN)
            { }
            column(EANCode; "EAN Code")
            { }
            column(Item_Group; "Item Group")
            { }
            column(Item_Family; "Item Family")
            { }
            column(Item_Subfamily; "Item Subfamily")
            { }
            column(Unit_Price; "Unit Price")
            { }
            //>>>> BBT - SMG
            //>> Obsolete - SMG
            column(ImporteRAEE; "Importe RAEE")
            { }
            column(Royalty; "Royalty %")
            { }
            column(Garantia; "Garantia %")
            { }
            column(Standard_Cost_2024; "Standard Cost 2024")
            { }
            column(Standard_Cost_2025; "Standard Cost 2025")
            { }
            column(Ecommerce_Shipping_Cost; "Ecommerce Shipping Cost")
            { }
            column(Ecommerce_Shipping_Cost_2025; "Ecommerce Shipping Cost 2025")
            { }
            //<< Obsolete - SMG
            column(SMG_RAEE_Amount; "SMG RAEE Amount")
            { }
            column(SMG_Royalty_TP; "SMG Royalty %")
            { }
            column(SMG_Warranty_TP; "SMG Warranty %")
            { }
            //<<<< BBT - SMG
        }
    }
}
