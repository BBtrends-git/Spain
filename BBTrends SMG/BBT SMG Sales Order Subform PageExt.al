PageExtension 51303 "SMG Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                if Rec.Quantity = 0 then begin
                    Rec."SMG Margin %" := 0;
                    Rec."SMG Unit Margin Amount" := 0;
                end;
                cuSMGManagement.SalesHeaderMarginCalculation(Rec);
                FindSMGSalesOrderMargin();
            end;
        }
        modify(Description)
        {
            StyleExpr = MarginStyleTxt;
        }
        modify("Unit Price")
        {
            StyleExpr = MarginStyleTxt;

            trigger OnAfterValidate()
            begin
                if Rec."Unit Price" = 0 then begin
                    Rec."SMG Margin %" := 0;
                    Rec."SMG Unit Margin Amount" := 0;
                end;
                cuSMGManagement.SalesHeaderMarginCalculation(Rec);
                FindSMGSalesOrderMargin();
            end;
        }
        modify("Line Amount")
        {
            StyleExpr = MarginStyleTxt;
        }
        modify("Unit Cost (LCY)")
        {
            Visible = false;
            Editable = false;
        }
        modify("Line Discount %")
        {
            Visible = not SMGEnabled;
            Editable = false;
        }
        modify("Line Discount Amount")
        {
            Visible = true;
            Editable = false;
        }
        addafter("Unit Price")
        {
            field("SMGDiscount1%"; Rec."SMG Discount 1 %")
            {
                ApplicationArea = All;
                Enabled = SMGDto01Enabled;
                Visible = SMGDto01Enabled;

                trigger OnValidate()
                begin
                    if Rec."SMG Discount 1 %" <> 100 then
                        cuSMGManagement.SalesLineMarginCalculation(Rec)
                    else begin
                        Rec."SMG Margin %" := 0;
                        Rec."SMG Unit Margin Amount" := 0;
                    end;
                    Rec.UpdateAmounts();
                    CurrPage.Update();
                    cuSMGManagement.SalesHeaderMarginCalculation(Rec);
                    FindSMGSalesOrderMargin();
                end;
            }
            field("SMGDiscount2%"; Rec."SMG Discount 2 %")
            {
                ApplicationArea = All;
                Enabled = SMGDto02Enabled;
                Visible = SMGDto02Enabled;

                trigger OnValidate()
                begin
                    if Rec."SMG Discount 2 %" <> 100 then
                        cuSMGManagement.SalesLineMarginCalculation(Rec)
                    else begin
                        Rec."SMG Margin %" := 0;
                        Rec."SMG Unit Margin Amount" := 0;
                    end;
                    Rec.UpdateAmounts();
                    CurrPage.Update();
                    cuSMGManagement.SalesHeaderMarginCalculation(Rec);
                    FindSMGSalesOrderMargin();
                end;
            }
            field("SMGDiscount3%"; Rec."SMG Discount 3 %")
            {
                ApplicationArea = All;
                Enabled = SMGDto03Enabled;
                Visible = SMGDto03Enabled;

                trigger OnValidate()
                begin
                    if Rec."SMG Discount 3 %" <> 100 then
                        cuSMGManagement.SalesLineMarginCalculation(Rec)
                    else begin
                        Rec."SMG Margin %" := 0;
                        Rec."SMG Unit Margin Amount" := 0;
                    end;
                    Rec.UpdateAmounts();
                    CurrPage.Update();
                    cuSMGManagement.SalesHeaderMarginCalculation(Rec);
                    FindSMGSalesOrderMargin();
                end;
            }
            field("SMGDiscount4%"; Rec."SMG Discount 4 %")
            {
                ApplicationArea = All;
                Enabled = SMGDto04Enabled;
                Visible = SMGDto04Enabled;
                trigger OnValidate()
                begin
                    if Rec."SMG Discount 4 %" <> 100 then
                        cuSMGManagement.SalesLineMarginCalculation(Rec)
                    else begin
                        Rec."SMG Margin %" := 0;
                        Rec."SMG Unit Margin Amount" := 0;
                    end;
                    Rec.UpdateAmounts();
                    CurrPage.Update();
                    cuSMGManagement.SalesHeaderMarginCalculation(Rec);
                    FindSMGSalesOrderMargin();
                end;
            }
            field("SMGDiscount5%"; Rec."SMG Discount 5 %")
            {
                ApplicationArea = All;
                Enabled = SMGDto05Enabled;
                Visible = SMGDto05Enabled;

                trigger OnValidate()
                begin
                    if Rec."SMG Discount 5 %" <> 100 then
                        cuSMGManagement.SalesLineMarginCalculation(Rec)
                    else begin
                        Rec."SMG Margin %" := 0;
                        Rec."SMG Unit Margin Amount" := 0;
                    end;
                    Rec.UpdateAmounts();
                    CurrPage.Update();
                    cuSMGManagement.SalesHeaderMarginCalculation(Rec);
                    FindSMGSalesOrderMargin();
                end;
            }
        }
        addafter("Line Amount")
        {
            field("SMG Net Unit Price"; Rec."SMG Net Unit Price")
            {
                ApplicationArea = All;
                Enabled = SMGEnabled;
                Visible = false;
            }
        }
        addlast(Control1)
        {
            field("SMGUnitCost"; Rec."Unit Cost")
            {
                ApplicationArea = ALL;
                Editable = false;
            }
            field("SMG%APOSExcludedInvoice"; Rec."SMG % APOS Excluded Invoice")
            {
                ApplicationArea = All;
                Enabled = SMGEnabled;
                Visible = false;
            }
            field("SMG%COLSExcludedInvoice"; Rec."SMG % COLS Excluded Invoice")
            {
                ApplicationArea = All;
                Enabled = SMGEnabled;
                Visible = false;
            }
            field("SMGCommission%"; Rec."SMG Commission %")
            {
                ApplicationArea = All;
                Enabled = SMGEnabled;
                Visible = false;
            }
            field("SMGCommissionAmount"; Rec."SMG Commission Amount")
            {
                ApplicationArea = All;
                Enabled = SMGEnabled;
                Visible = false;
            }
            field("SMGTransportSales%"; Rec."SMG Transport Sales %")
            {
                ApplicationArea = All;
                Enabled = SMGEnabled;
                Visible = false;
            }
            field("SMGDevsFin%"; Rec."SMG Devs Fin %")
            {
                ApplicationArea = All;
                Enabled = SMGEnabled;
                Visible = false;
            }
            field("SMGWarranty%"; Rec."SMG Warranty %")
            {
                ApplicationArea = All;
                Enabled = SMGEnabled;
                Visible = false;
            }
            field("SMGRoyalty%"; Rec."SMG Royalty %")
            {
                ApplicationArea = All;
                Enabled = SMGEnabled;
                Visible = false;
            }
            field("SMGRAEEAmount"; Rec."SMG RAEE Amount")
            {
                ApplicationArea = All;
                Enabled = SMGEnabled;
                Visible = false;
            }
            field("SMGMargin%"; Rec."SMG Margin %")
            {
                StyleExpr = MarginStyleTxt;

                ApplicationArea = All;
                Enabled = SMGEnabled;
                Visible = SMGEnabled;
            }
            field("SMGMarginAmount"; Rec."SMG Unit Margin Amount")
            {
                ApplicationArea = All;
                Enabled = SMGEnabled;
                Visible = SMGEnabled;
            }
        }
        addafter("TotalSalesLine.""Line Amount""")
        {
            field(SMGTotalMargin; rSalesHeader."SMG Total Margin %")
            {
                Enabled = SMGEnabled;
                Editable = false;
                StyleExpr = GlobalMarginStyletxt;
                ApplicationArea = All;
                Caption = 'Total Margin %', Comment = 'ESP="% Margen Total"';
                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
        }
    }

    var
        cuSMGManagement: Codeunit "SMG Management";
        rSMGSetup: Record "SMG Setup";
        rCustomer: Record Customer;
        rSalesHeader: Record "Sales Header";
        rSMGCustomerClassification: record "SMG Customer Classification";
        SMGEnabled: Boolean;
        SMGDto01Enabled: Boolean;
        SMGDto02Enabled: Boolean;
        SMGDto03Enabled: Boolean;
        SMGDto04Enabled: Boolean;
        SMGDto05Enabled: Boolean;
        MarginStyleTxt: Text;
        GlobalMarginStyletxt: Text;
        SMGMinimumMargin: Decimal;

    trigger OnOpenPage()
    begin
        MarginStyleTxt := 'Standard';
        GlobalMarginStyletxt := 'Standard';
        Clear(SMGMinimumMargin);
        SMGEnabled := cuSMGManagement.IsMarginEnabled;
        cuSMGManagement.InitializeMarginConfiguration(rSMGSetup);
        Clear(SMGDto01Enabled);
        Clear(SMGDto02Enabled);
        Clear(SMGDto03Enabled);
        Clear(SMGDto04Enabled);
        Clear(SMGDto05Enabled);
        if SMGEnabled then begin
            SMGDto01Enabled := rSMGSetup."Discount 1 Enabled";
            SMGDto02Enabled := rSMGSetup."Discount 2 Enabled";
            SMGDto03Enabled := rSMGSetup."Discount 3 Enabled";
            SMGDto04Enabled := rSMGSetup."Discount 4 Enabled";
            SMGDto05Enabled := rSMGSetup."Discount 5 Enabled";
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        FindSMGSalesOrderMargin;
    end;

    local procedure FindSMGSalesOrderMargin()
    begin
        SMGMinimumMargin := rSMGSetup."Minimum Margin %";
        rSalesHeader.Reset();
        if rSalesHeader.Get(Rec."Document Type", Rec."Document No.") then;
        rCustomer.Reset();
        if rCustomer.Get(rSalesHeader."Sell-to Customer No.") then begin
            rSMGCustomerClassification.Reset();
            rSMGCustomerClassification.SetRange(Type, rSMGCustomerClassification.Type::"National Group");
            rSMGCustomerClassification.SetRange(Code, rCustomer."SMG National Group");
            rSMGCustomerClassification.SetFilter("Minimum Margin %", '<>%1', 0);
            if rSMGCustomerClassification.FindFirst() then
                SMGMinimumMargin := rSMGCustomerClassification."Minimum Margin %";
        end;

        GlobalMarginStyletxt := 'Standard';
        if rSalesHeader."SMG Total Margin %" < SMGMinimumMargin then
            GlobalMarginStyletxt := 'Unfavorable';

        MarginStyleTxt := 'Standard';
        if rec."SMG Blocked for Short Margin" then
            MarginStyleTxt := 'Unfavorable';
    end;
}