PageExtension 50173 "BBT Job Queue Entries" extends "Job Queue Entries"
{
    layout
    {
        addafter("Ending Time")
        {
            field("Retry on Error"; Rec."Retry on Error")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
