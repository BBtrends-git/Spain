codeunit 50038 "Prod Order Events"
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Management", 'OnBeforeChangeStatusOnProdOrder', '', false, true)]
    local procedure "Prod. Order Status Management_OnBeforeChangeStatusOnProdOrder"(var ProductionOrder: Record "Production Order"; NewStatus: Option; var IsHandled: Boolean; NewPostingDate: Date; NewUpdateUnitCost: Boolean)
    begin
        varNewStatus := Enum::"Production Order Status".FromInteger(NewStatus);
    end;

    [EventSubscriber(ObjectType::codeunit, codeunit::"Prod. Order Status Management", 'OnAfterToProdOrderLineModify', '', false, false)]
    local procedure OnAfterToProdOrderLineModify(FromProdOrderLine: Record "Prod. Order Line"; var ToProdOrderLine: Record "Prod. Order Line"; var NewStatus: Option Released)
    begin
        IF NewStatus = NewStatus::Released THEN BEGIN
            ToProdOrderLine."Planning Flexibility" := ToProdOrderLine."Planning Flexibility"::None;
        END;
    end;

    [EventSubscriber(ObjectType::codeunit, codeunit::"Prod. Order Status Management", 'OnBeforeMatrOrCapConsumpExists', '', false, false)]
    local procedure OnBeforeMatrOrCapConsumpExists(ProdOrderLine: Record "Prod. Order Line"; var EntriesExist: Boolean; var IsHandled: Boolean)
    var
        rManufacturingSetup: Record "Manufacturing Setup";
        ItemLedgEntry: Record "Item Ledger Entry";
        CapLedgEntry: Record "Capacity Ledger Entry";
    begin
        IsHandled := true;
        ItemLedgEntry.SETCURRENTKEY("Order Type", "Order No.", "Order Line No.");
        ItemLedgEntry.SETRANGE("Order Type", ItemLedgEntry."Order Type"::Production);
        ItemLedgEntry.SETRANGE("Order No.", ProdOrderLine."Prod. Order No.");
        ItemLedgEntry.SETRANGE("Order Line No.", ProdOrderLine."Line No.");
        ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Consumption);
        //>> SDA.2022/06/14
        //IF ItemLedgEntry.FINDFIRST THEN
        //  EXIT(TRUE);
        IF ItemLedgEntry.FINDFIRST THEN BEGIN
            ItemLedgEntry.CALCSUMS(Quantity);
            IF ItemLedgEntry.Quantity <> 0 THEN EntriesExist := TRUE;
        END;
        //<<
        CapLedgEntry.SETCURRENTKEY("Order Type", "Order No.", "Order Line No.", "Routing No.", "Routing Reference No.");
        CapLedgEntry.SETRANGE("Order Type", CapLedgEntry."Order Type"::Production);
        CapLedgEntry.SETRANGE("Order No.", ProdOrderLine."Prod. Order No.");
        CapLedgEntry.SETRANGE("Routing No.", ProdOrderLine."Routing No.");
        CapLedgEntry.SETRANGE("Routing Reference No.", ProdOrderLine."Routing Reference No.");
        //>> SDA.2022/06/14
        //EXIT(CapLedgEntry.FINDFIRST);
        IF CapLedgEntry.FINDFIRST THEN BEGIN
            CapLedgEntry.CALCSUMS("Output Quantity");
            IF CapLedgEntry."Output Quantity" <> 0 THEN EntriesExist := TRUE;
        END;
        EntriesExist := false;
        //<<
    END;

    LOCAL PROCEDURE GetIntegerPos(No: Code[20]; VAR StartPos: Integer; VAR EndPos: Integer);
    VAR
        IsDigit: Boolean;
        i: Integer;
    BEGIN
        StartPos := 0;
        EndPos := 0;
        IF No <> '' THEN BEGIN
            i := STRLEN(No);
            REPEAT
                IsDigit := No[i] IN ['0' .. '9'];
                IF IsDigit THEN BEGIN
                    IF EndPos = 0 THEN EndPos := i;
                    StartPos := i;
                END;
                i := i - 1;
            UNTIL (i = 0) OR (StartPos <> 0) AND NOT IsDigit;
        END;
    END;

    LOCAL procedure GetNoText(No: Code[20]): Code[20]
    var
        StartPos: Integer;
        EndPos: Integer;
    begin
        GetIntegerPos(No, StartPos, EndPos);
        IF StartPos <> 0 THEN EXIT(COPYSTR(No, StartPos, EndPos - StartPos + 1));
    end;

    local procedure GetNumericValue(NoSerie: Code[20]; Increase: Integer): BigInteger
    var
        VarBigInteger: BigInteger;
    begin
        EVALUATE(VarBigInteger, GetNoText(NoSerie));
        EXIT(VarBigInteger + Increase);
    end;
    // [EventSubscriber(ObjectType::codeunit, codeunit::"Calculate Prod. Order", 'OnBeforeTransferBOMComponent', '', false, false)]
    // local procedure OnBeforeTransferBOMComponent(ProdOrderLine: Record "Prod. Order Line"; ProdOrder: Record "Production Order"; var ErrorOccured: Boolean; var IsHandled: Boolean; var ProdBOMLine: Record "Production BOM Line")
    // var
    //     rManufacturingSetup: Record "Manufacturing Setup";
    // begin
    //     // SDA. 20190213. Fijar el almacen de consumo en la cabecera de la orden de fabricación.
    //     //>>
    //     ProdOrder.GET(ProdOrderLine.Status, ProdOrderLine."Prod. Order No.");
    //     //<<
    // END;
    // [EventSubscriber(ObjectType::codeunit, codeunit::"Calculate Prod. Order", 'OnTransferBOMProcessItemOnBeforeGetPlanningParameters', '', false, false)]
    // local procedure OnTransferBOMProcessItemOnBeforeGetPlanningParameters(ProductionBOMLine: Record "Production BOM Line"; var ProdOrderComponent: Record "Prod. Order Component")
    // var
    //     ProdOrder: Record "Production Order";
    // begin
    //     // SDA. 20190213. Fijar el almacen de consumo en la cabecera de la orden de fabricación.
    //     //>>
    //     Clear(ProdOrder);
    //     ProdOrder.SetRange("No.", ProductionBOMLine."Production BOM No.");
    //     IF ProdOrder.FindFirst() then begin
    //         IF ProdOrder."Location Components Code" <> '' THEN
    //             ProdOrderComponent."Location Code" := ProdOrder."Location Components Code";
    //     end;
    //     //<<
    // END;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Prod. Order", 'OnAfterTransferBOMComponent', '', true, true)]
    local procedure "Calculate Prod. Order_OnAfterTransferBOMComponent"(var ProdOrderLine: Record "Prod. Order Line"; var ProductionBOMLine: Record "Production BOM Line"; var ProdOrderComponent: Record "Prod. Order Component"; LineQtyPerUOM: Decimal; ItemQtyPerUOM: Decimal)
    var
        ProdOrder: Record "Production Order";
    begin
        // SDA. 20190213. Fijar el almacen de consumo en la cabecera de la orden de fabricación.
        //>>
        ProdOrder.GET(ProdOrderLine.Status, ProdOrderLine."Prod. Order No.");
        if ProdOrder."Location Components Code" <> '' then ProdOrderComponent."Location Code" := ProdOrder."Location Components Code";
        //<<
    end;

    var
        varNewStatus: Enum "Production Order Status";
}
