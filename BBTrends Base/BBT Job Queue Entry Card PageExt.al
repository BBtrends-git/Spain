PageExtension 50174 "BBT Job Queue Entry Card" extends "Job Queue Entry Card"
{
    layout
    {
        addafter(Status)
        {
            field("Retry on Error"; Rec."Retry on Error")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
