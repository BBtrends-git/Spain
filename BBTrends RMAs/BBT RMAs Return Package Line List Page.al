Page 51204 "RMAs Package Line List"
{
    Caption = 'Sales Return Package Line List', Comment = 'ESP="RMA Líneas Bultos Devolución Ventas"';
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
                field("Qty. to Transfer"; Rec."Qty. to Transfer")
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

                trigger OnAction()
                begin
                end;
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
        }
    }
    var
        cuRMAsManagement: Codeunit "RMAs Management";
        rReturnHeader: Record "Sales Header";
        rRMAPostedPackage: Record "RMAs Posted Package";
        rRMAPostedPackageLine: Record "RMAs Posted Package Line";
        rPackageLineQuery: Record "RMAs Package Lines Queries";
        LineClosed: Boolean;

    trigger OnInit()
    begin
        Rec.Reset();
        Rec.DeleteAll();

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