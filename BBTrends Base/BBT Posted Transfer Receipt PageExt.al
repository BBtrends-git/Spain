PageExtension 50193 "BBT Posted Transfer Receipt" extends "Posted Transfer Receipt"
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
