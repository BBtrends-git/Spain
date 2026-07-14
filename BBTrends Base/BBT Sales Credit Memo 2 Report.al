Report 50004 "Sales - Credit Memo 2"
{
    // //INC-2018-05-93291
    // 
    // //INC-2019-01-105854 : Mostrar pie Protección de datos
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/Sales - Credit Memo 2.rdl';
    Caption = 'Sales - Credit Memo', comment = 'ESP="Ventas - Abono"';
    Permissions = TableData "Sales Shipment Buffer" = rimd,
                    Tabledata "Sales Cr.Memo Header" = rm;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(CompanyInformation; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            column(ReportForNavId_1100234000; 1100234000)
            { }
            column(CompanyInfoPicture; CompanyInfo.Picture)
            { }
            column(CompanyInfoName; CompanyInfo.Name)
            { }
            column(CompanyInfoAddress; CompanyInfo.Address)
            { }
            column(CompanyInfoAddress2; CompanyInfo."Address 2")
            { }
            column(CompanyInfoPostCode; CompanyInfo."Post Code")
            { }
            column(CompanyInfoCity; CompanyInfo.City)
            { }
            column(CompanyInfoCounty; CompanyInfo.County)
            { }
            column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
            { }
            column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
            { }
            column(CompanyInfoHomePage; CompanyInfo."Home Page")
            { }
            column(CompanyInfoEMail; CompanyInfo."E-Mail")
            { }
            column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
            { }
            column(CompanyInfoBankName; CompanyInfo."Bank Name")
            { }
            column(CompanyInfoBankAccNo; CompanyInfo."Bank Account No.")
            { }
            column(CompanyInfoTextopie; CompanyInfo."Texto pie  protecc. de datos 1")
            { }
            column(CompanyInfoTextopie1; CompanyInfo."Texto pie  protecc. de datos 2")
            { }
            column(CompanyInfoTextopie2; CompanyInfo."Texto pie  protecc. de datos 3")
            { }
            column(CompanyInfoTextopie3; CompanyInfo."Texto pie  protecc. de datos 4")
            { }
            column(CompanyInfoTextopie4; CompanyInfo."Texto pie  protecc. de datos 5")
            { }
            column(FooterText1; FooterText1)
            { }
            column(FooterText2; FooterText2)
            { }
            column(FooterText3; CompanyInfo."Commercial Register Text")
            { }
            column(CostRecicling; CompanyInfo."Cost Recicling Text")
            { }
            column(LOPDTxt; LOPDtxt)
            { }

            trigger OnAfterGetRecord()
            begin

                //I. INC-2018-05-93291
                LOPDtxt := 'En virtud de lo establecido en la Ley 15/1999, y la LSSICE 34/2002, le informamos que sus datos forman parte de un fichero titularidad de ' + CompanyInfo.Name + ' con la finalidad de llevar a cabo la gestión administrativa y comercial. ' + 'La información registrada se utilizará para informarle por cualquier medio electrónico o postal de las novedades de la compañía. ' + 'Puede ejercer los derechos de acceso, rectificación, cancelación y oposición en ' + CompanyInfo.Address + ', ' + CompanyInfo."Post Code" + ', ' + CompanyInfo.City + ' (' + CompanyInfo.County + ') ' + 'o en el correo eléctronico ' + CompanyInfo."E-Mail" + '.';
                //F. INC-2018-05-93291
            end;
        }
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Credit Memo', comment = 'ESP="Histórico abonos venta"';

            column(ReportForNavId_8098; 8098)
            { }
            //>>
            column(EURLbl; EURLbl)
            { }
            column(PLNLbl; PLNLbl)
            { }
            column(vShowPLCurrencyExchange; vShowPLCurrencyExchange)
            { }
            column(vRate; "BBT PL Currency Exchange")
            { }
            column(VATPlnLbl; VATPlnLbl)
            { }
            column(VATPln2Lbl; VATPln2Lbl)
            { }
            column(VATECBaseCaption; VATECBaseCaptionLbl)
            { }
            column(VATAmtLineVATCaption; VATAmtLineVATCaptionLbl)
            { }
            column(VATAmountCaption; VATAmountCaptionLbl)
            { }
            //<<
            column(vVATRegNo; vVATRegNo)
            { }
            column(vVATRegNoLbl; vVATRegNoLbl)
            { }
            column(No_SalesCrMemoHeader; "Sales Cr.Memo Header"."No.")
            { }
            column(PaymentTermsDescription; PaymentTerms.Description)
            { }
            column(ShipmentMethodDescription; ShipmentMethod.Description)
            { }
            column(PaymentMethodDescription; PaymentMethod.Description)
            { }
            column(PmtTermsDescCaption; PmtTermsDescCaptionLbl)
            { }
            column(ShpMethodDescCaption; ShpMethodDescCaptionLbl)
            { }
            column(PmtMethodDescCaption; PmtMethodDescCaptionLbl)
            { }
            column(DocDateCaption; DocDateCaptionLbl)
            { }
            column(HomePageCaption; HomePageCaptionCap)
            { }
            column(EmailCaption; EmailCaptionLbl)
            { }
            column(OurAccountNo_Cust; Cust."Our Account No.")
            { }
            column(CompanyInfoCountry; CompanyInfoCountryLbl)
            { }
            column(ReferenceCaption; ReferenceCaptionLbl)
            { }
            column(CurrencyText; CurrencyText)
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
                    column(SalesCorrectiveInvCopy; CopyText)
                    { }
                    column(CustAddr1; CustAddr[1])
                    { }
                    column(CompanyAddr1; CompanyAddr[1])
                    { }
                    column(CustAddr2; CustAddr[2])
                    { }
                    column(CompanyAddr2; CompanyAddr[2])
                    { }
                    column(CustAddr3; CustAddr[3])
                    { }
                    column(CompanyAddr3; CompanyAddr[3])
                    { }
                    column(CustAddr4; CustAddr[4])
                    { }
                    column(CompanyAddr4; CompanyAddr[4])
                    { }
                    column(CustAddr5; CustAddr[5])
                    { }
                    column(CustAddr6; CustAddr[6])
                    { }
                    column(CustAddr7; CustAddr[7])
                    { }
                    column(CustAddr8; CustAddr[8])
                    { }
                    column(CompanyAddr5; CompanyAddr[5])
                    { }
                    column(CompanyAddr6; CompanyAddr[6])
                    { }
                    column(BilltoCustNo_SalesCrMemoHeader; "Sales Cr.Memo Header"."Bill-to Customer No.")
                    { }
                    column(PostDate_SalesCrMemoHeader; "Sales Cr.Memo Header"."Posting Date")
                    { }
                    column(VATNoText; VATNoText)
                    { }
                    column(VATRegNo_SalesCrMemoHeader; "Sales Cr.Memo Header"."VAT Registration No.")
                    { }
                    column(SalesPersonText; SalesPersonText)
                    { }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    { }
                    column(AppliedToText; AppliedToText)
                    { }
                    column(ReferenceText; ReferenceText)
                    { }
                    column(YourRef_SalesCrMemoHeader; "Sales Cr.Memo Header"."Your Reference")
                    { }
                    column(DocDate_SalesCrMemoHeader; Format("Sales Cr.Memo Header"."Document Date", 0, 4))
                    { }
                    column(PricIncVAT_SalesCrMemoHeader; "Sales Cr.Memo Header"."Prices Including VAT")
                    { }
                    column(ReturnOrderNoText; ReturnOrderNoText)
                    { }
                    column(RetOrderNo_SalesCrMemoHeader; "Sales Cr.Memo Header"."Return Order No.")
                    { }
                    column(DueDate_SalesCrMemoHeader; "Sales Cr.Memo Header"."Due Date")
                    { }
                    column(PaymentDiscPct_SalesCrMemoHeader; "Sales Cr.Memo Header"."Payment Discount %")
                    { }
                    column(PageCaption; PageCaptionCap)
                    { }
                    column(OutputNo; OutputNo)
                    { }
                    column(PricInclVAT1_SalesCrMemoHeader; Format("Sales Cr.Memo Header"."Prices Including VAT"))
                    { }
                    column(VATBaseDiscPct_SalesCrMemoHeader; "Sales Cr.Memo Header"."VAT Base Discount %")
                    { }
                    column(CorrInvNo_SalesCrMemoHeader; "Sales Cr.Memo Header"."Corrected Invoice No.")
                    { }
                    column(ExternalDocumentNo_SalesCrMemoHeader; "Sales Cr.Memo Header"."External Document No.")
                    { }
                    column(CompanyInfoPhoneNoCaption; CompanyInfoPhoneNoCaptionLbl)
                    { }
                    column(CompanyInfoHomePageCaption; CompanyInfoHomePageCaptionLbl)
                    { }
                    column(CompanyInfoEMailCaption; CompanyInfoEMailCaptionLbl)
                    { }
                    column(CompanyInfoVATRegistrationNoCaption; CompanyInfoVATRegistrationNoCaptionLbl)
                    { }
                    column(CompanyInfoGiroNoCaption; CompanyInfoGiroNoCaptionLbl)
                    { }
                    column(CompanyInfoBankNameCaption; CompanyInfoBankNameCaptionLbl)
                    { }
                    column(CompanyInfoBankAccountNoCaption; CompanyInfoBankAccountNoCaptionLbl)
                    { }
                    column(SalesCrMemoHeaderNoCaption; SalesCrMemoHeaderNoCaptionLbl)
                    { }
                    column(SalesCrMemoHeaderPostingDateCaption; SalesCrMemoHeaderPostingDateCaptionLbl)
                    { }
                    column(CorrectedInvoiceNoCaption; CorrectedInvoiceNoCaptionLbl)
                    { }
                    column(DocumentDateCaption; DocumentDateCaptionLbl)
                    { }
                    column(BilltoCustNo_SalesCrMemoHeaderCaption; "Sales Cr.Memo Header".FieldCaption("Bill-to Customer No."))
                    { }
                    column(PricIncVAT_SalesCrMemoHeaderCaption; "Sales Cr.Memo Header".FieldCaption("Prices Including VAT"))
                    { }
                    column(CACCaption; CACCaptionLbl)
                    { }
                    column(CustOurAccountNoCaption; CustOurAccountNoCaptionLbl)
                    { }
                    column(DiccountsCaption; DiccountsCaptionLbl)
                    { }
                    column(SimbPctCaption; SimbPctCaptionLbl)
                    { }
                    column(AmountsCaption; AmountsCaptionLbl)
                    { }
                    column(DiscPctCaption; DiscPctCaptionLbl)
                    { }
                    column(DiscAmtCaption; DiscAmtCaptionLbl)
                    { }
                    column(ObservationsCaption; ObservationsCaptionLbl)
                    { }
                    column(AGCaption; AGCaptionLbl)
                    { }
                    column(DCCaption; DCCaptionLbl)
                    { }
                    column(DueDateCaption; DueDateCaptionLbl)
                    { }
                    column(AmCaption; AmCaptionLbl)
                    { }
                    column(CCC_Bank_No_CustBankAccount; CCCBankNo)
                    { }
                    column(CCC_Bank_Branch_No_CustBankAccount; CCCBankBranchNo)
                    { }
                    column(CCC_Control_Digits_CustBankAccount; CCCControlDigits)
                    { }
                    column(IBAN_CustBankAccount; CodeIBAN)
                    { }
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Sales Cr.Memo Header";
                        DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                        column(ReportForNavId_7574; 7574)
                        { }
                        column(DimText; DimText)
                        { }
                        column(Number_IntegerLine; DimensionLoop1.Number)
                        { }
                        column(HeaderDimensionsCaption; HeaderDimensionsCaptionLbl)
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
                                    DimText := StrSubstNo('%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText := StrSubstNo('%1, %2 %3', DimText, DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until DimSetEntry1.Next = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break;
                            //IF NOT ShowInternalInfo THEN
                            //  CurrReport.BREAK;
                        end;
                    }
                    dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = "Sales Cr.Memo Header";
                        DataItemTableView = sorting("Document No.", "Line No.");

                        column(ReportForNavId_3364; 3364)
                        { }
                        trigger OnAfterGetRecord()
                        begin
                            NNC_TotalLineAmount += "Sales Cr.Memo Line"."Line Amount";
                            NNC_TotalAmountInclVat += "Sales Cr.Memo Line"."Amount Including VAT";
                            NNC_TotalInvDiscAmount += "Sales Cr.Memo Line"."Inv. Discount Amount";
                            NNC_TotalAmount += "Sales Cr.Memo Line".Amount;
                            SalesShipmentBuffer.DeleteAll;
                            PostedReceiptDate := 0D;
                            if "Sales Cr.Memo Line".Quantity <> 0 then PostedReceiptDate := FindPostedShipmentDate;
                            if ("Sales Cr.Memo Line".Type = "Sales Cr.Memo Line".Type::"G/L Account") and (not ShowInternalInfo) then "Sales Cr.Memo Line"."No." := '';
                            if VATPostingSetup.Get("Sales Cr.Memo Line"."VAT Bus. Posting Group", "Sales Cr.Memo Line"."VAT Prod. Posting Group") then begin
                                VATAmountLine.Init;
                                VATAmountLine."VAT Identifier" := "Sales Cr.Memo Line"."VAT Identifier";
                                VATAmountLine."VAT Calculation Type" := "Sales Cr.Memo Line"."VAT Calculation Type";
                                VATAmountLine."Tax Group Code" := "Sales Cr.Memo Line"."Tax Group Code";
                                VATAmountLine."VAT %" := VATPostingSetup."VAT %";
                                VATAmountLine."EC %" := VATPostingSetup."EC %";
                                //ini - 'Record "VAT Amount Line" temporary' does not contain a definition for 'VAT+EC Base'
                                //    - 'Record "VAT Amount Line" temporary' does not contain a definition for 'Amount Including VAT+EC'
                                // VATAmountLine."VAT+EC Base" := "Sales Cr.Memo Line".Amount;
                                // VATAmountLine."Amount Including VAT+EC" := "Sales Cr.Memo Line"."Amount Including VAT";
                                VATAmountLine."VAT Base" := "Sales Cr.Memo Line".Amount;
                                VATAmountLine."Amount Including VAT" := "Sales Cr.Memo Line"."Amount Including VAT";
                                //fin - 'Record "VAT Amount Line" temporary' does not contain a definition for 'VAT+EC Base'
                                //    - 'Record "VAT Amount Line" temporary' does not contain a definition for 'Amount Including VAT+EC'
                                VATAmountLine."Line Amount" := "Sales Cr.Memo Line"."Line Amount";
                                //ini - 'Record "VAT Amount Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                                //    - 'Record "Sales Cr.Memo Line"' does not contain a definition for 'Pmt. Disc. Given Amount'
                                // VATAmountLine."Pmt. Disc. Given Amount" := "Sales Cr.Memo Line"."Pmt. Disc. Given Amount";
                                VATAmountLine."Pmt. Discount Amount" := "Sales Cr.Memo Line"."Pmt. Discount Amount";
                                //fin - 'Record "VAT Amount Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                                //    - 'Record "Sales Cr.Memo Line"' does not contain a definition for 'Pmt. Disc. Given Amount'
                                VATAmountLine.SetCurrencyCode("Sales Cr.Memo Header"."Currency Code");
                                if "Sales Cr.Memo Line"."Allow Invoice Disc." then VATAmountLine."Inv. Disc. Base Amount" := "Sales Cr.Memo Line"."Line Amount";
                                VATAmountLine."Invoice Discount Amount" := "Sales Cr.Memo Line"."Inv. Discount Amount";
                                VATAmountLine."VAT Difference" := "Sales Cr.Memo Line"."VAT Difference";
                                VATAmountLine."EC Difference" := "Sales Cr.Memo Line"."EC Difference";
                                if "Sales Cr.Memo Header"."Prices Including VAT" then VATAmountLine."Prices Including VAT" := true;
                                VATAmountLine."VAT Clause Code" := "Sales Cr.Memo Line"."VAT Clause Code";
                                VATAmountLine.InsertLine;
                                TotalSubTotal += "Sales Cr.Memo Line"."Line Amount";
                                TotalInvoiceDiscountAmount -= "Sales Cr.Memo Line"."Inv. Discount Amount";
                                TotalAmount += "Sales Cr.Memo Line".Amount;
                                TotalAmountVAT += "Sales Cr.Memo Line"."Amount Including VAT" - "Sales Cr.Memo Line".Amount;
                                TotalAmountInclVAT += "Sales Cr.Memo Line"."Amount Including VAT";
                                //ini - 'Record "Sales Cr.Memo Line"' does not contain a definition for 'Pmt. Disc. Given Amount'
                                // TotalGivenAmount -= "Sales Cr.Memo Line"."Pmt. Disc. Given Amount";
                                // TotalPaymentDiscountOnVAT += -("Sales Cr.Memo Line"."Line Amount" - "Sales Cr.Memo Line"."Inv. Discount Amount" - "Sales Cr.Memo Line"."Pmt. Disc. Given Amount" - "Sales Cr.Memo Line"."Amount Including VAT");
                                TotalGivenAmount -= "Sales Cr.Memo Line"."Pmt. Discount Amount";
                                TotalPaymentDiscountOnVAT += -("Sales Cr.Memo Line"."Line Amount" - "Sales Cr.Memo Line"."Inv. Discount Amount" - "Sales Cr.Memo Line"."Pmt. Discount Amount" - "Sales Cr.Memo Line"."Amount Including VAT");
                                //fin - 'Record "Sales Cr.Memo Line"' does not contain a definition for 'Pmt. Disc. Given Amount'
                            end;
                            SalesCrMemoLineBuffer.Init;
                            SalesCrMemoLineBuffer := "Sales Cr.Memo Line";
                            SalesCrMemoLineBuffer.Insert;
                            DocLineNo := "Sales Cr.Memo Line"."Line No.";
                            ReportPrintedLines += 1;
                        end;

                        trigger OnPreDataItem()
                        begin
                            VATAmountLine.DeleteAll;
                            SalesShipmentBuffer.Reset;
                            SalesShipmentBuffer.DeleteAll;
                            FirstValueEntryNo := 0;
                            MoreLines := "Sales Cr.Memo Line".Find('+');
                            while MoreLines and ("Sales Cr.Memo Line".Description = '') and ("Sales Cr.Memo Line"."No." = '') and ("Sales Cr.Memo Line".Quantity = 0) and ("Sales Cr.Memo Line".Amount = 0) do MoreLines := "Sales Cr.Memo Line".Next(-1) <> 0;
                            if not MoreLines then CurrReport.Break;
                            "Sales Cr.Memo Line".SetRange("Sales Cr.Memo Line"."Line No.", 0, "Sales Cr.Memo Line"."Line No.");
                            //ini - 'Record "Sales Cr.Memo Line"' does not contain a definition for 'Pmt. Disc. Given Amount'
                            //CurrReport.CreateTotals("Sales Cr.Memo Line".Amount, "Sales Cr.Memo Line"."Amount Including VAT", "Sales Cr.Memo Line"."Inv. Discount Amount", "Sales Cr.Memo Line"."Pmt. Disc. Given Amount");
                            //>> BBT. CreateTotals. Marcada como obsoleta. 
                            //CurrReport.CreateTotals("Sales Cr.Memo Line".Amount, "Sales Cr.Memo Line"."Amount Including VAT", "Sales Cr.Memo Line"."Inv. Discount Amount", "Sales Cr.Memo Line"."Pmt. Discount Amount");
                            //
                            //fin - 'Record "Sales Cr.Memo Line"' does not contain a definition for 'Pmt. Disc. Given Amount'
                            ReportPrintedLines := 0;
                        end;
                    }
                    dataitem(SalesLineLoop; "Integer")
                    {
                        DataItemTableView = sorting(Number);

                        column(ReportForNavId_1100234012; 1100234012)
                        { }
                        column(LineAmt_SalesCrMemoLine; "Sales Cr.Memo Line"."Line Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Desc_SalesCrMemoLine; "Sales Cr.Memo Line".Description)
                        { }
                        column(No_SalesCrMemoLine; "Sales Cr.Memo Line"."No.")
                        { }
                        column(Qty_SalesCrMemoLine; "Sales Cr.Memo Line".Quantity)
                        { }
                        column(UOM_SalesCrMemoLine; "Sales Cr.Memo Line"."Unit of Measure")
                        { }
                        column(UnitPrice_SalesCrMemoLine; "Sales Cr.Memo Line"."Unit Price")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 2;
                        }
                        column(LineDisc_SalesCrMemoLine; "Sales Cr.Memo Line"."Line Discount %")
                        { }
                        column(VATIdent_SalesCrMemoLine; "Sales Cr.Memo Line"."VAT Identifier")
                        { }
                        column(PostedReceiptDate; Format(PostedReceiptDate))
                        { }
                        column(Type_SalesCrMemoLine; Format("Sales Cr.Memo Line".Type))
                        { }
                        column(NNCTotalLineAmt; NNC_TotalLineAmount)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(NNCTotalAmtInclVat; NNC_TotalAmountInclVat)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(NNCTotalInvDiscAmt; NNC_TotalInvDiscAmount)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(NNCTotalAmt; NNC_TotalAmount)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(InvDiscAmt_SalesCrMemoLine; -"Sales Cr.Memo Line"."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        //ini - 'Record "Sales Cr.Memo Line"' does not contain a definition for 'Pmt. Disc. Given Amount'
                        // column(PmtDiscAmt_SalesCrMemoLine; -"Sales Cr.Memo Line"."Pmt. Disc. Given Amount")
                        // {
                        //     AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                        //     AutoFormatType = 1;
                        // }
                        column(PmtDiscAmt_SalesCrMemoLine; -"Sales Cr.Memo Line"."Pmt. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        //fin - 'Record "Sales Cr.Memo Line"' does not contain a definition for 'Pmt. Disc. Given Amount'
                        column(TotalExclVATText; TotalExclVATText)
                        { }
                        column(TotalInclVATText; TotalInclVATText)
                        { }
                        column(AmtIncVAT_SalesCrMemoLine; "Sales Cr.Memo Line"."Amount Including VAT")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(AmtIncVATAmt_SalesCrMemoLine; "Sales Cr.Memo Line"."Amount Including VAT" - "Sales Cr.Memo Line".Amount)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText)
                        { }
                        column(Amt_SalesCrMemoLine; "Sales Cr.Memo Line".Amount)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(DocNo_SalesCrMemoLine; "Sales Cr.Memo Line"."Document No.")
                        { }
                        column(LineNo_SalesCrMemoLine; "Sales Cr.Memo Line"."Line No.")
                        { }
                        column(EAN_SalesCrMemoLine; "Sales Cr.Memo Line"."EAN Code")
                        { }
                        //>> BBT. SMG Extension. 
                        /*
                        column(Disc1_SalesCrMemoLine; "Sales Cr.Memo Line"."Discount 1 %")
                        { }
                        column(Disc2_SalesCrMemoLine; "Sales Cr.Memo Line"."Discount 2 %")
                        { }
                        column(Disc3_SalesCrMemoLine; "Sales Cr.Memo Line"."Discount 3 %")
                        { }
                        column(Disc4_SalesCrMemoLine; "Sales Cr.Memo Line"."Discount 4 %")
                        { }
                        column(Disc5_SalesCrMemoLine; "Sales Cr.Memo Line"."Discount 5 %")
                        { }
                        column(DiscTotalAmt_SalesCrMemoLine; "Sales Cr.Memo Line"."Discounts Total Amount")
                        { }
                        */
                        //>> BBT. SMG Extension.  
                        column(SMGDisc1_SalesCrMemoLine; "Sales Cr.Memo Line"."SMG Discount 1 %")
                        { }
                        column(SMGDisc2_SalesCrMemoLine; "Sales Cr.Memo Line"."SMG Discount 2 %")
                        { }
                        column(SMGDisc3_SalesCrMemoLine; "Sales Cr.Memo Line"."SMG Discount 3 %")
                        { }
                        column(SMGDisc4_SalesCrMemoLine; "Sales Cr.Memo Line"."SMG Discount 4 %")
                        { }
                        column(SMGDisc5_SalesCrMemoLine; "Sales Cr.Memo Line"."SMG Discount 5 %")
                        { }
                        column(SMGDiscTotalAmt_SalesCrMemoLine; "Sales Cr.Memo Line"."Line Discount Amount")
                        { }
                        //<<
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        { }
                        column(SalesCrMemoLineLineDiscountCaption; SalesCrMemoLineLineDiscountCaptionLbl)
                        { }
                        column(AmountCaption; AmtCaptionLbl)
                        { }
                        column(PostedReceiptDateCaption; PostedReceiptDateCaptionLbl)
                        { }
                        column(InvDiscountAmountCaption; InvDiscountAmountCaptionLbl)
                        { }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        { }
                        column(PmtDiscGivenAmountCaption; PmtDiscGivenAmountCaptionLbl)
                        { }
                        column(Desc_SalesCrMemoLineCaption; "Sales Cr.Memo Line".FieldCaption(Description))
                        { }
                        column(No_SalesCrMemoLineCaption; ItemNoCaptionLbl)
                        { }
                        column(Qty_SalesCrMemoLineCaption; "Sales Cr.Memo Line".FieldCaption(Quantity))
                        { }
                        column(UOM_SalesCrMemoLineCaption; UnitsCaptionLbl)
                        { }
                        column(EANCaption; EANCaptionLbl)
                        { }
                        column(TotalDiscCaption; TotalDiscCaptionLbl)
                        { }
                        column(NetUnitCaption; NetUnitCaptionLbl)
                        { }
                        column(Disc1Caption; DiscLabel[1])
                        { }
                        column(Disc2Caption; DiscLabel[2])
                        { }
                        column(Disc3Caption; DiscLabel[3])
                        { }
                        column(Disc4Caption; DiscLabel[4])
                        { }
                        column(Disc5Caption; DiscLabel[5])
                        { }
                        column(PageLines; PageLines)
                        { }
                        column(ContLine; ContLine)
                        { }
                        column(TotalRepLines; TotalRepLines)
                        { }
                        column(CurrRepLine; SalesLineLoop.Number)
                        { }
                        column(NetoUnit; NetoUnit)
                        { }
                        column(ECAmountCaption; ECAmountCaptionLbl)
                        { }
                        column(PaymentDiscPctCaption; PaymentDiscPctCaptionLbl)
                        { }
                        column(PDAmtCaption; PDAmtCaptionLbl)
                        { }
                        column(TotalSubTotal; TotalSubTotal)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInvoiceDiscountAmount; TotalInvoiceDiscountAmount)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmount; TotalAmount)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalGivenAmount; TotalGivenAmount)
                        { }
                        column(VATAmountLineVATECBaseControl105Caption; VATAmountLineVATECBaseControl105CaptionLbl)
                        { }
                        column(VATAmountLineVATAmountControl106Caption; VATAmountLineVATAmountControl106CaptionLbl)
                        { }
                        column(VATAmountLineVATCaption; VATAmountLineVATCaptionLbl)
                        { }
                        column(ECCaption; ECCaptionLbl)
                        { }
                        column(ECCAmtCaption; ECCAmtCaptionLbl)
                        { }
                        column(TotalInvCaption; TotalInvCaptionLbl)
                        { }
                        dataitem("Sales Shipment Buffer"; "Integer")
                        {
                            DataItemTableView = sorting(Number);

                            column(ReportForNavId_1484; 1484)
                            { }
                            column(SalesShptBufferPostDate; Format(SalesShipmentBuffer."Posting Date"))
                            { }
                            column(SalesShptBufferQuantity; SalesShipmentBuffer.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(ReturnReceiptCaption; ReturnReceiptCaptionLbl)
                            { }
                            trigger OnAfterGetRecord()
                            begin
                                if "Sales Shipment Buffer".Number = 1 then
                                    SalesShipmentBuffer.Find('-')
                                else
                                    SalesShipmentBuffer.Next;
                            end;

                            trigger OnPreDataItem()
                            begin
                                CurrReport.Break;
                                "Sales Shipment Buffer".SetRange("Sales Shipment Buffer".Number, 1, SalesShipmentBuffer.Count);
                            end;
                        }
                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                            column(ReportForNavId_3591; 3591)
                            { }
                            column(DimText1; DimText)
                            { }
                            column(LineDimensionsCaption; LineDimensionsCaptionLbl)
                            { }
                            trigger OnAfterGetRecord()
                            begin
                                if DimensionLoop2.Number = 1 then begin
                                    if not DimSetEntry2.Find('-') then CurrReport.Break;
                                end
                                else if not Continue then CurrReport.Break;
                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := StrSubstNo('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText := StrSubstNo('%1, %2 %3', DimText, DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until (DimSetEntry2.Next = 0);
                            end;

                            trigger OnPreDataItem()
                            begin
                                CurrReport.Break;
                                //IF NOT ShowInternalInfo THEN
                                //  CurrReport.BREAK;
                                DimSetEntry2.SetRange("Dimension Set ID", "Sales Cr.Memo Line"."Dimension Set ID");
                            end;
                        }
                        trigger OnAfterGetRecord()
                        begin
                            if SalesLineLoop.Number = 1 then
                                SalesCrMemoLineBuffer.FindSet
                            else
                                SalesCrMemoLineBuffer.Next;
                            "Sales Cr.Memo Line" := SalesCrMemoLineBuffer;
                            NetoUnit := 0;
                            if "Sales Cr.Memo Line".Quantity <> 0 then NetoUnit := ROUND("Sales Cr.Memo Line"."Line Amount" / "Sales Cr.Memo Line".Quantity, 0.01);
                            ContLine += 1;
                            if ContLine > (PageLines) then ContLine := 1;
                        end;

                        trigger OnPreDataItem()
                        begin
                            //  BlankLines := CalculateBlankLines(ReportPrintedLines);
                            // if BlankLines > 0 then begin
                            //     for i := 1 to BlankLines do begin
                            //         DocLineNo += 1;
                            //         SalesCrMemoLineBuffer.Init;
                            //         SalesCrMemoLineBuffer."No." := "Sales Cr.Memo Header"."No.";
                            //         SalesCrMemoLineBuffer."Line No." := DocLineNo;
                            //         SalesCrMemoLineBuffer.Insert;
                            //     end;
                            // end;
                            TotalRepLines := SalesCrMemoLineBuffer.Count;
                            SalesLineLoop.SetRange(SalesLineLoop.Number, 1, TotalRepLines);
                            //   ContLine := 0;
                        end;
                    }
                    dataitem(VATCounter; "Integer")
                    {
                        DataItemTableView = sorting(Number);

                        column(ReportForNavId_6558; 6558)
                        { }
                        //ini - 'Record "VAT Amount Line" temporary' does not contain a definition for 'VAT+EC Base'
                        // column(VATAmtLineVATECBase; VATAmountLine."VAT+EC Base")
                        // {
                        //     AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                        //     AutoFormatType = 1;
                        // }
                        column(VATAmtLineVATECBase; VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //fin - 'Record "VAT Amount Line" temporary' does not contain a definition for 'VAT+EC Base'
                        column(VATAmtLineVATAmt; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineLineAmt; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //ini - 'Record "VAT Amount Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                        // column(VATAmtLineInvDiscAmtPmtDiscAmt; VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Disc. Given Amount")
                        // {
                        //     AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                        //     AutoFormatType = 1;
                        // }
                        column(VATAmtLineInvDiscAmtPmtDiscAmt; VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //fin - 'Record "VAT Amount Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                        column(VATAmtLineECAmt; VATAmountLine."EC Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 6;
                        }
                        column(VATAmtLineVATIdentifier; VATAmountLine."VAT Identifier")
                        { }
                        column(VATAmtLineEC; VATAmountLine."EC %")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountSpecificationCaption; VATAmountSpecificationCaptionLbl)
                        { }
                        column(VATAmountLineVATIdentifierCaption; VATAmountLineVATIdentifierCaptionLbl)
                        { }
                        column(VATAmountLineInvDiscBaseAmountControl130Caption; VATAmountLineInvDiscBaseAmountControl130CaptionLbl)
                        { }
                        column(VATAmountLineLineAmountControl135Caption; VATAmountLineLineAmountControl135CaptionLbl)
                        { }
                        column(InvandPmtDiscountsCaption; InvandPmtDiscountsCaptionLbl)
                        { }
                        column(VATAmountLineVATECBaseControl113Caption; VATAmountLineVATECBaseControl113CaptionLbl)
                        { }
                        column(TotalAmountInclVAT; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(VATCounter.Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            VATCounter.SetRange(VATCounter.Number, 1, VATAmountLine.Count);
                            //ini - 'Record "VAT Amount Line" temporary' does not contain a definition for 'VAT+EC Base'
                            //    - 'Record "VAT Amount Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                            // CurrReport.CreateTotals(
                            //   VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
                            //   VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT+EC Base", VATAmountLine."VAT Amount",
                            //   VATAmountLine."EC Amount", VATAmountLine."Pmt. Disc. Given Amount");
                            //>> BBT. CreateTotals. Marcada como obsoleta. 
                            //CurrReport.CreateTotals(VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount", VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount", VATAmountLine."EC Amount", VATAmountLine."Pmt. Discount Amount");
                            //<<
                            //fin - 'Record "VAT Amount Line" temporary' does not contain a definition for 'VAT+EC Base'
                            //    - 'Record "VAT Amount Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                        end;
                    }
                    dataitem(VATClauseEntryCounter; "Integer")
                    {
                        DataItemTableView = sorting(Number);

                        column(ReportForNavId_250; 250)
                        { }
                        column(VATClauseVATIdentifier; VATAmountLine."VAT Identifier")
                        { }
                        column(VATClauseCode; VATAmountLine."VAT Clause Code")
                        { }
                        column(VATClauseDescription; VATClause.Description)
                        { }
                        column(VATClauseDescription2; VATClause."Description 2")
                        { }
                        column(VATClauseAmount; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATClausesCaption; VATClausesCap)
                        { }
                        column(VATClauseVATIdentifierCaption; VATAmountLineVATIdentifierCaptionLbl)
                        { }
                        column(VATClauseVATAmtCaption; VATAmountLineVATAmountControl106CaptionLbl)
                        { }
                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(VATClauseEntryCounter.Number);
                            if not VATClause.Get(VATAmountLine."VAT Clause Code") then CurrReport.Skip;
                            VATClause.TranslateDescription("Sales Cr.Memo Header"."Language Code");
                        end;

                        trigger OnPreDataItem()
                        begin
                            Clear(VATClause);
                            VATClauseEntryCounter.SetRange(VATClauseEntryCounter.Number, 1, VATAmountLine.Count);
                            //>> BBT. CreateTotals. Marcada como obsoleta. 
                            //CurrReport.CreateTotals(VATAmountLine."VAT Amount");
                            //<<
                        end;
                    }
                    dataitem(VATCounterLCY; "Integer")
                    {
                        DataItemTableView = sorting(Number);

                        column(ReportForNavId_2038; 2038)
                        { }
                        column(VALSpecLCYHeader; VALSpecLCYHeader)
                        { }
                        column(VALExchRate; VALExchRate)
                        { }
                        column(VALVATAmtLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT1; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier1; VATAmountLine."VAT Identifier")
                        { }
                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(VATCounterLCY.Number);
                            VALVATBaseLCY := VATAmountLine.GetBaseLCY("Sales Cr.Memo Header"."Posting Date", "Sales Cr.Memo Header"."Currency Code", "Sales Cr.Memo Header"."Currency Factor");
                            VALVATAmountLCY := VATAmountLine.GetAmountLCY("Sales Cr.Memo Header"."Posting Date", "Sales Cr.Memo Header"."Currency Code", "Sales Cr.Memo Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or ("Sales Cr.Memo Header"."Currency Code" = '') then CurrReport.Break;
                            VATCounterLCY.SetRange(VATCounterLCY.Number, 1, VATAmountLine.Count);
                            //>> BBT. CreateTotals. Marcada como obsoleta. 
                            //CurrReport.CreateTotals(VALVATBaseLCY, VALVATAmountLCY);
                            //<<
                            if GLSetup."LCY Code" = '' then
                                VALSpecLCYHeader := Text008 + Text009
                            else
                                VALSpecLCYHeader := Text008 + Format(GLSetup."LCY Code");
                            CurrExchRate.FindCurrency("Sales Cr.Memo Header"."Posting Date", "Sales Cr.Memo Header"."Currency Code", 1);
                            CalculatedExchRate := ROUND(1 / "Sales Cr.Memo Header"."Currency Factor" * CurrExchRate."Exchange Rate Amount", 0.000001);
                            VALExchRate := StrSubstNo(Text010, CalculatedExchRate, CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(Total; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));

                        column(ReportForNavId_3476; 3476)
                        { }
                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break;
                        end;
                    }
                    dataitem(Total2; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));

                        column(ReportForNavId_3363; 3363)
                        { }
                        column(SelltoCustNo_SalesCrMemoHeader; "Sales Cr.Memo Header"."Sell-to Customer No.")
                        { }
                        column(ShipToAddr1; ShipToAddr[1])
                        { }
                        column(ShipToAddr2; ShipToAddr[2])
                        { }
                        column(ShipToAddr3; ShipToAddr[3])
                        { }
                        column(ShipToAddr4; ShipToAddr[4])
                        { }
                        column(ShipToAddr5; ShipToAddr[5])
                        { }
                        column(ShipToAddr6; ShipToAddr[6])
                        { }
                        column(ShipToAddr7; ShipToAddr[7])
                        { }
                        column(ShipToAddr8; ShipToAddr[8])
                        { }
                        column(ShiptoAddressCaption; ShiptoAddressCaptionLbl)
                        { }
                        column(SelltoCustNo_SalesCrMemoHeaderCaption; "Sales Cr.Memo Header".FieldCaption("Sell-to Customer No."))
                        { }
                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break;
                            //IF NOT ShowShippingAddr THEN
                            //  CurrReport.BREAK;
                        end;
                    }
                    trigger OnAfterGetRecord()
                    begin
                        Clear(SalesCrMemoLineBuffer);
                        SalesCrMemoLineBuffer.DeleteAll;
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    //CurrReport.PageNo := 1;
                    if CopyLoop.Number > 1 then begin
                        CopyText := FormatDocument.GetCOPYText();
                        OutputNo += 1;
                    end;
                    NNC_TotalLineAmount := 0;
                    NNC_TotalAmountInclVat := 0;
                    NNC_TotalInvDiscAmount := 0;
                    NNC_TotalAmount := 0;
                    TotalSubTotal := 0;
                    TotalInvoiceDiscountAmount := 0;
                    TotalAmount := 0;
                    TotalAmountVAT := 0;
                    TotalAmountInclVAT := 0;
                    TotalGivenAmount := 0;
                    TotalPaymentDiscountOnVAT := 0;
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then SalesCrMemoCountPrinted.Run("Sales Cr.Memo Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    CopyText := '';
                    CopyLoop.SetRange(CopyLoop.Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }
            trigger OnAfterGetRecord()
            var
                //rlCustomer: Record Customer;
                rlCurrency: Record Currency;
                rlGeneralLedgerSetup: Record "General Ledger Setup";
            begin
                if ("Sales Cr.Memo Header"."Language Code" <> '') and ("Sales Cr.Memo Header"."Language Code" <> 'ESP') then begin
                    //ini - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
                    //CurrReport.Language := Language.GetLanguageID("Sales Cr.Memo Header"."Language Code");
                    CurrReport.Language := cLanguage.GetLanguageID("Sales Cr.Memo Header"."Language Code");
                    //fin - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
                end;
                if RespCenter.Get("Sales Cr.Memo Header"."Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end
                else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                DimSetEntry1.SetRange("Dimension Set ID", "Sales Cr.Memo Header"."Dimension Set ID");
                if "Sales Cr.Memo Header"."Return Order No." = '' then
                    ReturnOrderNoText := ''
                else
                    ReturnOrderNoText := "Sales Cr.Memo Header".FieldCaption("Sales Cr.Memo Header"."Return Order No.");
                if "Sales Cr.Memo Header"."Salesperson Code" = '' then begin
                    SalesPurchPerson.Init;
                    SalesPersonText := '';
                end
                else begin
                    SalesPurchPerson.Get("Sales Cr.Memo Header"."Salesperson Code");
                    SalesPersonText := Text000;
                end;
                if "Sales Cr.Memo Header"."Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := "Sales Cr.Memo Header".FieldCaption("Sales Cr.Memo Header"."Your Reference");
                if "Sales Cr.Memo Header"."VAT Registration No." = '' then
                    VATNoText := ''
                else
                    VATNoText := "Sales Cr.Memo Header".FieldCaption("Sales Cr.Memo Header"."VAT Registration No.");
                Clear(CurrencyText);
                if "Sales Cr.Memo Header"."Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(Text001, GLSetup."LCY Code");
                    TotalInclVATText := StrSubstNo(Text002, GLSetup."LCY Code");
                    TotalExclVATText := StrSubstNo(Text007, GLSetup."LCY Code");
                    CurrencyText := ' ' + GLSetup."LCY Code";
                end
                else begin
                    TotalText := StrSubstNo(Text001, "Sales Cr.Memo Header"."Currency Code");
                    TotalInclVATText := StrSubstNo(Text002, "Sales Cr.Memo Header"."Currency Code");
                    TotalExclVATText := StrSubstNo(Text007, "Sales Cr.Memo Header"."Currency Code");
                    CurrencyText := ' ' + "Sales Cr.Memo Header"."Currency Code";
                end;
                "Sales Cr.Memo Header"."Ship-to Contact" := '';
                "Sales Cr.Memo Header"."Bill-to Contact" := '';
                FormatAddr.SalesCrMemoBillTo(CustAddr, "Sales Cr.Memo Header");
                if not Cust.Get("Sales Cr.Memo Header"."Bill-to Customer No.") then Clear(Cust);
                if not CustBankAccount.Get("Sales Cr.Memo Header"."Bill-to Customer No.", "Sales Cr.Memo Header"."Cust. Bank Acc. Code") then Clear(CustBankAccount);
                if "Sales Cr.Memo Header"."Payment Terms Code" = '' then
                    PaymentTerms.Init
                else begin
                    PaymentTerms.Get("Sales Cr.Memo Header"."Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Sales Cr.Memo Header"."Language Code");
                end;
                if "Sales Cr.Memo Header"."Payment Method Code" = '' then
                    PaymentMethod.Init
                else
                    PaymentMethod.Get("Sales Cr.Memo Header"."Payment Method Code");
                GiroNoCaptionVar := CompanyInfoGiroNoCaptionLbl;
                BankNameCaptionVar := CompanyInfoBankNameCaptionLbl;
                AGCaptionVar := AGCaptionLbl;
                DCCaptionVar := DCCaptionLbl;
                CCCBankNo := CustBankAccount."CCC Bank No.";
                CCCBankBranchNo := CustBankAccount."CCC Bank Branch No.";
                CCCControlDigits := CustBankAccount."CCC Control Digits";
                CodeIBAN := CustBankAccount.Iban;
                if PaymentMethod.Code <> '' then
                    if SalesSetup."Transfer Payment Method" = PaymentMethod.Code then begin
                        if not BankAccount.Get(Cust."Collection Bank Account") then Clear(BankAccount);
                        CCCBankNo := BankAccount."CCC Bank No.";
                        CCCBankBranchNo := BankAccount."CCC Bank Branch No.";
                        CCCControlDigits := BankAccount."CCC Control Digits";
                        CodeIBAN := BankAccount.Iban;
                    end;
                if "Sales Cr.Memo Header"."Applies-to Doc. No." = '' then
                    AppliedToText := ''
                else
                    AppliedToText := StrSubstNo(Text003, "Sales Cr.Memo Header"."Applies-to Doc. Type", "Sales Cr.Memo Header"."Applies-to Doc. No.");
                if "Sales Cr.Memo Header"."Shipment Method Code" = '' then
                    ShipmentMethod.Init
                else begin
                    ShipmentMethod.Get("Sales Cr.Memo Header"."Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Sales Cr.Memo Header"."Language Code");
                end;
                //ini - There is no argument given that corresponds to the required formal parameter 'SalesCrMemoHeader' of 'SalesCrMemoShipTo(var array[8] of Text[100], array[8] of Text[100], var Record "Sales Cr.Memo Header")'
                //FormatAddr.SalesCrMemoShipTo(ShipToAddr, "Sales Cr.Memo Header");
                FormatAddr.SalesCrMemoShipTo(ShipToAddr, CustAddr, "Sales Cr.Memo Header");
                //fin - There is no argument given that corresponds to the required formal parameter 'SalesCrMemoHeader' of 'SalesCrMemoShipTo(var array[8] of Text[100], array[8] of Text[100], var Record "Sales Cr.Memo Header")'
                ShowShippingAddr := "Sales Cr.Memo Header"."Sell-to Customer No." <> "Sales Cr.Memo Header"."Bill-to Customer No.";
                for i := 1 to ArrayLen(ShipToAddr) do if ShipToAddr[i] <> CustAddr[i] then ShowShippingAddr := true;
                ShowCashAccountingCriteria("Sales Cr.Memo Header");
                if LogInteraction then
                    if not CurrReport.Preview then
                        if "Sales Cr.Memo Header"."Bill-to Contact No." <> '' then
                            SegManagement.LogDocument(6, "Sales Cr.Memo Header"."No.", 0, 0, Database::Contact, "Sales Cr.Memo Header"."Bill-to Contact No.", "Sales Cr.Memo Header"."Salesperson Code", "Sales Cr.Memo Header"."Campaign No.", "Sales Cr.Memo Header"."Posting Description", '')
                        else
                            SegManagement.LogDocument(6, "Sales Cr.Memo Header"."No.", 0, 0, Database::Customer, "Sales Cr.Memo Header"."Sell-to Customer No.", "Sales Cr.Memo Header"."Salesperson Code", "Sales Cr.Memo Header"."Campaign No.", "Sales Cr.Memo Header"."Posting Description", '');

                //>> VAT PL
                Clear(vShowPLCurrencyExchange);
                vVATRegNo := '';
                if rlCustomer.Get("Sales Cr.Memo Header"."Bill-to Customer No.") then
                    if rlCustomer."VAT PL" then begin
                        vVATRegNoLbl := VATRegNoLbl;
                        rlGeneralLedgerSetup.Get();
                        vVATRegNo := rlGeneralLedgerSetup."PolishVAT Registration No.";

                        vShowPLCurrencyExchange := true;

                        vVATRegNoLbl := VATRegNoLbl;
                        rlGeneralLedgerSetup.Get();
                        vVATRegNo := rlGeneralLedgerSetup."PolishVAT Registration No.";
                        //if "Sales Invoice Header"."BBT PL Currency Exchange" = 0 then
                        fCheckNBPRates(CalcDate('-1D', "Sales Cr.Memo Header"."Posting Date"), "Sales Cr.Memo Header");
                    end;
                //<<
                "Sales Cr.Memo Header".CalcFields("Amount Including VAT");
                if rlCurrency.Get("Sales Cr.Memo Header"."Currency Code") then
                    EURLbl := ' ' + rlCurrency.Code
                else
                    EURLbl := ' EUR';
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
                        Visible = false;
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Log Interaction', comment = 'ESP="Log interacción"';
                        Enabled = LogInteractionEnable;
                    }
                }
            }
        }
        actions
        { }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Sales Cr. Memo") <> '';
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    { }

    trigger onPreReport()
    begin
        if not CurrReport.UseRequestPage then InitLogInteraction;
    end;

    trigger OnInitReport()
    begin
        GLSetup.Get;
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
        SalesSetup.Get;

        //>> BBT. 16/03/2026. Implantación de la extensión SMG.
        SMGEnable := cuSMGManagement.IsMarginEnabled();
        cuSMGManagement.InitializeMarginConfiguration(rSMGSetup);
        /*

        if not SMGEnable then begin
            if SalesSetup."Disc. 1 % Caption" <> '' then
                DiscLabel[1] := SalesSetup."Disc. 1 % Caption"
            else
                DiscLabel[1] := CopyStr("Sales Cr.Memo Line".FieldCaption("Discount 1 %"), 1, MaxStrLen(DiscLabel[1]));
            if SalesSetup."Disc. 2 % Caption" <> '' then
                DiscLabel[2] := SalesSetup."Disc. 2 % Caption"
            else
                DiscLabel[2] := CopyStr("Sales Cr.Memo Line".FieldCaption("Discount 2 %"), 1, MaxStrLen(DiscLabel[2]));
            if SalesSetup."Disc. 3 % Caption" <> '' then
                DiscLabel[3] := SalesSetup."Disc. 3 % Caption"
            else
                DiscLabel[3] := CopyStr("Sales Cr.Memo Line".FieldCaption("Discount 3 %"), 1, MaxStrLen(DiscLabel[3]));
            if SalesSetup."Disc. 4 % Caption" <> '' then
                DiscLabel[4] := SalesSetup."Disc. 4 % Caption"
            else
                DiscLabel[4] := CopyStr("Sales Cr.Memo Line".FieldCaption("Discount 4 %"), 1, MaxStrLen(DiscLabel[4]));
            if SalesSetup."Disc. 5 % Caption" <> '' then
                DiscLabel[5] := SalesSetup."Disc. 5 % Caption"
            else
                DiscLabel[5] := CopyStr("Sales Cr.Memo Line".FieldCaption("Discount 5 %"), 1, MaxStrLen(DiscLabel[5]));
        end
        else begin
        */
        //<<
        if (rSMGSetup."Discount 1 Enabled") and (rSMGSetup."Discount 1 Caption" <> '') then
            DiscLabel[1] := rSMGSetup."Discount 1 Caption"
        else
            DiscLabel[1] := CopyStr("Sales Cr.Memo Line".FieldCaption("SMG Discount 1 %"), 1, MaxStrLen(DiscLabel[1]));
        if (rSMGSetup."Discount 2 Enabled") and (rSMGSetup."Discount 2 Caption" <> '') then
            DiscLabel[2] := rSMGSetup."Discount 2 Caption"
        else
            DiscLabel[2] := CopyStr("Sales Cr.Memo Line".FieldCaption("SMG Discount 2 %"), 1, MaxStrLen(DiscLabel[2]));
        if (rSMGSetup."Discount 3 Enabled") and (rSMGSetup."Discount 3 Caption" <> '') then
            DiscLabel[3] := rSMGSetup."Discount 3 Caption"
        else
            DiscLabel[3] := CopyStr("Sales Cr.Memo Line".FieldCaption("SMG Discount 3 %"), 1, MaxStrLen(DiscLabel[3]));
        if (rSMGSetup."Discount 4 Enabled") and (rSMGSetup."Discount 4 Caption" <> '') then
            DiscLabel[4] := rSMGSetup."Discount 4 Caption"
        else
            DiscLabel[4] := CopyStr("Sales Cr.Memo Line".FieldCaption("SMG Discount 4 %"), 1, MaxStrLen(DiscLabel[4]));
        if (rSMGSetup."Discount 5 Enabled") and (rSMGSetup."Discount 5 Caption" <> '') then
            DiscLabel[5] := rSMGSetup."Discount 5 Caption"
        else
            DiscLabel[5] := CopyStr("Sales Cr.Memo Line".FieldCaption("SMG Discount 5 %"), 1, MaxStrLen(DiscLabel[5]));
        //end;

        //I. INC-2018-05-93291
        //PageLines  := 30;
        PageLines := 27;
        //F. INC-2018-05-93291
    end;

    var
        //>> BBT. SMG Extension.
        cuSMGManagement: Codeunit "SMG Management";
        rSMGSetup: Record "SMG Setup";
        SMGEnable: Boolean;
        //<<
        rlCustomer: Record Customer;
        EURLbl: Text;
        PLNLbl: Label ' PLN';
        Text000: label 'Salesperson', Comment = 'ESP="Representante"';
        Text001: label 'Total %1', Comment = 'ESP="Total %1"';
        vVATRegNo: Text;
        Text002: label 'Total %1 Incl. VAT', Comment = 'ESP="Total %1 IVA incl."';
        Text003: label '(Applies to %1 %2)', comment = 'ESP="(Liq. por %1 %2)"';
        PageCaptionCap: label 'Page %1 of %2', comment = 'ESP="Página %1 de %2"';
        Text007: label 'Total %1 Excl. VAT', comment = 'ESP="Total %1 IVA excl."';
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        CompanyInfo: Record "Company Information";
        VATAmountLine: Record "VAT Amount Line" temporary;
        VATClause: Record "VAT Clause";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        //ini - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
        //Language: Record Language;
        cLanguage: Codeunit Language;
        //fin - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
        SalesShipmentBuffer: Record "Sales Shipment Buffer" temporary;
        CurrExchRate: Record "Currency Exchange Rate";
        Cust: Record Customer;
        SalesCrMemoCountPrinted: Codeunit "Sales Cr. Memo-Printed";
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        RespCenter: Record "Responsibility Center";
        SalesCrMemoLineBuffer: Record "Sales Cr.Memo Line" temporary;
        CustBankAccount: Record "Customer Bank Account";
        BankAccount: Record "Bank Account";
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        ReturnOrderNoText: Text[80];
        SalesPersonText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        AppliedToText: Text;
        TotalText: Text[50];
        vVATRegNoLbl: Text;
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        i: Integer;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        FirstValueEntryNo: Integer;
        PostedReceiptDate: Date;
        NextEntryNo: Integer;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        Text008: label 'VAT Amount Specification in ', comment = 'ESP="Especificar importe IVA en "';
        Text009: label 'Local Currency', comment = 'ESP="Divisa local"';
        Text010: label 'Exchange rate: %1/%2', comment = 'ESP="Tipo cambio: %1/%2"';
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        CalculatedExchRate: Decimal;
        OutputNo: Integer;
        NNC_TotalLineAmount: Decimal;
        NNC_TotalAmountInclVat: Decimal;
        NNC_TotalInvDiscAmount: Decimal;
        NNC_TotalAmount: Decimal;
        VATPostingSetup: Record "VAT Posting Setup";
        Text1100001: label 'Sales - Corrective invoice %1', comment = 'ESP="Ventas - Factura correctiva %1"';
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        TotalGivenAmount: Decimal;
        TotalPaymentDiscountOnVAT: Decimal;
        PaymentMethod: Record "Payment Method";
        LogInteractionEnable: Boolean;
        CompanyInfoPhoneNoCaptionLbl: label 'Phone', comment = 'ESP="Tel."';
        CompanyInfoHomePageCaptionLbl: label 'Home Page', comment = 'ESP="Página Web"';
        CompanyInfoEMailCaptionLbl: label 'E-Mail', comment = 'ESP="Correo electrónico"';
        CompanyInfoVATRegistrationNoCaptionLbl: label 'NIF', comment = 'ESP="NIF"';
        CompanyInfoGiroNoCaptionLbl: label 'Domiciliación';
        CompanyInfoBankNameCaptionLbl: label 'Bank', comment = 'ESP="C. Ban"';
        CompanyInfoBankAccountNoCaptionLbl: label 'Account No.', comment = 'ESP="Cuenta corriente"';
        SalesCrMemoHeaderNoCaptionLbl: label 'Credit Memo', comment = 'ESP="Abono"';
        SalesCrMemoHeaderPostingDateCaptionLbl: label 'Cr. Memo Date', comment = 'ESP="Fecha abono"';
        CorrectedInvoiceNoCaptionLbl: label 'Corrected Invoice No.', comment = 'ESP="Nº factura corregida"';
        DocumentDateCaptionLbl: label 'Document Date', comment = 'ESP="Fecha emisión documento"';
        HeaderDimensionsCaptionLbl: label 'Header Dimensions', comment = 'ESP="Dimensiones cabecera"';
        UnitPriceCaptionLbl: label 'Tarif Price', comment = 'ESP="Precio tarifa"';
        SalesCrMemoLineLineDiscountCaptionLbl: label 'Disc.', comment = 'ESP="Dto."';
        AmtCaptionLbl: label 'Amount', comment = 'ESP="Neto Línea"';
        PostedReceiptDateCaptionLbl: label 'Posted Return Receipt Date', comment = 'ESP="Fecha recepción devolución registrada"';
        InvDiscountAmountCaptionLbl: label 'Invoice Discount Amount', comment = 'ESP="Importe descuento factura"';
        SubtotalCaptionLbl: label 'Subtotal', comment = 'ESP="Subtotal"';
        PmtDiscGivenAmountCaptionLbl: label 'Payment Discount Received Amount', comment = 'ESP="Importe recibido descuento pago"';
        ReturnReceiptCaptionLbl: label 'Return Receipt', comment = 'ESP="Recepción de devolución"';
        VATClausesCap: label 'VAT Clause', comment = 'ESP="Cláusula de IVA"';
        LineDimensionsCaptionLbl: label 'Line Dimensions', comment = 'ESP="Dimensiones línea"';
        VATAmountLineVATCaptionLbl: label 'VAT %', comment = 'ESP="% IVA"';
        VATAmountLineVATECBaseControl105CaptionLbl: label 'VAT Base', comment = 'ESP="Base Imponible"';
        VATAmountLineVATAmountControl106CaptionLbl: label 'VAT Amt.', comment = 'ESP="Cuota IVA"';
        VATAmountSpecificationCaptionLbl: label 'VAT Amount Specification', comment = 'ESP="Especificación importe IVA"';
        VATAmountLineVATIdentifierCaptionLbl: label 'VAT Identifier', comment = 'ESP="Identific. IVA"';
        VATAmountLineInvDiscBaseAmountControl130CaptionLbl: label 'Invoice Discount Base Amount', comment = 'ESP="Importe base descuento factura"';
        VATAmountLineLineAmountControl135CaptionLbl: label 'Line Amount', comment = 'ESP="Importe línea"';
        InvandPmtDiscountsCaptionLbl: label 'Invoice and Payment Discounts', comment = 'ESP="Descuentos facturas y pagos"';
        ECCaptionLbl: label 'EC %', comment = 'ESP="% REC. EQ."';
        ECAmountCaptionLbl: label 'EC Amount', comment = 'ESP="Recargo"';
        VATAmountLineVATECBaseControl113CaptionLbl: label 'Total', comment = 'ESP="Total';
        ShiptoAddressCaptionLbl: label 'Ship-to Address', comment = 'ESP="Dirección de envío"';
        CACCaptionLbl: Text;
        PmtTermsDescCaptionLbl: label 'Payment Terms', comment = 'ESP="Términos pago"';
        ShpMethodDescCaptionLbl: label 'Shipment Method', comment = 'ESP="Condiciones envío"';
        PmtMethodDescCaptionLbl: label 'Payment Method', comment = 'ESP="Forma de pago"';
        DocDateCaptionLbl: label 'Document Date', comment = 'ESP="Fecha emisión documento"';
        HomePageCaptionCap: label 'Home Page', comment = 'ESP="Página Web"';
        EmailCaptionLbl: label 'E-Mail', comment = 'ESP="Correo electrónico"';
        CACTxt: label 'Régimen especial del criterio de caja';
        CompanyInfoCountryLbl: label 'Spain';
        CustOurAccountNoCaptionLbl: label 'Vendor', comment = 'ESP="Proveedor"';
        ItemNoCaptionLbl: label 'Item', comment = 'ESP="Art."';
        EANCaptionLbl: label 'EAN';
        UnitsCaptionLbl: label 'Units', comment = 'ESP="Uds."';
        ReportPrintedLines: Integer;
        PageLines: Integer;
        BlankLines: Integer;
        TotalRepLines: Integer;
        DocLineNo: Integer;
        ContLine: Integer;
        VATRegNoLbl: Label 'VAT REGISTRATION NO. ';
        DiscLabel: array[5] of Text[30];
        TotalDiscCaptionLbl: label 'Total Discount', comment = 'ESP="Total Descuento"';
        NetUnitCaptionLbl: label 'Net Unit', comment = 'ESP="Neto Unitario"';
        DiccountsCaptionLbl: label 'Discounts', comment = 'ESP="Descuentos"';
        SimbPctCaptionLbl: label '%';
        AmountsCaptionLbl: label 'Amounts', comment = 'ESP="Importes"';
        DiscPctCaptionLbl: label 'Disc. %', comment = 'ESP="% Dto."';
        DiscAmtCaptionLbl: label 'Disc. Amt.', comment = 'ESP="Cuota Dto"';
        PaymentDiscPctCaptionLbl: label 'D.P. %', comment = 'ESP="% P.P."';
        PDAmtCaptionLbl: label 'D.P. Amt.', comment = 'ESP="Cuota P.P."';
        ECCAmtCaptionLbl: label 'EC Amt.', comment = 'ESP="Cuota EQ."';
        TotalInvCaptionLbl: label 'Total Invoice', comment = 'ESP="Total Factura"';
        ObservationsCaptionLbl: label 'Observations', comment = 'ESP="Observaciones"';
        AGCaptionLbl: label 'AG';
        DCCaptionLbl: label 'DC';
        DueDateCaptionLbl: label 'Due Date', comment = 'ESP="Vto."';
        ReferenceCaptionLbl: label 'Reference', comment = 'ESP="Referencia"';
        AmCaptionLbl: label 'Amount', comment = 'ESP="Importe"';
        CRCaptionLbl: label 'Coste reciclado RD 106/2008 de reciclado de pilas y baterias';
        FooterText1: label 'Para toda cuestion derivada de esta compra venta las partes se someten expresamente a la jurisdiccion de los juzgados y tribunales de Barcelona, con renuncia expresa a su propio fuero.';
        FooterText2: label 'Ambas partes se comprometen a cumplir con sus respectivas obligaciones legales en relación a los residuos de los envases de tipo comercial o doméstico parte de este acuerdo y en especial en cuanto del Artículo 18 del RD 782/1998.';
        LOPDtxt: Text;
        NetoUnit: Decimal;
        CodeIBAN: Code[50];
        GiroNoCaptionVar: Text[30];
        BankNameCaptionVar: Text[10];
        AGCaptionVar: Text[2];
        DCCaptionVar: Text[2];
        CCCBankNo: Text[4];
        CCCBankBranchNo: Text[4];
        CCCControlDigits: Text[2];

        CurrencyText: Code[10];
        FormatDocument: Codeunit "Format Document";
        vShowPLCurrencyExchange: Boolean;
        vRate: Decimal;
        Filler: Text;
        VATPlnLbl: Label 'VAT Amount Specification in PLN', Comment = 'ESP="Importe IVA en PLN"';
        VATPln2Lbl: Label 'EXCHANGE RATE', Comment = 'ESP="TIPO DE CAMBIO"';
        VATAmtLineVATCaptionLbl: label 'VAT %', comment = 'ESP="% IVA"';
        VATECBaseCaptionLbl: label 'VAT BASE', comment = 'ESP="BASE IMPONIBLE"';
        VATAmountCaptionLbl: label 'VAT AMT.', comment = 'ESP="CUOTA IVA"';

    procedure fCheckNBPRates(pPostingDate: Date; var pSalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        JsonResponse: Text;
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        JsonArray: JsonArray;
        JsonValue: JsonValue;
        ApiUrl: Text;
        RequestHeaders: HttpHeaders;
        DateText: Text;
        rlDataExchLineDef: Record "Data Exch. Line Def";
        Divisa: Code[10];
    begin
        DateText := Format(pPostingDate, 0, '<Year4>-<Month,2>-<Day,2>');
        Divisa := pSalesCrMemoHeader."Currency Code";
        if pSalesCrMemoHeader."Currency Code" = '' then
            Divisa := 'EUR';
        rlDataExchLineDef.Reset();
        if rlDataExchLineDef.Get('NBP', 'NBP') then ApiUrl := rlDataExchLineDef."Data Line Tag" + Divisa + '/' + DateText + '/';
        //   ApiUrl := 'https://api.nbp.pl/api/exchangerates/rates/A/EUR/' + DateText + '/';
        // Añadir encabezado "Accept: application/json"
        RequestHeaders := HttpClient.DefaultRequestHeaders();
        RequestHeaders.Add('Accept', 'application/json');
        // Realizar la solicitud GET
        if HttpClient.Get(ApiUrl, HttpResponseMessage) then begin
            if HttpResponseMessage.IsSuccessStatusCode() then begin
                // Leer el contenido de la respuesta como texto
                HttpResponseMessage.Content().ReadAs(JsonResponse);
                // Cargar el JSON en un objeto JsonObject
                JsonObject.ReadFrom(JsonResponse);
                // Acceder al array 'rates' en la respuesta JSON
                if JsonObject.Get('rates', JsonToken) then begin
                    // Convertir JsonToken a JsonArray
                    JsonArray := JsonToken.AsArray();
                    // Acceder al primer objeto dentro del array usando JsonToken
                    if JsonArray.Count() > 0 then begin
                        JsonArray.Get(0, JsonToken); // Obtiene el primer elemento del array
                        // Convertir el JsonToken a un JsonObject
                        if JsonToken.IsObject() then begin
                            JsonObject := JsonToken.AsObject();
                            // Obtener el valor de la tasa de cambio media ('mid')
                            if JsonObject.Get('mid', JsonToken) then begin
                                vRate := JsonToken.AsValue().AsDecimal();
                                pSalesCrMemoHeader."BBT PL Currency Exchange" := vRate;
                                pSalesCrMemoHeader.Modify();
                            end
                            else
                                Error('No se pudo obtener el valor de la tasa de cambio');
                        end
                        else
                            Error('El primer elemento del array no es un objeto JSON');
                    end
                    else
                        Error('El array de tasas está vacío');
                end
                else
                    Error('No se pudo obtener el array "rates" del JSON');
            end
            else begin
                //>> En caso de error buscamos el primer dia con cambio.
                fCheckNBPRates(CalcDate('-1D', pPostingDate), "Sales Cr.Memo Header");
                //<<
            end;
        end;
    end;

    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Sales Cr. Memo") <> '';
    end;

    local procedure FindPostedShipmentDate(): Date
    var
        ReturnReceiptHeader: Record "Return Receipt Header";
        SalesShipmentBuffer2: Record "Sales Shipment Buffer" temporary;
    begin
        NextEntryNo := 1;
        if "Sales Cr.Memo Line"."Return Receipt No." <> '' then if ReturnReceiptHeader.Get("Sales Cr.Memo Line"."Return Receipt No.") then exit(ReturnReceiptHeader."Posting Date");
        if "Sales Cr.Memo Header"."Return Order No." = '' then exit("Sales Cr.Memo Header"."Posting Date");
        case "Sales Cr.Memo Line".Type of
            "Sales Cr.Memo Line".Type::Item:
                GenerateBufferFromValueEntry("Sales Cr.Memo Line");
            "Sales Cr.Memo Line".Type::"G/L Account", "Sales Cr.Memo Line".Type::Resource, "Sales Cr.Memo Line".Type::"Charge (Item)", "Sales Cr.Memo Line".Type::"Fixed Asset":
                GenerateBufferFromShipment("Sales Cr.Memo Line");
            "Sales Cr.Memo Line".Type::" ":
                exit(0D);
        end;
        SalesShipmentBuffer.Reset;
        SalesShipmentBuffer.SetRange("Document No.", "Sales Cr.Memo Line"."Document No.");
        SalesShipmentBuffer.SetRange("Line No.", "Sales Cr.Memo Line"."Line No.");
        if SalesShipmentBuffer.Find('-') then begin
            SalesShipmentBuffer2 := SalesShipmentBuffer;
            if SalesShipmentBuffer.Next = 0 then begin
                SalesShipmentBuffer.Get(SalesShipmentBuffer2."Document No.", SalesShipmentBuffer2."Line No.", SalesShipmentBuffer2."Entry No.");
                SalesShipmentBuffer.Delete;
                exit(SalesShipmentBuffer2."Posting Date");
            end;
            SalesShipmentBuffer.CalcSums(Quantity);
            if SalesShipmentBuffer.Quantity <> "Sales Cr.Memo Line".Quantity then begin
                SalesShipmentBuffer.DeleteAll;
                exit("Sales Cr.Memo Header"."Posting Date");
            end;
        end
        else
            exit("Sales Cr.Memo Header"."Posting Date");
    end;

    local procedure GenerateBufferFromValueEntry(SalesCrMemoLine2: Record "Sales Cr.Memo Line")
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := SalesCrMemoLine2."Quantity (Base)";
        ValueEntry.SetCurrentkey("Document No.");
        ValueEntry.SetRange("Document No.", SalesCrMemoLine2."Document No.");
        ValueEntry.SetRange("Posting Date", "Sales Cr.Memo Header"."Posting Date");
        ValueEntry.SetRange("Item Charge No.", '');
        ValueEntry.SetFilter("Entry No.", '%1..', FirstValueEntryNo);
        if ValueEntry.Find('-') then
            repeat
                if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
                    if SalesCrMemoLine2."Qty. per Unit of Measure" <> 0 then
                        Quantity := ValueEntry."Invoiced Quantity" / SalesCrMemoLine2."Qty. per Unit of Measure"
                    else
                        Quantity := ValueEntry."Invoiced Quantity";
                    AddBufferEntry(SalesCrMemoLine2, -Quantity, ItemLedgerEntry."Posting Date");
                    TotalQuantity := TotalQuantity - ValueEntry."Invoiced Quantity";
                end;
                FirstValueEntryNo := ValueEntry."Entry No." + 1;
            until (ValueEntry.Next = 0) or (TotalQuantity = 0);
    end;

    local procedure GenerateBufferFromShipment(SalesCrMemoLine: Record "Sales Cr.Memo Line")
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine2: Record "Sales Cr.Memo Line";
        ReturnReceiptHeader: Record "Return Receipt Header";
        ReturnReceiptLine: Record "Return Receipt Line";
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := 0;
        SalesCrMemoHeader.SetCurrentkey("Return Order No.");
        SalesCrMemoHeader.SetFilter("No.", '..%1', "Sales Cr.Memo Header"."No.");
        SalesCrMemoHeader.SetRange("Return Order No.", "Sales Cr.Memo Header"."Return Order No.");
        if SalesCrMemoHeader.Find('-') then
            repeat
                SalesCrMemoLine2.SetRange("Document No.", SalesCrMemoHeader."No.");
                SalesCrMemoLine2.SetRange("Line No.", SalesCrMemoLine."Line No.");
                SalesCrMemoLine2.SetRange(Type, SalesCrMemoLine.Type);
                SalesCrMemoLine2.SetRange("No.", SalesCrMemoLine."No.");
                SalesCrMemoLine2.SetRange("Unit of Measure Code", SalesCrMemoLine."Unit of Measure Code");
                if SalesCrMemoLine2.Find('-') then
                    repeat
                        TotalQuantity := TotalQuantity + SalesCrMemoLine2.Quantity;
                    until SalesCrMemoLine2.Next = 0;
            until SalesCrMemoHeader.Next = 0;
        ReturnReceiptLine.SetCurrentkey("Return Order No.", "Return Order Line No.");
        ReturnReceiptLine.SetRange("Return Order No.", "Sales Cr.Memo Header"."Return Order No.");
        ReturnReceiptLine.SetRange("Return Order Line No.", SalesCrMemoLine."Line No.");
        ReturnReceiptLine.SetRange("Line No.", SalesCrMemoLine."Line No.");
        ReturnReceiptLine.SetRange(Type, SalesCrMemoLine.Type);
        ReturnReceiptLine.SetRange("No.", SalesCrMemoLine."No.");
        ReturnReceiptLine.SetRange("Unit of Measure Code", SalesCrMemoLine."Unit of Measure Code");
        ReturnReceiptLine.SetFilter(Quantity, '<>%1', 0);
        if ReturnReceiptLine.Find('-') then
            repeat
                if "Sales Cr.Memo Header"."Get Return Receipt Used" then CorrectShipment(ReturnReceiptLine);
                if Abs(ReturnReceiptLine.Quantity) <= Abs(TotalQuantity - SalesCrMemoLine.Quantity) then
                    TotalQuantity := TotalQuantity - ReturnReceiptLine.Quantity
                else begin
                    if Abs(ReturnReceiptLine.Quantity) > Abs(TotalQuantity) then ReturnReceiptLine.Quantity := TotalQuantity;
                    Quantity := ReturnReceiptLine.Quantity - (TotalQuantity - SalesCrMemoLine.Quantity);
                    SalesCrMemoLine.Quantity := SalesCrMemoLine.Quantity - Quantity;
                    TotalQuantity := TotalQuantity - ReturnReceiptLine.Quantity;
                    if ReturnReceiptHeader.Get(ReturnReceiptLine."Document No.") then AddBufferEntry(SalesCrMemoLine, -Quantity, ReturnReceiptHeader."Posting Date");
                end;
            until (ReturnReceiptLine.Next = 0) or (TotalQuantity = 0);
    end;

    local procedure CorrectShipment(var ReturnReceiptLine: Record "Return Receipt Line")
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        SalesCrMemoLine.SetCurrentkey("Return Receipt No.", "Return Receipt Line No.");
        SalesCrMemoLine.SetRange("Return Receipt No.", ReturnReceiptLine."Document No.");
        SalesCrMemoLine.SetRange("Return Receipt Line No.", ReturnReceiptLine."Line No.");
        if SalesCrMemoLine.Find('-') then
            repeat
                ReturnReceiptLine.Quantity := ReturnReceiptLine.Quantity - SalesCrMemoLine.Quantity;
            until SalesCrMemoLine.Next = 0;
    end;

    local procedure AddBufferEntry(SalesCrMemoLine: Record "Sales Cr.Memo Line"; QtyOnShipment: Decimal; PostingDate: Date)
    begin
        SalesShipmentBuffer.SetRange("Document No.", SalesCrMemoLine."Document No.");
        SalesShipmentBuffer.SetRange("Line No.", SalesCrMemoLine."Line No.");
        SalesShipmentBuffer.SetRange("Posting Date", PostingDate);
        if SalesShipmentBuffer.Find('-') then begin
            SalesShipmentBuffer.Quantity := SalesShipmentBuffer.Quantity - QtyOnShipment;
            SalesShipmentBuffer.Modify;
            exit;
        end;
        begin
            SalesShipmentBuffer.Init;
            SalesShipmentBuffer."Document No." := SalesCrMemoLine."Document No.";
            SalesShipmentBuffer."Line No." := SalesCrMemoLine."Line No.";
            SalesShipmentBuffer."Entry No." := NextEntryNo;
            SalesShipmentBuffer.Type := SalesCrMemoLine.Type;
            SalesShipmentBuffer."No." := SalesCrMemoLine."No.";
            SalesShipmentBuffer.Quantity := -QtyOnShipment;
            SalesShipmentBuffer."Posting Date" := PostingDate;
            SalesShipmentBuffer.Insert;
            NextEntryNo := NextEntryNo + 1
        end;
    end;

    procedure ShowCashAccountingCriteria(SalesCrMemoHeader: Record "Sales Cr.Memo Header"): Text
    var
        VATEntry: Record "VAT Entry";
    begin
        GLSetup.Get;
        if not GLSetup."Unrealized VAT" then exit;
        CACCaptionLbl := '';
        VATEntry.SetRange("Document No.", SalesCrMemoHeader."No.");
        VATEntry.SetRange("Document Type", VATEntry."document type"::"Credit Memo");
        if VATEntry.FindSet then
            repeat
                if VATEntry."VAT Cash Regime" then CACCaptionLbl := CACTxt;
            until (VATEntry.Next = 0) or (CACCaptionLbl <> '');
        exit(CACCaptionLbl);
    end;

    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
    end;

    local procedure CalculateBlankLines(PrintedLines: Integer): Integer
    var
        i: Integer;
    begin
        i := 1;
        while (PageLines * i < PrintedLines) do i += 1;
        exit(PageLines * i - PrintedLines);
    end;
}
