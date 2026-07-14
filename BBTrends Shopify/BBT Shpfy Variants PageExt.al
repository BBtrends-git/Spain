pageextension 73107 "BBT Shpfy Variants Ext" extends "Shpfy Variants"
{
    layout
    {
        addafter(Price)
        {
            field("Compare at Price"; Rec."Compare at Price")
            {
                ApplicationArea = All;
            }
        }
    }
}
