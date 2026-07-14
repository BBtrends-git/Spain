PageExtension 51300 "SMG Customer Card" extends "Customer Card"
{
    layout
    {
        addafter(General)
        {

            group(Classification)
            {
                Caption = 'Classification', Comment = 'ESP="Clasificación"';
                Visible = SMGEnable and SMGClassificationEnable;
                Enabled = SMGEnable and SMGClassificationEnable;

                grid(GridLayaut)
                {
                    GridLayout = Columns;
                    group(PurchaseGroupEnabled)
                    {
                        ShowCaption = false;


                        field("SMG Purchase Group"; Rec."SMG Purchase Group")
                        {
                            ApplicationArea = All;
                            Visible = SMGPurchaseGroupEnable;
                            Enabled = SMGPurchaseGroupEnable;
                            Importance = Promoted;
                        }
                        field(TextCountDtoPurchaseGroup; TextCountDtoPurchaseGroup)
                        {
                            Caption = 'Discount Count Purchase Group', Comment = 'ESP="Descuentos"';
                            ApplicationArea = All;
                            Visible = SMGPurchaseGroupDiscEnabled;
                            Enabled = SMGPurchaseGroupDiscEnabled;
                            Editable = false;
                            trigger OnDrillDown()
                            var
                                rSMGSalesDiscounts: record "SMG Sales Discounts";
                                pgSMGSalesDiscountPage: Page "SMG Sales Discounts";
                            begin
                                rSMGSalesDiscounts.Reset();
                                rSMGSalesDiscounts.SetRange("SMG Apply to", rSMGSalesDiscounts."SMG Apply to"::"Purchasing Group");
                                rSMGSalesDiscounts.Setrange("SMG Code", Rec."SMG Purchase Group");
                                pgSMGSalesDiscountPage.SetTableView(rSMGSalesDiscounts);
                                pgSMGSalesDiscountPage.Editable(false);
                                pgSMGSalesDiscountPage.RunModal();
                            end;
                        }
                    }
                    group(CustomerTypeEnabled)
                    {
                        ShowCaption = false;
                        field("SMG Customer Type"; Rec."SMG Customer Type")
                        {
                            ApplicationArea = All;
                            Visible = SMGCustomerTypeEnable;
                            Enabled = SMGCustomerTypeEnable;
                            Importance = Promoted;
                        }
                        field(TextCountDtoCustomerType; TextCountDtoCustomerType)
                        {
                            Caption = 'Discount Count Customer Type', Comment = 'ESP="Descuentos"';
                            ApplicationArea = All;
                            Visible = SMGCustomerTypeDiscEnabled;
                            Enabled = SMGCustomerTypeDiscEnabled;
                            Editable = false;
                            trigger OnDrillDown()
                            var
                                rSMGSalesDiscounts: record "SMG Sales Discounts";
                                pgSMGSalesDiscountPage: Page "SMG Sales Discounts";
                            begin
                                rSMGSalesDiscounts.Reset();
                                rSMGSalesDiscounts.SetRange("SMG Apply to", rSMGSalesDiscounts."SMG Apply to"::"Customer Type");
                                rSMGSalesDiscounts.Setrange("SMG Code", Rec."SMG Customer Type");
                                pgSMGSalesDiscountPage.SetTableView(rSMGSalesDiscounts);
                                pgSMGSalesDiscountPage.Editable(false);
                                pgSMGSalesDiscountPage.RunModal();
                            end;
                        }
                    }
                    group(NationalGroupEnabled)
                    {
                        ShowCaption = false;
                        field("SMG National Group"; Rec."SMG National Group")
                        {
                            ApplicationArea = All;
                            Visible = SMGNationalGroupEnable;
                            Enabled = SMGNationalGroupEnable;
                            Importance = Promoted;
                        }
                        field(TextCountDtoNationalGroup; TextCountDtoNationalGroup)
                        {
                            Caption = 'Discount Count National Group', Comment = 'ESP="Descuentos"';
                            ApplicationArea = All;
                            Visible = SMGNationalGroupDiscEnabled;
                            Enabled = SMGNationalGroupDiscEnabled;
                            Editable = false;
                            trigger OnDrillDown()
                            var
                                rSMGSalesDiscounts: record "SMG Sales Discounts";
                                pgSMGSalesDiscountPage: Page "SMG Sales Discounts";
                            begin
                                rSMGSalesDiscounts.Reset();
                                rSMGSalesDiscounts.SetRange("SMG Apply to", rSMGSalesDiscounts."SMG Apply to"::"National Group");
                                rSMGSalesDiscounts.Setrange("SMG Code", Rec."SMG National Group");
                                pgSMGSalesDiscountPage.SetTableView(rSMGSalesDiscounts);
                                pgSMGSalesDiscountPage.Editable(false);
                                pgSMGSalesDiscountPage.RunModal();
                            end;
                        }
                    }
                    group(PlatformEnabled)
                    {
                        ShowCaption = false;
                        field("SMG Platform"; Rec."SMG Platform")
                        {
                            ApplicationArea = All;
                            Visible = SMGPlatformEnable;
                            Enabled = SMGPlatformEnable;
                            Importance = Promoted;
                        }
                        field(TextCountDtoPlatform; TextCountDtoPlatform)
                        {
                            Caption = 'Discount Count platform', Comment = 'ESP="Descuentos"';
                            ApplicationArea = All;
                            Visible = SMGPlatformDiscEnabled;
                            Enabled = SMGPlatformDiscEnabled;
                            Editable = false;
                            trigger OnDrillDown()
                            var
                                rSMGSalesDiscounts: record "SMG Sales Discounts";
                                pgSMGSalesDiscountPage: Page "SMG Sales Discounts";
                            begin
                                rSMGSalesDiscounts.Reset();
                                rSMGSalesDiscounts.SetRange("SMG Apply to", rSMGSalesDiscounts."SMG Apply to"::Platform);
                                rSMGSalesDiscounts.Setrange("SMG Code", Rec."SMG Platform");
                                pgSMGSalesDiscountPage.SetTableView(rSMGSalesDiscounts);
                                pgSMGSalesDiscountPage.Editable(false);
                                pgSMGSalesDiscountPage.RunModal();
                            end;
                        }
                    }
                }
            }
            group(SMG)
            {
                Caption = 'Margin Setup', Comment = 'ESP="Margenes"';
                Visible = SMGEnable;
                Enabled = SMGEnable;

                group(SMG_OI)
                {
                    Caption = 'Margin Off-Invoice', Comment = 'ESP="Condiciones F.F."';

                    field("SMG Cols Conditions"; Rec."SMG COLS Conditions")
                    {
                        ApplicationArea = All;
                        Visible = SMGCOLsEnabled;
                        Enabled = SMGCOLsEnabled;
                        DrillDownPageId = "SMG COLS Conditions List";
                    }
                    field("PercentageCOL"; PercentageCOL)
                    {
                        Caption = '% Off-Invoice COLS', Comment = 'ESP="% F.F. COLS"';
                        ApplicationArea = All;
                        Visible = SMGCOLsEnabled;
                        Enabled = SMGCOLsEnabled;
                        Editable = false;
                    }
                    field("SMG Apos Conditions"; Rec."SMG Apos Conditions")
                    {
                        ApplicationArea = All;
                        Visible = SMGAPOsEnabled;
                        Enabled = SMGAPOsEnabled;
                        DrillDownPageId = "SMG APOS Customer Cond. List";
                    }
                    field("SMG Apos Conditions Platform"; Rec."SMG APOs Conditions Platform")
                    {
                        ApplicationArea = All;
                        Visible = SMGAPOSPlatformEnabled;
                        Enabled = SMGAPOSPlatformEnabled;
                        DrillDownPageId = "SMG APOS Platform Cond. List";
                    }
                    field("PercentageAPOS"; PercentageAPOS)
                    {
                        Caption = '% Off-Invoice APOS', Comment = 'ESP="% F.F. APOS"';
                        ApplicationArea = All;
                        Visible = SMGAPOsEnabled;
                        Enabled = SMGAPOsEnabled;
                        Editable = false;
                    }
                }
                group(SMG_RC)
                {
                    Caption = 'Remaining Conditions', Comment = 'ESP="Resto Condiciones"';

                    field("SMG Transport Sales %"; Rec."SMG Transport Sales %")
                    {
                        ApplicationArea = All;
                    }
                    field("SMG Devs Fin %"; Rec."SMG Devs Fin %")
                    {
                        ApplicationArea = All;
                    }
                    field("SMG Commission %"; Rec."SMG Commission %")
                    {
                        ApplicationArea = All;
                    }
                    field("SMG No Apply RAEE"; Rec."SMG No Apply RAEE")
                    {
                        ApplicationArea = All;
                    }
                    field("SMG Customer Sales Discounts"; Rec."SMG Customer Sales Discounts")
                    {
                        ApplicationArea = All;
                        DrillDownPageId = "SMG Sales Discounts";
                    }
                }
            }
        }
    }
    actions
    {
        //>> BBT: Atención a la nueva versión de gestión de precios y descuentos!!!
        modify(DiscountLines)
        {
            Visible = not SMGEnable;
            Enabled = not SMGEnable;
        }
        modify(PriceListsDiscounts)
        {
            Visible = not SMGEnable;
            Enabled = not SMGEnable;
        }
        modify("Line Discounts")
        {
            Visible = not SMGEnable;
            Enabled = not SMGEnable;
        }
        //<<
        addlast("Prices and Discounts")
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
        addlast(Category_Category7)
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
        rSMGCOLSConditions: record "SMG COLS Conditions";
        rSMGAPOSConditions: Record "SMG APOS Conditions";
        rSMGSalesDiscounts: record "SMG Sales Discounts";
        SMGEnable: Boolean;
        SMGClassificationEnable: Boolean;
        SMGPurchaseGroupEnable: Boolean;
        SMGCustomerTypeEnable: Boolean;
        SMGNationalGroupEnable: Boolean;
        SMGPlatformEnable: Boolean;
        SMGCOLsEnabled: Boolean;
        SMGAPOsEnabled: Boolean;
        SMGAPOSPlatformEnabled: Boolean;
        PercentageCOL: Decimal;
        PercentageAPOS: Decimal;
        SMGPurchaseGroupDiscEnabled: Boolean;
        SMGCustomerTypeDiscEnabled: Boolean;
        SMGNationalGroupDiscEnabled: Boolean;
        SMGPlatformDiscEnabled: Boolean;
        TextCountDtoPurchaseGroup: Text;
        TextCountDtoCustomerType: Text;
        TextCountDtoNationalGroup: Text;
        TextCountDtoPlatform: Text;

    trigger OnOpenPage()
    begin
        SMGEnable := cuSMGManagement.IsMarginEnabled;
        cuSMGManagement.InitializeMarginConfiguration(rSMGSetup);
        SMGPurchaseGroupEnable := rSMGSetup."Purchase Group Enabled";
        SMGCustomerTypeEnable := rSMGSetup."Customer Type Enabled";
        SMGNationalGroupEnable := rSMGSetup."National Group Enabled";
        SMGPlatformEnable := rSMGSetup."Platform Enabled";
        SMGClassificationEnable := SMGPurchaseGroupEnable or SMGPurchaseGroupEnable or SMGNationalGroupEnable or SMGPlatformEnable;
        SMGCOLsEnabled := rSMGSetup."COLs Conditions Enabled";
        SMGAPOsEnabled := rSMGSetup."APOs Conditions Enabled";
        SMGAPOSPlatformEnabled := rSMGSetup."Platform APOs Enabled";
        SMGPurchaseGroupDiscEnabled := rSMGSetup."Purch. Group Disc. Enabled";
        SMGCustomerTypeDiscEnabled := rSMGSetup."Customer Type Disc. Enabled";
        SMGNationalGroupDiscEnabled := rSMGSetup."National Group Disc. Enabled";
        SMGPlatformDiscEnabled := rSMGSetup."Platform Disc. Enabled";
    end;

    trigger OnAfterGetRecord()
    begin
        Clear(PercentageCOL);
        Clear(PercentageAPOS);
        if SMGEnable then begin
            if SMGCOLsEnabled then
                PercentageCOL := cuSMGManagement.SMGPercentageFFCOLS(Rec."No.");
            if SMGAPOsEnabled then
                PercentageAPOS := cuSMGManagement.SMGPercentageFFAPOS(Rec."No.", Format(''));
        end;

        Clear(TextCountDtoPurchaseGroup);
        if SMGPurchaseGroupDiscEnabled then begin
            rSMGSalesDiscounts.Reset();
            rSMGSalesDiscounts.SetRange("SMG Apply to", rSMGSalesDiscounts."SMG Apply to"::"Purchasing Group");
            rSMGSalesDiscounts.SetRange("SMG Code", rec."SMG Purchase Group");
            if rSMGSalesDiscounts.FindSet() then
                TextCountDtoPurchaseGroup := Format(rSMGSalesDiscounts.Count);
        end;
        Clear(TextCountDtoCustomerType);
        if SMGCustomerTypeDiscEnabled then begin
            rSMGSalesDiscounts.Reset();
            rSMGSalesDiscounts.SetRange("SMG Apply to", rSMGSalesDiscounts."SMG Apply to"::"Customer Type");
            rSMGSalesDiscounts.SetRange("SMG Code", rec."SMG Customer Type");
            if rSMGSalesDiscounts.FindSet() then
                TextCountDtoCustomerType := Format(rSMGSalesDiscounts.Count);
        end;
        Clear(TextCountDtoNationalGroup);
        if SMGNationalGroupDiscEnabled then begin
            rSMGSalesDiscounts.Reset();
            rSMGSalesDiscounts.SetRange("SMG Apply to", rSMGSalesDiscounts."SMG Apply to"::"National Group");
            rSMGSalesDiscounts.SetRange("SMG Code", rec."SMG National Group");
            if rSMGSalesDiscounts.FindSet() then
                TextCountDtoNationalGroup := Format(rSMGSalesDiscounts.Count);
        end;
        Clear(TextCountDtoPlatform);
        if SMGCustomerTypeDiscEnabled then begin
            rSMGSalesDiscounts.Reset();
            rSMGSalesDiscounts.SetRange("SMG Apply to", rSMGSalesDiscounts."SMG Apply to"::Platform);
            rSMGSalesDiscounts.SetRange("SMG Code", rec."SMG Platform");
            if rSMGSalesDiscounts.FindSet() then
                TextCountDtoPlatform := Format(rSMGSalesDiscounts.Count);
        end;
    end;
}