codeunit 50029 "Where Used Management Events"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Prod. Order Lines", 'OnAfterInitProdOrderLine', '', false, false)]
    local procedure OnBeforeWhereUsedListInsert(var ProdOrderLine: Record "Prod. Order Line"; ProdOrder: Record "Production Order")
    begin
        //>> SDA. 20190214.
        IF ProdOrderLine."Routing No." <> ProdOrder."Routing No." THEN
            ProdOrderLine."Routing No." := ProdOrder."Routing No.";
        //<<
        //>> SDA. 20190305.
        IF ProdOrder.Status = ProdOrder.Status::Released THEN
            ProdOrderLine."Planning Flexibility" := ProdOrderLine."Planning Flexibility"::None;
        //<<
    end;
}
