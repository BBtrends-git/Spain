Table 50031 "PSHOP - Address"
{
    Caption = 'Dirección Prestashop';
    //DrillDownPageID = "PSHOP - Addresses";
    //LookupPageID = "PSHOP - Addresses";
    ObsoleteState = Removed;    //BBT 01/07/2025

    fields
    {
        field(1; id; Integer)
        { }
        field(2; id_customer; Integer)
        {
            TableRelation = "PSHOP - Customer".id;
        }
        field(3; id_manufacturer; Integer)
        { }
        field(4; id_supplier; Integer)
        { }
        field(5; id_warehouse; Integer)
        { }
        field(6; id_country; Integer)
        { }
        field(7; id_state; Integer)
        { }
        field(8; alias; Text[80])
        { }
        field(9; company; Text[50])
        { }
        field(10; lastname; Text[80])
        { }
        field(11; firstname; Text[80])
        { }
        field(12; vat_number; Text[50])
        { }
        field(13; address1; Text[150])
        { }
        field(14; address2; Text[150])
        { }
        field(15; postcode; Text[50])
        { }
        field(16; city; Text[80])
        { }
        field(17; other; Text[50])
        { }
        field(18; phone; Text[30])
        { }
        field(19; phone_mobile; Text[30])
        { }
        field(20; dni; Code[20])
        { }
        field(21; deleted; Integer)
        { }
        field(22; date_add; DateTime)
        { }
        field(23; date_upd; DateTime)
        { }
        field(24; "Site Code"; Code[10])
        {
            TableRelation = "PSHOP - Site".Code;
        }
        field(100; "NAV Contact Alt. Code"; Code[20])
        {
            Caption = 'No. dirección cont. alt.';
            TableRelation = "Contact Alt. Address".Code;
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

    procedure GetCountryRegionCode(): Code[20]
    var
        PSHOPCountry: Record "PSHOP - Country";
    begin
        Clear(PSHOPCountry);
        if id_country <> 0 then begin
            PSHOPCountry.Get("Site Code", id_country);
            PSHOPCountry.TestField("NAV Country/Region Code");
        end;
        exit(PSHOPCountry."NAV Country/Region Code");
    end;
}
