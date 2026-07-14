PageExtension 50153 "BBT Ship-to Address" extends "Ship-to Address"
{
    layout
    {
        addafter(Contact)
        {
            group(EDI)
            {
                Caption = 'EDI';

                field("EDI ID"; Rec."EDI ID")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
}
