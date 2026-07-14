Page 51303 "SMG Platform List"
{
    ApplicationArea = All;
    Caption = 'Platform', comment = 'ESP="Plataforma"';
    PageType = List;
    SourceTable = "SMG Customer Classification";
    SourceTableView = sorting(Code) where(Type = filter("Platform"));
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
                    TableRelation = "SMG Customer Classification" where(Type = const(Platform));
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(WithDiscounts; WithDiscounts)
                {
                    Caption = 'Discounts', Comment = 'ESP="Dtos."';
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = DiscountEnabled;
                    Visible = DiscountEnabled;
                }
                field(WithAPOS; WithAPOS)
                {
                    Caption = 'APOS', Comment = 'ESP="APOS"';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("PlatformDiscounts")
            {
                Caption = 'Platform Discounts', Comment = 'ESP="Dtos. Plataforma"';
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
                    rSMGSalesDiscounts.SetRange("SMG Apply to", rSMGSalesDiscounts."SMG Apply to"::"Platform");
                    rSMGSalesDiscounts.SetRange("SMG Code", Rec.Code);
                    Page.RunModal(Page::"SMG Sales Discounts", rSMGSalesDiscounts);
                    CurrPage.Update(false);
                end;
            }
            action(PlatformConditions)
            {
                ApplicationArea = All;
                Caption = 'APOS Conditions', comment = 'ESP="Condiciones APOS"';
                Image = Discount;

                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    rSMGAPOSConditions: Record "SMG APOS Conditions";
                begin
                    rSMGAPOSConditions.Reset();
                    rSMGAPOSConditions.SetRange("Condition Classification", rSMGAPOSConditions."Condition Classification"::Platform);
                    rSMGAPOSConditions.SetRange("Condition Code", rec.Code);
                    Page.RunModal(Page::"SMG APOS Platform Cond. List", rSMGAPOSConditions);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        WithDiscounts: Boolean;
        WithAPOS: Boolean;
        rSMGSetup: Record "SMG Setup";
        cuSMGManagement: Codeunit "SMG Management";
        DiscountEnabled: Boolean;

    trigger OnOpenPage()
    begin
        Clear(DiscountEnabled);
        cuSMGManagement.InitializeMarginConfiguration(rSMGSetup);
        DiscountEnabled := rSMGSetup."Platform Disc. Enabled";
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.Type::"Platform";
        Clear(WithDiscounts);
        Clear(WithAPOS);
    end;

    trigger OnAfterGetRecord()
    begin
        WithDiscounts := IsWithDiscounts();
        WithAPOS := IsWithAPOS();
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
        rSMGSalesDiscounts.SetRange("SMG Apply to", rSMGSalesDiscounts."SMG Apply to"::Platform);
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

    local procedure IsWithAPOS(): Boolean
    var
        rSMGAPOSConditions: Record "SMG APOS Conditions";
    begin
        rSMGAPOSConditions.Reset();
        rSMGAPOSConditions.SetRange("Condition Classification", rSMGAPOSConditions."Condition Classification"::Platform);
        rSMGAPOSConditions.SetRange("Condition Code", rec.Code);
        rSMGAPOSConditions.SetFilter("% APOS Excluded from Invoice", '<>%1', 0);
        if rSMGAPOSConditions.FindFirst() then
            exit(true)
        else
            exit(false);
    end;
}