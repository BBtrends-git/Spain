PageExtension 50112 "BBT Item List" extends "Item List"
{
    layout
    {
        addafter(Description)
        {
            field("EAN Code"; Rec."EAN Code")
            {
                ApplicationArea = all;
            }
        }
        addafter("Item Category Code")
        {
            field("Item Group"; rec."Item group")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("Item Family"; rec."Item Family")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("Item Subfamily"; rec."Item Subfamily")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        addafter("Last Direct Cost")
        {
            field(Inventory; Rec.Inventory)
            {
                ApplicationArea = all;
            }
            field("Reserved Qty. on Inventory"; Rec."Reserved Qty. on Inventory")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Inventory to Date"; Rec."Inventory to Date")
            {
                ApplicationArea = all;
            }
        }
        addafter("Tariff No.")
        {
            field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
            {
                ApplicationArea = All;
            }
            field("Gross Weight"; Rec."Gross Weight")
            {
                ApplicationArea = All;
            }
            field("Net Weight"; Rec."Net Weight")
            {
                ApplicationArea = All;
            }
            field("Unit Volume"; Rec."Unit Volume")
            {
                ApplicationArea = All;
            }
        }
        addafter("Search Description")
        {
            field("Rolled-up Material Cost"; Rec."Rolled-up Material Cost")
            {
                ApplicationArea = All;
            }
            field("Rolled-up Capacity Cost"; Rec."Rolled-up Capacity Cost")
            {
                ApplicationArea = All;
            }
            field("Rolled-up Subcontracted Cost"; Rec."Rolled-up Subcontracted Cost")
            {
                ApplicationArea = All;
            }
            field("Rounding Precision"; Rec."Rounding Precision")
            {
                ApplicationArea = All;
            }
        }
        addafter(Blocked)
        {
            field("Purchasing Blocked"; Rec."Purchasing Blocked")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Sales Blocked"; Rec."Sales Blocked")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Production Blocked"; Rec."Production Blocked")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Service Blocked"; Rec."Service Blocked")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
        addafter("Assembly Policy")
        {
            field("Reordering Policy"; Rec."Reordering Policy")
            {
                ApplicationArea = All;
            }
            field("Safety Stock Quantity"; Rec."Safety Stock Quantity")
            {
                ApplicationArea = All;
            }
        }
        addafter("Flushing Method")
        {
            field("Lot Accumulation Period"; Rec."Lot Accumulation Period")
            {
                ApplicationArea = All;
            }
        }
        addafter("Item Tracking Code")
        {
            field("Lot Nos."; Rec."Lot Nos.")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
        addafter("Default Deferral Template Code")
        {
            field("Prevent Negative Inventory"; Rec."Prevent Negative Inventory")
            {
                ApplicationArea = All;
            }
            field("Modified by User ID"; Rec."Modified by User ID")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = All;
                Visible = false;
            }
            // BBT. 22/05/2025. Intregración Custom CRM obsoleta.
            /*
            field("Integrado CRM"; Rec."Integrado CRM")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Ult. Integración"; Rec."Ult. Integración")
            {
                ApplicationArea = All;
                Caption = 'Ult.Integración CRM';
                Editable = false;
            }
            field("ID CRM"; Rec."ID CRM")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
            }
            */
            //<<
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
                Visible = false;
            }
            //>> Obsoleto V28
            /*
            field("Common Item No."; Rec."Common Item No.")
            {
                ApplicationArea = All;
                Visible = false;
            }
            */
            //<<
            field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Qty. on Prod. Order"; Rec."Qty. on Prod. Order")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Qty. on Component Lines"; Rec."Qty. on Component Lines")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Qty. on Purch. Return"; Rec."Qty. on Purch. Return")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Qty. on Sales Return"; Rec."Qty. on Sales Return")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
        addafter("Standard Cost")
        {
            field("Scrap Cost"; Rec."Scrap Cost")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Manufacturing Policy"; "Assembly Policy")
    }
    actions
    {
        //>> BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        /*
        addafter("Adjust Cost - Item Entries")
        {
            action(IntegrarCRM)
            {
                ApplicationArea = All;
                Caption = 'Sincronizar CRM';
                Description = 'Sincronizar CRM';
                Image = RefreshLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    cIntCRM: Codeunit 50017;
                    rItems: Record Item;
                begin
                    CurrPage.SetSelectionFilter(rItems);
                    if rItems.FindSet() then cIntCRM.SincronizarProds(rItems);
                end;
            }
            action(IntegrarTarifas)
            {
                ApplicationArea = All;
                Caption = 'Sincronizar Tarifas';
                Description = 'Sincronizar CRM';
                Image = RefreshLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    cIntCRM: Codeunit 50017;
                    rItems: Record Item;
                begin
                    CurrPage.SetSelectionFilter(rItems);
                    if rItems.FindSet() then begin
                        cIntCRM.SincronizarTarifas(rItems);
                    end;
                end;
            }
        }
        */
        //<<
        addafter("Substituti&ons")
        {
            action("Exclusivity")
            {
                ApplicationArea = Suite;
                Caption = 'Exclusivity', Comment = 'ESP="Exclusividad"';
                Image = EditLines;
                RunObject = Page "BBT Item Excl Sales Matrix";
                RunPageLink = "No." = field("No.");
                ToolTip = 'View or edit the exclusive sale of this item to different national customer groups',
                        Comment = 'ESP="Ver o editar la venta exclusiva de este articulo a diferentes grupos nacionales de clientes"';
            }
        }
    }
    var
    //ClientTypeManagement: Codeunit 50012;
    //TempFilterItemAttributesBuffer: Record "Filter Item Attributes Buffer" temporary;
    //TempFilteredItem: Record Item temporary;
    //RunOnTempRec: Boolean;

    trigger OnAfterGetRecord()
    begin
        rec.CalcFields("Scrap Cost");
    end;

    procedure GetItemsFromTemporary(var FromRecord: Record Item temporary)
    begin
        FromRecord.Reset();
        if FromRecord.FindSet() then
            repeat
                if Rec.Get(FromRecord."No.") then Rec.Mark(true);
            until FromRecord.Next() = 0;
        Rec.FilterGroup(2);
        Rec.MarkedOnly(true);
        Rec.FilterGroup(0);
    end;
}
