Table 50030 "PSHOP - Customer"
{
    Caption = 'Cliente Prestashop';
    //DrillDownPageID = "PSHOP - Customer List";
    //LookupPageID = "PSHOP - Customer List";

    ObsoleteState = Removed;        // BBT 01/07/2025

    fields
    {
        field(1; id; Integer)
        { }
        field(2; id_default_group; Integer)
        { }
        field(3; id_lang; Integer)
        { }
        field(4; newsletter_date_add; DateTime)
        { }
        field(5; ip_registration_newsletter; Text[30])
        { }
        field(6; last_passwd_gen; DateTime)
        { }
        field(7; secure_key; Text[50])
        { }
        field(8; deleted; Integer)
        { }
        field(9; passwd; Text[150])
        {
            Description = '// No sirve para nada, ya que est codificado';
        }
        field(10; lastname; Text[50])
        { }
        field(11; firstname; Text[50])
        { }
        field(12; email; Text[100])
        { }
        field(13; id_gender; Integer)
        { }
        field(14; birthday; Date)
        { }
        field(15; newsletter; Integer)
        { }
        field(16; optin; Integer)
        { }
        field(17; website; Text[50])
        { }
        field(18; company; Text[50])
        { }
        field(19; siret; Text[30])
        { }
        field(20; ape; Text[30])
        { }
        field(21; outstanding_allow_amount; Decimal)
        { }
        field(22; show_public_prices; Integer)
        { }
        field(23; id_risk; Integer)
        { }
        field(24; max_payment_days; Integer)
        { }
        field(25; active; Integer)
        { }
        field(26; note; Text[100])
        { }
        field(27; is_guest; Integer)
        { }
        field(28; id_shop; Integer)
        {
            TableRelation = "PSHOP - Shop".id where("Site Code" = field("Site Code"));
        }
        field(29; id_shop_group; Integer)
        { }
        field(30; date_add; DateTime)
        { }
        field(31; date_upd; DateTime)
        { }
        field(32; reset_password_token; Text[50])
        { }
        field(33; reset_password_validity; DateTime)
        { }
        field(34; "Site Code"; Code[10])
        {
            TableRelation = "PSHOP - Site".Code;
        }
        field(100; "NAV Contact No."; Code[20])
        {
            Caption = 'No. contacto NAV';
            TableRelation = Contact."No.";
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
    trigger OnDelete()
    var
        PSHOPAddress: Record "PSHOP - Address";
    begin
        PSHOPAddress.Reset;
        PSHOPAddress.SetRange(id_customer, id);
        if PSHOPAddress.FindSet then PSHOPAddress.DeleteAll(true);
    end;
}
