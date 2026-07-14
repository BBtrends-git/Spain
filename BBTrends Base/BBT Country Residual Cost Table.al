table 50065 "BBT Country Residual Cost"
{
    Caption = 'Country Residual Cost', Comment = 'ESP="Coste residual por pais"';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Residue Code"; Code[20])
        {
            Caption = 'Residue Code', Comment = 'ESP="Cód. residuo"';
            TableRelation = "BBT Residues";
            Editable = false;
        }
        field(2; Country; Code[10])
        {
            Caption = 'Country', Comment = 'ESP="País"';
            TableRelation = "Country/Region";
        }
        field(3; Cost; Decimal)
        {
            Caption = 'Cost', Comment = 'ESP="Coste"';
            DecimalPlaces = 6;
        }
        field(4; Currency; Code[10])
        {
            Caption = 'Currency', Comment = 'ESP="Divisa"';
            TableRelation = Currency;
        }
    }
    keys
    {
        key(PK; "Residue Code", Country, Currency)
        {
            Clustered = true;
        }
    }
}
