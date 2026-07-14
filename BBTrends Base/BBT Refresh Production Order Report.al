Report 50064 "BBT Refresh Production Order"
//fin - The application object identifier '99001025' is not valid. It must be within the allowed ranges '[50000..90500]'.
//    - An application object of type 'Report' with name 'Refresh Production Order' is already declared by the extension 'Base Application by Microsoft (18.0.23013.23795)'
{
    // SDA. 20190214. En la actualización de la orden de producción mantener la ruta de la OF
    Caption = 'Refresh Production Order', comment = 'ESP="Actualizar orden producción"';
    ProcessingOnly = true;
    TransactionType = Update;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = sorting(Status, "No.");
            RequestFilterFields = Status, "No.", "Cantidad terminada", "Scrap Quantity";

            column(ReportForNavId_4824; 4824)
            {
            }
            trigger OnAfterGetRecord()
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
            begin
                if "Production Order".Status = "Production Order".Status::Finished then CurrReport.Skip;
                if Direction = Direction::Backward then "Production Order".TestField("Production Order"."Due Date");
                if CalcLines and IsComponentPicked("Production Order") then if not Confirm(StrSubstNo(DeletePickedLinesQst, "Production Order"."No.")) then CurrReport.Skip;
                Window.Update(1, "Production Order".Status);
                Window.Update(2, "Production Order"."No.");
                RoutingNo := "Production Order"."Routing No.";
                case "Production Order"."Source Type" of
                    "Production Order"."source type"::Item: //>> SDA. 20190214.
                                                            //    IF Item.GET("Source No.") THEN
                        if (Item.Get("Production Order"."Source No.")) and (RoutingNo = '') then //<<
                            RoutingNo := Item."Routing No.";
                    "Production Order"."source type"::Family:
                        if Family.Get("Production Order"."Source No.") then
                            RoutingNo := Family."Routing No.";
                end;
                if RoutingNo <> "Production Order"."Routing No." then begin
                    "Production Order"."Routing No." := RoutingNo;
                    "Production Order".Modify;
                end;
                ProdOrderLine.LockTable;
                //>> SDA. 20190214.
                ProdOrderLine.SetRange(Status, "Production Order".Status);
                ProdOrderLine.SetRange("Prod. Order No.", "Production Order"."No.");
                if ProdOrderLine.Find('-') and (ProdOrderLine."Routing No." <> "Production Order"."Routing No.") then begin
                    ProdOrderLine."Routing No." := "Production Order"."Routing No.";
                    ProdOrderLine.Modify;
                end;
                //<<
                CheckReservationExist;
                if CalcLines then begin
                    if not CreateProdOrderLines.Copy("Production Order", Direction, '', false) then ErrorOccured := true;
                end
                else begin
                    ProdOrderLine.SetRange(Status, "Production Order".Status);
                    ProdOrderLine.SetRange("Prod. Order No.", "Production Order"."No.");
                    if CalcRoutings or CalcComponents then begin
                        if ProdOrderLine.Find('-') then
                            repeat
                                if CalcRoutings then begin
                                    ProdOrderRtngLine.SetRange(Status, "Production Order".Status);
                                    ProdOrderRtngLine.SetRange("Prod. Order No.", "Production Order"."No.");
                                    ProdOrderRtngLine.SetRange("Routing Reference No.", ProdOrderLine."Routing Reference No.");
                                    ProdOrderRtngLine.SetRange("Routing No.", ProdOrderLine."Routing No.");
                                    if ProdOrderRtngLine.FindSet(true) then
                                        repeat
                                            ProdOrderRtngLine.SetSkipUpdateOfCompBinCodes(true);
                                            ProdOrderRtngLine.Delete(true);
                                        until ProdOrderRtngLine.Next = 0;
                                end;
                                if CalcComponents then begin
                                    ProdOrderComp.SetRange(Status, "Production Order".Status);
                                    ProdOrderComp.SetRange("Prod. Order No.", "Production Order"."No.");
                                    ProdOrderComp.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
                                    ProdOrderComp.DeleteAll(true);
                                end;
                            until ProdOrderLine.Next = 0;
                        if ProdOrderLine.Find('-') then
                            repeat
                                if CalcComponents then CheckProductionBOMStatus(ProdOrderLine."Production BOM No.", ProdOrderLine."Production BOM Version Code");
                                if CalcRoutings then CheckRoutingStatus(ProdOrderLine."Routing No.", ProdOrderLine."Routing Version Code");
                                ProdOrderLine."Due Date" := "Production Order"."Due Date";
                                if not CalcProdOrder.Calculate(ProdOrderLine, Direction, CalcRoutings, CalcComponents, false, false) then ErrorOccured := true;
                            until ProdOrderLine.Next = 0;
                    end;
                end;
                if (Direction = Direction::Backward) and ("Production Order"."Source Type" = "Production Order"."source type"::Family) then begin
                    "Production Order".SetUpdateEndDate;
                    "Production Order".Validate("Production Order"."Due Date", "Production Order"."Due Date");
                end;
                if "Production Order".Status = "Production Order".Status::Released then begin
                    ProdOrderStatusMgt.FlushProdOrder("Production Order", "Production Order".Status, WorkDate);
                    WhseProdRelease.Release("Production Order");
                    if CreateInbRqst then WhseOutputProdRelease.Release("Production Order");
                end;
                if ErrorOccured then Message(Text005, ProdOrder.TableCaption, ProdOrderLine.FieldCaption("Bin Code"));
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(Text000 + Text001 + Text002);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', comment = 'ESP="Opciones"';

                    field(Direction; Direction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Scheduling direction', comment = 'ESP="Dirección programación"';
                        OptionCaption = 'Forward,Back', comment = 'ESP="Adelante,Atrás"';
                    }
                    group(Calculate)
                    {
                        Caption = 'Calculate', comment = 'ESP="Calcular"';

                        field(CalcLines; CalcLines)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Lines', comment = 'ESP="Líneas"';

                            trigger OnValidate()
                            begin
                                if CalcLines then begin
                                    CalcRoutings := true;
                                    CalcComponents := true;
                                end;
                            end;
                        }
                        field(CalcRoutings; CalcRoutings)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Routings', comment = 'ESP="Rutas"';

                            trigger OnValidate()
                            begin
                                if not CalcRoutings then if CalcLines then Error(Text003);
                            end;
                        }
                        field(CalcComponents; CalcComponents)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Component Need', comment = 'ESP="Nec. componente"';

                            trigger OnValidate()
                            begin
                                if not CalcComponents then if CalcLines then Error(Text004);
                            end;
                        }
                    }
                    group(Warehouse)
                    {
                        Caption = 'Warehouse', comment = 'ESP="Almacén"';

                        field(CreateInbRqst; CreateInbRqst)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Create Inbound Request', comment = 'ESP="Crear petición de entrada"';
                        }
                    }
                }
            }
        }
        actions
        {
        }
        trigger OnInit()
        begin
            CalcLines := true;
            CalcRoutings := true;
            CalcComponents := true;
        end;

        trigger OnOpenPage()
        var
            rCompany: Record Company;
        begin
            rCompany.Reset();
            rCompany.Get(COMPANYNAME);
            Direction := Direction::Forward;
        end;
    }
    labels
    {
    }
    trigger OnInitReport()
    begin
        Direction := Direction::Backward;
    end;

    var
        Text000: label 'Refreshing Production Orders...\\', comment = 'ESP="Actualizando órds. producción...\\"';
        Text001: label 'Status         #1##########\', comment = 'ESP="Estado         #1##########\"';
        Text002: label 'No.            #2##########', comment = 'ESP="Nº             #2##########"';
        Text003: label 'Routings must be calculated, when lines are calculated.', comment = 'ESP="Cuando las líneas se calculan, se deben calcular las rutas."';
        Text004: label 'Component Need must be calculated, when lines are calculated.', comment = 'ESP="Necesidades de componentes deben calcularse cuando se cal. las lín."';
        CalcProdOrder: Codeunit "Calculate Prod. Order";
        CreateProdOrderLines: Codeunit "Create Prod. Order Lines";
        WhseProdRelease: Codeunit "Whse.-Production Release";
        WhseOutputProdRelease: Codeunit "Whse.-Output Prod. Release";
        Window: Dialog;
        Direction: Option Forward,Backward;
        CalcLines: Boolean;
        CalcRoutings: Boolean;
        CalcComponents: Boolean;
        CreateInbRqst: Boolean;
        Text005: label 'One or more of the lines on this %1 require special warehouse handling. The %2 for these lines has been set to blank.', comment = 'ESP="Una o más de las líneas de este %1 requieren manipulación de almacén especial. El %2 para estas líneas se ha establecido en blanco."';
        DeletePickedLinesQst: label 'Compnents for production order %1 have already been picked. Do you want to continue?', comment = 'ESP="Los componentes para el pedido de producción %1 ya se han seleccionado. ¿Desea continuar?"';

    local procedure CheckReservationExist()
    var
        ProdOrderLine2: Record "Prod. Order Line";
        ProdOrderComp2: Record "Prod. Order Component";
    begin
        // Not allowed to refresh if reservations exist
        if not (CalcLines or CalcComponents) then exit;
        ProdOrderLine2.SetRange(Status, "Production Order".Status);
        ProdOrderLine2.SetRange("Prod. Order No.", "Production Order"."No.");
        if ProdOrderLine2.Find('-') then
            repeat
                if CalcLines then begin
                    ProdOrderLine2.CalcFields("Reserved Qty. (Base)");
                    if ProdOrderLine2."Reserved Qty. (Base)" <> 0 then if ShouldCheckReservedQty(ProdOrderLine2."Prod. Order No.", 0, Database::"Prod. Order Line", ProdOrderLine2.Status.AsInteger(), ProdOrderLine2."Line No.", Database::"Prod. Order Component") then ProdOrderLine2.TestField("Reserved Qty. (Base)", 0);
                end;
                if CalcComponents then begin
                    ProdOrderComp2.SetRange(Status, ProdOrderLine2.Status);
                    ProdOrderComp2.SetRange("Prod. Order No.", ProdOrderLine2."Prod. Order No.");
                    ProdOrderComp2.SetRange("Prod. Order Line No.", ProdOrderLine2."Line No.");
                    ProdOrderComp2.SetAutocalcFields("Reserved Qty. (Base)");
                    if ProdOrderComp2.Find('-') then begin
                        repeat
                            if ProdOrderComp2."Reserved Qty. (Base)" <> 0 then if ShouldCheckReservedQty(ProdOrderComp2."Prod. Order No.", ProdOrderComp2."Line No.", Database::"Prod. Order Component", ProdOrderComp2.Status.AsInteger(), ProdOrderComp2."Prod. Order Line No.", Database::"Prod. Order Line") then ProdOrderComp2.TestField("Reserved Qty. (Base)", 0);
                        until ProdOrderComp2.Next = 0;
                    end;
                end;
            until ProdOrderLine2.Next = 0;
    end;

    local procedure ShouldCheckReservedQty(ProdOrderNo: Code[20]; LineNo: Integer; SourceType: Integer; Status: Option; ProdOrderLineNo: Integer; SourceType2: Integer): Boolean
    var
        ReservEntry: Record "Reservation Entry";
    begin
        begin
            ReservEntry.SetCurrentkey(ReservEntry."Source ID", ReservEntry."Source Ref. No.", ReservEntry."Source Type", ReservEntry."Source Subtype", ReservEntry."Source Batch Name");
            ReservEntry.SetRange(ReservEntry."Source Batch Name", '');
            ReservEntry.SetRange(ReservEntry."Reservation Status", ReservEntry."reservation status"::Reservation);
            ReservEntry.SetRange(ReservEntry."Source ID", ProdOrderNo);
            ReservEntry.SetRange(ReservEntry."Source Ref. No.", LineNo);
            ReservEntry.SetRange(ReservEntry."Source Type", SourceType);
            ReservEntry.SetRange(ReservEntry."Source Subtype", Status);
            ReservEntry.SetRange(ReservEntry."Source Prod. Order Line", ProdOrderLineNo);
            if ReservEntry.FindFirst then begin
                ReservEntry.Get(ReservEntry."Entry No.", not ReservEntry.Positive);
                exit(not ((ReservEntry."Source Type" = SourceType2) and (ReservEntry."Source ID" = ProdOrderNo) and (ReservEntry."Source Subtype" = Status)));
            end;
        end;
        exit(false);
    end;

    local procedure CheckProductionBOMStatus(ProdBOMNo: Code[20]; ProdBOMVersionNo: Code[20])
    var
        ProductionBOMHeader: Record "Production BOM Header";
        ProductionBOMVersion: Record "Production BOM Version";
    begin
        if ProdBOMNo = '' then exit;
        if ProdBOMVersionNo = '' then begin
            ProductionBOMHeader.Get(ProdBOMNo);
            ProductionBOMHeader.TestField(Status, ProductionBOMHeader.Status::Certified);
        end
        else begin
            ProductionBOMVersion.Get(ProdBOMNo, ProdBOMVersionNo);
            ProductionBOMVersion.TestField(Status, ProductionBOMVersion.Status::Certified);
        end;
    end;

    local procedure CheckRoutingStatus(RoutingNo: Code[20]; RoutingVersionNo: Code[20])
    var
        RoutingHeader: Record "Routing Header";
        RoutingVersion: Record "Routing Version";
    begin
        if RoutingNo = '' then exit;
        if RoutingVersionNo = '' then begin
            RoutingHeader.Get(RoutingNo);
            RoutingHeader.TestField(Status, RoutingHeader.Status::Certified);
        end
        else begin
            RoutingVersion.Get(RoutingNo, RoutingVersionNo);
            RoutingVersion.TestField(Status, RoutingVersion.Status::Certified);
        end;
    end;

    procedure InitializeRequest(Direction2: Option Forward,Backward; CalcLines2: Boolean; CalcRoutings2: Boolean; CalcComponents2: Boolean; CreateInbRqst2: Boolean)
    begin
        Direction := Direction2;
        CalcLines := CalcLines2;
        CalcRoutings := CalcRoutings2;
        CalcComponents := CalcComponents2;
        CreateInbRqst := CreateInbRqst2;
    end;

    local procedure IsComponentPicked(ProdOrder: Record "Production Order"): Boolean
    var
        ProdOrderComp: Record "Prod. Order Component";
    begin
        ProdOrderComp.SetRange(Status, ProdOrder.Status);
        ProdOrderComp.SetRange("Prod. Order No.", ProdOrder."No.");
        ProdOrderComp.SetFilter("Qty. Picked", '<>0');
        exit(not ProdOrderComp.IsEmpty);
    end;
}
