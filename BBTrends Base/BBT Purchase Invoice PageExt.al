PageExtension 50122 "BBT Purchase Invoice" extends "Purchase Invoice"
{
    layout
    {
        addafter("Buy-from Contact")
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = Basic;
            }
        }
        //>> Campo Obsoleto
        /*
        addafter("Purchaser Code")
        {
            field("Import No."; Rec."Import No.")
            {
                ApplicationArea = Basic;
            }
        }
        */
        //<<
        addafter(Status)
        {
            //>> Campo Obsoleto
            /*
            field("Base DUA"; Rec."Base DUA")
            {
                ApplicationArea = Basic;
            }
            */
            //<<
            field("Posting No."; Rec."Posting No.")
            {
                ApplicationArea = Basic;
                Visible = false;
                Editable = false;
            }
        }
    }
}
