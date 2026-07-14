table 50000 "Customer Classification"
{
    Caption = 'Customer Classification', comment = 'ESP="Clasificación Cliente"';
    DataCaptionFields = "Code", Description;
    //>> BBT. 16/03/2026. Implantación de la extensión SMG.
    ObsoleteState = Pending;
    //<<
    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type', comment = 'ESP="Tipo"';
            OptionCaption = 'National Group,Platform,Customer Type', comment = 'ESP="Grupo Nacional,Plataforma,Tipo cliente"';
            OptionMembers = "National Group",Platform,"Customer Type";
        }
        field(2; "Code"; Code[10])
        {
            Caption = 'Code', comment = 'ESP="Código"';
            NotBlank = true;
        }
        field(3; Description; Text[30])
        {
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
        field(4; "Condiciones fuera fact. % APOS"; Decimal)
        {
            MaxValue = 100;
            MinValue = 0;
        }
        field(5; "Condiciones fuera fact. % COLS"; Decimal)
        {
            MaxValue = 100;
            MinValue = 0;
        }
    }
    keys
    {
        key(Key1; Type, "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description)
        { }
    }
}
