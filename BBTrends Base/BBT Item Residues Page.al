page 50121 "BBT Item Residues"
{
    ApplicationArea = All;
    Caption = 'BBT Item Residues', Comment = 'ESP="Relación residuos producto"';
    PageType = List;
    SourceTable = "BBT Item Residues";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = 'ESP="Nº producto"';
                }
                field("Residue No."; Rec."Residue No.")
                {
                    ToolTip = 'Specifies the value of the Residue No. field.', Comment = 'ESP="Nº residuo"';
                }
                field("Residue Name"; Rec."Residue Name")
                {
                    ToolTip = 'Specifies the value of the Residue No. field.', Comment = 'ESP="Nombre residuo"';
                    Editable = false;
                }
                field("Numeric Value"; Rec."Numeric Value")
                {
                    ToolTip = 'Specifies the value of the Numeric Value field.', Comment = 'ESP="Valor numérico"';
                    BlankZero = true;

                    trigger OnValidate()
                    var
                        rlResidue: Record "BBT Residues";
                    begin
                        if rlResidue.Get(Rec."Residue No.") then
                            if rlResidue.Type = rlResidue.Type::Option then
                                Error('No es posible insertar un valor de tipo decimal en un residuo de tipo opción.');
                    end;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Residue No. field.', Comment = 'ESP="Unidad"';
                    Editable = false;
                }
                field("Option Value"; Rec."Option Value")
                {
                    ToolTip = 'Specifies the value of the Option Value field.', Comment = 'ESP="Valor opción"';

                    trigger OnValidate()
                    var
                        rlResidue: Record "BBT Residues";
                    begin
                        if rlResidue.Get(Rec."Residue No.") then
                            if rlResidue.Type = rlResidue.Type::Decimal then
                                Error('No es posible insertar un valor de tipo opción en un residuo de tipo decimal.');
                    end;
                }
                field(Scrap; Rec.Scrap)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        vScrap := rec.Scrap;
                    end;
                }
                field("Country/Region"; Rec."Country/Region")
                {
                    ApplicationArea = All;
                    Editable = vScrap;
                }
                field("Scrap Cost"; Rec."Scrap Cost")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DecimalPlaces = 5;
                    BlankZero = true;
                }
                field(Currency; Rec.Currency)
                {
                    ApplicationArea = All;
                    Editable = vScrap;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Initialize)
            {
                ApplicationArea = All;
                Caption = 'Initialize', comment = 'ESP="Inicializar"';
                Image = Start;

                trigger OnAction()
                var
                    rlItemResidues: Record "BBT Item Residues";
                begin
                    rlItemResidues.Reset();
                    rlItemResidues.SetRange("Item No.", Rec."Item No.");
                    if rlItemResidues.FindFirst() then begin
                        if Confirm('Ya existen residuos asignados a este producto. ¿Desea eliminarlos e inicializarlos de nuevo?') then begin
                            rlItemResidues.Reset();
                            rlItemResidues.SetRange("Item No.", Rec."Item No.");
                            if rlItemResidues.FindSet() then rlItemResidues.DeleteAll();

                            InitializeItemScraps(Rec."Item No.");
                        end;
                    end
                    else begin
                        InitializeItemScraps(Rec."Item No.");
                    end;
                end;
            }
            action(ValidateScrapCost)
            {
                ApplicationArea = All;
                Caption = 'Validate Scrap Cost', Comment = 'ESP="Validar coste scrap"';
                Image = Start;

                trigger OnAction()
                var
                    clScrapCostManagement: Codeunit "Scrap Cost Management";
                begin
                    if clScrapCostManagement.ProductCalculateScrapCost(Rec."Item No.") then
                        Message('El coste scrap ha sido calculado correctamente.');
                end;
            }
        }
        area(Promoted)
        {
            actionref(Initialize_Promoted; Initialize)
            {
            }
            actionref(ValidateScrapCost_Promoted; ValidateScrapCost)
            {
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        vScrap := false;
        if Rec.Scrap then vScrap := true;
    end;

    trigger OnClosePage()
    var
        clScrapCostManagement: Codeunit "Scrap Cost Management";
    begin
        clScrapCostManagement.ProductCalculateScrapCost(Rec."Item No.");
    end;

    var
        vScrap: Boolean;

    local procedure InitializeItemScraps(pItemNo: code[20])
    var
        rResidues: Record "BBT Residues";
        rItemResidues: Record "BBT Item Residues";
        rResiduesValues: Record "BBT Residues Type Value";
        vNumericValue: Decimal;
    begin
        rResidues.Reset();
        rResidues.SetRange("Show in Declaration", true);
        if rResidues.FindSet() then begin
            repeat
                rItemResidues.Init();
                rItemResidues."Item No." := pItemNo;
                rItemResidues."Residue No." := rResidues."No.";
                rItemResidues."Residue Name" := rResidues.Name;
                if rResidues.Type = rResidues.Type::Decimal then
                    rItemResidues."Unit of Measure" := rResidues."Unit of Measure";
                rItemResidues.Insert();
            until rResidues.Next() = 0;
        end;
        // BBT 16/02/2026. SCRAP - ES. Totalizador del Residuo.
        rResidues.Reset();
        rResidues.SetRange("Show in Declaration", false);
        rResidues.SetRange("No.", Format('SCRAP'));
        if rResidues.FindFirst() then begin
            rItemResidues.Init();
            rItemResidues.Validate("Item No.", pItemNo);
            rItemResidues.Validate("Residue No.", rResidues."No.");
            rItemResidues.Validate("Numeric Value", 1);
            rItemResidues.Validate(Scrap, true);
            rItemResidues.Validate("Country/Region", Format('ES'));
            rItemResidues.Validate(Currency, Format('EUR'));
            rItemResidues.Insert();
        end;
    end;
}
