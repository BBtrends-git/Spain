Report 50062 "BBT Purchase - Receipt"
//fin - The application object identifier '408' is not valid. It must be within the allowed ranges '[50000..90500]'.
//    - An application object of type 'Report' with name 'Purchase - Receipt' is already declared by the extension 'Base Application by Microsoft (18.0.23013.23795)'
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/Purchase - Receipt.rdl';
    Caption = 'Purchase - Receipt', comment = 'ESP="Compras - Albarán"';
    PreviewMode = PrintLayout;
    UsageCategory = Documents;

    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Buy-from Vendor No.", "No. Printed";
            RequestFilterHeading = 'Posted Purchase Receipt', comment = 'ESP="=Histórico albaranes compra"';

            column(ReportForNavId_2822; 2822)
            { }
            column(No_PurchRcptHeader; "Purch. Rcpt. Header"."No.")
            { }
            column(DocDateCaption; DocDateCaptionLbl)
            { }
            column(PageCaption; PageCaptionLbl)
            { }
            column(DescCaption; DescCaptionLbl)
            { }
            column(QtyCaption; QtyCaptionLbl)
            { }
            column(UOMCaption; UOMCaptionLbl)
            { }
            column(PaytoVenNoCaption; PaytoVenNoCaptionLbl)
            { }
            column(EmailCaption; EmailCaptionLbl)
            { }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = sorting(Number);

                column(ReportForNavId_5701; 5701)
                { }
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));

                    column(ReportForNavId_6455; 6455)
                    { }
                    column(PurchRcptCopyText; StrSubstNo(Text002, CopyText))
                    { }
                    // column(CurrentReportPageNo; StrSubstNo(Text003, Format(CurrReport.PageNo)))
                    // { }
                    column(ShipToAddr1; ShipToAddr[1])
                    { }
                    column(CompanyAddr1; CompanyAddr[1])
                    { }
                    column(ShipToAddr2; ShipToAddr[2])
                    { }
                    column(CompanyAddr2; CompanyAddr[2])
                    { }
                    column(ShipToAddr3; ShipToAddr[3])
                    { }
                    column(CompanyAddr3; CompanyAddr[3])
                    { }
                    column(ShipToAddr4; ShipToAddr[4])
                    { }
                    column(CompanyAddr4; CompanyAddr[4])
                    { }
                    column(ShipToAddr5; ShipToAddr[5])
                    { }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    { }
                    column(ShipToAddr6; ShipToAddr[6])
                    { }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    { }
                    column(CompanyInfoEmail; CompanyInfo."E-Mail")
                    { }
                    column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                    { }
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    { }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    { }
                    column(CompanyInfoBankAccNo; CompanyInfo."Bank Account No.")
                    { }
                    column(DocDate_PurchRcptHeader; Format("Purch. Rcpt. Header"."Document Date", 0, 4))
                    { }
                    column(PurchaserText; PurchaserText)
                    { }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    { }
                    column(No1_PurchRcptHeader; "Purch. Rcpt. Header"."No.")
                    { }
                    column(ReferenceText; ReferenceText)
                    { }
                    column(YourRef_PurchRcptHeader; "Purch. Rcpt. Header"."Your Reference")
                    { }
                    column(ShipToAddr7; ShipToAddr[7])
                    { }
                    column(ShipToAddr8; ShipToAddr[8])
                    { }
                    column(CompanyAddr5; CompanyAddr[5])
                    { }
                    column(CompanyAddr6; CompanyAddr[6])
                    { }
                    column(OutputNo; OutputNo)
                    { }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    { }
                    column(HomePageCaption; HomePageCaptionLbl)
                    { }
                    column(VATRegNoCaption; VATRegNoCaptionLbl)
                    { }
                    column(GiroNoCaption; GiroNoCaptionLbl)
                    { }
                    column(BankNameCaption; BankNameCaptionLbl)
                    { }
                    column(AccNoCaption; AccNoCaptionLbl)
                    { }
                    column(ShipmentNoCaption; ShipmentNoCaptionLbl)
                    { }
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Purch. Rcpt. Header";
                        DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                        column(ReportForNavId_7574; 7574)
                        { }
                        column(DimText; DimText)
                        { }
                        column(HeaderDimCaption; HeaderDimCaptionLbl)
                        { }
                        trigger OnAfterGetRecord()
                        begin
                            if DimensionLoop1.Number = 1 then begin
                                if not DimSetEntry1.FindSet then CurrReport.Break;
                            end
                            else if not Continue then CurrReport.Break;
                            Clear(DimText);
                            Continue := false;
                            repeat
                                OldDimText := DimText;
                                if DimText = '' then
                                    DimText := StrSubstNo('%1 - %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText := StrSubstNo('%1; %2 - %3', DimText, DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until DimSetEntry1.Next = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then CurrReport.Break;
                        end;
                    }
                    dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = "Purch. Rcpt. Header";
                        DataItemTableView = sorting("Document No.", "Line No.");

                        column(ReportForNavId_3042; 3042)
                        { }
                        column(ShowInternalInfo; ShowInternalInfo)
                        { }
                        column(Type_PurchRcptLine; Format("Purch. Rcpt. Line".Type, 0, 2))
                        { }
                        column(Desc_PurchRcptLine; "Purch. Rcpt. Line".Description)
                        {
                            IncludeCaption = false;
                        }
                        column(Qty_PurchRcptLine; "Purch. Rcpt. Line".Quantity)
                        {
                            IncludeCaption = false;
                        }
                        column(UOM_PurchRcptLine; "Purch. Rcpt. Line"."Unit of Measure")
                        {
                            IncludeCaption = false;
                        }
                        column(No_PurchRcptLine; "Purch. Rcpt. Line"."No.")
                        { }
                        column(DocNo_PurchRcptLine; "Purch. Rcpt. Line"."Document No.")
                        { }
                        column(LineNo_PurchRcptLine; "Purch. Rcpt. Line"."Line No.")
                        {
                            IncludeCaption = false;
                        }
                        column(No_PurchRcptLineCaption; "Purch. Rcpt. Line".FieldCaption("Purch. Rcpt. Line"."No."))
                        { }
                        column(LocationLabel; "Purch. Rcpt. Line"."Location Code")
                        { }
                        column(LocationLabelCaption; "Purch. Rcpt. Line".FieldCaption("Location Code"))
                        { }
                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                            column(ReportForNavId_3591; 3591)
                            { }
                            column(DimText1; DimText)
                            { }
                            column(LineDimCaption; LineDimCaptionLbl)
                            { }
                            trigger OnAfterGetRecord()
                            begin
                                if DimensionLoop2.Number = 1 then begin
                                    if not DimSetEntry2.FindSet then CurrReport.Break;
                                end
                                else if not Continue then CurrReport.Break;
                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := StrSubstNo('%1 - %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText := StrSubstNo('%1; %2 - %3', DimText, DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until DimSetEntry2.Next = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then CurrReport.Break;
                            end;
                        }
                        trigger OnAfterGetRecord()
                        begin
                            if (not ShowCorrectionLines) and "Purch. Rcpt. Line".Correction then CurrReport.Skip;
                            DimSetEntry2.SetRange("Dimension Set ID", "Purch. Rcpt. Line"."Dimension Set ID");
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := "Purch. Rcpt. Line".Find('+');
                            while MoreLines and ("Purch. Rcpt. Line".Description = '') and ("Purch. Rcpt. Line"."No." = '') and ("Purch. Rcpt. Line".Quantity = 0) do MoreLines := "Purch. Rcpt. Line".Next(-1) <> 0;
                            if not MoreLines then CurrReport.Break;
                            "Purch. Rcpt. Line".SetRange("Purch. Rcpt. Line"."Line No.", 0, "Purch. Rcpt. Line"."Line No.");
                        end;
                    }
                    dataitem(Total; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));

                        column(ReportForNavId_3476; 3476)
                        { }
                        column(BuyfromVenNo_PurchRcptHeader; "Purch. Rcpt. Header"."Buy-from Vendor No.")
                        { }
                        column(BuyfromVenNo_PurchRcptHeaderCaption; "Purch. Rcpt. Header".FieldCaption("Buy-from Vendor No."))
                        { }
                        trigger OnPreDataItem()
                        begin
                            if "Purch. Rcpt. Header"."Buy-from Vendor No." = "Purch. Rcpt. Header"."Pay-to Vendor No." then CurrReport.Break;
                        end;
                    }
                    dataitem(Total2; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));

                        column(ReportForNavId_3363; 3363)
                        { }
                        column(PaytoVenNo_PurchRcptHeader; "Purch. Rcpt. Header"."Pay-to Vendor No.")
                        { }
                        column(VendAddr1; VendAddr[1])
                        { }
                        column(VendAddr2; VendAddr[2])
                        { }
                        column(VendAddr3; VendAddr[3])
                        { }
                        column(VendAddr4; VendAddr[4])
                        { }
                        column(VendAddr5; VendAddr[5])
                        { }
                        column(VendAddr6; VendAddr[6])
                        { }
                        column(VendAddr7; VendAddr[7])
                        { }
                        column(VendAddr8; VendAddr[8])
                        { }
                        column(PaytoAddrCaption; PaytoAddrCaptionLbl)
                        { }
                        column(PaytoVenNo_PurchRcptHeaderCaption; "Purch. Rcpt. Header".FieldCaption("Pay-to Vendor No."))
                        { }
                    }
                }
                trigger OnAfterGetRecord()
                begin
                    if CopyLoop.Number > 1 then begin
                        CopyText := FormatDocument.GetCOPYText;
                        OutputNo += 1;
                    end;
                    //CurrReport.PageNo := 1;
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then RcptCountPrinted.Run("Purch. Rcpt. Header");
                end;

                trigger OnPreDataItem()
                begin
                    OutputNo := 1;
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    CopyText := '';
                    CopyLoop.SetRange(CopyLoop.Number, 1, NoOfLoops);
                end;
            }
            trigger OnAfterGetRecord()
            begin
                if ("Purch. Rcpt. Header"."Language Code" <> '') and ("Purch. Rcpt. Header"."Language Code" <> 'ESP') then begin
                    //ini - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
                    //CurrReport.Language := Language.GetLanguageID("Purch. Rcpt. Header"."Language Code");
                    CurrReport.Language := cLanguage.GetLanguageID("Purch. Rcpt. Header"."Language Code");
                    //fin - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
                end;
                CompanyInfo.Get;
                if RespCenter.Get("Purch. Rcpt. Header"."Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end
                else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                DimSetEntry1.SetRange("Dimension Set ID", "Purch. Rcpt. Header"."Dimension Set ID");
                if "Purch. Rcpt. Header"."Purchaser Code" = '' then begin
                    SalesPurchPerson.Init;
                    PurchaserText := '';
                end
                else begin
                    SalesPurchPerson.Get("Purch. Rcpt. Header"."Purchaser Code");
                    PurchaserText := Text000
                end;
                if "Purch. Rcpt. Header"."Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := "Purch. Rcpt. Header".FieldCaption("Purch. Rcpt. Header"."Your Reference");
                FormatAddr.PurchRcptShipTo(ShipToAddr, "Purch. Rcpt. Header");
                FormatAddr.PurchRcptPayTo(VendAddr, "Purch. Rcpt. Header");
                if LogInteraction then if not CurrReport.Preview then SegManagement.LogDocument(15, "Purch. Rcpt. Header"."No.", 0, 0, Database::Vendor, "Purch. Rcpt. Header"."Buy-from Vendor No.", "Purch. Rcpt. Header"."Purchaser Code", '', "Purch. Rcpt. Header"."Posting Description", '');
            end;
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', comment = 'ESP="Opciones"';

                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = Basic;
                        Caption = 'No. of Copies', comment = 'ESP="Nº copias"';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Internal Information', comment = 'ESP="Mostrar información interna"';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Log Interaction', comment = 'ESP="Log interacción"';
                        Enabled = LogInteractionEnable;
                    }
                    field(ShowCorrectionLines; ShowCorrectionLines)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Correction Lines', comment = 'ESP="Muestra líneas corrección"';
                    }
                }
            }
        }
        actions
        {
        }
        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Purch. Rcpt.") <> '';
            LogInteractionEnable := LogInteraction;
        end;
    }
    labels
    {
    }
    var
        Text000: label 'Purchaser', comment = 'ESP="Comprador"';
        Text002: label 'Purchase - Receipt %1', comment = 'ESP="Compras - Albarán"';
        Text003: label 'Page %1', comment = 'ESP="Pág. %1"';
        CompanyInfo: Record "Company Information";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        //ini - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
        //Language: Record Language;
        cLanguage: Codeunit Language;
        //fin - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
        RespCenter: Record "Responsibility Center";
        RcptCountPrinted: Codeunit "Purch.Rcpt.-Printed";
        SegManagement: Codeunit SegManagement;
        VendAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        PurchaserText: Text[30];
        ReferenceText: Text[80];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        FormatAddr: Codeunit "Format Address";
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        ShowCorrectionLines: Boolean;
        OutputNo: Integer;
        LogInteractionEnable: Boolean;
        PhoneNoCaptionLbl: label 'Phone No.', comment = 'ESP="Nº teléfono"';
        HomePageCaptionLbl: label 'Home Page', comment = 'ESP="Página Web"';
        VATRegNoCaptionLbl: label 'VAT Registration No.', comment = 'ESP="CIF/NIF"';
        GiroNoCaptionLbl: label 'Giro No.', comment = 'ESP="Nº giro postal"';
        BankNameCaptionLbl: label 'Bank', comment = 'ESP="Banco"';
        AccNoCaptionLbl: label 'Account No.', comment = 'ESP="Nº cuenta"';
        ShipmentNoCaptionLbl: label 'Shipment No.', comment = 'ESP="Nº albarán"';
        HeaderDimCaptionLbl: label 'Header Dimensions', comment = 'ESP="Dimensiones cabecera"';
        LineDimCaptionLbl: label 'Line Dimensions', comment = 'ESP="Dimensiones línea"';
        PaytoAddrCaptionLbl: label 'Pay-to Address', comment = 'ESP="Dirección pago"';
        DocDateCaptionLbl: label 'Document Date', comment = 'ESP="Fecha emisión documento"';
        PageCaptionLbl: label 'Page', comment = 'ESP="Pág."';
        DescCaptionLbl: label 'Description', comment = 'ESP="Descripción"';
        QtyCaptionLbl: label 'Quantity', comment = 'ESP="Cantidad"';
        UOMCaptionLbl: label 'Unit Of Measure', comment = 'ESP="Unidad medida"';
        PaytoVenNoCaptionLbl: label 'Pay-to Vendor No.', comment = 'ESP="Pago-a Nº proveedor"';
        EmailCaptionLbl: label 'E-Mail', comment = 'ESP="Correo electrónico"';
        FormatDocument: Codeunit "Format Document";

    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean; NewShowCorrectionLines: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
        ShowCorrectionLines := NewShowCorrectionLines;
    end;
}
