TableExtension 50119 "BBT Gen. Journal Line" extends "Gen. Journal Line"
{
    fields
    {
        field(50000; Deduction; Boolean)
        {
            Caption = 'Deduction';
            Description = '001';
        }
        field(50001; "BBT Amortization Line"; Boolean)
        {
            Caption = 'Amortization Line', comment = 'ESP="Línea amortización"';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50002; "BBT Loan No."; Code[20])
        {
            Caption = 'Loan No.', comment = 'ESP="Nº préstamo"';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50003; "BBT Fee No."; Integer)
        {
            Caption = 'Fee No.', comment = 'ESP="Nº cuota"';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50004; "BBT Loan Reclassification Line"; Boolean)
        {
            Caption = 'Loan Reclasification Line', comment = 'ESP="Línea reclasificación prestamo"';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50005; "BBT Bank No."; Code[20])
        {
            Caption = 'Bank No.', comment = 'ESP="Nº banco"';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50006; "BBT Reclassification Exercise"; Integer)
        {
            Caption = 'Reclassification Exercise', comment = 'ESP="Ejercicio reclasificación"';
            Editable = false;
            DataClassification = ToBeClassified;
        }
    }
    //>> SII NAVision
    /*
    local procedure ClearInvCrMemoTypeFields()
    begin
        //I-INC-2018-04-91435: SII MICROSOFT ABRIL
        Rec."Sales Invoice Type" := Enum::"SII Sales Invoice Type".FromInteger(0);
        Rec."Sales Cr. Memo Type" := Enum::"SII Sales Credit Memo Type".FromInteger(0);
        Rec."Sales Special Scheme Code" := Enum::"SII Sales Special Scheme Code".FromInteger(0);
        Rec."Purch. Invoice Type" := Enum::"SII Purch. Invoice Type".FromInteger(0);
        Rec."Purch. Cr. Memo Type" := Enum::"SII Purch. Credit Memo Type".FromInteger(0);
        Rec."Purch. Special Scheme Code" := Enum::"SII Purch. Special Scheme Code".FromInteger(0);
        Rec."Correction Type" := 0;
        Rec."Corrected Invoice No." := '';
        //F-INC-2018-04-91435: SII MICROSOFT ABRIL
    end;

    local procedure InitGenJnlLineBufferWithCustVend(var TempGenJournalLine: Record "Gen. Journal Line" temporary)
    begin
        //I-INC-2018-04-91435: SII MICROSOFT ABRIL
        TempGenJournalLine.Init;
        case true of
            Rec."Account Type" in [Rec."account type"::Customer, Rec."account type"::Vendor]:
                begin
                    TempGenJournalLine."Account Type" := Rec."Account Type";
                    TempGenJournalLine."Account No." := Rec."Account No.";
                end;
            Rec."Bal. Account Type" in [Rec."bal. account type"::Customer, Rec."bal. account type"::Vendor]:
                begin
                    TempGenJournalLine."Account Type" := Rec."Bal. Account Type";
                    TempGenJournalLine."Account No." := Rec."Bal. Account No.";
                end;
        end;
        //F-INC-2018-04-91435: SII MICROSOFT ABRIL
    end;

    local procedure CheckAccAndBalAccType(AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner")
    begin
        //I-INC-2018-04-91435: SII MICROSOFT ABRIL
        if (Rec."Account Type".AsInteger() <> AccType) and (Rec."Bal. Account Type".AsInteger() <> AccType) then Error(IncorrectAccTypeErr, Rec.FieldCaption(Rec."Account Type"), Rec.FieldCaption(Rec."Bal. Account Type"), Format(AccType));
        //F-INC-2018-04-91435: SII MICROSOFT ABRIL
    end;

    local procedure CheckDataForCorrection()
    begin
        //I-INC-2018-04-91435: SII MICROSOFT ABRIL
        Rec.TestField(Rec."Document Type", Rec."document type"::"Credit Memo");
        if not ((Rec."Account Type" in [Rec."account type"::Customer, Rec."account type"::Vendor]) or (Rec."Bal. Account Type" in [Rec."bal. account type"::Customer, Rec."bal. account type"::Vendor])) then Error(IncorrectAccTypeErr, Rec.FieldCaption(Rec."Account Type"), Rec.FieldCaption(Rec."Bal. Account Type"), StrSubstNo(OneOrAnotherTok, Format(Rec."account type"::Customer), Format(Rec."account type"::Vendor)));
        //F-INC-2018-04-91435: SII MICROSOFT ABRIL
    end;

    var
        AccTypeNotSupportedErr: label 'You cannot specify a deferral code for this type of account.';
        IncorrectAccTypeErr: label '%1 or %2 must be a %3.', Comment = '%1=Account Type,%2=Balance Account Type,%3=Customer or Vendor';
        OneOrAnotherTok: label '%1 or %2', Comment = 'Customer or Vendor';
    */
    //<<
}
