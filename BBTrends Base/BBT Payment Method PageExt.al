PageExtension 50162 "BBT Payment Method" extends "Payment Methods"
{
    layout
    {
        //>> Obsoleto
        /*
        addafter("Create Bills")
        {
            field("Credit Letter"; Rec."Credit Letter")
            {
                ApplicationArea = Basic;
            }
        }
        */
        //<<

        addafter("Bal. Account Type")
        {
            field("EDI - Payment Method"; Rec."EDI - Payment Method")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
