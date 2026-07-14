Table 50006 "Act Pedido Compra"
{
    ObsoleteState = Removed;

    fields
    {
        field(1; Id; Integer)
        {
            Description = 'Secuencial';
        }
        field(2; PedCompra; Code[20])
        { }
        field(3; Item; Code[20])
        { }
        field(4; CtdPedido; Integer)
        { }
        field(5; CtdPendiente; Integer)
        { }
    }
    keys
    {
        key(Key1; Id)
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }
}
