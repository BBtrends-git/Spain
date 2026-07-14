tableextension 73100 "BBT Shopfy Item Ext" extends Item
{
    fields
    {
        field(73100; "e-commerce"; Boolean)
        {
            //Caption = 'Ecommerce', Comment = 'ESP="Ecommerce"';
            Caption = 'Active on Shopify', Comment = 'ESP="Activo en Shopify"';
            DataClassification = ToBeClassified;
        }
        field(73101; "En Liquidación"; Boolean)
        {
            Caption = 'In Liquidation', Comment = 'ESP="En Liquidación"';
            DataClassification = ToBeClassified;
        }
    }
}
