PageExtension 50239 "BBT Payables Cartera Docs" extends "Payables Cartera Docs"
{
    layout
    {
        addafter(Place)
        {
            field("Nombre Proveedor"; Rec."Nombre Proveedor")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
