codeunit 50035 "Purchase Post Yes/No Events"
{
    //>> BBT 29/07/2025. Sustituye al control OnBefore que provocaba doble intento de registro
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Purch.-Post (Yes/No)", 'OnAfterConfirmPost', '', false, false)]
    local procedure OnAfterConfirmPost(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)

    var
        _infoCompany: Record "Company Information";
        Text50000: Label 'No se puede recibir ni enviar un documento de almacén SGA';
        _Procesos: Codeunit "Interface SGA";

    begin
        //SGA. Comprobación para que no se registren PCs o DCs con un almacen de SGA.
        _infoCompany.GET;
        if _infoCompany.SGA then begin
            IF PurchaseHeader.Receive OR PurchaseHeader.Ship THEN begin
                Clear(_Procesos);
                if _Procesos.AlmRegPedCompra(PurchaseHeader) then ERROR(Text50000);
                clear(_Procesos);
            end;
        end;
        //
    end;
    //<<
}