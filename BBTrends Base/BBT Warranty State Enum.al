enum 50005 "BBT Warranty State"
{
    Caption = 'Warranty State', comment = 'ESP="Estado Garantía"';
    Extensible = true;

    value(10; "Active")
    {
    Caption = 'Active', comment = 'ESP="Activa"';
    }
    value(20; "Inactive")
    {
    Caption = 'Inactive', comment = 'ESP="Inactiva"';
    }
}
