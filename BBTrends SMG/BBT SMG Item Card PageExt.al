PageExtension 51301 "SMG Item Card" extends "Item Card"
{
    layout
    {
        modify("Standard Cost")
        {
            trigger OnBeforeValidate()
            var
                cuSMGManagement: Codeunit "SMG Management";
            begin
                if (Rec."Standard Cost" <> xRec."Standard Cost") and
                    (Rec."Standard Cost" <> 0) then begin
                    cuSMGManagement.SMGUpdateStandardCost(Rec);
                    CurrPage.Update();
                end;
            end;
        }
        addafter("Costs & Posting")
        {
            group(SMG)
            {
                Caption = 'Margin Setup', Comment = 'ESP="Margenes"';
                Visible = SMGEnable;
                Enabled = SMGEnable;
                group(Margin)
                {
                    Caption = 'Margin', Comment = 'ESP="Margen"';

                    field("SMG RAEE Amount"; Rec."SMG RAEE Amount")
                    {
                        ApplicationArea = All;
                    }
                    field("SMG Royalty %"; Rec."SMG Royalty %")
                    {
                        ApplicationArea = All;
                    }
                    field("SMG Warranty %"; Rec."SMG Warranty %")
                    {
                        ApplicationArea = All;
                    }
                }
                group(History)
                {
                    Caption = 'History', Comment = 'ESP="Histórico"';

                    field("SMGStandardCostHistory"; SMGStandardCost)
                    {
                        Caption = 'Active Standard Cost', Comment = 'ESP="Coste Standard Activo"';
                        ApplicationArea = All;
                        Editable = false;

                        trigger OnAssistEdit()
                        var
                            rSMGHistoricalValuesMargin: Record "SMG Historical Values Margin";
                        begin
                            rSMGHistoricalValuesMargin.Reset();
                            rSMGHistoricalValuesMargin.SetRange("Type", rSMGHistoricalValuesMargin.Type::"Standard Cost");
                            rSMGHistoricalValuesMargin.SetRange("Item No.", Rec."No.");
                            Page.Run(Page::"SMG Hist Standard Cost List", rSMGHistoricalValuesMargin);
                            SMGStandardCost := IsEnabledStandarCost();
                        end;

                    }
                    field("AmountStdCost"; AmountStdCost)
                    {
                        Caption = 'Current Standard Cost', Comment = 'ESP="Coste Standard Actual"';
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("SMGTransEcomCostHistory"; SMGEcommTranspCost)
                    {
                        Caption = 'Active Transport Ecom. Cost', Comment = 'ESP="Coste Trasp. Ecom. Activo"';
                        ApplicationArea = All;
                        Editable = false;

                        trigger OnAssistEdit()
                        var
                            rSMGHistoricalValuesMargin: Record "SMG Historical Values Margin";
                        begin
                            rSMGHistoricalValuesMargin.Reset();
                            rSMGHistoricalValuesMargin.SetRange("Type", rSMGHistoricalValuesMargin.Type::"Ecomm Transport Cost");
                            rSMGHistoricalValuesMargin.SetRange("Item No.", Rec."No.");
                            Page.Run(Page::"SMG Hist Transp Ecom Cost List", rSMGHistoricalValuesMargin);
                            SMGEcommTranspCost := IsEnabledEcommTranspCost();
                        end;
                    }
                    field("AmountEcommCost"; AmountEcommCost)
                    {
                        Caption = 'Current Transport Ecom. Cost', Comment = 'ESP="Coste Trasp. Ecom. Actual"';
                        ApplicationArea = All;
                        Editable = false;
                    }
                }
            }
        }
    }

    actions
    {
        addlast(PricesandDiscounts)
        {

            group("HistoricalCost")
            {
                Caption = 'Historical Cost', Comment = 'ESP="Costes Históricos"';
                Visible = SMGEnable;
                Enabled = SMGEnable;
                Image = GetStandardJournal;

                action("StandardCost")
                {
                    Caption = 'Standard Cost', Comment = 'ESP="Coste Estandar"';
                    ApplicationArea = All;
                    Image = ItemCosts;

                    RunObject = Page "SMG Hist Standard Cost List";
                    RunPageLink = "Item No." = FIELD("No.");
                    RunPageMode = View;
                }
                action("TransEcomCost")
                {
                    Caption = 'Transport Ecom Cost', Comment = 'ESP="Coste Transp. Ecom."';
                    ApplicationArea = All;
                    Image = ResourceCosts;

                    RunObject = Page "SMG Hist Transp Ecom Cost List";
                    RunPageLink = "Item No." = FIELD("No.");
                    RunPageMode = View;
                }
            }

        }
        addlast(Category_Category6)
        {
            group(HistoricalCost_Promoted)
            {
                Caption = 'Historical Cost', Comment = 'ESP="Costes Históricos"';
                Visible = SMGEnable;
                Enabled = SMGEnable;
                Image = GetStandardJournal;

                actionref(StandardCost_promoted; StandardCost)
                { }
                actionref(TransEcomCost_promoted; TransEcomCost)
                { }
            }
        }
    }

    var
        cuSMGManagement: Codeunit "SMG Management";
        SMGEnable: Boolean;
        AmountStdCost: Decimal;
        AmountEcommCost: Decimal;
        SMGStandardCost: Boolean;
        SMGEcommTranspCost: Boolean;

    trigger OnOpenPage()
    begin
        SMGEnable := cuSMGManagement.IsMarginEnabled;
    end;

    trigger OnAfterGetRecord()
    begin
        Clear(SMGStandardCost);
        Clear(SMGEcommTranspCost);
        Clear(AmountStdCost);
        Clear(AmountEcommCost);
        if SMGEnable then begin

            SMGStandardCost := IsEnabledStandarCost();
            SMGEcommTranspCost := IsEnabledEcommTranspCost();

            AmountStdCost := cuSMGManagement.SMGAmountStdHistCost(Rec."No.");
            AmountEcommCost := cuSMGManagement.SMGAmountTransportEcomHistCost(Rec."No.");
        end;
    end;

    local procedure IsEnabledStandarCost(): Boolean
    var
        rSMGHistoricalValuesMargin: Record "SMG Historical Values Margin";
    begin
        rSMGHistoricalValuesMargin.Reset();
        rSMGHistoricalValuesMargin.SetRange("Type", "SMG Item Hist Margin Type"::"Standard Cost");
        rSMGHistoricalValuesMargin.SetRange("Item No.", Rec."No.");
        if not rSMGHistoricalValuesMargin.IsEmpty then
            exit(true)
        else
            exit(false);
    end;

    local procedure IsEnabledEcommTranspCost(): Boolean
    var
        rSMGHistoricalValuesMargin: Record "SMG Historical Values Margin";
    begin
        rSMGHistoricalValuesMargin.Reset();
        rSMGHistoricalValuesMargin.SetRange("Type", "SMG Item Hist Margin Type"::"Ecomm Transport Cost");
        rSMGHistoricalValuesMargin.SetRange("Item No.", Rec."No.");
        if not rSMGHistoricalValuesMargin.IsEmpty then
            exit(true)
        else
            exit(false);
    end;
}