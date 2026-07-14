PageExtension 50011 "BBT General Ledger Entries" extends "General Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field(Comment; Rec.Comment)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Comment field.';
            }
        }
    }
}
