PageExtension 51311 "SMG Posted Sales Invoice Lin" extends "Posted Sales Invoice Lines"
{
    layout
    {
        addafter("Line Discount %")
        {
            field("SMG Net Unit Price"; Rec."SMG Net Unit Price")
            {
                ApplicationArea = All;
            }
        }
    }
}