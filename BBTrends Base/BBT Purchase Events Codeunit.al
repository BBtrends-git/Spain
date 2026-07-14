codeunit 50045 "PurchaseEvents"
{
    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnValidatePaymentTermsCodeOnBeforeValidateDueDate', '', false, false)]
    local procedure OnCopyFromItemOnAfterCheck(CurrentFieldNo: Integer; var IsHandled: Boolean; var PurchaseHeader: Record "Purchase Header"; xPurchaseHeader: Record "Purchase Header")
    begin
        IsHandled := true;
        IF (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo") THEN
            PurchaseHeader.VALIDATE("Due Date", PurchaseHeader."Posting Date")
        ELSE
            PurchaseHeader.VALIDATE("Due Date", PurchaseHeader."Document Date");
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Line", 'OnAfterInitHeaderDefaults', '', false, false)]
    local procedure OnAfterInitHeaderDefaults(PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; var TempPurchLine: Record "Purchase Line")
    var
        Location: Record Location;
    begin
        IF PurchLine."Document Type" IN [PurchLine."Document Type"::Invoice, PurchLine."Document Type"::"Credit Memo"] THEN
            IF NOT Location.CantUseLocation(PurchHeader."Location Code") THEN
                PurchLine."Location Code" := '';
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Line", 'OnAfterAssignItemValues', '', false, false)]
    local procedure OnAfterAssignItemValues(CurrentFieldNo: Integer; Item: Record Item; var PurchLine: Record "Purchase Line")
    var
        _Location: Record Location;
    begin
        // SGA
        IF _Location.GET(PurchLine."Location Code") THEN
            IF _Location.SGA AND Item."No SGA management" THEN
                PurchLine."Location Code" := '';
        // SGA   
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Line", 'OnBeforeValidateEvent', 'Location Code', false, false)]
    local procedure OnBeforeValidateEvent(CurrFieldNo: Integer; var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line")
    var
        Location: Record Location;
    begin
        // SGA
        if (Rec.Type = Rec.Type::Item) then
            if Rec."Document Type" in [Rec."Document Type"::Invoice, Rec."Document Type"::"Credit Memo"] then
                if NOT Location.CantUseLocation(Rec."Location Code") then
                    error('El almacén %1 no se puede usar por ser de SGA.', Rec."Location Code");
        // SGA
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnValidatePaymentTermsCodeOnBeforeValidateDueDate', '', false, false)]
    local procedure OnValidatePaymentTermsCodeOnBeforeValidateDueDate(var IsHandled: Boolean; CurrentFieldNo: Integer; var PurchaseHeader: Record "Purchase Header"; xPurchaseHeader: Record "Purchase Header")
    var
        Location: Record Location;
    begin
        IsHandled := true;
        IF (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo") THEN
            PurchaseHeader.VALIDATE("Due Date", PurchaseHeader."Posting Date")
        ELSE
            PurchaseHeader.VALIDATE("Due Date", PurchaseHeader."Document Date");
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnValidatePaymentTermsCodeOnBeforeCalcDueDate', '', false, false)]
    local procedure OnValidatePaymentTermsCodeOnBeforeCalcDueDate(var IsHandled: Boolean; CalledByFieldNo: Integer; CallingFieldNo: Integer; var PurchaseHeader: Record "Purchase Header"; var xPurchaseHeader: Record "Purchase Header")
    var
        Location: Record Location;
        paymentTerms: Record "Payment Terms";
        AdjustDueDate: Codeunit "Due Date-Adjust";
    begin
        IsHandled := true;
        PaymentTerms.GET(PurchaseHeader."Payment Terms Code");
        IF PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::Invoice, PurchaseHeader."Document Type"::"Credit Memo"] THEN BEGIN
            IF PurchaseHeader."Posting Date" <> 0D THEN BEGIN
                PurchaseHeader."Due Date" := CALCDATE(PaymentTerms."Due Date Calculation", PurchaseHeader."Posting Date");
                AdjustDueDate.PurchAdjustDueDate(PurchaseHeader."Due Date", PurchaseHeader."Posting Date", PaymentTerms.CalculateMaxDueDate(PurchaseHeader."Posting Date"), PurchaseHeader."Pay-to Vendor No.");
                PurchaseHeader."Pmt. Discount Date" := CALCDATE(PaymentTerms."Discount Date Calculation", PurchaseHeader."Posting Date");
            END;
        END
        ELSE BEGIN
            PurchaseHeader."Due Date" := CALCDATE(PaymentTerms."Due Date Calculation", PurchaseHeader."Document Date");
            AdjustDueDate.PurchAdjustDueDate(PurchaseHeader."Due Date", PurchaseHeader."Document Date", PaymentTerms.CalculateMaxDueDate(PurchaseHeader."Document Date"), PurchaseHeader."Pay-to Vendor No.");
            PurchaseHeader."Pmt. Discount Date" := CALCDATE(PaymentTerms."Discount Date Calculation", PurchaseHeader."Document Date");
        END;
        // + 003
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnValidatePaymentTermsCodeOnBeforeCalcPmtDiscDate', '', false, false)]
    local procedure OnValidatePaymentTermsCodeOnBeforeCalcPmtDiscDate(CalledByFieldNo: Integer; CallingFieldNo: Integer; var IsHandled: Boolean; var PurchaseHeader: Record "Purchase Header"; var xPurchaseHeader: Record "Purchase Header")
    var
        Location: Record Location;
        paymentTerms: Record "Payment Terms";
        AdjustDueDate: Codeunit "Due Date-Adjust";
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnValidatePaymentTermsCodeOnBeforeValidateDueDateWhenBlank', '', false, false)]
    local procedure OnValidatePaymentTermsCodeOnBeforeValidateDueDateWhenBlank(CurrentFieldNo: Integer; var IsHandled: Boolean; var PurchaseHeader: Record "Purchase Header"; xPurchaseHeader: Record "Purchase Header")
    var
        Location: Record Location;
        paymentTerms: Record "Payment Terms";
        AdjustDueDate: Codeunit "Due Date-Adjust";
    begin
        IsHandled := true;
        // - 003
        //VALIDATE("Due Date","Document Date");
        IF PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::Invoice, PurchaseHeader."Document Type"::"Credit Memo"] THEN
            PurchaseHeader.VALIDATE("Due Date", PurchaseHeader."Posting Date")
        ELSE
            PurchaseHeader.VALIDATE("Due Date", PurchaseHeader."Document Date");
        // + 003
    end;

    [EventSubscriber(ObjectType::page, page::"Purchase Order", 'OnClosePageEvent', '', false, false)]
    local procedure OnClosePageEvent(var Rec: Record "Purchase Header")
    var
        Location: Record Location;
        paymentTerms: Record "Payment Terms";
        AdjustDueDate: Codeunit "Due Date-Adjust";
        Proceso: Codeunit "Interface SGA";
    begin
        // SGA
        IF rec.ModificadoSGA THEN
            IF rec."Status SGA" <> rec."Status SGA"::" " THEN
                Proceso.GestionPedidoCompra(rec."No.");
        CLEAR(Proceso);
    end;

    [EventSubscriber(ObjectType::page, page::"Purchase Order Subform", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure OnAfterValidateEventQuantity(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line")
    var
        Location: Record Location;
        paymentTerms: Record "Payment Terms";
        AdjustDueDate: Codeunit "Due Date-Adjust";
        Proceso: Codeunit "Interface SGA";
        _InfoCompany: Record "Company Information";
    begin
        //SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN
            IF xRec.Quantity <> rec.Quantity THEN
                rec.EnviarSGA();
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnAfterValidateEvent', 'Buy-from Vendor No.', false, false)]
    local procedure OnAfterValidateEventBuyfromVendorNo(CurrFieldNo: Integer; var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header")
    var
        Vendor: Record Vendor;
    begin
        // - DUAs SII        
        if Vendor.Get(Rec."Buy-from Vendor No.") then begin
            Rec.Validate("Invoice Type", Vendor."Invoice Type");
            Rec.Validate("Do Not Send To SII", Vendor."BBT Do Not Send Inv. To SII");
        end;
        // + DUAs SII
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterValidateEventNo(var Rec: Record "Purchase Header"; RunTrigger: Boolean)
    var
        "PurchasesPayablesSetup": Record "Purchases & Payables Setup";
    begin
        // - Grabación de notas de gasto
        PurchasesPayablesSetup.Get();
        if Rec."No. Series" <> '' then begin
            if Rec."No. Series" = PurchasesPayablesSetup."Expense Note Nos." then begin
                Rec."Do Not Send To SII" := true;
                Rec.Modify();
            end;
        end;
        // + Grabación de notas de gasto
    end;

    //>> BBT 13/05/2026. IMPORT STATUS. Se utiliza el desglose de LeadTimes del Producto
    /*
    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnAfterValidateEvent', 'Lead Time Calculation', false, false)]
    local procedure OnAfterValidateEventLeadTimeCalculation(CurrFieldNo: Integer; var Rec: Record "Purchase Header")
    var
        //"PurchasesPayablesSetup": Record "Purchases & Payables Setup";
        EmptyDateformulaVariable: DateFormula;
    begin
        clear(EmptyDateformulaVariable);
        if rec."BBT ETD PI" <> 0D then begin
            IF Rec."Lead Time Calculation" <> EmptyDateformulaVariable then
                rec."BBT Due Date ETD PI" := CalcDate(rec."Lead Time Calculation", rec."BBT ETD PI")
            else
                rec."BBT Due Date ETD PI" := rec."BBT ETD PI";
        end
        else
            Clear(Rec."BBT Due Date ETD PI");
    end;
    */
    //<<

    //>> BBT 13/05/2026. IMPORT STATUS. Se utiliza el desglose de LeadTimes del Producto
    /*
    [EventSubscriber(ObjectType::Table, database::"Purchase Line", 'OnAfterValidateEvent', 'eta', false, false)]
    local procedure OnAfterValidateEventeta(CurrFieldNo: Integer; var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line")
    var
        "PurchasesPayablesSetup": Record "Purchases & Payables Setup";
        EmptyDateformulaVariable: DateFormula;
        PurchaseHeader: Record "Purchase Header";
    begin
        Clear(PurchaseHeader);
        IF PurchaseHeader.get(rec."Document Type", Rec."Document No.") then begin
            IF rec.ETA = 0D then begin
                rec.validate("Planned Receipt Date", PurchaseHeader."BBT Due Date ETD PI");
                rec.validate("Expected Receipt Date", PurchaseHeader."BBT Due Date ETD PI");
                rec.modify;
            end;
            IF rec.ETA <> 0D then begin
                rec.validate("Planned Receipt Date", rec.ETA);
                rec.validate("Expected Receipt Date", rec.ETA);
                rec.modify;
            end;
        end;
    end;
    */
    //<<

    //>> BBT 13/05/2026. IMPORT STATUS. Se utiliza el desglose de LeadTimes del Producto
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertPurchaseLine(var Rec: Record "Purchase Line"; RunTrigger: Boolean)
    var
        rPurchaseHeader: Record "Purchase Header";
    begin
        if Rec.IsTemporary then
            exit;

        rPurchaseHeader.Reset();
        rPurchaseHeader.SetRange("Document Type", Rec."Document Type");
        rPurchaseHeader.SetRange("No.", Rec."Document No.");
        if rPurchaseHeader.FindFirst() then
            rPurchaseHeader.ReCalcDates(rPurchaseHeader);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyPurchaseLine(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; RunTrigger: Boolean)
    var
        rPurchaseHeader: Record "Purchase Header";
    begin
        if not RunTrigger then
            exit;

        rPurchaseHeader.Reset();
        rPurchaseHeader.SetRange("Document Type", Rec."Document Type");
        rPurchaseHeader.SetRange("No.", Rec."Document No.");
        if rPurchaseHeader.FindFirst() then
            rPurchaseHeader.ReCalcDates(rPurchaseHeader);
    end;
    //<<

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Receipt", 'OnAfterCreateInvLines', '', false, false)]
    local procedure OnAfterCreateInvLines(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line")
    var
        rlPurchaseLine: Record "Purchase Line";
        rlPurchaseHeader: Record "Purchase Header";
        rlPurchRcptHeader: Record "Purch. Rcpt. Header";
    begin
        rlPurchaseLine.Reset();
        rlPurchaseLine.SetRange("Document Type", PurchaseLine."Document Type");
        rlPurchaseLine.SetRange("Document No.", PurchaseLine."Document No.");
        rlPurchaseLine.SetFilter(Type, '<>%1', PurchaseLine.Type::" ");
        rlPurchaseLine.SetCurrentKey("Posting Date");
        rlPurchaseLine.SetAscending("Posting Date", true);
        if rlPurchaseLine.FindFirst() then
            if rlPurchRcptHeader.Get(rlPurchaseLine."Receipt No.") then
                if rlPurchaseHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.") then begin
                    rlPurchaseHeader.Validate("Currency Factor", rlPurchRcptHeader."Currency Factor");
                    rlPurchaseHeader.Modify();
                end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Receipt", 'OnAfterInsertInvoiceLineFromReceiptLine', '', false, false)]
    local procedure OnAfterInsertInvoiceLineFromReceiptLine(var PurchRcptLine: Record "Purch. Rcpt. Line"; var PurchLine: Record "Purchase Line"; PurchRcptLine2: Record "Purch. Rcpt. Line"; TransferLine: Boolean)
    begin
        PurchLine."Posting Date" := PurchRcptLine."Posting Date";
        PurchLine.Modify(false);
    end;
}
