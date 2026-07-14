PageExtension 50247 "BBT Payab Clos. Cartera Docs" extends "Payable Closed Cartera Docs"
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
