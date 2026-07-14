codeunit 50028 "Document Edit Events"
{
    Permissions =
        tableData "Cust. Ledger Entry" = rm,
        tabledata "Vendor Ledger Entry" = rm,
        tabledata "Vat Entry" = rm;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Edit", 'OnBeforeModifyCarteraDoc', '', false, false)]
    local procedure OnBeforeModifyCarteraDoc(CurrCarteraDoc: Record "Cartera Doc."; var CarteraDoc: Record "Cartera Doc.")
    begin
        CurrCarteraDoc."Cust./Vendor Bank Acc. Code" := CarteraDoc."Cust./Vendor Bank Acc. Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Shipment Header - Edit", 'OnBeforeSalesShptHeaderModify', '', false, false)]
    local procedure OnBeforeSalesShptHeaderModify(FromSalesShptHeader: Record "Sales Shipment Header"; var SalesShptHeader: Record "Sales Shipment Header")
    begin
        SalesShptHeader.Reference := FromSalesShptHeader.Reference;
        SalesShptHeader."Total Volume (Actual)" := FromSalesShptHeader."Total Volume (Actual)";
        SalesShptHeader."Total Net Weight (Actual)" := FromSalesShptHeader."Total Net Weight (Actual)";
        SalesShptHeader."Total Gross Weight (Actual)" := FromSalesShptHeader."Total Gross Weight (Actual)";
        SalesShptHeader."Number of Packages" := FromSalesShptHeader."Number of Packages";
        SalesShptHeader."Requested Delivery Date" := FromSalesShptHeader."Requested Delivery Date";
        SalesShptHeader."External Document No." := FromSalesShptHeader."External Document No.";
        SalesShptHeader."Sell-to Phone No." := FromSalesShptHeader."Sell-to Phone No.";
        SalesShptHeader."Sell-to E-Mail" := FromSalesShptHeader."Sell-to E-Mail";
        SalesShptHeader."Ship-to Name" := FromSalesShptHeader."Ship-to Name";
    end;
    /* Modificación de campos de la pagina Posted Sales Shipment - Update */
    [EventSubscriber(ObjectType::page, Page::"Posted Sales Shipment - Update", 'OnAfterRecordChanged', '', false, false)]
    local procedure OnAfterRecordChanged(var IsChanged: Boolean; var SalesShipmentHeader: Record "Sales Shipment Header"; xSalesShipmentHeader: Record "Sales Shipment Header")
    begin
        IsChanged := (SalesShipmentHeader."Shipping Agent Code" <> xSalesShipmentHeader."Shipping Agent Code")
                    or (SalesShipmentHeader."Package Tracking No." <> xSalesShipmentHeader."Package Tracking No.")
                    or (SalesShipmentHeader."Shipping Agent Service Code" <> xSalesShipmentHeader."Shipping Agent Service Code")
                    or (SalesShipmentHeader."Total Volume (Actual)" <> xSalesShipmentHeader."Total Volume (Actual)")
                    or (SalesShipmentHeader."Total Net Weight (Actual)" <> xSalesShipmentHeader."Total Net Weight (Actual)")
                    or (SalesShipmentHeader."Total Gross Weight (Actual)" <> xSalesShipmentHeader."Total Gross Weight (Actual)")
                    or (SalesShipmentHeader.Reference <> xSalesShipmentHeader.Reference)
                    or (SalesShipmentHeader."Number of Packages" <> xSalesShipmentHeader."Number of Packages")
                    or (SalesShipmentHeader."Requested Delivery Date" <> xSalesShipmentHeader."Requested Delivery Date")
                    or (SalesShipmentHeader."External Document No." <> xSalesShipmentHeader."External Document No.")
                    or (SalesShipmentHeader."Sell-to Phone No." <> xSalesShipmentHeader."Sell-to Phone No.")
                    or (SalesShipmentHeader."Sell-to E-Mail" <> xSalesShipmentHeader."Sell-to E-Mail")
                    or (SalesShipmentHeader."Ship-to Name" <> xSalesShipmentHeader."Ship-to Name");
    end;
    /* Modificación de campos de la pagina 'Posted Sales Invoice - Update' */
    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Invoice - Update", 'OnAfterRecordIsChanged', '', true, true)]
    local procedure "Posted Sales Invoice - Update_OnAfterRecordIsChanged"(var SalesInvoiceHeader: Record "Sales Invoice Header"; xSalesInvoiceHeader: Record "Sales Invoice Header"; var RecordIsChanged: Boolean)
    begin
        RecordIsChanged := (SalesInvoiceHeader."Operation Description" <> xSalesInvoiceHeader."Operation Description")
                        or (SalesInvoiceHeader."Operation Description 2" <> xSalesInvoiceHeader."Operation Description 2")
                        or (SalesInvoiceHeader."Special Scheme Code" <> xSalesInvoiceHeader."Special Scheme Code")
                        or (SalesInvoiceHeader."Invoice Type" <> xSalesInvoiceHeader."Invoice Type")
                        or (SalesInvoiceHeader."ID Type" <> xSalesInvoiceHeader."ID Type")
                        or (SalesInvoiceHeader."Succeeded Company Name" <> xSalesInvoiceHeader."Succeeded Company Name")
                        or (SalesInvoiceHeader."Succeeded VAT Registration No." <> xSalesInvoiceHeader."Succeeded VAT Registration No.")
                        or (SalesInvoiceHeader."Issued By Third Party" <> xSalesInvoiceHeader."Issued By Third Party")
                        or (SalesInvoiceHeader.GetSIIFirstSummaryDocNo() <> xSalesInvoiceHeader.GetSIIFirstSummaryDocNo())
                        or (SalesInvoiceHeader.GetSIILastSummaryDocNo() <> xSalesInvoiceHeader.GetSIILastSummaryDocNo())
                        or (SalesInvoiceHeader."Do Not Send To SII" <> xSalesInvoiceHeader."Do Not Send To SII")
                        or (SalesInvoiceHeader."Shipment Method Code" <> xSalesInvoiceHeader."Shipment Method Code")
                        or (SalesInvoiceHeader."Package Tracking No." <> xSalesInvoiceHeader."Package Tracking No.");
    end;

    [EventSubscriber(ObjectType::Page, Page::"Pstd. Sales Cr. Memo - Update", 'OnAfterRecordChanged', '', true, true)]
    local procedure "Pstd. Sales Cr. Memo - Update_OnAfterRecordChanged"(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; xSalesCrMemoHeader: Record "Sales Cr.Memo Header"; var IsChanged: Boolean)
    begin
        IsChanged := (SalesCrMemoHeader."Shipping Agent Code" <> xSalesCrMemoHeader."Shipping Agent Code") or (SalesCrMemoHeader."Shipping Agent Service Code" <> xSalesCrMemoHeader."Shipping Agent Service Code") or (SalesCrMemoHeader."Package Tracking No." <> xSalesCrMemoHeader."Package Tracking No.") or (SalesCrMemoHeader."Operation Description" <> xSalesCrMemoHeader."Operation Description") or (SalesCrMemoHeader."Operation Description 2" <> xSalesCrMemoHeader."Operation Description 2") or (SalesCrMemoHeader."Special Scheme Code" <> xSalesCrMemoHeader."Special Scheme Code") or (SalesCrMemoHeader."Cr. Memo Type" <> xSalesCrMemoHeader."Cr. Memo Type") or (SalesCrMemoHeader."Corrected Invoice No." <> xSalesCrMemoHeader."Corrected Invoice No.") or (SalesCrMemoHeader."Correction Type" <> xSalesCrMemoHeader."Correction Type") or (SalesCrMemoHeader."ID Type" <> xSalesCrMemoHeader."ID Type") or (SalesCrMemoHeader."Succeeded Company Name" <> xSalesCrMemoHeader."Succeeded Company Name") or (SalesCrMemoHeader."Succeeded VAT Registration No." <> xSalesCrMemoHeader."Succeeded VAT Registration No.") or (SalesCrMemoHeader."Company Bank Account Code" <> xSalesCrMemoHeader."Company Bank Account Code") or (SalesCrMemoHeader.GetSIIFirstSummaryDocNo() <> xSalesCrMemoHeader.GetSIIFirstSummaryDocNo()) or (SalesCrMemoHeader.GetSIILastSummaryDocNo() <> xSalesCrMemoHeader.GetSIILastSummaryDocNo()) or (SalesCrMemoHeader."Do Not Send To SII" <> xSalesCrMemoHeader."Do Not Send To SII");
    end;

    [EventSubscriber(ObjectType::Page, Page::"Posted Purch. Invoice - Update", 'OnAfterRecordChanged', '', true, true)]
    local procedure "Posted Purch. Invoice - Update_OnAfterRecordChanged"(var PurchInvHeader: Record "Purch. Inv. Header"; xPurchInvHeader: Record "Purch. Inv. Header"; var IsChanged: Boolean; xPurchInvHeaderGlobal: Record "Purch. Inv. Header")
    begin
        IsChanged := (PurchInvHeader."Payment Reference" <> xPurchInvHeaderGlobal."Payment Reference") or (PurchInvHeader."Payment Method Code" <> xPurchInvHeaderGlobal."Payment Method Code") or (PurchInvHeader."Creditor No." <> xPurchInvHeaderGlobal."Creditor No.") or (PurchInvHeader."Ship-to Code" <> xPurchInvHeaderGlobal."Ship-to Code") or (PurchInvHeader."Operation Description" <> xPurchInvHeaderGlobal."Operation Description") or (PurchInvHeader."Operation Description 2" <> xPurchInvHeaderGlobal."Operation Description 2") or (PurchInvHeader."Special Scheme Code" <> xPurchInvHeaderGlobal."Special Scheme Code") or (PurchInvHeader."Invoice Type" <> xPurchInvHeaderGlobal."Invoice Type") or (PurchInvHeader."ID Type" <> xPurchInvHeaderGlobal."ID Type") or (PurchInvHeader."Succeeded Company Name" <> xPurchInvHeaderGlobal."Succeeded Company Name") or (PurchInvHeader."Succeeded VAT Registration No." <> xPurchInvHeaderGlobal."Succeeded VAT Registration No.") or (PurchInvHeader."Do Not Send To SII" <> xPurchInvHeaderGlobal."Do Not Send To SII");
    end;

    [EventSubscriber(ObjectType::Page, Page::"Posted Purch. Cr.Memo - Update", 'OnAfterRecordChanged', '', true, true)]
    local procedure "Posted Purch. Cr.Memo - Update_OnAfterRecordChanged"(var PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr."; xPurchCrMemoHeader: Record "Purch. Cr. Memo Hdr."; var IsChanged: Boolean)
    begin
        IsChanged := (PurchCrMemoHeader."Operation Description" <> xPurchCrMemoHeader."Operation Description") or (PurchCrMemoHeader."Operation Description 2" <> xPurchCrMemoHeader."Operation Description 2") or (PurchCrMemoHeader."Special Scheme Code" <> xPurchCrMemoHeader."Special Scheme Code") or (PurchCrMemoHeader."Cr. Memo Type" <> xPurchCrMemoHeader."Cr. Memo Type") or (PurchCrMemoHeader."Corrected Invoice No." <> xPurchCrMemoHeader."Corrected Invoice No.") or (PurchCrMemoHeader."Correction Type" <> xPurchCrMemoHeader."Correction Type") or (PurchCrMemoHeader."ID Type" <> xPurchCrMemoHeader."ID Type") or (PurchCrMemoHeader."Succeeded Company Name" <> xPurchCrMemoHeader."Succeeded Company Name") or (PurchCrMemoHeader."Succeeded VAT Registration No." <> xPurchCrMemoHeader."Succeeded VAT Registration No.") or (PurchCrMemoHeader."Do Not Send To SII" <> xPurchCrMemoHeader."Do Not Send To SII");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Invoice Header - Edit", 'OnRunOnBeforeSalesInvoiceHeaderModify', '', true, true)]
    local procedure "Sales Invoice Header - Edit_OnRunOnBeforeSalesInvoiceHeaderModify"(var SalesInvoiceHeader: Record "Sales Invoice Header"; FromSalesInvoiceHeader: Record "Sales Invoice Header")
    var
        VATEntry: Record "VAT Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        SalesInvoiceHeader."Shipment Method Code" := FromSalesInvoiceHeader."Shipment Method Code";
        SalesInvoiceHeader."Package Tracking No." := FromSalesInvoiceHeader."Package Tracking No.";

        SalesInvoiceHeader."Do Not Send To SII" := FromSalesInvoiceHeader."Do Not Send To SII";
        RelatedEntries_DoNotSendToSII(Database::"Sales Invoice Header", SalesInvoiceHeader."No.", SalesInvoiceHeader."Posting Date", FromSalesInvoiceHeader."Do Not Send To SII");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Credit Memo Hdr. - Edit", 'OnBeforeSalesCrMemoHeaderModify', '', true, true)]
    local procedure "Sales Credit Memo Hdr. - Edit_OnBeforeSalesCrMemoHeaderModify"(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; FromSalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        VATEntry: Record "VAT Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        SalesCrMemoHeader."Do Not Send To SII" := FromSalesCrMemoHeader."Do Not Send To SII";
        RelatedEntries_DoNotSendToSII(Database::"Sales Cr.Memo Header", SalesCrMemoHeader."No.", SalesCrMemoHeader."Posting Date", FromSalesCrMemoHeader."Do Not Send To SII");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Inv. Header - Edit", 'OnBeforePurchInvHeaderModify', '', true, true)]
    local procedure "Purch. Inv. Header - Edit_OnBeforePurchInvHeaderModify"(var PurchInvHeader: Record "Purch. Inv. Header"; PurchInvHeaderRec: Record "Purch. Inv. Header")
    var
        VATEntry: Record "VAT Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        PurchInvHeader."Do Not Send To SII" := PurchInvHeaderRec."Do Not Send To SII";
        RelatedEntries_DoNotSendToSII(Database::"Purch. Inv. Header", PurchInvHeader."No.", PurchInvHeader."Posting Date", PurchInvHeaderRec."Do Not Send To SII");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Cr. Memo Hdr. - Edit", 'OnRunOnBeforeTestFieldNo', '', true, true)]
    local procedure "Purch. Cr. Memo Hdr. - Edit_OnRunOnBeforeTestFieldNo"(var PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr."; PurchCrMemoHeaderRec: Record "Purch. Cr. Memo Hdr.")
    var
        VATEntry: Record "VAT Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        PurchCrMemoHeader."Do Not Send To SII" := PurchCrMemoHeaderRec."Do Not Send To SII";
        RelatedEntries_DoNotSendToSII(Database::"Purch. Inv. Header", PurchCrMemoHeader."No.", PurchCrMemoHeader."Posting Date", PurchCrMemoHeaderRec."Do Not Send To SII");
    end;

    local procedure RelatedEntries_DoNotSendToSII(TableNo: Integer; DocumentNo: Code[20]; PostingDate: Date; DoNotSendToSII: Boolean)
    var
        VATEntry: Record "VAT Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        case TableNo of
            Database::"Purch. Inv. Header", Database::"Purch. Cr. Memo Hdr.":
                begin
                    //-ITK 230615 DRM - Modificamos el valor del campo "Do Not Send To SII"
                    VATEntry.Reset();
                    VATEntry.SetRange("Document No.", DocumentNo);
                    VATEntry.SetRange("Posting Date", PostingDate);
                    if VATEntry.FindFirst() then VATEntry.ModifyAll("Do Not Send To SII", DoNotSendToSII, false);
                    VendorLedgerEntry.Reset();
                    VendorLedgerEntry.SetRange("Document No.", DocumentNo);
                    VendorLedgerEntry.SetRange("Posting Date", PostingDate);
                    if VendorLedgerEntry.FindFirst() then VendorLedgerEntry.ModifyAll("Do Not Send To SII", DoNotSendToSII, false);
                    //+ITK 230615 DRM - Modificamos el valor del campo "Do Not Send To SII"
                end;
            Database::"Sales Invoice Header", Database::"Sales Cr.Memo Header":
                begin
                    //-ITK 230615 DRM - Modificamos el valor del campo "Do Not Send To SII"
                    VATEntry.Reset();
                    VATEntry.SetRange("Document No.", DocumentNo);
                    VATEntry.SetRange("Posting Date", PostingDate);
                    if VATEntry.FindFirst() then VATEntry.ModifyAll("Do Not Send To SII", DoNotSendToSII, false);
                    CustLedgerEntry.Reset();
                    CustLedgerEntry.SetRange("Document No.", DocumentNo);
                    CustLedgerEntry.SetRange("Posting Date", PostingDate);
                    if CustLedgerEntry.FindFirst() then CustLedgerEntry.ModifyAll("Do Not Send To SII", DoNotSendToSII, false);
                    //+ITK 230615 DRM - Modificamos el valor del campo "Do Not Send To SII"
                end;
        end;
    end;
    //>> BBT 19/06/2025 Suscripcion al evento de lanzamiento del documento de ventas 
    //                  Comprobación de que está informado el código de auditoria / transportista
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeReleaseSalesDoc', '', true, true)]
    local procedure BBTOnBeforeReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean; var SkipCheckReleaseRestrictions: Boolean; SkipWhseRequestOperations: Boolean)
    var
        Error01: Label '%1: Insert the reason code', Comment = 'ESP="%1: Informe el código de auditoría"';
        Error02: Label '%1: Insert the shipping agent code', Comment = 'ESP="%1: Informe el código del transportista"';
    begin
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order") or
            (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") then
            if SalesHeader."Reason Code" = '' then
                Error(Error01, Salesheader."No.");
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order") then
            if SalesHeader."Shipping Agent Code" = '' then
                Error(Error02, Salesheader."No.");
    end;
    //<<
    //>> BBT 19/06/2025 Suscripcion al evento de registro del documento de ventas 
    //                  Comprobación de que está informado el código de auditoria / transportista
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforePostSalesDoc, '', true, true)]
    local procedure BBTOnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean; var IsHandled: Boolean; var CalledBy: Integer)
    var
        Error01: Label '%1: Insert the reason code', Comment = 'ESP="%1: Informe el código de auditoría"';
        Error02: Label '%1: Insert the shipping agent code', Comment = 'ESP="%1: Informe el código del transportista"';
    begin
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order") or
            (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") then
            if SalesHeader."Reason Code" = '' then
                Error(Error01, Salesheader."No.");
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order") then
            if SalesHeader."Shipping Agent Code" = '' then
                Error(Error02, Salesheader."No.");
    end;
    //<<
}
