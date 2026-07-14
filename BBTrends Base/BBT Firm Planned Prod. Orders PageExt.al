PageExtension 50231 "BBT Firm Planned Prod. Orders" extends "Firm Planned Prod. Orders"
{
    layout
    {
        addafter(Quantity)
        {
            field("Cód. Pedido"; Rec."Cód. Pedido")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Location Code")
        {
            field("Location Components Code"; Rec."Location Components Code")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
    }
}
