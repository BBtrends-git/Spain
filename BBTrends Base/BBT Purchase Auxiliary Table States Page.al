page 50110 "BBT Auxiliary Table States"
{
    ApplicationArea = All;
    Caption = 'BTT Auxiliary Table States', comment = 'ESP="Tabla Auxiliar Estados"';
    PageType = List;
    SourceTable = "BBT Purchase Auxiliary Status";
    SourceTableView = sorting("BBT Type");
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("BBT Type"; Rec."BBT Type")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("BBT No."; Rec."BBT Code")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("BBT Description"; Rec."BBT Description")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
