Page 50012 "Warehouse Line Comment"
{
    AutoSplitKey = true;
    PageType = List;
    SourceTable = 50005;
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
    actions
    { }
}
