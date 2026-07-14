PageExtension 50183 "BBT Fixed Asset Card" extends "Fixed Asset Card"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = Basic;
                Importance = Additional;
            }
        }
    }
}
