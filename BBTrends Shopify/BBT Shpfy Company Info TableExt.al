tableextension 73103 "BBT Shpfy Company Info Ext" extends "Company Information"
{
    fields
    {
        field(73101; "Main Shop"; Code[20])
        {
            //>> BBT. 25/03/2026. No se utiliza
            ObsoleteState = Removed;
            //<<       
            Caption = 'Main Shop', Comment = 'ESP="Tienda Shopify"';
            DataClassification = CustomerContent;
            TableRelation = "Shpfy Shop";
        }
    }
}
