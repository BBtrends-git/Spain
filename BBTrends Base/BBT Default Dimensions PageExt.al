PageExtension 50172 "BBT Default Dimensions" extends "Default Dimensions"
{
    layout
    {
        addfirst(Control1)
        {
            field("Table ID"; Rec."Table ID")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("No."; Rec."No.")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
        }
    }
}
