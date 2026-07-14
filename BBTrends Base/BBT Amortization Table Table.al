table 50053 "BBT Amortization Table"
{
    Caption = 'Amortization Table', comment = 'ESP="Tabla amortización"';
    LookupPageId = "BBT Amortization Table";
    DrillDownPageId = "BBT Amortization Table";
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "BBT Loan No."; Code[20])
        {
            Caption = 'Loan No.', comment = 'ESP="Nº préstamo"';
            NotBlank = true;
            DataClassification = ToBeClassified;
        }
        field(2; "BBT Bank"; Code[20])
        {
            Caption = 'Bank', comment = 'ESP="Banco"';
            TableRelation = "Bank Account" where(Blocked = const(false));
            NotBlank = true;
            DataClassification = ToBeClassified;
        }
        field(3; "BBT Init Date"; Date)
        {
            Caption = 'Init Date', comment = 'ESP="Fecha inicio"';
            DataClassification = ToBeClassified;
        }
        field(4; "BBT End Date"; Date)
        {
            Caption = 'End Date', comment = 'ESP="Fecha fin"';
            DataClassification = ToBeClassified;
        }
        field(5; "BBT Interests Account"; Code[20])
        {
            Caption = 'Interests Account', comment = 'ESP="Cta. intereses"';
            TableRelation = "G/L Account";
            DataClassification = ToBeClassified;
        }
        field(6; "BBT Amortization Account"; Code[20])
        {
            Caption = 'Amortization Account', comment = 'ESP="Cta. amortización"';
            TableRelation = "G/L Account";
            DataClassification = ToBeClassified;
        }
        field(7; "BBT Long Term Loan Account"; Code[20])
        {
            Caption = 'Long Term Loan Account', comment = 'ESP="Cta. préstamo largo plazo"';
            TableRelation = "G/L Account";
            DataClassification = ToBeClassified;
        }
        field(8; "BBT Short Tem Loan Account"; Code[20])
        {
            Caption = 'Short Tem Loan Account', comment = 'ESP="Cta. préstamo corto plazo"';
            TableRelation = "G/L Account";
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "BBT Loan No.")
        {
            Clustered = true;
        }
    }
    /*procedure PaymentFee()
        var
            GeneralLedgerSetup: Record "General Ledger Setup";
            GenJournalLine: Record "Gen. Journal Line";
            GenJournalBatch: Record "Gen. Journal Batch";
            vLLineNo: Integer;
            LocalText000Lbl: Label 'PAYMENT FEE - %1', comment = 'ESP="PAGO CUOTA - %1"';
        begin
            GeneralLedgerSetup.Get();
            GenJournalBatch.Get(GeneralLedgerSetup."BBT Jnl. Templ. Name Amort.", GeneralLedgerSetup."BBT Jnl. Batch Name Amort.");

            GenJournalLine.Reset();
            GenJournalLine.SetRange("Journal Template Name", GeneralLedgerSetup."BBT Jnl. Templ. Name Amort.");
            GenJournalLine.SetRange("Journal Batch Name", GeneralLedgerSetup."BBT Jnl. Batch Name Amort.");
            //Buscamos la última línea por si no se han eliminado las líneas (desde la page)
            if GenJournalLine.FindLast() then
                vLLineNo := GenJournalLine."Line No.";

            //Primera línea
            vLLineNo += 10000;
            GenJournalLine.Init();
            GenJournalLine.Validate("Journal Template Name", GeneralLedgerSetup."BBT Jnl. Templ. Name Amort.");
            GenJournalLine.Validate("Journal Batch Name", GeneralLedgerSetup."BBT Jnl. Batch Name Amort.");
            GenJournalLine.Validate("Line No.", vLLineNo);
            GenJournalLine.Validate("Posting Date", Today);
            GenJournalLine.Validate("Document Type", GenJournalLine."Document Type"::Payment);
            GenJournalLine.Validate(Description, StrSubstNo(LocalText000Lbl, Rec."BBT Fee No."));
            GenJournalLine.IncrementDocumentNo(GenJournalBatch, GenJournalLine."Document No.");
            GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::"Bank Account");
            GenJournalLine.Validate("Account No.", Rec."BBT Bank");
            GenJournalLine.Validate(Description, StrSubstNo(LocalText000Lbl, Rec."BBT Fee No."));
            GenJournalLine.Validate(Amount, Rec."BBT Interest");
            GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
            GenJournalLine.Validate("Bal. Account No.", Rec."BBT Interests Account");
            GenJournalLine."BBT Amortization Line" := true;
            GenJournalLine."BBT Loan No." := "BBT Loan No.";
            GenJournalLine."BBT Fee No." := "BBT Fee No.";
            GenJournalLine.Insert();

            //Segunda línea
            vLLineNo += 10000;
            GenJournalLine.Init();
            GenJournalLine.Validate("Journal Template Name", GeneralLedgerSetup."BBT Jnl. Templ. Name Amort.");
            GenJournalLine.Validate("Journal Batch Name", GeneralLedgerSetup."BBT Jnl. Batch Name Amort.");
            GenJournalLine.Validate("Line No.", vLLineNo);
            GenJournalLine.Validate("Posting Date", Today);
            GenJournalLine.Validate("Document Type", GenJournalLine."Document Type"::Payment);
            GenJournalLine.IncrementDocumentNo(GenJournalBatch, GenJournalLine."Document No.");
            GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::"Bank Account");
            GenJournalLine.Validate("Account No.", Rec."BBT Bank");
            GenJournalLine.Validate(Description, StrSubstNo(LocalText000Lbl, Rec."BBT Fee No."));
            GenJournalLine.Validate(Amount, Rec."BBT Amortization");
            GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
            GenJournalLine.Validate("Bal. Account No.", Rec."BBT Amortization Account");
            GenJournalLine."BBT Amortization Line" := true;
            GenJournalLine."BBT Loan No." := "BBT Loan No.";
            GenJournalLine."BBT Fee No." := "BBT Fee No.";
            GenJournalLine.Insert();
        end;*/
}
