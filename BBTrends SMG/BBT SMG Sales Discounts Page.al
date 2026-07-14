Page 51308 "SMG Sales Discounts"
{
    Caption = 'Sales Discounts', Comment = 'ESP="Descuentos de Ventas"';
    PageType = List;
    SourceTable = 51304;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("SMG Apply to"; Rec."SMG Apply to")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("SMG Code"; Rec."SMG Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("SMG Discount 1 %"; Rec."SMG Discount 1 %")
                {
                    Enabled = SMGDto01Enabled;
                    Visible = SMGDto01Enabled;
                    ApplicationArea = All;
                }
                field("SMG Discount 2 %"; Rec."SMG Discount 2 %")
                {
                    Enabled = SMGDto02Enabled;
                    Visible = SMGDto02Enabled;
                    ApplicationArea = All;
                }
                field("SMG Discount 3 %"; Rec."SMG Discount 3 %")
                {
                    Enabled = SMGDto03Enabled;
                    Visible = SMGDto03Enabled;
                    ApplicationArea = All;
                }
                field("SMG Discount 4 %"; Rec."SMG Discount 4 %")
                {
                    Enabled = SMGDto04Enabled;
                    Visible = SMGDto04Enabled;
                    ApplicationArea = All;
                }
                field("SMG Discount 5 %"; Rec."SMG Discount 5 %")
                {
                    Enabled = SMGDto05Enabled;
                    Visible = SMGDto05Enabled;
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    { }

    var
        cuSMGManagement: Codeunit "SMG Management";
        rSMGSetUp: Record "SMG Setup";
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
