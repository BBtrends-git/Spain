PageExtension 50117 "BBT Sales Invoice" extends "Sales Invoice"
{
    layout
    {
        modify("Posting No.")
        {
            Editable = false;
        }
        addafter("Salesperson Code")
        {
            field("Service Zone Code"; Rec."Service Zone Code")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
        }
        addafter("Bill-to Contact No.")
        {
            field("Bill-to Code"; Rec."Bill-to Code")
            {
                ApplicationArea = Basic;
            }
        }
        //>> BBT. SMG Extension. 
        /*
        addafter("Pmt. Discount Date")
        {
            field("Purchase Group"; Rec."Purchase Group")
            {
                ApplicationArea = Basic;
                Importance = Promoted;
            }
        }
        */
        moveafter("Bill-to Contact"; "VAT Bus. Posting Group")
        moveafter("Shortcut Dimension 2 Code"; "Payment Method Code")
    }
}
