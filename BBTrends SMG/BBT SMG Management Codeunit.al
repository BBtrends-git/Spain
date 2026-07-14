codeunit 51300 "SMG Management"
{
    trigger OnRun();
    begin
    end;

    procedure IsMarginEnabled(): Boolean
    var
        rSMGSetup: record "SMG Setup";
    begin
        rSMGSetup.Reset();
        rSMGSetup.Get();
        if rSMGSetup."SMG Enabled" then
            exit(true)
        else
            exit(false);
    end;

    procedure InitializeMarginConfiguration(var pSMGSetUp: Record "SMG Setup")
    begin
        pSMGSetUp.Reset();
        pSMGSetUp.Get();
    end;

    procedure NetUnitPriceRoundingPrecision(): Decimal;
    var
        rSMGSetup: record "SMG Setup";
    begin
        rSMGSetup.Reset();
        rSMGSetup.Get();
        if rSMGSetUp."Net Price Rounding Precision" = 0 then
            exit(0.01)
        else
            exit(rSMGSetUp."Net Price Rounding Precision");
    end;

    procedure UnitAmountRoundingPrecision(): Decimal;
    var
        rGeneralLedgerSetup: Record "General Ledger Setup";
    begin
        rGeneralLedgerSetup.Reset();
        rGeneralLedgerSetup.get();

        exit(rGeneralLedgerSetup."Unit-Amount Rounding Precision");
    end;

    Procedure AmountRoundingPrecision(): Decimal;
    var
        rGeneralLedgerSetup: Record "General Ledger Setup";
    begin
        rGeneralLedgerSetup.Reset();
        rGeneralLedgerSetup.get();

        exit(rGeneralLedgerSetup."Amount Rounding Precision");
    end;

    procedure SMGGetSalesDiscounts(var pSalesLines: Record "Sales Line")
    var
        cuSMGManagement: Codeunit "SMG Management";
        rCustomer: Record Customer;
        SMGSalesDiscounts: Record "SMG Sales Discounts";
        rSMGSetup: Record "SMG Setup";
    begin
        cuSMGManagement.InitializeMarginConfiguration(rSMGSetup);
        if rCustomer.get(pSalesLines."Bill-to Customer No.") then;

        Clear(pSalesLines."SMG Discount 1 %");
        Clear(pSalesLines."SMG Discount 2 %");
        Clear(pSalesLines."SMG Discount 3 %");
        Clear(pSalesLines."SMG Discount 4 %");
        Clear(pSalesLines."SMG Discount 5 %");

        if rSMGSetup."Discount 1 Enabled" then begin
            if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::Customer, rCustomer."No.") then
                pSalesLines."SMG Discount 1 %" := SMGSalesDiscounts."SMG Discount 1 %"
            else
                if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::Platform, rCustomer."SMG Platform") then
                    pSalesLines."SMG Discount 1 %" := SMGSalesDiscounts."SMG Discount 1 %"
                else
                    if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::"National Group", rCustomer."SMG National Group") then
                        pSalesLines."SMG Discount 1 %" := SMGSalesDiscounts."SMG Discount 1 %"
                    else
                        if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::"Customer Type", rCustomer."SMG Customer Type") then
                            pSalesLines."SMG Discount 1 %" := SMGSalesDiscounts."SMG Discount 1 %"
                        else
                            if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::"Purchasing Group", rCustomer."SMG Purchase Group") then
                                pSalesLines."SMG Discount 1 %" := SMGSalesDiscounts."SMG Discount 1 %";
        end;
        if rSMGSetup."Discount 2 Enabled" then begin
            if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::Customer, rCustomer."No.") then
                pSalesLines."SMG Discount 2 %" := SMGSalesDiscounts."SMG Discount 2 %"
            else
                if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::Platform, rCustomer."SMG Platform") then
                    pSalesLines."SMG Discount 2 %" := SMGSalesDiscounts."SMG Discount 2 %"
                else
                    if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::"National Group", rCustomer."SMG National Group") then
                        pSalesLines."SMG Discount 2 %" := SMGSalesDiscounts."SMG Discount 2 %"
                    else
                        if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::"Customer Type", rCustomer."SMG Customer Type") then
                            pSalesLines."SMG Discount 2 %" := SMGSalesDiscounts."SMG Discount 2 %"
                        else
                            if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::"Purchasing Group", rCustomer."SMG Purchase Group") then
                                pSalesLines."SMG Discount 2 %" := SMGSalesDiscounts."SMG Discount 2 %";
        end;
        if rSMGSetup."Discount 3 Enabled" then begin
            if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::Customer, rCustomer."No.") then
                pSalesLines."SMG Discount 3 %" := SMGSalesDiscounts."SMG Discount 3 %"
            else
                if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::Platform, rCustomer."SMG Platform") then
                    pSalesLines."SMG Discount 3 %" := SMGSalesDiscounts."SMG Discount 3 %"
                else
                    if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::"National Group", rCustomer."SMG National Group") then
                        pSalesLines."SMG Discount 3 %" := SMGSalesDiscounts."SMG Discount 3 %"
                    else
                        if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::"Customer Type", rCustomer."SMG Customer Type") then
                            pSalesLines."SMG Discount 3 %" := SMGSalesDiscounts."SMG Discount 3 %"
                        else
                            if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::"Purchasing Group", rCustomer."SMG Purchase Group") then
                                pSalesLines."SMG Discount 3 %" := SMGSalesDiscounts."SMG Discount 3 %";
        end;
        if rSMGSetup."Discount 4 Enabled" then begin
            if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::Customer, rCustomer."No.") then
                pSalesLines."SMG Discount 4 %" := SMGSalesDiscounts."SMG Discount 4 %"
            else
                if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::Platform, rCustomer."SMG Platform") then
                    pSalesLines."SMG Discount 4 %" := SMGSalesDiscounts."SMG Discount 4 %"
                else
                    if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::"National Group", rCustomer."SMG National Group") then
                        pSalesLines."SMG Discount 4 %" := SMGSalesDiscounts."SMG Discount 4 %"
                    else
                        if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::"Customer Type", rCustomer."SMG Customer Type") then
                            pSalesLines."SMG Discount 4 %" := SMGSalesDiscounts."SMG Discount 4 %"
                        else
                            if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::"Purchasing Group", rCustomer."SMG Purchase Group") then
                                pSalesLines."SMG Discount 4 %" := SMGSalesDiscounts."SMG Discount 4 %";
        end;
        if rSMGSetup."Discount 5 Enabled" then begin
            if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::Customer, rCustomer."No.") then
                pSalesLines."SMG Discount 5 %" := SMGSalesDiscounts."SMG Discount 5 %"
            else
                if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::Platform, rCustomer."SMG Platform") then
                    pSalesLines."SMG Discount 5 %" := SMGSalesDiscounts."SMG Discount 5 %"
                else
                    if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::"National Group", rCustomer."SMG National Group") then
                        pSalesLines."SMG Discount 5 %" := SMGSalesDiscounts."SMG Discount 5 %"
                    else
                        if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::"Customer Type", rCustomer."SMG Customer Type") then
                            pSalesLines."SMG Discount 5 %" := SMGSalesDiscounts."SMG Discount 5 %"
                        else
                            if SMGSalesDiscounts.Get(SMGSalesDiscounts."SMG apply to"::"Purchasing Group", rCustomer."SMG Purchase Group") then
                                pSalesLines."SMG Discount 5 %" := SMGSalesDiscounts."SMG Discount 5 %";
        end;
    end;

    procedure SMGGetCommissionPercent(var pSalesLines: Record "Sales Line")
    var
        rSalesperson: Record "Salesperson/Purchaser";
        rSalesHeader: Record "Sales Header";
    begin
        IF rSalesHeader.Get(pSalesLines."Document Type", pSalesLines."Document No.") then begin
            if rSalesperson.Get(rSalesHeader."Salesperson Code") then
                pSalesLines."SMG Commission %" := rSalesperson."Commission %";
        end;
    end;

    procedure SMGCalculateSalesDiscounts(var pSalesLines: record "Sales Line")
    var
        LineAmount: Decimal;

    begin
        Clear(LineAmount);

        pSalesLines."Line Discount %" := (1 - ((1 - (pSalesLines."SMG Discount 1 %" / 100)) *
                                                (1 - (pSalesLines."SMG Discount 2 %" / 100)) *
                                                (1 - (pSalesLines."SMG Discount 3 %" / 100)) *
                                                (1 - (pSalesLines."SMG Discount 4 %" / 100)) *
                                                (1 - (pSalesLines."SMG Discount 5 %" / 100)))) * 100;

        LineAmount := pSalesLines.Quantity * pSalesLines."Unit Price";
        pSalesLines."SMG Discount 1 Amount" := (LineAmount * pSalesLines."SMG Discount 1 %") / 100;
        LineAmount := (pSalesLines.Quantity * pSalesLines."Unit Price") - pSalesLines."SMG Discount 1 Amount";
        pSalesLines."SMG Discount 2 Amount" := (LineAmount * pSalesLines."SMG Discount 2 %") / 100;
        LineAmount := (pSalesLines.Quantity * pSalesLines."Unit Price") - pSalesLines."SMG Discount 1 Amount"
                                                                     - pSalesLines."SMG Discount 2 Amount";
        pSalesLines."SMG Discount 3 Amount" := (LineAmount * pSalesLines."SMG Discount 3 %") / 100;
        LineAmount := (pSalesLines.Quantity * pSalesLines."Unit Price") - pSalesLines."SMG Discount 1 Amount"
                                                                     - pSalesLines."SMG Discount 2 Amount"
                                                                     - pSalesLines."SMG Discount 3 Amount";
        pSalesLines."SMG Discount 4 Amount" := (LineAmount * pSalesLines."SMG Discount 4 %") / 100;
        LineAmount := (pSalesLines.Quantity * pSalesLines."Unit Price") - pSalesLines."SMG Discount 1 Amount"
                                                                     - pSalesLines."SMG Discount 2 Amount"
                                                                     - pSalesLines."SMG Discount 3 Amount"
                                                                     - pSalesLines."SMG Discount 4 Amount";
        pSalesLines."SMG Discount 5 Amount" := (LineAmount * pSalesLines."SMG Discount 5 %") / 100;
        LineAmount := (pSalesLines.Quantity * pSalesLines."Unit Price") - pSalesLines."SMG Discount 1 Amount"
                                                                     - pSalesLines."SMG Discount 2 Amount"
                                                                     - pSalesLines."SMG Discount 3 Amount"
                                                                     - pSalesLines."SMG Discount 4 Amount"
                                                                     - pSalesLines."SMG Discount 5 Amount";

        pSalesLines."SMG Discounts Total Amount" := pSalesLines."SMG Discount 1 Amount" + pSalesLines."SMG Discount 2 Amount" +
                                           pSalesLines."SMG Discount 3 Amount" + pSalesLines."SMG Discount 4 Amount" +
                                           pSalesLines."SMG Discount 5 Amount";

        if pSalesLines."Line Discount %" = 0 then
            pSalesLines."SMG Net Unit Price" := pSalesLines."Unit Price"
        else
            pSalesLines."SMG Net Unit Price" := Round(pSalesLines."Unit Price" - (pSalesLines."Unit Price" * (pSalesLines."Line Discount %" / 100)),
                                                    NetUnitPriceRoundingPrecision);

        pSalesLines."Line Discount Amount" := ((pSalesLines."Unit Price" * pSalesLines."Line Discount %") / 100) * pSalesLines.Quantity;

        //>> Rounding
        pSalesLines."Line Discount %" := Round(pSalesLines."Line Discount %", UnitAmountRoundingPrecision);
        pSalesLines."Line Discount Amount" := Round(pSalesLines."Line Discount Amount", AmountRoundingPrecision);
        //<<
    end;

    procedure SalesLineMarginCalculation(var pSalesLine: Record "Sales Line")
    var
        rCustomer: Record Customer;
        rItem: Record Item;
        rSalesHeader: Record "Sales Header";
        rSMGSetUp: Record "SMG Setup";
        rItemUnitofMeasure: Record "Item Unit of Measure";
        rSMGCustomerClassification: Record "SMG Customer Classification";

        ExcludeMarginCalculation: Boolean;

        CostAmt1: Decimal;
        CostAmt2: Decimal;
        CostAmt3: Decimal;
        CostAmt4: Decimal;
        CostAmt5: Decimal;
        CostAmt6: Decimal;
        CostAmt7: Decimal;
        CostAmt8: Decimal;
        TotalUnitCost: Decimal;
        ActualUnitPrice: Decimal;
        TotalCosteAmt: Decimal;
        PrecioNetoUnitario: Decimal;
        ItemCost: Decimal;
        //
        CurrencyFactor: Decimal;
        TotalUnitCostDL: Decimal;
        TotalCosteAmtDL: Decimal;
        PrecioNetoUnitarioDL: Decimal;
        MinimumMargin: Decimal;

    begin
        CurrencyFactor := 0;
        TotalUnitCostDL := 0;
        TotalCosteAmtDL := 0;
        PrecioNetoUnitarioDL := 0;
        TotalCosteAmt := 0;
        PrecioNetoUnitario := 0;

        CostAmt1 := 0;
        CostAmt2 := 0;
        CostAmt3 := 0;
        CostAmt4 := 0;
        CostAmt5 := 0;
        CostAmt6 := 0;
        CostAmt7 := 0;

        Clear(ExcludeMarginCalculation);
        Clear(pSalesLine."SMG % APOS Excluded Invoice");
        Clear(pSalesLine."SMG % COLS Excluded Invoice");
        Clear(pSalesLine."SMG Transport Sales %");
        Clear(pSalesLine."SMG Warranty %");
        Clear(pSalesLine."SMG RAEE Amount");
        Clear(pSalesLine."SMG Royalty %");
        Clear(pSalesLine."SMG Blocked for Short Margin");

        if (pSalesLine.Type = pSalesLine.Type::Item) AND (pSalesLine."No." <> Format('')) AND (pSalesLine.Quantity <> 0) then begin
            InitializeMarginConfiguration(rSmgSetup);
            rSalesHeader := SMGGetSalesHeader(pSalesLine);

            CurrencyFactor := 1;
            if rSalesHeader."Currency Factor" <> 0 then
                CurrencyFactor := rSalesHeader."Currency Factor";

            pSalesLine.TestField("No.");
            if rItem.Get(pSalesLine."No.") then;

            rCustomer.Reset();
            if rCustomer.GET(rSalesHeader."Sell-to Customer No.") then;

            rSMGCustomerClassification.Reset();
            rSMGCustomerClassification.SetRange(Type, rSMGCustomerClassification.Type::"Customer Type");
            rSMGCustomerClassification.SetRange(Code, rCustomer."SMG Platform");
            IF rSMGCustomerClassification.findfirst then
                ExcludeMarginCalculation := rSMGCustomerClassification."Exclude Margin Calculation";

            IF not ExcludeMarginCalculation then begin
                if rSmgSetup."COLs Conditions Enabled" then
                    pSalesLine."SMG % COLS Excluded Invoice" := SMGPercentageFFCOLS(rCustomer."No.");
                if rSMGSetUp."APOs Conditions Enabled" then
                    pSalesLine."SMG % APOS Excluded Invoice" := SMGPercentageFFAPOS(rCustomer."No.", rItem."No.");

                pSalesLine."SMG Transport Sales %" := rCustomer."SMG Transport Sales %";
                pSalesLine."SMG Devs Fin %" := rCustomer."SMG Devs Fin %";
                pSalesLine."SMG Commission %" := rCustomer."SMG Commission %";
                pSalesLine."SMG Warranty %" := rItem."SMG Warranty %";
                pSalesLine."SMG Royalty %" := rItem."SMG Royalty %";
                pSalesLine."SMG RAEE Amount" := 0;
                if not rCustomer."SMG No Apply RAEE" then
                    pSalesLine."SMG RAEE Amount" := Round(rItem."SMG RAEE Amount" * CurrencyFactor, AmountRoundingPrecision);

                ActualUnitPrice := pSalesLine."Line Amount" / pSalesLine.Quantity;

                IF pSalesLine."SMG % APOS Excluded Invoice" <> 0 THEN CostAmt1 := ActualUnitPrice * (pSalesLine."SMG % APOS Excluded Invoice" / 100);
                IF pSalesLine."SMG % COLS Excluded Invoice" <> 0 THEN CostAmt2 := ActualUnitPrice * (pSalesLine."SMG % COLS Excluded Invoice" / 100);

                // Cálculo del precio neto unitario ( PV - Dtos ) - APOs - ACOLs
                PrecioNetoUnitario := ActualUnitPrice - CostAmt1 - CostAmt2;
                PrecioNetoUnitarioDL := PrecioNetoUnitario / CurrencyFactor; // Pasamos el PrecioNetoUnitario de la divisa a EUROs

                // El cálculo del resto de costes se hace sobre el PrecioNetoUnitario (con los APOs y COls descontados)
                if PrecioNetoUnitario > 0 then begin
                    IF pSalesLine."SMG Transport Sales %" <> 0 THEN CostAmt3 := PrecioNetoUnitario * (pSalesLine."SMG Transport Sales %" / 100);
                    IF pSalesLine."SMG Warranty %" <> 0 THEN CostAmt4 := PrecioNetoUnitario * (pSalesLine."SMG Warranty %" / 100);
                    IF pSalesLine."SMG RAEE Amount" <> 0 THEN CostAmt5 := pSalesLine."SMG RAEE Amount";
                    IF pSalesLine."SMG Royalty %" <> 0 THEN CostAmt6 := PrecioNetoUnitario * (pSalesLine."SMG Royalty %" / 100);
                    IF pSalesLine."SMG Commission %" <> 0 THEN CostAmt7 := PrecioNetoUnitario * (pSalesLine."SMG Commission %" / 100);
                    IF pSalesLine."SMG Devs Fin %" <> 0 THEN CostAmt8 := PrecioNetoUnitario * (pSalesLine."SMG Devs Fin %" / 100);
                end;

                // Importe total de cargos sobre el coste
                TotalCosteAmt := CostAmt3 + CostAmt4 + CostAmt5 + CostAmt6 + CostAmt7 + CostAmt8;
                TotalCosteAmtDL := TotalCosteAmt / CurrencyFactor;      // Pasamos el TotalCosteAmt a EUROs

                TotalUnitCostDL := 0;
                if rItem."Costing Method" = rItem."Costing Method"::Standard then
                    ItemCost := rItem."Standard Cost"
                else
                    ItemCost := rItem."Unit Cost";

                rItemUnitofMeasure.RESET;
                if rItem."Base Unit of Measure" = pSalesLine."Unit of Measure Code" then begin
                    TotalUnitCostDL := ItemCost;
                end
                else begin
                    rItemUnitofMeasure.SetRange("Item No.", rItem."No.");
                    rItemUnitofMeasure.SetRange(Code, pSalesLine."Unit of Measure Code");
                    if rItemUnitofMeasure.FindFirst() then
                        TotalUnitCostDL := (ItemCost * rItemUnitofMeasure."Qty. per Unit of Measure")
                    else
                        TotalUnitCostDL := 0;
                end;

                TotalUnitCost := (TotalUnitCostDL * CurrencyFactor) + TotalCosteAmt;        //Ajustamos el coste producto a la divisa del pedido
                TotalUnitCostDL := TotalUnitCostDL + TotalCosteAmtDL;
                //<<

                //>> Calculo del margen basado en: Precio de Venta - Dtos - APOs - COLs - CosteProducto - Resto de Costes
                pSalesLine."Unit Cost" := Round(TotalUnitCost, UnitAmountRoundingPrecision);
                pSalesLine."Unit Cost (LCY)" := Round(TotalUnitCostDL, UnitAmountRoundingPrecision);
                pSalesLine."SMG Unit Margin Amount" := PrecioNetoUnitario - TotalUnitCost;

                if (pSalesLine."Line Amount" = 0) and (TotalUnitCost > 0) then begin
                    pSalesLine."SMG Blocked for Short Margin" := true;
                end
                else if (pSalesLine."Line Amount" <> 0) then begin

                    pSalesLine."SMG Margin %" := Round(pSalesLine."SMG Unit Margin Amount" * 100 / PrecioNetoUnitario, 0.01);

                    MinimumMargin := rSMGSetUp."Minimum Margin %";      // % Margen Estandar 
                    rSMGCustomerClassification.Reset();
                    rSMGCustomerClassification.SetRange(Type, rSMGCustomerClassification.Type::"National Group");
                    rSMGCustomerClassification.SetRange(Code, rCustomer."SMG National Group");
                    rSMGCustomerClassification.SetFilter("Minimum Margin %", '>%1', 0);
                    if rSMGCustomerClassification.FindFirst() then
                        MinimumMargin := rSMGCustomerClassification."Minimum Margin %";     // % Margen del Grupo Nacional 

                    if pSalesLine."SMG Margin %" < MinimumMargin then begin
                        pSalesLine."SMG Blocked for Short Margin" := true;
                    end;
                end;
                //<<
            end;

            SalesHeaderMarginCalculation(pSalesLine);

        end;
    end;

    procedure SalesHeaderMarginCalculation(pSalesLine: Record "Sales Line")
    var
        rSalesLineAux: Record "Sales Line";
        rSalesHeader: Record "Sales Header";
        SMGTotalMargin: Decimal;
    begin
        clear(rSalesHeader."SMG Blocked for Short Margin");
        rSalesHeader.Reset();
        rSalesHeader.SetRange("Document Type", pSalesLine."Document Type");
        rSalesHeader.SetRange("No.", pSalesLine."Document No.");
        if rSalesHeader.FindFirst() then begin
            if pSalesLine."SMG Blocked for Short Margin" then
                rSalesHeader."SMG Blocked for Short Margin" := true
            else begin
                rSalesLineAux.Reset;
                rSalesLineAux.SetRange("Document Type", pSalesLine."Document Type");
                rSalesLineAux.SetRange("Document No.", pSalesLine."Document No.");
                rSalesLineAux.SetFilter("Line No.", '<>%1', pSalesLine."Line No.");
                rSalesLineAux.SetRange(Type, rSalesLineAux.type::Item);
                rSalesLineAux.SetRange("SMG Blocked for Short Margin", true);
                if rSalesLineAux.FindFirst() then
                    rSalesHeader."SMG Blocked for Short Margin" := true
                else
                    rSalesHeader."SMG Blocked for Short Margin" := false;
            end;

            rSalesHeader."SMG Total Margin %" := SMGCalculateTotalMargin(pSalesLine);

            rSalesHeader.Modify();
        end;
    end;

    procedure SMGCalculateTotalMargin(pSalesLine: Record "Sales Line"): Decimal
    var
        rSalesLineAux: Record "Sales Line";
        rItem: Record Item;
        SMGCondFFCOLS: Decimal;
        SMGCondFFAPOS: Decimal;
        SumMarginAmount: Decimal;
        vTotalAmount: Decimal;
    begin
        clear(SMGCondFFCOLS);
        Clear(SMGCondFFAPOS);
        Clear(SumMarginAmount);
        Clear(vTotalAmount);
        Clear(rSalesLineAux);

        // Se calcula con todas las lineas del pedido tipo ITEM y la cantidad es diferente de 0
        // Primero la linea del parametro (todavia no está commit en la tabla).
        if (pSalesLine.Type = pSalesLine.type::Item) and (pSalesLine.Quantity <> 0) then begin
            if pSalesLine."SMG Net Unit Price" = 0 then begin
                if rItem.Get(pSalesLine."No.") then
                    if rItem."Costing Method" = rItem."Costing Method"::Standard then
                        SumMarginAmount += -(rItem."Standard Cost" * pSalesLine.Quantity)
                    else
                        SumMarginAmount += -(rItem."Unit Cost" * pSalesLine.Quantity);
            end
            else
                SumMarginAmount += pSalesLine."SMG Unit Margin Amount" * pSalesLine.Quantity;

            vTotalAmount += (pSalesLine."SMG Net Unit Price"
                            - (SMGPercentageFFCOLS(pSalesLine."Bill-to Customer No.") * pSalesLine."SMG Net Unit Price" / 100)
                            - (SMGPercentageFFAPOS(pSalesLine."Bill-to Customer No.", pSalesLine."No.") * pSalesLine."SMG Net Unit Price" / 100))
                            * pSalesLine.Quantity;
        end;

        // Siguiente el resto de lineas
        rSalesLineAux.SetRange("Document Type", pSalesLine."Document Type");
        rSalesLineAux.SetRange("Document No.", pSalesLine."Document No.");
        rSalesLineAux.SetFilter("Line No.", '<>%1', pSalesLine."Line No.");
        rSalesLineAux.SetRange(Type, rSalesLineAux.Type::Item);
        rSalesLineAux.SetFilter(Quantity, '<>%1', 0);
        IF rSalesLineAux.FindSet() then
            repeat
                if rSalesLineAux."SMG Net Unit Price" = 0 then begin
                    if rItem.Get(rSalesLineAux."No.") then
                        if rItem."Costing Method" = rItem."Costing Method"::Standard then
                            SumMarginAmount += -(rItem."Standard Cost" * pSalesLine.Quantity)
                        else
                            SumMarginAmount += -(rItem."Unit Cost" * pSalesLine.Quantity);
                end
                else
                    SumMarginAmount += rSalesLineAux."SMG Unit Margin Amount" * rSalesLineAux.Quantity;

                vTotalAmount += (rSalesLineAux."SMG Net Unit Price"
                                - (SMGPercentageFFCOLS(pSalesLine."Bill-to Customer No.") * rSalesLineAux."SMG Net Unit Price" / 100)
                                - (SMGPercentageFFAPOS(pSalesLine."Bill-to Customer No.", pSalesLine."No.") * rSalesLineAux."SMG Net Unit Price" / 100))
                                * rSalesLineAux.Quantity;
            until rSalesLineAux.Next() = 0;

        // Margen Total
        IF vTotalAmount <> 0 then
            exit(Round(100 * (SumMarginAmount) / (vTotalAmount), 0.01))
        else
            exit(0);
    end;

    procedure SMGPercentageFFCOLS(pCustomer: Code[20]): Decimal
    var
        rSMGCOLSConditions: Record "SMG COLS Conditions";
        rCustomer: Record Customer;
        TotalPercentage: Decimal;
    begin
        Clear(TotalPercentage);
        rCustomer.Reset();
        if rCustomer.Get(pCustomer) then;

        //if rCustomer."SMG Cols Conditions" then begin
        rSMGCOLSConditions.Reset();
        rSMGCOLSConditions.SetRange("Customer No.", pCustomer);
        rSMGCOLSConditions.SetFilter("Starting Date", '<=%1', WorkDate);
        rSMGCOLSConditions.SetFilter("Ending Date", '>=%1', WorkDate);
        if rSMGCOLSConditions.FindFirst() then
            TotalPercentage := rSMGCOLSConditions."% COLS Excluded from Invoice"
        else begin
            rSMGCOLSConditions.SetFilter("Ending Date", '=%1', 0D);
            if rSMGCOLSConditions.FindFirst() then
                TotalPercentage := rSMGCOLSConditions."% COLS Excluded from Invoice"
        end;

        if TotalPercentage <> 0 then
            exit(TotalPercentage)
        else
            exit(0);
        //end;
    end;

    procedure SMGPercentageFFAPOS(pCustomer: Code[20]; pItem: code[20]): Decimal
    var
        rSMGSetup: Record "SMG Setup";
        cuSMGManagement: Codeunit "SMG Management";
        rSMGAPOSConditions: Record "SMG APOS Conditions";
        rCustomer: Record Customer;
        TotalPercentage: Decimal;
        ItemBrand: Code[20];
    begin
        InitializeMarginConfiguration(rSMGSetup);
        Clear(TotalPercentage);
        rCustomer.Reset();
        if rCustomer.Get(pCustomer) then;

        //>> APOS Cliente
        rSMGAPOSConditions.Reset();
        rSMGAPOSConditions.SetRange("Condition Classification", rSMGAPOSConditions."Condition Classification"::Customer);
        rSMGAPOSConditions.SetRange("Condition Code", pCustomer);
        rSMGAPOSConditions.SetRange(Brand, Format(''));
        rSMGAPOSConditions.SetFilter("Starting Date", '<=%1', WorkDate);
        rSMGAPOSConditions.SetFilter("Ending Date", '>=%1', WorkDate);
        if rSMGAPOSConditions.FindSet() then
            repeat
                TotalPercentage += rSMGAPOSConditions."% APOS Excluded from Invoice";
            until rSMGAPOSConditions.Next() = 0;

        rSMGAPOSConditions.SetFilter("Ending Date", '=%1', 0D);
        if rSMGAPOSConditions.FindSet() then
            repeat
                TotalPercentage += rSMGAPOSConditions."% APOS Excluded from Invoice";
            until rSMGAPOSConditions.Next() = 0;
        //<<

        //>> APOS Plataforma
        rSMGAPOSConditions.Reset();
        rSMGAPOSConditions.SetRange("Condition Classification", rSMGAPOSConditions."Condition Classification"::Platform);
        rSMGAPOSConditions.SetRange("Condition Code", rCustomer."SMG Platform");
        rSMGAPOSConditions.SetFilter("Starting Date", '<=%1', WorkDate);
        rSMGAPOSConditions.SetFilter("Ending Date", '>=%1', WorkDate);
        if rSMGAPOSConditions.FindSet() then
            repeat
                TotalPercentage += rSMGAPOSConditions."% APOS Excluded from Invoice"
                until rSMGAPOSConditions.Next() = 0
        else begin
            rSMGAPOSConditions.SetFilter("Ending Date", '=%1', 0D);
            if rSMGAPOSConditions.FindSet() then
                repeat
                    TotalPercentage += rSMGAPOSConditions."% APOS Excluded from Invoice"
                    until rSMGAPOSConditions.Next() = 0
        end;

        if TotalPercentage <> 0 then
            exit(TotalPercentage)
        else
            exit(0);
        //<<
    end;

    procedure SMGAmountStdHistCost(pItem: Code[20]): Decimal
    var
        rSMGHistValuesMargin: Record "SMG Historical Values Margin";
        //rItem: Record Item;
        CurrentAmount: Decimal;
    begin
        Clear(CurrentAmount);
        //rItem.Reset();
        //rItem.Get(pItem);

        //if ritem."SMG Standard Cost History" then begin
        rSMGHistValuesMargin.Reset();
        rSMGHistValuesMargin.SetRange("Item No.", pItem);
        rSMGHistValuesMargin.SetRange(Type, rSMGHistValuesMargin.type::"Standard Cost");
        rSMGHistValuesMargin.SetFilter("Starting Date", '<=%1', WorkDate);
        rSMGHistValuesMargin.SetFilter("Ending Date", '>=%1', WorkDate);
        if rSMGHistValuesMargin.FindFirst() then
            CurrentAmount := rSMGHistValuesMargin."Cost Amount"
        else begin
            rSMGHistValuesMargin.SetFilter("Ending Date", '=%1', 0D);
            if rSMGHistValuesMargin.FindFirst() then
                CurrentAmount := rSMGHistValuesMargin."Cost Amount"
        end;

        if CurrentAmount <> 0 then
            exit(CurrentAmount)
        else
            exit(0);
        //end;
    end;

    procedure SMGAmountTransportEcomHistCost(pItem: Code[20]): Decimal
    var
        rSMGHistValuesMargin: Record "SMG Historical Values Margin";
        //rItem: Record Item;
        CurrentAmount: Decimal;
    begin
        Clear(CurrentAmount);
        //rItem.Reset();
        //rItem.Get(pItem);

        //if ritem."SMG Standard Cost History" then begin
        rSMGHistValuesMargin.Reset();
        rSMGHistValuesMargin.SetRange("Item No.", pItem);
        rSMGHistValuesMargin.SetRange(Type, rSMGHistValuesMargin.type::"Ecomm Transport Cost");
        rSMGHistValuesMargin.SetFilter("Starting Date", '<=%1', WorkDate);
        rSMGHistValuesMargin.SetFilter("Ending Date", '>=%1', WorkDate);
        if rSMGHistValuesMargin.FindFirst() then
            CurrentAmount := rSMGHistValuesMargin."Cost Amount"
        else begin
            rSMGHistValuesMargin.SetFilter("Ending Date", '=%1', 0D);
            if rSMGHistValuesMargin.FindFirst() then
                CurrentAmount := rSMGHistValuesMargin."Cost Amount"
        end;

        if CurrentAmount <> 0 then
            exit(CurrentAmount)
        else
            exit(0);
        //end;
    end;

    procedure SMGGetSalesHeader(PSalesLine: Record "Sales Line"): Record "Sales Header";
    var
        rSalesHeader: Record "Sales Header";
    begin
        rSalesHeader.Reset();
        rSalesHeader.SetRange("Document Type", PSalesLine."Document Type");
        rSalesHeader.SetRange("No.", PSalesLine."Document No.");
        if rSalesHeader.FindFirst() then;

        exit(rSalesHeader);
    end;

    Procedure RecordClassificationExist(ClassificationGroup: Enum "SMG Customer Classification"; ClassificationCode: Code[20])
    var
        rCustomer: Record Customer;
        Label01: Label 'Cannot be deleted. There are clients with this code',
                Comment = 'ESP="No se puede borrar. Existen clientes con este código"';

    begin
        rCustomer.Reset();
        case ClassificationGroup of
            ClassificationGroup::"Purchasing Group":
                rCustomer.SetRange("SMG Purchase Group", ClassificationCode);
            ClassificationGroup::"Customer Type":
                rCustomer.SetRange("SMG Customer Type", ClassificationCode);
            ClassificationGroup::"National Group":
                rCustomer.SetRange("SMG National Group", ClassificationCode);
            ClassificationGroup::Platform:
                rCustomer.SetRange("SMG Platform", ClassificationCode);
        end;
        if rCustomer.FindFirst() then
            Error(Label01);
    end;

    procedure SMGUpdateStandardCost(pItem: Record Item)
    var
        rSMGHistValuesMargin: Record "SMG Historical Values Margin";
    begin
        // Caducamos los registros vigentes con fecha de inicio menor o igual a la actual
        // Primero con fecha final mayor o igual a la actual 
        rSMGHistValuesMargin.Reset();
        rSMGHistValuesMargin.SetRange("Item No.", pItem."No.");
        rSMGHistValuesMargin.SetRange(Type, rSMGHistValuesMargin.type::"Standard Cost");
        rSMGHistValuesMargin.SetFilter("Starting Date", '<=%1', WorkDate());
        rSMGHistValuesMargin.SetFilter("Ending Date", '>=%1', WorkDate());
        if rSMGHistValuesMargin.FindSet() then
            repeat
                rSMGHistValuesMargin.validate("Ending Date", CalcDate('<-1D>', WorkDate()));
                if rSMGHistValuesMargin.Modify() then;
            until rSMGHistValuesMargin.Next() = 0;
        // Siguiente con fecha final en 'blanco'
        rSMGHistValuesMargin.Reset();
        rSMGHistValuesMargin.SetRange("Item No.", pItem."No.");
        rSMGHistValuesMargin.SetRange(Type, rSMGHistValuesMargin.type::"Standard Cost");
        rSMGHistValuesMargin.SetFilter("Starting Date", '<=%1', WorkDate());
        rSMGHistValuesMargin.SetRange("Ending Date", 0D);
        if rSMGHistValuesMargin.FindSet() then
            repeat
                rSMGHistValuesMargin.validate("Ending Date", CalcDate('<-1D>', WorkDate()));
                if rSMGHistValuesMargin.Modify() then;
            until rSMGHistValuesMargin.Next() = 0;

        // Eliminamos los registros con fecha de inicio mayor a la vigente
        rSMGHistValuesMargin.Reset();
        rSMGHistValuesMargin.SetRange("Item No.", pItem."No.");
        rSMGHistValuesMargin.SetRange(Type, rSMGHistValuesMargin.type::"Standard Cost");
        rSMGHistValuesMargin.SetFilter("Starting Date", '>=%1', WorkDate());
        if rSMGHistValuesMargin.FindSet() then
            repeat
                if rSMGHistValuesMargin.Delete() then;
            until rSMGHistValuesMargin.Next() = 0;

        // Insertamos el nuevo coste estandar con fecha de hoy
        Clear(rSMGHistValuesMargin);
        rSMGHistValuesMargin.Init();
        rSMGHistValuesMargin.Validate(Type, rSMGHistValuesMargin.type::"Standard Cost");
        rSMGHistValuesMargin.Validate("Item No.", pItem."No.");
        rSMGHistValuesMargin.Validate("Starting Date", WorkDate());
        rSMGHistValuesMargin.Validate("Ending Date", 0D);
        rSMGHistValuesMargin.validate("Cost Amount", pitem."Standard Cost");
        if rSMGHistValuesMargin.Insert() then;
    end;
}