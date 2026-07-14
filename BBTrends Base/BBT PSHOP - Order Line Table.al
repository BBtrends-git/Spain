Table 50026 "PSHOP - Order Line"
{
    Caption = 'Línea pedido Prestashop';

    ObsoleteState = Removed;        // BBT 01/07/2025

    fields
    {
        field(1; "Order Id"; Integer)
        { }
        field(2; "Line Id"; Integer)
        { }
        field(3; product_id; Integer)
        {
            TableRelation = "PSHOP - Product".id;
        }
        field(4; product_attribute_id; Integer)
        { }
        field(5; product_quantity; Decimal)
        { }
        field(6; product_name; Text[250])
        { }
        field(7; product_reference; Text[30])
        { }
        field(8; product_ean13; Code[30])
        { }
        field(9; product_isbn; Code[30])
        { }
        field(10; product_upc; Code[30])
        { }
        field(11; product_price; Decimal)
        { }
        field(12; id_customization; Integer)
        { }
        field(13; unit_price_tax_incl; Decimal)
        { }
        field(14; unit_price_tax_excl; Decimal)
        { }
        field(15; "Site Code"; Code[10])
        {
            TableRelation = "PSHOP - Site".Code;
        }
    }
    keys
    {
        key(Key1; "Site Code", "Order Id", "Line Id")
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }
}
