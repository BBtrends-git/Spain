pageextension 51142 "BBT Salespersons/Purchasers" extends "Salespersons/Purchasers"
{
    layout
    {
        modify("Commission %")
        {
            visible = false;
        }
        modify("Coupled to Dataverse")
        {
            Visible = false;
        }

        addbefore("Phone No.")
        {
            field("Job Title"; Rec."Job Title")
            {
                ApplicationArea = All;
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = All;
            }
        }
    }
}