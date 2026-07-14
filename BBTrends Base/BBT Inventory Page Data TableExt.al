TableExtension 50159 "BBT Inventory Page Data" extends "Inventory Page Data"
{
    fields
    {
        field(50000; "Description  Item No."; Code[20])
        {
            Caption = 'Description  Item No.';
            Editable = false;
            TableRelation = Item;
        }
    }
}
