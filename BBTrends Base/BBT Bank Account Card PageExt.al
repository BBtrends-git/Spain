PageExtension 50157 "BBT Bank Account Card" extends "Bank Account Card"
{
    layout
    {
        //Unsupported feature: Property Insertion (Visible) on ""Bank Name - Data Conversion"(Control 19)".
        //Unsupported feature: Property Insertion (Visible) on ""Bank Clearing Standard"(Control 21)".
        //Unsupported feature: Property Insertion (Visible) on ""Bank Clearing Code"(Control 17)".
        //Unsupported feature: Property Modification (Visible) on ""Positive Pay Export Code"(Control 31)".
        addafter(Blocked)
        {
            field("Net Change"; Rec."Net Change")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Creditor No.")
        {
            field("Sufijo presentador"; Rec."Sufijo presentador")
            {
                ApplicationArea = Basic;
            }
            field("Contrato Confirming"; Rec."Contrato Confirming")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
