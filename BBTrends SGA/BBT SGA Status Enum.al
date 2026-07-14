enum 51451 "SGA Status"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Comment = 'ESP=" "';
    }
    value(1; "SGA Sent")
    {
        Caption = 'SGA Sent', Comment = 'ESP="SGA Enviado"';
    }
    value(2; "SGA Locked")
    {
        Caption = 'SGA Locked', Comment = 'ESP="SGA Bloqueado"';
    }
}