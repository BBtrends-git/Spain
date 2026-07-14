codeunit 50046 "SalesEvents"
{
    Permissions = tabledata "Sales Shipment Header" = rimd;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnCopyFromItemOnAfterCheck', '', false, false)]
    local procedure OnCopyFromItemOnAfterCheck(Item: Record Item; var SalesLine: Record "Sales Line")
    var
    begin
        salesLine."Unit Gross Weight" := Item."Gross Weight";
        SalesLine."Unit Net Weight" := Item."Net Weight";
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterAssignItemValues', '', false, false)]
    local procedure OnAfterAssignItemValues(Item: Record Item; var SalesLine: Record "Sales Line")
    begin
        SalesLine."EAN Code" := salesLine.TraerEan;
        salesLine."Prod No." := item."No.";
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnBeforeValidateEvent', 'Location Code', false, false)]
    local procedure OnBeforeValidateEventLocationCode(CurrFieldNo: Integer; var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        Location: Record Location;
    begin
        // SGA
        IF (CurrFieldNo = rec.FIELDNO("Location Code")) AND (rec.Type = rec.Type::Item) THEN
            IF rec."Document Type" IN [rec."Document Type"::Invoice, rec."Document Type"::"Credit Memo"] THEN
                IF NOT Location.CantUseLocation(rec."Location Code") THEN
                    ERROR('El almacén %1 no se puede usar por ser de SGA.', rec."Location Code");
        // SGA
    end;

    //>> BBT. 16/03/2026. Implantación de la extensión SMG.
    // Eventos obsoletos.
    /*  BBT Sales Events Codeunit.al
    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnValidateQuantityOnBeforeResetAmounts', '', false, false)]
    local procedure OnValidateQuantityOnBeforeResetAmounts(var IsHandled: Boolean; var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    begin
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnBeforeValidateEvent', 'Unit Price', false, false)]
    local procedure OnBeforeValidateEventUnitPrice(CurrFieldNo: Integer; var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    begin
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Unit Price', false, false)]
    local procedure OnAfterValidateEventUnitPrice(CurrFieldNo: Integer; var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    begin
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Line Discount %', false, false)]
    local procedure OnAfterValidateEventLineDiscount(CurrFieldNo: Integer; var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    begin
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnValidateLineDiscountPercentOnBeforeUpdateAmounts', '', false, false)]
    local procedure OnValidateLineDiscountPercentOnBeforeUpdateAmounts(CurrFieldNo: Integer; var SalesLine: Record "Sales Line")
    begin
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnBeforeTestJobPlanningLine', '', false, false)]
    local procedure OnBeforeTestJobPlanningLine(CallingFieldNo: Integer; var IsHandled: Boolean; var SalesLine: Record "Sales Line")
    begin
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterUpdateAmountsDone', '', false, false)]
    local procedure OnAfterUpdateAmountsDone(CurrentFieldNo: Integer; var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line")
    begin
    end;

    [EventSubscriber(ObjectType::codeunit, codeunit::"Document Totals", 'OnAfterCalculateSalesSubPageTotals', '', true, true)]
    local procedure OnAfterCalculateSalesSubPageTotals(var InvoiceDiscountAmount: Decimal; var InvoiceDiscountPct: Decimal; var TotalSalesHeader: Record "Sales Header"; var TotalSalesLine2: Record "Sales Line"; var TotalSalesLine: Record "Sales Line"; var VATAmount: Decimal)
    begin
    end;
    */
    //<<

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Variant Code', false, false)]
    local procedure OnAfterValidateEventVariantCode(CurrFieldNo: Integer; var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        Location: Record Location;
    begin
        Rec."EAN Code" := Rec.TraerEan;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterInitHeaderDefaults', '', false, false)]
    local procedure OnBeforeInitHeaderLocactionCode(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    var
        rLocation: Record Location;
        rCompanyInformation: Record "Company Information";
    begin
        rCompanyInformation.Get();
        if rCompanyInformation.SGA then begin
            IF SalesLine."Document Type" IN [SalesLine."Document Type"::Invoice, SalesLine."Document Type"::"Credit Memo"] THEN
                IF NOT rLocation.CantUseLocation(SalesHeader."Location Code")
                THEN
                    SalesLine."Location Code" := '';
        end;
    end;

    //>> 29/07/2025. Comprobación SGA
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post (Yes/No)", 'OnAfterConfirmPost', '', false, false)]
    local procedure OnAfterConfirmPost(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        CompanyInfo: Record "Company Information";
        Procesos: Codeunit "Interface SGA";
        Text50000: Label 'No se puede recibir ni enviar un documento de almacén SGA';
    begin
        //I - SGA
        CompanyInfo.GET;
        if CompanyInfo.SGA then begin
            Clear(Procesos);
            // BBT Controlar que no se pueda registrar desde una devolución  directamente en un almacén SGA
            if SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order" then
                if SalesHeader.Receive OR SalesHeader.Ship then begin
                    IF Procesos.AlmRegDevVenta(SalesHeader) then Error(Text50000);
                    Clear(Procesos);
                end;
            // BBT Controlar que no se pueda registrar desde un ABONO directamente en un almacén SGA
            if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then BEGIN
                if Procesos.AlmRegDevVenta(SalesHeader) then ERROR(Text50000);
                Clear(Procesos);
            end;
        end;
        //F - SGA
    end;
    //<<

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Shipment Header - Edit", 'OnBeforeSalesShptHeaderModify', '', false, false)]
    local procedure OnBeforeSalesShptHeaderModify(FromSalesShptHeader: Record "Sales Shipment Header"; var SalesShptHeader: Record "Sales Shipment Header")
    begin
        // - 001
        SalesShptHeader."Number of Packages" := FromSalesShptHeader."Number of Packages";
        SalesShptHeader.Reference := FromSalesShptHeader.Reference;
        // + 001
        // - 002
        SalesShptHeader."Total Gross Weight (Actual)" := FromSalesShptHeader."Total Gross Weight (Actual)";
        SalesShptHeader."Total Net Weight (Actual)" := FromSalesShptHeader."Total Net Weight (Actual)";
        SalesShptHeader."Total Volume (Actual)" := FromSalesShptHeader."Total Volume (Actual)";
        // + 002
        // TC PEDIDO POR JOSEP MARQUES
        SalesShptHeader."Ship-to Address" := FromSalesShptHeader."Ship-to Address";
        SalesShptHeader."Ship-to Address 2" := FromSalesShptHeader."Ship-to Address 2";
        // TC PEDIDO POR JOSEP MARQUES
        //>> BBT 20/02/2023
        SalesShptHeader."Requested Delivery Date" := FromSalesShptHeader."Requested Delivery Date";
        //<<
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Release Sales Document", 'OnCodeOnAfterCheckCustomerCreated', '', false, false)]
    local procedure OnCodeOnAfterCheckCustomerCreated(PreviewMode: Boolean; var IsHandled: Boolean; var SalesHeader: Record "Sales Header")
    var
        _InfoCompany: Record "Company Information";
    begin
        // SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN BEGIN
                SalesHeader.TESTFIELD(SalesHeader."Payment Terms Code");
                SalesHeader.TESTFIELD(SalesHeader."Payment Method Code");
            END;
        // Fin 
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnBeforeCopySellToCustomerAddressFieldsFromCustomer', '', false, false)]
    local procedure OnBeforeCopySellToCustomerAddressFieldsFromCustomer(Customer: Record Customer; var IsHandled: Boolean; var SalesHeader: Record "Sales Header")
    begin
        //TC 2O NIF
        IF NOT SalesHeader."PL VAT" THEN
            SalesHeader."VAT Bus. Posting Group" := Customer."VAT Bus. Posting Group"
        ELSE
            SalesHeader."VAT Bus. Posting Group" := Customer."PL VAT Bus. Posting Group";
        //TC 2O NIF
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnValidateSellToCustomerNoOnBeforeValidateLocationCode', '', false, false)]
    local procedure OnValidateSellToCustomerNoOnBeforeValidateLocationCode(var Cust: Record Customer; var IsHandled: Boolean; var SalesHeader: Record "Sales Header")
    begin
        // TC-017 PREDETERMINAR DIRECCION DE ENVIO
        IF (Cust."Ship-to Code" <> '') AND (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) THEN
            SalesHeader.VALIDATE("Ship-to Code", Cust."Ship-to Code")
        ELSE
            SalesHeader.VALIDATE("Ship-to Code", '');
        // TC-017 PREDETERMINAR DIRECCION DE ENVIO
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure OnAfterValidateEventSelltoCustomerNo(CurrFieldNo: Integer; var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    var
        _InfoCompany: Record "Company Information";
        Customer: Record Customer;
    begin
        // SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN IF Rec."Document Type" = Rec."Document Type"::Order THEN Rec.MeterComentariosEnvio;
        // - DUAs SII        
        if Customer.Get(Rec."Sell-to Customer No.") then begin
            Rec.Validate("Invoice Type", Customer."Invoice Type");
            // + DUAs SII
            // - Expediciones - Campo pedir cita
            Rec."Request delivery appointment" := Customer."Request delivery appointment";
            // + Expediciones - Campo pedir cita
            // - Expediciones – Condiciones logísticas
            rec."Logistics conditions" := Customer."Logistics conditions";
            // + Expediciones – Condiciones logísticas
            //Los clientes que tengan la marca de "No enviar facturas al SII" -> no se enviarán sus facturas al SII
            Rec.Validate("Do Not Send To SII", Customer."BBT Do Not Send Inv. To SII");
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterUpdateBillToCont', '', false, false)]
    local procedure OnAfterUpdateBillToCont(Contact: Record Contact; Customer: Record Customer; var SalesHeader: Record "Sales Header")
    var
        _InfoCompany: Record "Company Information";
    begin
        //- 001
        SalesHeader."Purchase Group" := Customer."SMG Purchase Group";  //>> BBT. 16/03/2026. Implantación de la extensión SMG.
        //+ 001
        SalesHeader."Payment Method Code" := Customer."Payment Method Code";
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnBeforeSetBillToCustomerAddressFieldsFromCustomer', '', false, false)]
    local procedure OnBeforeSetBillToCustomerAddressFieldsFromCustomer(CurrentFieldNo: Integer; var BillToCustomer: Record Customer; var GLSetup: Record "General Ledger Setup"; var IsHandled: Boolean; var SalesHeader: Record "Sales Header"; var SkipBillToContact: Boolean; xSalesHeader: Record "Sales Header")
    var
        _InfoCompany: Record "Company Information";
        ServiceZone: Record "service zone";
        PaymentTerms: Record "Payment Terms";
    begin
        IsHandled := true;
        SalesHeader."Bill-to Customer Templ. Code" := '';
        SalesHeader."Bill-to Name" := BillToCustomer.Name;
        SalesHeader."Bill-to Name 2" := BillToCustomer."Name 2";
        IF (SalesHeader.HasDifferentBillToAddress(BillToCustomer) and BillToCustomer.HasAddress()) then begin
            SalesHeader."Bill-to Address" := BillToCustomer.Address;
            SalesHeader."Bill-to Address 2" := BillToCustomer."Address 2";
            SalesHeader."Bill-to City" := BillToCustomer.City;
            SalesHeader."Bill-to Post Code" := BillToCustomer."Post Code";
            SalesHeader."Bill-to County" := BillToCustomer.County;
            SalesHeader."Bill-to Country/Region Code" := BillToCustomer."Country/Region Code";
        end;
        if not SkipBillToContact then SalesHeader."Bill-to Contact" := BillToCustomer.Contact;
        SalesHeader."Payment Terms Code" := BillToCustomer."Payment Terms Code";
        SalesHeader."Prepmt. Payment Terms Code" := BillToCustomer."Payment Terms Code";
        //>> BBT 20210521
        // if SalesHeader."Document Type" in [SalesHeader."Document Type"::"Credit Memo", SalesHeader."Document Type"::"Return Order"] then begin
        //     SalesHeader."Payment Method Code" := '';
        //     if PaymentTerms.Get(SalesHeader."Payment Terms Code") then
        //         if PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" then
        //             SalesHeader."Payment Method Code" := BillToCustomer."Payment Method Code"
        // end else
        //     SalesHeader."Payment Method Code" := BillToCustomer."Payment Method Code";
        SalesHeader."Payment Method Code" := BillToCustomer."Payment Method Code";
        //<< BBT 20210521
        GLSetup.Get();
        if GLSetup."Bill-to/Sell-to VAT Calc." = GLSetup."Bill-to/Sell-to VAT Calc."::"Bill-to/Pay-to No." then begin
            if (SalesHeader."VAT Bus. Posting Group" <> '') and (SalesHeader."VAT Bus. Posting Group" <> BillToCustomer."VAT Bus. Posting Group") then
                IF NOT SalesHeader."PL VAT" THEN //TC 2O NIF
                    SalesHeader."VAT Bus. Posting Group" := BillToCustomer."VAT Bus. Posting Group"
                ELSE
                    SalesHeader."VAT Bus. Posting Group" := BillToCustomer."PL VAT Bus. Posting Group";
            //TC 2O NIF
            SalesHeader."VAT Country/Region Code" := BillToCustomer."Country/Region Code";
            SalesHeader."VAT Registration No." := BillToCustomer."VAT Registration No.";
            SalesHeader."Gen. Bus. Posting Group" := BillToCustomer."Gen. Bus. Posting Group";
        end;
        SalesHeader."Customer Posting Group" := BillToCustomer."Customer Posting Group";
        SalesHeader."Currency Code" := BillToCustomer."Currency Code";
        SalesHeader."Customer Price Group" := BillToCustomer."Customer Price Group";
        SalesHeader."Prices Including VAT" := BillToCustomer."Prices Including VAT";
        SalesHeader."Price Calculation Method" := BillToCustomer.GetPriceCalculationMethod();
        SalesHeader."Allow Line Disc." := BillToCustomer."Allow Line Disc.";
        SalesHeader."Invoice Disc. Code" := BillToCustomer."Invoice Disc. Code";
        SalesHeader."Customer Disc. Group" := BillToCustomer."Customer Disc. Group";
        SalesHeader."Language Code" := BillToCustomer."Language Code";
        //SalesHeader.SetSalespersonCode(BillToCustomer."Salesperson Code", SalesHeader."Salesperson Code");
        IF ServiceZone.GET(BillToCustomer."Service Zone Code") THEN IF ServiceZone."Salesperson Code" <> '' THEN SalesHeader."Salesperson Code" := ServiceZone."Salesperson Code";
        IF SalesHeader."Salesperson Code" = '' THEN SalesHeader."Salesperson Code" := BillToCustomer."Salesperson Code";
        // - 005
        SalesHeader."Service Zone Code" := BillToCustomer."Service Zone Code";
        // + 005
        SalesHeader."Combine Shipments" := BillToCustomer."Combine Shipments";
        SalesHeader.Reserve := BillToCustomer.Reserve;
        if SalesHeader."Document Type" In [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Quote] then SalesHeader."Prepayment %" := BillToCustomer."Prepayment %";
        SalesHeader."Tax Area Code" := BillToCustomer."Tax Area Code";
        if (SalesHeader."Ship-to Code" = '') or (SalesHeader."Sell-to Customer No." <> BillToCustomer."No.") then SalesHeader."Tax Liable" := BillToCustomer."Tax Liable";
        SalesHeader."Cust. Bank Acc. Code" := BillToCustomer."Preferred Bank Account Code";
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnValidatePaymentTermsCodeOnBeforeValidateDueDate', '', false, false)]
    local procedure OnValidatePaymentTermsCodeOnBeforeValidateDueDate(CurrentFieldNo: Integer; var IsHandled: Boolean; var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header")
    var
        _InfoCompany: Record "Company Information";
        AdjustDueDate: Codeunit "Due Date-Adjust";
        PaymentTerms: Record "Payment Terms";
    begin
        IsHandled := true;
        PaymentTerms.GET(SalesHeader."Payment Terms Code");
        //>> 01/07/2022
        //    VALIDATE("Due Date","Document Date");
        SalesHeader."Due Date" := CALCDATE(PaymentTerms."Due Date Calculation", SalesHeader."Document Date");
        AdjustDueDate.SalesAdjustDueDate(SalesHeader."Due Date", SalesHeader."Document Date", PaymentTerms.CalculateMaxDueDate(SalesHeader."Document Date"), SalesHeader."Bill-to Customer No.");
        //<< 01/07/2022
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnBeforeValidateShipmentMethodCode', '', false, false)]
    local procedure OnBeforeValidateShipmentMethodCode(var IsHandled: Boolean; var SalesHeader: Record "Sales Header")
    var
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnBeforeValidateLocationCode', '', false, false)]
    local procedure OnBeforeValidateLocationCode(var IsHandled: Boolean; var SalesHeader: Record "Sales Header")
    var
    begin
        IsHandled := true;
        SalesHeader.UpdateShipToAddress();
        SalesHeader.UpdateOutboundWhseHandlingTime();
        SalesHeader.CreateDimFromDefaultDim(SalesHeader.FieldNo("Location Code"));
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterValidateEvent', 'Salesperson Code', false, false)]
    local procedure OnAfterValidateEventSalespersonCode(CurrFieldNo: Integer; var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    var
    begin
        // - 002
        IF Rec."Document Type" IN [Rec."Document Type"::Order, Rec."Document Type"::Invoice] THEN
            Rec.UpdateAllLineCommission(Rec."Salesperson Code", xRec."Salesperson Code");
        // + 002
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnBeforeValidateShippingAgentCode', '', false, false)]
    local procedure OnBeforeValidateShippingAgentCode(CurrentFieldNo: Integer; var IsHandled: Boolean; var SalesHeader: Record "Sales Header"; var xSalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        IsHandled := true;
        IF xSalesHeader."Shipping Agent Code" = SalesHeader."Shipping Agent Code" THEN EXIT;
        SalesHeader."Shipping Agent Service Code" := '';
        SalesHeader.GetShippingTime(SalesHeader.FIELDNO("Shipping Agent Code"));
        //UpdateSalesLines(FIELDCAPTION("Shipping Agent Code"),CurrFieldNo <> 0);
        //DAGA
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        IF SalesLine.FINDSET THEN BEGIN
            SalesLine.VALIDATE("Shipping Agent Code", SalesHeader."Shipping Agent Code");
            SalesLine.MODIFY;
        END;
        //F DAGA
    end;

    [EventSubscriber(ObjectType::page, page::"Sales Return Order Subform", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure OnAfterValidateEvent(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        rCompanyInformation: Record "Company Information";
    begin
        rCompanyInformation.Get();
        if rCompanyInformation.SGA then begin
            IF xRec.Quantity <> rec.Quantity THEN rec.EnviarSGA;
        end;
    end;

    [EventSubscriber(ObjectType::page, page::"Sales Order", 'OnBeforeValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure OnBeforeValidateEventSelltoCustomerNoPage(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        // >> BBT 27/10/2021
        rec."Invoice Type" := rec."Invoice Type"::"F1 Invoice";
        IF (rec."Gen. Bus. Posting Group" = 'ECOMERCE') AND (rec."VAT Registration No." = '') AND (rec."Sell-to Country/Region Code" = 'ES') THEN BEGIN
            rec."Invoice Type" := rec."Invoice Type"::"F2 Simplified Invoice";
        END;
        // <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeCheckPostWhseShptLines', '', true, true)]
    local procedure "Sales-Post_OnBeforeCheckPostWhseShptLines"(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; var IsHandled: Boolean; WhseShptHeader: Record "Warehouse Shipment Header"; WhseRcptHeader: Record "Warehouse Receipt Header"; WhseShip: Boolean; WhseReceive: Boolean)
    var
        SalesShptHeader: Record "Sales Shipment Header";
    begin
        clear(SalesShptHeader);
        If SalesShptHeader.Get(SalesShptLine."Document No.") then begin
            //TC
            SalesShptHeader."Warehose Ship No.2" := WhseShptHeader."No.";
            SalesShptHeader.Modify();
            //TC
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnValidateShipToCodeOnBeforeCopyShipToAddress', '', true, true)]
    local procedure "Sales Header_OnValidateShipToCodeOnBeforeCopyShipToAddress"(var SalesHeader: Record "Sales Header"; var xSalesHeader: Record "Sales Header"; var CopyShipToAddress: Boolean)
    begin
        //INC-2017-02-67667. En Ship-to Code - OnValidate() quitado el control por tipo documento
        CopyShipToAddress := true;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnBeforeActionEvent', 'SendApprovalRequest', true, true)]
    local procedure SalesOrder_OnBeforeActionEvent_SendApprovalRequest(var Rec: Record "Sales Header")
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;
        SalesLine: Record "Sales Line";
        vLLineNo: Integer;
        Location: Record Location;
        LocalText000Lbl: Label 'There are lines in the sales order with price 0. Do you want to continue with the order approval request?!',
                        comment = 'ESP="Existen líneas en el pedido de venta con precio 0. ¿Desea continuar con la solicitud de aprobación del pedido?!"';
        LocalText001Lbl: Label 'Process cancelled by user',
                        comment = 'ESP="Proceso cancelado por el usuario"';
        LocalText002Lbl: Label 'No minimum order amount is defined in the sales configuration. Do you wish to continue?',
                        comment = 'ESP="No está definido ningún importe mínimo de pedidos en la configuración de ventas. ¿Desea continuar?"';
        LocalText003Lbl: Label 'Do you want to add charge lines to your order?',
                        comment = 'ESP="Desea añadir las lineas de portes?"';
    begin
        //Aviso y bloqueo al lanzar o registrar el envío de un pedido de venta con alguna línea a precio cero.
        if Rec."Document Type" = Rec."Document Type"::Order then begin
            SalesReceivablesSetup.Get();
            Customer.Get(Rec."Sell-to Customer No.");
            if (SalesReceivablesSetup."BBT Excl. Notice Zero Price" = '') or
                (Customer."SMG Platform" <> SalesReceivablesSetup."BBT Excl. Notice Zero Price") then begin
                SalesLine.Reset();
                SalesLine.SetRange("Document Type", Rec."Document Type");
                SalesLine.SetRange("Document No.", Rec."No.");
                SalesLine.SetFilter("Unit Price", '%1', 0);
                if SalesLine.FindFirst() then begin
                    if not Confirm(LocalText000Lbl, true) then Error(LocalText001Lbl);
                end;
            end;
        end;
        //Al lanzar un pedido de ventas, si el pedido no llega a un importe mínimo, el sistema deberá proponer una línea de portes con el importe configurado
        Rec.CalcFields(Amount);
        if SalesReceivablesSetup."BBT Minimum Matter" <= 0 then begin
            if not Confirm(LocalText002Lbl, true) then Error(LocalText001Lbl);
        end
        else begin
            SalesReceivablesSetup.TestField("BBT Minimum Matter");
            SalesReceivablesSetup.TestField("BBT Item Shipping Charge");
            SalesReceivablesSetup.TestField("BBT Shipping Charge");
            if (Rec.Amount < SalesReceivablesSetup."BBT Minimum Matter") AND
                (SalesReceivablesSetup."Shipping Exclusion" <> Customer."SMG Platform") then begin
                //Buscamos si ya existe alguna línea de portes (que se haya lanzado el pedido varias veces) para preguntar al usuario si desea eliminarla
                SalesLine.Reset();
                SalesLine.SetRange("Document Type", Rec."Document Type");
                SalesLine.SetRange("Document No.", Rec."No.");
                SalesLine.SetRange("BBT Shipping Charge", true);
                if NOT SalesLine.FindSet() then begin
                    if Confirm(StrSubstNo(LocalText003Lbl, Rec."No."), true) then begin
                        SalesLine.Reset();
                        SalesLine.SetRange("Document Type", Rec."Document Type");
                        SalesLine.SetRange("Document No.", Rec."No.");
                        if SalesLine.FindLast() then
                            vLLineNo := SalesLine."Line No." + 10000
                        else
                            vLLineNo := 10000;
                        SalesLine.Init();
                        SalesLine.Validate("Document Type", Rec."Document Type");
                        SalesLine.Validate("Document No.", Rec."No.");
                        SalesLine.Validate("Line No.", vLLineNo);
                        SalesLine.Validate(Type, SalesLine.Type::Item);
                        SalesLine.Validate("No.", SalesReceivablesSetup."BBT Item Shipping Charge");
                        if SalesReceivablesSetup."BBT Text Item Shipping Charge" <> '' then SalesLine.Validate(Description, SalesReceivablesSetup."BBT Text Item Shipping Charge");
                        SalesLine.Validate(Quantity, 1);
                        SalesLine.Validate("Unit Price", SalesReceivablesSetup."BBT Shipping Charge");
                        SalesLine.Validate("BBT Shipping Charge", true);
                        SalesLine.Insert(true);
                    end;
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', true, true)]
    local procedure SalesLine_OnAfterValidateEvent_No(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        Item: Record Item;
        ReworkTypeByCustItem: Record "BBT Rework Type By Cust./Item";
    begin
        //Al indicar en un pedido de venta un producto que requiera retrabajo, mostrar un mensaje con el tipo retrabajo definido para ese producto y cliente
        if (Rec."Document Type" = Rec."Document Type"::Order) and (Rec."No." <> '') and (Rec.Type = Rec.Type::Item) then begin
            Item.Get(Rec."No.");
            if Item."BBT Rework" then begin
                Clear(ReworkTypeByCustItem);
                ReworkTypeByCustItem.SetRange("BTT Rework Item No.", Rec."No.");
                ReworkTypeByCustItem.SetRange("BBT Customer No.", '');
                IF ReworkTypeByCustItem.FindFirst() then begin
                    if ReworkTypeByCustItem."BBT Rework Type" <> '' then Message(ReworkTypeByCustItem."BBT Rework Type");
                end
                else begin
                    ReworkTypeByCustItem.SetRange("BBT Customer No.", Rec."Sell-to Customer No.");
                    IF ReworkTypeByCustItem.FindFirst() then begin
                        if ReworkTypeByCustItem."BBT Rework Type" <> '' then Message(ReworkTypeByCustItem."BBT Rework Type");
                    end;
                end;
            end;
        end
    end;



    //>> BBT 04/08/2025. Aviso y bloqueo al intentar lanzar/aprobar un pedido con Producto de Venta Exclusiva
    [EventSubscriber(ObjectType::codeunit, codeunit::"Release Sales Document", 'OnBeforeReleaseSalesDoc', '', true, true)]
    local procedure OnBeforeReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean; var SkipCheckReleaseRestrictions: Boolean; SkipWhseRequestOperations: Boolean)
    var
        rCustomer: Record Customer;
        rSalesLine: Record "Sales Line";
        rUserSetup: Record "User Setup";
        rExclusivitySalesItems: Record "BBT Exclusivity Sales Items";
        LocalError01: Label 'This order contains item %1 which is exclusive sales',
                    comment = 'ESP="Este pedido contiene el producto %1 que es de venta exclusiva"';
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            rUserSetup.Reset();
            if rUserSetup.Get(UserId) then;
            if not rUserSetup."Exclusive Ecomm Sales Allowed" then begin
                rCustomer.Reset();
                if rCustomer.Get(SalesHeader."Sell-to Customer No.") then;
                rSalesLine.Reset();
                rSalesLine.SetRange("Document Type", SalesHeader."Document Type");
                rSalesLine.SetRange("Document No.", SalesHeader."No.");
                rSalesLine.Setrange(Type, rSalesLine.Type::Item);
                rSalesLine.SetFilter(Quantity, '<>%1', 0);
                //>> BBT. 19/03/2026. Las ventas desde SERIEB no pasan el control de exclusividad
                rSalesLine.SetFilter("Location Code", '<>%1', 'SERIEB');
                //<<
                if rSalesLine.FindSet() then
                    repeat begin
                        rExclusivitySalesItems.Reset();
                        rExclusivitySalesItems.SetRange("Item No.", rSalesLine."No.");
                        rExclusivitySalesItems.SetRange(Related, true);
                        if rExclusivitySalesItems.FindSet() then begin
                            rExclusivitySalesItems.SetRange("National Group", rCustomer."SMG National Group");
                            if not rExclusivitySalesItems.FindFirst() then Error(LocalError01, rSalesLine."No.");
                        end;
                    end;
                    until rSalesLine.Next() = 0;
            end;
        end;
    end;
    //<<

    //>> BBT 11/02/2026.    Evita imprimir el albarán de forma automática para el almacén STOCK.
    //                      El proceso se ejecuta en 'Background' desde la cola de proyectos.
    //                      Esto se hace porque salian todos por la impresora del almacén de MARGA.
    [EventSubscriber(ObjectType::Table, database::"Report Selections", 'OnBeforePrintDocument', '', true, true)]
    local procedure OnBeforePrintDocument(TempReportSelections: Record "Report Selections" temporary; IsGUI: Boolean; var RecVarToPrint: Variant; var IsHandled: Boolean)
    var
        rCompanyInformation: Record "Company Information";
        rLocation: record Location;
        rReportSelections: Record "Report Selections";
        rSalesShipmentHeader: Record "Sales Shipment Header";
        rSalesShipmentLine: Record "Sales Shipment Line";
        ReportID: Integer;
        ResultCode: Code[20];

    begin
        rCompanyInformation.Get();
        if rCompanyInformation.SGA then begin
            if CurrentClientType = ClientType::Background then begin
                // Recuperamos el código del almacén de Sta.Perpetua (En principo STOCK)
                rLocation.Reset();
                rLocation.setrange(SGA, true);
                rLocation.SetRange("SGA Whse Code", Format('000')); // Codigo del almacén en el SGA (TWO)
                rLocation.SetRange("Require Shipment", true);
                rLocation.SetRange(Calidad, false);
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
}