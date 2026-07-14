PageExtension 50136 "BBT Posted Sales Cr. Mem. Sub" extends "Posted Sales Cr. Memo Subform"
{
    layout
    {
        addafter("Allow Invoice Disc.")
        {
            field("Salesperson Code"; Rec."Salesperson Code")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
