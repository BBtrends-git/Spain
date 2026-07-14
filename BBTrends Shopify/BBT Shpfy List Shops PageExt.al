pageextension 73103 "BBT Shpfy List Shops Ext" extends "Shpfy Shops"
{
    layout
    {
        addafter(Code)
        {
            field(MarketPlace; Rec.MarketPlace)
            {
                ApplicationArea = All;
            }
            field("ID Marketplace"; Rec."ID Marketplace")
            {
                ApplicationArea = All;
            }
        }
    }
}
