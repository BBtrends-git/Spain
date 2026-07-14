Table 50029 "PSHOP - Product"
{
    Caption = 'Producto Prestashop';
    //DrillDownPageID = "PSHOP - Product List";
    //LookupPageID = "PSHOP - Product List";

    ObsoleteState = Removed;        // BBT 01/07/2025

    fields
    {
        field(1; id; Integer)
        {
            trigger OnValidate()
            begin
                Error('Este campo está obsoleto');
            end;
        }
        field(2; id_manufacturer; Integer)
        { }
        field(3; id_supplier; Integer)
        { }
        field(4; id_category_default; Integer)
        { }
        field(5; new; Text[30])
        { }
        field(6; cache_default_attribute; Integer)
        { }
        field(7; id_default_image; Integer)
        { }
        field(8; id_default_combination; Integer)
        { }
        field(9; id_tax_rules_group; Integer)
        { }
        field(10; position_in_category; Integer)
        { }
        field(11; manufacturer_name; Text[30])
        { }
        field(12; quantity; Integer)
        { }
        field(13; type; Option)
        {
            OptionCaption = 'simple';
            OptionMembers = simple;
        }
        field(14; id_shop_default; Integer)
        { }
        field(15; reference; Text[30])
        { }
        field(16; supplier_reference; Text[30])
        { }
        field(17; location; Text[30])
        { }
        field(18; width; Decimal)
        { }
        field(19; height; Decimal)
        { }
        field(20; depth; Decimal)
        { }
        field(21; weight; Decimal)
        { }
        field(22; quantity_discount; Integer)
        { }
        field(23; ean13; Text[30])
        { }
        field(24; isbn; Text[30])
        { }
        field(25; upc; Text[30])
        { }
        field(26; cache_is_pack; Integer)
        { }
        field(27; cache_has_attachments; Integer)
        { }
        field(28; is_virtual; Integer)
        { }
        field(29; state; Integer)
        { }
        field(30; additional_delivery_times; Integer)
        { }
        field(31; on_sale; Integer)
        { }
        field(32; online_only; Integer)
        { }
        field(33; ecotax; Decimal)
        { }
        field(34; minimal_quantity; Integer)
        { }
        field(35; low_stock_threshold; Text[30])
        { }
        field(36; low_stock_alert; Integer)
        { }
        field(37; price; Decimal)
        {
            trigger OnValidate()
            begin
                Validate("Update Price", true);
            end;
        }
        field(38; wholesale_price; Decimal)
        { }
        field(39; unity; Text[30])
        { }
        field(40; unit_price_ratio; Decimal)
        { }
        field(41; additional_shipping_cost; Decimal)
        { }
        field(42; customizable; Integer)
        { }
        field(43; text_fields; Integer)
        { }
        field(44; uploadable_files; Integer)
        { }
        field(45; active; Integer)
        {
            trigger OnValidate()
            begin
                Validate("Update Available for Order", true);
            end;
        }
        field(46; redirect_type; Text[30])
        { }
        field(47; id_type_redirected; Integer)
        { }
        field(48; available_for_order; Integer)
        {
            trigger OnValidate()
            begin
                //VALIDATE("Update Available for Order",TRUE);
            end;
        }
        field(49; available_date; Date)
        { }
        field(50; show_condition; Integer)
        { }
        field(51; condition; Text[30])
        { }
        field(52; show_price; Integer)
        { }
        field(53; indexed; Integer)
        { }
        field(54; visibility; Text[30])
        { }
        field(55; advanced_stock_management; Integer)
        { }
        field(56; date_add; DateTime)
        { }
        field(57; date_upd; DateTime)
        { }
        field(58; pack_stock_type; Integer)
        { }
        field(59; "delivery in stock"; Text[80])
        {
            Description = 'Sale en array';
        }
        field(60; "delivery out stock"; Text[80])
        {
            Description = 'Sale en array';
        }
        field(61; stock_available; Decimal)
        {
            trigger OnValidate()
            begin
                Validate("Update Stock", true);
            end;
        }
        field(62; out_of_stock; Decimal)
        { }
        field(63; name; Text[250])
        { }
        field(64; description; Blob)
        { }
        field(65; description_short; Blob)
        { }
        field(66; id_stock_available; Integer)
        { }
        field(80; "Categories Count"; Integer)
        {
            CalcFormula = count("PSHOP - Product Related Info" where(type = const(Category), "product id" = field(id)));
            Caption = 'No. categorías';
            Editable = false;
            FieldClass = FlowField;
        }
        field(81; "Accessories Count"; Integer)
        {
            CalcFormula = count("PSHOP - Product Related Info" where(type = const(Accessory), "product id" = field(id)));
            Caption = 'No. accesorios';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; "NAV Item No."; Code[20])
        {
            Caption = 'No. producto NAV';
            TableRelation = Item."No.";
        }
        field(101; Update; Boolean)
        { }
        field(102; "Update Stock"; Boolean)
        {
            trigger OnValidate()
            begin
                CalcUpdate
            end;
        }
        field(103; "Update Price"; Boolean)
        {
            trigger OnValidate()
            begin
                CalcUpdate
            end;
        }
        field(104; "Update Available for Order"; Boolean)
        {
            trigger OnValidate()
            begin
                CalcUpdate
            end;
        }
        field(105; "Update Marketplace"; Boolean)
        {
            trigger OnValidate()
            begin
                CalcUpdate;
            end;
        }
        field(50000; "Tarifa MarketPlace"; Decimal)
        {
            CalcFormula = lookup("Sales Price"."Unit Price" where("Item No." = field(reference), "Sales Type" = const("Customer Price Group"), "Sales Code" = const('MARKETPLAC')));
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key1; "NAV Item No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }

    procedure ReadDescription(): Text
    var
        IStream: InStream;
        DummyTxt: Text;
    begin
        CalcFields(description);
        description.CreateInstream(IStream, Textencoding::Windows);
        IStream.ReadText(DummyTxt);
        exit(DummyTxt);
    end;

    procedure WriteDescription(Txt: Text)
    var
        OStream: OutStream;
    begin
        Clear(description);
        description.CreateOutstream(OStream);
        OStream.WriteText(Txt);
    end;

    procedure ReadDescriptionShort(): Text
    var
        IStream: InStream;
        DummyTxt: Text;
    begin
        CalcFields(description_short);
        description_short.CreateInstream(IStream, Textencoding::Windows);
        IStream.ReadText(DummyTxt);
        exit(DummyTxt);
    end;

    procedure WriteDescriptionShort(Txt: Text)
    var
        OStream: OutStream;
    begin
        Clear(description_short);
        description_short.CreateOutstream(OStream);
        OStream.WriteText(Txt);
    end;

    local procedure CalcUpdate()
    begin
        Update := "Update Price" or "Update Stock" or "Update Available for Order" or "Update Marketplace";
    end;
}
