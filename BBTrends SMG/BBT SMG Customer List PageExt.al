PageExtension 51304 "SMG Customer List" extends "Customer List"
{
    layout
    {
        addafter(Name)
        {
            field("SMG Purchase Group"; Rec."SMG Purchase Group")
            {
                Visible = SMGEnable and SMGPurchaseGroupEnable;
                Enabled = SMGEnable and SMGPurchaseGroupEnable;
                ApplicationArea = All;
            }
            field("SMG CustomerType"; Rec."SMG Customer Type")
            {
                Visible = SMGEnable and SMGCustomerTypeEnable;
                Enabled = SMGEnable and SMGCustomerTypeEnable;
                ApplicationArea = All;
            }
            field("SMG National Group"; rec."SMG National Group")
            {
                Visible = SMGEnable and SMGNationalGroupEnable;
                Enabled = SMGEnable and SMGNationalGroupEnable;
                ApplicationArea = All;
            }
            field("SMG Platform"; rec."SMG Platform")
            {
                Visible = SMGEnable and SMGPlatformEnable;
                Enabled = SMGEnable and SMGPlatformEnable;
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        //>> BBT: Atención a la nueva versión de gestión de precios y descuentos
        modify(PriceListsDiscounts)
        {
            Visible = not SMGEnable;
            Enabled = not SMGEnable;
        }
        modify(Sales_LineDiscounts)
        {
            Visible = not SMGEnable;
            Enabled = not SMGEnable;
        }
        modify(Prices_LineDiscounts)
        {
            Visible = not SMGEnable;
            Enabled = not SMGEnable;
        }
        //<<
        addlast(Action24)
        {
            group(SalesDiscounts)
            {
                Caption = 'Sales Discounts', Comment = 'ESP="Descuentos Ventas"';
                Visible = SMGEnable;
                Enabled = SMGEnable;
                action("CustomerDiscounts")
                {
                    Caption = 'Customer Discounts', Comment = 'ESP=Dtos. Cliente';
                    ApplicationArea = all;
                    Image = Customer;
                    RunObject = Page "SMG Sales Discounts";
                    RunPageLink = "SMG Apply to" = CONST(Customer), "SMG Code" = FIELD("No.");
                }
            }
            group("Conditions")
            {
                Caption = 'Conditions', Comment = 'ESP="Condiciones"';
                Visible = SMGEnable;
                Enabled = SMGEnable;
                Image = CalculateInvoiceDiscount;

                action("COLS Conditions")
                {
                    Caption = 'COLS Conditions', Comment = 'ESP="Condiciones COLS"';
                    ApplicationArea = All;
                    Image = CalculateInvoiceDiscount;
                    Enabled = SMGCOLsEnabled;
                    RunObject = Page "SMG COLS Conditions List";
                    RunPageLink = "Customer No." = FIELD("No.");
                    RunPageMode = View;
                }
                action("APOS Conditions")
                {
                    Caption = 'APOS Conditions', Comment = 'ESP="Condiciones APOS"';
                    ApplicationArea = All;
                    Image = CalculateInvoiceDiscount;
                    Enabled = SMGAPOsEnabled;
                    RunObject = Page "SMG APOS Customer Cond. List";
                    RunPageLink = "Condition Code" = FIELD("No.");
                    RunPageMode = View;
                }
            }
        }
        addlast(Category_Category9)
        {
            group(SalesDiscounts_Promoted)
            {
                Caption = 'Sales Discounts', Comment = 'ESP="Descuentos Ventas"';
                Visible = SMGEnable;
                Enabled = SMGEnable;
                Image = Discount;

                actionref(CustomerDiscounts_promoted; CustomerDiscounts)
                { }
            }
            group(Conditions_Promoted)
            {
                Caption = 'Conditions', Comment = 'ESP="Condiciones"';
                Visible = SMGEnable;
                Enabled = SMGEnable;
                Image = CalculateInvoiceDiscount;

                actionref(ACOLSConditions_promoted; "COLS Conditions")
                { }
                actionref(APOSConditions_promoted; "APOS Conditions")
                { }
            }
        }
    }
    var
        cuSMGManagement: Codeunit "SMG Management";
        rSMGSetup: Record "SMG Setup";
        SMGEnable: Boolean;
        SMGPurchaseGroupEnable: Boolean;
        SMGCustomerTypeEnable: Boolean;
        SMGNationalGroupEnable: Boolean;
        SMGPlatformEnable: Boolean;
        SMGCOLsEnabled: Boolean;
        SMGAPOsEnabled: Boolean;

    trigger OnOpenPage()
    begin
        SMGEnable := cuSMGManagement.IsMarginEnabled;
        cuSMGManagement.InitializeMarginConfiguration(rSMGSetup);
        cuSMGManagement.InitializeMarginConfiguration(rSMGSetup);
        SMGPurchaseGroupEnable := rSMGSetup."Purchase Group Enabled";
        SMGCustomerTypeEnable := rSMGSetup."Customer Type Enabled";
        SMGNationalGroupEnable := rSMGSetup."National Group Enabled";
        SMGPlatformEnable := rSMGSetup."Platform Enabled";
        SMGCOLsEnabled := rSMGSetup."COLs Conditions Enabled";
        SMGAPOsEnabled := rSMGSetup."APOs Conditions Enabled";
    end;
}