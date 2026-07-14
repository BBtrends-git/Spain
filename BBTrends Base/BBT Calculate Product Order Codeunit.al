codeunit 50042 "BBT Calculate Product Order"
{
    PROCEDURE Calculate2(ProdOrderLine2: Record 5406; Direction: Option Forward,Backward; CalcRouting: Boolean; CalcComponents: Boolean; DeleteRelations: Boolean; LetDueDateDecrease: Boolean): Boolean;
    VAR
        CapLedgEntry: Record 5832;
        ItemLedgEntry: Record 32;
        ProdOrderRtngLine3: Record 5409;
        ProdOrderRtngLine4: Record 5409;
        Routing: Record 99000763;
        ProdOrderRtngLine: Record 5409;
        ErrorOccured: Boolean;
    BEGIN
        ProdOrderLine := ProdOrderLine2;
        ProdOrderLine.TESTFIELD(Quantity);
        IF Direction = Direction::Backward THEN
            ProdOrderLine.TESTFIELD("Ending Date")
        ELSE
            ProdOrderLine.TESTFIELD("Starting Date");
        IF DeleteRelations THEN ProdOrderLine.DeleteRelations;
        IF CalcRouting THEN BEGIN
            TransferRouting;
            IF NOT CalcComponents THEN BEGIN // components will not be calculated later- update bin code
                ProdOrderRtngLine.SETRANGE(Status, ProdOrderLine.Status);
                ProdOrderRtngLine.SETRANGE("Prod. Order No.", ProdOrderLine."Prod. Order No.");
                ProdOrderRtngLine.SETRANGE("Routing Reference No.", ProdOrderLine."Routing Reference No.");
                ProdOrderRtngLine.SETRANGE("Routing No.", ProdOrderLine."Routing No.");
                IF NOT ProdOrderRouteMgt.UpdateComponentsBin(ProdOrderRtngLine, TRUE) THEN ErrorOccured := TRUE;
            END;
        END
        ELSE BEGIN
            IF Routing.GET(ProdOrderLine2."Routing No.") OR (ProdOrderLine2."Routing No." = '') THEN
                IF Routing.Type <> Routing.Type::Parallel THEN BEGIN
                    ProdOrderRtngLine3.SETRANGE(Status, ProdOrderLine2.Status);
                    ProdOrderRtngLine3.SETRANGE("Prod. Order No.", ProdOrderLine2."Prod. Order No.");
                    ProdOrderRtngLine3.SETRANGE("Routing Reference No.", ProdOrderLine2."Routing Reference No.");
                    ProdOrderRtngLine3.SETRANGE("Routing No.", ProdOrderLine2."Routing No.");
                    ProdOrderRtngLine3.SETFILTER("Routing Status", '<>%1', ProdOrderRtngLine3."Routing Status"::Finished);
                    ProdOrderRtngLine4.COPYFILTERS(ProdOrderRtngLine3);
                    IF ProdOrderRtngLine3.FIND('-') THEN
                        REPEAT
                            ProdOrderRtngLine4.SETRANGE("Operation No.", ProdOrderRtngLine3."Next Operation No.");
                            IF NOT ProdOrderRtngLine4.FINDFIRST AND (ProdOrderRtngLine3."Next Operation No." <> '') THEN ERROR(Text002, ProdOrderRtngLine3."Next Operation No.");
                            ProdOrderRtngLine4.SETRANGE("Operation No.", ProdOrderRtngLine3."Previous Operation No.");
                            IF NOT ProdOrderRtngLine4.FINDFIRST AND (ProdOrderRtngLine3."Previous Operation No." <> '') THEN ERROR(Text003, ProdOrderRtngLine3."Previous Operation No.");
                        UNTIL ProdOrderRtngLine3.NEXT = 0;
                END;
        END;
        IF CalcComponents THEN BEGIN
            IF ProdOrderLine."Production BOM No." <> '' THEN BEGIN
                Item.GET(ProdOrderLine."Item No.");
                GetPlanningParameters.AtSKU(SKU, ProdOrderLine."Item No.", ProdOrderLine."Variant Code", ProdOrderLine."Location Code");
                IF NOT TransferBOM(ProdOrderLine."Production BOM No.", 1, ProdOrderLine."Qty. per Unit of Measure", UOMMgt.GetQtyPerUnitOfMeasure(Item, VersionMgt.GetBOMUnitOfMeasure(ProdOrderLine."Production BOM No.", ProdOrderLine."Production BOM Version Code"))) THEN ErrorOccured := TRUE;
            END;
        END;
        Recalculate(ProdOrderLine, Direction, LetDueDateDecrease);
        EXIT(NOT ErrorOccured);
    END;

    PROCEDURE Recalculate(VAR ProdOrderLine2: Record 5406; Direction: Option Forward,Backward; LetDueDateDecrease: Boolean);
    BEGIN
        ProdOrderLine := ProdOrderLine2;
        ProdOrderLine.BlockDynamicTracking(Blocked);
        CalculateRouting(Direction, LetDueDateDecrease);
        CalculateProdOrder.CalculateComponents;
        ProdOrderLine2 := ProdOrderLine;
    END;

    procedure TransferRouting()
    var
        RtngHeader: Record "Routing Header";
        RtngLine: Record "Routing Line";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
        WorkCenter: Record "Work Center";
        MachineCenter: Record "Machine Center";
    begin
        IF ProdOrderLine."Routing No." = '' THEN EXIT;
        RtngHeader.GET(ProdOrderLine."Routing No.");
        ProdOrderRtngLine.SETRANGE(Status, ProdOrderLine.Status);
        ProdOrderRtngLine.SETRANGE("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        ProdOrderRtngLine.SETRANGE("Routing Reference No.", ProdOrderLine."Routing Reference No.");
        ProdOrderRtngLine.SETRANGE("Routing No.", ProdOrderLine."Routing No.");
        IF ProdOrderRtngLine.FINDFIRST THEN EXIT;
        RtngLine.SETRANGE("Routing No.", ProdOrderLine."Routing No.");
        RtngLine.SETRANGE("Version Code", ProdOrderLine."Routing Version Code");
        IF RtngLine.FIND('-') THEN
            REPEAT
                RtngLine.TESTFIELD(Recalculate, FALSE);
                ProdOrderRtngLine.INIT;
                ProdOrderRtngLine.Status := ProdOrderLine.Status;
                ProdOrderRtngLine."Prod. Order No." := ProdOrderLine."Prod. Order No.";
                ProdOrderRtngLine."Routing Reference No." := ProdOrderLine."Routing Reference No.";
                ProdOrderRtngLine."Routing No." := ProdOrderLine."Routing No.";
                ProdOrderRtngLine."Operation No." := RtngLine."Operation No.";
                ProdOrderRtngLine."Next Operation No." := RtngLine."Next Operation No.";
                ProdOrderRtngLine."Previous Operation No." := RtngLine."Previous Operation No.";
                ProdOrderRtngLine.Type := RtngLine.Type;
                ProdOrderRtngLine."No." := RtngLine."No.";
                ProdOrderRtngLine.FillDefaultLocationAndBins;
                ProdOrderRtngLine."Work Center No." := RtngLine."Work Center No.";
                ProdOrderRtngLine."Work Center Group Code" := RtngLine."Work Center Group Code";
                ProdOrderRtngLine.Description := RtngLine.Description;
                ProdOrderRtngLine."Setup Time" := RtngLine."Setup Time";
                ProdOrderRtngLine."Run Time" := RtngLine."Run Time";
                ProdOrderRtngLine."Wait Time" := RtngLine."Wait Time";
                ProdOrderRtngLine."Move Time" := RtngLine."Move Time";
                ProdOrderRtngLine."Fixed Scrap Quantity" := RtngLine."Fixed Scrap Quantity";
                ProdOrderRtngLine."Lot Size" := RtngLine."Lot Size";
                ProdOrderRtngLine."Scrap Factor %" := RtngLine."Scrap Factor %";
                ProdOrderRtngLine."Minimum Process Time" := RtngLine."Minimum Process Time";
                ProdOrderRtngLine."Maximum Process Time" := RtngLine."Maximum Process Time";
                ProdOrderRtngLine."Concurrent Capacities" := RtngLine."Concurrent Capacities";
                IF ProdOrderRtngLine."Concurrent Capacities" = 0 THEN ProdOrderRtngLine."Concurrent Capacities" := 1;
                ProdOrderRtngLine."Send-Ahead Quantity" := RtngLine."Send-Ahead Quantity";
                ProdOrderRtngLine."Setup Time Unit of Meas. Code" := RtngLine."Setup Time Unit of Meas. Code";
                ProdOrderRtngLine."Run Time Unit of Meas. Code" := RtngLine."Run Time Unit of Meas. Code";
                ProdOrderRtngLine."Wait Time Unit of Meas. Code" := RtngLine."Wait Time Unit of Meas. Code";
                ProdOrderRtngLine."Move Time Unit of Meas. Code" := RtngLine."Move Time Unit of Meas. Code";
                ProdOrderRtngLine."Routing Link Code" := RtngLine."Routing Link Code";
                ProdOrderRtngLine."Standard Task Code" := RtngLine."Standard Task Code";
                ProdOrderRtngLine."Sequence No. (Forward)" := RtngLine."Sequence No. (Forward)";
                ProdOrderRtngLine."Sequence No. (Backward)" := RtngLine."Sequence No. (Backward)";
                ProdOrderRtngLine."Fixed Scrap Qty. (Accum.)" := RtngLine."Fixed Scrap Qty. (Accum.)";
                ProdOrderRtngLine."Scrap Factor % (Accumulated)" := RtngLine."Scrap Factor % (Accumulated)";
                ProdOrderRtngLine."Unit Cost per" := RtngLine."Unit Cost per";
                //>> BBT 01/07/2025. Codeunit Microsoft.Inventory.Costing."Cost Calculation Management"' does not contain a definition for 'RoutingCostPerUnit'
                //CostCalcMgt.RoutingCostPerUnit(ProdOrderRtngLine.Type, ProdOrderRtngLine."No.", ProdOrderRtngLine."Direct Unit Cost", ProdOrderRtngLine."Indirect Cost %", ProdOrderRtngLine."Overhead Rate", ProdOrderRtngLine."Unit Cost per", ProdOrderRtngLine."Unit Cost Calculation");
                Error('CU Cost Calculation Management does not contain a definition for RoutingCostPerUnit');
                //<<
                CASE ProdOrderRtngLine.Type OF
                    ProdOrderRtngLine.Type::"Work Center":
                        BEGIN
                            WorkCenter.GET(RtngLine."Work Center No.");
                            ProdOrderRtngLine."Flushing Method" := WorkCenter."Flushing Method";
                        END;
                    ProdOrderRtngLine.Type::"Machine Center":
                        BEGIN
                            MachineCenter.GET(ProdOrderRtngLine."No.");
                            ProdOrderRtngLine."Flushing Method" := MachineCenter."Flushing Method";
                        END;
                END;
                ProdOrderRtngLine.VALIDATE("Direct Unit Cost");
                ProdOrderRtngLine."Starting Time" := ProdOrderLine."Starting Time";
                ProdOrderRtngLine."Starting Date" := ProdOrderLine."Starting Date";
                ProdOrderRtngLine."Ending Time" := ProdOrderLine."Ending Time";
                ProdOrderRtngLine."Ending Date" := ProdOrderLine."Ending Date";
                ProdOrderRtngLine.UpdateDatetime;
                ProdOrderRtngLine.INSERT;
                TransferTaskInfo(ProdOrderRtngLine, ProdOrderLine."Routing Version Code");
            UNTIL RtngLine.NEXT = 0;
    end;

    procedure TransferTaskInfo(VAR FromProdOrderRtngLine: Record "Prod. Order Routing Line"; VersionCode: Code[20])
    var
        RtngLineTool: Record "Routing Tool";
        RtngLinePersonnel: Record "Routing Personnel";
        RtngLineQltyMeas: Record "Routing Quality Measure";
        RtngComment: Record "Routing Comment Line";
        ProdOrderRoutTool: Record "Prod. Order Routing Tool";
        ProdOrderRtngPersonnel: Record "Prod. Order Routing Personnel";
        ProdOrderRtngQltyMeas: Record "Prod. Order Rtng Qlty Meas.";
        ProdOrderRtngComment: Record "Prod. Order Rtng Comment Line";
    begin
        RtngLineTool.SETRANGE("Routing No.", FromProdOrderRtngLine."Routing No.");
        RtngLineTool.SETRANGE("Operation No.", FromProdOrderRtngLine."Operation No.");
        RtngLineTool.SETRANGE("Version Code", VersionCode);
        IF RtngLineTool.FIND('-') THEN
            REPEAT
                ProdOrderRoutTool.TRANSFERFIELDS(RtngLineTool);
                ProdOrderRoutTool.Status := FromProdOrderRtngLine.Status;
                ProdOrderRoutTool."Prod. Order No." := FromProdOrderRtngLine."Prod. Order No.";
                ProdOrderRoutTool."Routing Reference No." := FromProdOrderRtngLine."Routing Reference No.";
                ProdOrderRoutTool.INSERT;
            UNTIL RtngLineTool.NEXT = 0;
        RtngLinePersonnel.SETRANGE("Routing No.", FromProdOrderRtngLine."Routing No.");
        RtngLinePersonnel.SETRANGE("Operation No.", FromProdOrderRtngLine."Operation No.");
        RtngLinePersonnel.SETRANGE("Version Code", VersionCode);
        IF RtngLinePersonnel.FIND('-') THEN
            REPEAT
                ProdOrderRtngPersonnel.TRANSFERFIELDS(RtngLinePersonnel);
                ProdOrderRtngPersonnel.Status := FromProdOrderRtngLine.Status;
                ProdOrderRtngPersonnel."Prod. Order No." := FromProdOrderRtngLine."Prod. Order No.";
                ProdOrderRtngPersonnel."Routing Reference No." := FromProdOrderRtngLine."Routing Reference No.";
                ProdOrderRtngPersonnel.INSERT;
            UNTIL RtngLinePersonnel.NEXT = 0;
        RtngLineQltyMeas.SETRANGE("Routing No.", FromProdOrderRtngLine."Routing No.");
        RtngLineQltyMeas.SETRANGE("Operation No.", FromProdOrderRtngLine."Operation No.");
        RtngLineQltyMeas.SETRANGE("Version Code", VersionCode);
        IF RtngLineQltyMeas.FIND('-') THEN
            REPEAT
                ProdOrderRtngQltyMeas.TRANSFERFIELDS(RtngLineQltyMeas);
                ProdOrderRtngQltyMeas.Status := FromProdOrderRtngLine.Status;
                ProdOrderRtngQltyMeas."Prod. Order No." := FromProdOrderRtngLine."Prod. Order No.";
                ProdOrderRtngQltyMeas."Routing Reference No." := FromProdOrderRtngLine."Routing Reference No.";
                ProdOrderRtngQltyMeas.INSERT;
            UNTIL RtngLineQltyMeas.NEXT = 0;
        RtngComment.SETRANGE("Routing No.", FromProdOrderRtngLine."Routing No.");
        RtngComment.SETRANGE("Operation No.", FromProdOrderRtngLine."Operation No.");
        RtngComment.SETRANGE("Version Code", VersionCode);
        IF RtngComment.FIND('-') THEN
            REPEAT
                ProdOrderRtngComment.TRANSFERFIELDS(RtngComment);
                ProdOrderRtngComment.Status := FromProdOrderRtngLine.Status;
                ProdOrderRtngComment."Prod. Order No." := FromProdOrderRtngLine."Prod. Order No.";
                ProdOrderRtngComment."Routing Reference No." := FromProdOrderRtngLine."Routing Reference No.";
                ProdOrderRtngComment.INSERT;
            UNTIL RtngComment.NEXT = 0;
    end;

    local procedure TransferBOM(ProdBOMNo: Code[20]; Level: Integer; LineQtyPerUOM: Decimal; ItemQtyPerUOM: Decimal): Boolean
    var
        BOMHeader: Record "Production BOM Header";
        ComponentSKU: Record "Stockkeeping Unit";
        Item2: Record Item;
        ProductionBOMVersion: Record "Production BOM Version";
        ReqQty: Decimal;
        ErrorOccured: Boolean;
        VersionCode: Code[20];
    begin
        IF ProdBOMNo = '' THEN EXIT;
        ProdOrderComp.LOCKTABLE;
        IF Level > 50 THEN ERROR(Text000, ProdBOMNo);
        BOMHeader.GET(ProdBOMNo);
        IF Level > 1 THEN
            VersionCode := VersionMgt.GetBOMVersion(ProdBOMNo, ProdOrderLine."Starting Date", TRUE)
        ELSE
            VersionCode := ProdOrderLine."Production BOM Version Code";
        IF VersionCode <> '' THEN BEGIN
            ProductionBOMVersion.GET(ProdBOMNo, VersionCode);
            ProductionBOMVersion.TESTFIELD(Status, ProductionBOMVersion.Status::Certified);
        END
        ELSE
            BOMHeader.TESTFIELD(Status, BOMHeader.Status::Certified);
        // SDA. 20190213. Fijar el almacen de consumo en la cabecera de la orden de fabricación.
        //>>
        ProdOrder.GET(ProdOrderLine.Status, ProdOrderLine."Prod. Order No.");
        //<<
        BomComponent[Level].SETRANGE("Production BOM No.", ProdBOMNo);
        BomComponent[Level].SETRANGE("Version Code", VersionCode);
        BomComponent[Level].SETFILTER("Starting Date", '%1|..%2', 0D, ProdOrderLine."Starting Date");
        BomComponent[Level].SETFILTER("Ending Date", '%1|%2..', 0D, ProdOrderLine."Starting Date");
        IF BomComponent[Level].FIND('-') THEN
            REPEAT
                IF BomComponent[Level]."Routing Link Code" <> '' THEN BEGIN
                    ProdOrderRtngLine2.SETRANGE(Status, ProdOrderLine.Status);
                    ProdOrderRtngLine2.SETRANGE("Prod. Order No.", ProdOrderLine."Prod. Order No.");
                    ProdOrderRtngLine2.SETRANGE("Routing Link Code", BomComponent[Level]."Routing Link Code");
                    ProdOrderRtngLine2.FINDFIRST;
                    ReqQty := BomComponent[Level].Quantity * (1 + BomComponent[Level]."Scrap %" / 100) * (1 + ProdOrderRtngLine2."Scrap Factor % (Accumulated)") * (1 + ProdOrderLine."Scrap %" / 100) * LineQtyPerUOM / ItemQtyPerUOM + ProdOrderRtngLine2."Fixed Scrap Qty. (Accum.)";
                END
                ELSE
                    ReqQty := BomComponent[Level].Quantity * (1 + BomComponent[Level]."Scrap %" / 100) * (1 + ProdOrderLine."Scrap %" / 100) * LineQtyPerUOM / ItemQtyPerUOM;
                CASE BomComponent[Level].Type OF
                    BomComponent[Level].Type::Item:
                        BEGIN
                            IF ReqQty <> 0 THEN BEGIN
                                ProdOrderComp.SETCURRENTKEY(Status, "Prod. Order No.", "Prod. Order Line No.", "Item No.");
                                ProdOrderComp.SETRANGE(Status, ProdOrderLine.Status);
                                ProdOrderComp.SETRANGE("Prod. Order No.", ProdOrderLine."Prod. Order No.");
                                ProdOrderComp.SETRANGE("Prod. Order Line No.", ProdOrderLine."Line No.");
                                ProdOrderComp.SETRANGE("Item No.", BomComponent[Level]."No.");
                                ProdOrderComp.SETRANGE("Variant Code", BomComponent[Level]."Variant Code");
                                ProdOrderComp.SETRANGE("Routing Link Code", BomComponent[Level]."Routing Link Code");
                                ProdOrderComp.SETRANGE(Position, BomComponent[Level].Position);
                                ProdOrderComp.SETRANGE("Position 2", BomComponent[Level]."Position 2");
                                ProdOrderComp.SETRANGE("Position 3", BomComponent[Level]."Position 3");
                                ProdOrderComp.SETRANGE(Length, BomComponent[Level].Length);
                                ProdOrderComp.SETRANGE(Width, BomComponent[Level].Width);
                                ProdOrderComp.SETRANGE(Weight, BomComponent[Level].Weight);
                                ProdOrderComp.SETRANGE(Depth, BomComponent[Level].Depth);
                                ProdOrderComp.SETRANGE("Unit of Measure Code", BomComponent[Level]."Unit of Measure Code");
                                IF NOT ProdOrderComp.FINDFIRST THEN BEGIN
                                    ProdOrderComp.RESET;
                                    ProdOrderComp.SETRANGE(Status, ProdOrderLine.Status);
                                    ProdOrderComp.SETRANGE("Prod. Order No.", ProdOrderLine."Prod. Order No.");
                                    ProdOrderComp.SETRANGE("Prod. Order Line No.", ProdOrderLine."Line No.");
                                    IF ProdOrderComp.FINDLAST THEN
                                        NextProdOrderCompLineNo := ProdOrderComp."Line No." + 10000
                                    ELSE
                                        NextProdOrderCompLineNo := 10000;
                                    ProdOrderComp.INIT;
                                    ProdOrderComp.SetIgnoreErrors;
                                    ProdOrderComp.BlockDynamicTracking(Blocked);
                                    ProdOrderComp.Status := ProdOrderLine.Status;
                                    ProdOrderComp."Prod. Order No." := ProdOrderLine."Prod. Order No.";
                                    ProdOrderComp."Prod. Order Line No." := ProdOrderLine."Line No.";
                                    ProdOrderComp."Line No." := NextProdOrderCompLineNo;
                                    ProdOrderComp.VALIDATE("Item No.", BomComponent[Level]."No.");
                                    ProdOrderComp."Variant Code" := BomComponent[Level]."Variant Code";
                                    ProdOrderComp."Location Code" := SKU."Components at Location";
                                    // SDA. 20190213. Fijar el almacen de consumo en la cabecera de la orden de fabricación.
                                    //>>
                                    IF ProdOrder."Location Components Code" <> '' THEN ProdOrderComp."Location Code" := ProdOrder."Location Components Code";
                                    //<<
                                    ProdOrderComp."Bin Code" := GetDefaultBin;
                                    ProdOrderComp.Description := BomComponent[Level].Description;
                                    ProdOrderComp.VALIDATE("Unit of Measure Code", BomComponent[Level]."Unit of Measure Code");
                                    ProdOrderComp."Quantity per" := BomComponent[Level]."Quantity per" * LineQtyPerUOM / ItemQtyPerUOM;
                                    ProdOrderComp.Length := BomComponent[Level].Length;
                                    ProdOrderComp.Width := BomComponent[Level].Width;
                                    ProdOrderComp.Weight := BomComponent[Level].Weight;
                                    ProdOrderComp.Depth := BomComponent[Level].Depth;
                                    ProdOrderComp.Position := BomComponent[Level].Position;
                                    ProdOrderComp."Position 2" := BomComponent[Level]."Position 2";
                                    ProdOrderComp."Position 3" := BomComponent[Level]."Position 3";
                                    ProdOrderComp."Lead-Time Offset" := BomComponent[Level]."Lead-Time Offset";
                                    ProdOrderComp.VALIDATE("Routing Link Code", BomComponent[Level]."Routing Link Code");
                                    ProdOrderComp.VALIDATE("Scrap %", BomComponent[Level]."Scrap %");
                                    ProdOrderComp.VALIDATE("Calculation Formula", BomComponent[Level]."Calculation Formula");
                                    GetPlanningParameters.AtSKU(ComponentSKU, ProdOrderComp."Item No.", ProdOrderComp."Variant Code", ProdOrderComp."Location Code");
                                    ProdOrderComp."Flushing Method" := ComponentSKU."Flushing Method";
                                    IF (SKU."Manufacturing Policy" = SKU."Manufacturing Policy"::"Make-to-Order") AND (ComponentSKU."Manufacturing Policy" = ComponentSKU."Manufacturing Policy"::"Make-to-Order") AND (ComponentSKU."Replenishment System" = ComponentSKU."Replenishment System"::"Prod. Order") THEN BEGIN
                                        ProdOrderComp."Planning Level Code" := ProdOrderLine."Planning Level Code" + 1;
                                        Item2.GET(ProdOrderComp."Item No.");
                                        ProdOrderComp."Item Low-Level Code" := Item2."Low-Level Code";
                                    END;
                                    ProdOrderComp.GetDefaultBin;
                                    ProdOrderComp.INSERT(TRUE);
                                END
                                ELSE BEGIN
                                    ProdOrderComp.SetIgnoreErrors;
                                    ProdOrderComp.SETCURRENTKEY(Status, "Prod. Order No."); // Reset key
                                    ProdOrderComp.BlockDynamicTracking(Blocked);
                                    ProdOrderComp.VALIDATE("Quantity per", ProdOrderComp."Quantity per" + BomComponent[Level]."Quantity per" * LineQtyPerUOM / ItemQtyPerUOM);
                                    ProdOrderComp.VALIDATE("Routing Link Code", BomComponent[Level]."Routing Link Code");
                                    ProdOrderComp.MODIFY;
                                END;
                                IF ProdOrderComp.HasErrorOccured THEN ErrorOccured := TRUE;
                                ProdOrderComp.AutoReserve;
                                ProdBOMCompComment.SETRANGE("Production BOM No.", BomComponent[Level]."Production BOM No.");
                                ProdBOMCompComment.SETRANGE("BOM Line No.", BomComponent[Level]."Line No.");
                                ProdBOMCompComment.SETRANGE("Version Code", BomComponent[Level]."Version Code");
                                IF ProdBOMCompComment.FIND('-') THEN
                                    REPEAT
                                        ProdOrderBOMCompComment.TRANSFERFIELDS(ProdBOMCompComment);
                                        ProdOrderBOMCompComment.Status := ProdOrderComp.Status;
                                        ProdOrderBOMCompComment."Prod. Order No." := ProdOrderComp."Prod. Order No.";
                                        ProdOrderBOMCompComment."Prod. Order Line No." := ProdOrderComp."Prod. Order Line No.";
                                        ProdOrderBOMCompComment."Prod. Order BOM Line No." := ProdOrderComp."Line No.";
                                        IF NOT ProdOrderBOMCompComment.INSERT THEN ProdOrderBOMCompComment.MODIFY;
                                    UNTIL ProdBOMCompComment.NEXT = 0;
                            END;
                        END;
                    BomComponent[Level].Type::"Production BOM":
                        BEGIN
                            TransferBOM(BomComponent[Level]."No.", Level + 1, ReqQty, 1);
                            BomComponent[Level].SETRANGE("Production BOM No.", ProdBOMNo);
                            IF Level > 1 THEN
                                BomComponent[Level].SETRANGE("Version Code", VersionMgt.GetBOMVersion(ProdBOMNo, ProdOrderLine."Starting Date", TRUE))
                            ELSE
                                BomComponent[Level].SETRANGE("Version Code", ProdOrderLine."Production BOM Version Code");
                            BomComponent[Level].SETFILTER("Starting Date", '%1|..%2', 0D, ProdOrderLine."Starting Date");
                            BomComponent[Level].SETFILTER("Ending Date", '%1|%2..', 0D, ProdOrderLine."Starting Date");
                        END;
                END;
            UNTIL BomComponent[Level].NEXT = 0;
        EXIT(NOT ErrorOccured);
    end;

    LOCAL procedure GetDefaultBin() BinCode: Code[20]
    var
        Location: Record Location;
        WMSMgt: Codeunit "WMS Management";
    begin
        IF ProdOrderComp."Location Code" <> '' THEN BEGIN
            IF Location.Code <> ProdOrderComp."Location Code" THEN Location.GET(ProdOrderComp."Location Code");
            IF Location."Bin Mandatory" AND (NOT Location."Directed Put-away and Pick") THEN WMSMgt.GetDefaultBin(ProdOrderComp."Item No.", ProdOrderComp."Variant Code", ProdOrderComp."Location Code", BinCode);
        END;
    end;

    LOCAL procedure CalculateRouting(Direction: option Forward,Backward; LetDueDateDecrease: Boolean)
    var
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
        LeadTime: Code[20];
    begin
        IF ProdOrderRouteMgt.NeedsCalculation(ProdOrderLine.Status, ProdOrderLine."Prod. Order No.", ProdOrderLine."Routing Reference No.", ProdOrderLine."Routing No.") THEN ProdOrderRouteMgt.Calculate(ProdOrderLine);
        IF Direction = Direction::Forward THEN
            ProdOrderRtngLine.SETCURRENTKEY(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Sequence No. (Forward)")
        ELSE
            ProdOrderRtngLine.SETCURRENTKEY(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Sequence No. (Backward)");
        ProdOrderRtngLine.SETRANGE(Status, ProdOrderLine.Status);
        ProdOrderRtngLine.SETRANGE("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        ProdOrderRtngLine.SETRANGE("Routing Reference No.", ProdOrderLine."Routing Reference No.");
        ProdOrderRtngLine.SETRANGE("Routing No.", ProdOrderLine."Routing No.");
        ProdOrderRtngLine.SETFILTER("Routing Status", '<>%1', ProdOrderRtngLine."Routing Status"::Finished);
        IF NOT ProdOrderRtngLine.FINDFIRST THEN BEGIN
            LeadTime := LeadTimeMgt.ManufacturingLeadTime(ProdOrderLine."Item No.", ProdOrderLine."Location Code", ProdOrderLine."Variant Code");

            //>> BBT 11/03/2025. Fix Compatibility With Extension 28.0
            //IF Direction = Direction::Forward THEN // Ending Date calculated forward from Starting Date
            //    ProdOrderLine."Ending Date" := LeadTimeMgt.PlannedEndingDate(ProdOrderLine."Item No.", ProdOrderLine."Location Code", ProdOrderLine."Variant Code", '', LeadTime, 2, ProdOrderLine."Starting Date")
            //ELSE    // Starting Date calculated backward from Ending Date
            //    ProdOrderLine."Starting Date" := LeadTimeMgt.PlannedStartingDate(ProdOrderLine."Item No.", ProdOrderLine."Location Code", ProdOrderLine."Variant Code", '', LeadTime, 2, ProdOrderLine."Ending Date");
            if Direction = Direction::Forward then // Ending Date calculated forward from Starting Date
                ProdOrderLine."Ending Date" := LeadTimeMgt.GetPlannedEndingDate(ProdOrderLine."Item No.", ProdOrderLine."Location Code",
                                            ProdOrderLine."Variant Code", '', LeadTime, Enum::"Requisition Ref. Order Type"::"Prod. Order", ProdOrderLine."Starting Date")

            else    // Starting Date calculated backward from Ending Date
                ProdOrderLine."Starting Date" := LeadTimeMgt.GetPlannedStartingDate(ProdOrderLine."Item No.", ProdOrderLine."Location Code",
                                            ProdOrderLine."Variant Code", '', LeadTime, Enum::"Requisition Ref. Order Type"::"Prod. Order", ProdOrderLine."Ending Date");
            //<<

            CalculateProdOrder.CalculateProdOrderDates(ProdOrderLine, LetDueDateDecrease);
            EXIT;
        END;
        IF Direction = Direction::Forward THEN BEGIN
            ProdOrderRtngLine."Starting Date" := ProdOrderLine."Starting Date";
            ProdOrderRtngLine."Starting Time" := ProdOrderLine."Starting Time";
        END
        ELSE BEGIN
            ProdOrderRtngLine."Ending Date" := ProdOrderLine."Ending Date";
            ProdOrderRtngLine."Ending Time" := ProdOrderLine."Ending Time";
        END;
        ProdOrderRtngLine.UpdateDatetime;
        CalculateProdOrder.CalculateRoutingFromActual(ProdOrderRtngLine, Direction, FALSE);
        CalculateProdOrder.CalculateProdOrderDates(ProdOrderLine, LetDueDateDecrease);
    end;

    var
        ProdOrderLine: Record "Prod. Order Line";
        CostCalcMgt: Codeunit "Cost Calculation Management";
        Blocked: Boolean;
        ProdOrderRouteMgt: Codeunit "Prod. Order Route Management";
        Text000: label 'BOM phantom structure for %1 is higher than 50 levels.';
        Text001: Label '%1 %2 %3 can not be calculated, if at least one %4 has been posted.';
        Text002: label 'Operation No. %1 cannot follow another operation in the routing of this Prod. Order Line';
        Text003: label 'Operation No. %1 cannot precede another operation in the routing of this Prod. Order Line';
        Item: Record Item;
        SKU: Record "Stockkeeping Unit";
        UOMMgt: Codeunit "Unit of Measure Management";
        VersionMgt: Codeunit "VersionManagement";
        GetPlanningParameters: Codeunit "Planning-Get Parameters";
        ProdOrder: Record "Production Order";
        ProdOrderComp: Record "Prod. Order Component";
        ProdOrderRtngLine2: Record "Prod. Order Routing Line";
        ProdOrderBOMCompComment: Record "Prod. Order Comp. Cmt Line";
        BomComponent: array[99] of Record "Production BOM Line";
        ProdBOMCompComment: Record "Production BOM Comment Line";
        NextProdOrderCompLineNo: Integer;
        LeadTimeMgt: Codeunit "Lead-Time Management";
        CalculateProdOrder: Codeunit "Calculate Prod. Order";
}
