table 51200 "RMAs Setup"
{
    Caption = 'RMAs Setup', Comment = 'ESP="RMA Configuración"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            AllowInCustomizations = Never;
            Caption = 'Primary Key';
        }
        field(2; "EAN13 Unit"; Code[20])
        {
            Caption = 'EAN13 Unit', Comment = 'ESP="Unidad del EAN13"';
            TableRelation = "Unit of Measure";
        }
        field(3; "Resource Group"; Code[20])
        {
            Caption = 'Resource Group', Comment = 'ESP="Grupo de Recurso"';
            TableRelation = "Resource Group"."No.";
        }
        field(4; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name', Comment = 'ESP="Libro Diario Producto"';
            TableRelation = "Item Journal Template".Name where("Page ID" = const(40), Recurring = const(false), Type = const(Item));
        }
        field(5; "Journal Batch Name"; Code[20])
        {
            Caption = 'Journal Batch Name', Comment = 'ESP="Sección Diario Producto"';
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
        field(6; "Warehouse Quality A"; Code[10])
        {
            Caption = 'Warehouse Quality A', Comment = 'ESP="Almacén Calidad A"';
            TableRelation = Location.code where("Use As In-Transit" = const(false));
        }
        field(7; "Warehouse Quality B"; Code[10])
        {
            Caption = 'Warehouse Quality B', Comment = 'ESP="Almacén Calidad B"';
            TableRelation = Location.Code where("Use As In-Transit" = const(false));
        }
        field(8; "Warehouse Quality C"; Code[10])
        {
            Caption = 'Warehouse Quality C', Comment = 'ESP="Almacén Calidad C"';
            TableRelation = Location.Code where("Use As In-Transit" = const(false));
        }
        field(9; "Returns Warehouse"; Code[10])
        {
            Caption = 'Returns Warehouse', Comment = 'ESP="Almacén Devoluciones"';
            TableRelation = Location.Code where("Use As In-Transit" = const(false));
        }
        field(10; "Scrap Adjust"; Boolean)
        {
            Caption = 'Scrap Adjust', Comment = 'ESP="Ajuste Chatarra"';
        }
        field(11; "Return Series"; code[20])
        {
            Caption = 'Return Series', Comment = 'ESP="Serie Devolución"';
            TableRelation = "No. Series".Code;
        }
        field(12; "Adjustments Without Returns"; Boolean)
        {
            Caption = 'Adjustments without Sales Returns', Comment = 'ESP="Regularización sin Devolución"';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}