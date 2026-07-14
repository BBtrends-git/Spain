codeunit 51200 "RMAs Management"
{
    procedure ReturnAdjustment(var pRMAPackage: Record "RMAs Package"; pPackageLine: Integer);
    var
        rRMASetup: Record "RMAs Setup";
        rNSeries: Record "No. Series";
        rRMAPackageLine: Record "RMAs Package Line";
        rSalesReturn: Record "Sales Header";
        rSalesReturnTmp: Record "Sales Header" temporary;
        rSalesReturnLine: Record "Sales Line";
        rSalesReturnLineTmp: Record "Sales Line" temporary;
        rSalesReturnLineAux: Record "Sales Line";
        rSalesReturnLineRec: Record "Sales Line";
        rRMAPostedPackage: Record "RMAs Posted Package";
        rRMAPostedPackageLine: record "RMAs Posted Package Line";
        rRMAPostedPackageAux: Record "RMAs Posted Package";
        rRMAPostedPackageLineAux: record "RMAs Posted Package Line";
        rRMAPackageAux: Record "RMAs Package";
        rRMAPackageLineAux: Record "RMAs Package Line";
        ToDelete: Boolean;

        cuSalesPost: Codeunit "Sales-Post";

        PendingRegistration: Boolean;
        PackageQTY: Integer;
        PackageLineQTY: Integer;
        SalesReturnQTY: Integer;
        SalesReturnLineQTY: Integer;
        PackagePendingQTY: Integer;
        PackageLinePendingQTY: Integer;
        PostedPackageQTY: Integer;

        Error01: Label 'Serial number %1 does not exist', Comment = 'ESP="No existe el Númerador de Serie %1"';
        Error02: Label 'The package status is not closed', Comment = 'ESP="El bulto no está cerrado"';
        Error03: Label 'The package has already been registered', Comment = 'ESP="El bulto ya ha sido registrado"';
        Error04: Label 'Product %1 with Quantity %2 has no assigned Quality', Comment = 'ESP="El Producto %1 con Cantidad %2, no tiene Calidad asignada"';
        Error05: Label 'The Sales Return %1 is not found', Comment = 'ESP="No existe la Devolución %1"';
        //Error06: Label 'The registered package  %1 could not be inserted', Comment = 'ESP="No se ha podido dar de alta el bulto registrado %1"';
        //Error07: Label 'The registered line package  %1 - %2 - %3 could not be inserted', Comment = 'ESP="No se ha podido dar de alta la linea bulto registrado %1 - %2 - %3"';
        Error08: Label 'An error occurred while recording the product journal.', Comment = 'ESP="Se ha producido un error al registrar en el diario de producto."';
    begin
        // Recuperamos la configuración y comprobamos
        rRMASetup.Reset();
        rRMASetup.Get();
        rRMASetup.TestField("Journal Template Name");
        rRMASetup.TestField("Journal Batch Name");
        rRMASetup.TestField("Return Series");
        rRMASetup.TestField("Returns Warehouse");
        rRMASetup.TestField("Warehouse Quality A");
        rRMASetup.TestField("Warehouse Quality B");
        if not rRMASetup."Scrap Adjust" then
            rRMASetup.TestField("Warehouse Quality C");

        rNSeries.Reset();
        rNSeries.SetRange(Code, rRMAsetup."Return Series");
        if not rNSeries.FindFirst() then
            ERROR(Error01, rRMAsetup."Return Series");

        // Revisión del estado del bulto
        if pRMAPackage."Package Status" = pRMAPackage."Package Status"::Open then
            Error(Error02);
        //if pRMAPackage."Registered Package" then
        //    Error(Error03);

        // Comprobamos que todas las cantidades están asignadas a alguna calidad y que exista la devolución
        PendingRegistration := false;
        rRMAPackageLine.Reset();
        rRMAPackageLine.SetRange("Package No.", pRMAPackage."Package No.");
        rRMAPackageLine.SetFilter("Item No.", '<>%1', '');
        rRMAPackageLine.SetFilter(Quantity, '>%1', 0);
        if rRMAPackageLine.FindSet() then
            repeat
                if Format(rRMAPackageLine.Quality) = '0' then
                    Error(Error04, rRMAPackageLine."Item No.", rRMAPackageLine.Quantity);
                if rRMAPackageLine."Return Order No." <> '' then begin
                    rSalesReturn.Reset();
                    rSalesReturn.SetRange("Document Type", rSalesReturn."Document Type"::"Return Order");
                    rSalesReturn.SetRange("No.", rRMAPackageLine."Return Order No.");
                    if not rSalesReturn.FindFirst() then
                        Error(Error05, rRMAPackageLine."Return Order No.")
                    else begin
                        rSalesReturnLine.Reset();
                        rSalesReturnLine.SetRange("Document Type", rSalesReturn."Document Type"::"Return Order");
                        rSalesReturnLine.SetRange("Document No.", rRMAPackageLine."Return Order No.");
                        rSalesReturnLine.SetRange(Type, rSalesReturnLine.type::Item);
                        if rSalesReturnLine.FindFirst() then begin
                            rSalesReturn.PerformManualRelease();            // Existe la devolución/lineas. Comprobamos el estatus Lanzado
                            rSalesReturn.PerformManualReopen(rSalesReturn); // Volvemos el estatus a Abierto.
                        end;
                    end;
                end;
                rRMAPackageLine.CalcFields("Posted Quantity");
                if rRMAPackageLine.Quantity - rRMAPackageLine."Posted Quantity" > 0 then
                    PendingRegistration := true;
            until rRMAPackageLine.Next() = 0;
        if not PendingRegistration then
            Error(Error03);

        // Ponemos en una tabla temporal las devoluciones que tenemos en el bulto y
        // sus lineas, acumulando las cantidades para el mismo producto
        //>>
        rSalesReturnTmp.Reset();
        rSalesReturnTmp.DeleteAll();
        rSalesReturnLineTmp.Reset();
        rSalesReturnLineTmp.DeleteAll();
        // Cabecera de la devolución.
        rRMAPackageLine.Reset();
        rRMAPackageLine.SetRange("Package No.", pRMAPackage."Package No.");
        rRMAPackageLine.SetFilter("Item No.", '<>%1', '');
        rRMAPackageLine.SetFilter(Quantity, '>%1', 0);
        rRMAPackageLine.SetFilter("Remaining Quantity", '>%1', 0);
        //>> Procesamos solo la linea del bulto que se indica
        if pPackageLine <> 0 then
            rRMAPackageLine.SetRange("Package Line", pPackageLine);
        //<<    
        if rRMAPackageLine.FindSet() then
            repeat
                // Linea del bulto con devolución
                if rRMAPackageLine."Return Order No." <> '' then begin
                    // La devolución tiene lineas con el producto que indica el bulto
                    rSalesReturnLine.Reset();
                    rSalesReturnLine.SetRange("Document Type", rSalesReturn."Document Type"::"Return Order");
                    rSalesReturnLine.SetRange("Document No.", rRMAPackageLine."Return Order No.");
                    rSalesReturnLine.SetRange(Type, rSalesReturnLine.type::Item);
                    rSalesReturnLine.SetRange("No.", rRMAPackageLine."Item No.");
                    if rSalesReturnLine.FindFirst() then begin
                        rSalesReturnTmp.Reset();
                        rSalesReturnTmp.SetRange("Document Type", rSalesReturn."Document Type"::"Return Order");
                        rSalesReturnTmp.SetRange("No.", rRMAPackageLine."Return Order No.");
                        if not rSalesReturnTmp.FindFirst() then begin
                            rSalesReturn.Reset();
                            rSalesReturn.SetRange("Document Type", rSalesReturn."Document Type"::"Return Order");
                            rSalesReturn.SetRange("No.", rRMAPackageLine."Return Order No.");
                            if rSalesReturn.FindFirst() then begin
                                if rSalesReturn."Location Code" <> rRMASetup."Returns Warehouse" then begin
                                    rSalesReturn.validate("Location Code", rRMASetup."Returns Warehouse"); //Aseguramos que el almacén sea el de devoluciones
                                    rSalesReturn.Modify();
                                end;
                                rSalesReturnTmp.Init();
                                rSalesReturnTmp := rSalesReturn;
                                rSalesReturnTmp.Insert();
                            end;
                        end;
                    end;
                end;
            until rRMAPackageLine.Next() = 0;
        // Lineas de la devolución con acumulado de las cantidades por producto.
        rSalesReturnTmp.Reset();
        if rSalesReturnTmp.FindSet() then
            repeat begin
                rSalesReturnLine.Reset();
                rSalesReturnLine.SetRange("Document Type", rSalesReturnTmp."Document Type"::"Return Order");
                rSalesReturnLine.SetRange("Document No.", rSalesReturnTmp."No.");
                rSalesReturnLine.SetRange(Type, rSalesReturnLine.Type::Item);
                rSalesReturnLine.SetFilter(Quantity, '>%1', 0);
                if rSalesReturnLine.FindSet() then
                    repeat
                        if rSalesReturnLine."Location Code" <> rRMASetup."Returns Warehouse" then begin
                            rSalesReturnLine.validate("Location Code", rRMASetup."Returns Warehouse"); //Aseguramos que el almacén de las lineas sea el de devoluciones
                            rSalesReturnLine.Modify();
                        end;
                        rSalesReturnLineTmp.Reset();
                        rSalesReturnLinetmp.SetRange("Document Type", rSalesReturnLine."Document Type"::"Return Order");
                        rSalesReturnLinetmp.SetRange("Document No.", rSalesReturnLine."Document No.");
                        rSalesReturnLinetmp.SetRange(Type, rSalesReturnLine.Type::Item);
                        rSalesReturnLinetmp.SetRange("No.", rSalesReturnLine."No.");
                        if not rSalesReturnLineTmp.FindFirst() then begin
                            rSalesReturnLineTmp := rSalesReturnLine;
                            rSalesReturnLineTmp."Return Qty. to Receive" := rSalesReturnLine.Quantity - rSalesReturnLine."Return Qty. Received";
                            rSalesReturnLineTmp.Insert();
                        end
                        else begin
                            rSalesReturnLineTmp."Return Qty. to Receive" += rSalesReturnLine.Quantity - rSalesReturnLine."Return Qty. Received";
                            rSalesReturnLineTmp.Modify();
                        end;

                    until rSalesReturnLine.Next() = 0;
            end;
            until rSalesReturnTmp.Next() = 0;
        //<<

        //>> Proceso de reparto de cantidades y registro.
        rSalesReturnTmp.Reset();
        if rSalesReturnTmp.FindSet() then begin
            repeat begin
                rSalesReturnLineTmp.Reset();
                rSalesReturnLineTmp.SetRange("Document Type", rSalesReturnTmp."Document Type"::"Return Order");
                rSalesReturnLineTmp.SetRange("Document No.", rSalesReturnTmp."No.");
                rSalesReturnLineTmp.SetRange(Type, rSalesReturnLineTmp.Type::Item);
                rSalesReturnLineTmp.SetFilter("Return Qty. to Receive", '>%1', 0);
                if rSalesReturnLineTmp.FindSet() then
                    repeat begin
                        SalesReturnQTY := rSalesReturnLineTmp."Return Qty. to Receive";
                        // Inicializamos la cantidad a recibir de la linea de la devolución
                        rSalesReturnLine.Reset();
                        rSalesReturnLine.SetRange("Document Type", rSalesReturnLineTmp."Document Type"::"Return Order");
                        rSalesReturnLine.SetRange("Document No.", rSalesReturnLineTmp."Document No.");
                        rSalesReturnLine.SetRange(Type, rSalesReturnLineTmp.Type::Item);
                        rSalesReturnLine.SetRange("No.", rSalesReturnLineTmp."No.");
                        rSalesReturnLine.SetFilter(Quantity, '>%1', 0);
                        if rSalesReturnLine.FindSet() then
                            repeat begin
                                rSalesReturnLine.validate("Return Qty. to Receive", 0);
                                rSalesReturnLine.Modify();
                            end;
                            until rSalesReturnLine.Next() = 0;

                        //Calculo de la cantidad del bulto/producto
                        Clear(PackageQTY);
                        rRMAPackageLine.Reset();
                        rRMAPackageLine.SetRange("Package No.", pRMAPackage."Package No.");
                        rRMAPackageLine.SetRange("Return Order No.", rSalesReturnTmp."No.");
                        rRMAPackageLine.SetRange("Item No.", rSalesReturnLineTmp."No.");
                        rRMAPackageLine.SetFilter(Quantity, '>%1', 0);
                        //>> Procesamos solo la linea del bulto que se indica
                        if pPackageLine <> 0 then
                            rRMAPackageLine.SetRange("Package Line", pPackageLine);
                        //<< 
                        if rRMAPackageLine.FindSet() then
                            repeat begin
                                rRMAPackageLine.CalcFields("Posted Quantity");
                                PackageQTY := PackageQTY + rRMAPackageLine.Quantity - rRMAPackageLine."Posted Quantity";
                            end;
                            until rRMAPackageLine.Next() = 0;
                        //Si en la devolución hay menos cantidad que en el bulto se deja la diferencia en el bulto
                        PackagePendingQTY := PackageQTY;
                        if SalesReturnQTY < PackageQTY then
                            PackagePendingQTY := SalesReturnQTY;

                        rRMAPackageLine.Reset();
                        rRMAPackageLine.SetRange("Package No.", pRMAPackage."Package No.");
                        rRMAPackageLine.SetRange("Return Order No.", rSalesReturnTmp."No.");
                        rRMAPackageLine.SetRange("Item No.", rSalesReturnLineTmp."No.");
                        rRMAPackageLine.SetFilter(Quantity, '>%1', 0);
                        //>> Procesamos solo la linea del bulto que se indica
                        if pPackageLine <> 0 then
                            rRMAPackageLine.SetRange("Package Line", pPackageLine);
                        //<< 
                        if rRMAPackageLine.FindSet() then
                            repeat
                                rRMAPackageLine.CalcFields("Posted Quantity");
                                PackageLinePendingQTY := rRMAPackageLine.Quantity - rRMAPackageLine."Posted Quantity";
                                // Las unidades a devolver deben ser > 0
                                if PackagePendingQTY > 0 then begin
                                    PostedPackageQTY := 0;
                                    // Asignamos cantidades a recibir
                                    rSalesReturnLine.Reset();
                                    rSalesReturnLine.SetRange("Document Type", rSalesReturnLineTmp."Document Type"::"Return Order");
                                    rSalesReturnLine.SetRange("Document No.", rSalesReturnLineTmp."Document No.");
                                    rSalesReturnLine.SetRange(Type, rSalesReturnLineTmp.Type::Item);
                                    rSalesReturnLine.SetRange("No.", rSalesReturnLineTmp."No.");
                                    rSalesReturnLine.SetFilter(Quantity, '>%1', 0);
                                    if rSalesReturnLine.FindSet() then
                                        repeat
                                            if (PackageLinePendingQTY > 0) then begin
                                                //Si hay más cantidad que en el bulto se deja la diferencia sin registrar en el DV 
                                                if PackagePendingQTY < PackageLinePendingQTY then
                                                    PackageLinePendingQTY := PackagePendingQTY;

                                                SalesReturnLineQTY := rSalesReturnLine.Quantity - (rSalesReturnLine."Return Qty. to Receive" + rSalesReturnLine."Return Qty. Received");
                                                if SalesReturnLineQTY > 0 then begin
                                                    if SalesReturnLineQTY >= PackageLinePendingQTY then begin
                                                        rSalesReturnLine.Validate("Return Qty. to Receive", (rSalesReturnLine."Return Qty. to Receive" + PackageLinePendingQTY));
                                                        //rSalesReturnLine.Validate("Return Qty. to Receive (Base)", PackageLinePendingQTY);

                                                        PostedPackageQTY := PostedPackageQTY + PackageLinePendingQTY;
                                                        PackagePendingQTY := PackagePendingQTY - PackageLinePendingQTY;
                                                        PackageLinePendingQTY := 0;
                                                    end
                                                    else begin
                                                        rSalesReturnLine.Validate("Return Qty. to Receive", SalesReturnLineQTY);
                                                        //rSalesReturnLine.Validate("Return Qty. to Receive (Base)", rSalesReturnLine."Quantity (Base)");

                                                        PostedPackageQTY := PostedPackageQTY + SalesReturnLineQTY;
                                                        PackageLinePendingQTY := PackageLinePendingQTY - SalesReturnLineQTY;
                                                        PackagePendingQTY := PackagePendingQTY - SalesReturnLineQTY;
                                                    end;
                                                    //else begin
                                                    //    rSalesReturnLine.Validate("Return Qty. to Receive", 0);
                                                    //    rSalesReturnLine.Validate("Return Qty. to Receive (Base)", 0);
                                                    //end;

                                                    rSalesReturnLine.Modify();
                                                end;
                                            end;
                                        until rSalesReturnLine.Next() = 0;

                                    //Se crea la linea del bulto registrado. Cantidad cuadrada con el recibido de la devolución
                                    rRMAPostedPackageLine.ManageRMAPostedPackageLine(rRMAPostedPackage, rRMAPostedPackageLine,
                                                                                    pRMAPackage, rRMAPAckageLine, PostedPackageQTY);
                                end;
                            until rRMAPackageLine.Next() = 0;
                    end;
                    until rSalesReturnLineTmp.Next() = 0;
            end;
            until rSalesReturnTmp.Next() = 0;

            // Registramos la devolución o devoluciones del bulto
            rSalesReturnTmp.Reset();
            if rSalesReturnTmp.FindSet() then begin
                repeat begin
                    //Comprobamos que la devolución tiene lineas con unidades pendientes de registrar
                    rSalesReturnLineTmp.Reset();
                    rSalesReturnLineTmp.Reset();
                    rSalesReturnLineTmp.SetRange("Document Type", rSalesReturnTmp."Document Type"::"Return Order");
                    rSalesReturnLineTmp.SetRange("Document No.", rSalesReturnTmp."No.");
                    rSalesReturnLineTmp.SetRange(Type, rSalesReturnLineTmp.Type::Item);
                    rSalesReturnLineTmp.SetFilter("Return Qty. to Receive", '>%1', 0);
                    if rSalesReturnLineTmp.FindFirst() then begin
                        rSalesReturnTmp.Validate("Posting Date", WorkDate());
                        rSalesReturnTmp.Ship := false;
                        rSalesReturnTmp.Invoice := false;
                        rSalesReturnTmp.Receive := true;
                        cuSalesPost.RUN(rSalesReturnTmp);       // Registro de la devolución
                    end;
                end;
                until rSalesReturnTmp.Next() = 0;
            end;
        end;
        //<<

        //>>Si en el bulto existen lineas sin devolución, hay que añadirlas al bulto posted.
        rRMAPackageLine.Reset();
        rRMAPackageLine.SetRange("Package No.", pRMAPackage."Package No.");
        rRMAPackageLine.SetFilter("Return Order No.", '=%1', '');
        //rRMAPackageLine.SetFilter("Item No.", '<>%1', '');        //Han decidido entrar lineas sin producto cuando llega algo que no es nuestro ¿¿¿???
        rRMAPackageLine.SetFilter(Quantity, '>%1', 0);
        //>> Procesamos solo la linea del bulto que se indica
        if pPackageLine <> 0 then
            rRMAPackageLine.SetRange("Package Line", pPackageLine);
        //<< 
        if rRMAPackageLine.FindSet() then begin
            repeat
                rRMAPostedPackageLine.ManageRMAPostedPackageLine(rRMAPostedPackage, rRMAPostedPackageLine, pRMAPackage, rRMAPAckageLine, rRMAPAckageLine.Quantity);
            until rRMAPackageLine.Next() = 0
        end;
        //<<

        //>> Actualizamos las cantidades pendientes del bulto 
        rRMAPackageLine.Reset();
        rRMAPackageLine.SetRange("Package No.", pRMAPackage."Package No.");
        rRMAPackageLine.SetFilter("Item No.", '<>%1', '');
        rRMAPackageLine.SetFilter(Quantity, '>%1', 0);
        //>> Procesamos solo la linea del bulto que se indica
        if pPackageLine <> 0 then
            rRMAPackageLine.SetRange("Package Line", pPackageLine);
        //<< 
        if rRMAPackageLine.FindSet() then
            repeat
                rRMAPackageLine.GetRemainingQuantity(rRMAPackageLine);
            until rRMAPackageLine.Next() = 0;
        //<<

        //>> Gestión de la regularización de la calidad C - CHATARRA 
        if rRMASetup."Scrap Adjust" then begin

            //>> Gestión en diarios de producto a partir del bulto posted
            // Lineas sin devolución dan de alta en positivo.
            // Todas las lineas C se regulariza en negativo
            rRMAPostedPackageLine.Reset();
            rRMAPostedPackageLine.SetRange("Posted Package No.", rRMAPostedPackage."Posted Package No.");
            rRMAPostedPackageLine.SetRange("Posted No.", rRMAPostedPackage."Posted No.");
            rRMAPostedPackageLine.SetFilter("Item No.", '<>%1', '');
            rRMAPostedPackageLine.SetFilter(Quantity, '>%1', 0);
            if rRMAPostedPackageLine.FindSet() then begin
                repeat begin
                    if Format(rRMAPostedPackageLine."Return Order No.") = '' then // Sin Devolución hay que ajustar la cantidad en positivo
                        RecordJournalLines(rRMAPostedPackageLine, rRMAPostedPackageLine.Quantity, true);

                    if rRMAPostedPackageLine.Quality = rRMAPostedPackageLine.Quality::C then begin
                        RecordJournalLines(rRMAPostedPackageLine, rRMAPostedPackageLine.Quantity, false);
                        // Marcamos la linea calidad C como totalmente ajustada
                        rRMAPostedPackageLine."Adjusted Quantity" := rRMAPostedPackageLine.Quantity;
                        rRMAPostedPackageLine."Fully Transferred" := true;
                        rRMAPostedPackageLine.Modify();
                    end;
                end;
                until rRMAPostedPackageLine.Next() = 0;
            end;
            //<<

            //>> Rellenamos las cantidades ajustadas de la linea y cerramos el bulto si procede
            /* BBT 21/01/2026. Procesamiento Anterior
            rRMAPostedPackageAux.Reset();
            rRMAPostedPackageAux.SetRange("Posted Package No.", rRMAPostedPackage."Posted Package No.");
            rRMAPostedPackageAux.SetRange("Posted No.", rRMAPostedPackage."Posted No.");
            if rRMAPostedPackageAux.Count > 0 then begin
                rRMAPostedPackageLine.Reset();
                rRMAPostedPackageLine.SetRange("Posted Package No.", rRMAPostedPackage."Posted Package No.");
                rRMAPostedPackageLine.SetRange("Posted No.", rRMAPostedPackage."Posted No.");
                rRMAPostedPackageLine.SetFilter("Return Order No.", '=%1', '');
                if rRMAPostedPackageLine.FindSet() then
                    repeat begin
                        rRMAPostedPackageLine."Adjusted Quantity" := rRMAPostedPackageLine.Quantity;
                        rRMAPostedPackageLine."Fully Transferred" := true;
                        rRMAPostedPackageLine.Modify();
                    end;
                    until rRMAPostedPackageLine.Next() = 0;
            
            rRMAPostedPackageLine.Reset();
            rRMAPostedPackageLine.SetRange("Posted Package No.", rRMAPostedPackage."Posted Package No.");
            rRMAPostedPackageLine.SetRange("Posted No.", rRMAPostedPackage."Posted No.");
            rRMAPostedPackageLine.SetRange(Quality, rRMAPostedPackageLineAux.Quality::C);
            rRMAPostedPackageLine.SetRange("Fully Transferred", false);
            if rRMAPostedPackageLine.FindFirst() then begin
                rRMAPostedPackage."Fully Transferred" := true;
                rRMAPostedPackage.Modify();
            end;
            */
            //<<

            //>> BBT 21/01/2026. Revisamos que no queden lineas calidad C sin marcar como totalmente ajustadas
            // Lineas
            //rRMAPostedPackageLineAux.Reset();
            //rRMAPostedPackageLineAux.SetRange("Fully Transferred", false);
            //rRMAPostedPackageLineAux.SetRange(Quality, rRMAPostedPackageLineAux.Quality::C);
            //if rRMAPostedPackageLineAux.FindSet() then
            //    repeat begin
            //        rRMAPostedPackageLineAux."Adjusted Quantity" := rRMAPostedPackageLineAux.Quantity;
            //        rRMAPostedPackageLineAux."Fully Transferred" := true;
            //        rRMAPostedPackageLineAux.Modify();
            //    end;
            //   until rRMAPostedPackageLineAux.Next() = 0;
            //<<

        end;

        //>> BBT 21/01/2026. Si todas las líneas están ajustadas/transferidas marcamos el bulto como totalmente 'transferido'.   
        // Cabecera
        rRMAPostedPackageAux.Reset();
        rRMAPostedPackageAux.SetRange("Fully Transferred", false);
        if rRMAPostedPackageAux.FindSet() then
            repeat begin
                //>> BBT 17/02/2026. Marcamos como transferidas las lineas sin producto ¿¿¿???
                rRMAPostedPackageLineAux.Reset();
                rRMAPostedPackageLineAux.SetRange("Posted Package No.", rRMAPostedPackageAux."Posted Package No.");
                rRMAPostedPackageLineAux.SetRange("Posted No.", rRMAPostedPackageAux."Posted No.");
                rRMAPostedPackageLineAux.SetRange("Fully Transferred", false);
                rRMAPostedPackageLineAux.SetFilter("Item No.", '=%1', '');
                if rRMAPostedPackageLineAux.FindSet() then
                    repeat
                    begin
                        rRMAPostedPackageLineAux."Fully Transferred" := true;
                        rRMAPostedPackageLineAux.Modify();
                    end;
                    until rRMAPostedPackageLineAux.Next() = 0;
                //<<
                // Si todas las lineas están finalizadas se marca la cabecera del bulto.
                rRMAPostedPackageLineAux.Reset();
                rRMAPostedPackageLineAux.SetRange("Posted Package No.", rRMAPostedPackageAux."Posted Package No.");
                rRMAPostedPackageLineAux.SetRange("Posted No.", rRMAPostedPackageAux."Posted No.");
                rRMAPostedPackageLineAux.SetRange("Fully Transferred", false);
                if not rRMAPostedPackageLineAux.FindFirst() then begin
                    rRMAPostedPackageAux."Fully Transferred" := true;
                    rRMAPostedPackageAux.Modify();
                end;
            end;
            until rRMAPostedPackageAux.Next() = 0;
        //<<

        //>> Marcamos el bulto como registrado.
        pRMAPackage."Registered Package" := true;
        pRMAPackage.Modify;
        //<<

        //>> Revisamos que no queden bultos completamente registrados sin borrar.
        // Si el bulto está registrado y no hay lineas con cantidades pendientes se borra completamente.
        // El bulto ya está en los POSTED PACKAGES.
        rRMAPackageAux.Reset();
        rRMAPackageAux.SetRange("Registered Package", true);
        if rRMAPackageAux.FindSet() then
            repeat begin
                ToDelete := true;
                rRMAPackageLineAux.Reset();
                rRMAPackageLineAux.SetRange("Package No.", rRMAPackageAux."Package No.");
                if rRMAPackageLineAux.FindSet() then
                    repeat
                        if (rRMAPackageLineAux."Remaining Quantity" <> 0) then
                            ToDelete := false;
                    until rRMAPackageLineAux.Next() = 0;
                if ToDelete then begin
                    if rRMAPackageLineAux.FindSet() then
                        repeat
                            rRMAPackageLineAux.Delete();        // Borramos lineas
                        until rRMAPackageLineAux.Next() = 0;
                    rRMAPackageAux.Delete();                    // Borramos cabecera
                end;
            end;
            until rRMAPackageAux.Next() = 0;
        //<<
    end;

    procedure TransferStockPackage(var pRMAStockPackage: Record "RMAs Stock Package")
    var
        rRMASetup: Record "RMAs Setup";
        rInventorySetup: Record "Inventory Setup";
        rRMAStockPackage: Record "RMAs Stock Package";
        rRMAStockPackageLine: Record "RMAs Stock Package Line";
        rTransferHeader: Record "Transfer Header";
        rTransferLine: Record "Transfer Line";
        rRMAsPackageTransferMatrix: Record "RMAs Package Transfer Matrix";
        rRMAsPostedPackage: Record "RMAs Posted Package";
        rRMAsPostedPackageLine: Record "RMAs Posted Package Line";

        cuNSeries: Codeunit "No. Series";

    begin
        // Pedidos de Transferencia desde el almacén de devoluciones a los almacenes de las calidades A-B-C
        // TODAS las líneas del bulto van a Pedidos de Transferencia
        rRMASetup.Reset();
        rRMASetup.Get();
        rInventorySetup.Reset();
        rInventorySetup.Get();

        rRMAStockPackageLine.Reset();
        rRMAStockPackageLine.SetRange("Package No.", pRMAStockPackage."Package No.");
        if not rRMAStockPackageLine.IsEmpty then begin
            // Cabecera de transferencia    
            rTransferHeader.Init();
            rTransferHeader."No." := cuNSeries.GetNextNo(rInventorySetup."Transfer Order Nos.", WorkDate(), false);
            rTransferHeader."No. Series" := rInventorySetup."Transfer Order Nos.";
            rTransferHeader.Validate("Transfer-from Code", rRMASetup."Returns Warehouse");
            rTransferHeader.Validate("Transfer-to Code", pRMAStockPackage.Location);
            rTransferHeader.Validate("Shipment Date", WorkDate());
            rTransferHeader.Validate("Posting Date", WorkDate());
            rTransferHeader.Validate("Receipt Date", WorkDate());
            rTransferHeader.Status := rTransferHeader.Status::Released;
            rTransferHeader."External Document No." := pRMAStockPackage."Package No.";
            rTransferHeader.Insert;

            //Lineas de la transferencia
            rRMAStockPackageLine.Reset();
            rRMAStockPackageLine.SetRange("Package No.", pRMAStockPackage."Package No.");
            rRMAStockPackageLine.SetFilter("Item No.", '<>%1', '');
            rRMAStockPackageLine.SetFilter(Quantity, '>%1', 0);
            if rRMAStockPackageLine.FindSet() then
                repeat begin
                    rTransferLine.Init();
                    rTransferLine."Document No." := rTransferHeader."No.";
                    rTransferLine."Line No." := GetLastTransferLine(rTransferHeader);
                    rTransferLine.Validate("Item No.", rRMAStockPackageLine."Item No.");
                    rTransferLine.Validate(Quantity, rRMAStockPackageLine.Quantity);
                    rTransferLine.Validate("Shipment Date", rTransferHeader."Shipment Date");
                    rTransferLine.Validate("Receipt Date", rTransferHeader."Posting Date");
                    rTransferLine.Insert();
                end;
                until rRMAStockPackageLine.Next() = 0;

            //>> Marcamos el bulto (cabecera y líneas) como transferido.
            pRMAStockPackage."Package transferred" := true;
            pRMAStockPackage."Transfer Order" := rTransferHeader."No.";
            pRMAStockPackage.Modify;

            rRMAStockPackageLine.Reset();
            rRMAStockPackageLine.SetRange("Package No.", pRMAStockPackage."Package No.");
            rRMAStockPackageLine.SetFilter("Item No.", '<>%1', '');
            rRMAStockPackageLine.SetFilter(Quantity, '>%1', 0);
            if rRMAStockPackageLine.FindSet() then
                repeat begin
                    rRMAStockPackageLine."Line transferred" := true;
                    rRMAStockPackageLine.Modify();
                end;
                until rRMAStockPackageLine.Next() = 0;
            //<<

            //>> Marcamos las líneas y la cabecera de los bultos registrados como transferidos
            rRMAStockPackageLine.Reset();
            rRMAStockPackageLine.SetRange("Package No.", pRMAStockPackage."Package No.");
            rRMAStockPackageLine.SetFilter("Item No.", '<>%1', '');
            rRMAStockPackageLine.SetFilter(Quantity, '>%1', 0);
            if rRMAStockPackageLine.FindSet() then
                repeat begin
                    // Línea transferida
                    rRMAsPostedPackageLine.SetRange("Posted Package No.", rRMAStockPackageLine."Original Posted Package No.");
                    rRMAsPostedPackageLine.SetRange("Posted No.", rRMAStockPackageLine."Original Posted No.");
                    rRMAsPostedPackageLine.SetRange("Posted Package Line", rRMAStockPackageLine."Original Posted Package Line");
                    rRMAsPostedPackageLine.SetRange("Item No.", rRMAStockPackageLine."Item No.");
                    if rRMAsPostedPackageLine.FindFirst() then begin
                        rRMAsPostedPackageLine.CalcFields("Transferred Quantity");
                        if rRMAsPostedPackageLine.Quantity <= rRMAsPostedPackageLine."Transferred Quantity" then begin
                            rRMAsPostedPackageLine."Fully Transferred" := true;
                            rRMAsPostedPackageLine.Modify();
                        end;
                    end;
                    // Bulto totalmente transferido
                    rRMAsPostedPackage.Reset();
                    rRMAsPostedPackage.SetRange("Posted Package No.", rRMAStockPackageLine."Original Posted Package No.");
                    rRMAsPostedPackage.SetRange("Posted No.", rRMAStockPackageLine."Original Posted No.");
                    if rRMAsPostedPackage.FindFirst() then begin
                        rRMAsPostedPackageLine.Reset();
                        rRMAsPostedPackageLine.SetRange("Posted Package No.", rRMAsPostedPackage."Posted Package No.");
                        rRMAsPostedPackageLine.SetRange("Posted No.", rRMAsPostedPackage."Posted No.");
                        rRMAsPostedPackageLine.SetRange("Fully Transferred", false);
                        if not rRMAsPostedPackageLine.FindFirst() then begin
                            rRMAsPostedPackage."Fully Transferred" := true;
                            rRMAsPostedPackage.Modify();
                        end;
                    end;
                end;
                until rRMAStockPackageLine.Next() = 0;
            //<< 
            //>> Eliminanos de la matriz de transferencia los datos del bulto
            rRMAsPackageTransferMatrix.Reset();
            if rRMAsPackageTransferMatrix.FindSet() then
                repeat
                    rRMAStockPackage.Reset();
                    rRMAStockPackage.SetRange("Package No.", rRMAsPackageTransferMatrix."Package No.");
                    rRMAStockPackage.Setrange("Package transferred", false);
                    if not rRMAStockPackage.FindFirst() then
                        rRMAsPackageTransferMatrix.Delete();
                until rRMAsPackageTransferMatrix.Next() = 0;
            //<<
        end;
    end;

    local procedure GetLastJournalLine(pJournalTemplateName: Code[10]; pJournalBatchName: code[10]): Integer;
    var
        rItemJournalLineAux: Record "Item Journal Line";
    begin
        rItemJournalLineAux.Reset();
        rItemJournalLineAux.setrange("Journal Template Name", pJournalTemplateName);
        rItemJournalLineAux.SetRange("Journal Batch Name", pJournalBatchName);
        IF rItemJournalLineAux.FindLast() then
            exit(rItemJournalLineAux."Line No." + 10000)
        else
            exit(10000);
    end;

    local procedure GetLastTransferLine(pTransferHeader: Record "Transfer Header"): Integer;
    var
        rTransferLine: Record "Transfer Line";
    begin
        rTransferLine.Reset();
        rTransferLine.SetRange("Document No.", pTransferHeader."No.");
        IF rTransferLine.FindLast() then
            exit(rTransferLine."Line No." + 10000)
        else
            exit(10000);
    end;

    local procedure RecordJournalLines(pRMAPostedPackageLine: Record "RMAs Posted Package Line"; PQuantity: Integer; PositiveAdjust: Boolean)
    var
        cuItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        rItemJournalLine: Record "Item Journal Line";
        rRMASetup: Record "RMAs Setup";
        cuNSeries: Codeunit "No. Series";
        Text01: Label 'Quality', Comment = 'ESP="Calidad"';
        Text02: Label 'SCRAPS ', Comment = 'ESP="DEVs BASURA "';
    begin
        rRMASetup.Reset();
        rRMASetup.get();

        //>> Por precaución limpiamos el diario
        rItemJournalLine.Reset();
        rItemJournalLine.SetRange("Journal Template Name", rRMASetup."Journal Template Name");
        rItemJournalLine.SetRange("Journal Batch Name", rRMASetup."Journal Batch Name");
        if rItemJournalLine.FindSet() then
            repeat
                rItemJournalLine.Delete();
            until rItemJournalLine.Next() = 0;
        //<<

        //>> Grabamos el registro
        rItemJournalLine.Init();
        rItemJournalLine."Journal Template Name" := rRMASetup."Journal Template Name";
        rItemJournalLine."Journal Batch Name" := rRMASetup."Journal Batch Name";
        rItemJournalLine."Line No." := GetLastJournalLine(rItemJournalLine."Journal Template Name", rItemJournalLine."Journal Batch Name");
        rItemJournalLine."Posting Date" := WorkDate();

        if PositiveAdjust then begin
            rItemJournalLine."Entry Type" := rItemJournalLine."Entry Type"::"Positive Adjmt.";
            rItemJournalLine."Document No." := cuNSeries.GetNextNo(rRMASetup."Return Series", WorkDate(), false);
        end
        else begin
            rItemJournalLine."Entry Type" := rItemJournalLine."Entry Type"::"Negative Adjmt.";
            rItemJournalLine."Document No." := CopyStr(Text02 + format(Today, 0), 1, 20);
        end;

        rItemJournalLine.Validate("Item No.", pRMAPostedPackageLine."Item No.");
        rItemJournalLine.Validate(Quantity, PQuantity);
        rItemJournalLine.Validate("Location Code", rRMASetup."Returns Warehouse");
        rItemJournalLine."External Document No." := CopyStr(Format(pRMAPostedPackageLine."Posted Package No.") + '-' + Format(pRMAPostedPackageLine."Posted No."), 1, 100);

        Clear(rItemJournalLine.Description);
        If Format(pRMAPostedPackageLine."Return Order No.") <> '' then
            rItemJournalLine.Description := Format(pRMAPostedPackageLine."Return Order No.") + '/'
        else
            rItemJournalLine.Description := rItemJournalLine."External Document No." + '/';
        case pRMAPostedPackageLine.Quality of
            pRMAPostedPackageLine.Quality::A:
                rItemJournalLine.Description := rItemJournalLine.Description + Text01 + ' A';
            pRMAPostedPackageLine.Quality::B:
                rItemJournalLine.Description := rItemJournalLine.Description + Text01 + ' B';
            pRMAPostedPackageLine.Quality::C:
                rItemJournalLine.Description := rItemJournalLine.Description + Text01 + ' C';
        end;
        if PositiveAdjust then begin
            rItemJournalLine.Description := CopyStr(rItemJournalLine.Description + '/' + pRMAPostedPackageLine."Return Reason", 1, 100);
            if pRMAPostedPackageLine.Incident then
                rItemJournalLine.Description := CopyStr(rItemJournalLine.Description + '/' + pRMAPostedPackageLine."Incident Reason", 1, 100);
        end;

        rItemJournalLine.Insert();
        //<<

        //>> Registramos
        CLEAR(cuItemJnlPostLine);
        cuItemJnlPostLine.RunWithCheck(rItemJournalLine);
        //<<

        //>> Por precaución limpiamos el diario
        rItemJournalLine.Reset();
        rItemJournalLine.SetRange("Journal Template Name", rRMASetup."Journal Template Name");
        rItemJournalLine.SetRange("Journal Batch Name", rRMASetup."Journal Batch Name");
        if rItemJournalLine.FindSet() then
            repeat
                rItemJournalLine.Delete();
            until rItemJournalLine.Next() = 0;
        //<<
    end;

    //>> Procedures para calcular las cantidades pendientes de la devolución de ventas
    procedure GetReturnQty(pRMAPostedPackageLine: Record "RMAs Posted Package Line"): Integer
    var
        rReturnLine: Record "Sales Line";
        Quantity: Integer;
    begin
        Clear(Quantity);
        if pRMAPostedPackageLine."Return Order No." <> '' then begin
            rReturnLine.Reset();
            rReturnLine.SetRange("Document Type", rReturnLine."Document Type"::"Return Order");
            rReturnLine.SetRange("Document No.", pRMAPostedPackageLine."Return Order No.");
            rReturnLine.SetRange(Type, rReturnLine.Type::Item);
            rReturnLine.SetRange("No.", pRMAPostedPackageLine."Item No.");
            if rReturnLine.FindSet() then
                repeat
                    Quantity += rReturnLine.Quantity;
                until rReturnLine.Next() = 0;
        end;
        exit(Quantity);
    end;

    procedure GetReturnedQty(pRMAPostedPackageLine: Record "RMAs Posted Package Line"): Integer
    var
        rReturnLine: Record "Sales Line";
        Quantity: Integer;
    begin
        Clear(Quantity);
        if pRMAPostedPackageLine."Return Order No." <> '' then begin
            rReturnLine.Reset();
            rReturnLine.SetRange("Document Type", rReturnLine."Document Type"::"Return Order");
            rReturnLine.SetRange("Document No.", pRMAPostedPackageLine."Return Order No.");
            rReturnLine.SetRange(Type, rReturnLine.Type::Item);
            rReturnLine.SetRange("No.", pRMAPostedPackageLine."Item No.");
            if rReturnLine.FindSet() then
                repeat
                    Quantity += rReturnLine."Return Qty. Received";
                until rReturnLine.Next() = 0;
        end;
        exit(Quantity);
    end;

    procedure GetInvoicedQty(pRMAPostedPackageLine: Record "RMAs Posted Package Line"): Integer
    var
        rReturnLine: Record "Sales Line";
        Quantity: Integer;
    begin
        Clear(Quantity);
        if pRMAPostedPackageLine."Return Order No." <> '' then begin
            rReturnLine.Reset();
            rReturnLine.SetRange("Document Type", rReturnLine."Document Type"::"Return Order");
            rReturnLine.SetRange("Document No.", pRMAPostedPackageLine."Return Order No.");
            rReturnLine.SetRange(Type, rReturnLine.Type::Item);
            rReturnLine.SetRange("No.", pRMAPostedPackageLine."Item No.");
            if rReturnLine.FindSet() then
                repeat
                    Quantity += rReturnLine."Quantity Invoiced";
                until rReturnLine.Next() = 0
        end;
        exit(Quantity);
    end;
    //<<
}