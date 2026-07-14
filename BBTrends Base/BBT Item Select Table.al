Table 50042 "Item Select"
{
    ObsoleteState = Removed;        // BBT 01/07/2025. PRECINTIA

    fields
    {
        field(1; "Item No."; Code[20])
        {
        }
        field(2; Description; Text[150])
        {
        }
        field(3; "Item Tracking Code"; Code[10])
        {
            Caption = 'Item Tracking Code';
            TableRelation = "Item Tracking Code";
        }
        field(4; "Lot Nos."; Code[10])
        {
            Caption = 'Lot Nos.';
            TableRelation = "No. Series" where("Serie Producto" = const(true));
        }
        field(5; "Drawing Part No."; Text[50])
        {
            Caption = 'Drawing Part No.';
            Description = 'PRP-001';
        }
        field(6; Embolsado; Boolean)
        {
        }
        field(7; "Unidades Bolsa"; Integer)
        {
        }
        field(8; "Num. Cintas"; Integer)
        {
        }
        field(9; Color; Text[100])
        {
            //>> BBT. PRECINTIA. Tabla Obsoleta
            //TableRelation = "Atributos basicos".Valor where(Atributo = const(Color));
            //<<
        }
        field(10; "Tecnología Impresión"; Text[100])
        {
            //>> BBT. PRECINTIA. Tabla Obsoleta
            //TableRelation = "Atributos basicos".Valor where(Atributo = const("Tecnología Impresión"));
            //<<
        }
        field(11; Material; Text[100])
        {
            //>> BBT. PRECINTIA. Tabla Obsoleta
            //TableRelation = "Atributos basicos".Valor where(Atributo = const(Material));
            //<<
        }
        field(12; "Generic Item"; Boolean)
        {
            Caption = 'Generic Item';
        }
    }
    keys
    {
        key(Key1; "Item No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
}
