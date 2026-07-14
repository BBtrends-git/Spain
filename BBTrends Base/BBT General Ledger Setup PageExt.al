PageExtension 50129 "BBT General Ledger Setup" extends "General Ledger Setup"
{
    layout
    {
        addafter("Gen. Journal Templates")
        {
            field("PolishVAT Registration No."; Rec."PolishVAT Registration No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Control1900309501)
        {
            group("Loan Reclassification")
            {
                Caption = 'Loan Reclassification', comment = 'ESP="Reclasificación préstamos"';

                field("BBT Jnl. Templ. Name Paym. Fee"; Rec."BBT Jnl. Templ. Name Paym. Fee")
                {
                    ApplicationArea = All;
                }
                field("BBT Jnl. Batch Name Paym. Fee"; Rec."BBT Jnl. Batch Name Paym. Fee")
                {
                    ApplicationArea = All;
                }
                field("BBT Jnl. Templ. Name Loan Recl"; Rec."BBT Jnl. Templ. Name Loan Recl")
                {
                    ApplicationArea = All;
                }
                field("BBT Jnl. Batch Name Loan Recl."; Rec."BBT Jnl. Batch Name Loan Recl.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
