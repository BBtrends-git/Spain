PageExtension 50130 "BBT User Setup" extends "User Setup"
{
    layout
    {
        //>>
        /*
        addafter("Time Sheet Admin.")
        {
            field("Impresora por defecto"; Rec."Impresora por defecto")
            {
                ApplicationArea = Basic;
            }
        }
        */
        //<<
        addbefore(Email)
        {
            field("Exclusive Ecomm Sales Allowed"; Rec."Exclusive Ecomm Sales Allowed")
            {
                ApplicationArea = Basic;
            }
        }
    }
}