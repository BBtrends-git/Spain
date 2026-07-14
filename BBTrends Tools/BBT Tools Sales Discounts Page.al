Page 59038 "Tools SMG Sales Discounts"
{
    PageType = List;
    SourceTable = 50002;
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Apply to"; Rec."Apply to")
                {
                    ApplicationArea = Basic;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field("Discount 1 %"; Rec."Discount 1 %")
                {
                    ApplicationArea = Basic;
                }
                field("Discount 2 %"; Rec."Discount 2 %")
                {
                    ApplicationArea = Basic;
                }
                field("Discount 3 %"; Rec."Discount 3 %")
                {
                    ApplicationArea = Basic;
                }
                field("Discount 4 %"; Rec."Discount 4 %")
                {
                    ApplicationArea = Basic;
                }
                field("Discount 5 %"; Rec."Discount 5 %")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
    actions
    { }
}
