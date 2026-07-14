Report 50048 "BBT Inventory Availability"
//fin - The application object identifier '705' is not valid. It must be within the allowed ranges '[50000..90500]'.
//    - An application object of type 'Report' with name 'Inventory Availability' is already declared by the extension 'Base Application by Microsoft (18.0.23013.23795)'.
{
    // SDA.20190417. Corregir Informe. Incorporar Componentes Planificados. Cancelaciones en la Hoja de Demanda
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/Inventory Availability.rdl';
    Caption = 'Inventory Availability', comment = 'ESP="Disponibilidad stock"';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = where(Type = const(Inventory));
            RequestFilterFields = "No.", "Location Filter", "Variant Filter", "Search Description", "Assembly BOM", "Inventory Posting Group", "Statistics Group", "Vendor No.";

            column(ReportForNavId_8129; 8129)
            { }
            column(CompanyName; COMPANYNAME)
            { }
            column(TableItemFilter; Item.TableCaption + ': ' + ItemFilter)
            { }
            column(ItemFilter; ItemFilter)
            { }
            column(GetCurrentKey; GetCurrentKey)
            { }
            column(UseStockkeepingUnit; UseStockkeepingUnit)
            { }
            column(InventPostGroup_Item; Item."Inventory Posting Group")
            { }
            column(InvtReorder; Format(InvtReorder))
            { }
            column(ReorderPoint_Item; Item."Reorder Point")
            {
                IncludeCaption = true;
            }
            column(ProjAvailBalance; ProjAvailBalance)
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlannedOrderReceipt; PlannedOrderReceipt)
            {
                DecimalPlaces = 0 : 5;
            }
            column(BackOrderQty; BackOrderQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(ScheduledReceipt; ScheduledReceipt)
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossRequirement; GrossRequirement)
            {
                DecimalPlaces = 0 : 5;
            }
            column(BaseUnitofMeasure_Item; Item."Base Unit of Measure")
            {
                IncludeCaption = true;
            }
            column(AssemblyBOM_Item; Format(Item."Assembly BOM"))
            { }
            column(Description_Item; Item.Description)
            {
                IncludeCaption = true;
            }
            column(No_Item; Item."No.")
            {
                IncludeCaption = true;
            }
            column(InventoryAvailabilityCaption; InventoryAvailabilityCaptionLbl)
            { }
            column(PageCaption; PageCaptionLbl)
            { }
            column(BOMCaption; BOMCaptionLbl)
            { }
            column(GrossRequirementCaption; GrossRequirementCaptionLbl)
            { }
            column(ScheduledReceiptCaption; ScheduledReceiptCaptionLbl)
            { }
            column(PlannedOrderReceiptCaption; PlannedOrderReceiptCaptionLbl)
            { }
            column(QuantityOnBackOrderCaption; QuantityOnBackOrderCaptionLbl)
            { }
            column(ProjectedAvailableBalCaption; ProjectedAvailableBalCaptionLbl)
            { }
            column(ReorderCaption; ReorderCaptionLbl)
            { }
            dataitem("Stockkeeping Unit"; "Stockkeeping Unit")
            {
                DataItemLink = "Item No." = field("No."), "Location Code" = field("Location Filter"), "Variant Code" = field("Variant Filter");
                DataItemTableView = sorting("Item No.", "Location Code", "Variant Code");

                column(ReportForNavId_5605; 5605)
                {
                }
                column(AssemblyBOMStock_Item; Format(Item."Assembly BOM"))
                {
                }
                column(UnitofMeasure_Item; Item."Base Unit of Measure")
                {
                }
                column(InvtReorder2; Format(InvtReorder))
                {
                }
                column(ReordPoint_StockkeepUnit; "Stockkeeping Unit"."Reorder Point")
                {
                }
                column(ProjAvailBalance2; ProjAvailBalance)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(BackOrderQty2; BackOrderQty)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(PlannedOrderReceipt2; PlannedOrderReceipt)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(ScheduledReceipt2; ScheduledReceipt)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(GrossRequirement2; GrossRequirement)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(VariantCode_StockkeepUnit; "Stockkeeping Unit"."Variant Code")
                {
                    IncludeCaption = true;
                }
                column(LocCode_StockkeepUnit; "Stockkeeping Unit"."Location Code")
                {
                    IncludeCaption = true;
                }
                column(SKUPrintLoop; SKUPrintLoop)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    SKUPrintLoop := SKUPrintLoop + 1;
                    if "Stockkeeping Unit"."Reordering Policy" in ["Stockkeeping Unit"."reordering policy"::Order, "Stockkeeping Unit"."reordering policy"::"Lot-for-Lot"] then "Stockkeeping Unit"."Reorder Point" := 0;
                    CalcNeed(Item, "Stockkeeping Unit"."Location Code", "Stockkeeping Unit"."Variant Code", "Stockkeeping Unit"."Reorder Point");
                end;

                trigger OnPreDataItem()
                begin
                    if not UseStockkeepingUnit then CurrReport.Break;
                    SKUPrintLoop := 0;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                if not UseStockkeepingUnit then begin
                    if Item."Reordering Policy" in [Item."reordering policy"::Order, Item."reordering policy"::"Lot-for-Lot"] then Item."Reorder Point" := 0;
                    CalcNeed(Item, Item.GetFilter(Item."Location Filter"), Item.GetFilter(Item."Variant Filter"), Item."Reorder Point");
                end;
            end;

            trigger OnPreDataItem()
            begin
                GetCurrentKey := Item.CurrentKey;
            end;
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', comment = 'ESP="Opciones"';

                    field(UseStockkeepingUnit; UseStockkeepingUnit)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Use Stockkeeping Unit', comment = 'ESP="Utiliz. ud. almacenam."';
                    }
                }
            }
        }
        actions
        {
        }
    }
    labels
    {
    }
    trigger OnPreReport()
    begin
        ItemFilter := Item.GetFilters;
    end;

    var
        ItemFilter: Text;
        BackOrderQty: Decimal;
        InvtReorder: Boolean;
        GrossRequirement: Decimal;
        PlannedOrderReceipt: Decimal;
        ScheduledReceipt: Decimal;
        ProjAvailBalance: Decimal;
        UseStockkeepingUnit: Boolean;
        SKUPrintLoop: Integer;
        AvailToPromise: Codeunit "Available to Promise";
        GetCurrentKey: Text[250];
        InventoryAvailabilityCaptionLbl: label 'Inventory Availability', comment = 'ESP="Disponibilidad stock"';
        PageCaptionLbl: label 'Page', comment = 'ESP="Pág."';
        BOMCaptionLbl: label 'BOM', comment = 'ESP="L.M."';
        GrossRequirementCaptionLbl: label 'Gross Requirement', comment = 'ESP="Necesidades brutas"';
        ScheduledReceiptCaptionLbl: label 'Scheduled Receipt', comment = 'ESP="Recepción programada"';
        PlannedOrderReceiptCaptionLbl: label 'Planned Order Receipt', comment = 'ESP="Recep. orden planif."';
        QuantityOnBackOrderCaptionLbl: label 'Quantity on Back Order', comment = 'ESP="Cdad. pedidos pendientes"';
        ProjectedAvailableBalCaptionLbl: label 'Projected Available Balance', comment = 'ESP="Saldo disponible estimado"';
        ReorderCaptionLbl: label 'Reorder', comment = 'ESP="Reaprovisionamiento"';

    procedure CalcNeed(Item: Record Item; LocationFilter: Text[250]; VariantFilter: Text[250]; ReorderPoint: Decimal)
    var
        Rec_PlanComp: Record "Planning Component";
        QtyInComponentPlanning: Decimal;
        Rec_ReqLine: Record "Requisition Line";
        NewQtyInReqLine: Decimal;
    begin
        begin
            Item.SetFilter(Item."Location Filter", LocationFilter);
            Item.SetFilter(Item."Variant Filter", VariantFilter);
            Item.SetRange(Item."Drop Shipment Filter", false);
            Item.SetRange(Item."Date Filter", 0D, WorkDate);
            Item.CalcFields(Item."Qty. on Purch. Order", Item."Planning Receipt (Qty.)", Item."Scheduled Receipt (Qty.)", Item."Planned Order Receipt (Qty.)", Item."Purch. Req. Receipt (Qty.)", Item."Qty. in Transit", Item."Trans. Ord. Receipt (Qty.)", Item."Reserved Qty. on Inventory");
            BackOrderQty := Item."Qty. on Purch. Order" + Item."Scheduled Receipt (Qty.)" + Item."Planned Order Receipt (Qty.)" + Item."Qty. in Transit" + Item."Trans. Ord. Receipt (Qty.)" + Item."Planning Receipt (Qty.)" + Item."Purch. Req. Receipt (Qty.)";
            Item.SetRange(Item."Date Filter", 0D, 99991231D);
            GrossRequirement := AvailToPromise.CalcGrossRequirement(Item);
            ScheduledReceipt := AvailToPromise.CalcScheduledReceipt(Item);
            //>> SDA.20190417.
            //  CALCFIELDS(
            //    Inventory,
            //    "Planning Receipt (Qty.)",
            //    "Planned Order Receipt (Qty.)",
            //    "Purch. Req. Receipt (Qty.)");
            //
            Item.CalcFields(Item.Inventory, Item."Planning Receipt (Qty.)", Item."Planning Release (Qty.)", Item."Planned Order Receipt (Qty.)", Item."Planned Order Release (Qty.)");
            //<<
            //>> SDA.20190417. Incorporar Componentes Planificados.
            QtyInComponentPlanning := 0;
            Rec_PlanComp.SetRange("Item No.", Item."No.");
            Rec_PlanComp.SetFilter("Location Code", LocationFilter);
            Rec_PlanComp.SetFilter("Variant Code", VariantFilter);
            Rec_PlanComp.SetRange("Due Date", 0D, 99991231D);
            repeat
                QtyInComponentPlanning := QtyInComponentPlanning + Rec_PlanComp."Expected Quantity (Base)";
            until Rec_PlanComp.Next = 0;
            GrossRequirement := GrossRequirement + QtyInComponentPlanning;
            //<<
            //>> SDA.20190417. Cancelaciones en la Hoja de Demanda
            NewQtyInReqLine := 0;
            Rec_ReqLine.SetRange(Type, Rec_ReqLine.Type::Item);
            Rec_ReqLine.SetRange("No.", Item."No.");
            Rec_ReqLine.SetFilter("Location Code", LocationFilter);
            Rec_ReqLine.SetFilter("Variant Code", VariantFilter);
            Rec_ReqLine.SetRange("Due Date", 0D, 99991231D);
            Rec_ReqLine.SetFilter("Action Message", '%1 | %2 | %3', Rec_ReqLine."action message"::Cancel, Rec_ReqLine."action message"::"Change Qty.", Rec_ReqLine."action message"::"Resched. & Chg. Qty.");
            repeat
                NewQtyInReqLine := NewQtyInReqLine + Rec_ReqLine."Net Quantity (Base)";
            until Rec_ReqLine.Next = 0;
            //<<
            //>> SDA.20190417
            //  ScheduledReceipt := ScheduledReceipt - "Planned Order Receipt (Qty.)";
            //
            //  PlannedOrderReceipt :=
            //    "Planned Order Receipt (Qty.)" +
            //    "Purch. Req. Receipt (Qty.)";
            //
            //  ProjAvailBalance :=
            //    Inventory +
            //    ScheduledReceipt -
            //    GrossRequirement;
            //
            ScheduledReceipt := ScheduledReceipt - Item."Planning Receipt (Qty.)" + NewQtyInReqLine;
            PlannedOrderReceipt := Item."Planning Receipt (Qty.)" + Item."Planned Order Receipt (Qty.)";
            ProjAvailBalance := Item.Inventory + ScheduledReceipt + PlannedOrderReceipt - GrossRequirement;
            //<<
            InvtReorder := ProjAvailBalance < ReorderPoint;
        end;
    end;

    procedure InitializeRequest(NewUseStockkeepingUnit: Boolean)
    begin
        UseStockkeepingUnit := NewUseStockkeepingUnit;
    end;
}
