PageExtension 50197 "BBT BOM Cost Shares" extends "BOM Cost Shares"
{
    layout
    {
        addafter(Type)
        {
            field(Indentation; Rec.Indentation)
            {
                ApplicationArea = Basic;
            }
        }
    }
}
