PageExtension 50194 "BBT Posted Transfer Shipments" extends "Posted Transfer Shipments"
{
    layout
    {
        addafter("No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic;
            }
            field("Transfer Order No."; Rec."Transfer Order No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
