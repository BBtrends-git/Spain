PageExtension 50110 "BBT Vendor List" extends "Vendor List"
{
    layout
    {
        addafter(Name)
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Post Code")
        {
            //>> V27.1
            //field(City; Rec.City)
            //{
            //    ApplicationArea = Basic;
            //    Visible = false;
            //}
            //<<
            field(County; Rec.County)
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        addafter("Payment Terms Code")
        {
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Base Calendar Code")
        {
            field(Balance; Rec.Balance)
            {
                ApplicationArea = Basic;
            }
            field("Net Change"; Rec."Net Change")
            {
                ApplicationArea = Basic;
            }
            field("Net Change (LCY)"; Rec."Net Change (LCY)")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
