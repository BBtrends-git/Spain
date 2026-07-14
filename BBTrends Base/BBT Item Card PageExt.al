PageExtension 50003 "BBT Item Card" extends "Item Card"
{
    layout
    {
        modify("Item Category Code")
        {
            ShowMandatory = true;
        }
        modify("Unit Cost")
        {
            ShowMandatory = true;
        }
        //>> BBT. 11/05/2026. LeadTime de Productos 
        modify("Lead Time Calculation")
        {
            Enabled = true;
            Visible = true;
            Editable = false;

            trigger OnAssistEdit()
            var
                CalculoPage: Page "BBT-IT Item LeadTime";
            begin
                CalculoPage.SetItem(Rec);
                CalculoPage.Run();
            end;
        }
        //<<
        addafter("Last Direct Cost")
        {
            field("Scrap Cost"; Rec."Scrap Cost")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
        }
        addafter("Item Category Code")
        {
            field("Item Group"; rec."Item group")
            {
                ApplicationArea = All;
                ShowMandatory = true;
                trigger OnValidate()
                begin
                    if rec."Item Group" <> xRec."Item Group" then begin
                        rec."Item Family" := '';
                        rec."Item Subfamily" := '';
                    end;
                end;
            }
            field("Item Family"; rec."Item Family")
            {
                ApplicationArea = All;
                ShowMandatory = true;
                trigger OnValidate()
                begin
                    if rec."Item Family" <> xRec."Item Family" then begin
                        rec."Item Subfamily" := '';
                    end;
                end;
            }
            field("Item Subfamily"; rec."Item Subfamily")
            {
                ApplicationArea = All;
            }
        }
        addafter(Inventory)
        {
            field("Reserved Qty. on Inventory"; Rec."Reserved Qty. on Inventory")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reserved Qty. on Inventory field.';
            }
        }
        addafter("Last Date Modified")
        {
            field("Modified by User ID"; Rec."Modified by User ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Modified by User ID field.';
            }
        }
        addafter(Warehouse)
        {
            group(SGA)
            {
                Visible = SGAEnabled;
                Enabled = SGAEnabled;

                field("No SGA management"; Rec."No SGA management")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No SGA management field.';
                }
                field("SGA lot management"; Rec."SGA lot management")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA lot management field.';
                }
                field("Forced buy SGA"; Rec."Forced buy SGA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Forced buy SGA field.';
                }
                field("Forced sales SGA"; Rec."Forced sales SGA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Forced sales SGA field.';
                }
            }
        }
        addafter(Description)
        {
            field("Previous Description"; Rec."Previous Description")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        modify("Unit Volume")
        {
            Editable = false;
        }
        modify("Net Weight")
        {
            Editable = false;
        }
        modify("Gross Weight")
        {
            Editable = false;
        }
        addafter(VariantMandatoryDefaultNo)
        {
            field("BBT Rework"; Rec."BBT Rework")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin

                    ReworkVisible := Rec."BBT Rework";
                    CurrPage.Update;
                end;
            }
            field("EAN Code"; Rec."EAN Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
    actions
    {
        addafter("Cost Shares")
        {
            action(Packaging_Residues)
            {
                Caption = 'Packaging and residues', Comment = 'ESP="Envases y residuos"';
                ApplicationArea = all;
                Image = Item;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    glItemResidues: Page "BBT Item Residues";
                    rlItemResidues: Record "BBT Item Residues";
                begin
                    Clear(glItemResidues);
                    rlItemResidues.Reset();
                    rlItemResidues.SetRange("Item No.", Rec."No.");
                    glItemResidues.SetTableView(rlItemResidues);
                    glItemResidues.RunModal();
                end;
            }
        }

        addbefore("Requisition Worksheet")
        {
            action("Retrabajo")
            {
                ApplicationArea = all;
                Image = Workflow;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                Visible = ReworkVisible;

                trigger OnAction()
                var
                    Rework: Record "BBT Rework Type By Cust./Item";
                    ReworkPage: Page "BBT Rework Type By Cust./Item";
                begin
                    Clear(Rework);
                    Clear(ReworkPage);
                    Rework.SetRange("BTT Rework Item No.", '');
                    If not Rework.FindFirst() then Rework.SetRange("BTT Rework Item No.", Rec."No.");
                    ReworkPage.SetTableView(Rework);
                    //ReworkPage.SetRecord(Rework);
                    ReworkPage.Run();
                end;
            }
        }
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
        _infoCompany: Record "Company Information";
        _InterfaceSGA: Codeunit "Interface SGA";
        SGAEnabled: Boolean;
        DeleteItemRecord: Boolean;
        ReworkVisible: Boolean;

    trigger OnOpenPage()
    begin
        // SGA
        _infoCompany.GET;
        SGAEnabled := _infoCompany.SGA;

        DeleteItemRecord := false;

        If Rec."BBT Rework" then
            ReworkVisible := true
        else
            ReworkVisible := false;
    end;

    trigger OnClosePage()
    var
        RecProductos: Record Item;
    begin
        // SGA
        IF SGAEnabled THEN BEGIN
            RecProductos.RESET;
            RecProductos.SETRANGE("No.", rec."NO.");
            RecProductos.SetRange("No SGA management", false);
            RecProductos.SetRange("Last Date Modified", Today);
            IF RecProductos.FINDSET THEN
                REPEAT
                    _InterfaceSGA.GestionProducto(RecProductos);
                    CLEAR(_InterfaceSGA);
                UNTIL RecProductos.NEXT = 0;
        END;
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Cubage Base Unit of Measure");
        rec.CalcFields("Scrap Cost");
        if Rec."Unit Volume" <> Rec."Cubage Base Unit of Measure" then begin
            Rec."Unit Volume" := Rec."Cubage Base Unit of Measure";
            Rec.Modify();
        end;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        DeleteItemRecord := true;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if NOT DeleteItemRecord then
            case true of
                rec.Description = '':
                    begin
                        Rec.TestField(Description);
                        exit(false);
                    end;
                rec."Base Unit of Measure" = '':
                    begin
                        Rec.TestField("Base Unit of Measure");
                        exit(false);
                    end;
                rec."Item Category Code" = '':
                    begin
                        Rec.TestField("Item Category Code");
                        exit(false);
                    end;
                rec."Item group" = '':
                    begin
                        Rec.TestField("Item group");
                        exit(false);
                    end;
                rec."Item Family" = '':
                    begin
                        Rec.TestField("Item Family");
                        exit(false);
                    end;
                rec."Gen. Prod. Posting Group" = '':
                    begin
                        Rec.TestField("Gen. Prod. Posting Group");
                        exit(false);
                    end;
                rec."VAT Prod. Posting Group" = '':
                    begin
                        Rec.TestField("VAT Prod. Posting Group");
                        exit(false);
                    end;
                rec."Inventory Posting Group" = '':
                    begin
                        Rec.TestField("Inventory Posting Group");
                        exit(false);
                    end;
                (rec."Costing Method" = rec."Costing Method"::Standard) and (rec."Standard Cost" <= 0):
                    begin
                        Rec.TestField("Standard Cost");
                        exit(false);
                    end;
            end;
    end;
}
