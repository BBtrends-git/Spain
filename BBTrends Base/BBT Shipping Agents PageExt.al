PageExtension 50163 "Shipping Agents" extends "Shipping Agents"
{
    layout
    {
        modify("Internet Address")
        {
            Visible = false;
        }
        modify("Account No.")
        {
            Visible = false;
        }
        addafter(Name)
        {
            field("Integration Type"; Rec."Integration Type")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
