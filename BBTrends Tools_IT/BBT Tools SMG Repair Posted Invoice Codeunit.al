Codeunit 59006 "SMG Repair Posted Invoice"
{
    Permissions = tableData "Sales Invoice Header" = rimd,
                    tabledata "Sales Invoice Line" = rimd;

    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        case Rec."Parameter String" of

            'REPAIRINVOICES':
                begin
                    RepairPostedInvoices();
                    Commit();
                end;
            'REPAIRORDERS':
                begin
                    RepairSalesOrders();
                    Commit();
                end;
            'REPAIRINVDTOS':
                begin
                    RepairInvoicesDtos();
                    Commit();
                end;
            'REPAIRORDTOS':
                begin
                    RepairOrdersDtos();
                    Commit();
                end;

            else
                Error('Parámetro no reconocido: ' + Rec."Parameter String");

        end;
    end;

    var
        TotalDescuento: Decimal;

    Local Procedure RepairSalesOrders()
    var
        rSalesLine: Record "Sales Line";
    begin
        rSalesLine.Reset();
        if rSalesLine.FindSet() then
            repeat
                if (rSalesLine."SMG Discount 1 %" <> 0) or
                    (rSalesLine."SMG Discount 2 %" <> 0) or
                    (rSalesLine."SMG Discount 3 %" <> 0) or
                    (rSalesLine."SMG Discount 4 %" <> 0) or
                    (rSalesLine."SMG Discount 5 %" <> 0) then begin
                    TotalDescuento := rSalesLine."SMG Discount 1 Amount" +
                                        rSalesLine."SMG Discount 2 Amount" +
                                        rSalesLine."SMG Discount 3 Amount" +
                                        rSalesLine."SMG Discount 4 Amount" +
                                        rSalesLine."SMG Discount 5 Amount";
                    if TotalDescuento <> rSalesLine."Line Discount Amount" then begin
                        Message('Error en %1 - %2 . SMG: %3 - BC: %4 ', rSalesLine."Document No.", rSalesLine."Line No.",
                                                                        TotalDescuento, rSalesLine."Line Discount Amount");
                    end;
                end;
            until rSalesLine.Next() = 0;
    end;

    Local Procedure RepairPostedInvoices()
    var
        rSalesInvoiceLine: Record "Sales Invoice Line";
    begin
        rSalesInvoiceLine.Reset();
        rSalesInvoiceLine.SetFilter(Quantity, '<>%1', 0);
        rSalesInvoiceLine.SetFilter("Unit Price", '<>%1', 0);
        //rSalesInvoiceLine.SetRange("Document No.", 'FV2611053');
        if rSalesInvoiceLine.FindSet() then
            repeat
                SMGCalculateAmounts(rSalesInvoiceLine)
            until rSalesInvoiceLine.Next() = 0;
    end;

    local procedure SMGCalculateAmounts(var pInvoiceLines: record "Sales invoice Line")
    begin
        if pInvoiceLines."SMG Net Unit Price" <> pInvoiceLines."Unit Price" then begin

            pInvoiceLines."Line Discount %" := (1 - ((1 - (pInvoiceLines."SMG Discount 1 %" / 100)) *
                                                    (1 - (pInvoiceLines."SMG Discount 2 %" / 100)) *
                                                    (1 - (pInvoiceLines."SMG Discount 3 %" / 100)) *
                                                    (1 - (pInvoiceLines."SMG Discount 4 %" / 100)) *
                                                    (1 - (pInvoiceLines."SMG Discount 5 %" / 100)))) * 100;

            if pInvoiceLines."Line Discount %" = 0 then
                pInvoiceLines."SMG Net Unit Price" := pInvoiceLines."Unit Price"
            else
                pInvoiceLines."SMG Net Unit Price" := Round(pInvoiceLines."Unit Price" - (pInvoiceLines."Unit Price" * (pInvoiceLines."Line Discount %" / 100)), 0.01);

            pInvoiceLines."Line Discount Amount" := ((pInvoiceLines."Unit Price" * pInvoiceLines."Line Discount %") / 100) * pInvoiceLines.Quantity;


            //>> Rounding
            pInvoiceLines."Line Discount %" := Round(pInvoiceLines."Line Discount %", 0.00001);
            pInvoiceLines."Line Discount Amount" := Round(pInvoiceLines."Line Discount Amount", 0.01);
            //<<

            pInvoiceLines.Modify()
        end;
    end;

    Local Procedure RepairOrdersDtos()
    var
        rSalesHeader: Record "Sales Header";
        rSalesLine: Record "Sales Line";
        LineAmt: Decimal;
    begin
        rSalesHeader.Reset();
        rSalesHeader.SetRange("Document Type", rSalesHeader."Document Type"::Order);
        rSalesHeader.SetFilter("Document Date", '>%1', DMY2Date(31, 12, 2025));
        if rSalesHeader.FindSet() then
            repeat
                rSalesLine.Reset();
                rSalesLine.SetRange("Document Type", rSalesLine."Document Type"::Order);
                rSalesLine.SetRange("Document No.", rSalesHeader."No.");
                rSalesLine.SetRange("Type", rSalesLine.Type::Item);
                rSalesLine.SetFilter("Quantity", '<>%1', 0);
                rSalesLine.SetFilter("Line Discount %", '<>%1', 0);
                rSalesLine.SetRange("SMG Discounts Total Amount", 0);
                rSalesLine.SetFilter("Unit Price", '<>%1', 0);
                if rSalesLine.FindSet() then
                    repeat
                        Clear(LineAmt);

                        LineAmt := rSalesLine.Quantity * rSalesLine."Unit Price";
                        rSalesLine."SMG Discount 1 Amount" := (LineAmt * rSalesLine."SMG Discount 1 %") / 100;
                        LineAmt := (rSalesLine.Quantity * rSalesLine."Unit Price") - rSalesLine."SMG Discount 1 Amount";
                        rSalesLine."SMG Discount 2 Amount" := (LineAmt * rSalesLine."SMG Discount 2 %") / 100;
                        LineAmt := (rSalesLine.Quantity * rSalesLine."Unit Price") - rSalesLine."SMG Discount 1 Amount"
                                                                                    - rSalesLine."SMG Discount 2 Amount";
                        rSalesLine."SMG Discount 3 Amount" := (LineAmt * rSalesLine."SMG Discount 3 %") / 100;
                        LineAmt := (rSalesLine.Quantity * rSalesLine."Unit Price") - rSalesLine."SMG Discount 1 Amount"
                                                                                    - rSalesLine."SMG Discount 2 Amount"
                                                                                    - rSalesLine."SMG Discount 3 Amount";
                        rSalesLine."SMG Discount 4 Amount" := (LineAmt * rSalesLine."SMG Discount 4 %") / 100;
                        LineAmt := (rSalesLine.Quantity * rSalesLine."Unit Price") - rSalesLine."SMG Discount 1 Amount"
                                                                                    - rSalesLine."SMG Discount 2 Amount"
                                                                                    - rSalesLine."SMG Discount 3 Amount"
                                                                                    - rSalesLine."SMG Discount 4 Amount";
                        rSalesLine."SMG Discount 5 Amount" := (LineAmt * rSalesLine."SMG Discount 5 %") / 100;
                        LineAmt := (rSalesLine.Quantity * rSalesLine."Unit Price") - rSalesLine."SMG Discount 1 Amount"
                                                                                    - rSalesLine."SMG Discount 2 Amount"
                                                                                    - rSalesLine."SMG Discount 3 Amount"
                                                                                    - rSalesLine."SMG Discount 4 Amount"
                                                                                    - rSalesLine."SMG Discount 5 Amount";

                        rSalesLine."SMG Discounts Total Amount" := rSalesLine."SMG Discount 1 Amount" + rSalesLine."SMG Discount 2 Amount" +
                                                                   rSalesLine."SMG Discount 3 Amount" + rSalesLine."SMG Discount 4 Amount" +
                                                                   rSalesLine."SMG Discount 5 Amount";

                        rSalesLine.Modify;

                    until rSalesLine.Next() = 0;
            until rSalesHeader.Next() = 0;
    end;

    Local Procedure RepairInvoicesDtos()
    var
        rInvoiceHeader: Record "Sales Invoice Header";
        rInvoiceLine: Record "Sales Invoice Line";
        LineAmt: Decimal;
    begin
        rInvoiceHeader.Reset();
        rInvoiceHeader.SetFilter("Document Date", '>%1', DMY2Date(31, 12, 2025));
        if rInvoiceHeader.FindSet() then
            repeat
                rInvoiceLine.Reset();
                rInvoiceLine.SetRange("Document No.", rInvoiceHeader."No.");
                rInvoiceLine.SetRange("Type", rInvoiceLine.Type::Item);
                rInvoiceLine.SetFilter("Quantity", '<>%1', 0);
                rInvoiceLine.SetFilter("Line Discount %", '<>%1', 0);
                rInvoiceLine.SetRange("SMG Discounts Total Amount", 0);
                rInvoiceLine.SetFilter("Unit Price", '<>%1', 0);
                if rInvoiceLine.FindSet() then
                    repeat
                        Clear(LineAmt);

                        LineAmt := rInvoiceLine.Quantity * rInvoiceLine."Unit Price";
                        rInvoiceLine."SMG Discount 1 Amount" := (LineAmt * rInvoiceLine."SMG Discount 1 %") / 100;
                        LineAmt := (rInvoiceLine.Quantity * rInvoiceLine."Unit Price") - rInvoiceLine."SMG Discount 1 Amount";
                        rInvoiceLine."SMG Discount 2 Amount" := (LineAmt * rInvoiceLine."SMG Discount 2 %") / 100;
                        LineAmt := (rInvoiceLine.Quantity * rInvoiceLine."Unit Price") - rInvoiceLine."SMG Discount 1 Amount"
                                                                                    - rInvoiceLine."SMG Discount 2 Amount";
                        rInvoiceLine."SMG Discount 3 Amount" := (LineAmt * rInvoiceLine."SMG Discount 3 %") / 100;
                        LineAmt := (rInvoiceLine.Quantity * rInvoiceLine."Unit Price") - rInvoiceLine."SMG Discount 1 Amount"
                                                                                    - rInvoiceLine."SMG Discount 2 Amount"
                                                                                    - rInvoiceLine."SMG Discount 3 Amount";
                        rInvoiceLine."SMG Discount 4 Amount" := (LineAmt * rInvoiceLine."SMG Discount 4 %") / 100;
                        LineAmt := (rInvoiceLine.Quantity * rInvoiceLine."Unit Price") - rInvoiceLine."SMG Discount 1 Amount"
                                                                                    - rInvoiceLine."SMG Discount 2 Amount"
                                                                                    - rInvoiceLine."SMG Discount 3 Amount"
                                                                                    - rInvoiceLine."SMG Discount 4 Amount";
                        rInvoiceLine."SMG Discount 5 Amount" := (LineAmt * rInvoiceLine."SMG Discount 5 %") / 100;
                        LineAmt := (rInvoiceLine.Quantity * rInvoiceLine."Unit Price") - rInvoiceLine."SMG Discount 1 Amount"
                                                                                    - rInvoiceLine."SMG Discount 2 Amount"
                                                                                    - rInvoiceLine."SMG Discount 3 Amount"
                                                                                    - rInvoiceLine."SMG Discount 4 Amount"
                                                                                    - rInvoiceLine."SMG Discount 5 Amount";

                        rInvoiceLine."SMG Discounts Total Amount" := rInvoiceLine."SMG Discount 1 Amount" + rInvoiceLine."SMG Discount 2 Amount" +
                                                                   rInvoiceLine."SMG Discount 3 Amount" + rInvoiceLine."SMG Discount 4 Amount" +
                                                                   rInvoiceLine."SMG Discount 5 Amount";

                        rInvoiceLine.Modify;

                    until rInvoiceLine.Next() = 0;
            until rInvoiceHeader.Next() = 0;
    end;
}