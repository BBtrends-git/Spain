codeunit 50021 "TransferEvents"
{
    [EventSubscriber(ObjectType::Table, database::"Transfer Header", 'OnBeforeValidateTransferFromCode', '', false, false)]
    local procedure OnBeforeValidateTransferFromCode(var HideValidationDialog: Boolean; var IsHandled: Boolean; var TransferHeader: Record "Transfer Header"; var xTransferHeader: Record "Transfer Header")
    var
        Location: Record Location;
        Confirmed: Boolean;
        _InfoCompany: Record "Company Information";
        AlmacenFrom: Record Location;
        AlmacenTo: Record Location;
    begin
        // SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN
            IF (TransferHeader."Transfer-from Code" <> '') AND (TransferHeader."Transfer-to Code" <> '') THEN BEGIN
                AlmacenFrom.GET(TransferHeader."Transfer-from Code");
                AlmacenTo.GET(TransferHeader."Transfer-to Code");
                IF NOT (AlmacenFrom."Movimiento SGA ficticio" AND AlmacenTo."Movimiento SGA ficticio") THEN
                    IF AlmacenFrom.SGA AND AlmacenTo.SGA THEN ERROR('Los dos almacenes no pueden ser de SGA.');
            END;
        // SGA
    end;

    [EventSubscriber(ObjectType::Table, database::"Transfer Header", 'OnBeforeValidateTransferToCode', '', false, false)]
    local procedure OnBeforeValidateTransferToCode(var HideValidationDialog: Boolean; var IsHandled: Boolean; var TransferHeader: Record "Transfer Header"; var xTransferHeader: Record "Transfer Header")
    var
        Location: Record Location;
        Confirmed: Boolean;
        _InfoCompany: Record "Company Information";
        AlmacenFrom: Record Location;
        AlmacenTo: Record Location;
    begin
        // SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN
            IF (TransferHeader."Transfer-from Code" <> '') AND (TransferHeader."Transfer-to Code" <> '') THEN BEGIN
                AlmacenFrom.GET(TransferHeader."Transfer-from Code");
                AlmacenTo.GET(TransferHeader."Transfer-to Code");
                IF NOT (AlmacenFrom."Movimiento SGA ficticio" AND AlmacenTo."Movimiento SGA ficticio") THEN
                    IF AlmacenFrom.SGA AND AlmacenTo.SGA THEN ERROR('Los dos almacenes no pueden ser de SGA.');
            END;
        // SGA
    end;

    [EventSubscriber(ObjectType::page, page::"Transfer Order Subform", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure OnAfterValidateEventQuantity(var Rec: Record "Transfer Line"; var xRec: Record "Transfer Line")
    var
        _InfoCompany: Record "Company Information";
    begin
        //SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN
            IF xRec.Quantity <> rec.Quantity THEN rec.EnviarSGA;
    end;

    [EventSubscriber(ObjectType::page, page::"Transfer Order Subform", 'OnAfterValidateEvent', 'Qty. to Ship', false, false)]
    local procedure OnAfterValidateEventQuantityToShip(var Rec: Record "Transfer Line"; var xRec: Record "Transfer Line")
    var
        _InfoCompany: Record "Company Information";
    begin
        //SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN
            IF xRec.Quantity <> rec.Quantity THEN rec.EnviarSGA;
    end;

    [EventSubscriber(ObjectType::page, page::"Transfer Order Subform", 'OnAfterValidateEvent', 'Qty. to Receive', false, false)]
    local procedure OnAfterValidateEventQuantityToReceive(var Rec: Record "Transfer Line"; var xRec: Record "Transfer Line")
    var
        _InfoCompany: Record "Company Information";
    begin
        //SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN
            IF xRec.Quantity <> rec.Quantity THEN rec.EnviarSGA;
    end;

    [EventSubscriber(ObjectType::Table, database::"Transfer Line", 'OnAfterUpdateWithWarehouseShipReceive', '', false, false)]
    local procedure OnAfterUpdateWithWarehouseShipReceive(var TransferLine: Record "Transfer Line")
    var
        Location: Record Location;
        _InfoCompany: Record "Company Information";
    begin
        //SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN
            if Location.Get(TransferLine."Transfer-from Code") and Location.SGA then
                TransferLine.Validate("Qty. to Ship", TransferLine."Outstanding Quantity");
    end;

    [EventSubscriber(ObjectType::Table, database::"Transfer Line", 'OnBeforeCheckWarehouse', '', false, false)]
    local procedure OnBeforeCheckWarehouse(Location: Record Location; Receive: Boolean; TransferLine: Record "Transfer Line"; var IsHandled: Boolean)
    var
        ShowDialog: Option " ",Message,Error;
        DialogText: Text[50];
        WhseValidateSourceLine: Codeunit "Whse. Validate Source Line";
        Text003: Label 'Almacén %1 es requerido para %2 = %3.';
        _InfoCompany: Record "Company Information";
    begin
        //SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN begin
            //Para alamcenes SGA, validar automaticamente la cantidad a enviar si es almacén requerido, y no mostrar mensajes. Dejamos el aviso de error.
            if Location.SGA then begin
                if Location."Directed Put-away and Pick" then begin
                    ShowDialog := ShowDialog::Error;
                    if Receive then
                        DialogText := Location.GetRequirementText(Location.FieldNo("Require Receive"))
                    else
                        DialogText := Location.GetRequirementText(Location.FieldNo("Require Shipment"));
                end
                else begin
                    if Receive and (Location."Require Receive" or Location."Require Put-away") then begin
                        if WhseValidateSourceLine.WhseLinesExist(DATABASE::"Transfer Line", 1, TransferLine."Document No.", TransferLine."Line No.", 0, TransferLine.Quantity) then
                            ShowDialog := ShowDialog::Error
                        else if Location."Require Receive" then ShowDialog := ShowDialog::Message;
                        if Location."Require Receive" then
                            DialogText := Location.GetRequirementText(Location.FieldNo("Require Receive"))
                        else
                            DialogText := Location.GetRequirementText(Location.FieldNo("Require Put-away"));
                    end;
                    if not Receive and (Location."Require Shipment" or Location."Require Pick") then begin
                        if WhseValidateSourceLine.WhseLinesExist(DATABASE::"Transfer Line", 0, TransferLine."Document No.", TransferLine."Line No.", 0, TransferLine.Quantity) then
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
        _InfoCompany: Record "Company Information";
        TempTransferLne: Record "Transfer Line" temporary;
        Text50000: Label 'El pedido de transferencia no está lanzado.';
        Text50001: Label 'El pedido de transferencia contiene producto %1 sin gestión SGA.';
        Text50002: Label 'Ningún almacén tiene gestión SGA.';
        _RecAlmacen1: Record Location;
        _RecAlmacen2: Record Location;
        _TransNormal: Boolean;
        TransLine: Record "Transfer Line";
        _RecProducto: Record Item;
        PostReceipt, PostShipment, PostTransfer : Boolean;
        InventorySetup: Record "Inventory Setup";
        Text000: Label '&Ship,&Receive', comment = 'ESP="Enviar,Recibir"';
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        TransferOrderPostReceipt: Codeunit "TransferOrder-Post Receipt";
        TransferOrderPostShipment: Codeunit "TransferOrder-Post Shipment";
        TransferOrderPostTransfer: Codeunit "TransferOrder-Post Transfer";
        Selection2: Option " ",Shipment,Receipt;
        Location: Record Location;
        _Tipo: Integer;
        InterfaceSGA: Codeunit "Interface SGA";
    begin
        // SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN BEGIN
            IsHandled := true;
            TempTransferLne.RESET;
            TempTransferLne.DELETEALL;
            IF TransHeader.Status <> TransHeader.Status::Released THEN ERROR(Text50000);
            _RecAlmacen1.GET(TransHeader."Transfer-from Code");
            _RecAlmacen2.GET(TransHeader."Transfer-to Code");
            _TransNormal := (NOT _RecAlmacen1.SGA AND NOT _RecAlmacen2.SGA) OR ((_RecAlmacen1."Movimiento SGA ficticio" AND _RecAlmacen2."Movimiento SGA ficticio") AND (_RecAlmacen1."SGA Whse Code" = _RecAlmacen2."SGA Whse Code"));
            IF NOT _TransNormal THEN BEGIN
                IF NOT _RecAlmacen1.SGA AND NOT _RecAlmacen2.SGA THEN ERROR(Text50002);
                TransLine.SETRANGE("Document No.", TransHeader."No.");
                TransLine.SETRANGE("Derived From Line No.", 0);
                IF TransLine.FIND('-') THEN
                    REPEAT
                        IF _RecProducto.GET(TransLine."Item No.") THEN IF _RecProducto."No SGA management" THEN ERROR(STRSUBSTNO(Text50001, _RecProducto."No."));
                        TempTransferLne := TransLine;
                        TempTransferLne.INSERT;
                    UNTIL TransLine.NEXT = 0;
            END;
            InventorySetup.Get();
            case true of
                (TransHeader."Direct Transfer") and (InventorySetup."Direct Transfer Posting" = InventorySetup."Direct Transfer Posting"::"Receipt and Shipment"):
                    begin
                        PostShipment := true;
                        PostReceipt := true;
                    end;
                (TransHeader."Direct Transfer") and (InventorySetup."Direct Transfer Posting" = InventorySetup."Direct Transfer Posting"::"Direct Transfer"):
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
                TransferOrderPostShipment.SetHideValidationDialog(PostBatch);
                IF _TransNormal THEN
                    TransferOrderPostShipment.Run(TransHeader)
                ELSE BEGIN
                    IF Location.GET(TransHeader."Transfer-from Code") AND Location.SGA THEN BEGIN
                        IF TransHeader."Status SGA" <> TransHeader."Status SGA"::" " THEN ERROR('Pedido de transferencia pendiente de confirmar envío por el SGA');
                        _Tipo := 0;
                        InterfaceSGA.ChequeoStockTransfer(TransHeader."No.");
                        CLEAR(InterfaceSGA);
                        InterfaceSGA.EnvioSGA(TransHeader, _Tipo, TempTransferLne, FALSE);
                        CLEAR(InterfaceSGA);
                    END
                    ELSE BEGIN
                        _Tipo := 1;
                        TransferOrderPostShipment.Run(TransHeader);
                        InterfaceSGA.EnvioSGA(TransHeader, _Tipo, TempTransferLne, FALSE);
                        CLEAR(InterfaceSGA);
                    END;
                END;
            end;
            if PostReceipt then begin
                _RecAlmacen1.GET(TransHeader."Transfer-from Code");
                _RecAlmacen2.GET(TransHeader."Transfer-to Code");
                IF NOT _TransNormal AND _RecAlmacen2.SGA THEN ERROR('La recepción del material se debe de realizar por el SGA.');
                TransferOrderPostReceipt.SetHideValidationDialog(PostBatch);
                TransferOrderPostReceipt.Run(TransHeader);
            end;
            if PostTransfer then begin
                TransferOrderPostTransfer.Run(TransHeader);
            end;
        end;
    END;
    //SGA
}
