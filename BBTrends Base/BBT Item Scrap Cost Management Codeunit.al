codeunit 50052 "Scrap Cost Management"
{
    Permissions = tabledata "BBT Item Residues" = rdmi;
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        rItem: Record Item;
        rItemResidues: Record "BBT Item Residues";

    begin
        case Rec."Parameter String" of

            'UPDITEMSCRAP':     // Actualizar SCRAP de los productos
                begin
                    rItem.Reset();
                    rItem.SetFilter("Item Category Code", '1*|2*|3*|4*|5*|6*|7*|8*');
                    if rItem.FindSet() then
                        repeat begin
                            rItemResidues.Reset();
                            rItemResidues.SetRange("Item No.", rItem."No.");
                            rItemResidues.SetRange(Scrap, false);
                            rItemResidues.SetFilter("Numeric Value", '<>%1', 0);
                            if rItemResidues.FindFirst() then begin
                                CreateScrapCostRecord(rItem."No.");
                                ProductCalculateScrapCost(rItem."No.");
                            end;
                        end;
                        until rItem.Next() = 0;
                end;
            else
                Error('Parámetro no reconocido: ' + Rec."Parameter String");

        end;
    end;

    // Calculo de los SCRAPs del producto para cada PAIS - MONEDA
    procedure ProductCalculateScrapCost(pItemNo: Code[20]): Boolean
    var
        rlItemResidues: Record "BBT Item Residues";
        rlItemResidues2: Record "BBT Item Residues";
        rlCountryResidualCost: Record "BBT Country Residual Cost";
        vSumResiduesCost: Decimal;
    begin
        rlItemResidues.Reset();
        rlItemResidues.SetRange("Item No.", pItemNo);
        rlItemResidues.SetRange(Scrap, true);
        if rlItemResidues.FindFirst() then begin
            repeat
                if (rlItemResidues."Country/Region" = '') or (rlItemResidues.Currency = '') then
                    Error('Debe informar el código del país y de la divisa')
                else begin
                    vSumResiduesCost := 0;
                    rlCountryResidualCost.Reset();
                    rlCountryResidualCost.SetRange(Country, rlItemResidues."Country/Region");
                    rlCountryResidualCost.SetRange(Currency, rlItemResidues.Currency);
                    if rlCountryResidualCost.FindSet() then begin
                        repeat
                            rlItemResidues2.Reset();
                            rlItemResidues2.SetRange("Item No.", rlItemResidues."Item No.");
                            rlItemResidues2.SetRange("Residue No.", rlCountryResidualCost."Residue Code");
                            rlItemResidues2.SetRange(Scrap, false);
                            if rlItemResidues2.FindFirst() then begin
                                if rlItemResidues2."Numeric Value" = 0 then rlItemResidues2."Numeric Value" := 1;
                                vSumResiduesCost += rlCountryResidualCost."Cost" * rlItemResidues2."Numeric Value";
                            end;
                        until rlCountryResidualCost.Next() = 0;
                    end;
                    vSumResiduesCost := vSumResiduesCost * rlItemResidues."Numeric Value";
                    rlItemResidues."Scrap Cost" := vSumResiduesCost;
                    rlItemResidues.Modify(false);
                end;
            until rlItemResidues.Next() = 0;
        end;
        exit(true);
    end;

    // Calculo del SCRAP de la factura NACIONAL (ES-EUR)
    procedure InvoiceCalculateScrapCost(pSalesInvoice: Code[20]): Decimal;
    var
        rSalesInvoiceLines: record "Sales Invoice Line";
        rItemResidues: Record "BBT Item Residues";
        rItemResiduesAux: Record "BBT Item Residues";
        TotalScrap: Decimal;
    begin
        Clear(TotalScrap);
        rSalesInvoiceLines.Reset();
        rSalesInvoiceLines.SetRange("Document No.", pSalesInvoice);
        rSalesInvoiceLines.SetRange(Type, rSalesInvoiceLines.Type::Item);
        rSalesInvoiceLines.SetFilter(Quantity, '<>%1', 0);
        if rSalesInvoiceLines.FindSet() then begin
            repeat begin
                CreateScrapCostRecord(rSalesInvoiceLines."No.");
                ProductCalculateScrapCost(rSalesInvoiceLines."No.");
                // Suma de los SCRAPs de todos los productos de la factura 
                rItemResidues.Reset();
                rItemResidues.SetRange("Item No.", rSalesInvoiceLines."No.");
                rItemResidues.SetRange(Scrap, true);
                rItemResidues.SetRange("Residue No.", 'SCRAP');
                rItemResidues.SetRange("Country/Region", 'ES');
                rItemResidues.SetRange("Currency", 'EUR');
                if rItemResidues.FindFirst() then
                    TotalScrap := TotalScrap + (rItemResidues."Scrap Cost" * rSalesInvoiceLines.Quantity);
            end;
            until rSalesInvoiceLines.Next() = 0;
        end;
        exit(Round(TotalScrap, 0.01));
    end;

    procedure CreateScrapCostRecord(pItemNo: Code[20])
    var
        rItemResidues: Record "BBT Item Residues";
    begin
        // Este registro es el que acumula el total del coste SCRAP
        rItemResidues.Reset();
        rItemResidues.SetRange("Item No.", pItemNo);
        rItemResidues.SetRange(Scrap, true);
        rItemResidues.SetRange("Residue No.", 'SCRAP');
        rItemResidues.SetRange("Country/Region", 'ES');
        rItemResidues.SetRange("Currency", 'EUR');
        if not rItemResidues.FindFirst() then begin
            rItemResidues.Init();
            rItemResidues.Validate("Item No.", pItemNo);
            rItemResidues.Validate("Residue No.", 'SCRAP');
            rItemResidues.Validate(Scrap, true);
            rItemResidues.Validate("Country/Region", 'ES');
            rItemResidues.Validate("Currency", 'EUR');
            rItemResidues.Validate(rItemResidues."Numeric Value", 1);
            rItemResidues.Insert();
        end;
    end;
}
