PageExtension 50246 "BBT Receiv Closed Cartera Docs" extends "Receivable Closed Cartera Docs"
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
