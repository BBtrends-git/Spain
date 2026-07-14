Page 59037 "Tools SMG Condiciones APos"
{
    PageType = List;
    SourceTable = "Cond APos";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field("APOs Comment"; Rec."APOs Comment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the comments for APO conditions', Comment = 'ESP="Especifica los comentarios de las condiciones APOs"';
                }
                field("Condiciones fuera fact. % APOS"; Rec."Condiciones fuera fact. % APOS")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = all;
                }
                field(Plataforma; Rec.Plataforma)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    { }
}
