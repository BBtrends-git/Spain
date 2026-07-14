PageExtension 50244 "BBT Closed Cartera Documents" extends "Closed Cartera Documents"
{
    layout
    {
        addafter(Place)
        {
            field("Nombre Cliente"; Rec."Nombre Cliente")
            {
                ApplicationArea = Basic;
            }
            field("Nombre Proveedor"; Rec."Nombre Proveedor")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
