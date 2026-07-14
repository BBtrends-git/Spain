codeunit 50024 "GenJournal Events"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCustLedgEntryInsert', '', false, false)]
    local procedure OnCopyFromItemOnAfterCheck(GenJournalLine: Record "Gen. Journal Line"; GLRegister: Record "G/L Register"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        // - 001
        CustLedgerEntry.Deduction:=GenJournalLine.Deduction;
        CustLedgerEntry.Comment:=GenJournalLine.Comment;
    // + 001
    end;
    //Cuando se registre la amortización propuesta, se deberá marcar automaticamente el booleano de "pagado" de la tabla de amortización para esta línea en concreto
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterPostGenJnlLine', '', true, true)]
    local procedure GenJnlPostLine_OnAfterPostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean; sender: Codeunit "Gen. Jnl.-Post Line")
    var
        AmortizationLines: Record "BBT Amortization Lines";
        vLInitDate, vLEndDate: Date;
    begin
        if GenJournalLine."BBT Amortization Line" then begin
            if AmortizationLines.Get(GenJournalLine."BBT Loan No.", GenJournalLine."BBT Fee No.")then if not AmortizationLines."BBT Paid" then begin
                    AmortizationLines."BBT Paid":=true;
                    AmortizationLines.Modify();
                end end;
    end;
}
