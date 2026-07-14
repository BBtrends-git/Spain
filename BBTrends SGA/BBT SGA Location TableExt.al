TableExtension 51450 "SGA Location" extends Location
{
    fields
    {
        field(51450; "SGA Enabled"; Boolean)
        {
            Caption = 'SGA Enabled', Comment = 'ESP="Activado"';
        }
        field(51451; "SGA Warehouse Code"; Code[10])
        {
            Caption = 'SGA Warehouse Code', Comment = 'ESP="Código Almacén"';
        }
        field(51452; "SGA Quality"; Boolean)
        {
            Caption = 'SGA Quality', Comment = 'ESP="Calidad"';
        }
        field(51453; "SGA Fictitious Movement"; Boolean)
        {
            Caption = 'SGA Fictitious Movement', Comment = 'ESP="Mov. Ficticio"';
        }
        field(51454; "SGA Allows returns"; Boolean)
        {
            Caption = 'SGA Allows Returns', Comment = 'ESP="Permite Devolución"';
        }
    }
}