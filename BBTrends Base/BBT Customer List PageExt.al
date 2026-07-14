PageExtension 50002 "BBT Customer List" extends "Customer List"
{
    layout
    {
        addafter(Name)
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer''s VAT registration number for customers in EU countries/regions.';
            }
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies how payment for the document must be submitted, such as bank transfer or check.';
            }
        }
        addafter("VAT Bus. Posting Group")
        {
            field("Service Zone Code"; Rec."Service Zone Code")
            {
                ApplicationArea = Basic;
            }
            field("VAT PL"; Rec."VAT PL")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
    }
    actions
    { }
}
