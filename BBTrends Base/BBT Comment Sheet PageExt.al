PageExtension 50131 "BBT Comment Sheet" extends "Comment Sheet"
{
    layout
    {
        addafter("Code")
        {
            field("Comment type"; Rec."Comment type")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(Desactivado; Rec.Desactivado)
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
    }
}
