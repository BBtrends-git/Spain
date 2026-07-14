codeunit 50027 "BBT Document Mailing"
{
    //>> BBT 11/03/2026. Fix Compatibility With Extension 28.0
    //   Los attachment pasan a obsoletos para evitar rutas de archivos directas.
    //   TempEmailItem."Attachment File Path" := AttachmentFilePath;
    //   TempEmailItem."Attachment Name" := AttachmentFileName;
    /*
    PROCEDURE EmailFileFromPurchHeader(PurchHeader: Record "Purchase Header"; AttachmentFilePath: Text[250]; CustomReportSelection: Record "Custom Report Selection")
    BEGIN
        EmailFilePurch(AttachmentFilePath, '', PurchHeader."No.", PurchHeader."Buy-from Vendor No.", FORMAT(PurchHeader."Document Type"), FALSE, CustomReportSelection);
    END;

    PROCEDURE EmailFilePurch(AttachmentFilePath: Text[250]; AttachmentFileName: Text[250]; PostedDocNo: Code[20]; SendEmaillToCustNo: Code[20]; EmailDocName: Text[150]; HideDialog: Boolean; CustomReportSelection: Record "Custom Report Selection");
    VAR
        TempEmailItem: Record "Email Item" temporary;
        CompanyInformation: Record "Company Information";
    BEGIN
        IF AttachmentFileName = '' THEN AttachmentFileName := STRSUBSTNO(ReportAsPdfFileNameMsgPurch, EmailDocName, PostedDocNo);
        CompanyInformation.GET;
        IF CustomReportSelection."Send To Email" <> '' THEN
            TempEmailItem."Send to" := CustomReportSelection."Send To Email"
        ELSE
            TempEmailItem."Send to" := GetToAddressFromVendor(SendEmaillToCustNo);
        TempEmailItem.Subject := COPYSTR(STRSUBSTNO(EmailSubjectCapTxt, CompanyInformation.Name, EmailDocName, PostedDocNo), 1, MAXSTRLEN(TempEmailItem.Subject));
        TempEmailItem."Attachment File Path" := AttachmentFilePath;
        TempEmailItem."Attachment Name" := AttachmentFileName;
        //TempEmailItem.Send(HideDialog); 
    END;

    LOCAL PROCEDURE GetToAddressFromVendor(PurchToVendorNo: Code[20]): Text[250];
    VAR
        Vendor: Record Vendor;
        ToAddress: Text;
    BEGIN
        IF Vendor.GET(PurchToVendorNo) THEN ToAddress := Vendor."E-Mail";
        EXIT(ToAddress);
    END;

    var
        DocumentMailing: Codeunit "Document-Mailing";
        ReportAsPdfFileNameMsgPurch: Label 'Sales %1 %2.pdf';
        EmailSubjectCapTxt: Label '%1 - %2 %3';
    */
    //<<
}
