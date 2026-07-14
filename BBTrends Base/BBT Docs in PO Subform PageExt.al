PageExtension 50250 "BBT Docs. in PO Subform" extends "Docs. in PO Subform"
{
    layout
    {
        addafter("Entry No.")
        {
            field("Cust./Vendor Bank Acc. Code"; Rec."Cust./Vendor Bank Acc. Code")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
