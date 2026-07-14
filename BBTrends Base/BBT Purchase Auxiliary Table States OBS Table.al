table 50055 "BBT Auxiliary Table States"
{
    //>> ESTA TABLA NO SE USA. LA BUENA ES LA 51106-BBT Purchase Auxiliary Status
    ObsoleteState = Pending;
    //<<
    Caption = 'Auxiliary Table States', comment = 'ESP="Tabla auxiliar estados"';
    //LookupPageId = "BBT Auxiliary Table States";
    //DrillDownPageId = "BBT Auxiliary Table States";

    fields
    {
        field(1; "BBT No."; Code[20])
        {
            Caption = 'No.', comment = 'ESP="Nº"';
            DataClassification = ToBeClassified;
        }
        field(2; "BBT Type"; Enum "BBT States Auxiliary Table")
        {
            Caption = 'Type', comment = 'ESP="Tipo"';
            DataClassification = ToBeClassified;
        }
        field(3; "BBT Description"; Text[250])
        {
            Caption = 'Description', comment = 'ESP="Descripción"';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "BBT No.")
        {
            Clustered = true;
        }
        key(BBT1; "BBT Type")
        { }
    }
}
