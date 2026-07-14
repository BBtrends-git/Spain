PageExtension 50226 "BBT Items by Location Matrix" extends "Items by Location Matrix"
{
    layout
    {
        addafter(Description)
        {
            field("Standard Cost"; Rec."Standard Cost")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
