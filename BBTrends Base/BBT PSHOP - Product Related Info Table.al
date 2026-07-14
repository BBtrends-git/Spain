Table 50032 "PSHOP - Product Related Info"
{
    Caption = 'Información relacionada producto Prestashop';
    //DrillDownPageID = "PSHOP - Product Related Info";
    //LookupPageID = "PSHOP - Product Related Info";

    ObsoleteState = Removed;        // BBT 01/07/2025

    fields
    {
        field(1; type; Option)
        {
            OptionCaption = 'Categoría,Accesorio';
            OptionMembers = Category,Accessory;
        }
        field(2; "product id"; Integer)
        {
            TableRelation = "PSHOP - Product".id;
        }
        field(3; "related id"; Integer)
        {
            TableRelation = if (type = const(Category)) "PSHOP - Category".id;
        }
        field(4; "Site Code"; Code[10])
        {
            TableRelation = "PSHOP - Site".Code;
        }
    }
    keys
    {
        key(Key1; "Site Code", type, "product id", "related id")
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }
}
