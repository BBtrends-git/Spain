PageExtension 50195 "BBT Posted Transfer Receipts" extends "Posted Transfer Receipts"
{
    layout
    {
        addafter("No.")
        {
            field("Transfer Order No."; Rec."Transfer Order No.")
            {
                ApplicationArea = Basic;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
