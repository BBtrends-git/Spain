codeunit 51453 "SGA Events"
{
    Permissions = tabledata "Warehouse Shipment Header" = rm,
                tabledata "Warehouse Shipment Line" = rm,
                tabledata "Sales Shipment Header" = rm,
                tabledata "Sales Shipment Line" = rm;

    trigger OnRun();
    begin
    end;

    //>> SGA Item Events
    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyItemEvent(var Rec: Record Item; var xRec: Record Item; RunTrigger: Boolean)
    var
        cuSGAManagement: Codeunit "SGA Management";
    begin
        if cuSGAManagement.IsSGAEnabled then begin
            if Rec."SGA Item Management" then begin
                Rec."SGA Requires Modification" := Rec.SGAItemModification;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Unit of Measure", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyItemUnitOfMeasure(var Rec: Record "Item Unit of Measure"; var xRec: Record "Item Unit of Measure"; RunTrigger: Boolean)
    var
        cuSGAManagement: Codeunit "SGA Management";
        cuSGAInterfaces: Codeunit "SGA Interfaces";
        rItem: Record Item;
    begin
        if cuSGAManagement.IsSGAEnabled then begin
            rItem.Reset();
            if rItem.Get(Rec."Item No.") then begin
                if rItem."SGA Item Management" then begin
                    clear(cuSGAInterfaces);
                    cuSGAInterfaces.GestionProducto(rItem);
                    Clear(cuSGAInterfaces);
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Identifier", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyItemIdentifier(var Rec: Record "Item Identifier"; var xRec: Record "Item Identifier"; RunTrigger: Boolean)
    var
        cuSGAManagement: Codeunit "SGA Management";
        cuSGAInterfaces: Codeunit "SGA Interfaces";
        rItem: Record Item;
    begin
        if cuSGAManagement.IsSGAEnabled then begin
            rItem.Reset();
            if rItem.Get(Rec."Item No.") then begin
                if rItem."SGA Item Management" then begin
                    clear(cuSGAInterfaces);
                    cuSGAInterfaces.GestionProducto(rItem);
                    Clear(cuSGAInterfaces);
                end;
            end;
        end;
    end;
    //<<

    //>> SGA Ajustes Inventario - diarios de producto
    [EventSubscriber(ObjectType::page, page::"Adjust Inventory", 'OnBeforeValidateEvent', 'NewInventory', false, false)]
    local procedure OnBeforeActionEventPostAndPrintLocation(var Rec: Record Location)
    var
        cuSGAManagement: Codeunit "SGA Management";
        Error01: Label 'There are lines with SGA warehouse', comment = 'ESP="Existen líneas con almacén SGA."';
    begin
        if cuSGAManagement.IsSGAEnabled() then
            if rec."SGA Enabled" then
                Error(Error01);
    end;

    [EventSubscriber(ObjectType::page, page::"Item Journal", 'OnBeforeActionEvent', 'Post', false, false)]
    local procedure OnBeforeActionEventPostItemJournal(var Rec: Record "Item Journal Line")
    var
        cuSGAManagement: Codeunit "SGA Management";
        Error01: Label 'There are lines with SGA warehouse', comment = 'ESP="Existen líneas con almacén SGA."';
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            Clear(cuSGAManagement);
            IF cuSGAManagement.AlmRegManualDiario(Rec) THEN Error(Error01);
        end;
    end;

    [EventSubscriber(ObjectType::page, page::"Item Journal", 'OnBeforeActionEvent', 'Post and &Print', false, false)]
    local procedure OnBeforeActionEventPostAndPrintItemJournal(var Rec: Record "Item Journal Line")
    var
        cuSGAManagement: Codeunit "SGA Management";
        Error01: Label 'There are lines with SGA warehouse', comment = 'ESP="Existen líneas con almacén SGA."';
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            Clear(cuSGAManagement);
            IF cuSGAManagement.AlmRegManualDiario(Rec) THEN Error(Error01);
        end;
    end;
    //<<

    //>> SGA Purchase Events
    [EventSubscriber(ObjectType::Table, database::"Purchase Line", 'OnAfterAssignItemValues', '', false, false)]
    local procedure OnAfterAssignItemValues(CurrentFieldNo: Integer; Item: Record Item; var PurchLine: Record "Purchase Line")
    var
        cuSGAManagement: Codeunit "SGA Management";
        rLocation: Record Location;
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            if rLocation.get(PurchLine."Location Code") then
                IF (rLocation."SGA Enabled") and not (Item."SGA Item Management") then
                    PurchLine."Location Code" := '';
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Line", 'OnBeforeValidateEvent', 'Location Code', false, false)]
    local procedure OnBeforeValidateEvent(CurrFieldNo: Integer; var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line")
    var
        cuSGAManagement: Codeunit "SGA Management";
        rLocation: Record Location;
        Error01: Label 'Warehouse %1 cannot be used because it is part of the SGA',
        Comment = 'ESP="El almacén %1 no se puede usar por ser de SGA"';
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            IF (Rec.Type = Rec.Type::Item) THEN
                IF Rec."Document Type" IN [Rec."Document Type"::Invoice, Rec."Document Type"::"Credit Memo"] THEN
                    IF not cuSGAManagement.SGACantUseLocation(Rec."Location Code") THEN
                        Error(Error01, Rec."Location Code");
        end;
    end;

    [EventSubscriber(ObjectType::page, page::"Purchase Order", 'OnClosePageEvent', '', false, false)]
    local procedure OnClosePageEvent(var Rec: Record "Purchase Header")
    var
        cuSGAManagement: Codeunit "SGA Management";
        cuSGAInterfaces: Codeunit "SGA Interfaces";
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            if rec."SGA Modified" then
                if Rec."SGA Status" <> Rec."SGA Status"::" " then
                    cuSGAInterfaces.GestionPedidoCompra(rec."No.");
            CLEAR(cuSGAInterfaces);
        end;
    end;

    [EventSubscriber(ObjectType::page, page::"Purchase Order Subform", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure OnAfterValidateEventQuantityPurchaseOrder(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line")
    var
        cuSGAManagement: Codeunit "SGA Management";
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            IF xRec.Quantity <> rec.Quantity THEN
                rec.SGASent();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Purch.-Post (Yes/No)", 'OnAfterConfirmPost', '', false, false)]
    local procedure OnAfterConfirmPost(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)

    var
        cuSGAManagement: Codeunit "SGA Management";
        Error01: Label 'It is not possible to receive or send a SGA warehouse document.',
                Comment = 'ESP="No se puede recibir ni enviar un documento de almacén SGA"';
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            if PurchaseHeader.Receive or PurchaseHeader.Ship then begin
                Clear(cuSGAManagement);
                if cuSGAManagement.AlmRegPedCompra(PurchaseHeader) then
                    Error(Error01);
                clear(cuSGAManagement);
            end;
        end;
        //
    end;
    //<<

    //>> SGA Sales Events
    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnBeforeValidateEvent', 'Location Code', false, false)]
    local procedure OnBeforeValidateEventLocationCode(CurrFieldNo: Integer; var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        cuSGAManagement: Codeunit "SGA Management";
        Error01: Label 'Warehouse %1 cannot be used because it is part of the SGA.',
                comment = 'ESP="El almacén %1 no se puede usar por ser de SGA"';
        rLocation: Record Location;
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            if (CurrFieldNo = Rec.FIELDNO("Location Code")) AND (Rec.Type = Rec.Type::Item) then
                if rec."Document Type" in [Rec."Document Type"::Invoice, Rec."Document Type"::"Credit Memo"] then
                    IF not cuSGAManagement.SGACantUseLocation(Rec."Location Code") THEN
                        ERROR(Error01, rec."Location Code");
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterInitHeaderDefaults', '', false, false)]
    local procedure OnBeforeInitHeaderLocactionCode(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    var
        cuSGAManagement: Codeunit "SGA Management";
        rLocation: Record Location;
        rCompanyInformation: Record "Company Information";
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            if SalesLine."Document Type" IN [SalesLine."Document Type"::Invoice, SalesLine."Document Type"::"Credit Memo"] then
                if NOT cuSGAManagement.SGACantUseLocation(SalesHeader."Location Code") then
                    SalesLine."Location Code" := '';
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post (Yes/No)", 'OnAfterConfirmPost', '', false, false)]
    local procedure OnAfterConfirmPostSales(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        cuSGAManagement: Codeunit "SGA Management";
        Error01: Label 'You cannot receive or send a document from the WMS warehouse.',
        Comment = 'ESP="No se puede recibir ni enviar un documento de almacén SGA"';
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            Clear(cuSGAManagement);
            // BBT Controlar que no se pueda registrar desde una devolución  directamente en un almacén SGA
            if SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order" then
                if SalesHeader.Receive OR SalesHeader.Ship then begin
                    IF cuSGAManagement.AlmRegDevVenta(SalesHeader) then Error(Error01);
                    Clear(cuSGAManagement);
                end;
            // BBT Controlar que no se pueda registrar desde un ABONO directamente en un almacén SGA
            if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then BEGIN
                if cuSGAManagement.AlmRegDevVenta(SalesHeader) then ERROR(Error01);
                Clear(cuSGAManagement);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Release Sales Document", 'OnCodeOnAfterCheckCustomerCreated', '', false, false)]
    local procedure OnCodeOnAfterCheckCustomerCreated(PreviewMode: Boolean; var IsHandled: Boolean; var SalesHeader: Record "Sales Header")
    var
        cuSGAManagement: Codeunit "SGA Management";
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
                SalesHeader.TestField(SalesHeader."Payment Terms Code");
                SalesHeader.TestField(SalesHeader."Payment Method Code");
            end;
        end;
    end;

    [EventSubscriber(ObjectType::page, page::"Sales Return Order Subform", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure OnAfterValidateEvent(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        cuSGAManagement: Codeunit "SGA Management";
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            IF xRec.Quantity <> rec.Quantity THEN rec.SGASent();
        end;
    end;

    //>>BBT 06/07/2026  SalesShptHeader no es parametro 'var' por lo tanto no se actualiza la fecha de registro
    /*
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnBeforeSalesShptLineInsert', '', false, false)]
    local procedure OnBeforeSalesShptLineInsert(ItemLedgShptEntryNo: Integer; var SalesShptLine: Record "Sales Shipment Line"; SalesShptHeader: Record "Sales Shipment Header")
    var
        cuSGAManagement: Codeunit "SGA Management";
        rWarehouseShipmentLine: Record "Warehouse Shipment Line";
        rSalesShipmentHeader: Record "Sales Shipment Header";
    begin
        if cuSGAManagement.IsSGAEnabled() then begin

            SalesShptHeader."Posting Date" := WorkDate();
            SalesShptHeader."Document Date" := WorkDate();
        end;
    end;
    */
    //<<

    //>> BBT 11/02/2026.    Evita imprimir el albarán de forma automática para el almacén STOCK.
    //                      El proceso se ejecuta en 'Background' desde la cola de proyectos.
    //                      Esto se hace porque salian todos por la impresora del almacén de MARGA.
    [EventSubscriber(ObjectType::Table, database::"Report Selections", 'OnBeforePrintDocument', '', true, true)]
    local procedure OnBeforePrintDocument(TempReportSelections: Record "Report Selections" temporary; IsGUI: Boolean; var RecVarToPrint: Variant; var IsHandled: Boolean)
    var
        cuSGAManagement: Codeunit "SGA Management";
        rLocation: record Location;
        rReportSelections: Record "Report Selections";
        rSalesShipmentHeader: Record "Sales Shipment Header";
        rSalesShipmentLine: Record "Sales Shipment Line";
        ReportID: Integer;
        ResultCode: Code[20];

    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            if CurrentClientType = ClientType::Background then begin
                // Recuperamos el código del almacén de Sta.Perpetua (En principo STOCK)
                rLocation.Reset();
                rLocation.setrange("SGA Enabled", true);
                rLocation.SetRange("SGA Warehouse Code", Format('000')); // Codigo del almacén en el SGA (TWO)
                rLocation.SetRange("Require Shipment", true);
                rLocation.SetRange("SGA Quality", false);
                if rLocation.FindFirst() then;

                // Informe del albarán de ventas.
                Clear(ReportID);
                rReportSelections.Reset();
                rReportSelections.SetRange(Usage, rReportSelections.Usage::"S.Shipment");
                if rReportSelections.FindFirst() then
                    ReportID := rReportSelections."Report ID";
                // Comprobamos que el informe es el del albarán de ventas
                if (TempReportSelections.Usage = TempReportSelections.Usage::"S.Shipment") and
                    (TempReportSelections."Report ID" = ReportID) then begin
                    //Código del albarán                  
                    Clear(ResultCode);
                    ResultCode := CopyStr(Format(RecVarToPrint), 1, 10);
                    //Recuperamos el albarán y miramos el almacén  
                    rSalesShipmentHeader.Reset();
                    rSalesShipmentHeader.SetRange("No.", ResultCode);
                    if rSalesShipmentHeader.FindFirst() then begin
                        rSalesShipmentLine.Reset();
                        rSalesShipmentLine.SetRange("Document No.", rSalesShipmentHeader."No.");
                        rSalesShipmentLine.SetRange(Type, rSalesShipmentLine.Type::Item);
                        if rSalesShipmentLine.FindFirst() then begin
                            if rSalesshipmentLine."Location Code" = rLocation.Code then
                                IsHandled := true;            // Se fuerza que la impresión sea manual.
                        end;
                    end;
                end;
            end;
        end;
    end;
    //<<

    //>> SGA Transfer Events
    [EventSubscriber(ObjectType::Table, database::"Transfer Header", 'OnBeforeValidateTransferFromCode', '', false, false)]
    local procedure OnBeforeValidateTransferFromCode(var HideValidationDialog: Boolean; var IsHandled: Boolean; var TransferHeader: Record "Transfer Header"; var xTransferHeader: Record "Transfer Header")
    var
        cuSGAManagement: Codeunit "SGA Management";
        rLocation: Record Location;
        Confirmed: Boolean;
        rLocationFrom: Record Location;
        rLocationTo: Record Location;
        ERROR01: Label 'The two warehouses cannot be of type SGA',
                Comment = 'ESP="Los dos almacenes no pueden ser de SGA"';
    begin
        if cuSGAManagement.IsSGAEnabled() then
            if (TransferHeader."Transfer-from Code" <> '') AND (TransferHeader."Transfer-to Code" <> '') then begin
                rLocationFrom.Get(TransferHeader."Transfer-from Code");
                rLocationTo.Get(TransferHeader."Transfer-to Code");
                if not (rLocationFrom."SGA Fictitious Movement" and rLocationTo."SGA Fictitious Movement") then
                    if rLocationFrom."SGA Enabled" and rLocationTo."SGA Enabled" then
                        ERROR('Los dos almacenes no pueden ser de SGA');
            end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Transfer Header", 'OnBeforeValidateTransferToCode', '', false, false)]
    local procedure OnBeforeValidateTransferToCode(var HideValidationDialog: Boolean; var IsHandled: Boolean; var TransferHeader: Record "Transfer Header"; var xTransferHeader: Record "Transfer Header")
    var
        cuSGAManagement: Codeunit "SGA Management";
        rLocation: Record Location;
        Confirmed: Boolean;
        rLocationFrom: Record Location;
        rLocationTo: Record Location;
        ERROR01: Label 'The two warehouses cannot be of type SGA',
                Comment = 'ESP="Los dos almacenes no pueden ser de SGA"';
    begin
        if cuSGAManagement.IsSGAEnabled() then
            if (TransferHeader."Transfer-from Code" <> '') AND (TransferHeader."Transfer-to Code" <> '') then begin
                rLocationFrom.Get(TransferHeader."Transfer-from Code");
                rLocationTo.Get(TransferHeader."Transfer-to Code");
                if not (rLocationFrom."SGA Fictitious Movement" and rLocationTo."SGA Fictitious Movement") then
                    if rLocationFrom."SGA Enabled" and rLocationTo."SGA Enabled" then
                        ERROR('Los dos almacenes no pueden ser de SGA');
            end;
    end;

    [EventSubscriber(ObjectType::page, page::"Transfer Order Subform", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure OnAfterValidateEventQuantity(var Rec: Record "Transfer Line"; var xRec: Record "Transfer Line")
    var
        cuSGAManagement: Codeunit "SGA Management";
    begin
        if cuSGAManagement.IsSGAEnabled() then
            if xRec.Quantity <> Rec.Quantity then Rec.SGAEnviar;
    end;

    [EventSubscriber(ObjectType::page, page::"Transfer Order Subform", 'OnAfterValidateEvent', 'Qty. to Ship', false, false)]
    local procedure OnAfterValidateEventQuantityToShip(var Rec: Record "Transfer Line"; var xRec: Record "Transfer Line")
    var
        cuSGAManagement: Codeunit "SGA Management";
    begin
        if cuSGAManagement.IsSGAEnabled() then
            if xRec."Qty. to Ship" <> Rec."Qty. to Ship" then Rec.SGAEnviar;
    end;

    [EventSubscriber(ObjectType::page, page::"Transfer Order Subform", 'OnAfterValidateEvent', 'Qty. to Receive', false, false)]
    local procedure OnAfterValidateEventQuantityToReceive(var Rec: Record "Transfer Line"; var xRec: Record "Transfer Line")
    var
        cuSGAManagement: Codeunit "SGA Management";
    begin
        if cuSGAManagement.IsSGAEnabled() then
            if xRec."Qty. to Receive" <> Rec."Qty. to Receive" then Rec.SGAEnviar;
    end;

    [EventSubscriber(ObjectType::Table, database::"Transfer Line", 'OnAfterUpdateWithWarehouseShipReceive', '', false, false)]
    local procedure OnAfterUpdateWithWarehouseShipReceive(var TransferLine: Record "Transfer Line")
    var
        rLocation: Record Location;
        cuSGAManagement: Codeunit "SGA Management";
    begin
        if cuSGAManagement.IsSGAEnabled() then
            if rLocation.Get(TransferLine."Transfer-from Code") and rLocation."SGA Enabled" then
                TransferLine.Validate("Qty. to Ship", TransferLine."Outstanding Quantity");
    end;

    [EventSubscriber(ObjectType::Table, database::"Transfer Line", 'OnBeforeCheckWarehouse', '', false, false)]
    local procedure OnBeforeCheckWarehouse(Location: Record Location; Receive: Boolean; TransferLine: Record "Transfer Line"; var IsHandled: Boolean)
    var
        ShowDialog: Option " ",Message,Error;
        DialogText: Text[50];
        cuWhseValidateSourceLine: Codeunit "Whse. Validate Source Line";
        Text003: Label 'Warehouse %1 is required for %2 = %3', Comment = 'ESP="Almacén %1 es requerido para %2 = %3"';
        cuSGAManagement: Codeunit "SGA Management";
    begin
        //Para almacenes SGA, validar automaticamente la cantidad a enviar si es almacén requerido, y no mostrar mensajes. Dejamos el aviso de error.
        if cuSGAManagement.IsSGAEnabled() then begin
            if Location."SGA Enabled" then begin
                if Location."Directed Put-away and Pick" then begin
                    ShowDialog := ShowDialog::Error;
                    if Receive then
                        DialogText := Location.GetRequirementText(Location.FieldNo("Require Receive"))
                    else
                        DialogText := Location.GetRequirementText(Location.FieldNo("Require Shipment"));
                end
                else begin
                    if Receive and (Location."Require Receive" or Location."Require Put-away") then begin
                        if cuWhseValidateSourceLine.WhseLinesExist(DATABASE::"Transfer Line", 1, TransferLine."Document No.", TransferLine."Line No.", 0, TransferLine.Quantity) then
                            ShowDialog := ShowDialog::Error
                        else if Location."Require Receive" then ShowDialog := ShowDialog::Message;
                        if Location."Require Receive" then
                            DialogText := Location.GetRequirementText(Location.FieldNo("Require Receive"))
                        else
                            DialogText := Location.GetRequirementText(Location.FieldNo("Require Put-away"));
                    end;
                    if not Receive and (Location."Require Shipment" or Location."Require Pick") then begin
                        if cuWhseValidateSourceLine.WhseLinesExist(DATABASE::"Transfer Line", 0, TransferLine."Document No.", TransferLine."Line No.", 0, TransferLine.Quantity) then
                            ShowDialog := ShowDialog::Error
                        else if Location."Require Shipment" then ShowDialog := ShowDialog::Message;
                        if Location."Require Shipment" then
                            DialogText := Location.GetRequirementText(Location.FieldNo("Require Shipment"))
                        else
                            DialogText := Location.GetRequirementText(Location.FieldNo("Require Pick"));
                    end;
                end;
                case ShowDialog of
                    ShowDialog::Error:
                        Error(Text003, DialogText, TransferLine.FieldCaption(TransferLine."Line No."), TransferLine."Line No.");
                end;
                IsHandled := true;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::codeunit, codeunit::"TransferOrder-Post (Yes/No)", 'OnCodeOnBeforePostTransferOrder', '', false, false)]
    local procedure OnCodeOnBeforePostTransferOrder(var TransHeader: Record "Transfer Header"; var TransferOrderPost: Enum "Transfer Order Post"; var DefaultNumber: Integer; var IsHandled: Boolean; var PostBatch: Boolean; var Selection: Option)
    var
        cuSGAManagement: Codeunit "SGA Management";
        cuSGAInterfaces: Codeunit "SGA Interfaces";
        cuGenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        cuTransferOrderPostReceipt: Codeunit "TransferOrder-Post Receipt";
        cuTransferOrderPostShipment: Codeunit "TransferOrder-Post Shipment";
        cuTransferOrderPostTransfer: Codeunit "TransferOrder-Post Transfer";
        rTempTransferLine: Record "Transfer Line" temporary;
        rLocation: Record Location;
        rLocation1: Record Location;
        rLocation2: Record Location;
        rItem: Record Item;
        rTransferLine: Record "Transfer Line";
        rInventorySetup: Record "Inventory Setup";
        Error01: Label 'The transfer request has not been released', Comment = 'ESP="El pedido de transferencia no está lanzado"';
        Error02: Label 'The transfer order contains product %1 without SGA management', Comment = 'ESP="El pedido de transferencia contiene producto %1 sin gestión SGA"';
        Error03: Label 'No warehouse has SGA management', Comment = 'ESP="Ningún almacén tiene gestión SGA"';
        Error04: Label 'Transfer order pending confirmation by the SGA', Comment = 'ESP="Pedido de transferencia pendiente de confirmar envío por el SGA"';
        Error05: Label 'The material receipt must be processed by the SGA', Comment = 'ESP="La recepción del material se debe de realizar por el SGA"';
        Text000: Label '&Ship,&Receive', comment = 'ESP="Enviar,Recibir"';
        TransNormal: Boolean;
        PostReceipt, PostShipment, PostTransfer : Boolean;
        Selection2: Option " ",Shipment,Receipt;
        Tipo: Integer;

    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            IsHandled := true;
            rTempTransferLine.Reset();
            rTempTransferLine.DeleteAll();

            if TransHeader.Status <> TransHeader.Status::Released then
                Error(Error01);

            rLocation1.GET(TransHeader."Transfer-from Code");
            rLocation2.GET(TransHeader."Transfer-to Code");
            TransNormal := (not rLocation1."SGA Enabled" and not rLocation2."SGA Enabled") OR
                            ((rLocation1."SGA Fictitious Movement" and rLocation2."SGA Fictitious Movement") and
                            (rLocation1."SGA Warehouse Code" = rLocation2."SGA Warehouse Code"));
            if not TransNormal then begin
                if not rLocation1."SGA Enabled" and not rLocation2."SGA Enabled" then
                    Error(Error03);

                rTransferLine.SetRange("Document No.", TransHeader."No.");
                rTransferLine.SetRange("Derived From Line No.", 0);
                if rTransferLine.FindSet() then
                    repeat
                        if rItem.GET(rTransferLine."Item No.") then
                            if not rItem."SGA Item Management" then
                                Error(StrSubstNo(Error02, rItem."No."));

                        rTempTransferLine := rTransferLine;
                        rTempTransferLine.Insert();
                    until rTransferLine.NEXT = 0;
            end;
            rInventorySetup.Get();
            case true of
                (TransHeader."Direct Transfer") and (rInventorySetup."Direct Transfer Posting" = rInventorySetup."Direct Transfer Posting"::"Receipt and Shipment"):
                    begin
                        PostShipment := true;
                        PostReceipt := true;
                    end;
                (TransHeader."Direct Transfer") and (rInventorySetup."Direct Transfer Posting" = rInventorySetup."Direct Transfer Posting"::"Direct Transfer"):
                    PostTransfer := true;
                PostBatch:
                    begin
                        PostShipment := TransferOrderPost = TransferOrderPost::Ship;
                        PostReceipt := TransferOrderPost = TransferOrderPost::Receive;
                    end;
                else begin
                    if DefaultNumber = 0 then DefaultNumber := 1;
                    Selection := StrMenu(Text000, DefaultNumber);
                    PostShipment := Selection = Selection2::Shipment;
                    PostReceipt := Selection = Selection2::Receipt;
                end;
            end;
            if PostShipment then begin
                cuTransferOrderPostShipment.SetHideValidationDialog(PostBatch);
                if TransNormal then
                    cuTransferOrderPostShipment.Run(TransHeader)
                ELSE begin
                    if rLocation.GET(TransHeader."Transfer-from Code") AND rLocation."SGA Enabled" then begin
                        if TransHeader."SGA Status" <> TransHeader."SGA Status"::" " then
                            Error(Error04);
                        Tipo := 0;
                        cuSGAManagement.CheckStockTransfer(TransHeader."No.");
                        CLEAR(cuSGAInterfaces);
                        cuSGAInterfaces.EnvioSGA(TransHeader, Tipo, rTempTransferLine, FALSE);
                        CLEAR(cuSGAInterfaces);
                    end
                    ELSE begin
                        Tipo := 1;
                        cuTransferOrderPostShipment.Run(TransHeader);
                        cuSGAInterfaces.EnvioSGA(TransHeader, Tipo, rTempTransferLine, FALSE);
                        CLEAR(cuSGAInterfaces);
                    end;
                end;
            end;
            if PostReceipt then begin
                rLocation1.GET(TransHeader."Transfer-from Code");
                rLocation2.GET(TransHeader."Transfer-to Code");
                if not TransNormal and rLocation2."SGA Enabled" then
                    Error(Error05);

                cuTransferOrderPostReceipt.SetHideValidationDialog(PostBatch);
                cuTransferOrderPostReceipt.Run(TransHeader);
            end;
            if PostTransfer then begin
                cuTransferOrderPostTransfer.Run(TransHeader);
            end;
        end;
    end;
    //<<

    //>> SGA Warehouse Events
    [EventSubscriber(ObjectType::codeunit, codeunit::"Get Source Doc. Outbound", 'OnBeforeGetSingleOutboundDoc', '', false, false)]
    local procedure OnBeforeGetSingleOutboundDoc(var IsHandled: Boolean; var WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    var
        cuSGAManagement: Codeunit "SGA Management";
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            WarehouseShipmentHeader.CALCFIELDS("SGA Destination Type", "SGA Destination No.");
        end;
    end;

    [EventSubscriber(ObjectType::codeunit, codeunit::"Get Source Doc. Outbound", 'OnGetSingleOutboundDocOnSetFilterGroupFilters', '', false, false)]
    local procedure OnGetSingleOutboundDocOnSetFilterGroupFilters(var WhseRqst: Record "Warehouse Request"; WhseShptHeader: Record "Warehouse Shipment Header")
    var
        cuSGAManagement: Codeunit "SGA Management";
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            WhseRqst.SETRANGE("Destination Type", WhseShptHeader."SGA Destination Type");
            WhseRqst.SETRANGE("Destination No.", WhseShptHeader."SGA Destination No.");
        end;
    end;
    /*
        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesShptLineInsert', '', false, false)]
        //local procedure OnBeforeSalesShptLineInsert(var SalesShptHeader: Record "Sales Shipment Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; var IsHandled: Boolean; var TempWhseRcptHeader: Record "Warehouse Receipt Header" temporary; WhseReceive: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header" temporary; WhseShip: Boolean; InvtPickPutaway: Boolean)
        local procedure OnBeforeSalesShptLineInsert(var SalesShptLine: Record "Sales Shipment Line"; SalesShptHeader: Record "Sales Shipment Header"; SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean; PostedWhseShipmentLine: Record "Posted Whse. Shipment Line"; SalesHeader: Record "Sales Header"; WhseShip: Boolean; WhseReceive: Boolean; ItemLedgShptEntryNo: Integer; xSalesLine: record "Sales Line"; var TempSalesLineGlobal: record "Sales Line" temporary; var IsHandled: Boolean)

        var
            cuSGAManagement: Codeunit "SGA Management";
            rWarehouseShipmentLine: Record "Warehouse Shipment Line";
            rSalesShipmentLine: Record "Sales Shipment Line";
        begin
            if cuSGAManagement.IsSGAEnabled() then
                if WhseShip then begin
                    rSalesShipmentLine.Reset();
                    rSalesShipmentLine.SetRange("Document No.", SalesShptHeader."No.");
                    rSalesShipmentLine.SetRange("Transaction Type", Format(11));
                    rSalesShipmentLine.SetRange("Type", rSalesShipmentLine.Type::Item);
                    rSalesShipmentLine.SetFilter(Quantity, '<>%1', 0);
                    if rSalesShipmentLine.FindFirst() then begin
                        rWarehouseShipmentLine.Reset();
                        rWarehouseShipmentLine.SetRange("No.", TempWhseShptHeader."No.");
                        rWarehouseShipmentLine.SetRange("Item No.", rSalesShipmentLine."No.");
                        rWarehouseShipmentLine.SetFilter(Quantity, '<>%1', 0);
                        if rWarehouseShipmentLine.FindFirst() then
                            SalesShptHeader."SGA Warehouse Delivery No" := rWarehouseShipmentLine."SGA Warehouse Delivery Number";
                    end;
                end;
        end;

                rWarehouseShipmentLine: Record "Warehouse Shipment Line";
        rSalesShipmentHeader: Record "Sales Shipment Header";
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            // SalesShptHeader no es parametro 'var' por lo tanto no se transmite
            //SalesShptHeader."Posting Date" := WorkDate();
            //SalesShptHeader."Document Date" := WorkDate();
            //
            rWarehouseShipmentLine.Reset();
            rWarehouseShipmentLine.SetRange("No.", SalesShptLine."Document No.");
            rWarehouseShipmentLine.SetRange("Item No.", SalesShptLine."No.");
            rWarehouseShipmentLine.SetFilter(Quantity, '<>%1', 0);
            if rWarehouseShipmentLine.FindFirst() then begin
                rSalesShipmentHeader."SGA Warehouse Delivery No" := rWarehouseShipmentLine."SGA Warehouse Delivery Number";
                rSalesShipmentHeader."Posting Date" := WorkDate();
                rSalesShipmentHeader."Document Date" := WorkDate();
                rSalesShipmentHeader.Modify();
            end;
        end;
    */
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnBeforePostUpdateWhseDocuments', '', false, false)]
    local procedure OnBeforePostUpdateWhseDocuments(var WhseShptHeader: Record "Warehouse Shipment Header"; var TempWarehouseShipmentLine: Record "Warehouse Shipment Line" temporary)
    var
        cuSGAManagement: Codeunit "SGA Management";
        rPostedWhseShipmentHeader: Record "Posted Whse. Shipment Header";
        rPostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        rSalesShipmentHeader: Record "Sales Shipment Header";
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            WhseShptHeader."SGA Warehouse Delivery Number" := TempWarehouseShipmentLine."SGA Warehouse Delivery Number";
            WhseShptHeader.Modify();

            rPostedWhseShipmentHeader.Reset();
            rPostedWhseShipmentHeader.SetCurrentKey("Whse. Shipment No.");
            rPostedWhseShipmentHeader.SetRange("Whse. Shipment No.", WhseShptHeader."No.");
            if rPostedWhseShipmentHeader.FindFirst() then begin
                rPostedWhseShipmentHeader."SGA Warehouse Delivery Number" := WhseShptHeader."SGA Warehouse Delivery Number";
                rPostedWhseShipmentHeader.Modify();

                rPostedWhseShipmentLine.Reset();
                rPostedWhseShipmentLine.SetRange("No.", rPostedWhseShipmentHeader."No.");
                rPostedWhseShipmentLine.SetRange("Source Type", 37);
                rPostedWhseShipmentLine.SetRange("Source Subtype", rPostedWhseShipmentLine."Source Subtype"::"1");
                rPostedWhseShipmentLine.SetRange("Source Document", rPostedWhseShipmentLine."Source Document"::"Sales Order");
                rPostedWhseShipmentLine.SetRange("Posted Source Document", rPostedWhseShipmentLine."Posted Source Document"::"Posted Shipment");
                rPostedWhseShipmentLine.SetFilter("Item No.", '<>%1', '');
                rPostedWhseShipmentLine.SetFilter(Quantity, '<>%1', 0);
                if rPostedWhseShipmentLine.FindFirst() then begin
                    rSalesShipmentHeader.Reset();
                    rSalesShipmentHeader.SetRange("No.", rPostedWhseShipmentLine."Posted Source No.");
                    rSalesShipmentHeader.SetRange("Order No.", rPostedWhseShipmentLine."Source No.");
                    if rSalesShipmentHeader.FindFirst() then begin
                        rSalesShipmentHeader."SGA Warehouse Delivery No" := WhseShptHeader."SGA Warehouse Delivery Number";
                        rSalesShipmentHeader.Modify();
                    end;
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::codeunit, codeunit::"Whse.-Post Shipment", 'OnCreatePostedShptLineOnBeforePostWhseJnlLine', '', false, false)]
    local procedure OnCreatePostedShptLineOnBeforePostWhseJnlLine(var PostedWhseShipmentLine: Record "Posted Whse. Shipment Line"; var TempTrackingSpecification: Record "Tracking Specification" temporary; WarehouseShipmentLine: Record "Warehouse Shipment Line")
    var
        cuSGAInterfaces: Codeunit "SGA Interfaces";
        cuSGAManagement: Codeunit "SGA Management";
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            cuSGAInterfaces.DocEnvConfirmAlb(WarehouseShipmentLine."Location Code", PostedWhseShipmentLine."Posted Source No.", WarehouseShipmentLine."No.");
            CLEAR(cuSGAInterfaces);
        end;
    end;

    [EventSubscriber(ObjectType::page, page::"Warehouse Shipment", 'OnAfterValidateEvent', 'External Document No.', false, false)]
    local procedure OnAfterValidateEventExternalDocumentNo(var Rec: Record "Warehouse Shipment Header"; var xRec: Record "Warehouse Shipment Header")
    var
        cuSGAManagement: Codeunit "SGA Management";
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            if rec."SGA Status" <> rec."SGA Status"::" " then
                rec."SGA Modified" := xRec."External Document No." <> rec."External Document No.";
        end;
    end;

    [EventSubscriber(ObjectType::page, page::"Warehouse Shipment", 'OnAfterValidateEvent', 'Shipment Date', false, false)]
    local procedure OnAfterValidateEventShipmentDate(var Rec: Record "Warehouse Shipment Header"; var xRec: Record "Warehouse Shipment Header")
    var
        cuSGAManagement: Codeunit "SGA Management";
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            if rec."SGA Status" <> rec."SGA Status"::" " then
                rec."SGA Modified" := xRec."Shipment Date" <> rec."Shipment Date";
        end;
    end;

    [EventSubscriber(ObjectType::page, page::"Warehouse Shipment", 'OnAfterValidateEvent', 'Shipping Agent Code', false, false)]
    local procedure OnAfterValidateEventShippingAgentCode(var Rec: Record "Warehouse Shipment Header"; var xRec: Record "Warehouse Shipment Header")
    var
        cuSGAManagement: Codeunit "SGA Management";
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            if rec."SGA Status" <> rec."SGA Status"::" " then
                rec."SGA Modified" := xRec."Shipment Date" <> rec."Shipment Date";
        end;
    end;

    [EventSubscriber(ObjectType::page, page::"Warehouse Shipment", 'OnAfterValidateEvent', 'Shipping Agent Service Code', false, false)]
    local procedure OnAfterValidateEventShippingAgentServiceCode(var Rec: Record "Warehouse Shipment Header"; var xRec: Record "Warehouse Shipment Header")
    var
        cuSGAManagement: Codeunit "SGA Management";
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            if rec."SGA Status" <> rec."SGA Status"::" " then
                rec."SGA Modified" := xRec."Shipment Date" <> rec."Shipment Date";
        end;
    end;

    [EventSubscriber(ObjectType::page, page::"Warehouse Shipment", 'OnAfterValidateEvent', 'Shipment Method Code', false, false)]
    local procedure OnAfterValidateEventShipmentMethodCode(var Rec: Record "Warehouse Shipment Header"; var xRec: Record "Warehouse Shipment Header")
    var
        cuSGAManagement: Codeunit "SGA Management";
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            if rec."SGA Status" <> rec."SGA Status"::" " then
                rec."SGA Modified" := xRec."Shipment Date" <> rec."Shipment Date";
        end;
    end;

    [EventSubscriber(ObjectType::page, page::"Warehouse Shipment", 'OnBeforeActionEvent', 'P&ost Shipment', false, false)]
    local procedure OnBeforeActionEventPostShipment(var Rec: Record "Warehouse Shipment Header")
    var
        cuSGAManagement: Codeunit "SGA Management";
        cuSGAinterfaces: Codeunit "SGA Interfaces";
        rLocation: Record Location;
        Error01: Label 'You cannot register shipments with a SGA warehouse',
                Comment = 'ESP="No se pueden registrar envios con almacén SGA"';
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            rLocation.GET(rec."Location Code");
            if rLocation."SGA Enabled" then Error(Error01);
        end;
    end;

    [EventSubscriber(ObjectType::page, page::"Warehouse Shipment", 'OnBeforeActionEvent', 'Post and &Print', false, false)]
    local procedure OnBeforeActionEventPostandPrint(var Rec: Record "Warehouse Shipment Header")
    var
        cuSGAManagement: Codeunit "SGA Management";
        cuSGAinterfaces: Codeunit "SGA Interfaces";
        rLocation: Record Location;
        Error01: Label 'You cannot register shipments with a SGA warehouse',
                Comment = 'ESP="No se pueden registrar envios con almacén SGA"';
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            rLocation.GET(rec."Location Code");
            if rLocation."SGA Enabled" then Error(Error01);
        end;
    end;

    [EventSubscriber(ObjectType::page, page::"Whse. Shipment Subform", 'OnAfterValidateEvent', 'Qty. to Ship', false, false)]
    local procedure OnAfterValidateEventWhseShipmentSubform(var Rec: Record "Warehouse Shipment Line"; var xRec: Record "Warehouse Shipment Line")
    var
        cuSGAManagement: Codeunit "SGA Management";
    begin
        if cuSGAManagement.IsSGAEnabled() then
            if Rec.SGASent() then
                Rec.SGAUpdateInserted();

    end;
    //
    /*  NUNCA se modifica la Quantity
    [EventSubscriber(ObjectType::page, page::"Whse. Shipment Subform", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure OnAfterValidateEventQuantityWhseShipment(var Rec: Record "Warehouse Shipment Line"; var xRec: Record "Warehouse Shipment Line")
    var
        cuSGAManagement: Codeunit "SGA Management";
    begin
        if cuSGAManagement.IsSGAEnabled() then
            if Rec.SGASent() then
                Rec.SGAUpdateInserted();
    end;
    */
    //<<
}