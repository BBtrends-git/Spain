PageExtension 50212 "BBT Posted Return Receipt" extends "Posted Return Receipt"
{
    layout
    {
        addafter("Shipment Date")
        {
            field("Number of Packages"; Rec."Number of Packages")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field(Reference; Rec.Reference)
            {
                ApplicationArea = Basic;
                Editable = false;
            }
        }
    }
}
