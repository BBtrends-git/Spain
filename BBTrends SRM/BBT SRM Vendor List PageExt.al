pageextension 51352 "SRM Vendor List" extends "Vendor List"
{
    layout
    {
        addlast(Control1)
        {
            field("SRM Evaluation Manager"; Rec."SRM Evaluation Manager")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("SRM Vendor Type"; Rec."SRM Vendor Type")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("SRM Vendor Performance"; Rec."SRM Vendor Performance")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("SRM Vendor Classification"; Rec."SRM Vendor Classification")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    { }

}