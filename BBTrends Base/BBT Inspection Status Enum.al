enum 50007 "BBT Inspection Status"
{
    Extensible = true;
    Caption = 'Inspection Status', comment = 'ESP="Estado inspección"';

    value(0; "Complete pending inspection")
    {
        Caption = 'Complete pending inspection', comment = 'ESP="Terminado pendiente inspección"';
    }
    value(1; "Accepted pending shipment")
    {
        Caption = 'Accepted pending shipment', comment = 'ESP="Aceptado pendiente embarque"';
    }
    value(2; Refused)
    {
        Caption = 'Refused', comment = 'ESP="Rechazado"';
    }
    value(3; "Pending rework")
    {
        Caption = 'Pending rework', comment = 'ESP="Pendiente retrabajo"';
    }
}
