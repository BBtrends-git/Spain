pageextension 50025 "Item Category Card" extends "Item Category Card"
{
    layout
    {
        addafter(Description)
        {
            field("Residues Declaration"; Rec."Residues Declaration")
            {
                ApplicationArea = All;
            }
        }
    }
}
