page 50109 "BBT Rework Type By Cust./Item"
{
    ApplicationArea = All;
    Caption = 'Rework Type By Customer/Item', comment = 'ESP="Tipo retrabajo por cliente/producto"';
    PageType = List;
    SourceTable = "BBT Rework Type By Cust./Item";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("BBT Customer No."; Rec."BBT Customer No.")
                {
                    ApplicationArea = All;
                }
                field("BTT Rework Item No."; Rec."BTT Rework Item No.")
                {
                    ApplicationArea = All;
                }
                field("BBT Rework Type"; Rec."BBT Rework Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
