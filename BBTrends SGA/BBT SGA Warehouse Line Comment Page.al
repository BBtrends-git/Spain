Page 51453 "SGA Warehouse Line Comment"
{
    Caption = 'SGA Warehouse Line Comment', Comment = 'Linea Comentarios Almacén';
    AutoSplitKey = true;
    PageType = List;
    SourceTable = "SGA Warehouse Line Comment";
    UsageCategory = Documents;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Date"; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Comment"; Rec.Comment)
                {
                    ApplicationArea = All;
                }
                field("Document Line No."; Rec."Document Line No.")
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