Table 50048 "PSHOP - Shop"
{
    ObsoleteState = Removed;        // BBT 01/07/2025

    fields
    {
        field(1; "Site Code"; Code[10])
        {
            Editable = false;
            TableRelation = "PSHOP - Site".Code;
        }
        field(2; id; Integer)
        {
            Editable = false;
        }
        field(3; id_shop_group; Integer)
        { }
        field(4; id_category; Integer)
        { }
        field(5; active; Integer)
        { }
        field(6; deleted; Integer)
        { }
        field(7; name; Text[80])
        { }
        field(8; theme_name; Text[80])
        { }
        field(10; Orders; Integer)
        {
            CalcFormula = count("PSHOP - Order Header" where(id_shop = field(id), "Site Code" = field("Site Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; Customers; Integer)
        {
            CalcFormula = count("PSHOP - Customer" where(id_shop = field(id), "Site Code" = field("Site Code")));
            Editable = false;
            FieldClass = FlowField;
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
