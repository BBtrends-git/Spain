PageExtension 50235 "BBT Sales Order Archives" extends "Sales Order Archives"
{
    layout
    {
        addafter("Interaction Exist")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
