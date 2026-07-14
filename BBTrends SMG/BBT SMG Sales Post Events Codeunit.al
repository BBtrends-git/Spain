codeunit 51302 "SMG Sales Post Events"
{
    Permissions = tabledata "Sales Header" = rimd, tabledata "Sales Line" = rimd;

    [EventSubscriber(ObjectType::Table, DATABASE::"Sales Line", 'OnAfterGetLineAmountToHandle', '', false, false)]
    local procedure OnAfterGetLineAmountToHandle(SalesLine: Record "Sales Line"; QtyToHandle: Decimal; var LineAmount: Decimal; var LineDiscAmount: Decimal)
    var
        cuSMGManagement: Codeunit "SMG Management";
    begin
        // El sistema recupera el valor de la linea sin descuentos.
        if cuSMGManagement.IsMarginEnabled() then begin
            LineAmount := Round((QtyToHandle * SalesLine."SMG Net Unit Price") + LineDiscAmount,
                            cuSMGManagement.AmountRoundingPrecision());
        end;
    end;
}