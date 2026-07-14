PageExtension 50229 "BBT Sales Return Order List" extends "Sales Return Order List"
{
    layout
    {
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            visible = false;
        }
        addafter("External Document No.")
        {
            field("Sales Credit No."; SalesCreditNo)
            {
                ApplicationArea = Basic;
                Caption = 'Sales Credit No.', comment = 'ESP="Ult. No. Abono"';
            }
        }
        addafter("Job Queue Status")
        {
            field("Ship-to City"; Rec."Ship-to City")
            {
                ApplicationArea = Basic;
            }
            field("Number of Packages"; Rec."Number of Packages")
            {
                ApplicationArea = Basic;
            }
            field(Reference; Rec.Reference)
            {
                ApplicationArea = Basic;
            }
            field("Last Return Receipt No."; Rec."Last Return Receipt No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Status)
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = Basic;
                visible = false;
            }
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = Basic;
                visible = false;
            }
        }
    }
    var
        SalesCreditNo: Code[20];
        rSalesCrMemoHeader: Record "Sales Cr.Memo Header";

    trigger OnAfterGetRecord()
    begin
        SalesCreditNo := '';
        rSalesCrMemoHeader.RESET;
        rSalesCrMemoHeader.SETRANGE("Return Order No.", rec."No.");
        IF rSalesCrMemoHeader.FINDFIRST THEN SalesCreditNo := rSalesCrMemoHeader."No.";
    end;
}
