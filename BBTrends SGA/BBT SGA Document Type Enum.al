enum 51452 "SGA Document Type"
{
    Extensible = true;

    value(0; "Sales")
    {
        Caption = 'Sales', Comment = 'ESP="Ventas"';
    }
    value(1; "Purchase")
    {
        Caption = 'Purchase', Comment = 'ESP="Compras"';
    }
    value(2; "Transfer")
    {
        Caption = 'Transfer', Comment = 'ESP="Transferencia"';
    }
    value(3; "Sales Return")
    {
        Caption = 'Sales Return', Comment = 'ESP="Devolución Ventas"';
    }
    value(4; "Purchase Return")
    {
        Caption = 'Purchase Return', Comment = 'ESP="Devolución Compras"';
    }
}