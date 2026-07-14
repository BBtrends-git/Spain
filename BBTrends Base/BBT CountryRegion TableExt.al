TableExtension 50104 "BBT CountryRegion" extends "Country/Region"
{
    fields
    {
        field(50000; "Country Origin on Sales Docs"; Boolean)
        {
        }
        field(50001; "Tariff Code on Sales Docs"; Boolean)
        {
        }
        field(50002; "Export Name"; Text[50])
        {
            Caption = 'Export Name';
        }
        field(50003; "Scrap Information"; Boolean)
        {
            Caption = 'Scrap Information', Comment = 'ESP="Información scrap"';
        }
    }
}
