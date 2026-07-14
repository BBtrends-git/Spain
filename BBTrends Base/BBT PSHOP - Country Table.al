Table 50035 "PSHOP - Country"
{
    Caption = 'País Prestashop';
    ObsoleteState = Removed;        //BBT 01/047/2025

    fields
    {
        field(1; id; Integer)
        { }
        field(2; id_zone; Integer)
        { }
        field(3; id_currency; Integer)
        { }
        field(4; call_prefix; Text[30])
        { }
        field(5; iso_code; Code[10])
        { }
        field(6; active; Integer)
        { }
        field(7; contains_states; Integer)
        { }
        field(8; need_identification_number; Integer)
        { }
        field(9; need_zip_code; Integer)
        { }
        field(10; zip_code_format; Text[30])
        { }
        field(11; display_tax_label; Integer)
        { }
        field(12; name; Text[80])
        { }
        field(13; "Site Code"; Code[10])
        {
            TableRelation = "PSHOP - Site".Code;
        }
        field(100; "NAV Country/Region Code"; Code[20])
        {
            Caption = 'Cód. País NAV';
            TableRelation = "Country/Region".Code;
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
