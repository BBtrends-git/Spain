codeunit 51301 "SMG Sales Events"
{
    Permissions = tabledata "Sales Header" = rimd, tabledata "Sales Line" = rimd;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterAssignItemValues', '', false, false)]
    local procedure OnAfterAssignItemValues(Item: Record Item; var SalesLine: Record "Sales Line")
    var
        cuSMGManagement: Codeunit "SMG Management";
    begin
        if cuSMGManagement.IsMarginEnabled() then begin
            cuSMGManagement.SMGGetSalesDiscounts(SalesLine);
            cuSMGManagement.SMGGetCommissionPercent(SalesLine);
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnValidateQuantityOnBeforeResetAmounts', '', false, false)]
    local procedure OnValidateQuantityOnBeforeResetAmounts(var IsHandled: Boolean; var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    var
        cuSMGManagement: Codeunit "SMG Management";
    begin
        if cuSMGManagement.IsMarginEnabled() then begin
            SalesLine.VALIDATE("SMG Discount 1 %");
            SalesLine.VALIDATE("SMG Discount 2 %");
            SalesLine.VALIDATE("SMG Discount 3 %");
            SalesLine.VALIDATE("SMG Discount 4 %");
            SalesLine.VALIDATE("SMG Discount 5 %");
        end;

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnBeforeValidateEvent', 'Unit Price', false, false)]
    local procedure OnBeforeValidateEventUnitPrice(CurrFieldNo: Integer; var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        cuSMGManagement: Codeunit "SMG Management";
    begin
        if cuSMGManagement.IsMarginEnabled() then begin
            Rec.VALIDATE("SMG Discount 1 %");
            Rec.VALIDATE("SMG Discount 2 %");
            Rec.VALIDATE("SMG Discount 3 %");
            Rec.VALIDATE("SMG Discount 4 %");
            Rec.VALIDATE("SMG Discount 5 %");
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Unit Price', false, false)]
    local procedure OnAfterValidateEventUnitPrice(CurrFieldNo: Integer; var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        cuSMGManagement: Codeunit "SMG Management";
    begin
        if cuSMGManagement.IsMarginEnabled() then
            Rec.VALIDATE("SMG Commission %");

    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterValidateEvent', 'Line Discount %', false, false)]
    local procedure OnAfterValidateEventLineDiscount(CurrFieldNo: Integer; var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        cuSMGManagement: Codeunit "SMG Management";
    begin
        if cuSMGManagement.IsMarginEnabled() then
            Rec.VALIDATE("SMG Commission %");
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnValidateLineDiscountPercentOnBeforeUpdateAmounts', '', false, false)]
    local procedure OnValidateLineDiscountPercentOnBeforeUpdateAmounts(CurrFieldNo: Integer; var SalesLine: Record "Sales Line")
    var
        cuSMGManagement: Codeunit "SMG Management";
    begin
        //    if cuSMGManagement.IsMarginEnabled() then
        //        SalesLine."Line Discount Amount" += SalesLine."SMG Discounts Total Amount";
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnBeforeTestJobPlanningLine', '', false, false)]
    local procedure OnBeforeTestJobPlanningLine(CallingFieldNo: Integer; var IsHandled: Boolean; var SalesLine: Record "Sales Line")
    var
        cuSMGManagement: Codeunit "SMG Management";
    begin
        //    if cuSMGManagement.IsMarginEnabled() then
        //        SalesLine."Line Discount Amount" := SalesLine."SMG Discounts Total Amount";
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterUpdateAmountsDone', '', false, false)]
    local procedure OnAfterUpdateAmountsDone(CurrentFieldNo: Integer; var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line")
    var
        cuSMGManagement: Codeunit "SMG Management";
    begin
        if cuSMGManagement.IsMarginEnabled() then begin
            /* PRUEBA
            SalesLine.VALIDATE("SMG Net Unit Price");
            */
            cuSMGManagement.SalesLineMarginCalculation(SalesLine);
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnUpdateAmountsOnAfterCalcLineAmount', '', false, false)]
    local procedure OnUpdateAmountsOnAfterCalcLineAmount(var SalesLine: Record "Sales Line"; var LineAmount: Decimal)
    var
        cuSMGManagement: Codeunit "SMG Management";
    begin


        if cuSMGManagement.IsMarginEnabled() then begin
            cuSMGManagement.SMGCalculateSalesDiscounts(SalesLine);
            /*
            //>> BBT 21/04/2026. Calculo directo del porcentage e importe del descuento
            if SalesLine."Unit Price" = 0 then begin
                SalesLine."Line Discount %" := (1 - ((1 - (SalesLine."SMG Discount 1 %" / 100)) *
                                                            (1 - (SalesLine."SMG Discount 2 %" / 100)) *
                                                            (1 - (SalesLine."SMG Discount 3 %" / 100)) *
                                                            (1 - (SalesLine."SMG Discount 4 %" / 100)) *
                                                            (1 - (SalesLine."SMG Discount 5 %" / 100)))) * 100;
            end
            else begin
                SalesLine."Line Discount %" := (SalesLine."Unit Price" - SalesLine."SMG Net Unit Price") * 100 / SalesLine."Unit Price";
            end;
            SalesLine."Line Discount Amount" := ((SalesLine."Unit Price" * SalesLine."Line Discount %") / 100) * SalesLine.Quantity;
            //<<

            //>> Rounding
            SalesLine."Line Discount %" := Round(SalesLine."Line Discount %", cuSMGManagement.UnitAmountRoundingPrecision);
            SalesLine."Line Discount Amount" := Round(SalesLine."Line Discount Amount", cuSMGManagement.AmountRoundingPrecision);
            //<<
            */
            // Line Amount
            LineAmount := Round(SalesLine."SMG Net Unit Price" * SalesLine.Quantity, cuSMGManagement.AmountRoundingPrecision);
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnValidateLineDiscountPercentOnAfterTestStatusOpen', '', false, false)]
    local procedure OnValidateLineDiscountPercentOnAfterTestStatusOpen(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer)
    var
        cuSMGManagement: Codeunit "SMG Management";
    begin
        if cuSMGManagement.IsMarginEnabled() then begin
            SalesLine."Line Discount %" := 0;
        end;
    end;

    //>> Atención a la nueva versión de gestión de precios y descuentos
    /* PARA BORRAR SI FUNCIONA EL EVENTO ANTERIOR 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", 'OnAfterFindSalesLineLineDisc', '', false, false)]
    local procedure OnAfterFindSalesLineLineDisc(var SalesLine: Record "Sales Line")
    var
        cuSMGManagement: Codeunit "SMG Management";
    begin
        if cuSMGManagement.IsMarginEnabled() then begin
            SalesLine."Line Discount %" := 0;
            //SalesLine."Line Discount Amount" := 0;
        end;
    end;
    */
    //<<
}