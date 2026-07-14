PageExtension 50114 "BBT General Journal" extends "General Journal"
{
    layout
    {
        modify(Control1900919607)
        {
            Visible = false;
        }
        addafter("Posting Date")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
        }
        addafter("Direct Debit Mandate ID")
        {
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = Basic;
            }
            field("Due Date"; Rec."Due Date")
            {
                ApplicationArea = Basic;
            }
            field(Deduction; Rec.Deduction)
            {
                ApplicationArea = Basic;
            }
        }
        addfirst(FactBoxes)
        {
            part(Control1100001; "Dimension Set Entries FactBox")
            {
                SubPageLink = "Dimension Set ID" = field("Dimension Set ID");
                Visible = false;
                ApplicationArea = all;
            }
        }
    }
}
