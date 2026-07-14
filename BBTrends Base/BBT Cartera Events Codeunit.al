codeunit 50048 "Cartera Events"
{
    [EventSubscriber(ObjectType::codeunit, codeunit::"Document-Edit", 'OnBeforeModifyCarteraDoc', '', false, false)]
    local procedure OnBeforeModifyCarteraDoc(CurrCarteraDoc: Record "Cartera Doc."; var CarteraDoc: Record "Cartera Doc.")
    begin
        CarteraDoc."Cust./Vendor Bank Acc. Code":=CurrCarteraDoc."Cust./Vendor Bank Acc. Code";
    end;
}
