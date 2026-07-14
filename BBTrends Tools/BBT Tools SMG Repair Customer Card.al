page 59036 "Tools SMG Customer Card"
{
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Customer;
    Editable = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    ApplicationArea = All;

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
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Condiciones fuera fact. % COLS"; Rec."Condiciones fuera fact. % COLS")
                {
                    ApplicationArea = All;
                }
                field("Condiciones F.F. % APOs 2024"; Rec."Condiciones F.F. % APOs 2024")
                {
                    ApplicationArea = All;
                }
                field("Condiciones F.F. % COLs 2024"; Rec."Condiciones F.F. % COLs 2024")
                {
                    ApplicationArea = All;
                }
                field("Condiciones F.F. % APOs 2025"; Rec."Condiciones F.F. % APOs 2025")
                {
                    ApplicationArea = All;
                }
                field("Condiciones F.F. % COLs 2025"; Rec."Condiciones F.F. % COLs 2025")
                {
                    ApplicationArea = All;
                }
                field("Transporte ventas %"; Rec."Transporte ventas %")
                {
                    ApplicationArea = All;
                }
                field("DEVS  FIN %"; Rec."DEVS  FIN %")
                {
                    ApplicationArea = All;
                }
                field("Comission %"; Rec."Comission %")
                {
                    ApplicationArea = All;
                }
                field("No Apply RAEE"; Rec."No Apply RAEE")
                {
                    ApplicationArea = All;
                }
            }
            group(Clasificacion)
            {
                field("Purchase Group"; Rec."Purchase Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purchase Group field.';
                }
                field("Customer Type"; Rec."Customer Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Type field.';
                }
                field("National Group"; Rec."National Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the National Group field.';
                }
                field(Platform; Rec.Platform)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Platform field.';
                }
                field(Rappel; Rec.Rappel)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Rappel field.', Comment = 'ESP="Rappel"';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Condiciones APos")
            {
                ApplicationArea = all;
                Image = Discount;
                // Promoted = true;
                // PromotedCategory = Process;
                // PromotedIsBig = true;
                RunObject = page "Tools SMG Condiciones APos";
                RunPageView = where(plataforma = const(false));
                RunPageLink = code = field("No.");
            }

            action("Dtos. por cliente")
            {
                ApplicationArea = all;
                Image = Customer;
                // Promoted = true;
                // PromotedCategory = Category7;
                // PromotedIsBig = true;
                RunObject = Page "Tools SMG Sales Discounts";
                RunPageLink = "Apply to" = CONST(Customer), Code = FIELD("No.");
            }
            action("Dtos. por tipo de cliente")
            {
                ApplicationArea = all;
                Image = CustomerRating;
                // Promoted = true;
                // PromotedCategory = Category7;
                // PromotedIsBig = true;
                RunObject = Page "Tools SMG Sales Discounts";
                RunPageLink = "Apply to" = CONST("Customer Type"), Code = FIELD("Customer Type");
            }
            action("Dtos. por Grupo Nacional")
            {
                ApplicationArea = all;
                Image = CustomerGroup;
                // Promoted = true;
                // PromotedCategory = Category7;
                // PromotedIsBig = true;
                RunObject = Page "Tools SMG Sales Discounts";
                RunPageLink = "Apply to" = CONST("National Group"), Code = FIELD("National Group");
            }
            action("Dtos. por Plataforma")
            {
                ApplicationArea = all;
                Image = CustomerList;
                // Promoted = true;
                // PromotedCategory = Category7;
                // PromotedIsBig = true;
                RunObject = Page "Tools SMG Sales Discounts";
                RunPageLink = "Apply to" = CONST(Platform), Code = FIELD(Platform);
            }
        }
    }
}