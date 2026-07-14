Codeunit 50004 "Output Jnl.-Expl. last Route"
{
    Permissions = TableData "Item Journal Line" = imd,
        TableData "Prod. Order Line" = r,
        TableData "Prod. Order Routing Line" = r;
    TableNo = "Item Journal Line";

    trigger OnRun()
    var
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
        ItemJnlLine: Record "Item Journal Line";
        //>> BBT. Codeunit Obsoleta:  "Cost Calculation Management"
        //CostCalcMgt: Codeunit "Cost Calculation Management";
        CostCalcMgt: Codeunit "Mfg. Cost Calculation Mgt.";
        //<<
        ItemJnlLineReserve: Codeunit "Item Jnl. Line-Reserve";
        NextLineNo: Integer;
        LineSpacing: Integer;
        BaseQtyToPost: Decimal;
    begin
        if (rec."Order Type" <> rec."order type"::Production) or (rec."Order No." = '') then exit;
        if not ItemJnlLineReserve.DeleteLineConfirm(Rec) then exit;
        ProdOrderLine.Reset;
        ProdOrderLine.SetRange(Status, ProdOrderLine.Status::Released);
        ProdOrderLine.SetRange("Prod. Order No.", Rec."Order No.");
        if Rec."Order Line No." <> 0 then ProdOrderLine.SetRange("Line No.", Rec."Order Line No.");
        if Rec."Item No." <> '' then ProdOrderLine.SetRange("Item No.", Rec."Item No.");
        if Rec."Routing Reference No." <> 0 then ProdOrderLine.SetRange("Routing Reference No.", Rec."Routing Reference No.");
        if Rec."Routing No." <> '' then ProdOrderLine.SetRange("Routing No.", Rec."Routing No.");
        ProdOrderRtngLine.SetRange(Status, ProdOrderRtngLine.Status::Released);
        ProdOrderRtngLine.SetRange("Prod. Order No.", Rec."Order No.");
        if Rec."Operation No." <> '' then ProdOrderRtngLine.SetRange("Operation No.", Rec."Operation No.");
        ProdOrderRtngLine.SetFilter("Routing Status", '<> %1', ProdOrderRtngLine."routing status"::Finished);
        ProdOrderRtngLine.SetRange("Flushing Method", ProdOrderRtngLine."flushing method"::Manual);
        // Solo despliega última linea de la ruta
        ProdOrderRtngLine.SetRange("Next Operation No.", '');
        // Clear fields in xRec to ensure that validation code regarding dimensions is executed:
        Rec."Order Line No." := 0;
        Rec."Item No." := '';
        Rec."Routing Reference No." := 0;
        Rec."Routing No." := '';
        ItemJnlLine := Rec;
        ItemJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        ItemJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        if ItemJnlLine.Find('>') then begin
            LineSpacing := (ItemJnlLine."Line No." - Rec."Line No.") DIV (1 + ProdOrderLine.Count * ProdOrderRtngLine.Count);
            if LineSpacing = 0 then Error(Text000);
        end
        else
            LineSpacing := 10000;
        NextLineNo := Rec."Line No.";
        if not ProdOrderLine.Find('-') then Error(Text001);
        repeat
            ProdOrderRtngLine.SetRange("Routing No.", ProdOrderLine."Routing No.");
            ProdOrderRtngLine.SetRange("Routing Reference No.", ProdOrderLine."Routing Reference No.");
            if ProdOrderRtngLine.Find('-') then begin
                repeat
                    BaseQtyToPost := CostCalcMgt.CalcQtyAdjdForRoutingScrap(ProdOrderLine."Quantity (Base)", ProdOrderRtngLine."Scrap Factor % (Accumulated)", ProdOrderRtngLine."Fixed Scrap Qty. (Accum.)") - CostCalcMgt.CalcActOutputQtyBase(ProdOrderLine, ProdOrderRtngLine);
                    if BaseQtyToPost > 0 then begin
                        InsertOutputJnlLine(Rec, NextLineNo, LineSpacing, ProdOrderLine."Line No.", ProdOrderLine."Item No.", ProdOrderLine."Variant Code", ProdOrderLine."Location Code", ProdOrderLine."Bin Code", ProdOrderLine."Routing No.", ProdOrderLine."Routing Reference No.", ProdOrderRtngLine."Operation No.", ProdOrderLine."Unit of Measure Code", BaseQtyToPost / ProdOrderLine."Qty. per Unit of Measure", (ProdOrderRtngLine."Next Operation No." = ''));
                        if ProdOrderRtngLine."Next Operation No." = '' then ItemTrackingMgt.CopyItemTracking(ProdOrderLine.RowID1, LastItemJnlLine.RowID1, false);
                    end;
                until ProdOrderRtngLine.Next = 0;
            end
            else if ProdOrderLine."Remaining Quantity" > 0 then begin
                InsertOutputJnlLine(Rec, NextLineNo, LineSpacing, ProdOrderLine."Line No.", ProdOrderLine."Item No.", ProdOrderLine."Variant Code", ProdOrderLine."Location Code", ProdOrderLine."Bin Code", ProdOrderLine."Routing No.", ProdOrderLine."Routing Reference No.", '', ProdOrderLine."Unit of Measure Code", ProdOrderLine."Remaining Quantity", true);
                ItemTrackingMgt.CopyItemTracking(ProdOrderLine.RowID1, LastItemJnlLine.RowID1, false);
            end;
        until ProdOrderLine.Next = 0;
        ItemJnlLineReserve.DeleteLine(Rec);
        Rec.Delete;
    end;

    var
        Text000: label 'There are not enough free line numbers to explode the route.';
        Text001: label 'There is nothing to explode.';
        LastItemJnlLine: Record "Item Journal Line";
        ItemTrackingMgt: Codeunit "Item Tracking Management";

    local procedure InsertOutputJnlLine(ItemJnlLine: Record "Item Journal Line"; var NextLineNo: Integer; LineSpacing: Integer; ProdOrderLineNo: Integer; ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]; BinCode: Code[20]; RoutingNo: Code[20]; RoutingRefNo: Integer; OperationNo: Code[10]; UnitOfMeasureCode: Code[10]; QtyToPost: Decimal; LastOperation: Boolean)
    begin
        NextLineNo := NextLineNo + LineSpacing;
        ItemJnlLine."Line No." := NextLineNo;
        ItemJnlLine.Validate("Entry Type", ItemJnlLine."entry type"::Output);
        ItemJnlLine.Validate("Order Line No.", ProdOrderLineNo);
        ItemJnlLine.Validate("Item No.", ItemNo);
        ItemJnlLine.Validate("Variant Code", VariantCode);
        ItemJnlLine.Validate("Location Code", LocationCode);
        if BinCode <> '' then ItemJnlLine.Validate("Bin Code", BinCode);
        ItemJnlLine.Validate("Routing No.", RoutingNo);
        ItemJnlLine.Validate("Routing Reference No.", RoutingRefNo);
        ItemJnlLine.Validate("Operation No.", OperationNo);
        ItemJnlLine.Validate("Unit of Measure Code", UnitOfMeasureCode);
        ItemJnlLine.Validate("Setup Time", 0);
        ItemJnlLine.Validate("Run Time", 0);
        if (LocationCode <> '') and LastOperation then ItemJnlLine.CheckWhse(LocationCode, QtyToPost);
        if ItemJnlLine.SubcontractingWorkCenterUsed then
            ItemJnlLine.Validate("Output Quantity", 0)
        else
            ItemJnlLine.Validate("Output Quantity", QtyToPost);
        ItemJnlLine.Insert;
        LastItemJnlLine := ItemJnlLine;
    end;
}
