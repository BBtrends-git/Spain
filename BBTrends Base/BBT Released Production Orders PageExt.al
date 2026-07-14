PageExtension 50232 "BBT Released Production Orders" extends "Released Production Orders"
{
    layout
    {
        modify("Location Code")
        {
            Visible = true;
        }
        addafter("Routing No.")
        {
            field("Item Tracking Code"; Rec."Item Tracking Code")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Quantity)
        {
            field("Cantidad terminada"; Rec."Cantidad terminada")
            {
                ApplicationArea = Basic;
                DecimalPlaces = 0 : 5;
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
        addafter("Bin Code")
        {
            field("Scrap Quantity"; Rec."Scrap Quantity")
            {
                ApplicationArea = Basic;
            }
            field("Cód. Pedido"; Rec."Cód. Pedido")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        addafter("Change &Status")
        {
            action("Cambiar Estado Selec")
            {
                ApplicationArea = Basic;
                Caption = 'Change &Status';
                Ellipsis = true;
                Image = ChangeStatus;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    cProdOrderStatus: Codeunit "Prod. Order Status Management";
                    ProdOrder: Record "Production Order";
                begin
                    // FHS
                    CurrPage.SetSelectionFilter(ProdOrder);
                    if ProdOrder.FindFirst then
                        repeat
                            cProdOrderStatus.Run(ProdOrder);
                        until ProdOrder.Next = 0;
                end;
            }
        }
    }
}
