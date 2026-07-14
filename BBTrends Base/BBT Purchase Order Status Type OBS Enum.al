enum 50010 "BBT Import Order Status Type"
{
    ObsoleteState = Pending;

    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', comment = 'ESP=" "';
    }
    value(1; Lines)
    {
        Caption = 'Lines', comment = 'ESP="Líneas"';
    }
    value(2; "CDI Management")
    {
        Caption = 'CDI Management', comment = 'ESP="Gestión CDIs"';
    }
}
