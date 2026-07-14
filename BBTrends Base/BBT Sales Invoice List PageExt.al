PageExtension 50228 "BBT Sales Invoice List" extends "Sales Invoice List"
{
    layout
    {
        //>> BBT. SMG Extension. 
        /*
        addafter(Status)
        {
            field("Purchase Group"; Rec."Purchase Group")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        */
        addafter("Job Queue Status")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("Customer Posting Group"; Rec."Customer Posting Group")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Control1900316107)
        {
            part(Control1000000000; "Sales Statistics Factbox")
            {
                Editable = false;
                ShowFilter = false;
                SubPageLink = "Document Type" = const(Invoice), "No." = field("No.");
                ApplicationArea = all;
            }
        }
    }
}
