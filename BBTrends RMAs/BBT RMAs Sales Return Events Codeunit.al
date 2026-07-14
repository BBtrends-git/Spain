codeunit 51201 "RMAs Sales Return Events"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", OnBeforeConfirmSalesPost, '', false, false)]

    procedure OnBeforeConfirmSalesPost_ForceInvoice(var SalesHeader: Record "Sales Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer; var PostAndSend: Boolean)
    // Función local para manejar el registro solo como Factura
    var
        rSalesLine: Record "Sales Line";
        cuSalesPost: Codeunit "Sales-Post"; // Codeunit 80 para el registro
        ConfirmManagement: Codeunit "Confirm Management";
        PostConfirm01: Label ' Invoiced ?', Comment = 'ESP=Facturar ?';
        Error01: Label 'The posting process has been cancelled by the user', Comment = 'ESP="El proceso de registro ha sido cancelado por el usuario"';
    begin
        // El registro de la devolución propone la opción: Facturar.
        DefaultOption := 2;
        // SOLO SE USA PARA LAS DEVOLUCIONES DE VENTAS con bultos en devolución
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order") and
            WithSalesReturnPackages(SalesHeader) then begin

            // Ocultar el diálogo estándar
            //HideDialog := true;
            //if Confirm(PostConfirm01, false) then begin
            //    SalesHeader.Ship := false;
            //    SalesHeader.Receive := false;
            //    SalesHeader.Invoice := true;    // Forzar la facturación
            //    SalesHeader.Modify(true);

            // Aseguramos que las cantidades pendientes de facturar son las ya recibidas
            rSalesLine.Reset();
            rSalesLine.SetRange("Document Type", rSalesLine."Document Type"::"Return Order");
            rSalesLine.SetRange("Document No.", SalesHeader."No.");
            rSalesLine.SetRange(Type, rSalesLine.Type::Item);
            rSalesLine.SetFilter(Quantity, '<>%1', 0);
            if rSalesLine.FindSet() then
                repeat begin
                    rSalesLine.Validate("Qty. to Invoice", rSalesLine."Return Qty. Rcd. Not Invd.");
                    rSalesLine.Modify();
                end;
                until rSalesLine.Next() = 0;
            //>> La llamada a la Codeunit 80 "Sales-Post" no es necesaria porque el proceso de facturación continua despues del evento.
            //Clear(cuSalesPost);
            //cuSalesPost.Run(SalesHeader);
            //<<

            //end
            //else
            //    Error(Error01);
        end;
    end;

    local procedure WithSalesReturnPackages(SalesHeader: Record "Sales Header"): Boolean
    var
        rRMAPackageLine: record "RMAs Package Line";
        rRMAPostedPackageLine: record "RMAs Posted Package Line";
    begin
        rRMAPackageLine.Reset();
        rRMAPackageLine.SetRange("Return Order No.", SalesHeader."No.");
        if rRMAPackageLine.findfirst then
            exit(true)
        else begin
            rRMAPostedPackageLine.Reset();
            rRMAPostedPackageLine.SetRange("Return Order No.", SalesHeader."No.");
            if rRMAPostedPackageLine.FindFirst() then
                exit(true);
        end;
        exit(false);
    end;

}