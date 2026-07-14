codeunit 50047 "Adjust Inventory Events"
{
    [EventSubscriber(ObjectType::page, page::"Adjust Inventory", 'OnBeforeValidateEvent', 'NewInventory', false, false)]
    local procedure OnBeforeActionEventPostAndPrint(var Rec: Record Location)
    var
        Text50000: Label 'Existen líneas con almacén SGA.', comment = 'ESP="Existen líneas con almacén SGA."';
        rCompanyInformation: Record "Company Information";
    begin
        rCompanyInformation.Get();
        if rCompanyInformation.SGA then
            if rec.SGA then Error(Text50000);
    end;
}
