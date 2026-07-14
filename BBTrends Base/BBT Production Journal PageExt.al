PageExtension 50181 "BBT Production Journal" extends "Production Journal"
{
    actions
    {
        addafter("&Print")
        {
            action("Calc. Consumption")
            {
                ApplicationArea = Basic;
                Caption = 'Calc. Consumption';
                Image = CalculateConsumption;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Calc. Consumption';

                trigger OnAction()
                var
                    CalcConsumption: Report "Calc. Consumption";
                begin
                    GetConsumptionByQtyOutput;
                end;
            }
        }
    }
    local procedure GetConsumptionByQtyOutput()
    var
        rItemJournalLine: Record "Item Journal Line";
        rItemJournalTemplate: Record "Item Journal Template";
        rItem: Record Item;
        rProdOrderComponent: Record "Prod. Order Component";
        OutputQty: Decimal;
        ScrapQty: Decimal;
        ItemRounding: Decimal;
        ExpectedQty: Decimal;
        ConsumptionQty: Decimal;
        ProdOrderLine: Record "Prod. Order Line";
    begin
        // Recalculo del consumo por la cantidad de salida propuesta en el diario.
        rItemJournalTemplate.Reset;
        rItemJournalTemplate.SetRange("Source Code", 'ORDENPROD');
        if rItemJournalTemplate.FindFirst then;
        Clear(OutputQty);
        Clear(ScrapQty);
        rItemJournalLine.Reset;
        rItemJournalLine.SetRange("Journal Template Name", rItemJournalTemplate.Name);
        rItemJournalLine.SetRange("Entry Type", rItemJournalLine."entry type"::Output);
        rItemJournalLine.SetRange("Order Type", rItemJournalLine."order type"::Production);
        rItemJournalLine.SetRange("Order No.", ProdOrderLine."Prod. Order No.");
        rItemJournalLine.SetRange("Order Line No.", ProdOrderLine."Line No.");
        if rItemJournalLine.FindFirst then begin
            OutputQty := rItemJournalLine.Quantity;
            ScrapQty := rItemJournalLine."Scrap Quantity";
            rItemJournalLine.Reset;
            rItemJournalLine.SetRange("Journal Template Name", rItemJournalTemplate.Name);
            rItemJournalLine.SetRange("Entry Type", rItemJournalLine."entry type"::Consumption);
            rItemJournalLine.SetRange("Order Type", rItemJournalLine."order type"::Production);
            rItemJournalLine.SetRange("Order No.", ProdOrderLine."Prod. Order No.");
            rItemJournalLine.SetRange("Order Line No.", ProdOrderLine."Line No.");
            if rItemJournalLine.FindSet then
                repeat
                    Clear(ItemRounding);
                    rItem.Reset;
                    rItem.SetRange("No.", rItemJournalLine."Item No.");
                    if rItem.FindFirst then ItemRounding := rItem."Rounding Precision";
                    Clear(ExpectedQty);
                    rProdOrderComponent.Reset;
                    rProdOrderComponent.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
                    rProdOrderComponent.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
                    rProdOrderComponent.SetRange("Item No.", rItemJournalLine."Item No.");
                    if rProdOrderComponent.FindFirst then begin
                        ExpectedQty := rProdOrderComponent."Expected Quantity";
                        ConsumptionQty := ROUND((ExpectedQty * (OutputQty + ScrapQty)) / ProdOrderLine.Quantity, ItemRounding);
                        rItemJournalLine.Quantity := ConsumptionQty;
                        rItemJournalLine."Quantity (Base)" := ROUND(ConsumptionQty * rItemJournalLine."Qty. per Unit of Measure", ItemRounding);
                        rItemJournalLine."Invoiced Quantity" := rItemJournalLine.Quantity;
                        rItemJournalLine."Invoiced Qty. (Base)" := rItemJournalLine."Quantity (Base)";
                        rItemJournalLine.Modify;
                    end;
                until rItemJournalLine.Next = 0;
        end;
    end;
}
