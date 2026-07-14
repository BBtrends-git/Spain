page 50120 "BBT Residues Type Value List"
{
    ApplicationArea = All;
    Caption = 'Residues Type Value List', Comment = 'ESP="Valores tipo residuo"';
    PageType = ListPart;
    SourceTable = "BBT Residues Type Value";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%ESP="Cód. residuo"';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%ESP="Descripción"';
                }
                field("Value"; Rec."Value")
                {
                    ToolTip = 'Specifies the value of the Value field.', Comment = '%ESP="Valor"';
                }
            }
        }
    }
}
