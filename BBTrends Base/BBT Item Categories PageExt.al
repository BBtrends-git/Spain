pageextension 50024 "Item Categories" extends "Item Categories"
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
