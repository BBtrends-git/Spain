page 51300 "SMG Setup Card"
{
    ApplicationArea = All;
    Caption = 'Margin Management Setup', Comment = 'ESP="Configuración Gestión de Margenes"';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "SMG Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Configuration)
            {
                Caption = 'Configuration', Comment = 'ESP="Configuración"';
                field("SMG Enabled"; Rec."SMG Enabled")
                {
                    ApplicationArea = All;
                }
            }
            group(General)
            {
                Caption = 'General', Comment = 'ESP="General"';
                Enabled = Rec."SMG Enabled";
                Visible = Rec."SMG Enabled";
                field("Minimum Margin %"; Rec."Minimum Margin %")
                {
                    ApplicationArea = All;
                    Enabled = Rec."SMG Enabled";
                }
                field("COLs Conditions Enabled"; Rec."COLs Conditions Enabled")
                {
                    Enabled = Rec."SMG Enabled";
                    ApplicationArea = All;
                }
                field("Net Price Rounding Precision"; Rec."Net Price Rounding Precision")
                {
                    Enabled = rec."SMG Enabled";
                    ApplicationArea = All;
                }
                field("APOs Conditions Enabled"; Rec."APOs Conditions Enabled")
                {
                    Enabled = Rec."SMG Enabled";
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        if not Rec."APOs Conditions Enabled" then
                            Rec."Platform APOs Enabled" := false;
                        CurrPage.Update();
                    end;
                }
                field("Platform APOs Enabled"; Rec."Platform APOs Enabled")
                {
                    Enabled = Rec."SMG Enabled" and Rec."APOs Conditions Enabled";
                    ApplicationArea = All;
                }
            }
            group(Discounts)
            {
                Caption = 'Direct Discounts', Comment = 'ESP="Descuentos Directos"';
                Enabled = Rec."SMG Enabled";
                Visible = Rec."SMG Enabled";
                field("Discount 1 Enabled"; Rec."Discount 1 Enabled")
                {
                    Enabled = Rec."SMG Enabled";
                    ApplicationArea = All;
                }
                field("Discount 2 Enabled"; Rec."Discount 2 Enabled")
                {
                    Enabled = Rec."SMG Enabled";
                    ApplicationArea = All;
                }
                field("Discount 3 Enabled"; Rec."Discount 3 Enabled")
                {
                    Enabled = Rec."SMG Enabled";
                    ApplicationArea = All;
                }
                field("Discount 4 Enabled"; Rec."Discount 4 Enabled")
                {
                    Enabled = Rec."SMG Enabled";
                    ApplicationArea = All;
                }
                field("Discount 5 Enabled"; Rec."Discount 5 Enabled")
                {
                    Enabled = Rec."SMG Enabled";
                    ApplicationArea = All;
                }
                field("Discount 1 Caption"; Rec."Discount 1 Caption")
                {
                    Enabled = Rec."SMG Enabled" and Rec."Discount 1 Enabled";
                    ApplicationArea = All;
                }
                field("Discount 2 Caption"; Rec."Discount 2 Caption")
                {
                    Enabled = Rec."SMG Enabled" and Rec."Discount 2 Enabled";
                    ApplicationArea = All;
                }
                field("Discount 3 Caption"; Rec."Discount 3 Caption")
                {
                    Enabled = Rec."SMG Enabled" and Rec."Discount 3 Enabled";
                    ApplicationArea = All;
                }
                field("Discount 4 Caption"; Rec."Discount 4 Caption")
                {
                    Enabled = Rec."SMG Enabled" and Rec."Discount 4 Enabled";
                    ApplicationArea = All;
                }
                field("Discount 5 Caption"; Rec."Discount 5 Caption")
                {
                    Enabled = Rec."SMG Enabled" and Rec."Discount 5 Enabled";
                    ApplicationArea = All;
                }
            }
            group(ActiveDiscounts)
            {
                Caption = 'Active Customer Classification', Comment = 'ESP="Clasificación de Clientes"';
                Enabled = Rec."SMG Enabled";
                Visible = Rec."SMG Enabled";

                grid(GridLayaut)
                {
                    GridLayout = Columns;
                    group(PurchaseGroupEnabled)
                    {
                        ShowCaption = false;

                        field("Purchase Group Enabled"; Rec."Purchase Group Enabled")
                        {
                            ApplicationArea = All;
                            trigger OnValidate()
                            begin
                                if not Rec."Purchase Group Enabled" then
                                    Rec."Purch. Group Disc. Enabled" := false;
                                FieldEnable();
                                CurrPage.Update();
                            end;
                        }
                        field("Purch. Group Disc. Enabled"; Rec."Purch. Group Disc. Enabled")
                        {
                            ApplicationArea = All;
                            Enabled = PurchaseGroupEnabled;
                        }
                        field(TextCountPurchaseProup; TextCountPurchaseGroup)
                        {
                            Caption = 'Purchase Group Count', Comment = 'ESP="Grupos de Compra"';
                            ApplicationArea = All;
                            Enabled = PurchaseGroupEnabled;
                            Editable = false;
                            trigger OnDrillDown()
                            begin
                                Page.Run(Page::"SMG Purchasing Group List");
                            end;
                        }
                    }
                    group(CustomerTypeEnabled)
                    {
                        ShowCaption = false;

                        field("Customer Type Enabled"; Rec."Customer Type Enabled")
                        {
                            ApplicationArea = All;
                            trigger OnValidate()
                            begin
                                if not Rec."Customer Type Enabled" then
                                    Rec."Customer Type Disc. Enabled" := false;
                                FieldEnable();
                                CurrPage.Update();
                            end;
                        }
                        field("Customer Type Disc. Enabled"; Rec."Customer Type Disc. Enabled")
                        {
                            Enabled = CustomerTypeEnabled;
                            ApplicationArea = All;
                        }
                        field(TextCountCustomerType; TextCountCustomerType)
                        {
                            Caption = 'Customer Type Count', Comment = 'ESP="Tipos de Cliente"';
                            ApplicationArea = All;
                            Enabled = CustomerTypeEnabled;
                            Editable = false;
                            trigger OnDrillDown()
                            begin
                                Page.Run(Page::"SMG Customer Type List")
                            end;
                        }
                    }
                    group(NationalGroupEnabled)
                    {
                        ShowCaption = false;

                        field("National Group Enabled"; Rec."National Group Enabled")
                        {
                            ApplicationArea = All;
                            trigger OnValidate()
                            begin
                                if not Rec."National Group Enabled" then
                                    Rec."National Group Disc. Enabled" := false;
                                FieldEnable();
                                CurrPage.Update();
                            end;
                        }
                        field("National Group Disc. Enabled"; Rec."National Group Disc. Enabled")
                        {
                            Enabled = NationalGroupEnabled;
                            ApplicationArea = All;
                        }
                        field(TextCountNationalGroup; TextCountNationalGroup)
                        {
                            Caption = 'National Group Count', Comment = 'ESP="Grupos Nacionales"';
                            ApplicationArea = All;
                            Enabled = NationalGroupEnabled;
                            Editable = false;
                            trigger OnDrillDown()
                            begin
                                Page.Run(Page::"SMG National Group List")
                            end;
                        }
                    }
                    group(PlatformEnabled)
                    {
                        ShowCaption = false;

                        field("Platform Enabled"; Rec."Platform Enabled")
                        {
                            ApplicationArea = All;
                            trigger OnValidate()
                            begin
                                if not Rec."Platform Enabled" then
                                    rec."Platform Disc. Enabled" := false;
                                FieldEnable();
                                CurrPage.Update();
                            end;
                        }
                        field("Plataforma Disc. Enabled"; Rec."Platform Disc. Enabled")
                        {
                            ApplicationArea = All;
                            Enabled = Rec."Platform Enabled";
                        }
                        field(TextCountPlatform; TextCountPlatform)
                        {
                            Caption = 'Platform Count', Comment = 'ESP="Plataformas"';
                            ApplicationArea = All;
                            Enabled = PlatformEnabled;
                            Editable = false;
                            trigger OnDrillDown()
                            begin
                                Page.Run(Page::"SMG Platform List")
                            end;
                        }
                    }
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(Classification)
            {
                Caption = 'Customer Classification', Comment = 'ESP="Clasificación Clientes"';
                Image = Discount;
                Enabled = Rec."SMG Enabled";

                action(Platform)
                {
                    Caption = 'Platform', Comment = 'ESP="Plataforma"';
                    Enabled = Rec."Platform Enabled";
                    ApplicationArea = All;
                    Image = CustomerLedger;
                    RunObject = Page "SMG Platform List";
                    RunPageLink = Type = filter("Platform");
                    RunPageMode = View;
                }
                action(NationalGroup)
                {
                    Caption = 'National Group', Comment = 'ESP="Grupo Nacional"';
                    Enabled = Rec."National Group Enabled";
                    ApplicationArea = All;
                    Image = CustomerGroup;
                    RunObject = Page "SMG National Group List";
                    RunPageLink = Type = filter("National Group");
                    RunPageMode = View;
                }
                action(CustomerType)
                {
                    Caption = 'Customer Type', Comment = 'ESP="Tipo Cliente"';
                    Enabled = Rec."Customer Type Enabled";
                    ApplicationArea = All;
                    Image = CustomerCode;
                    RunObject = Page "SMG Customer Type List";
                    RunPageLink = Type = filter("Customer Type");
                    RunPageMode = View;
                }
                action(PurchaseGroup)
                {
                    Caption = 'Purchase Group', Comment = 'ESP="Grupo de Compra"';
                    Enabled = Rec."Purchase Group Enabled";
                    ApplicationArea = All;
                    Image = CustomerRating;
                    RunObject = Page "SMG Purchasing Group List";
                    RunPageLink = Type = filter("Purchasing Group");
                    RunPageMode = View;
                }
            }
            group(Conditions)
            {
                Caption = 'Conditions', Comment = 'ESP="Condiciones F.F."';
                Enabled = Rec."SMG Enabled";

                action("APOsCustomerConditions")
                {
                    Caption = 'APOs Customer Conditions', Comment = 'ESP="Condiciones APOS Clientes"';
                    Enabled = Rec."APOs Conditions Enabled";
                    ApplicationArea = All;
                    Image = Discount;
                    RunObject = Page "SMG APOS Customer Cond. List";
                    RunPageLink = "Condition Classification" = filter("SMG APOS Type"::Customer);
                    RunPageMode = View;
                }
                action("APOsPlatformConditions")
                {
                    Caption = 'APOs Platform Conditions', Comment = 'ESP="Condiciones APOs Plataformas"';
                    Enabled = Rec."Platform Enabled" and Rec."Platform APOs Enabled";
                    ApplicationArea = All;
                    Image = Discount;
                    RunObject = Page "SMG APOS Platform Cond. List";
                    RunPageLink = "Condition Classification" = filter("SMG APOS Type"::Platform);
                    RunPageMode = View;
                }
            }
        }

        area(Promoted)
        {
            group(Classification_Promoted)
            {
                Caption = 'Customer Classification', Comment = 'ESP="Clasificación Clientes"';
                Image = Discount;

                actionref(PurchaseGroup_promoted; PurchaseGroup)
                { }
                actionref(CustomarType_promoted; CustomerType)
                { }
                actionref(NationalGroup_promoted; NationalGroup)
                { }
                actionref(Platform_promoted; Platform)
                { }
            }
            group(Conditions_Promoted)
            {
                Caption = 'Conditions', Comment = 'ESP="Condiciones F.F."';
                Image = CalculateInvoiceDiscount;

                actionref(APOsCustomerConditions_promoted; APOsCustomerConditions)
                { }
                actionref(APOsPlatformConditions_promoted; APOsPlatformConditions)
                { }
            }
        }
    }

    var
        TextCountPurchaseGroup: Text[8];
        TextCountNationalGroup: Text[8];
        TextCountCustomerType: Text[8];
        TextCountPlatform: Text[8];
        PurchaseGroupEnabled: Boolean;
        NationalGroupEnabled: Boolean;
        CustomerTypeEnabled: Boolean;
        PlatformEnabled: Boolean;

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        FieldEnable();
    end;

    trigger OnAfterGetRecord()
    begin
        rec.CalcFields("Purchase Group Count", "National Group Count", "Customer Type Count", "Platform Count");
        TextCountPurchaseGroup := Format(Rec."Purchase Group Count");
        TextCountNationalGroup := Format(Rec."National Group Count");
        TextCountCustomerType := Format(Rec."Customer Type Count");
        TextCountPlatform := Format(Rec."Platform Count");
    end;

    local procedure FieldEnable()
    begin
        PurchaseGroupEnabled := Rec."Purchase Group Enabled";
        NationalGroupEnabled := Rec."National Group Enabled";
        CustomerTypeEnabled := Rec."Customer Type Enabled";
        PlatformEnabled := Rec."Platform Enabled";
    end;
}