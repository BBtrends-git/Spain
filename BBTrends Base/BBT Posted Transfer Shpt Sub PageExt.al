PageExtension 50192 "BBT Posted Transfer Shpt. Sub" extends "Posted Transfer Shpt. Subform"
{
    layout
    {
        addfirst(Control1)
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = Basic;
                Editable = false;
                Visible = false;
            }
        }
    }
}
