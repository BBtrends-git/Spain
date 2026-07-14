Table 50018 "Cond APos"
{
    ObsoleteState = Pending;

    //>> BBT. 16/03/2026. Implantación de la extensión SMG.
    /*
    DrillDownPageID = "Condiciones APos";
    LookupPageID = "Condiciones APos";
    */
    //<<

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.', comment = 'ESP="Nº mov."';
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code', comment = 'ESP="Código"';
            NotBlank = true;
            TableRelation = if (Plataforma = const(true)) "SMG Customer Classification".Code
            else if (Plataforma = const(false)) Customer."No.";
            ValidateTableRelation = false;
        }
        field(3; "Condiciones fuera fact. % APOS"; Decimal)
        {
            Editable = true;
            MaxValue = 100;
            MinValue = 0;
        }
        field(4; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code', Comment = 'ESP="Cód. dimensión global 2"';
            NotBlank = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(5; Plataforma; Boolean)
        { }
        field(6; Periodicity; Enum "BBT Periodicity")
        {
            Caption = 'Periodicity', Comment = 'ESP="Periodicidad"';
        }
        field(51136; "APOs Comment"; Text[1024])
        {
            Caption = 'APOs Comment', Comment = 'ESP="Comentario APOs"';
            Editable = true;
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        { }
        key(Key2; "Global Dimension 2 Code", "Entry No.", "Condiciones fuera fact. % APOS")
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }
}
