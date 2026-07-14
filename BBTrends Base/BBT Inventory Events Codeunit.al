codeunit 50041 "Inventory Events"
{
    [EventSubscriber(ObjectType::codeunit, codeunit::"Inventory Profile Offsetting", 'OnBeforeTransShptTransLineToProfile', '', false, false)]
    local procedure OnBeforeTransShptTransLineToProfile(var InventoryProfile: Record "Inventory Profile"; var IsHandled: Boolean)
    var
        _InfoCompany: Record "Company Information";
        CopyOfItem: Record Item;
    begin
        IsHandled:=true;
    end;
    [EventSubscriber(ObjectType::codeunit, codeunit::"Inventory Profile Offsetting", 'OnMaintainPlanningLineOnAfterPopulateReqLineFields', '', false, false)]
    local procedure OnMaintainPlanningLineOnAfterPopulateReqLineFields(DemandInvtProfile: Record "Inventory Profile"; Direction: Option; NewPhase: Option; var ReqLine: Record "Requisition Line"; var SupplyInvtProfile: Record "Inventory Profile"; var TempSKU: Record "Stockkeeping Unit")
    var
        Stockkeeping_Unit: Record "Stockkeeping Unit";
    begin
        // I - RND-114
        ReqLine.VALIDATE("No.");
        Stockkeeping_Unit.SETRANGE("Item No.", ReqLine."No.");
        Stockkeeping_Unit.SETRANGE("Variant Code", ReqLine."Variant Code");
        Stockkeeping_Unit.SETRANGE("Replenishment System", TempSKU."Replenishment System");
        IF Stockkeeping_Unit.FINDFIRST THEN //IF Stockkeeping_Unit."Output production in location" <> '' THEN
            ReqLine."Location Code":=Stockkeeping_Unit."Location Code";
    // F - RND-114
    end;
    [EventSubscriber(ObjectType::codeunit, codeunit::"Inventory Profile Offsetting", 'OnBeforeTempTransferSKUInsert', '', false, false)]
    local procedure OnBeforeTempTransferSKUInsert(TransferLine: Record "Transfer Line"; var TempTransferSKU: Record "Stockkeeping Unit" temporary)
    var
        Stockkeeping_Unit: Record "Stockkeeping Unit";
    begin
        //>> SDA-20190328
        TransferPlanningParameters(TempTransferSKU);
    //<<
    end;
    local procedure TransferPlanningParameters(var SKU: Record "Stockkeeping Unit")
    var
        SKU2: Record "Stockkeeping Unit";
        PlanningGetParameters: Codeunit "Planning-Get Parameters";
    begin
        PlanningGetParameters.AtSKU(SKU2, SKU."Item No.", SKU."Variant Code", SKU."Location Code");
        SKU:=SKU2;
    end;
}
