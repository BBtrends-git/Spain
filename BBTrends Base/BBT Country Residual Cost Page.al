page 50122 "BBT Country Residual Cost"
{
    ApplicationArea = All;
    Caption = 'Country Residual Cost', Comment = 'ESP="Coste residual por pais"';
    PageType = List;
    SourceTable = "BBT Country Residual Cost";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Residue Code"; Rec."Residue Code")
                {
                    ToolTip = 'Specifies the value of the Residue Code field.', Comment = 'ESP="Codigo residuo"';
                }
                field(Country; Rec.Country)
                {
                    ToolTip = 'Specifies the value of the Country field.', Comment = 'ESP="País"';
                }
                field(Currency; Rec.Currency)
                {
                    ToolTip = 'Specifies the value of the Currency field.', Comment = 'ESP="País"';
                }
                field(Cost; Rec.Cost)
                {
                    ToolTip = 'Specifies the value of the Cost field.', Comment = 'ESP="Coste"';
                }
            }
        }
    }
}
