page 50118 "BBT Residues"
{
    ApplicationArea = All;
    Caption = 'Residues', Comment = 'ESP="Lista residuos"';
    PageType = List;
    SourceTable = "BBT Residues";
    RefreshOnActivate = true;
    CardPageID = "BBT Residues Card";
    DelayedInsert = true;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = 'ESP="Cód. residuo"';
                    editable = false;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = 'ESP="Nombre"';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = 'ESP="Tipo"';
                }
                field(Unit; Rec."Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Unit field.', Comment = 'ESP="Unidad"';
                }
                field("Order"; Rec."Order")
                {
                    ToolTip = 'Specifies the value of the Order field.', Comment = 'ESP="Orden"';
                }
                field("Show in Declaration"; Rec."Show in Declaration")
                {
                    ToolTip = 'Specifies the value of the Show in Declaration field.', Comment = 'ESP="Mostrar en declaración residuos"';
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
            {
            }
        }
    }
}
