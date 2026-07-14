Page 50097 "Log NAVSGA Errors"
{
    Editable = false;
    PageType = List;
    SourceTable = "Log NAVSGA Errors";
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Document No.';
                }
                field("Description  Error"; Rec."Description  Error")
                {
                    ApplicationArea = Basic;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Line No.';
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item No.';
                    Visible = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Last Date"; Rec."Last Date")
                {
                    ApplicationArea = Basic;
                }
                field(Corrected; Rec.Corrected)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }
    actions
    {
    }
    trigger OnOpenPage()
    begin
        Rec.SetFilter(Corrected, '%1', false);
    end;
}
