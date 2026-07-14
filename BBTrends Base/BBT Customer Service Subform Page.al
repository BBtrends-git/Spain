Page 50073 "Customer Service Subform"
{
    Caption = 'Líneas';
    PageType = ListPart;
    SourceTable = "Customer Service Line";
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Replace for Item No."; Rec."Replace for Item No.")
                {
                    ApplicationArea = Basic;
                }
                field("Replace for Item Description"; Rec."Replace for Item Description")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
    actions
    {
    }
}
