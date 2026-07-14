pageextension 73104 "BBT Shpfy Orders Ext" extends "Shpfy Orders"
{
    layout
    {
        addbefore(Error)
        {
            field(Validado; Rec.Validado)
            {
                ApplicationArea = All;
            }
            field("Blocked per price"; Rec."Blocked per price")
            {
                ApplicationArea = All;
            }
        }
        addafter(TotalAmount)
        {
            field("VAT Included"; Rec."VAT Included")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("VAT Amount"; Rec."VAT Amount")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }
}
