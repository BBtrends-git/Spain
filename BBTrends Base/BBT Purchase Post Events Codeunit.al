codeunit 50034 "Purchase Post Events"
{
    SingleInstance = true;

    var
        DocumentNo: Code[20];

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Purch.-Post", 'OnAfterPurchInvHeaderInsert', '', false, false)]
    local procedure OnAfterPurchInvHeaderInsert(var PurchHeader: Record "Purchase Header"; var PurchInvHeader: Record "Purch. Inv. Header")
    var
        Location: Record Location;
    begin
        DocumentNo := PurchInvHeader."No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Purch.-Post", 'OnAfterPurchCrMemoHeaderInsert', '', false, false)]
    local procedure OnAfterPurchCrMemoHeaderInsert(var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var PurchHeader: Record "Purchase Header")
    var
        Location: Record Location;
    begin
        DocumentNo := PurchCrMemoHdr."No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Purch.-Post", 'OnAfterFinalizePosting', '', false, false)]
    local procedure OnAfterFinalizePosting(CommitIsSupressed: Boolean; var PurchHeader: Record "Purchase Header"; var PurchInvHeader: Record "Purch. Inv. Header")
    var
        Location: Record Location;
        PostingMsgTxt: label 'DOCUMENT NO. %1 HAVE BEEN POSTING';
    begin
        IF GUIALLOWED AND PurchHeader.Invoice THEN MESSAGE(PostingMsgTxt, DocumentNo);
    end;

    //>> V27
    /*
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Purch.-Post", 'OnBeforePostVendorEntry', '', false, false)]
    local procedure OnBeforePostVendorEntry(CommitIsSupressed: Boolean; var PurchHeader: Record "Purchase Header"; var GenJnlLine: Record "Gen. Journal Line")
    var
    begin
        //I. INC-2020-11-121340
        GenJnlLine."ID Type" := PurchHeader."ID Type";
        //F. INC-2020-11-121340
    end;
    */
    //<<

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Purch.-Get Receipt", 'OnAfterInsertInvoiceLineFromReceiptLine', '', false, false)]
    local procedure OnAfterInsertInvoiceLineFromReceiptLine(PurchRcptLine2: Record "Purch. Rcpt. Line"; TransferLine: Boolean; var PurchLine: Record "Purchase Line"; var PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        PurchaseLine: Record "Purchase Line";
        PurchReceiptHeader: Record "Purch. Rcpt. Header";
        PurchReceiptHeaderCode: Code[20];
        DateFlag: Date;
    begin
        DateFlag := 0D;
        //Buscamos la fecha mas actual del documento
        Clear(PurchaseLine);
        PurchaseLine.SetRange("Document No.", PurchLine."Document No.");
        PurchaseLine.SetRange("Document Type", PurchLine."Document Type");
        IF PurchaseLine.FindFirst() then begin
            repeat
                Clear(PurchReceiptHeader);
                IF PurchReceiptHeader.Get(PurchLine."Receipt No.") then begin
                    IF (PurchReceiptHeader."Posting Date" > DateFlag) OR (DateFlag = 0D) then begin
                        DateFlag := PurchReceiptHeader."Posting Date";
                        PurchReceiptHeaderCode := PurchReceiptHeader."No.";
                    end;
                end;
            until PurchaseLine.Next() = 0;
        end;
        //modificamos los costes en funcion al albaran mas reciente
        Clear(PurchaseLine);
        PurchaseLine.SetRange("Document No.", PurchLine."Document No.");
        PurchaseLine.SetRange("Document Type", PurchLine."Document Type");
        IF PurchaseLine.FindFirst() then begin
            repeat
                Clear(PurchReceiptHeader);
                IF PurchReceiptHeader.Get(PurchReceiptHeaderCode) then begin
                end;
            until PurchaseLine.Next() = 0;
        end;
    end;

    //>> BBT. 27/05/2026. Repregunta de eliminación de pedido de compra
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeOnDelete', '', false, false)]
    local procedure OnBeforeOnDelete(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
        ConfirmManagement: Codeunit "Confirm Management";
        SecondConfirmMsg: Label 'Are you absolutely sure you want to cancel this order? \\ *** THIS ACTION CANNOT BE UNDONE ***',
                        Comment = 'ESP="¿Está completamente seguro de que desea eliminar este pedido? \\ *** ESTA ACCIÓN NO SE PUEDE DESHACER ***"';
    begin
        if not GuiAllowed then
            exit;

        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
            if not ConfirmManagement.GetResponseOrDefault(SecondConfirmMsg, false) then
                Error('');
        end;
    end;
    //<<
}
