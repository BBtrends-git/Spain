page 51238 "RMAs API Returns Package Lines"
{
    Caption = 'RMAs API Returns Package Lines', Comment = 'ESP="RMA API Líneas Bultos Devolución"';
    PageType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtapis';
    APIVersion = 'v2.0';
    EntityName = 'apireturnspackageline';
    EntitySetName = 'apireturnspackagelines';

    SourceTable = "RMAs Package Lines Queries";
    SourceTableTemporary = true;
    SourceTableView = sorting() order(Descending);
    DelayedInsert = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(PackageNo; Rec."Package No.")
                { }
                field(PostedNo; Rec."Posted No.")
                { }
                field(PackageLine; Rec."Package Line")
                { }
                field(CreationDate; Rec."Creation Date")
                { }
                field(PackageType; Rec."Package Type")
                { }
                field(NumbersPackages; Rec."Numbers Packages")
                { }
                field(ReturnOrderNo; Rec."Return Order No.")
                { }
                field(ReturnReasonCode; Rec."Return Reason Code")
                { }
                field(ReturnCustomer; Rec."Return Customer")
                { }
                field(ReturnCustomerName; Rec."Return Customer Name")
                { }
                field(ReturnCategory; Rec."Return Category")
                { }
                field(ItemNo; Rec."Item No.")
                { }
                field(EANofUnit; Rec."EAN of Unit")
                { }
                field(Description; Rec.Description)
                { }
                field(Quantity; Rec.Quantity)
                { }
                field(Quality; Rec.Quality)
                { }
                field(ReturnReason; Rec."Return Reason")
                { }
                field(AdjustedQty; Rec."Adjusted Qty.")
                { }
                field(QtytoTransfer; Rec."Qty. to Transfer")
                { }
                field(TransferredQty; Rec."Transferred Qty.")
                { }
                field(QtytoReturn; Rec."Qty. to Return")
                { }
                field(QtytoReturned; Rec."Qty. to Returned")
                { }
                field(QtyReturned; Rec."Qty. Returned")
                { }
                field(QtytoInvoiced; Rec."Qty. to Invoiced")
                { }
                field(QtyInvoiced; Rec."Qty. Invoiced")
                { }
                field(ReturnResource; Rec."Return Resource")
                { }
                field(IncidentReason; Rec."Incident Reason")
                { }
            }
        }
    }

    var
        cuRMAsManagement: Codeunit "RMAs Management";
        rReturnHeader: Record "Sales Header";
        rRMAPostedPackage: Record "RMAs Posted Package";
        rRMAPostedPackageLine: Record "RMAs Posted Package Line";
        LineClosed: Boolean;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        if not Rec.IsEmpty() then
            exit(true);

        FillTemporaryTable();

        exit(Rec.Find(Which));
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        exit(Rec.Next(Steps));
    end;

    local procedure FillTemporaryTable();
    var
        rPackageLineQuery: Record "RMAs Package Lines Queries";
    begin
        rRMAPostedPackage.Reset();
        if rRMAPostedPackage.FindSet() then
            repeat begin
                rRMAPostedPackageLine.Reset();
                rRMAPostedPackageLine.SetRange("Posted Package No.", rRMAPostedPackage."Posted Package No.");
                rRMAPostedPackageLine.SetRange("Posted No.", rRMAPostedPackage."Posted No.");
                rRMAPostedPackageLine.SetFilter(Quantity, '<>%1', 0);
                if rRMAPostedPackageLine.FindSet() then
                    repeat begin
                        rPackageLineQuery.Reset();
                        rPackageLineQuery.SetRange("Package No.", rRMAPostedPackageLine."Posted Package No.");
                        rPackageLineQuery.SetRange("Posted No.", rRMAPostedPackageLine."Posted No.");
                        rPackageLineQuery.SetRange("Package Line", rRMAPostedPackageLine."Posted Package Line");
                        if rPackageLineQuery.IsEmpty() then begin
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
                            Rec."Qty. to Transfer" := Rec.Quantity - (Rec."Adjusted Qty." + Rec."Transferred Qty.");
                            Rec."Qty. to Return" := cuRMAsManagement.GetReturnQty(rRMAPostedPackageLine);
                            Rec."Qty. Returned" := cuRMAsManagement.GetReturnedQty(rRMAPostedPackageLine);
                            Rec."Qty. Invoiced" := cuRMAsManagement.GetInvoicedQty(rRMAPostedPackageLine);
                            Rec."Qty. to Returned" := Rec."Qty. to Return" - Rec."Qty. Returned";
                            Rec."Qty. to Invoiced" := Rec."Qty. to Return" - Rec."Qty. Invoiced";
                            Rec.Insert();
                        end;
                    end;
                    until rRMAPostedPackageLine.Next() = 0;
            end;
            until rRMAPostedPackage.Next() = 0;
    end;

}