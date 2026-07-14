Table 50020 "Packaging Line"
{
    Caption = 'Línea Embalaje';
    DrillDownPageID = 50040;
    LookupPageID = 50040;

    fields
    {
        field(1; "No."; Code[50])
        {
            Caption = 'Nº';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Nº Línea';
        }
        field(3; "Source Type"; Integer)
        {
            CalcFormula = lookup(Packaging."Source Type" where("No." = field("No.")));
            Caption = 'Tipo origen';
            Editable = true;
            FieldClass = FlowField;
        }
        field(4; "Source No."; Code[20])
        {
            CalcFormula = lookup(Packaging."Source No." where("No." = field("No.")));
            Caption = 'Nº Origen';
            Editable = true;
            FieldClass = FlowField;
        }
        field(5; "Source Line No."; Integer)
        {
            Caption = 'Nº Línea origen';
            Editable = true;
        }
        field(6; "Posted Source Type"; Integer)
        {
            CalcFormula = lookup(Packaging."Posted Source Type" where("No." = field("No.")));
            Caption = 'Tipo origen reg.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Posted Source No."; Code[20])
        {
            CalcFormula = lookup(Packaging."Posted Source No." where("No." = field("No.")));
            Caption = 'Nº Origen reg.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Posted Source Line No."; Integer)
        {
            Caption = 'Nº Línea origen reg.';
            Editable = false;
            Enabled = false;
        }
        field(9; "Item No."; Code[20])
        {
            Caption = 'Nº Producto';
            Editable = true;
            TableRelation = Item;

            trigger OnValidate()
            var
                SalesLine: Record "Sales Line";
            begin
                GetHeader;
                if "Item No." = '' then
                    "Source Line No." := 0
                else begin
                    //CASE Packaging."Source Type" OF
                    //  DATABASE::"Sales Line":
                    //    BEGIN
                    SalesLine.Reset;
                    SalesLine.SetRange("Document No.", Packaging."Source No.");
                    SalesLine.SetRange(Type, SalesLine.Type::Item);
                    SalesLine.SetRange("No.", "Item No.");
                    SalesLine.FindSet;
                    "Source Line No." := SalesLine."Line No.";
                    Validate("Unit of Measure Code", SalesLine."Unit of Measure Code");
                    Validate("Qty. per Unit of Measure", SalesLine."Qty. per Unit of Measure");
                end;
                //ELSE
                //  ERROR('Opción no contemplada - Por favor póngase en contacto con el administrador del sistema');
                //END;
                //END;
            end;
        }
        field(10; Quantity; Decimal)
        {
            Caption = 'Cantidad';

            trigger OnValidate()
            begin
                "Qty. (Base)" := CalcBaseQty(Quantity);
            end;
        }
        field(11; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Cód. Ud. Medida';
            Editable = true;
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(12; "Qty. (Base)"; Decimal)
        {
            Caption = 'Cdad. (Base)';

            trigger OnValidate()
            begin
                TestField("Qty. per Unit of Measure", 1);
                Validate(Quantity, "Qty. (Base)");
            end;
        }
        field(13; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(14; "No Ped SSCC"; Code[20])
        {
        }
        field(15; "No Alb SSCC"; Code[20])
        {
        }
        field(16; "Shipment Posting Date"; Date)
        {
            Caption = 'Fecha registro envío';
        }
        field(17; "Destination Type"; Option)
        {
            Caption = 'Destination Type';
            Editable = true;
            OptionCaption = ' ,Customer,Vendor,Location';
            OptionMembers = " ",Customer,Vendor,Location;
        }
        field(18; "Destination No."; Code[20])
        {
            Caption = 'Destination No.';
            Editable = true;
            TableRelation = if ("Destination Type" = const(Customer)) Customer."No."
            else if ("Destination Type" = const(Vendor)) Vendor."No."
            else if ("Destination Type" = const(Location)) Location.Code;

            trigger OnValidate()
            begin
                GetDestinationName;
            end;
        }
        field(19; "Destination Name"; Text[80])
        {
            Caption = 'Nombre destino';
        }
        field(20; "Whse. Shipment No."; Code[20])
        {
            Caption = 'No. envío almacén';
        }
        field(21; "Posted Whse. Shipment No."; Code[20])
        {
            Caption = 'No. envío almacén reg.';
            TableRelation = "Posted Whse. Shipment Header"."No.";
        }
        field(76; "Caja Picking"; Code[20])
        {
        }
        field(77; Roadmap; Code[20])
        {
            CalcFormula = lookup(Packaging.Roadmap where("No." = field("No.")));
            Caption = 'Roadmap';
            Editable = false;
            FieldClass = FlowField;
        }
        field(78; "Creation Date"; date)
        {
            CalcFormula = Lookup(Packaging."Creation Date" WHERE("No." = FIELD("No.")));
            Caption = 'Creation date';
            Editable = true;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key1; "No.", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
    trigger OnDelete()
    begin
        // GetHeader;
        // Packaging.TESTFIELD("Posted Source No.",'');
    end;

    trigger OnInsert()
    var
        PackagingLine: Record "Packaging Line";
    begin
        // GetHeader;
        // Packaging.TESTFIELD("No.");
        //
        // PackagingLine.RESET;
        // PackagingLine.SETRANGE("No.","No.");
        // IF PackagingLine.FINDLAST THEN;
        //
        // "Line No." := PackagingLine."Line No."+10000;
    end;

    trigger OnModify()
    begin
        // GetHeader;
        // Packaging.TESTFIELD("Posted Source No.",'');
    end;

    trigger OnRename()
    begin
        // GetHeader;
        // Packaging.TESTFIELD("Posted Source No.",'');
    end;

    var
        Packaging: Record Packaging;

    local procedure GetDestinationName()
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        Location: Record Location;
    begin
        if "Destination No." = '' then exit;
        case "Destination Type" of
            "destination type"::Customer:
                begin
                    Customer.Reset;
                    Customer.Get("Destination No.");
                    "Destination Name" := Customer.Name;
                end;
            "destination type"::Location:
                begin
                    Location.Reset;
                    Location.Get("Destination No.");
                    "Destination Name" := Location.Name;
                end;
            "destination type"::Vendor:
                begin
                    Vendor.Reset;
                    Vendor.Get("Destination No.");
                    "Destination Name" := Vendor.Name;
                end;
        end;
    end;

    local procedure GetHeader()
    begin
        Packaging.Reset;
        if "No." = '' then Error('Debe informar del número de embalaje antes de continuar');
        Packaging.Get("No.");
    end;

    local procedure CalcBaseQty(Qty: Decimal): Decimal
    begin
        TestField("Qty. per Unit of Measure");
        exit(ROUND(Qty * "Qty. per Unit of Measure", 0.00001));
    end;

    procedure CalcSourceDocQty() SourceDocQty: Decimal
    var
        SalesLine: Record "Sales Line";
    begin
        GetHeader;
        CalcFields("Source Type", "Source No.");
        if "Item No." = '' then
            SourceDocQty := 0
        else begin
            case Packaging."Source Type" of
                Database::"Sales Line":
                    begin
                        SalesLine.Reset;
                        SalesLine.SetRange("Document No.", Packaging."Source No.");
                        SalesLine.SetRange(Type, SalesLine.Type::Item);
                        SalesLine.SetRange("No.", "Item No.");
                        SalesLine.CalcSums("Qty. to Ship");
                        SourceDocQty := SalesLine."Qty. to Ship";
                    end;
                else
                    Error('Opción no contemplada - Póngase en contacto con el administrador del sistema');
            end;
        end;
    end;

    procedure CalcPackedQty() PackedQty: Decimal
    var
        PackagingLine: Record "Packaging Line";
    begin
        PackedQty := 0;
        if "Source Line No." = 0 then exit;
        CalcFields("Source Type", "Source No.");
        PackagingLine.Reset;
        PackagingLine.SetRange("Source Type", "Source Type");
        PackagingLine.SetRange("Source No.", "Source No.");
        PackagingLine.SetRange("Source Line No.", "Source Line No.");
        PackagingLine.SetRange("Posted Source No.", '');
        PackagingLine.CalcSums(Quantity);
        PackedQty := PackagingLine.Quantity;
    end;
}
