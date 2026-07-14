codeunit 50031 "Sales Post Events"
{
    Permissions = tabledata "Sales Shipment Header" = rimd,
                    tabledata "Sales Cr.Memo Header" = rimd;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnBeforeSalesShptLineInsert', '', false, false)]
    local procedure OnBeforeSalesShptLineInsert(ItemLedgShptEntryNo: Integer; var SalesShptLine: Record "Sales Shipment Line"; SalesShptHeader: Record "Sales Shipment Header")
    var
        _InfoCompany: Record "Company Information";
    begin
        // SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN BEGIN
            //SalesShptHeader."No. entrega almacen" := WhseShptHeader."No. entrega almacen";
            SalesShptHeader."Posting Date" := WORKDATE;
            SalesShptHeader."Document Date" := WORKDATE;
        END;
        // SGA
        // - 002
        SalesShptLine."Line Gross Weight" := SalesShptLine.Quantity * SalesShptLine."Unit Gross Weight";
        SalesShptLine."Line Net Weight" := SalesShptLine.Quantity * SalesShptLine."Unit Net Weight";
        SalesShptLine."Line Volume" := SalesShptLine.Quantity * SalesShptLine."Unit Volume";
        // + 002
        // - 004
        UpdateShipmentHeader(SalesShptHeader);
        // + 004
    end;

    LOCAL PROCEDURE UpdateShipmentHeader(VAR SalesShptHeader: Record 110);
    VAR
        SalesCommentLine: Record 44;
        RecordLinkManagement: Codeunit 447;
    BEGIN
        // - 004
        SalesShptHeader.CALCFIELDS("Total Gross Weight", "Total Net Weight", "Total Volume");
        SalesShptHeader."Total Gross Weight (Actual)" := SalesShptHeader."Total Gross Weight";
        SalesShptHeader."Total Net Weight (Actual)" := SalesShptHeader."Total Net Weight";
        SalesShptHeader."Total Volume (Actual)" := SalesShptHeader."Total Volume";
        SalesShptHeader.MODIFY;
        // + 004
    END;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnRunOnBeforeFinalizePosting', '', false, false)]
    local procedure OnRunOnBeforeFinalizePosting(CommitIsSuppressed: Boolean; var EverythingInvoiced: Boolean)
    var
    begin
        EverythingInvoiced := false;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnBeforePostUpdateOrderLineModifyTempLine', '', false, false)]
    local procedure OnBeforePostUpdateOrderLineModifyTempLine(var TempSalesLine: Record "Sales Line" temporary; WhseReceive: Boolean; WhseShip: Boolean)
    var
    begin
        // - 001
        TempSalesLine.InitPalletNumber;
        // + 001
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnInsertCrMemoHeaderOnAfterSalesCrMemoHeaderTransferFields', '', false, false)]
    local procedure OnInsertCrMemoHeaderOnAfterSalesCrMemoHeaderTransferFields(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var SalesHeader: Record "Sales Header")
    var
    begin
        SalesCrMemoHeader."Shipping Agent Code" := SalesHeader."Shipping Agent Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', true, true)]
    local procedure SalesPost_OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean; var IsHandled: Boolean)
    var
        Location: Record Location;
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;
        SalesLine: Record "Sales Line";
        LocalText000Lbl: Label 'There are lines in the sales order with price 0.. Do you want to continue with the registration?',
                        comment = 'ESP="Existen líneas en el pedido de venta con precio 0. ¿Desea continuar con el registro?"';
        LocalText001Lbl: Label 'Process cancelled by user', comment = 'ESP="Proceso cancelado por el usuario"';
    begin
        //Aviso y bloqueo al lanzar o registrar el envío de un pedido de venta con alguna línea a precio cero.
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) and SalesHeader.Ship then begin
            SalesReceivablesSetup.Get();
            Customer.Get(SalesHeader."Sell-to Customer No.");
            if (SalesReceivablesSetup."BBT Excl. Notice Zero Price" = '') or
                (Customer."SMG Platform" <> SalesReceivablesSetup."BBT Excl. Notice Zero Price") then begin
                SalesLine.Reset();
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetFilter("Unit Price", '%1', 0);
                if SalesLine.FindFirst() then begin
                    Clear(Location);
                    Location.SetRange(code, SalesLine."Location Code");
                    IF Location.FindFirst() then begin
                        IF NOT (Location.SGA) then begin
                            if not Confirm(LocalText000Lbl, true) then Error(LocalText001Lbl);
                        end;
                    end;
                end;
            end;
        end;
    end;

    local procedure ConfirmationMessage(SendRepAsEmail: Boolean): Text
    var
        PostAndEmailMsg: Label 'Do you want to post and email the %1?';
        Text001: Label 'Do you want to post and print the %1?';
    begin
        if SendRepAsEmail then exit(PostAndEmailMsg);
        exit(Text001);
    end;

    procedure GetReport(var SalesHeader: Record "Sales Header"; SendRepAsEmail: Boolean)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then exit;
        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::Order:
                begin
                    if SalesHeader.Ship then PrintShip(SalesHeader, SendRepAsEmail);
                    if SalesHeader.Invoice then PrintInvoice(SalesHeader, SendRepAsEmail);
                end;
            SalesHeader."Document Type"::Invoice:
                PrintInvoice(SalesHeader, SendRepAsEmail);
            SalesHeader."Document Type"::"Return Order":
                begin
                    if SalesHeader.Receive then PrintReceive(SalesHeader);
                    if SalesHeader.Invoice then PrintCrMemo(SalesHeader, SendRepAsEmail);
                end;
            SalesHeader."Document Type"::"Credit Memo":
                PrintCrMemo(SalesHeader, SendRepAsEmail);
        end;
    end;

    local procedure PrintReceive(SalesHeader: Record "Sales Header")
    var
        ReturnRcptHeader: Record "Return Receipt Header";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then exit;
        ReturnRcptHeader."No." := SalesHeader."Last Return Receipt No.";
        if ReturnRcptHeader.Find then;
        ReturnRcptHeader.SetRecFilter;
        ReturnRcptHeader.PrintRecords(false);
    end;

    local procedure PrintInvoice(SalesHeader: Record "Sales Header"; SendRepAsEmail: Boolean)
    var
        SalesInvHeader: Record "Sales Invoice Header";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then exit;
        if SalesHeader."Last Posting No." = '' then
            SalesInvHeader."No." := SalesHeader."No."
        else
            SalesInvHeader."No." := SalesHeader."Last Posting No.";
        SalesInvHeader.Find;
        SalesInvHeader.SetRecFilter;
        if SendRepAsEmail then
            SalesInvHeader.EmailRecords(true)
        else
            SalesInvHeader.PrintRecords(false);
    end;

    local procedure PrintShip(SalesHeader: Record "Sales Header"; SendRepAsEmail: Boolean)
    var
        SalesShptHeader: Record "Sales Shipment Header";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then exit;
        SalesShptHeader."No." := SalesHeader."Last Shipping No.";
        if SalesShptHeader.Find then;
        SalesShptHeader.SetRecFilter;
        if SendRepAsEmail then
            SalesShptHeader.EmailRecords(true)
        else
            SalesShptHeader.PrintRecords(false);
    end;

    local procedure PrintCrMemo(SalesHeader: Record "Sales Header"; SendRepAsEmail: Boolean)
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then exit;
        if SalesHeader."Last Posting No." = '' then
            SalesCrMemoHeader."No." := SalesHeader."No."
        else
            SalesCrMemoHeader."No." := SalesHeader."Last Posting No.";
        SalesCrMemoHeader.Find;
        SalesCrMemoHeader.SetRecFilter;
        if SendRepAsEmail then
            SalesCrMemoHeader.EmailRecords(true)
        else
            SalesCrMemoHeader.PrintRecords(false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnInsertShipmentHeaderOnAfterTransferfieldsToSalesShptHeader', '', true, true)]
    local procedure "Sales-Post_OnInsertShipmentHeaderOnAfterTransferfieldsToSalesShptHeader"(SalesHeader: Record "Sales Header"; var SalesShptHeader: Record "Sales Shipment Header")
    begin
        // - Expediciones - Campo pedir cita
        SalesShptHeader."Request delivery appointment" := SalesHeader."Request delivery appointment";
        // + Expediciones - Campo pedir cita
        // - Expediciones – Condiciones logísticas
        SalesShptHeader."Logistics conditions" := SalesHeader."Logistics conditions";
        // + Expediciones – Condiciones logísticas
    end;

    /*
        [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnAfterInsertCrMemoHeader', '', false, false)]
        local procedure OnAfterInsertCrMemoHeader(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var SalesHeader: Record "Sales Header")
        var
        begin
            IF SalesCrMemoHeader."Operation Description" = '' then begin
                SalesCrMemoHeader."Operation Description" := format(SalesCrMemoHeader."no.");
                SalesCrMemoHeader.modify;
            end;
        end;
    */

    //>> BBT. 16/03/2026. Implantación de la extensión SMG.
    // Eventos obsoletos.
    /*  BBT Sales Events Codeunit.al
    [EventSubscriber(ObjectType::Table, DATABASE::"Sales Line", 'OnAfterGetLineAmountToHandle', '', false, false)]
    local procedure OnAfterGetLineAmountToHandle(SalesLine: Record "Sales Line"; QtyToHandle: Decimal; var LineAmount: Decimal; var LineDiscAmount: Decimal)
    end;
    */
}
