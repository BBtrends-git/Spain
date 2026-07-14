PageExtension 50256 "BBT Prod. BOM Version List" extends "Prod. BOM Version List"
{
    layout
    {
        addfirst(Control1)
        {
            field("Production BOM No."; Rec."Production BOM No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        addafter("Last Date Modified")
        {
            field("No. Series"; Rec."No. Series")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
    }
}
