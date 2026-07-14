PageExtension 51138 "BBT-IT Posted Sales Cred Memo" extends "Posted Sales Credit Memo"
{
    layout
    {
        addbefore("External Document No.")
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = Basic;
            }
        }
        modify("Your Reference")
        {
            Visible = true;
        }
    }
}