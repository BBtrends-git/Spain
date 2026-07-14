table 50057 "BBT Amortization Lines"
{
    Caption = 'Amortization Lines', comment = 'ESP="Líneas amortización"';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "BBT Loan No."; Code[20])
        {
            Caption = 'Loan No.', comment = 'ESP="Nº préstamo"';
            NotBlank = true;
            DataClassification = ToBeClassified;
        }
        field(2; "BBT Fee No."; Integer)
        {
            Caption = 'Fee No.', comment = 'ESP="Nº cuota"';
            MinValue = 1;
            DataClassification = ToBeClassified;
        }
        field(3; "BBT Fee"; Decimal)
        {
            Caption = 'Fee', comment = 'ESP="Cuota"';
            DataClassification = ToBeClassified;
        }
        field(4; "BBT Interest"; Decimal)
        {
            Caption = 'Interest', comment = 'ESP="Interés"';
            DataClassification = ToBeClassified;
        }
        field(5; "BBT Amortization"; Decimal)
        {
            Caption = 'Amortization', comment = 'ESP="Amortización"';
            DataClassification = ToBeClassified;
        }
        field(6; "BBT Outstanding Capital"; Decimal)
        {
            Caption = 'Outstanding Capital', comment = 'ESP="Capital pendiente"';
            DataClassification = ToBeClassified;
        }
        field(7; "BBT Paid"; Boolean)
        {
            Caption = 'Paid', comment = 'ESP="Pagado"';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
    keys
    {
        key(PK; "BBT Loan No.", "BBT Fee No.")
        {
            Clustered = true;
        }
    }
    procedure PaymentFee()
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        AmortizationTable: Record "BBT Amortization Table";
        //>> Obsoleto V27
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        NoSeriesBatch: Codeunit "No. Series - Batch";
        //<<
        GJBNoSerialCode: Code[20];
        EmptySerialCode: Code[20];

        vLLineNo: Integer;
        LocalText000Lbl: Label 'PAYMENT FEE - %1', comment = 'ESP="PAGO CUOTA - %1"';
    begin
        GeneralLedgerSetup.Get();
        GenJournalBatch.Get(GeneralLedgerSetup."BBT Jnl. Templ. Name Paym. Fee", GeneralLedgerSetup."BBT Jnl. Batch Name Paym. Fee");
        GenJournalBatch.TestField("No. Series");
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", GeneralLedgerSetup."BBT Jnl. Templ. Name Paym. Fee");
        GenJournalLine.SetRange("Journal Batch Name", GeneralLedgerSetup."BBT Jnl. Batch Name Paym. Fee");
        //Buscamos la última línea por si no se han eliminado las líneas (desde la page)
        if GenJournalLine.FindLast() then vLLineNo := GenJournalLine."Line No.";
        AmortizationTable.Get("BBT Loan No.");
        //Primera línea
        vLLineNo += 10000;
        GenJournalLine.Init();
        GenJournalLine.Validate("Journal Template Name", GeneralLedgerSetup."BBT Jnl. Templ. Name Paym. Fee");
        GenJournalLine.Validate("Journal Batch Name", GeneralLedgerSetup."BBT Jnl. Batch Name Paym. Fee");
        GenJournalLine.Validate("Line No.", vLLineNo);
        GenJournalLine.Validate("Posting Date", Today);
        GenJournalLine.Validate("Document Type", GenJournalLine."Document Type"::Payment);
        GenJournalLine.Validate(Description, StrSubstNo(LocalText000Lbl, Rec."BBT Fee No."));
        //>> Obsoleto V27
        //NoSeriesMgt.InitSeries(GenJournalBatch."No. Series", EmptySerialCode, Today, GenJournalLine."Document No.", EmptySerialCode);
        //
        GenJournalBatch.TestField("No. Series");
        GJBNoSerialCode := GenJournalBatch."No. Series";
        if NoSeries.AreRelated(GenJournalBatch."No. Series", EmptySerialCode) then
            GJBNoSerialCode := EmptySerialCode;
        GenJournalLine."Document No." := NoSeries.GetNextNo(GJBNoSerialCode, Today);
        //<<
        //>> V27
        //Obsolete('Use SimulateGetNextNo from "No. Series - Batch" instead', '24.0')]
        //GenJournalLine.IncrementDocumentNo(GenJournalBatch, GenJournalLine."Document No.");
        NoSeriesBatch.SimulateGetNextNo(GenJournalBatch."No. Series", Today, GenJournalLine."Document No.");
        //<<
        GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::"Bank Account");
        GenJournalLine.Validate("Account No.", AmortizationTable."BBT Bank");
        GenJournalLine.Validate(Description, StrSubstNo(LocalText000Lbl, Rec."BBT Fee No."));
        GenJournalLine.Validate(Amount, Rec."BBT Interest");
        GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
        GenJournalLine.Validate("Bal. Account No.", AmortizationTable."BBT Interests Account");
        GenJournalLine."BBT Amortization Line" := true;
        GenJournalLine."BBT Loan No." := "BBT Loan No.";
        GenJournalLine."BBT Fee No." := "BBT Fee No.";
        GenJournalLine.Insert();
        //Segunda línea
        vLLineNo += 10000;
        GenJournalLine.Init();
        GenJournalLine.Validate("Journal Template Name", GeneralLedgerSetup."BBT Jnl. Templ. Name Paym. Fee");
        GenJournalLine.Validate("Journal Batch Name", GeneralLedgerSetup."BBT Jnl. Batch Name Paym. Fee");
        GenJournalLine.Validate("Line No.", vLLineNo);
        GenJournalLine.Validate("Posting Date", Today);
        GenJournalLine.Validate("Document Type", GenJournalLine."Document Type"::Payment);
        //>> Obsoleto V27
        //NoSeriesMgt.InitSeries(GenJournalBatch."No. Series", EmptySerialCode, Today, GenJournalLine."Document No.", EmptySerialCode);
        //
        GenJournalBatch.TestField("No. Series");
        GJBNoSerialCode := GenJournalBatch."No. Series";
        if NoSeries.AreRelated(GenJournalBatch."No. Series", EmptySerialCode) then
            GJBNoSerialCode := EmptySerialCode;
        GenJournalLine."Document No." := NoSeries.GetNextNo(GJBNoSerialCode, Today);
        //<<
        GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::"Bank Account");
        GenJournalLine.Validate("Account No.", AmortizationTable."BBT Bank");
        GenJournalLine.Validate(Description, StrSubstNo(LocalText000Lbl, Rec."BBT Fee No."));
        GenJournalLine.Validate(Amount, Rec."BBT Amortization");
        GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
        GenJournalLine.Validate("Bal. Account No.", AmortizationTable."BBT Amortization Account");
        GenJournalLine."BBT Amortization Line" := true;
        GenJournalLine."BBT Loan No." := "BBT Loan No.";
        GenJournalLine."BBT Fee No." := "BBT Fee No.";
        GenJournalLine.Insert();
    end;
}
