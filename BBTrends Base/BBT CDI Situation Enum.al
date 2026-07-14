enum 50003 "CDI Situation"
{
    Extensible = true;

    value(0; "Pending opening")
    {
        Caption = 'Pending opening', comment = 'ESP="Pendiente apertura"';
    }
    value(1; "Pending documents")
    {
        Caption = 'Pending documents', comment = 'ESP="Pendiente documentos"';
    }
    value(2; "Pending expiration")
    {
        Caption = 'Pending expiration', comment = 'ESP="Pendiente vencimiento"';
    }
    value(3; "Pending acceptance")
    {
        Caption = 'Pending acceptance', comment = 'ESP="Pendiente aceptación"';
    }
    value(4; "Finan CDI")
    {
        Caption = 'Finan CDI', Comment = 'ESP="Finan CDI"';
    }
    value(5; Paid)
    {
        Caption = 'Paid', comment = 'ESP="Pagada"';
    }
    value(6; Cancelled)
    {
        Caption = 'Cancelled', Comment = 'ESP="Cancelada"';
    }
}
