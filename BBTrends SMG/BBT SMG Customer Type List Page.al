page 51302 "SMG Customer Type List"
{
    ApplicationArea = All;
    Caption = 'Customer Type', comment = 'ESP="Tipo de Cliente"';
    PageType = List;
    SourceTable = "SMG Customer Classification";
    SourceTableView = sorting(Code) where(Type = filter("Customer Type"));
    //UsageCategory = Administration;
    DeleteAllowed = true;
    ModifyAllowed = true;
    InsertAllowed = true;
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(States)
            {
                ShowCaption = false;

                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("WithDiscounts"; WithDiscounts)
                {
                    Caption = 'Discounts', Comment = 'ESP="Dtos."';
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = DiscountEnabled;
                    Visible = DiscountEnabled;
                }
                field("Exclude Margin Calculation"; Rec."Exclude Margin Calculation")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("CustomerTypeDiscounts")
            {
                Caption = 'Customer Type Discounts', Comment = 'ESP="Dtos. Tipo Cliente"';
                ApplicationArea = all;
                Image = LineDiscount;
                Enabled = DiscountEnabled;
                Visible = DiscountEnabled;

                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    rSMGSalesDiscounts: Record "SMG Sales Discounts";
                begin
                    rSMGSalesDiscounts.Reset();
                    rSMGSalesDiscounts.SetRange("SMG Apply to", rSMGSalesDiscounts."SMG Apply to"::"Customer Type");
                    rSMGSalesDiscounts.SetRange("SMG Code", Rec.Code);
                    Page.RunModal(Page::"SMG Sales Discounts", rSMGSalesDiscounts);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        WithDiscounts: Boolean;
        rSMGSetup: Record "SMG Setup";
        cuSMGManagement: Codeunit "SMG Management";
        DiscountEnabled: Boolean;

    trigger OnOpenPage()
    begin
        Clear(DiscountEnabled);
        cuSMGManagement.InitializeMarginConfiguration(rSMGSetup);
        DiscountEnabled := rSMGSetup."Customer Type Disc. Enabled"
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.Type::"Customer Type";
        Clear(WithDiscounts);
    end;

    trigger OnAfterGetRecord()
    begin
        WithDiscounts := IsWithDiscounts();
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        cuSMGManagement.RecordClassificationExist(Rec.Type, Rec.Code);
    end;

    local procedure IsWithDiscounts(): Boolean
    var
        rSMGSalesDiscounts: Record "SMG Sales Discounts";
    begin
        rSMGSalesDiscounts.Reset();
        rSMGSalesDiscounts.SetRange("SMG Apply to", rSMGSalesDiscounts."SMG Apply to"::"Customer Type");
        rSMGSalesDiscounts.SetRange("SMG Code", rec.Code);
        if rSMGSalesDiscounts.FindFirst() then
            exit((rSMGSalesDiscounts."SMG Discount 1 %" +
                rSMGSalesDiscounts."SMG Discount 2 %" +
                rSMGSalesDiscounts."SMG Discount 3 %" +
                rSMGSalesDiscounts."SMG Discount 4 %" +
                rSMGSalesDiscounts."SMG Discount 5 %") <> 0)
        else
            exit(false);
    end;
}