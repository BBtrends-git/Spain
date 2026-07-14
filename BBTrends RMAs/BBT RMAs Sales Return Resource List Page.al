page 51208 "RMAs Return Resource List"
{
    //AdditionalSearchTerms = 'Workforce List, Mechanism List, Device List';
    ApplicationArea = All;
    Caption = 'Sales Return Resources List', Comment = 'ESP="RMA Operarios Devoluciones"';
    CardPageID = "RMAs Return Resource Card";
    Editable = false;
    PageType = List;
    //QueryCategory = 'Resource List';
    SourceTable = Resource;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Resource Group No."; Rec."Resource Group No.")
                {
                    ApplicationArea = All;
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Indirect Cost %"; Rec."Indirect Cost %")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;

                    Visible = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Privacy Blocked"; Rec."Privacy Blocked")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Resource")
            {
                Caption = '&Resource', Comment = 'ESP="Recursos"';
                Image = Resource;
                action(Statistics)
                {
                    ApplicationArea = All;
                    Caption = 'Statistics', Comment = 'ESP="Estadísticas"';
                    ;
                    Image = Statistics;
                    RunObject = Page "Resource Statistics";
                    RunPageLink = "No." = field("No.");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments', Comment = 'ESP="Comentarios"';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = const(Resource), "No." = field("No.");
                }
                action("Units of Measure")
                {
                    ApplicationArea = All;
                    Caption = 'Units of Measure', Comment = 'ESP="Unidad de Medida"';
                    Image = UnitOfMeasure;
                    RunObject = Page "Resource Units of Measure";
                    RunPageLink = "Resource No." = field("No.");
                }
            }

            group("&Prices")
            {
                Caption = '&Prices';
                Image = Price;
                action(PurchPriceLists)
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Prices';
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
                    Caption = 'Sales Prices';
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
                Caption = 'Plan&ning';
                Image = Planning;
                action("Resource &Capacity")
                {
                    ApplicationArea = All;
                    Caption = 'Resource &Capacity';
                    Image = Capacity;
                    RunObject = Page "Resource Capacity";
                    RunPageOnRec = true;
                }
                action("Resource A&vailability")
                {
                    ApplicationArea = All;
                    Caption = 'Resource A&vailability';
                    Image = Calendar;
                    RunObject = Page "Resource Availability";
                    RunPageLink = "No." = field("No."),
                                  "Unit of Measure Filter" = field("Unit of Measure Filter"),
                                  "Chargeable Filter" = field("Chargeable Filter");
                }
            }
        }
        area(creation)
        {
            action("New Resource Group")
            {
                ApplicationArea = All;
                Caption = 'New Resource Group';
                Image = NewResourceGroup;
                RunObject = Page "Resource Groups";
                RunPageMode = Create;
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
            action("Res. Price List")
            {
                ApplicationArea = All;
                Caption = 'Resource - Price List';
                Image = "Report";
                RunObject = Report "Res. Price List";
            }
            action("Resource Register")
            {
                ApplicationArea = All;
                Caption = 'Resource Register';
                Image = "Report";
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Resource Register";
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions', Comment = 'ESP="Funciones';
                Image = "Action";
                action("Create Time Sheets")
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
            group(Category_New)
            {
                Caption = 'New', Comment = 'Generated from the PromotedActionCategories property index 0.';

                actionref("New Resource Group_Promoted"; "New Resource Group")
                { }
            }
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("Create Time Sheets_Promoted"; "Create Time Sheets")
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
            group(Category_Category5)
            {
                Caption = 'Navigate', Comment = 'Generated from the PromotedActionCategories property index 4.';
            }
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("Resource Statistics_Promoted"; "Resource Statistics")
                {
                }
                actionref("Resource Usage_Promoted"; "Resource Usage")
                {
                }
                actionref("Resource - Cost Breakdown_Promoted"; "Resource - Cost Breakdown")
                {
                }
                actionref("Res. Price List_Promoted"; "Res. Price List")
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        rRMASetup: Record "RMAs Setup";
    begin
        rRMASetup.Reset();
        rRMASetup.Get();

        Rec.SetRange("Resource Group No.", rRMASetup."Resource Group");
    end;

    procedure GetSelectionFilter(): Text
    var
        Resource: Record Resource;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(Resource);
        exit(SelectionFilterManagement.GetSelectionFilterForResource(Resource));
    end;

    procedure SetSelection(var Resource: Record Resource)
    begin
        CurrPage.SetSelectionFilter(Resource);
    end;
}
