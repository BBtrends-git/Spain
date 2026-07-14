PageExtension 50257 "BBT Prod. BOM Where-Used" extends "Prod. BOM Where-Used"
{
    layout
    {
        addafter("Quantity Needed")
        {
            field("Production BOM Header No."; Rec."Production BOM Header No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
