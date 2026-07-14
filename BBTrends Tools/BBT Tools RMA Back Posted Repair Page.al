Page 59004 "BBT Tool RMAs Back Posted"
{
    Caption = 'BBT Tool RMAs Back Posted Repair';
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
                field("Adjusted Qty."; Rec."Adjusted Qty.")
                {
                    ApplicationArea = All;
                }
                field("Transferred Qty."; Rec."Transferred Qty.")
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
                Caption = 'Package', comment = 'ESP="Bulto Devol."';
                Image = Inventory;
                Ellipsis = false;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "RMAs Package Card";
                RunPageLink = "Package No." = field("Package No.");
                RunPageMode = View;
            }
            action(DocReturn)
            {
                ApplicationArea = All;
                Caption = 'Document', Comment = 'ESP="Devolución"';
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

            action(BackPosted)
            {
                ApplicationArea = All;
                Caption = 'Back Posted';
                Ellipsis = false;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Documents;
                Enabled = (Rec."Return Order No." <> '');

                trigger OnAction()
                begin
                    rRMAPostedPackage.Reset();
                    rRMAPostedPackage.SetRange("Posted Package No.", Rec."Package No.");
                    rRMAPostedPackage.SetRange("Posted No.", rec."Posted No.");
                    if rRMAPostedPackage.FindFirst() then begin
                        rRMAPostedPackageLine.Reset();
                        rRMAPostedPackageLine.SetRange("Posted Package No.", Rec."Package No.");
                        rRMAPostedPackageLine.SetRange("Posted No.", rec."Posted No.");
                        rRMAPostedPackageLine.SetRange("Posted Package Line", Rec."Package Line");
                        if rRMAPostedPackageLine.FindFirst() then begin
                            RMABackPostedPackageLine(rRMAPostedPackage, rRMAPostedPackageLine);
                            RMADeletePostedPackageLine(rRMAPostedPackage, rRMAPostedPackageLine);
                            rec.Delete();
                        end;
                    end;

                end;
            }
        }
    }
    var
        rReturnHeader: Record "Sales Header";
        rRMAPostedPackage: Record "RMAs Posted Package";
        rRMAPostedPackageLine: Record "RMAs Posted Package Line";
        LineClosed: Boolean;

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
                if rRMAPostedPackageLine.FindSet() then
                    repeat begin
                        Rec.Reset();
                        Rec.SetRange("Package No.", rRMAPostedPackageLine."Posted Package No.");
                        Rec.SetRange("Posted No.", rRMAPostedPackageLine."Posted No.");
                        Rec.SetRange("Package Line", rRMAPostedPackageLine."Posted Package Line");
                        //Rec.SetRange("Return Order No.", rRMAPostedPackageLine."Return Order No.");
                        //Rec.SetRange("Item No.", rRMAPostedPackageLine."Item No.");
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
                            rRMAPostedPackageLine.CalcFields("Transferred Quantity");
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
                            Rec."Adjusted Qty." := rRMAPostedPackageLine."Adjusted Quantity";
                            Rec."Transferred Qty." := rRMAPostedPackageLine."Transferred Quantity";
                            Rec."Qty. to Return" := GetReturnQty(rRMAPostedPackageLine);
                            Rec."Qty. Returned" := GetReturnedQty(rRMAPostedPackageLine);
                            Rec."Qty. Invoiced" := GetInvoicedQty(rRMAPostedPackageLine);
                            Rec."Qty. to Returned" := Rec."Qty. to Return" - Rec."Qty. Returned";
                            Rec."Qty. to Invoiced" := Rec."Qty. to Return" - Rec."Qty. Invoiced";

                            Rec.Insert();
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

    //>> BBT 16/02/2026. Retroceso de paquete registrado
    local procedure RMABackPostedPackageLine(pRMAPostedPackage: record "RMAs Posted Package"; pRMAPostedPackageLine: Record "RMAs Posted Package Line"): Boolean
    var
        rRMAPackage: Record "RMAs Package";
        rRMAPackageLine: Record "RMAs Package Line";
    begin
        // Si no existe la cabecera del bulto registrado se da de alta
        rRMAPackage.Reset();
        rRMAPackage.SetRange("Package No.", pRMAPostedPackageLine."Posted Package No.");
        if not rRMAPackage.FindFirst() then begin
            rRMAPackage.Init();
            rRMAPackage."Package No." := pRMAPostedPackage."Posted Package No.";
            rRMAPackage."Creation Date" := pRMAPostedPackage."Posted Date";
            rRMAPackage."Package Type" := pRMAPostedPackage."Package Type";
            rRMAPackage."Numbers Packages" := pRMAPostedPackage."Numbers Packages";
            rRMAPackage."Return Category" := pRMAPostedPackage."Return Category";
            rRMAPackage."Package Status" := rRMAPackage."Package Status"::Closed;
            rRMAPackage."Registered Package" := false;
            if not rRMAPackage.Insert() then;
            //Error('No se ha podido dar de alta el bulto: %1', rRMAPackage."Package No.");
        end;

        rRMAPackageLine.Init();
        rRMAPackageLine."Package No." := pRMAPostedPackage."Posted Package No.";
        rRMAPackageLine."Package Line" := pRMAPostedPackageLine."Posted Package Line";
        rRMAPackageLine."Item No." := pRMAPostedPackageLine."Item No.";
        rRMAPackageLine."EAN of Unit" := pRMAPostedPackageLine."EAN of Unit";
        rRMAPackageLine.Description := pRMAPostedPackageLine.Description;
        rRMAPackageLine.Quantity := pRMAPostedPackageLine.Quantity;
        rRMAPackageLine."Lot Number" := pRMAPostedPackageLine."Lot Number";
        rRMAPackageLine.Quality := pRMAPostedPackageLine.Quality;
        rRMAPackageLine.Condition := pRMAPostedPackageLine.Condition;
        rRMAPackageLine."Return Order No." := pRMAPostedPackageLine."Return Order No.";
        rRMAPackageLine."Return Reason" := pRMAPostedPackageLine."Return Reason";
        rRMAPackageLine.Incident := pRMAPostedPackageLine."Incident";
        rRMAPackageLine."Incident Reason" := pRMAPostedPackageLine."Incident Reason";
        rRMAPackageLine."Analysis Date" := pRMAPostedPackageLine."Analysis Date";
        rRMAPackageLine."Return Resource" := pRMAPostedPackageLine."Return Resource";
        if not rRMAPackageLine.Insert() then;
        //Error('Error el el alta de la linea %2 del bulto %1', rRMAPackageLine."Package No.", rRMAPackageLine."Package Line");
    end;

    local procedure RMADeletePostedPackageLine(var pRMAPostedPackage: record "RMAs Posted Package"; var pRMAPostedPackageLine: Record "RMAs Posted Package Line"): Boolean
    var
        rRMAPostedPackageLine: record "RMAs Posted Package Line";
    begin
        pRMAPostedPackageLine.Delete();

        rRMAPostedPackageLine.Reset();
        rRMAPostedPackageLine.SetRange("Posted Package No.", pRMAPostedPackage."Posted Package No.");
        rRMAPostedPackageLine.SetRange("Posted No.", pRMAPostedPackage."Posted No.");
        if not rRMAPostedPackageLine.FindFirst() then
            pRMAPostedPackage.Delete();
    end;
}