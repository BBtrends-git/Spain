PageExtension 50120 "BBT Sales Invoice Subform" extends "Sales Invoice Subform"
{
    layout
    {
        modify("Line Discount %")
        {
            Visible = false;
        }
        addafter("No.")
        {
            field("EAN Code"; Rec."EAN Code")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Line Amount")
        {
            field("Unit Gross Weight"; Rec."Unit Gross Weight")
            {
                ApplicationArea = Basic;
            }
            field("Unit Net Weight"; Rec."Unit Net Weight")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
