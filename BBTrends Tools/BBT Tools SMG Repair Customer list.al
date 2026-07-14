page 59035 "Tools SMG Customer List"
{
    ApplicationArea = All;
    CardPageID = "Tools SMG Customer Card";
    Editable = false;
    PageType = List;
    QueryCategory = 'Customer List';
    SourceTable = Customer;
    UsageCategory = Lists;
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
