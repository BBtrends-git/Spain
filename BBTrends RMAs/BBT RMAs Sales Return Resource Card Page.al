page 51209 "RMAs Return Resource Card"
{
    Caption = 'Sales Return Resources', Comment = 'ESP="Operarios Devoluciones"';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Resource;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Standard;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the resource.';
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies information in addition to the description.';
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies whether the resource is a person or a machine.';
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the base unit used to measure the resource, such as hour, piece, or kilometer.';
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.';
                    Visible = false;
                }
                field("Resource Group No."; Rec."Resource Group No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the resource group that this resource is assigned to.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.';
                }
                field("Privacy Blocked"; Rec."Privacy Blocked")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies whether to limit access to data for the data subject during daily operations. This is useful, for example, when protecting data from changes while it is under privacy review.';
                    Visible = false;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the most recent change of information in the Resource Card window.';
                }
                field("Use Time Sheet"; Rec."Use Time Sheet")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies if a resource uses a time sheet to record time allocated to various tasks.';
                }
                field("Time Sheet Owner User ID"; Rec."Time Sheet Owner User ID")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the name of the owner of the time sheet.';
                }
                field("Time Sheet Approver User ID"; Rec."Time Sheet Approver User ID")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the ID of the approver of the time sheet.';
                }
            }
            //>> BBT 14/08/2025 Datos de coste y precio para facturación de los recursos.
            /*
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cost of one unit of the selected item or resource.';
                }
                field("Indirect Cost %"; Rec."Indirect Cost %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the percentage of the item''s last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cost of one unit of the item or resource on the line.';
                }
                field("Price/Profit Calculation"; Rec."Price/Profit Calculation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the relationship between the Unit Cost, Unit Price, and Profit Percentage fields associated with this resource.';
                }
                field("Profit %"; Rec."Profit %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the profit margin that you want to sell the resource at. You can enter a profit percentage manually or have it entered according to the Price/Profit Calculation field';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                }
                field("Default Deferral Template Code"; Rec."Default Deferral Template Code")
                {
                    ApplicationArea = All;
                    Caption = 'Default Deferral Template';
                    ToolTip = 'Specifies the default template that governs how to defer revenues and expenses to the periods when they occurred.';
                }
                field("Automatic Ext. Texts"; Rec."Automatic Ext. Texts")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that an Extended Text Header will be added on sales or purchase documents for this resource.';
                }
                field("IC Partner Purch. G/L Acc. No."; Rec."IC Partner Purch. G/L Acc. No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the intercompany g/l account number in your partner''s company that the amount for this resource is posted to.';
                }
            }
            */
            //<<

            //>> BBT 14/08/2025 Datos personales del recurso
            /*
            group("Personal Data")
            {
                Caption = 'Personal Data';
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the person''s job title.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the address or location of the resource, if applicable.';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies additional address information.';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the city of the resource''s address.';
                }
                group(Control47)
                {
                    ShowCaption = false;
                    Visible = IsCountyVisible;
                    field(County; Rec.County)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies a special region, to which the resource belongs.';
                    }
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the postal code.';
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the country/region of the address.';

                    trigger OnValidate()
                    begin
                        IsCountyVisible := FormatAddress.UseCounty(Rec."Country/Region Code");
                    end;
                }
                field("Social Security No."; Rec."Social Security No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the person''s social security number or the machine''s serial number.';
                }
                field(Education; Rec.Education)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the training, education, or certification level of the person.';
                }
                field("Contract Class"; Rec."Contract Class")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contract class for the person.';
                }
                field("Employment Date"; Rec."Employment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the person began working for you or the date when the machine was placed in service.';
                }
            }
            */
            //<<
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Resource")
            {
                Caption = '&Resource', Comment = 'ESP="Recurso"';
                Image = Resource;
                action(Statistics)
                {
                    ApplicationArea = All;
                    Caption = 'Statistics', Comment = 'ESP="Estadísticas"';
                    Image = Statistics;
                    RunObject = Page "Resource Statistics";
                    RunPageLink = "No." = field("No."),
                                  "Date Filter" = field("Date Filter"),
                                  "Unit of Measure Filter" = field("Unit of Measure Filter"),
                                  "Chargeable Filter" = field("Chargeable Filter");
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
                }
                action("Units of Measure")
                {
                    ApplicationArea = All;
                    Caption = 'Units of Measure', Comment = 'ESP="Unidad de Medida"';
                    Image = UnitOfMeasure;
                    RunObject = Page "Resource Units of Measure";
                    RunPageLink = "Resource No." = field("No.");
                    ToolTip = 'View or edit the units of measure that are set up for the resource.';
                }
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments', Comment = 'ESP="Comentarios"';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = const(Resource),
                                  "No." = field("No.");
                    ToolTip = 'View or add comments for the record.';
                }
                separator(Action69)
                { }
            }

            group("&Prices")
            {
                Caption = '&Prices', Comment = 'ESP="Precios"';
                Image = Price;

                action(PurchPriceLists)
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Prices', Comment = 'ESP="Precios Compra"';
                    Image = ResourceCosts;

                    trigger OnAction()
                    var
                        AmountType: Enum "Price Amount Type";
                        PriceType: Enum "Price Type";
                    begin
                        Rec.ShowPriceListLines(PriceType::Purchase, AmountType::Any);
                    end;
                }
                action(SalesPriceLists)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Prices', Comment = 'ESP="Precios Venta"';
                    Image = LineDiscount;

                    trigger OnAction()
                    var
                        AmountType: Enum "Price Amount Type";
                        PriceType: Enum "Price Type";
                    begin
                        Rec.ShowPriceListLines(PriceType::Sale, AmountType::Any);
                    end;
                }
            }
            group("Plan&ning")
            {
                Caption = 'Plan&ning', Comment = 'ESP="Planificación"';
                Image = Planning;
                action("Resource &Capacity")
                {
                    ApplicationArea = All;
                    Caption = 'Resource &Capacity', Comment = 'ESP="Capacidad"';
                    Image = Capacity;
                    RunObject = Page "Resource Capacity";
                    RunPageOnRec = true;
                }
                action("Resource &Allocated per Job")
                {
                    ApplicationArea = All;
                    Caption = 'Resource &Allocated per Project', Comment = 'ESP="Recursos por Proyecto"';
                    Image = ViewJob;
                    RunObject = Page "Resource Allocated per Job";
                    RunPageLink = "Resource Filter" = field("No.");
                }
                action("Resource A&vailability")
                {
                    ApplicationArea = All;
                    Caption = 'Resource A&vailability', Comment = 'ESP="Disponibilidad de Recursos"';
                    Image = Calendar;
                    RunObject = Page "Resource Availability";
                    RunPageLink = "No." = field("No."),
                                  "Base Unit of Measure" = field("Base Unit of Measure"),
                                  "Chargeable Filter" = field("Chargeable Filter");
                }
            }
        }
        area(reporting)
        {
            action("Resource Statistics")
            {
                ApplicationArea = All;
                Caption = 'Resource Statistics', Comment = 'ESP="Estadísticas"';
                Image = "Report";
                RunObject = Report "Resource Statistics";
            }
            action("Resource Usage")
            {
                ApplicationArea = All;
                Caption = 'Resource Usage', Comment = 'ESP="Uso del Recurso"';
                Image = "Report";
                RunObject = Report "Resource Usage";
            }
            action("Resource - Cost Breakdown")
            {
                ApplicationArea = All;
                Caption = 'Resource - Cost Breakdown', Comment = 'ESP="Desglose de Costes"';
                Image = "Report";
                RunObject = Report "Resource - Cost Breakdown";
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions', Comment = 'ESP="Funciones"';
                Image = "Action";
                action(CreateTimeSheets)
                {
                    ApplicationArea = All;
                    Caption = 'Create Time Sheets', Comment = 'ESP="Crear Parte de Trabajo"';
                    Ellipsis = true;
                    Image = NewTimesheet;

                    trigger OnAction()
                    begin
                        Rec.CreateTimeSheets();
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(CreateTimeSheets_Promoted; CreateTimeSheets)
                { }
            }
            group(Category_Category4)
            {
                Caption = 'Resource', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref(Statistics_Promoted; Statistics)
                { }
                actionref("Co&mments_Promoted"; "Co&mments")
                { }

                separator(Navigate_Separator)
                { }

                actionref(SalesPriceLists_Promoted; SalesPriceLists)
                { }
                actionref(PurchPriceLists_Promoted; PurchPriceLists)
                { }
                actionref("Units of Measure_Promoted"; "Units of Measure")
                { }
            }
            group(Category_Category6)
            {
                Caption = 'Prices';
            }
            group(Category_Category7)
            {
                Caption = 'Planning', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category5)
            {
                Caption = 'Navigate', Comment = 'Generated from the PromotedActionCategories property index 4.';
            }
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("Resource Statistics_Promoted"; "Resource Statistics")
                { }
                actionref("Resource Usage_Promoted"; "Resource Usage")
                { }
                actionref("Resource - Cost Breakdown_Promoted"; "Resource - Cost Breakdown")
                { }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        rRMASetup: Record "RMAs Setup";
    begin
        rRMASetup.Reset();
        rRMASetup.Get();

        Rec."Resource Group No." := rRMASetup."Resource Group";
        Rec."Base Unit of Measure" := 'HORA';
    end;
}

