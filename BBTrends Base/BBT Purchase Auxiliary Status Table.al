table 51106 "BBT Purchase Auxiliary Status"
{
    Caption = 'Auxiliary Purchase Statuses', comment = 'ESP="Tabla Auxiliar Estados"';
    LookupPageId = "BBT Auxiliary Table States";
    DrillDownPageId = "BBT Auxiliary Table States";

    fields
    {
        field(1; "BBT Type"; Enum "BBT States Auxiliary Table")
        {
            Caption = 'Type', comment = 'ESP="Tipo"';
        }
        field(2; "BBT Code"; Code[20])
        {
            Caption = 'Code', comment = 'ESP="Código"';
        }
        field(3; "BBT Description"; Text[250])
        {
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
    }
    keys
    {
        key(PK; "BBT Type", "BBT Code")
        {
            Clustered = true;
        }
    }
}