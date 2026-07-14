PageExtension 50111 "BBT Vendor Ledger Entries" extends "Vendor Ledger Entries"
{
    layout
    {
        addafter("Vendor No.")
        {
            field("Vendor Name BBT"; Rec."Vendor Name BBT")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Name BBT field.';
            }
        }
    }
}
