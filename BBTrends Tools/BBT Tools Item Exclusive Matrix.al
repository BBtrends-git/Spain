page 59003 "BBT Item Exclusive Matrix"
{
    Caption = 'Item Exclusive Matrix Repair';
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = true;
    PageType = list;
    SourceTable = "BBT Item Exclusive Sales";
    UsageCategory = Administration;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ItemNo"; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("NationalGroup"; Rec."National Group")
                {
                    ApplicationArea = All;
                }
                field(Related; Rec.Related)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}