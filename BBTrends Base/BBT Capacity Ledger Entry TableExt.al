TableExtension 50167 "BBT Capacity Ledger Entry" extends "Capacity Ledger Entry"
{
    fields
    {
        field(50000; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
    }
}
