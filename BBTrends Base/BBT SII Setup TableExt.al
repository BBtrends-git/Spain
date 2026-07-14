tableextension 50002 "BBT SII Setup" extends "SII Setup"
{
    fields
    {
        field(50000; "Country/Region Code Not Send"; Code[10])
        {
            Caption = 'Country/Region Code Not Send To SII', Comment = 'ESP="Cód. país/región que no envía al SII"';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region".Code;
            ObsoleteState = Removed;
            ObsoleteReason = 'Se deshabilita el desarrollo a petición de BBTrends 16/06/2023';
        }
    }
}
