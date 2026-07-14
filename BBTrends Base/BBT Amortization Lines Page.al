page 50113 "BBT Amortization Lines"
{
    ApplicationArea = All;
    Caption = 'Amortization Lines', comment = 'ESP="Líneas amortización"';
    PageType = List;
    SourceTable = "BBT Amortization Lines";
    SourceTableView = sorting("BBT Loan No.", "BBT Fee No.");
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("BBT Fee No."; Rec."BBT Fee No.")
                {
                    ApplicationArea = All;
                }
                field("BBT Fee"; Rec."BBT Fee")
                {
                    ApplicationArea = All;
                }
                field("BBT Interest"; Rec."BBT Interest")
                {
                    ApplicationArea = All;
                }
                field("BBT Amortization"; Rec."BBT Amortization")
                {
                    ApplicationArea = All;
                }
                field("BBT Outstanding Capital"; Rec."BBT Outstanding Capital")
                {
                    ApplicationArea = All;
                }
                field("BBT Paid"; Rec."BBT Paid")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Payment Fee")
            {
                Caption = 'Payment Fee', comment = 'ESP="Pago cuota"';
                ApplicationArea = All;
                Image = PaymentJournal;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    GeneralLedgerSetup: Record "General Ledger Setup";
                    GenJournalLine: Record "Gen. Journal Line";
                    GeneralJournal: Page "General Journal";
                    BBTAmortizationTable: Record "BBT Amortization Table";
                    LocalText000Lbl: Label 'The payment of the selected record will be proposed in the configured general journal. Do you wish to continue?', comment = 'ESP="Se va a proponer el pago del registro seleccionado en el diario general configurado. ¿Desea continuar?"';
                    LocalText001Lbl: Label 'Process canceled by user', comment = 'ESP="Proceso cancelado por el usuario"';
                    LocalText002Lbl: Label 'There are lines in journal %1 and batch %2. Do you want to delete them?', comment = 'ESP="Existen líneas en el diario %1 y sección %2. ¿Desea eliminarlas?"';
                    LocalText003Lbl: Label 'Process completed', comment = 'ESP="Proceso finalizado"';
                begin
                    if not Confirm(LocalText000Lbl, true) then Error(LocalText001Lbl);
                    GeneralLedgerSetup.Get();
                    GeneralLedgerSetup.TestField("BBT Jnl. Templ. Name Paym. Fee");
                    GeneralLedgerSetup.TestField("BBT Jnl. Batch Name Paym. Fee");
                    Rec.TestField("BBT Paid", false);
                    GenJournalLine.Reset();
                    GenJournalLine.SetRange("Journal Template Name", GeneralLedgerSetup."BBT Jnl. Templ. Name Paym. Fee");
                    GenJournalLine.SetRange("Journal Batch Name", GeneralLedgerSetup."BBT Jnl. Batch Name Paym. Fee");
                    if not GenJournalLine.IsEmpty then if Confirm(StrSubstNo(LocalText002Lbl, GeneralLedgerSetup."BBT Jnl. Templ. Name Paym. Fee", GeneralLedgerSetup."BBT Jnl. Batch Name Paym. Fee"), true) then GenJournalLine.DeleteAll();
                    Rec.PaymentFee();
                    Message(LocalText003Lbl);
                end;
            }
        }
    }
}
