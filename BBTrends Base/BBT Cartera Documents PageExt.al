PageExtension 50240 "BBT Cartera Documents" extends "Cartera Documents"
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
