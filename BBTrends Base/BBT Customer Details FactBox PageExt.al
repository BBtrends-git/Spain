PageExtension 50225 "BBT Customer Details FactBox" extends "Customer Details FactBox"
{
    layout
    {
        addafter(Contact)
        {
            field("Billing Period"; Rec."Billing Period")
            {
                ApplicationArea = Basic;
            }
            field("Document Sending Profile"; Rec."Document Sending Profile")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
