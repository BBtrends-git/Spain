PageExtension 50264 "BBT Released Prod. Order Lines" extends "Released Prod. Order Lines"
{
    layout
    {
        addfirst(Control1)
        {
            field("Prod. Order No."; Rec."Prod. Order No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Item No.")
        {
            field("Item Tracking Code"; Rec."Item Tracking Code")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
        }
    }
    actions
    {
        addafter(ProductionJournal)
        {
            action(ActualizarLinea)
            {
                ApplicationArea = Basic;
                Caption = 'Actualizar Línea';
                Image = "Action";

                trigger OnAction()
                var
                    Item: Record Item;
                    ProdOrderLine: Record "Prod. Order Line";
                    ProdOrderRtngLine: Record "Prod. Order Routing Line";
                    ProdOrderComp: Record "Prod. Order Component";
                    Family: Record Family;
                    ProdOrder: Record "Production Order";
                    ProdOrderStatusMgt: Codeunit "Prod. Order Status Management";
                    RoutingNo: Code[20];
                    ErrorOccured: Boolean;
                    CalcProdOrder: Codeunit "BBT Calculate Product Order";
                    Direction: Option Forward,Backward;
                begin
                    //I DAGA
                    if Confirm('Esta seguro que quiere actualizar la linea?') then begin
                        if Rec.Status <> Rec.Status::Released then Error('La orden debe estar en estado lanzada');
                        if Rec."Finished Quantity" <> 0 then Error('Cantidad terminada debe ser 0');
                        ProdOrderRtngLine.SetRange(Status, Rec.Status);
                        ProdOrderRtngLine.SetRange("Prod. Order No.", Rec."Prod. Order No.");
                        ProdOrderRtngLine.SetRange("Routing Reference No.", Rec."Routing Reference No.");
                        ProdOrderRtngLine.SetRange("Routing No.", Rec."Routing No.");
                        ProdOrderRtngLine.DeleteAll;
                        /*
                        IF ProdOrderRtngLine.FINDSET(TRUE) THEN
                          REPEAT
                             ProdOrderRtngLine.SetSkipUpdateOfCompBinCodes(TRUE);
                              ProdOrderRtngLine.DELETE(true);
                          UNTIL ProdOrderRtngLine.NEXT = 0;
                         */
                        ProdOrderComp.SetRange(Status, Rec.Status);
                        ProdOrderComp.SetRange("Prod. Order No.", Rec."Prod. Order No.");
                        ProdOrderComp.SetRange("Prod. Order Line No.", Rec."Line No.");
                        ProdOrderComp.DeleteAll();
                        Direction := Direction::Backward;
                        if not CalcProdOrder.Calculate2(Rec, Direction, true, true, false, false) then ErrorOccured := true;
                        Message('Se ha actualizado la linea de %1', Format(Rec.Quantity));
                    end;
                    //F DAGA
                end;
            }
        }
    }
}
