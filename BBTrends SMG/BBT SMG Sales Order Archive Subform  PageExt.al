PageExtension 51310 "SMG Sales Order Archive Subf" extends "Sales Order Archive Subform"
{
    layout
    {
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
        modify("Unit Price")
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
            }
            field("SMGDiscount2%"; Rec."SMG Discount 2 %")
            {
                ApplicationArea = All;
                Enabled = SMGDto02Enabled;
                Visible = SMGDto02Enabled;
            }
            field("SMGDiscount3%"; Rec."SMG Discount 3 %")
            {
                ApplicationArea = All;
                Enabled = SMGDto03Enabled;
                Visible = SMGDto03Enabled;
            }
            field("SMGDiscount4%"; Rec."SMG Discount 4 %")
            {
                ApplicationArea = All;
                Enabled = SMGDto04Enabled;
                Visible = SMGDto04Enabled;
            }
            field("SMGDiscount5%"; Rec."SMG Discount 5 %")
            {
                ApplicationArea = All;
                Enabled = SMGDto05Enabled;
                Visible = SMGDto05Enabled;
            }
            field("SMG Net Unit Price"; Rec."SMG Net Unit Price")
            {
                ApplicationArea = All;
                Enabled = SMGEnabled;
                Visible = SMGEnabled;
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
    }
    var
        cuSMGManagement: Codeunit "SMG Management";
        rSMGSetup: Record "SMG Setup";
        SMGEnabled: Boolean;
        SMGDto01Enabled: Boolean;
        SMGDto02Enabled: Boolean;
        SMGDto03Enabled: Boolean;
        SMGDto04Enabled: Boolean;
        SMGDto05Enabled: Boolean;

    trigger OnOpenPage()
    begin
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
}