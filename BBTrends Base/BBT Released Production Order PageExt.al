PageExtension 50263 "BBT Released Production Order" extends "Released Production Order"
{
    layout
    {
        modify("Location Code")
        {
            Visible = false;
        }
        addafter("Due Date")
        {
            field("Location Components Code"; Rec."Location Components Code")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Last Date Modified")
        {
            field("Routing No."; Rec."Routing No.")
            {
                ApplicationArea = Basic;
            }
            field("Cantidad terminada"; Rec."Cantidad terminada")
            {
                ApplicationArea = Basic;
            }
            field("Cód. Pedido"; Rec."Cód. Pedido")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
