codeunit 50040 "Warehouse Events"
{
    [EventSubscriber(ObjectType::codeunit, codeunit::"Get Source Doc. Outbound", 'OnBeforeGetSingleOutboundDoc', '', false, false)]
    local procedure OnBeforeGetSingleOutboundDoc(var IsHandled: Boolean; var WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    var
        _InfoCompany: Record "Company Information";
    begin
        // SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN WarehouseShipmentHeader.CALCFIELDS("Destination Type", "Destination No.");
        // SGA
    end;

    [EventSubscriber(ObjectType::codeunit, codeunit::"Get Source Doc. Outbound", 'OnGetSingleOutboundDocOnSetFilterGroupFilters', '', false, false)]
    local procedure OnGetSingleOutboundDocOnSetFilterGroupFilters(var WhseRqst: Record "Warehouse Request"; WhseShptHeader: Record "Warehouse Shipment Header")
    var
        _InfoCompany: Record "Company Information";
    begin
        //SGA
        IF _InfoCompany.SGA THEN
            IF WhseShptHeader."Destination No." <> '' THEN BEGIN
                WhseRqst.SETRANGE("Destination Type", WhseShptHeader."Destination Type");
                WhseRqst.SETRANGE("Destination No.", WhseShptHeader."Destination No.");
            END;
        //SGA
    end;

    [EventSubscriber(ObjectType::codeunit, codeunit::"Get Source Doc. Outbound", 'OnBeforeCreateFromSalesOrder', '', false, false)]
    local procedure OnBeforeCreateFromSalesOrder(var SalesHeader: Record "Sales Header")
    var
        _InfoCompany: Record "Company Information";
    begin
        //>>CONTROL QUE EL PEDIDO TENGA COD DIRECCION ENVIO EN B&B TRENDS
        IF (COMPANYNAME = 'BB Trends') AND (SalesHeader."Ship-to Code" = '') THEN ERROR('Para realizar el envío debe rellenar Cód. dirección envío cliente');
        //<<CONTROL QUE EL PEDIDO TENGA COD DIRECCION ENVIO EN B&B TRENDS
    end;

    [EventSubscriber(ObjectType::codeunit, codeunit::"Get Source Doc. Outbound", 'OnBeforeOpenWarehouseShipmentPage', '', false, false)]
    local procedure OnBeforeOpenWarehouseShipmentPage(var GetSourceDocuments: Report "Get Source Documents"; var IsHandled: Boolean)
    var
    begin
        IF NOT GUIALLOWED THEN IsHandled := true; //BB><
    end;

    [EventSubscriber(ObjectType::codeunit, codeunit::"Whse.-Post Shipment", 'OnBeforePostedWhseShptHeaderInsert', '', false, false)]
    local procedure OnBeforePostedWhseShptHeaderInsert(var PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header"; WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    var
        _InfoCompany: Record "Company Information";
    begin
        // SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN
            PostedWhseShipmentHeader."No. entrega almacen" := WarehouseShipmentHeader."No. entrega almacen";
        // SGA
    end;

    [EventSubscriber(ObjectType::codeunit, codeunit::"Whse.-Post Shipment", 'OnCreatePostedShptLineOnBeforePostWhseJnlLine', '', false, false)]
    local procedure OnCreatePostedShptLineOnBeforePostWhseJnlLine(var PostedWhseShipmentLine: Record "Posted Whse. Shipment Line"; var TempTrackingSpecification: Record "Tracking Specification" temporary; WarehouseShipmentLine: Record "Warehouse Shipment Line")
    var
        _InfoCompany: Record "Company Information";
        _ProcesosSGA: Codeunit "Interface SGA";
    begin
        // SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN BEGIN
            _ProcesosSGA.DocEnvConfirmAlb(WarehouseShipmentLine."Location Code", PostedWhseShipmentLine."Posted Source No.", WarehouseShipmentLine."No.");
            CLEAR(_ProcesosSGA);
        END;
        // SGA
    end;

    [EventSubscriber(ObjectType::page, page::"Warehouse Shipment", 'OnAfterValidateEvent', 'External Document No.', false, false)]
    local procedure OnAfterValidateEventExternalDocumentNo(var Rec: Record "Warehouse Shipment Header"; var xRec: Record "Warehouse Shipment Header")
    var
        _InfoCompany: Record "Company Information";
        _ProcesosSGA: Codeunit "Interface SGA";
    begin
        // SGA
        IF rec."Status SGA" <> rec."Status SGA"::" " THEN rec.ModificadoSGA := xRec."External Document No." <> rec."External Document No.";
        // SGA
    end;

    [EventSubscriber(ObjectType::page, page::"Warehouse Shipment", 'OnAfterValidateEvent', 'Shipment Date', false, false)]
    local procedure OnAfterValidateEventShipmentDate(var Rec: Record "Warehouse Shipment Header"; var xRec: Record "Warehouse Shipment Header")
    var
        _InfoCompany: Record "Company Information";
        _ProcesosSGA: Codeunit "Interface SGA";
    begin
        // SGA
        IF rec."Status SGA" <> rec."Status SGA"::" " THEN rec.ModificadoSGA := xRec."Shipment Date" <> rec."Shipment Date";
        // SGA
    end;

    [EventSubscriber(ObjectType::page, page::"Warehouse Shipment", 'OnAfterValidateEvent', 'Shipping Agent Code', false, false)]
    local procedure OnAfterValidateEventShippingAgentCode(var Rec: Record "Warehouse Shipment Header"; var xRec: Record "Warehouse Shipment Header")
    var
        _InfoCompany: Record "Company Information";
        _ProcesosSGA: Codeunit "Interface SGA";
    begin
        // SGA
        IF rec."Status SGA" <> rec."Status SGA"::" " THEN rec.ModificadoSGA := xRec."Shipment Date" <> rec."Shipment Date";
        // SGA
    end;

    [EventSubscriber(ObjectType::page, page::"Warehouse Shipment", 'OnAfterValidateEvent', 'Shipping Agent Service Code', false, false)]
    local procedure OnAfterValidateEventShippingAgentServiceCode(var Rec: Record "Warehouse Shipment Header"; var xRec: Record "Warehouse Shipment Header")
    var
        _InfoCompany: Record "Company Information";
        _ProcesosSGA: Codeunit "Interface SGA";
    begin
        // SGA
        IF rec."Status SGA" <> rec."Status SGA"::" " THEN rec.ModificadoSGA := xRec."Shipment Date" <> rec."Shipment Date";
        // SGA
    end;

    [EventSubscriber(ObjectType::page, page::"Warehouse Shipment", 'OnAfterValidateEvent', 'Shipment Method Code', false, false)]
    local procedure OnAfterValidateEventShipmentMethodCode(var Rec: Record "Warehouse Shipment Header"; var xRec: Record "Warehouse Shipment Header")
    var
        _InfoCompany: Record "Company Information";
        _ProcesosSGA: Codeunit "Interface SGA";
    begin
        // SGA
        IF rec."Status SGA" <> rec."Status SGA"::" " THEN rec.ModificadoSGA := xRec."Shipment Date" <> rec."Shipment Date";
        // SGA
    end;

    [EventSubscriber(ObjectType::page, page::"Warehouse Shipment", 'OnBeforeActionEvent', 'P&ost Shipment', false, false)]
    local procedure OnAfterActionEventPostShipment(var Rec: Record "Warehouse Shipment Header")
    var
        _InfoCompany: Record "Company Information";
        _ProcesosSGA: Codeunit "Interface SGA";
        _Almacen: Record Location;
    begin
        // SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN BEGIN
            _Almacen.GET(rec."Location Code");
            IF _Almacen.SGA THEN ERROR(Text50000);
        END;
        //
    end;

    [EventSubscriber(ObjectType::page, page::"Warehouse Shipment", 'OnBeforeActionEvent', 'Post and &Print', false, false)]
    local procedure OnAfterActionEventPostandPrint(var Rec: Record "Warehouse Shipment Header")
    var
        _InfoCompany: Record "Company Information";
        _ProcesosSGA: Codeunit "Interface SGA";
        _Almacen: Record Location;
    begin
        // SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN BEGIN
            _Almacen.GET(rec."Location Code");
            IF _Almacen.SGA THEN ERROR(Text50000);
        END;
        //
    end;

    [EventSubscriber(ObjectType::page, page::"Whse. Shipment Subform", 'OnAfterValidateEvent', 'Qty. to Ship', false, false)]
    local procedure OnAfterValidateEventWhseShipmentSubform(var Rec: Record "Warehouse Shipment Line"; var xRec: Record "Warehouse Shipment Line")
    var
    begin
        IF rec.Enviado_A_SGA THEN rec.ActModifSGA;
        //
    end;

    [EventSubscriber(ObjectType::page, page::"Whse. Shipment Subform", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure OnAfterValidateEventQuantity(var Rec: Record "Warehouse Shipment Line"; var xRec: Record "Warehouse Shipment Line")
    var
    begin
        IF rec.Enviado_A_SGA THEN rec.ActModifSGA;
        //
    end;

    var
        Text50000: label 'No se pueden registrar envios con almacén SGA';
}
