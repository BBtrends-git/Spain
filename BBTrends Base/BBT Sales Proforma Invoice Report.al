Report 50001 "Sales - Proforma Invoice"
{
    // //INC-2019-01-105854 : Mostrar pie Protección de datos
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/Sales - Proforma Invoice.rdl';
    Caption = 'Order Confirmation', comment = 'ESP="Confirmación pedido"';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(CompanyLogo; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            column(ReportForNavId_1100234005; 1100234005)
            { }
            column(CompanyInfo1Picture; CompanyInfo.Picture)
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
            column(CompanyInfoHomePage; CompanyInfo."Home Page")
            { }
            column(CompanyInfoEmail; CompanyInfo."E-Mail")
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
        }
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Sales Order', comment = 'ESP="Pedido venta"';

            column(ReportForNavId_6640; 6640)
            { }
            column(PaymentTermsDescription; PaymentTerms.Description)
            { }
            column(ShipmentMethodDescription; ShipmentMethod.Description)
            { }
            column(PaymentMethodDescription; PaymentMethod.Description)
            { }
            column(DocType_SalesHeader; "Sales Header"."Document Type")
            { }
            column(No_SalesHeader; "Sales Header"."No.")
            { }
            column(PaymentTermsCaption; PaymentTermsCaptionLbl)
            { }
            column(ShipmentMethodCaption; ShipmentMethodCaptionLbl)
            { }
            column(PaymentMethodCaption; PaymentMethodCaptionLbl)
            { }
            column(HomePageCaption; HomePageCaptionCap)
            { }
            column(EmailCaption; EmailCaptionLbl)
            { }
            column(DocumentDateCaption; DocumentDateCaptionLbl)
            { }
            column(AllowInvDiscCaption; AllowInvDiscCaptionLbl)
            { }
            column(TotalLinCaption; TotalLinCaptionLbl)
            { }
            column(TotalAmountCaption; TotalAmountCaptionLbl)
            { }
            column(SignatureCaption; SignatureCaptionLbl)
            { }
            column(CompanyInfoCountry; CompanyInfoCountryLbl)
            { }
            column(PageLines; PageLines)
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
                    column(SalesHeaderCopyText; CopyText)
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
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    { }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    { }
                    column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.")
                    { }
                    column(CompanyInfoVATRegistrationNo; CompanyInfo."VAT Registration No.")
                    { }
                    column(BilltoCustNo_SalesHeader; "Sales Header"."Bill-to Customer No.")
                    { }
                    column(DocDate_SalesHeader; "Sales Header"."Document Date")
                    { }
                    column(VATNoText; VATNoText)
                    { }
                    column(VATRegNo_SalesHeader; "Sales Header"."VAT Registration No.")
                    { }
                    column(ShipmentDate_SalesHeader; Format("Sales Header"."Shipment Date"))
                    { }
                    column(SalesPersonText; SalesPersonText)
                    { }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    { }
                    column(SalesHeaderNo1; "Sales Header"."No.")
                    { }
                    column(ReferenceText; ReferenceText)
                    { }
                    column(YourRef_SalesHeader; "Sales Header"."Your Reference")
                    { }
                    column(CustAddr7; CustAddr[7])
                    { }
                    column(CustAddr8; CustAddr[8])
                    { }
                    column(CompanyAddr5; CompanyAddr[5])
                    { }
                    column(CompanyAddr6; CompanyAddr[6])
                    { }
                    column(PricesIncludVAT_SalesHeader; "Sales Header"."Prices Including VAT")
                    { }
                    column(PageCaption; PageCaptionCap)
                    { }
                    column(OutputNo; OutputNo)
                    { }
                    column(PricesInclVATYesNo_SalesHeader; Format("Sales Header"."Prices Including VAT"))
                    { }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    { }
                    column(VATRegNoCaption; VATRegNoCaptionLbl)
                    { }
                    column(GiroNoCaption; GiroNoCaptionVar)
                    { }
                    column(BankNameCaption; BankNameCaptionVar)
                    { }
                    column(AGCaption; AGCaptionVar)
                    { }
                    column(DCCaption; DCCaptionVar)
                    { }
                    column(CCC_Bank_No_CustBankAccount; CCCBankNo)
                    { }
                    column(CCC_Bank_Branch_No_CustBankAccount; CCCBankBranchNo)
                    { }
                    column(CCC_Control_Digits_CustBankAccount; CCCControlDigits)
                    { }
                    column(IBAN_CustBankAccount; CodeIBAN)
                    { }
                    column(BankAccountNoCaption; BankAccountNoCaptionLbl)
                    { }
                    column(ShipmentDateCaption; ShipmentDateCaptionLbl)
                    { }
                    column(OrderNoCaption; OrderNoCaptionLbl)
                    { }
                    column(BilltoCustNo_SalesHeaderCaption; CustomerNbrCaptionLbl)
                    { }
                    column(PricesIncludVAT_SalesHeaderCaption; "Sales Header".FieldCaption("Prices Including VAT"))
                    { }
                    column(CACCaption; CACCaptionLbl)
                    { }
                    column(NoOfCopies; Abs(NoOfCopies))
                    { }
                    column(NoOfCopiesCaption; NoOfCopiesCaptionLlb)
                    { }
                    column(CopyText; CopyText)
                    { }
                    column(CurrencyCode; "Sales Header"."Currency Code")
                    { }
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                        column(ReportForNavId_7574; 7574)
                        { }
                        column(DimText_DimLoop1; DimText)
                        { }
                        column(Number_DimLoop1; DimensionLoop1.Number)
                        { }
                        column(HeaderDimensionsCaption; HeaderDimensionsCaptionLbl)
                        { }
                        trigger OnAfterGetRecord()
                        begin
                            if DimensionLoop1.Number = 1 then begin
                                if not DimSetEntry1.Find('-') then CurrReport.Break;
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
                    dataitem("Sales Line"; "Sales Line")
                    {
                        DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                        column(ReportForNavId_2844; 2844)
                        { }
                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break;
                        end;
                    }
                    dataitem(RoundLoop; "Integer")
                    {
                        DataItemTableView = sorting(Number);

                        column(ReportForNavId_7551; 7551)
                        { }
                        column(LineAmt_SalesLine; SalesLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Desc_SalesLine; "Sales Line".Description)
                        { }
                        column(NNCSalesLineLineAmt; NNC_SalesLineLineAmt)
                        { }
                        column(NNCSalesLineInvDiscAmt; NNC_SalesLineInvDiscAmt)
                        { }
                        column(NNCTotalExclVAT; NNC_TotalExclVAT)
                        { }
                        column(NNCVATAmt; NNC_VATAmt)
                        { }
                        column(NNCPmtDiscOnVAT; NNC_PmtDiscOnVAT)
                        { }
                        column(NNCTotalInclVAT2; NNC_TotalInclVAT2)
                        { }
                        column(NNCVatAmt2; NNC_VatAmt2)
                        { }
                        column(NNCTotalExclVAT2; NNC_TotalExclVAT2)
                        { }
                        column(VATBaseDisc_SalesHeader; "Sales Header"."VAT Base Discount %")
                        { }
                        column(AsmInfoExistsForLine; AsmInfoExistsForLine)
                        { }
                        column(No2_SalesLine; "Sales Line"."No.")
                        { }
                        column(Qty_SalesLine; "Sales Line".Quantity)
                        { }
                        column(UOM_SalesLine; "Sales Line"."Unit of Measure Code")
                        { }
                        column(UnitPrice_SalesLine; "Sales Line"."Unit Price")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(LineDisc_SalesLine; "Sales Line"."Line Discount %")
                        { }
                        column(LineAmt1_SalesLine; "Sales Line"."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(AllowInvDisc_SalesLine; "Sales Line"."Allow Invoice Disc.")
                        { }
                        column(VATIdentifier_SalesLine; "Sales Line"."VAT Identifier")
                        { }
                        column(Type_SalesLine; Format("Sales Line".Type))
                        { }
                        column(No1_SalesLine; "Sales Line"."Line No.")
                        { }
                        column(AllowInvDisYesNo_SalesLine; Format("Sales Line"."Allow Invoice Disc."))
                        { }
                        column(SalesLineInvDiscAmt; SalesLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //ini - 'Record "Sales Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                        // column(SalesLineLineAmtInvDiscAmt;-SalesLine."Pmt. Disc. Given Amount")
                        // {
                        //     AutoFormatExpression = "Sales Header"."Currency Code";
                        //     AutoFormatType = 1;
                        // }
                        column(SalesLineLineAmtInvDiscAmt; -SalesLine."Pmt. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //fin - 'Record "Sales Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                        column(NNCPmtDiscGivenAmount; NNC_PmtDiscGivenAmount)
                        { }
                        //ini - 'Record "Sales Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                        // column(SalesLinePmtDiscGivenAmt;SalesLine."Pmt. Disc. Given Amount")
                        // {
                        // }
                        column(SalesLinePmtDiscGivenAmt; SalesLine."Pmt. Discount Amount")
                        { }
                        //fin - 'Record "Sales Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                        column(TotalExclVATText; TotalExclVATText)
                        { }
                        column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText)
                        { }
                        column(TotalInclVATText; TotalInclVATText)
                        { }
                        column(VATAmount; VATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //ini - 'Record "Sales Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                        // column(SalesLineLAmtInvDiscAmtVATAmt;SalesLine."Line Amount" - SalesLine."Inv. Discount Amount" - SalesLine."Pmt. Disc. Given Amount" + VATAmount)
                        // {
                        //     AutoFormatExpression = "Sales Header"."Currency Code";
                        //     AutoFormatType = 1;
                        // }
                        column(SalesLineLAmtInvDiscAmtVATAmt; SalesLine."Line Amount" - SalesLine."Inv. Discount Amount" - SalesLine."Pmt. Discount Amount" + VATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //fin - 'Record "Sales Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                        column(VATDiscountAmount; -VATDiscountAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseAmount; VATBaseAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmountInclVAT; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        { }
                        column(DiscountCaption; DiscountCaptionLbl)
                        { }
                        column(AmountCaption; AmountCaptionLbl)
                        { }
                        column(InvDiscAmtCaption; InvDiscAmtCaptionLbl)
                        { }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        { }
                        column(PmtDiscGivenAmtCaption; PmtDiscGivenAmtCaptionLbl)
                        { }
                        column(PaymentDiscVATCaption; PaymentDiscVATCaptionLbl)
                        { }
                        column(Desc_SalesLineCaption; "Sales Line".FieldCaption(Description))
                        { }
                        column(No_SalesLineCaption; No_SalesLineCaptionLbl)
                        { }
                        column(Qty_SalesLineCaption; "Sales Line".FieldCaption(Quantity))
                        { }
                        column(UOM_SalesLineCaption; UOM_SalesLineCaptionLbl)
                        { }
                        column(AllowInvDisc_SalesLineCaption; "Sales Line".FieldCaption("Allow Invoice Disc."))
                        { }
                        column(VATIdentifier_SalesLineCaption; "Sales Line".FieldCaption("VAT Identifier"))
                        { }
                        column(ReportPrintedLines; ReportPrintedLines)
                        { }
                        column(ContPrintedLines; ContPrintedLines)
                        { }
                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                            column(ReportForNavId_3591; 3591)
                            { }
                            column(DimText_DimLoop2; DimText)
                            { }
                            column(LineDimensionsCaption; LineDimensionsCaptionLbl)
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
                                        DimText := StrSubstNo('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText := StrSubstNo('%1, %2 %3', DimText, DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until DimSetEntry2.Next = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                CurrReport.Break;
                                //IF NOT ShowInternalInfo THEN
                                //  CurrReport.BREAK;
                                DimSetEntry2.SetRange("Dimension Set ID", "Sales Line"."Dimension Set ID");
                            end;
                        }
                        dataitem(AsmLoop; "Integer")
                        {
                            DataItemTableView = sorting(Number);

                            column(ReportForNavId_9462; 9462)
                            { }
                            column(AsmLineUnitOfMeasureText; GetUnitOfMeasureDescr(AsmLine."Unit of Measure Code"))
                            { }
                            column(AsmLineQuantity; AsmLine.Quantity)
                            { }
                            column(AsmLineDescription; BlanksForIndent + AsmLine.Description)
                            { }
                            column(AsmLineNo; BlanksForIndent + AsmLine."No.")
                            { }
                            column(AsmLineType; AsmLine.Type)
                            { }
                            trigger OnAfterGetRecord()
                            begin
                                if AsmLoop.Number = 1 then
                                    AsmLine.FindSet
                                else
                                    AsmLine.Next;
                            end;

                            trigger OnPreDataItem()
                            begin
                                CurrReport.Break;
                                if not DisplayAssemblyInformation then CurrReport.Break;
                                if not AsmInfoExistsForLine then CurrReport.Break;
                                AsmLine.SetRange("Document Type", AsmHeader."Document Type");
                                AsmLine.SetRange("Document No.", AsmHeader."No.");
                                AsmLoop.SetRange(AsmLoop.Number, 1, AsmLine.Count);
                            end;
                        }
                        trigger OnAfterGetRecord()
                        begin
                            if RoundLoop.Number = 1 then
                                SalesLine.FindFirst
                            else
                                SalesLine.Next;
                            "Sales Line" := SalesLine;
                            if DisplayAssemblyInformation then AsmInfoExistsForLine := SalesLine.AsmToOrderExists(AsmHeader);
                            if not "Sales Header"."Prices Including VAT" and (SalesLine."VAT Calculation Type" = SalesLine."vat calculation type"::"Full VAT") then SalesLine."Line Amount" := 0;
                            if (SalesLine.Type = SalesLine.Type::"G/L Account") and (not ShowInternalInfo) then "Sales Line"."No." := '';
                            NNC_SalesLineLineAmt += SalesLine."Line Amount";
                            NNC_SalesLineInvDiscAmt += SalesLine."Inv. Discount Amount";
                            NNC_TotalLCY := NNC_SalesLineLineAmt - NNC_SalesLineInvDiscAmt;
                            NNC_TotalExclVAT := NNC_TotalLCY;
                            NNC_VATAmt := VATAmount;
                            NNC_TotalInclVAT := NNC_TotalLCY - NNC_VATAmt;
                            NNC_PmtDiscOnVAT := -VATDiscountAmount;
                            NNC_TotalInclVAT2 := TotalAmountInclVAT;
                            NNC_VatAmt2 := VATAmount;
                            NNC_TotalExclVAT2 := VATBaseAmount;
                            //ini - 'Record "Sales Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                            //NNC_PmtDiscGivenAmount := NNC_PmtDiscGivenAmount - SalesLine."Pmt. Disc. Given Amount" ;
                            NNC_PmtDiscGivenAmount := NNC_PmtDiscGivenAmount - SalesLine."Pmt. Discount Amount";
                            //fin - 'Record "Sales Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                            ReportPrintedLines += 1;
                            ContPrintedLines += 1;
                            if ContPrintedLines > PageLines then ContPrintedLines := 1;
                        end;

                        trigger OnPostDataItem()
                        begin
                            SalesLine.DeleteAll;
                        end;

                        trigger OnPreDataItem()
                        begin
                            DocLineNo := 0;
                            MoreLines := SalesLine.Find('+');
                            DocLineNo := SalesLine."Line No.";
                            while MoreLines and (SalesLine.Description = '') and (SalesLine."Description 2" = '') and (SalesLine."No." = '') and (SalesLine.Quantity = 0) and (SalesLine.Amount = 0) do MoreLines := SalesLine.Next(-1) <> 0;
                            if not MoreLines then CurrReport.Break;
                            BlankLines := CalculateBlankLines(SalesLine.Count);
                            if BlankLines > 0 then begin
                                for i := 1 to BlankLines do begin
                                    DocLineNo += 1;
                                    SalesLine.Init;
                                    SalesLine."Document Type" := "Sales Header"."Document Type";
                                    SalesLine."No." := "Sales Header"."No.";
                                    SalesLine."Line No." := DocLineNo;
                                    SalesLine.Insert;
                                end;
                            end;
                            //SalesLine.SETRANGE("Line No.",0,SalesLine."Line No.");
                            SalesLine.SetRange("Line No.", 0, DocLineNo);
                            RoundLoop.SetRange(RoundLoop.Number, 1, SalesLine.Count);
                            //ini - 'Record "Sales Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                            //CurrReport.CreateTotals(SalesLine."Line Amount",SalesLine."Inv. Discount Amount",SalesLine."Pmt. Disc. Given Amount");
                            //>> BBT. CreateTotals. Marcada como obsoleta.  
                            //CurrReport.CreateTotals(SalesLine."Line Amount", SalesLine."Inv. Discount Amount", SalesLine."Pmt. Discount Amount");
                            //<<
                            //fin - 'Record "Sales Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                            ReportPrintedLines := 0;
                            ContPrintedLines := 0;
                        end;
                    }
                    dataitem(VATCounter; "Integer")
                    {
                        DataItemTableView = sorting(Number);

                        column(ReportForNavId_6558; 6558)
                        { }
                        //ini - 'Record "VAT Amount Line" temporary' does not contain a definition for 'VAT+EC Base'
                        // column(VATAmountLineVATECBase;VATAmountLine."VAT+EC Base")
                        // {
                        //     AutoFormatExpression = "Sales Header"."Currency Code";
                        //     AutoFormatType = 1;
                        // }
                        column(VATAmountLineVATECBase; VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //fin - 'Record "VAT Amount Line" temporary' does not contain a definition for 'VAT+EC Base'
                        column(VATAmountLineVATAmount; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineLineAmount; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //ini - 'Record "VAT Amount Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                        // column(VATAmtLineInvDiscAmtPmtDiscAmt; VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Disc. Given Amount")
                        // {
                        //     AutoFormatExpression = "Sales Header"."Currency Code";
                        //     AutoFormatType = 1;
                        // }
                        column(VATAmtLineInvDiscAmtPmtDiscAmt; VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //fin - 'Record "VAT Amount Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                        column(VATAmountLineECAmt; VATAmountLine."EC Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVAT_VATCounter; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 6;
                        }
                        column(VATAmtLineVATIdentifier_VATCounter; VATAmountLine."VAT Identifier")
                        { }
                        column(VATAmountLineEC; VATAmountLine."EC %")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATPecrentCaption; VATPecrentCaptionLbl)
                        { }
                        column(VATECBaseCaption; VATECBaseCaptionLbl)
                        { }
                        column(VATAmountCaption; VATAmountCaptionLbl)
                        { }
                        column(VATAmtSpecCaption; VATAmtSpecCaptionLbl)
                        { }
                        column(InvDiscBaseAmtCaption; InvDiscBaseAmtCaptionLbl)
                        { }
                        column(LineAmountCaption; LineAmountCaptionLbl)
                        { }
                        column(InvPmtDiscountsCaption; InvPmtDiscountsCaptionLbl)
                        { }
                        column(VATIdentifierCaption; VATIdentifierCaptionLbl)
                        { }
                        column(ECAmtCaption; ECAmtCaptionLbl)
                        { }
                        column(ECPercentCaption; ECPercentCaptionLbl)
                        { }
                        column(TotalCaption; TotalCaptionLbl)
                        { }
                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(VATCounter.Number);
                            if VATAmountLine."VAT Amount" = 0 then VATAmountLine."VAT %" := 0;
                            if VATAmountLine."EC Amount" = 0 then VATAmountLine."EC %" := 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (VATAmount = 0) and (VATAmountLine."VAT %" + VATAmountLine."EC %" = 0) then CurrReport.Break;
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
                    dataitem(VATCounterLCY; "Integer")
                    {
                        DataItemTableView = sorting(Number);

                        column(ReportForNavId_2038; 2038)
                        { }
                        column(VALExchRate; VALExchRate)
                        { }
                        column(VALSpecLCYHeader; VALSpecLCYHeader)
                        { }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATAmountLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVAT_VATCounterLCY; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier_VATCounterLCY; VATAmountLine."VAT Identifier")
                        { }
                        column(VATBaseCaption; VATBaseCaptionLbl)
                        { }
                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(VATCounterLCY.Number);
                            VALVATBaseLCY := VATAmountLine.GetBaseLCY("Sales Header"."Posting Date", "Sales Header"."Currency Code", "Sales Header"."Currency Factor");
                            VALVATAmountLCY := VATAmountLine.GetAmountLCY("Sales Header"."Posting Date", "Sales Header"."Currency Code", "Sales Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or ("Sales Header"."Currency Code" = '') or (VATAmountLine.GetTotalVATAmount = 0) then CurrReport.Break;
                            VATCounterLCY.SetRange(VATCounterLCY.Number, 1, VATAmountLine.Count);
                            //>> BBT. CreateTotals. Marcada como obsoleta.  
                            //CurrReport.CreateTotals(VALVATBaseLCY, VALVATAmountLCY);
                            //<<
                            if GLSetup."LCY Code" = '' then
                                VALSpecLCYHeader := Text007 + Text008
                            else
                                VALSpecLCYHeader := Text007 + Format(GLSetup."LCY Code");
                            CurrExchRate.FindCurrency("Sales Header"."Posting Date", "Sales Header"."Currency Code", 1);
                            VALExchRate := StrSubstNo(Text009, CurrExchRate."Relational Exch. Rate Amount", CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(Total; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));

                        column(ReportForNavId_3476; 3476)
                        { }
                    }
                    dataitem(Total2; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));

                        column(ReportForNavId_3363; 3363)
                        { }
                        column(SelltoCustNo_SalesHeader; "Sales Header"."Sell-to Customer No.")
                        { }
                        column(ShipToAddr8; ShipToAddr[8])
                        { }
                        column(ShipToAddr7; ShipToAddr[7])
                        { }
                        column(ShipToAddr6; ShipToAddr[6])
                        { }
                        column(ShipToAddr5; ShipToAddr[5])
                        { }
                        column(ShipToAddr4; ShipToAddr[4])
                        { }
                        column(ShipToAddr3; ShipToAddr[3])
                        { }
                        column(ShipToAddr2; ShipToAddr[2])
                        { }
                        column(ShipToAddr1; ShipToAddr[1])
                        { }
                        column(ShiptoAddressCaption; ShiptoAddressCaptionLbl)
                        { }
                        column(SelltoCustNo_SalesHeaderCaption; "Sales Header".FieldCaption("Sell-to Customer No."))
                        { }
                        trigger OnPreDataItem()
                        begin
                            if not ShowShippingAddr then CurrReport.Break;
                        end;
                    }
                    dataitem(PrepmtLoop; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                        column(ReportForNavId_1849; 1849)
                        { }
                        column(PrepmtLineAmount; PrepmtLineAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtInvBufDesc; PrepmtInvBuf.Description)
                        { }
                        column(GLAccountNo_PrepmtInvBuf; PrepmtInvBuf."G/L Account No.")
                        { }
                        column(TotalExclVATText1; TotalExclVATText)
                        { }
                        column(PrepmtVATAmtLineVATAmtTxt; PrepmtVATAmountLine.VATAmountText)
                        { }
                        column(TotalInclVATTxt; TotalInclVATText)
                        { }
                        column(PrepmtInvBufAmount; PrepmtInvBuf.Amount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmount; PrepmtVATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtInvBufAmtPrepmtVATAmt; PrepmtInvBuf.Amount + PrepmtVATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLVATAmtText1; VATAmountLine.VATAmountText)
                        { }
                        column(PrepmtTotalAmountInclVAT; PrepmtTotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATBaseAmount; PrepmtVATBaseAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(DescriptionCaption; DescriptionCaptionLbl)
                        { }
                        column(GLAccountNoCaption; GLAccountNoCaptionLbl)
                        { }
                        column(PrepaymentSpecCaption; PrepaymentSpecCaptionLbl)
                        { }
                        dataitem(PrepmtDimLoop; "Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                            column(ReportForNavId_6278; 6278)
                            { }
                            column(DimText2; DimText)
                            { }
                            trigger OnAfterGetRecord()
                            begin
                                if PrepmtDimLoop.Number = 1 then begin
                                    if not TempPrepmtDimSetEntry.Find('-') then CurrReport.Break;
                                end
                                else if not Continue then CurrReport.Break;
                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := StrSubstNo('%1 %2', TempPrepmtDimSetEntry."Dimension Code", TempPrepmtDimSetEntry."Dimension Value Code")
                                    else
                                        DimText := StrSubstNo('%1, %2 %3', DimText, TempPrepmtDimSetEntry."Dimension Code", TempPrepmtDimSetEntry."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until TempPrepmtDimSetEntry.Next = 0;
                            end;
                        }
                        trigger OnAfterGetRecord()
                        begin
                            if PrepmtLoop.Number = 1 then begin
                                if not PrepmtInvBuf.Find('-') then CurrReport.Break;
                            end
                            else if PrepmtInvBuf.Next = 0 then CurrReport.Break;
                            if ShowInternalInfo then DimMgt.GetDimensionSet(TempPrepmtDimSetEntry, PrepmtInvBuf."Dimension Set ID");
                            if "Sales Header"."Prices Including VAT" then
                                PrepmtLineAmount := PrepmtInvBuf."Amount Incl. VAT"
                            else
                                PrepmtLineAmount := PrepmtInvBuf.Amount;
                        end;

                        trigger OnPreDataItem()
                        begin
                            //ini - 'Record "VAT Amount Line" temporary' does not contain a definition for 'VAT+EC Base'
                            // CurrReport.CreateTotals(
                            //   PrepmtInvBuf.Amount, PrepmtInvBuf."Amount Incl. VAT",
                            //   PrepmtVATAmountLine."Line Amount", PrepmtVATAmountLine."VAT+EC Base",
                            //   PrepmtVATAmountLine."VAT Amount",
                            //   PrepmtLineAmount);
                            //>> BBT. CreateTotals. Marcada como obsoleta.  
                            //CurrReport.CreateTotals(PrepmtInvBuf.Amount, PrepmtInvBuf."Amount Incl. VAT", PrepmtVATAmountLine."Line Amount", PrepmtVATAmountLine."VAT Base", PrepmtVATAmountLine."VAT Amount", PrepmtLineAmount);
                            //<<
                            //fin - 'Record "VAT Amount Line" temporary' does not contain a definition for 'VAT+EC Base'
                        end;
                    }
                    dataitem(PrepmtVATCounter; "Integer")
                    {
                        DataItemTableView = sorting(Number);

                        column(ReportForNavId_3388; 3388)
                        { }
                        column(VATAmt_PrepmtVATAmtLine; PrepmtVATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //ini - 'Record "VAT Amount Line" temporary' does not contain a definition for 'VAT+EC Base'
                        // column(VATBase_PrepmtVATAmtLine; PrepmtVATAmountLine."VAT+EC Base")
                        // {
                        //     AutoFormatExpression = "Sales Header"."Currency Code";
                        //     AutoFormatType = 1;
                        // }
                        column(VATBase_PrepmtVATAmtLine; PrepmtVATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //fin - 'Record "VAT Amount Line" temporary' does not contain a definition for 'VAT+EC Base'
                        column(LineAmt_PrepmtVATAmtLine; PrepmtVATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VAT_PrepmtVATAmtLine; PrepmtVATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATIdentifier_PrepmtVATAmtLine; PrepmtVATAmountLine."VAT Identifier")
                        { }
                        column(PrepaymentVATAmtSpecCaption; PrepaymentVATAmtSpecCaptionLbl)
                        { }
                        column(PrepmtVATPercentCaption; VATPecrentCaptionLbl)
                        { }
                        column(PrepmtVATBaseCaption; VATECBaseCaptionLbl)
                        { }
                        column(PrepmtVATAmtCaption; VATAmountCaptionLbl)
                        { }
                        column(PrepmtVATIdentCaption; VATIdentifierCaptionLbl)
                        { }
                        column(PrepmtLineAmtCaption; LineAmountCaptionLbl)
                        { }
                        column(PrepmtTotalCaption; TotalCaptionLbl)
                        { }
                        trigger OnAfterGetRecord()
                        begin
                            PrepmtVATAmountLine.GetLine(PrepmtVATCounter.Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            PrepmtVATCounter.SetRange(PrepmtVATCounter.Number, 1, PrepmtVATAmountLine.Count);
                        end;
                    }
                    dataitem(PrepmtTotal; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));

                        column(ReportForNavId_7808; 7808)
                        { }
                        column(PrepmtPaymentTermsDesc; PrepmtPaymentTerms.Description)
                        { }
                        column(PrepmtPaymentTermsCaption; PrepmtPaymentTermsCaptionLbl)
                        { }
                        trigger OnPreDataItem()
                        begin
                            if not PrepmtInvBuf.Find('-') then CurrReport.Break;
                        end;
                    }
                }
                trigger OnAfterGetRecord()
                var
                    PrepmtSalesLine: Record "Sales Line" temporary;
                    SalesPost: Codeunit "Sales-Post";
                    TempSalesLine: Record "Sales Line" temporary;
                begin
                    Clear(SalesLine);
                    Clear(SalesPost);
                    VATAmountLine.DeleteAll;
                    SalesLine.DeleteAll;
                    SalesPost.GetSalesLines("Sales Header", SalesLine, 0);
                    SalesLine.CalcVATAmountLines(0, "Sales Header", SalesLine, VATAmountLine);
                    SalesLine.UpdateVATOnLines(0, "Sales Header", SalesLine, VATAmountLine);
                    VATAmount := VATAmountLine.GetTotalVATAmount;
                    VATBaseAmount := VATAmountLine.GetTotalVATBase;
                    VATDiscountAmount := VATAmountLine.GetTotalVATDiscount("Sales Header"."Currency Code", "Sales Header"."Prices Including VAT");
                    TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;
                    PrepmtInvBuf.DeleteAll;
                    SalesPostPrepmt.GetSalesLines("Sales Header", 0, PrepmtSalesLine);
                    if not PrepmtSalesLine.IsEmpty then begin
                        SalesPostPrepmt.GetSalesLinesToDeduct("Sales Header", TempSalesLine);
                        if not TempSalesLine.IsEmpty then SalesPostPrepmt.CalcVATAmountLines("Sales Header", TempSalesLine, PrepmtVATAmountLineDeduct, 1);
                    end;
                    SalesPostPrepmt.CalcVATAmountLines("Sales Header", PrepmtSalesLine, PrepmtVATAmountLine, 0);
                    PrepmtVATAmountLine.DeductVATAmountLine(PrepmtVATAmountLineDeduct);
                    SalesPostPrepmt.UpdateVATOnLines("Sales Header", PrepmtSalesLine, PrepmtVATAmountLine, 0);
                    SalesPostPrepmt.BuildInvLineBuffer("Sales Header", PrepmtSalesLine, 0, PrepmtInvBuf);
                    PrepmtVATAmount := PrepmtVATAmountLine.GetTotalVATAmount;
                    PrepmtVATBaseAmount := PrepmtVATAmountLine.GetTotalVATBase;
                    PrepmtTotalAmountInclVAT := PrepmtVATAmountLine.GetTotalAmountInclVAT;
                    if (VATAmountLine."VAT Calculation Type" = VATAmountLine."vat calculation type"::"Reverse Charge VAT") and "Sales Header"."Prices Including VAT" then begin
                        VATBaseAmount := VATAmountLine.GetTotalLineAmount(false, "Sales Header"."Currency Code");
                        TotalAmountInclVAT := VATAmountLine.GetTotalLineAmount(false, "Sales Header"."Currency Code");
                    end;
                    if CopyLoop.Number > 1 then begin
                        CopyText := FormatDocument.GetCOPYText();
                        OutputNo += 1;
                    end;
                    //CurrReport.PageNo := 1;
                    NNC_TotalLCY := 0;
                    NNC_TotalExclVAT := 0;
                    NNC_VATAmt := 0;
                    NNC_TotalInclVAT := 0;
                    NNC_PmtDiscGivenAmount := 0;
                    NNC_PmtDiscOnVAT := 0;
                    NNC_TotalInclVAT2 := 0;
                    NNC_VatAmt2 := 0;
                    NNC_TotalExclVAT2 := 0;
                    NNC_SalesLineLineAmt := 0;
                    NNC_SalesLineInvDiscAmt := 0;
                end;

                trigger OnPostDataItem()
                begin
                    if Print then SalesCountPrinted.Run("Sales Header");
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
            begin
                if ("Sales Header"."Language Code" <> '') and ("Sales Header"."Language Code" <> 'ESP') then begin
                    //ini - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
                    //CurrReport.Language := Language.GetLanguageID("Sales Header"."Language Code");
                    CurrReport.Language := cLanguage.GetLanguageID("Sales Header"."Language Code");
                    //fin - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
                end;
                if RespCenter.Get("Sales Header"."Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end
                else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                DimSetEntry1.SetRange("Dimension Set ID", "Sales Header"."Dimension Set ID");
                if "Sales Header"."Salesperson Code" = '' then begin
                    Clear(SalesPurchPerson);
                    SalesPersonText := '';
                end
                else begin
                    SalesPurchPerson.Get("Sales Header"."Salesperson Code");
                    SalesPersonText := Text000;
                end;
                if "Sales Header"."Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := "Sales Header".FieldCaption("Sales Header"."Your Reference");
                if "Sales Header"."VAT Registration No." = '' then
                    VATNoText := ''
                else
                    //VATNoText := FIELDCAPTION("VAT Registration No.");
                    VATNoText := VATNbrCaptionLbl;
                if "Sales Header"."Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(Text001, GLSetup."LCY Code");
                    TotalInclVATText := StrSubstNo(Text1100000, GLSetup."LCY Code");
                    TotalExclVATText := StrSubstNo(Text1100001, GLSetup."LCY Code");
                end
                else begin
                    TotalText := StrSubstNo(Text001, "Sales Header"."Currency Code");
                    TotalInclVATText := StrSubstNo(Text1100000, "Sales Header"."Currency Code");
                    TotalExclVATText := StrSubstNo(Text1100001, "Sales Header"."Currency Code");
                end;
                "Sales Header"."Ship-to Contact" := '';
                "Sales Header"."Bill-to Contact" := '';
                FormatAddr.SalesHeaderBillTo(CustAddr, "Sales Header");
                if not Cust.Get("Sales Header"."Sell-to Customer No.") then Cust.Init;
                Index := 1;
                InsertText := 1;
                repeat
                    if CustAddr[Index] = '' then begin
                        case InsertText of
                            1:
                                if Cust."Phone No." <> '' then
                                    CustAddr[Index] := PhoneNoCaptionLbl + ': ' + Cust."Phone No.";
                            2:
                                if Cust."Fax No." <> '' then
                                    CustAddr[Index] := FaxNoCaptionLbl + ': ' + Cust."Fax No.";
                            3:
                                if Cust."E-Mail" <> '' then
                                    CustAddr[Index] := EmailCaptionLbl + ': ' + Cust."E-Mail";
                        end;
                        InsertText := InsertText + 1;
                    end;
                    Index := Index + 1;
                until Index = 9;
                CompressArray(CustAddr);
                if "Sales Header"."Payment Terms Code" = '' then
                    PaymentTerms.Init
                else begin
                    PaymentTerms.Get("Sales Header"."Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Sales Header"."Language Code");
                end;
                if "Sales Header"."Prepmt. Payment Terms Code" = '' then
                    PrepmtPaymentTerms.Init
                else begin
                    PrepmtPaymentTerms.Get("Sales Header"."Prepmt. Payment Terms Code");
                    PrepmtPaymentTerms.TranslateDescription(PrepmtPaymentTerms, "Sales Header"."Language Code");
                end;
                if "Sales Header"."Prepmt. Payment Terms Code" = '' then
                    PrepmtPaymentTerms.Init
                else begin
                    PrepmtPaymentTerms.Get("Sales Header"."Prepmt. Payment Terms Code");
                    PrepmtPaymentTerms.TranslateDescription(PrepmtPaymentTerms, "Sales Header"."Language Code");
                end;
                if not Cust.Get("Sales Header"."Bill-to Customer No.") then Clear(Cust);
                if not CustBankAccount.Get("Sales Header"."Bill-to Customer No.", "Sales Header"."Cust. Bank Acc. Code") then Clear(CustBankAccount);
                if "Sales Header"."Payment Method Code" = '' then
                    PaymentMethod.Init
                else
                    PaymentMethod.Get("Sales Header"."Payment Method Code");
                GiroNoCaptionVar := GiroNoCaptionLbl;
                BankNameCaptionVar := BankNameCaptionLbl;
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
                if "Sales Header"."Shipment Method Code" = '' then
                    ShipmentMethod.Init
                else begin
                    ShipmentMethod.Get("Sales Header"."Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Sales Header"."Language Code");
                end;
                //ini - There is no argument given that corresponds to the required formal parameter 'SalesHeader' of 'SalesHeaderShipTo(var array[8] of Text[100], array[8] of Text[100], var Record "Sales Header")'
                //FormatAddr.SalesHeaderShipTo(ShipToAddr, "Sales Header");
                FormatAddr.SalesHeaderShipTo(ShipToAddr, CustAddr, "Sales Header");
                //fin - There is no argument given that corresponds to the required formal parameter 'SalesHeader' of 'SalesHeaderShipTo(var array[8] of Text[100], array[8] of Text[100], var Record "Sales Header")'
                ShowShippingAddr := "Sales Header"."Sell-to Customer No." <> "Sales Header"."Bill-to Customer No.";
                for i := 1 to ArrayLen(ShipToAddr) do if ShipToAddr[i] <> CustAddr[i] then ShowShippingAddr := true;
                ShowCashAccountingCriteria("Sales Header");
                if Print then begin
                    if ArchiveDocument then ArchiveManagement.StoreSalesDocument("Sales Header", LogInteraction);
                    if LogInteraction then begin
                        "Sales Header".CalcFields("Sales Header"."No. of Archived Versions");
                        if "Sales Header"."Bill-to Contact No." <> '' then
                            SegManagement.LogDocument(3, "Sales Header"."No.", "Sales Header"."Doc. No. Occurrence", "Sales Header"."No. of Archived Versions", Database::Contact, "Sales Header"."Bill-to Contact No.", "Sales Header"."Salesperson Code", "Sales Header"."Campaign No.", "Sales Header"."Posting Description", "Sales Header"."Opportunity No.")
                        else
                            SegManagement.LogDocument(3, "Sales Header"."No.", "Sales Header"."Doc. No. Occurrence", "Sales Header"."No. of Archived Versions", Database::Customer, "Sales Header"."Bill-to Customer No.", "Sales Header"."Salesperson Code", "Sales Header"."Campaign No.", "Sales Header"."Posting Description", "Sales Header"."Opportunity No.");
                    end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                Print := Print or not CurrReport.Preview;
                AsmInfoExistsForLine := false;
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
                    field(ArchiveDocument; ArchiveDocument)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Archive Document', comment = 'ESP="Archivar documento"';
                        Visible = false;

                        trigger OnValidate()
                        begin
                            if not ArchiveDocument then LogInteraction := false;
                        end;
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Log Interaction', comment = 'ESP="Log interacción"';
                        Enabled = LogInteractionEnable;

                        trigger OnValidate()
                        begin
                            if LogInteraction then ArchiveDocument := ArchiveDocumentEnable;
                        end;
                    }
                    field(ShowAssemblyComponents; DisplayAssemblyInformation)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Assembly Components', comment = 'ESP="Mostrar componentes del ensamblado"';
                        Visible = false;
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
            //ini - Field 'Archive Quotes and Orders' is removed. Reason: Replaced by new fields Archive Quotes and Archive Orders. Tag: 18.0.
            //ArchiveDocument := SalesSetup."Archive Quotes and Orders";
            ArchiveDocument := SalesSetup."Archive Orders";
            //fin - Field 'Archive Quotes and Orders' is removed. Reason: Replaced by new fields Archive Quotes and Archive Orders. Tag: 18.0.
            LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Sales Ord. Cnfrmn.") <> '';
            LogInteractionEnable := LogInteraction;
        end;
    }
    labels
    {
    }
    trigger OnInitReport()
    begin
        GLSetup.Get;
        SalesSetup.Get;
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
        PageLines := 35;
    end;

    var
        Text000: label 'FORWARDER FROM', comment = 'ESP="AGENTE"';
        Text001: label 'Total %1', Comment = 'ESP="Total %1"';
        PageCaptionCap: label 'Page %1 of %2', comment = 'ESP="Página %1 de %2"';
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PrepmtPaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        VATAmountLine: Record "VAT Amount Line" temporary;
        PrepmtVATAmountLine: Record "VAT Amount Line" temporary;
        PrepmtVATAmountLineDeduct: Record "VAT Amount Line" temporary;
        SalesLine: Record "Sales Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        TempPrepmtDimSetEntry: Record "Dimension Set Entry" temporary;
        PrepmtInvBuf: Record "Prepayment Inv. Line Buffer" temporary;
        RespCenter: Record "Responsibility Center";
        //ini - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
        //Language: Record Language;
        cLanguage: Codeunit Language;
        //fin - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
        CurrExchRate: Record "Currency Exchange Rate";
        AsmHeader: Record "Assembly Header";
        AsmLine: Record "Assembly Line";
        Cust: Record Customer;
        CustBankAccount: Record "Customer Bank Account";
        BankAccount: Record "Bank Account";
        SalesCountPrinted: Codeunit "Sales-Printed";
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        ArchiveManagement: Codeunit ArchiveManagement;
        SalesPostPrepmt: Codeunit "Sales-Post Prepayments";
        DimMgt: Codeunit DimensionManagement;
        CustAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        SalesPersonText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
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
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        Text007: label 'VAT Amount Specification in ', comment = 'ESP="Especificar importe IVA en "';
        Text008: label 'Local Currency', comment = 'ESP="Divisa local"';
        Text009: label 'Exchange rate: %1/%2', comment = 'ESP="Tipo cambio: %1/%2"';
        VALExchRate: Text[50];
        PrepmtVATAmount: Decimal;
        PrepmtVATBaseAmount: Decimal;
        PrepmtTotalAmountInclVAT: Decimal;
        PrepmtLineAmount: Decimal;
        OutputNo: Integer;
        NNC_TotalLCY: Decimal;
        NNC_TotalExclVAT: Decimal;
        NNC_VATAmt: Decimal;
        NNC_TotalInclVAT: Decimal;
        NNC_PmtDiscOnVAT: Decimal;
        NNC_TotalInclVAT2: Decimal;
        NNC_VatAmt2: Decimal;
        NNC_TotalExclVAT2: Decimal;
        NNC_SalesLineLineAmt: Decimal;
        NNC_SalesLineInvDiscAmt: Decimal;
        Print: Boolean;
        Text1100000: label 'Total %1 Incl. VAT+EC', comment = 'ESP="Total %1 IVA incl.+RE"';
        Text1100001: label 'Total %1 Excl. VAT+EC', comment = 'ESP="Total %1 IVA excl.+RE"';
        PaymentMethod: Record "Payment Method";
        NNC_PmtDiscGivenAmount: Decimal;
        ArchiveDocumentEnable: Boolean;
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        AsmInfoExistsForLine: Boolean;
        PaymentTermsCaptionLbl: label 'CONDITIONS', comment = 'ESP="CONDICIONES"';
        ShipmentMethodCaptionLbl: label 'Shipment Method', comment = 'ESP="Condiciones envío"';
        PaymentMethodCaptionLbl: label 'Payment Method', comment = 'ESP="Forma pago"';
        PhoneNoCaptionLbl: label 'Phone', comment = 'ESP="Tel."';
        VATRegNoCaptionLbl: label 'NIF', comment = 'ESP="NIF"';
        GiroNoCaptionLbl: label 'Domiciliación', comment = 'ESP="Domiciliación"';
        BankNameCaptionLbl: label 'C. Bank', comment = 'ESP="C. Ban"';
        BankAccountNoCaptionLbl: label 'Account No.', comment = 'ESP="Cuenta Corriente"';
        ShipmentDateCaptionLbl: label 'Shipment Date', comment = 'ESP="Fecha envío"';
        OrderNoCaptionLbl: label 'PROFORMA INVOICE', comment = 'ESP="FACTURA PROFORMA"';
        HeaderDimensionsCaptionLbl: label 'Header Dimensions', comment = 'ESP="Dimensiones cabecera"';
        UnitPriceCaptionLbl: label 'Price', comment = 'ESP="Precio"';
        DiscountCaptionLbl: label 'Discount %', comment = 'ESP="% Descuento"';
        AmountCaptionLbl: label 'Amount', comment = 'ESP="Importe"';
        InvDiscAmtCaptionLbl: label 'Invoice Discount Amount', comment = 'ESP="Importe descuento factura"';
        SubtotalCaptionLbl: label 'Subtotal', comment = 'ESP="Subtotal"';
        PmtDiscGivenAmtCaptionLbl: label 'Pmt. Discount Given Amount', comment = 'ESP="Importe descuento P.P. concedido"';
        PaymentDiscVATCaptionLbl: label 'Payment Discount on VAT', comment = 'ESP="Descuento P.P. sobre IVA"';
        LineDimensionsCaptionLbl: label 'Line Dimensions', comment = 'ESP="Dimensiones línea"';
        VATPecrentCaptionLbl: label 'VAT %', comment = 'ESP="% IVA"';
        VATECBaseCaptionLbl: label 'VAT+EC Base', comment = 'ESP="Base IVA+RE"';
        VATAmountCaptionLbl: label 'VAT Amount', comment = 'ESP="Importe IVA"';
        VATAmtSpecCaptionLbl: label 'VAT Amount Specification', comment = 'ESP="Especificación importe IVA"';
        InvDiscBaseAmtCaptionLbl: label 'Invoice Discount Base Amount', comment = 'ESP="Importe base descuento factura"';
        LineAmountCaptionLbl: label 'Line Amount', comment = 'ESP="Importe línea"';
        InvPmtDiscountsCaptionLbl: label 'Invoice and Pmt. Discounts', comment = 'ESP="Factura y descuentos P.P."';
        VATIdentifierCaptionLbl: label 'VAT Identifier', comment = 'ESP="Identific. IVA"';
        ECAmtCaptionLbl: label 'EC Amount', comment = 'ESP="Importe RE"';
        ECPercentCaptionLbl: label 'EC %', comment = 'ESP="% RE"';
        TotalCaptionLbl: label 'Total', comment = 'ESP="Total';
        VATBaseCaptionLbl: label 'VAT Base', comment = 'ESP="Base IVA"';
        ShiptoAddressCaptionLbl: label 'Ship-to Address', comment = 'ESP="Dirección de envío"';
        DescriptionCaptionLbl: label 'Description', comment = 'ESP="Descripción"';
        GLAccountNoCaptionLbl: label 'G/L Account No.', comment = 'ESP="Nº cuenta"';
        PrepaymentSpecCaptionLbl: label 'Prepayment Specification', comment = 'ESP="Especificación prepago"';
        PrepaymentVATAmtSpecCaptionLbl: label 'Prepayment VAT Amount Specification', comment = 'ESP="Especificación importe IVA prepago"';
        PrepmtPaymentTermsCaptionLbl: label 'Prepmt. Payment Terms', comment = 'ESP="Términos prepago"';
        HomePageCaptionCap: label 'Home Page', comment = 'ESP="Página Web"';
        EmailCaptionLbl: label 'E-mail', comment = 'ESP="Correo electrónico"';
        DocumentDateCaptionLbl: label 'Date', comment = 'ESP="Fecha"';
        AllowInvDiscCaptionLbl: label 'Allow Invoice Discount', comment = 'ESP="Permitir descuento factura"';
        CACCaptionLbl: Text;
        CACTxt: label 'Régimen especial del criterio de caja', comment = 'ESP="Régimen especial del criterio de caja"';
        CustomerNbrCaptionLbl: label 'CUSTOMER', comment = 'ESP="CLIENTE"';
        VATNbrCaptionLbl: label 'VAT nbr:', comment = 'ESP="NIF"';
        NoOfCopiesCaptionLlb: label 'NBR. COPIES', comment = 'ESP="Nº COPIAS"';
        Index: Integer;
        InsertText: Integer;
        FaxNoCaptionLbl: label 'Fax', comment = 'ESP="Fax"';
        No_SalesLineCaptionLbl: label 'Reference', comment = 'ESP="Referencia"';
        UOM_SalesLineCaptionLbl: label 'Units', comment = 'ESP="Uds."';
        TotalLinCaptionLbl: label 'TOTAL', comment = 'ESP="TOTAL"';
        PageLines: Integer;
        ReportPrintedLines: Integer;
        TotalAmountCaptionLbl: label 'TOTAL AMOUNT', comment = 'ESP="IMPORTE TOTAL"';
        SignatureCaptionLbl: label 'Stamp and Signature', comment = 'ESP="Firma y Sello"';
        ContPrintedLines: Integer;
        DocLineNo: Integer;
        BlankLines: Integer;
        CompanyInfoCountryLbl: label 'Spain';
        AGCaptionLbl: label 'AG';
        DCCaptionLbl: label 'DC';
        CodeIBAN: Code[50];
        GiroNoCaptionVar: Text[30];
        BankNameCaptionVar: Text[10];
        AGCaptionVar: Text[2];
        DCCaptionVar: Text[2];
        CCCBankNo: Text[4];
        CCCBankBranchNo: Text[4];
        CCCControlDigits: Text[2];
        FormatDocument: Codeunit "Format Document";

    procedure InitializeRequest(NoOfCopiesFrom: Integer; ShowInternalInfoFrom: Boolean; ArchiveDocumentFrom: Boolean; LogInteractionFrom: Boolean; PrintFrom: Boolean; DisplayAsmInfo: Boolean)
    begin
        NoOfCopies := NoOfCopiesFrom;
        ShowInternalInfo := ShowInternalInfoFrom;
        ArchiveDocument := ArchiveDocumentFrom;
        LogInteraction := LogInteractionFrom;
        Print := PrintFrom;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;

    local procedure GetUnitOfMeasureDescr(UOMCode: Code[10]): Text[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if not UnitOfMeasure.Get(UOMCode) then exit(UOMCode);
        exit(UnitOfMeasure.Description);
    end;

    procedure ShowCashAccountingCriteria(SalesHeader: Record "Sales Header"): Text
    var
        VATPostingSetup: Record "VAT Posting Setup";
        SalesLine: Record "Sales Line";
    begin
        GLSetup.Get;
        if not GLSetup."VAT Cash Regime" then exit;
        CACCaptionLbl := '';
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet then
            repeat
                if VATPostingSetup.Get(SalesHeader."VAT Bus. Posting Group", SalesLine."VAT Prod. Posting Group") then if VATPostingSetup."Unrealized VAT Type" <> VATPostingSetup."unrealized vat type"::" " then CACCaptionLbl := CACTxt;
            until (SalesLine.Next = 0) or (CACCaptionLbl <> '');
        exit(CACCaptionLbl);
    end;

    procedure BlanksForIndent(): Text[10]
    begin
        exit(PadStr('', 2, ' '));
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
