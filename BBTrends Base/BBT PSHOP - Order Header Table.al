Table 50025 "PSHOP - Order Header"
{
    Caption = 'Cab. Pedido Prestashop';
    //DrillDownPageID = "PSHOP - Order List";
    //LookupPageID = "PSHOP - Order List";

    ObsoleteState = Removed;        // BBT 01/07/2025

    fields
    {
        field(1; id; Integer)
        { }
        field(2; id_address_delivery; Integer)
        {
            TableRelation = "PSHOP - Address".id;
        }
        field(3; id_address_invoice; Integer)
        {
            TableRelation = "PSHOP - Address".id;
        }
        field(4; id_cart; Integer)
        { }
        field(5; id_lang; Integer)
        { }
        field(6; id_customer; Integer)
        {
            TableRelation = "PSHOP - Customer".id;
        }
        field(7; id_carrier; Integer)
        { }
        field(8; current_state; Integer)
        {
            TableRelation = "PSHOP - Order State".id;

            trigger OnValidate()
            begin
                Validate("Update Status", true);
            end;
        }
        field(9; module; Text[30])
        { }
        field(10; invoice_number; Integer)
        { }
        field(11; invoice_date; DateTime)
        { }
        field(12; delivery_number; Integer)
        { }
        field(13; delivery_date; DateTime)
        { }
        field(14; valid; Integer)
        { }
        field(15; date_add; DateTime)
        { }
        field(16; date_upd; DateTime)
        { }
        field(17; shipping_number; Integer)
        { }
        field(18; id_shop_group; Integer)
        { }
        field(19; id_shop; Integer)
        {
            TableRelation = "PSHOP - Shop".id where("Site Code" = field("Site Code"));
        }
        field(20; secure_key; Text[50])
        {
            ExtendedDatatype = Masked;
        }
        field(21; payment; Text[50])
        { }
        field(22; recyclable; Integer)
        { }
        field(23; gift; Integer)
        { }
        field(24; gift_message; Text[80])
        { }
        field(25; mobile_theme; Integer)
        { }
        field(26; total_discounts; Decimal)
        { }
        field(27; total_discounts_tax_incl; Decimal)
        { }
        field(28; total_discounts_tax_excl; Decimal)
        { }
        field(29; total_paid; Decimal)
        { }
        field(30; total_paid_tax_incl; Decimal)
        { }
        field(31; total_paid_tax_excl; Decimal)
        { }
        field(32; total_paid_real; Decimal)
        { }
        field(33; total_products; Decimal)
        { }
        field(34; total_products_wt; Decimal)
        { }
        field(35; total_shipping; Decimal)
        { }
        field(36; total_shipping_tax_incl; Decimal)
        { }
        field(37; total_shipping_tax_excl; Decimal)
        { }
        field(38; carrier_tax_rate; Decimal)
        { }
        field(39; total_wrapping; Decimal)
        { }
        field(40; total_wrapping_tax_incl; Decimal)
        { }
        field(41; total_wrapping_tax_excl; Decimal)
        { }
        field(42; round_mode; Decimal)
        { }
        field(43; round_type; Decimal)
        { }
        field(44; conversion_rate; Decimal)
        { }
        field(45; reference; Text[30])
        { }
        field(46; ref_pedido_beezup; Text[100])
        { }
        field(47; ref_pedido_marketplace; Code[50])
        { }
        field(48; marketplace; Code[20])
        { }
        field(49; "Package Tracking No."; Text[30])
        {
            Caption = 'Package Tracking No.';

            trigger OnValidate()
            begin
                Validate("Update Tracking", true);
            end;
        }
        field(50; "Site Code"; Code[10])
        {
            Caption = 'Cód. Sitio';
            TableRelation = "PSHOP - Site".Code;
        }
        field(100; "NAV Order No."; Code[20])
        {
            Caption = 'No. pedido NAV';
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
        }
        field(101; "Error Text"; Text[250])
        {
            Caption = 'Texto error';
            Editable = false;
        }
        field(102; "Convert Order"; Boolean)
        {
            CalcFormula = lookup("PSHOP - Order State"."Convert Order" where(id = field(current_state), "Site Code" = field("Site Code")));
            Caption = 'Convertir a pedido NAV';
            FieldClass = FlowField;
        }
        field(103; "current_state name"; Text[50])
        {
            CalcFormula = lookup("PSHOP - Order State".name where(id = field(current_state), "Site Code" = field("Site Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(104; "Update Status"; Boolean)
        {
            Caption = 'Actualizar estado';
        }
        field(105; "Nombre marketplace"; Text[50])
        {
            CalcFormula = lookup("PSHOP - Marketplace".Name where(Code = field(marketplace), "Site Code" = field("Site Code")));
            FieldClass = FlowField;
        }
        field(106; "Blocked per price"; Boolean)
        {
            Caption = 'Bloqueado por precio';
        }
        field(107; "Update Tracking"; Boolean)
        {
            Caption = 'Actualizar seguimiento';
        }
        field(108; "Tracking Updated"; Boolean)
        { }
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

    trigger OnDelete()
    var
        PSHOPOrderLine: Record "PSHOP - Order Line";
    begin
        PSHOPOrderLine.Reset;
        PSHOPOrderLine.SetRange("Order Id", id);
        if PSHOPOrderLine.FindSet then PSHOPOrderLine.DeleteAll(true);
    end;
}
