enum 50001 "EDI Direction"
{
    Extensible = true;

    value(0; " ")
    { }
    value(1; Inbound)
    {
        Caption = 'Inbound', comment = 'ESP="Entrada"';
    }
    value(2; Outbound)
    {
        Caption = 'Outbound', comment = 'ESP="Salida"';
    }
}
