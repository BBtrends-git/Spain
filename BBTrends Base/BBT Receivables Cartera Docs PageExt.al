PageExtension 50238 "BBT Receivables Cartera Docs" extends "Receivables Cartera Docs"
{
    layout
    {
        addafter(Place)
        {
            field("Nombre Cliente"; Rec."Nombre Cliente")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
