PageExtension 50243 "BBT Posted Cartera Documents" extends "Posted Cartera Documents"
{
    layout
    {
        addafter("Account No.")
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
