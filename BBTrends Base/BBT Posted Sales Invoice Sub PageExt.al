PageExtension 50134 "BBT Posted Sales Invoice Sub" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter("Unit Cost (LCY)")
        {
            field("EDI - Gross unit price"; Rec."EDI - Gross unit price")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("Shipment No."; Rec."Shipment No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
