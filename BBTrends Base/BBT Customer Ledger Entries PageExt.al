PageExtension 50108 "BBT Customer Ledger Entries" extends "Customer Ledger Entries"
{
    layout
    {
        addafter("Customer No.")
        {
            field("Customer Name BBT"; Rec."Customer Name BBT")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Name BBT field.';
            }
        }
        addafter(Open)
        {
            field(Deduction; Rec.Deduction)
            {
                ApplicationArea = Basic;
                Editable = false;
            }
        }
        addafter("Direct Debit Mandate ID")
        {
            field("Closed by Entry No."; Rec."Closed by Entry No.")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Closed by Amount"; Rec."Closed by Amount")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Doc. Relation"; Rec."Doc. Relation")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
