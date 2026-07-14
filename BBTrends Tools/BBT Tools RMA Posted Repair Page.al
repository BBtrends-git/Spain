Page 59002 "BBT Tool RMAs Package Repair"
{
    Caption = 'RMA Package Repair List';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "RMAs Package Lines Queries";
    SourceTableTemporary = true;
    ApplicationArea = All;
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    DelayedInsert = false;
    Editable = false;
    LinksAllowed = false;
    SourceTableView = sorting() order(Descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Package No."; Rec."Package No.")
                {
                    ApplicationArea = All;
                }
                field("Posted No."; Rec."Posted No.")
                {
                    ApplicationArea = All;
                }
                field("Package Line"; Rec."Package Line")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field("Package Type"; Rec."Package Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Numbers Packages"; Rec."Numbers Packages")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Package Status"; Rec."Package Status")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Registered Package"; Rec."Registered Package")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Return Order No."; Rec."Return Order No.")
                {
                    ApplicationArea = All;
                }
                field("Return Reason Code"; Rec."Return Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Return Customer"; Rec."Return Customer")
                {
                    ApplicationArea = All;
                }
                field("Return Customer Name"; Rec."Return Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Return Category"; Rec."Return Category")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("EAN of Unit"; Rec."EAN of Unit")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field(Quality; Rec.Quality)
                {
                    ApplicationArea = All;
                }
                field("Return Reason"; Rec."Return Reason")
                {
                    ApplicationArea = All;
                }
                field("Qty. to Return"; Rec."Qty. to Return")
                {
                    ApplicationArea = All;
                }
                field("Qty. to Returned"; Rec."Qty. to Returned")
                {
                    ApplicationArea = All;
                }
                field("Qty. Returned"; Rec."Qty. Returned")
                {
                    ApplicationArea = All;
                }
                field("Qty. to Invoiced"; Rec."Qty. to Invoiced")
                {
                    ApplicationArea = All;
                }
                field("Qty. Invoiced"; Rec."Qty. Invoiced")
                {
                    ApplicationArea = All;
                }
                field("Return Resource"; Rec."Return Resource")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Incident Reason"; Rec."Incident Reason")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Package)
            {
                ApplicationArea = Basic;
                Caption = 'Bulto Devol.';
                Image = Inventory;
                Ellipsis = false;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "RMAs Posted Package Card";
                RunPageLink = "Posted Package No." = field("Package No."), "Posted No." = field("Posted No.");
                RunPageMode = View;

                trigger OnAction()
                begin
                end;
            }
            action(DocReturn)
            {
                ApplicationArea = All;
                Caption = 'Devolución';
                Ellipsis = false;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Documents;
                Enabled = (Rec."Return Order No." <> '');
                RunObject = Page "Sales Return Order";
                RunPageLink = "No." = field("Return Order No.");
                RunPageMode = View;
            }
            action(Posting)
            {
                ApplicationArea = All;
                Caption = 'Registro';
                Image = PostingEntries;
                Ellipsis = false;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = true;
                //Enabled = (Rec."Return Order No." <> '');

                trigger OnAction()
                var
                    rRMAsPacKage: Record "RMAs Posted Package";
                    Text01: Label 'Do you want to post the package lines?', Comment = 'ESP="¿Quiere registrar las líneas del bulto?"';
                    Text02: Label 'The package lines were successfully posted', Comment = 'ESP="Las líneas del bulto se registraron correctamente."';
                begin
                    if not Confirm(Text01, false) then exit;
                    rRMAPostedPacKageLine.Reset();
                    rRMAPostedPacKageLine.SetRange("Posted Package No.", rec."Package No.");
                    rRMAPostedPacKage.SetRange("Posted No.", rec."Posted No.");
                    rRMAPostedPackageLine.SetRange("Posted Package Line", rec."Package Line");
                    if rRMAPostedPackageLine.FindFirst() then begin
                        ToolReturnAdjustment(rRMAPostedPackageLine);
                        rec.Delete();
                    end;
                    CurrPage.Update();
                end;
            }
        }
    }
    var
        rItemLedgerEntry: Record "Item Ledger Entry";
        rReturnHeader: Record "Sales Header";
        rRMAPostedPackage: Record "RMAs Posted Package";
        rRMAPostedPackageLine: Record "RMAs Posted Package Line";
        //cuRMAsManagement: Codeunit "RMAs Management";
        LineClosed: Boolean;
        ExternalDocument: Text;

    trigger OnInit()
    begin
        Rec.Reset();
        Rec.DeleteAll();

        rRMAPostedPackage.Reset();
        rRMAPostedPackage.SetFilter("Posted Date", '>=%1', DMY2Date(01, 01, 2026));
        if rRMAPostedPackage.FindSet() then
            repeat begin
                rRMAPostedPackageLine.Reset();
                rRMAPostedPackageLine.SetRange("Posted Package No.", rRMAPostedPackage."Posted Package No.");
                rRMAPostedPackageLine.SetRange("Posted No.", rRMAPostedPackage."Posted No.");
                rRMAPostedPackageLine.SetRange(Quality, rRMAPostedPackageLine.Quality::C);
                if rRMAPostedPackageLine.FindSet() then
                    repeat begin
                        ExternalDocument := CopyStr(Format(rRMAPostedPackageLine."Posted Package No.") + '-' + Format(rRMAPostedPackageLine."Posted No."), 1, 100);
                        rItemLedgerEntry.Reset();
                        rItemLedgerEntry.SetRange("Item No.", rRMAPostedPackageLine."Item No.");
                        rItemLedgerEntry.SetFilter("External Document No.", '=%1', ExternalDocument);
                        rItemLedgerEntry.SetRange("Entry Type", rItemLedgerEntry."Entry Type"::"Negative Adjmt.");
                        if not rItemLedgerEntry.FindFirst() then begin
                            Rec.Reset();
                            Rec.SetRange("Package No.", rRMAPostedPackageLine."Posted Package No.");
                            Rec.SetRange("Posted No.", rRMAPostedPackageLine."Posted No.");
                            Rec.SetRange("Package Line", rRMAPostedPackageLine."Posted Package Line");
                            Rec.SetRange("Return Order No.", rRMAPostedPackageLine."Return Order No.");
                            Rec.SetRange("Item No.", rRMAPostedPackageLine."Item No.");
                            if not rec.FindFirst() then begin
                                rReturnHeader.Reset();
                                rReturnHeader.SetRange("Document Type", rReturnHeader."Document Type"::"Return Order");
                                rReturnHeader.SetRange("No.", rRMAPostedPackageLine."Return Order No.");
                                if not rReturnHeader.FindFirst() then
                                    rReturnHeader.Init();

                                Rec.Init();
                                // Header
                                Rec."Package No." := rRMAPostedPackage."Posted Package No.";
                                Rec."Posted No." := rRMAPostedPackage."Posted No.";
                                Rec."Creation Date" := rRMAPostedPackage."Posted Date";
                                Rec."Package Type" := rRMAPostedPackage."Package Type";
                                Rec."Numbers Packages" := rRMAPostedPackage."Numbers Packages";
                                Rec."Package Status" := Rec."Package Status"::Closed;
                                Rec."Registered Package" := true;
                                Rec."Return Category" := rRMAPostedPackage."Return Category";
                                // Lines
                                Rec."Package Line" := rRMAPostedPackageLine."Posted Package Line";
                                Rec."Return Order No." := rRMAPostedPackageLine."Return Order No.";
                                Rec."Return Resource" := rRMAPostedPackageLine."Return Resource";
                                Rec."Return Reason Code" := rReturnHeader."Reason Code";
                                Rec."Return Customer" := rReturnHeader."Sell-to Customer No.";
                                Rec."Return Customer Name" := rReturnHeader."Sell-to Customer Name";
                                Rec."Item No." := rRMAPostedPackageLine."Item No.";
                                Rec."EAN of Unit" := rRMAPostedPackageLine."EAN of Unit";
                                Rec.Description := rRMAPostedPackageLine.Description;
                                Rec.Quantity := rRMAPostedPackageLine.Quantity;
                                Rec.Quality := rRMAPostedPackageLine.Quality;
                                Rec."Return Reason" := rRMAPostedPackageLine."Return Reason";
                                Rec."Incident Reason" := rRMAPostedPackageLine."Incident Reason";
                                Rec."Qty. to Return" := GetReturnQty(rRMAPostedPackageLine);
                                Rec."Qty. Returned" := GetReturnedQty(rRMAPostedPackageLine);
                                Rec."Qty. Invoiced" := GetInvoicedQty(rRMAPostedPackageLine);
                                Rec."Qty. to Returned" := Rec."Qty. to Return" - Rec."Qty. Returned";
                                Rec."Qty. to Invoiced" := Rec."Qty. to Return" - Rec."Qty. Invoiced";
                                Rec.Insert();
                            end;
                        end;
                    end;
                    until rRMAPostedPackageLine.Next() = 0;
            end;
            until rRMAPostedPackage.Next() = 0;
    end;

    local procedure GetReturnQty(pRMAPostedPackageLine: Record "RMAs Posted Package Line"): Integer
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

    local procedure GetReturnedQty(pRMAPostedPackageLine: Record "RMAs Posted Package Line"): Integer
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

    local procedure GetInvoicedQty(pRMAPostedPackageLine: Record "RMAs Posted Package Line"): Integer
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

    //>> Procedures para el ajuste


    local procedure ToolReturnAdjustment(var pRMAPostedPackageLine: Record "RMAs Posted Package Line");
    var
        rRMASetup: Record "RMAs Setup";
        rNSeries: Record "No. Series";
        //rRMAPackageLine: Record "RMAs Package Line";
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

        /* ESTO ES PARA REGISTRAR LAS DEVOLUCIONES. Se tiene de arreglar para bultos ya registrados
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
                    rSalesReturnTmp.Validate("Posting Date", WorkDate());
                    rSalesReturnTmp.Ship := false;
                    rSalesReturnTmp.Invoice := false;
                    rSalesReturnTmp.Receive := true;
                    cuSalesPost.RUN(rSalesReturnTmp);
                end;
                until rSalesReturnTmp.Next() = 0;
            end;
        end;
        //<<

        //>>Si en el bulto existen lineas sin devolución, hay que añadirlas al bulto posted.
        rRMAPackageLine.Reset();
        rRMAPackageLine.SetRange("Package No.", pRMAPackage."Package No.");
        rRMAPackageLine.SetFilter("Return Order No.", '=%1', '');
        rRMAPackageLine.SetFilter("Item No.", '<>%1', '');
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
        */

        //>> Gestión de la regularización de la calidad C - CHATARRA 
        if rRMASetup."Scrap Adjust" then begin

            //>> Gestión en diarios de producto a partir del bulto posted
            // Lineas sin devolución dan de alta en positivo.
            // Todas las lineas C se regulariza en negativo
            if pRMAPostedPackageLine.Quality = pRMAPostedPackageLine.Quality::C then begin
                RecordJournalLines(pRMAPostedPackageLine, false);
                // Marcamos la linea calidad C como totalmente ajustada
                pRMAPostedPackageLine."Adjusted Quantity" := pRMAPostedPackageLine.Quantity;
                pRMAPostedPackageLine."Fully Transferred" := true;
                pRMAPostedPackageLine.Modify();
            end;
            //<<

            //>> BBT 21/01/2026. Si todas las líneas están ajustadas/transferidas marcamos el bulto como totalmente 'transferido'.   
            // Cabecera
            rRMAPostedPackageAux.Reset();
            rRMAPostedPackageAux.SetRange("Fully Transferred", false);
            if rRMAPostedPackageAux.FindSet() then
                repeat begin
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

    local procedure RecordJournalLines(pRMAPostedPackageLine: Record "RMAs Posted Package Line"; PositiveAdjust: Boolean)
    var
        cuItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        rItemJournalLine: Record "Item Journal Line";
        rRMASetup: Record "RMAs Setup";
        rRMAPostedPackage: Record "RMAs Posted Package";
        cuNSeries: Codeunit "No. Series";
        Text01: Label 'Calidad';
        Text02: Label 'DEVs BASURA ';
    begin
        rRMASetup.Reset();
        rRMASetup.get();

        rRMAPostedPackage.Reset();
        rRMAPostedPackage.SetRange("Posted Package No.", pRMAPostedPackageLine."Posted Package No.");
        rRMAPostedPackage.SetRange("Posted No.", pRMAPostedPackageLine."Posted No.");
        rRMAPostedPackage.FindFirst();

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
        rItemJournalLine."Posting Date" := rRMAPostedPackage."Posted Date";

        if PositiveAdjust then begin
            rItemJournalLine."Entry Type" := rItemJournalLine."Entry Type"::"Positive Adjmt.";
            rItemJournalLine."Document No." := cuNSeries.GetNextNo(rRMASetup."Return Series", WorkDate(), false);
        end
        else begin
            rItemJournalLine."Entry Type" := rItemJournalLine."Entry Type"::"Negative Adjmt.";
            rItemJournalLine."Document No." := CopyStr(Text02 + format(rRMAPostedPackage."Posted Date", 0), 1, 20);
        end;

        rItemJournalLine.Validate("Item No.", pRMAPostedPackageLine."Item No.");
        rItemJournalLine.Validate(Quantity, pRMAPostedPackageLine.Quantity);
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
}