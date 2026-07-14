codeunit 50030 "Create Prod Order Lines Events"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Edit", 'OnBeforeModifyCarteraDoc', '', false, false)]
    local procedure OnBeforeModifyCarteraDoc(CurrCarteraDoc: Record "Cartera Doc."; var CarteraDoc: Record "Cartera Doc.")
    begin
        CurrCarteraDoc."Cust./Vendor Bank Acc. Code":=CarteraDoc."Cust./Vendor Bank Acc. Code";
    end;
}
