PageExtension 50191 "BBT Posted Transfer Shipment" extends "Posted Transfer Shipment"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
        }
    }
}
