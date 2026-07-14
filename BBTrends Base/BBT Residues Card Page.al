page 50119 "BBT Residues Card"
{
    ApplicationArea = All;
    Caption = 'Residues Card', Comment = 'ESP="Ficha residuo"';
    PageType = Card;
    SourceTable = "BBT Residues";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.', Comment = 'ESP="Cód. residuo"';
                    editable = PKeditable;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.', Comment = 'ESP="Nombre"';
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.', Comment = 'ESP="Tipo"';
                }
                field(Unit; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit field.', Comment = 'ESP="Unidad"';
                }
                field("Order"; Rec."Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order field.', Comment = 'ESP="Orden"';
                }
            }
            group(General2)
            {
                ShowCaption = false;

                part("BBT Residues Type Value List"; "BBT Residues Type Value List")
                {
                    ApplicationArea = All;
                    SubPageLink = Code = field("No.");
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ScrapCost)
            {
                ApplicationArea = All;
                Caption = 'Add Scrap Cost', comment = 'ESP="Añadir coste scrap"';
                Image = Cost;

                trigger OnAction()
                var
                    rlResidues: Record "BBT Residues";
                    rlItemResidues: Record "BBT Item Residues";
                    rlResiduesValues: Record "BBT Residues Type Value";
                    glCountryResidualCost: Page "BBT Country Residual Cost";
                    rlCountryResidualCost: Record "BBT Country Residual Cost";
                    vNumericValue: Decimal;
                begin
                    Clear(glCountryResidualCost);
                    rlCountryResidualCost.Reset();
                    rlCountryResidualCost.SetRange("Residue Code", Rec."No.");
                    //rlCountryResidualCost.SetRange(Country, Rec."Country/Region");
                    if rlCountryResidualCost.FindSet() then begin
                        glCountryResidualCost.SetTableView(rlCountryResidualCost);
                        glCountryResidualCost.RunModal();
                    end
                    else begin
                        //Rec.TestField("Country/Region");
                        rlCountryResidualCost.Init();
                        rlCountryResidualCost."Residue Code" := Rec."No.";
                        //rlCountryResidualCost.Country := Rec."Country/Region";
                        rlCountryResidualCost.Insert();
                        Commit();
                        glCountryResidualCost.SetTableView(rlCountryResidualCost);
                        glCountryResidualCost.RunModal();
                    end;
                end;
            }
        }
        area(Promoted)
        {
            actionref(ScrapCost_Promoted; ScrapCost)
            { }
        }
    }
    var
        PKeditable: Boolean;

    trigger OnOpenPage()
    begin
        PKeditable := false;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        PKeditable := true;
    end;
}
