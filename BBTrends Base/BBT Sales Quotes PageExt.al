PageExtension 50227 "BBT Sales Quotes" extends "Sales Quotes"
{
    layout
    {
        //>> V27
        //addafter("Assigned User ID")
        //{
        //    field("Amount Including VAT"; Rec."Amount Including VAT")
        //    {
        //        ApplicationArea = Basic;
        //    }
        //}
        //<<
        addafter(Status)
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
