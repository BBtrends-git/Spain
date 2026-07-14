PageExtension 50109 "BBT Vendor Card" extends "Vendor Card"
{
    layout
    {
        addfirst(Invoicing)
        {
            field("VAT PL"; Rec."VAT PL")
            {
                ApplicationArea = Basic;
            }
            field("Invoice Type"; Rec."Invoice Type")
            {
                ApplicationArea = All;
            }
        }
        addafter("Creditor No.")
        {
            field("Related Customer"; Rec."Telex Answer Back")
            {
                ApplicationArea = Basic;
                Caption = 'Telex Answer Back';
                TableRelation = Customer;
            }
            group(Control1000000001)
            {
                Caption = 'Communication';

                field("EDI ID"; Rec."EDI ID")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
            }
        }
        moveafter("Block Payment Tolerance"; "Preferred Bank Account code")
        addafter("IC Partner Code")
        {
            field("BBT Do Not Send Inv. To SII"; Rec."BBT Do Not Send Inv. To SII")
            {
                ApplicationArea = All;
            }
        }
    }
}
