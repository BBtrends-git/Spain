report 50015 "BBT Loan Reclassification"
{
    Caption = 'Loan Reclassification', comment = 'ESP="Reclasificación préstamo"';
    ApplicationArea = All;
    UsageCategory = None;
    Permissions = tabledata "Gen. Journal Line" = ri;
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', comment = 'ESP="Opciones"';

                    field(Exercise; vGExercise)
                    {
                        Caption = 'Exercise', comment = 'ESP="Ejercicio"';
                        ApplicationArea = All;
                    }
                }
            }
        }
        trigger OnInit()
        begin
            //Proponemos por defecto el ejercicio del año en curso
            vGExercise := Date2DMY(Today, 3);
        end;
    }

    var
        vGExercise: Integer;

    trigger OnPreReport()
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        GenJournalLine: Record "Gen. Journal Line";
        AmortizationTable: Record "BBT Amortization Table";
        AmortizationLines: Record "BBT Amortization Lines";
        GenJournalBatch: Record "Gen. Journal Batch";
        //>> Obsoleto V27
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        //<<
        GJBNoSerialCode: Code[20];
        EmptySerialCode: Code[20];

        vLInitDate, vLEndDate : Date;
        vLLineNo: Integer;
        vLLoanNo: Code[20];
        LocalText000Lbl: Label 'You must select a valid exercise', comment = 'ESP="Debe seleccionar un ejercicio válido"';
        LocalText001Lbl: Label 'There are lines in journal %1 and batch %2. Do you want to delete them?', comment = 'ESP="Existen líneas en el diario %1 y sección %2. ¿Desea eliminarlas?"';
        LocalText002Lbl: Label 'Process completed', comment = 'ESP="Proceso completado"';
        LocalText003Lbl: Label 'LOAN RECLASSIFICATION - %1', comment = 'ESP="RECLASIFICACIÓN PRÉSTAMO - %1 - %2 - %3"';
    begin
        if vGExercise <= 0 then Error(LocalText000Lbl);
        GeneralLedgerSetup.Get();
        GeneralLedgerSetup.TestField("BBT Jnl. Templ. Name Loan Recl");
        GeneralLedgerSetup.TestField("BBT Jnl. Batch Name Loan Recl.");
        GenJournalBatch.Get(GeneralLedgerSetup."BBT Jnl. Templ. Name Loan Recl", GeneralLedgerSetup."BBT Jnl. Batch Name Loan Recl.");
        GenJournalBatch.TestField("No. Series");
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", GeneralLedgerSetup."BBT Jnl. Templ. Name Loan Recl");
        GenJournalLine.SetRange("Journal Batch Name", GeneralLedgerSetup."BBT Jnl. Batch Name Loan Recl.");
        if not GenJournalLine.IsEmpty then if Confirm(StrSubstNo(LocalText001Lbl, GeneralLedgerSetup."BBT Jnl. Templ. Name Loan Recl", GeneralLedgerSetup."BBT Jnl. Batch Name Loan Recl."), true) then GenJournalLine.DeleteAll();
        //Buscamos la última línea por si no se han eliminado las líneas
        if GenJournalLine.FindLast() then vLLineNo := GenJournalLine."Line No.";
        vLInitDate := DMY2Date(1, 1, vGExercise);
        vLEndDate := DMY2Date(31, 12, vGExercise);
        AmortizationTable.Reset();
        AmortizationTable.SetCurrentKey("BBT Loan No.", "BBT Bank", "BBT Init Date", "BBT End Date");
        AmortizationTable.SetFilter("BBT Init Date", '>=%1', vLInitDate);
        AmortizationTable.SetFilter("BBT End Date", '<=%1', vLEndDate);
        if AmortizationTable.FindSet() then
            repeat
                AmortizationLines.Reset();
                AmortizationLines.SetRange("BBT Loan No.", AmortizationTable."BBT Loan No.");
                AmortizationLines.SetRange("BBT Paid", false);
                if AmortizationLines.FindSet() then
                    repeat
                        if vLLoanNo <> AmortizationLines."BBT Loan No." then begin
                            vLLineNo += 10000;
                            GenJournalLine.Init();
                            GenJournalLine.Validate("Journal Template Name", GeneralLedgerSetup."BBT Jnl. Templ. Name Loan Recl");
                            GenJournalLine.Validate("Journal Batch Name", GeneralLedgerSetup."BBT Jnl. Batch Name Loan Recl.");
                            GenJournalLine.Validate("Line No.", vLLineNo);
                            GenJournalLine.Validate("Posting Date", Today);
                            GenJournalLine.Validate("Document Type", GenJournalLine."Document Type"::" ");
                            //>> Obsoleto V27
                            //NoSeriesMgt.InitSeries(GenJournalBatch."No. Series", EmptySerialCode, Today, GenJournalLine."Document No.", EmptySerialCode);
                            //
                            GenJournalBatch.TestField("No. Series");
                            GJBNoSerialCode := GenJournalBatch."No. Series";
                            if NoSeries.AreRelated(GenJournalBatch."No. Series", EmptySerialCode) then
                                GJBNoSerialCode := EmptySerialCode;
                            GenJournalLine."Document No." := NoSeries.GetNextNo(GJBNoSerialCode, Today);
                            //<<
                            GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::"G/L Account");
                            GenJournalLine.Validate("Account No.", AmortizationTable."BBT Long Term Loan Account");
                            GenJournalLine.Validate(Description, StrSubstNo(LocalText003Lbl, AmortizationTable."BBT Loan No.", AmortizationTable."BBT Bank", vGExercise));
                            GenJournalLine.Validate(Amount, AmortizationLines."BBT Fee");
                            GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
                            GenJournalLine.Validate("Bal. Account No.", AmortizationTable."BBT Short Tem Loan Account");
                            GenJournalLine."BBT Loan Reclassification Line" := true;
                            GenJournalLine."BBT Bank No." := AmortizationTable."BBT Bank";
                            GenJournalLine."BBT Loan No." := AmortizationTable."BBT Loan No.";
                            GenJournalLine."BBT Reclassification Exercise" := vGExercise;
                            GenJournalLine.Insert();
                            vLLoanNo := AmortizationLines."BBT Loan No.";
                        end
                        else begin
                            GenJournalLine.Validate(Amount, GenJournalLine.Amount + AmortizationLines."BBT Fee");
                            GenJournalLine.Modify();
                        end;
                    until AmortizationLines.Next() = 0;
            until AmortizationTable.Next() = 0;
        Message(LocalText002Lbl);
    end;


}
