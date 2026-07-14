PageExtension 50147 "BBT Apply Customer Entries" extends "Apply Customer Entries"
{
    layout
    {
        addafter(AppliesToID)
        {
            field("Doc. Relation"; Rec."Doc. Relation")
            {
                ApplicationArea = Basic;
            }
            field("Entry No."; Rec."Entry No.")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }
    actions
    {
        addafter("Show Only Selected Entries to Be Applied")
        {
            action("Import CSV Settlement")
            {
                Caption = 'Import CSV Settlement', comment = 'ESP="Importar CSV liquidación"';
                ApplicationArea = All;
                Image = ImportExcel;

                trigger OnAction()
                var
                    CSVInStream: InStream;
                    CSVFileName: Text;
                    CSVBuffer: Record "CSV Buffer" temporary;
                    SalesInvHeader: Record "Sales Invoice Header";
                    CarteraDoc: Record "Cartera Doc.";
                    CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer" temporary;
                    CustLedgerEntry: Record "Cust. Ledger Entry";
                    CustEntrySetApplID: Codeunit "Cust. Entry-SetAppl.ID";
                    vLTotalAmountToApply: Decimal;
                    LocalText000Lbl: Label 'Import CSV', comment = 'ESP="Importar CSV"';
                    LocalText001Lbl: Label ';', comment = 'ESP=";"';
                    LocalText002Lbl: Label 'Invoice %1 does not exist', comment = 'ESP="No existe la factura %1"';
                    LocalText003Lbl: Label 'The amount indicated on line %1 is greater than the amount on invoice %2', comment = 'ESP="El importe indicado en la línea %1 es mayor que el importe de la factura %2"';
                    LocalText004Lbl: Label 'The process will import a CSV and the detected records will be marked for settlement. Do you wish to continue?', comment = 'ESP="El proceso importará un CSV y se marcarán los registros detectados para su liquidación. ¿Desea continuar?"';
                    LocalText005Lbl: Label 'Process cancelled', comment = 'ESP="Proceso cancelado"';
                    LocalText006Lbl: Label 'Process completed', comment = 'ESP="Proceso completado"';
                    LocalText007Lbl: Label 'The entry no. was not found in Customer Ledger Entry', comment = 'ESP="El número de movimiento de cliente no ha sido encontrado."';
                begin
                    if Confirm(LocalText004Lbl, true) then begin
                        UploadIntoStream(LocalText000Lbl, '', '', CSVFileName, CSVInStream);
                        if CSVBuffer.IsTemporary then begin
                            CSVBuffer.DeleteAll;
                            CSVBuffer.LoadDataFromStream(CSVInStream, LocalText001Lbl);
                            if CSVBuffer.FindSet() then
                                repeat //Línea 1 -> Cabecera
                                    if CSVBuffer."Line No." <> 1 then begin
                                        CSVBuffer.TestField(Value);
                                        case CSVBuffer."Field No." of
                                            1:
                                                begin
                                                    Clear(SalesInvHeader);
                                                    if not SalesInvHeader.Get(CSVBuffer.Value) then begin
                                                        //Buscamos el documento en cartera
                                                        CarteraDoc.Reset();
                                                        CarteraDoc.SetRange(Type, CarteraDoc.Type::Receivable);
                                                        CarteraDoc.SetRange("Document No.");
                                                        CarteraDoc.SetFilter("Bill Gr./Pmt. Order No.", '%1', '');
                                                        if not CarteraDoc.FindFirst() then;
                                                        //Error(LocalText002Lbl, CSVBuffer.Value);
                                                    end;
                                                    CVLedgerEntryBuffer.Init();
                                                    CVLedgerEntryBuffer."Entry No." := CSVBuffer."Line No.";
                                                    CVLedgerEntryBuffer.Insert();
                                                    CVLedgerEntryBuffer."Document No." := CSVBuffer.Value;
                                                    CVLedgerEntryBuffer.Modify();
                                                end;
                                            2:
                                                begin
                                                    Evaluate(CVLedgerEntryBuffer.Amount, CSVBuffer.Value);
                                                    if SalesInvHeader."No." <> '' then begin
                                                        SalesInvHeader.CalcFields("Amount Including VAT");
                                                        if CVLedgerEntryBuffer.Amount > SalesInvHeader."Amount Including VAT" then;
                                                        //  Error(LocalText003Lbl, CVLedgerEntryBuffer.Amount, CVLedgerEntryBuffer."Document No.");
                                                    end
                                                    else begin
                                                        if CVLedgerEntryBuffer.Amount > CarteraDoc."Remaining Amount" then;
                                                        // Error(LocalText003Lbl, CVLedgerEntryBuffer.Amount, CVLedgerEntryBuffer."Document No.");
                                                    end;
                                                    CVLedgerEntryBuffer.Modify();
                                                end;
                                            3:
                                                begin
                                                    Clear(CustLedgerEntry);
                                                    IF not CustLedgerEntry.get(CSVBuffer.Value) then Error(LocalText007Lbl);
                                                    evaluate(CVLedgerEntryBuffer."Transaction No.", CSVBuffer.Value);
                                                    CVLedgerEntryBuffer.Modify();
                                                end;
                                        end;
                                    end;
                                until CSVBuffer.Next() = 0;
                            CVLedgerEntryBuffer.Reset();
                            if CVLedgerEntryBuffer.FindSet() then
                                repeat
                                    CustLedgerEntry.Reset();
                                    CustLedgerEntry.SetRange("Customer No.", Rec."Customer No.");
                                    // CustLedgerEntry.SetFilter("Document Type", '%1|%2', CustLedgerEntry."Document Type"::Invoice, CustLedgerEntry."Document Type"::Bill);
                                    CustLedgerEntry.SetRange("Document No.", CVLedgerEntryBuffer."Document No.");
                                    IF CVLedgerEntryBuffer."Transaction No." <> 0 then CustLedgerEntry.SetRange("Entry No.", CVLedgerEntryBuffer."Transaction No."); //usamos este campo para guardar el entryno que nos pasan en el excel
                                    CustLedgerEntry.SetRange(Open, true);
                                    CustLedgerEntry.SetRange("Remaining Amount", CVLedgerEntryBuffer.Amount);
                                    if CustLedgerEntry.FindFirst() then begin
                                        CustLedgerEntry.Copy(CustLedgerEntry);
                                        CustLedgerEntry."BBT Settlement From CSV" := true;
                                        CustLedgerEntry."BBT Amount To Apply From CSV" := -CVLedgerEntryBuffer.Amount;
                                        CustLedgerEntry.Modify();
                                        CustEntrySetApplID.SetApplId(CustLedgerEntry, TempApplyingCustLedgEntry, GenJnlLine2."Applies-to ID");
                                        CalcApplnAmount();
                                        vLTotalAmountToApply += -CVLedgerEntryBuffer.Amount;
                                    end;
                                until CVLedgerEntryBuffer.Next() = 0;
                            AppliedAmount := -vLTotalAmountToApply;
                            CurrPage.Update(true);
                            Message(LocalText006Lbl);
                        end;
                    end
                    else
                        Error(LocalText005Lbl);
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref("Import CSV Settlement_Promoted"; "Import CSV Settlement")
            {
            }
        }
    }
    //Unsupported feature: Code Modification on "HandlChosenEntries(PROCEDURE 14)".
    //procedure HandlChosenEntries();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
        IF AppliedCustLedgEntry.FINDSET(FALSE,FALSE) THEN BEGIN
          REPEAT
            AppliedCustLedgEntryTemp := AppliedCustLedgEntry;
        #4..47
                    CurrentAmount := CurrentAmount +
                      AppliedCustLedgEntryTemp."Remaining Amount" - AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
                  END ELSE BEGIN
                    IF (CurrentAmount + AppliedCustLedgEntryTemp."Remaining Amount" >= 0) <> (CurrentAmount >= 0) THEN BEGIN
                      PmtDiscAmount := PmtDiscAmount + PossiblePmtDisc;
                      AppliedAmount := AppliedAmount + CorrectionAmount;
                    END;
                    CurrentAmount := CurrentAmount + AppliedCustLedgEntryTemp."Remaining Amount" -
                      AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
                    PossiblePmtDisc := AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
                  END;
            END ELSE BEGIN
              IF ((CurrentAmount - PossiblePmtDisc + AppliedCustLedgEntryTemp."Amount to Apply") * CurrentAmount) <= 0 THEN BEGIN
        #61..88
          AppliedCustLedgEntryTemp.SETRANGE(Positive);

        UNTIL NOT AppliedCustLedgEntryTemp.FINDFIRST;
        PmtDiscAmount += PossiblePmtDisc;
        CheckRounding;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
        #1..50
                    PossiblePmtDisc := AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
        #51..56
        #58..91
        CheckRounding;
        */
    //end;
}
