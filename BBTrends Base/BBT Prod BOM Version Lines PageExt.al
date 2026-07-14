PageExtension 50255 "BBT Prod BOM Version Lines" extends "Production BOM Version Lines"
{
    layout
    {
        addafter("Ending Date")
        {
            field("Last Direct Cost"; Rec."Last Direct Cost")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
