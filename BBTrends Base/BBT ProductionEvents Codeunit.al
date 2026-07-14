codeunit 50020 "ProductionEvents"
{
    [EventSubscriber(ObjectType::codeunit, codeunit::"Create Prod. Order from Sale", 'OnAfterCreateProdOrderFromSalesLine', '', false, false)]
    local procedure OnAfterCreateProdOrderFromSalesLine(var ProdOrder: Record "Production Order"; var SalesLine: Record "Sales Line")
    var
        Company: Record Company;
        InvSetup: Record "Inventory Setup";
    begin
        //2739
        ProdOrder."Cód. Pedido" := SalesLine."Document No.";
        ProdOrder."No. Linea Pedido" := SalesLine."Line No.";
        //2739 END
    end;

}
