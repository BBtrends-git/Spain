page 50108 "BBT Amortization Table"
{
    ApplicationArea = All;
    Caption = 'Amortization Table', comment = 'ESP="Tabla amortización"';
    PageType = List;
    SourceTable = "BBT Amortization Table";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("BBT Loan No."; Rec."BBT Loan No.")
                {
                    ApplicationArea = All;
                }
                field("BBT Bank"; Rec."BBT Bank")
                {
                    ApplicationArea = All;
                }
                field("BBT Init Date"; Rec."BBT Init Date")
                {
                    ApplicationArea = All;
                }
                field("BBT End Date"; Rec."BBT End Date")
                {
                    ApplicationArea = All;
                }
                field("BBT Interests Account"; Rec."BBT Interests Account")
                {
                    ApplicationArea = All;
                }
                field("BBT Amortization Account"; Rec."BBT Amortization Account")
                {
                    ApplicationArea = All;
                }
                field("BBT Long Term Loan Account"; Rec."BBT Long Term Loan Account")
                {
                    ApplicationArea = All;
                }
                field("BBT Short Tem Loan Account"; Rec."BBT Short Tem Loan Account")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action("Amortization Lines")
            {
                ApplicationArea = All;
                Caption = 'Amortization Lines', comment = 'ESP="Líneas amortización"';
                Image = GetLines;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "BBT Amortization Lines";
                RunPageLink = "BBT Loan No." = field("BBT Loan No.");
            }
        }
        area(Processing)
        {
            action("Loan Reclassification")
            {
                Caption = 'Loan Reclassification', comment = 'ESP="Reclasificación prestamo"';
                ApplicationArea = All;
                Image = PaymentPeriod;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = report "BBT Loan Reclassification";
            }
        }
    }
}
