Page 51207 "RMAs Sales Return Lookup"
{
    Caption = 'Sales Return', Comment = 'ESP="Devoluciones Ventas"';
    Editable = false;
    PageType = List;
    SourceTable = "Sales Header";
    ApplicationArea = All;
    UsageCategory = None;
    SourceTableView = sorting("No.") order(descending) where("Document Type" = filter("Return Order"), "Completely Shipped" = const(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(CustomerName; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                }
                field(ExternalDocument; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }
                field(Reference; Rec."Your Reference")
                {
                    ApplicationArea = All;
                }
                field(AgentCode; Rec."Shipping Agent Code")
                {
                    ApplicationArea = all;
                }
                field(PackageTrackingNo; Rec."Package Tracking No.")
                {
                    ApplicationArea = All;
                }
                field(Reason; Rec."Reason Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        //Rec.SetRange("Document Type", Rec."Document Type"::"Return Order");
        //Rec.SetRange("Completely Shipped", false);
        if Rec.FindFirst() then;
    end;

    procedure GetSelectionFilter(): Text
    var
        SalesReturn: Record "Sales Header";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(SalesReturn);
        exit(SelectionFilterManagement.GetSelectionFilterForSalesHeader(SalesReturn));
    end;

    procedure SetSelection(var SalesReturn: Record "Sales Header")
    begin
        CurrPage.SetSelectionFilter(SalesReturn);
    end;
}