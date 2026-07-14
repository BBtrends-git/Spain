page 50106 "BBT Warranty Type List"
{
    ApplicationArea = All;
    Caption = 'Warranty Type List', comment = 'ESP="Lista Tipos Garantía"';
    PageType = List;
    SourceTable = "BBT Warranty Types";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field("Description"; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Duration"; Rec."Duration")
                {
                    ApplicationArea = All;
                }
                field("Total Items"; Rec."Total Items")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
