page 51116 "BBT-IT Item LeadTime"
{
    PageType = StandardDialog;
    Caption = 'LeadTime Calculation', Comment = 'ESP="Cálculo del LeadTime"';

    layout
    {
        area(content)
        {
            group(Valores)
            {
                ShowCaption = false;

                field("ManufacturingLeadTime"; rParentRec."Manufacturing LeadTime")
                {
                    Caption = 'Manufacturing LeadTime', Comment = 'ESP="Tiempo Fabricación"';
                    ToolTip = 'Specify the product manufacturing time',
                        Comment = 'ESP="Especifica el tiempo de fabricación del producto"';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CalculateLeadTime();
                        CurrPage.Update();
                    end;
                }
                field("Inspection-TransitLeadTime"; rParentRec."Inspection-Transit LeadTime")
                {
                    Caption = 'Inspection-Transit LeadTime', Comment = 'ESP="Tiempo Inspección-Transito"';
                    ToolTip = 'Specify the inspection time plus the product shipping time',
                        Comment = 'ESP="Especifica el tiempo de inspección más el de transporte del producto"';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CalculateLeadTime();
                        CurrPage.Update();
                    end;
                }
                field("LastMile LeadTime"; rParentRec."Last Mile LeadTime")
                {
                    Caption = 'Last Mile LeadTime', Comment = 'ESP="Tiempo Recogida-Almacén"';
                    ToolTip = 'Specify the import processing time plus the products entry time into the warehouse',
                        Comment = 'ESP="Especifica el tiempo de tramitación más el de entrada en el almacén del producto"';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CalculateLeadTime();
                        CurrPage.Update();
                    end;
                }
                field(TotalLeadTime; TotalLeadTime)
                {
                    Caption = 'Total Replenishment Time', Comment = 'ESP="Tiempo Total de Reposición"';
                    ApplicationArea = All;
                    Visible = true;
                    Enabled = true;
                    Editable = false;
                }
            }
        }
    }
    var
        TotalLeadTime: DateFormula;
        TotalDays: Integer;
        rParentRec: Record Item;

    trigger OnOpenPage()
    begin
        CalculateLeadTime();
    end;



    procedure SetItem(var pItem: Record Item)
    begin
        rParentRec := pItem
    end;

    local procedure CalculateLeadTime()
    begin
        Clear(TotalLeadTime);
        Clear(TotalDays);

        if Format(rParentRec."Manufacturing LeadTime") <> '' then
            TotalDays += CalcDate(rParentRec."Manufacturing LeadTime", Today) - Today;

        if Format(rParentRec."Inspection-Transit LeadTime") <> '' then
            TotalDays += CalcDate(rParentRec."Inspection-Transit LeadTime", Today) - Today;

        if Format(rParentRec."Last Mile LeadTime") <> '' then
            TotalDays += CalcDate(rParentRec."Last Mile LeadTime", Today) - Today;

        Evaluate(TotalLeadTime, '<' + Format(TotalDays) + 'D>');

        if TotalLeadTime <> rParentRec."Lead Time Calculation" then begin
            rParentRec."Lead Time Calculation" := TotalLeadTime;
            rParentRec.Modify();
        end;

    end;
}