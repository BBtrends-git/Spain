Page 51452 "SGA Log Errors"
{
    PageType = List;
    SourceTable = "SGA Log Errors";
    UsageCategory = Documents;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    ApplicationArea = All;
    SourceTableView = where("SGA Corrected" = const(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("SGA Serial No"; Rec."SGA Serial No")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("SGA Document No."; Rec."SGA Document No.")
                {
                    ApplicationArea = All;
                }
                field("SGA Description Error"; Rec."SGA Description Error")
                {
                    ApplicationArea = All;
                }
                field("SGA Line No."; Rec."SGA Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("SGA Item No."; Rec."SGA Item No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("SGA Posting Date"; Rec."SGA Posting Date")
                {
                    ApplicationArea = All;
                }
                field("SGA Last Date"; Rec."SGA Last Date")
                {
                    ApplicationArea = All;
                }
                field("SGA Corrected"; Rec."SGA Corrected")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }
    actions
    { }
}
