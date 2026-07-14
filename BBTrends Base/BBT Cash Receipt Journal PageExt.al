PageExtension 50150 "BBT Cash Receipt Journal" extends "Cash Receipt Journal"
{
    layout
    {
        addafter("Applied (Yes/No)")
        {
            field(Deduction; Rec.Deduction)
            {
                ApplicationArea = Basic;
            }
        }
    }
}
