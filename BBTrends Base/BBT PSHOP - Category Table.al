Table 50033 "PSHOP - Category"
{
    Caption = 'Categoría Prestashop';
    //DrillDownPageID = "PSHOP - Categories";
    //LookupPageID = "PSHOP - Categories";
    ObsoleteState = Removed;    // BBT 01/07/2025

    fields
    {
        field(1; id; Integer)
        { }
        field(2; id_parent; Integer)
        {
            //ObsoleteState = Removed
            //TableRelation = "PSHOP - Category".id;
        }
        field(3; level_depth; Integer)
        { }
        field(4; nb_products_recursive; Integer)
        { }
        field(5; active; Integer)
        { }
        field(6; id_shop_default; Integer)
        { }
        field(7; is_root_category; Integer)
        { }
        field(8; position; Integer)
        { }
        field(9; date_add; DateTime)
        { }
        field(10; date_upd; DateTime)
        { }
        field(11; name; Text[150])
        { }
        field(12; description; Text[150])
        { }
        field(13; "Site Code"; Code[10])
        {
            TableRelation = "PSHOP - Site".Code;
        }
    }
    keys
    {
        key(Key1; "Site Code", id)
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }
}
