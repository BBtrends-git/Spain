table 50061 "BBT Depreciation Range"
{
    Caption = 'Depreciation Range', Comment = 'ESP="Rango depreciación"';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Depreciation Days"; Integer)
        {
            Caption = 'Depreciation Days', Comment = 'ESP="Días depreciación"';
        }
        field(2; "% Depreciation"; Decimal)
        {
            Caption = '% Depreciation', Comment = 'ESP="% depreciación"';
        }
    }
    keys
    {
        key(PK; "Depreciation Days")
        {
            Clustered = true;
        }
    }
}
