TableExtension 50136 "BBT Reason Code" extends "Reason Code"
{
    fields
    {
        field(50000; "CS - Create Sales Return Order"; Boolean)
        {
            Caption = 'SC - Crear devolución venta';
        }
        field(50001; "CS - Create Sales Order"; Boolean)
        {
            Caption = 'SC - Crear pedido venta';
        }
        field(50004; "Service Type"; Option)
        {
            Caption = 'Resolución';
            OptionCaption = ' ,Devolución,Cambio,,Cupón,Abono portes';
            OptionMembers = " ", Return, Sale, Replate, Coupon, "Credit Freight";
        }
    }
}
