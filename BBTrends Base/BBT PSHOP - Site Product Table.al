Table 50044 "PSHOP - Site Product"
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
        field(3; "Product No."; Code[20])
        {
            TableRelation = "PSHOP - Product"."NAV Item No.";
        }
        field(12; quantity; Integer)
        { }
        field(25; upc; Text[30])
        { }
        field(29; state; Integer)
        { }
        field(37; price; Decimal)
        {
            trigger OnValidate()
            begin
                Validate("Update Price", true);
            end;
        }
        field(45; active; Integer)
        {
            trigger OnValidate()
            begin
                Validate("Update Active", true);
            end;
        }
        field(48; available_for_order; Integer)
        {
            trigger OnValidate()
            begin
                //VALIDATE("Update Available for Order",TRUE);
            end;
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
        field(66; id_stock_available; Integer)
        { }
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
        field(104; "Update Active"; Boolean)
        {
            //>> BBT 01/07/2025
            /*
            trigger OnValidate()
            var
                PSHOPIntegrationMgt: Codeunit "PSHOP Integration Mgt.";
                Item: Record Item;
            begin
                //CalcUpdate
                TestField("Product No.");
                Item.Reset;
                Item.Get("Product No.");
                PSHOPIntegrationMgt.CreateFromNAVItem(Item, FieldNo("Update Active"), "Site Code", Rec);
            end;
            */
            //<<
        }
        field(105; "Update Marketplace"; Boolean)
        {
            trigger OnValidate()
            begin
                CalcUpdate;
            end;
        }
        field(50014; "Web Catalog"; Boolean)
        {
            Caption = 'Activo en Prestashop';
            InitValue = true;

            //>> BBT 01/07/2025
            /*
            trigger OnValidate()
            var
                PSHOPIntegrationMgt: Codeunit "PSHOP Integration Mgt.";
                Item: Record Item;
            begin
                //active := TRUE;
                TestField("Product No.");
                Item.Reset;
                Item.Get("Product No.");
                PSHOPIntegrationMgt.CreateFromNAVItem(Item, FieldNo("Web Catalog"), "Site Code", Rec);
            end;
            */
            //<<
        }
        field(50016; Clearance; Boolean)
        {
            Caption = 'Liquidación';

            //>> BBT 01/07/2025
            /*
            trigger OnValidate()
            var
                PSHOPIntegrationMgt: Codeunit "PSHOP Integration Mgt.";
                Item: Record Item;
            begin
                TestField("Product No.");
                Item.Reset;
                Item.Get("Product No.");
                PSHOPIntegrationMgt.CreateFromNAVItem(Item, FieldNo(Clearance), "Site Code", Rec);
            end;
            */
            //<<
        }
        field(50017; "Activado Web"; Boolean)
        {
            //>> BBT 01/07/2025
            /*
            trigger OnValidate()
            var
                PSHOPIntegrationMgt: Codeunit "PSHOP Integration Mgt.";
                Item: Record Item;
            begin
                TestField("Product No.");
                Item.Reset;
                Item.Get("Product No.");
                PSHOPIntegrationMgt.CreateFromNAVItem(Item, FieldNo("Activado Web"), "Site Code", Rec);
            end;
            */
            //<<
        }
        field(50018; "Activado Marketplace"; Boolean)
        {
            //>> BBT 01/07/2025
            /*
            trigger OnValidate()
            var
                PSHOPIntegrationMgt: Codeunit "PSHOP Integration Mgt.";
                Item: Record Item;
            begin
                TestField("Product No.");
                Item.Reset;
                Item.Get("Product No.");
                PSHOPIntegrationMgt.CreateFromNAVItem(Item, FieldNo("Activado Marketplace"), "Site Code", Rec);
            end;
            */
            //<<
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

    local procedure CalcUpdate()
    begin
        Update := "Update Price" or "Update Stock" or "Update Active" or "Update Marketplace";
    end;
}
