PageExtension 51309 "SMG Posted Sales Cr Memo Subf" extends "Posted Sales Cr. Memo Subform"
{
    layout
    {
        modify("Line Discount %")
        {
            visible = false;
        }
        addafter("Unit Price")
        {
            field("SMG Discount 1 %"; Rec."SMG Discount 1 %")
            {
                ApplicationArea = All;
                Enabled = SMGDto01Enabled;
                Visible = SMGDto01Enabled;

            }
            field("SMG Discount 2 %"; Rec."SMG Discount 2 %")
            {
                ApplicationArea = All;
                Enabled = SMGDto02Enabled;
                Visible = SMGDto02Enabled;
            }
            field("SMG Discount 3 %"; Rec."SMG Discount 3 %")
            {
                ApplicationArea = All;
                Enabled = SMGDto03Enabled;
                Visible = SMGDto03Enabled;
            }
            field("SMG Discount 4 %"; Rec."SMG Discount 4 %")
            {
                ApplicationArea = All;
                Enabled = SMGDto04Enabled;
                Visible = SMGDto04Enabled;
            }
            field("SMG Discount 5 %"; Rec."SMG Discount 5 %")
            {
                ApplicationArea = All;
                Enabled = SMGDto05Enabled;
                Visible = SMGDto05Enabled;
            }
            field("SMG Net Unit Price"; Rec."SMG Net Unit Price")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = SMGEnabled;
                Enabled = SMGEnabled;
            }
            field("SMG Discounts Total Amount"; Rec."SMG Discounts Total Amount")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = SMGEnabled;
                Enabled = SMGEnabled;
            }
        }
        addafter("Line Amount")
        {
            field("SMG Commission %"; Rec."SMG Commission %")
            {
                ApplicationArea = All;
                Visible = SMGEnabled;
                Enabled = SMGEnabled;
            }
            field("SMG Commission Amount"; Rec."SMG Commission Amount")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = SMGEnabled;
                Enabled = SMGEnabled;
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