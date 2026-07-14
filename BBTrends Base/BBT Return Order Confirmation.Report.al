Report 50041 "BBT Return Order Confirmation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/Return Order Confirmation BB.rdl';
    Caption = 'Return Order Confirmation', comment = 'ESP="Confirmación devolución"';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const("Return Order"));
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Sales Return Order', comment = 'ESP="Devolución venta"';

            column(ReportForNavId_6640; 6640)
            { }
            column(No_SalesHdr; "Sales Header"."No.")
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
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    { }
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    { }
                    column(CompanyInfo3Picture; CompanyInfo3.Picture)
                    { }
                    column(ReturnOrderConfirmCopyText; StrSubstNo(Text004, CopyText))
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
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    { }
                    column(CustAddr6; CustAddr[6])
                    { }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    { }
                    column(CompanyInfoEmail; CompanyInfo."E-Mail")
                    { }
                    column(CompanyInfoVATRegistrationNo; CompanyInfo."VAT Registration No.")
                    { }
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    { }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    { }
                    column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.")
                    { }
                    column(BilltoCustomerNo_SalesHdr; "Sales Header"."Bill-to Customer No.")
                    { }
                    column(DocDate_SalesHdr; Format("Sales Header"."Document Date", 0, 4))
                    { }
                    column(VATNoText; VATNoText)
                    { }
                    column(VATRegNo_SalesHdr; "Sales Header"."VAT Registration No.")
                    { }
                    column(SalesPersonText; SalesPersonText)
                    { }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    { }
                    column(No1_SalesHdr; "Sales Header"."No.")
                    { }
                    column(ReferenceText; ReferenceText)
                    { }
                    column(YourRef_SalesHdr; "Sales Header"."Your Reference")
                    { }
                    column(CustAddr7; CustAddr[7])
                    { }
                    column(CustAddr8; CustAddr[8])
                    { }
                    column(CompanyAddr5; CompanyAddr[5])
                    { }
                    column(CompanyAddr6; CompanyAddr[6])
                    { }
                    column(PricesInclVAT_SalesHdr; "Sales Header"."Prices Including VAT")
                    { }
                    column(PricesInclVAT_SalesHdrCaption; "Sales Header".FieldCaption("Prices Including VAT"))
                    { }
                    column(PageCaption; StrSubstNo(Text005, ''))
                    { }
                    column(OutputNo; OutputNo)
                    { }
                    column(PricesInclVATYesNo; Format("Sales Header"."Prices Including VAT"))
                    { }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    { }
                    column(VATRegNoCaption; VATRegNoCaptionLbl)
                    { }
                    column(GiroNoCaption; GiroNoCaptionLbl)
                    { }
                    column(BankNameCaption; BankNameCaptionLbl)
                    { }
                    column(BankAccNoCaption; BankAccNoCaptionLbl)
                    { }
                    column(ReturnOrderNoCaption; ReturnOrderNoCaptionLbl)
                    { }
                    column(DocumentDateCaption; DocumentDateCaptionLbl)
                    { }
                    column(HomePageCaption; HomePageCaptionLbl)
                    { }
                    column(UnitPriceCaption; UnitPriceCaptionLbl)
                    { }
                    column(DiscPercentCaption; DiscPercentCaptionLbl)
                    { }
                    column(AmountCaption; AmountCaptionLbl)
                    { }
                    column(EmailCaption; EmailCaptionLbl)
                    { }
                    column(AllowInvoiceDiscCaption; AllowInvoiceDiscCaptionLbl)
                    { }
                    column(TotalAmount; TotalAmount)
                    {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(InvDiscAmtCaption; InvDiscAmtCaptionLbl)
                    { }
                    column(SubtotalCaption; SubtotalCaptionLbl)
                    { }
                    column(PaymentDiscReceivedAmtCaption; PaymentDiscReceivedAmtCaptionLbl)
                    { }
                    column(PaymentDisconVATCaption; PaymentDisconVATCaptionLbl)
                    { }
                    column(TotalExclVATText; TotalExclVATText)
                    { }
                    column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText)
                    { }
                    column(VATAmount; VATAmount)
                    {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotalInclVATText; TotalInclVATText)
                    { }
                    column(TotalAmountInclVAT; TotalAmountInclVAT)
                    {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(BilltoCustomerNo_SalesHdrCaption; "Sales Header".FieldCaption("Bill-to Customer No."))
                    { }
                    column(ValoradoLbl; Valorado)
                    { }
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                        column(ReportForNavId_7574; 7574)
                        { }
                        column(DimText; DimText)
                        { }
                        column(Number_DimensionLoop1; DimensionLoop1.Number)
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
                            if not ShowInternalInfo then CurrReport.Break;
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
                        column(TypeInt; TypeInt)
                        { }
                        column(SalesLineNo; SalesLineNo)
                        { }
                        column(SalesLineLineNo; SalesLineLineNo)
                        { }
                        column(LineAmt_SalesLine; SalesLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Desc_SalesLine; "Sales Line".Description)
                        { }
                        column(Desc_SalesLineCaption; "Sales Line".FieldCaption(Description))
                        { }
                        column(No2_SalesLine; "Sales Line"."No.")
                        { }
                        column(No2_SalesLineCaption; "Sales Line".FieldCaption("No."))
                        { }
                        column(Qty_SalesLine; "Sales Line".Quantity)
                        { }
                        column(Qty_SalesLineCaption; "Sales Line".FieldCaption(Quantity))
                        { }
                        column(UnitofMeasure_SalesLine; "Sales Line"."Unit of Measure")
                        { }
                        column(UnitofMeasure_SalesLineCaption; "Sales Line".FieldCaption("Unit of Measure"))
                        { }
                        column(UnitPrice_SalesLine; "Sales Line"."Unit Price")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(LineDisc_SalesLine; "Sales Line"."Line Discount %")
                        { }
                        column(AllowInvDisc_SalesLine; "Sales Line"."Allow Invoice Disc.")
                        { }
                        column(VATIdentifier_SalesLine; "Sales Line"."VAT Identifier")
                        { }
                        column(VATIdentifier_SalesLineCaption; "Sales Line".FieldCaption("VAT Identifier"))
                        { }
                        column(AllowInvDisc1_SalesLine; Format("Sales Line"."Allow Invoice Disc."))
                        { }
                        column(InvDiscAmt_SalesLine; -SalesLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //ini - 'Record "Sales Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                        // column(PmtDiscGivenAmt_SalesLine;-SalesLine."Pmt. Disc. Given Amount")
                        // {
                        //     AutoFormatType = 1;
                        // }
                        // column(SalesLineLineAmtSalesLineInvDiscAmtSalesLinePmtDiscGnAmt;SalesLine."Line Amount"-SalesLine."Inv. Discount Amount"-SalesLine."Pmt. Disc. Given Amount")
                        // {
                        //     AutoFormatExpression = "Sales Header"."Currency Code";
                        //     AutoFormatType = 1;
                        // }
                        column(PmtDiscGivenAmt_SalesLine; -SalesLine."Pmt. Discount Amount")
                        {
                            AutoFormatType = 1;
                        }
                        column(SalesLineLineAmtSalesLineInvDiscAmtSalesLinePmtDiscGnAmt; SalesLine."Line Amount" - SalesLine."Inv. Discount Amount" - SalesLine."Pmt. Discount Amount")
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
                        column(VATBaseDisc; "Sales Header"."VAT Base Discount %")
                        { }
                        column(VATBaseAmount; VATBaseAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalSubTotal; TotalSubTotal)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInvoiceDiscountAmount; TotalInvoiceDiscountAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                            column(ReportForNavId_3591; 3591)
                            { }
                            column(DimText1; DimText)
                            { }
                            column(Number_DimensionLoop2; DimensionLoop2.Number)
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
                                if not ShowInternalInfo then CurrReport.Break;
                                DimSetEntry2.SetRange("Dimension Set ID", "Sales Line"."Dimension Set ID");
                            end;
                        }
                        trigger OnAfterGetRecord()
                        begin
                            if RoundLoop.Number = 1 then
                                SalesLine.Find('-')
                            else
                                SalesLine.Next;
                            "Sales Line" := SalesLine;
                            if (SalesLine.Type = SalesLine.Type::"G/L Account") and (not ShowInternalInfo) then begin
                                SalesLineNo := "Sales Line"."No.";
                                "Sales Line"."No." := '';
                            end;
                            TypeInt := "Sales Line".Type.AsInteger();
                            SalesLineLineNo := "Sales Line"."Line No.";
                            TotalSubTotal += "Sales Line"."Line Amount";
                            TotalInvoiceDiscountAmount -= "Sales Line"."Inv. Discount Amount";
                            TotalAmount += "Sales Line".Amount;
                        end;

                        trigger OnPostDataItem()
                        begin
                            SalesLine.DeleteAll;
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := SalesLine.Find('+');
                            while MoreLines and (SalesLine.Description = '') and (SalesLine."Description 2" = '') and (SalesLine."No." = '') and (SalesLine.Quantity = 0) and (SalesLine.Amount = 0) do MoreLines := SalesLine.Next(-1) <> 0;
                            if not MoreLines then CurrReport.Break;
                            SalesLine.SetRange("Line No.", 0, SalesLine."Line No.");
                            RoundLoop.SetRange(RoundLoop.Number, 1, SalesLine.Count);
                            //ini - 'Record "Sales Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                            // CurrReport.CreateTotals(SalesLine."Line Amount", SalesLine."Inv. Discount Amount", SalesLine."Pmt. Disc. Given Amount");
                            //>> BBT. CreateTotals. Marcada como obsoleta. 
                            //CurrReport.CreateTotals(SalesLine."Line Amount", SalesLine."Inv. Discount Amount", SalesLine."Pmt. Discount Amount");
                            //<<
                            //fin - 'Record "Sales Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
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
                        //     AutoFormatExpression = "Sales Header"."Currency Code";
                        //     AutoFormatType = 1;
                        // }
                        column(VATAmtLineVATECBase; VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //fin - 'Record "VAT Amount Line" temporary' does not contain a definition for 'VAT+EC Base'
                        column(VATAmtLineVATAmount; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineLineAmount; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmount; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //ini - 'Record "VAT Amount Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                        // column(VATAmtLineInvDiscAmtVATAmtLinePmtDiscGivenAmt; VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Disc. Given Amount")
                        // {
                        //     AutoFormatExpression = "Sales Header"."Currency Code";
                        //     AutoFormatType = 1;
                        // }
                        column(VATAmtLineInvDiscAmtVATAmtLinePmtDiscGivenAmt; VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //fin - 'Record "VAT Amount Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                        column(VATAmtLineECAmount; VATAmountLine."EC Amount")
                        {
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
                            AutoFormatType = 1;
                        }
                        column(VATPercentCaption; VATPercentCaptionLbl)
                        { }
                        column(VATBaseCaption; VATBaseCaptionLbl)
                        { }
                        column(VATAmountCaption; VATAmountCaptionLbl)
                        { }
                        column(VATAmountSpecificationCaption; VATAmountSpecificationCaptionLbl)
                        { }
                        column(InvDiscBaseAmtCaption; InvDiscBaseAmtCaptionLbl)
                        { }
                        column(LineAmtCaption; LineAmtCaptionLbl)
                        { }
                        column(InvandPmtDiscountsCaption; InvandPmtDiscountsCaptionLbl)
                        { }
                        column(VATIdentifierCaption; VATIdentifierCaptionLbl)
                        { }
                        column(ECCaption; ECCaptionLbl)
                        { }
                        column(ECAmountCaption; ECAmountCaptionLbl)
                        { }
                        column(TotalCaption; TotalCaptionLbl)
                        { }
                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(VATCounter.Number);
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
                            //
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
                        column(VATAmtLineVAT1; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier1; VATAmountLine."VAT Identifier")
                        { }
                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(VATCounterLCY.Number);
                            //ini - 'Record "VAT Amount Line" temporary' does not contain a definition for 'VAT+EC Base'
                            // VALVATBaseLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                            //                    "Sales Header"."Posting Date", "Sales Header"."Currency Code",
                            //                    VATAmountLine."VAT+EC Base", "Sales Header"."Currency Factor"));
                            VALVATBaseLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Sales Header"."Posting Date", "Sales Header"."Currency Code", VATAmountLine."VAT Base", "Sales Header"."Currency Factor"));
                            //fin - 'Record "VAT Amount Line" temporary' does not contain a definition for 'VAT+EC Base'
                            VALVATAmountLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Sales Header"."Posting Date", "Sales Header"."Currency Code", VATAmountLine."VAT Amount", "Sales Header"."Currency Factor"));
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or ("Sales Header"."Currency Code" = '') or (VATAmountLine.GetTotalVATAmount = 0) then CurrReport.Break;
                            VATCounterLCY.SetRange(VATCounterLCY.Number, 1, VATAmountLine.Count);
                            //>> BBT. CreateTotals. Marcada como obsoleta. 
                            //CurrReport.CreateTotals(VALVATBaseLCY, VALVATAmountLCY);
                            //
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
                        column(ShowShippingAddr; ShowShippingAddr)
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
                }
                trigger OnAfterGetRecord()
                var
                    SalesPost: Codeunit "Sales-Post";
                begin
                    Clear(SalesLine);
                    Clear(SalesPost);
                    SalesLine.DeleteAll;
                    VATAmountLine.DeleteAll;
                    SalesPost.GetSalesLines("Sales Header", SalesLine, 0);
                    SalesLine.CalcVATAmountLines(0, "Sales Header", SalesLine, VATAmountLine);
                    SalesLine.UpdateVATOnLines(0, "Sales Header", SalesLine, VATAmountLine);
                    VATAmount := VATAmountLine.GetTotalVATAmount;
                    VATBaseAmount := VATAmountLine.GetTotalVATBase;
                    VATDiscountAmount := VATAmountLine.GetTotalVATDiscount("Sales Header"."Currency Code", "Sales Header"."Prices Including VAT");
                    TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;
                    if (VATAmountLine."VAT Calculation Type" = VATAmountLine."vat calculation type"::"Reverse Charge VAT") and "Sales Header"."Prices Including VAT" then begin
                        VATBaseAmount := VATAmountLine.GetTotalLineAmount(false, "Sales Header"."Currency Code");
                        TotalAmountInclVAT := VATAmountLine.GetTotalLineAmount(false, "Sales Header"."Currency Code");
                    end;
                    if CopyLoop.Number > 1 then begin
                        CopyText := FormatDocument.GetCOPYText();
                        OutputNo += 1;
                    end;
                    //CurrReport.PageNo := 1;
                    TotalSubTotal := 0;
                    TotalInvoiceDiscountAmount := 0;
                    TotalAmount := 0;
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then SalesCountPrinted.Run("Sales Header");
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
                CompanyInfo.Get;
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
                    VATNoText := "Sales Header".FieldCaption("Sales Header"."VAT Registration No.");
                if "Sales Header"."Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(Text001, GLSetup."LCY Code");
                    TotalInclVATText := StrSubstNo(Text002, GLSetup."LCY Code");
                    TotalExclVATText := StrSubstNo(Text006, GLSetup."LCY Code");
                end
                else begin
                    TotalText := StrSubstNo(Text001, "Sales Header"."Currency Code");
                    TotalInclVATText := StrSubstNo(Text002, "Sales Header"."Currency Code");
                    TotalExclVATText := StrSubstNo(Text006, "Sales Header"."Currency Code");
                end;
                FormatAddr.SalesHeaderBillTo(CustAddr, "Sales Header");
                //ini - There is no argument given that corresponds to the required formal parameter 'SalesHeader' of 'SalesHeaderShipTo(var array[8] of Text[100], array[8] of Text[100], var Record "Sales Header")'
                // FormatAddr.SalesHeaderShipTo(ShipToAddr, "Sales Header");
                FormatAddr.SalesHeaderShipTo(ShipToAddr, CustAddr, "Sales Header");
                //fin - There is no argument given that corresponds to the required formal parameter 'SalesHeader' of 'SalesHeaderShipTo(var array[8] of Text[100], array[8] of Text[100], var Record "Sales Header")'
                ShowShippingAddr := "Sales Header"."Sell-to Customer No." <> "Sales Header"."Bill-to Customer No.";
                for i := 1 to ArrayLen(ShipToAddr) do if ShipToAddr[i] <> CustAddr[i] then ShowShippingAddr := true;
                if LogInteraction then
                    if not CurrReport.Preview then begin
                        if "Sales Header"."Bill-to Contact No." <> '' then
                            SegManagement.LogDocument(18, "Sales Header"."No.", 0, 0, Database::Contact, "Sales Header"."Bill-to Contact No.", "Sales Header"."Salesperson Code", "Sales Header"."Campaign No.", "Sales Header"."Posting Description", "Sales Header"."Opportunity No.")
                        else
                            SegManagement.LogDocument(18, "Sales Header"."No.", 0, 0, Database::Customer, "Sales Header"."Bill-to Customer No.", "Sales Header"."Salesperson Code", "Sales Header"."Campaign No.", "Sales Header"."Posting Description", "Sales Header"."Opportunity No.");
                    end;
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
                    field(Valorado; Valorado)
                    {
                        ApplicationArea = Basic;
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
            InitLogInteraction;
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
        case SalesSetup."Logo Position on Documents" of
            SalesSetup."logo position on documents"::"No Logo":
                ;
            SalesSetup."logo position on documents"::Left:
                begin
                    CompanyInfo1.Get;
                    CompanyInfo1.CalcFields(Picture);
                end;
            SalesSetup."logo position on documents"::Center:
                begin
                    CompanyInfo2.Get;
                    CompanyInfo2.CalcFields(Picture);
                end;
            SalesSetup."logo position on documents"::Right:
                begin
                    CompanyInfo3.Get;
                    CompanyInfo3.CalcFields(Picture);
                end;
        end;
    end;

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage then InitLogInteraction;
    end;

    var
        Text000: label 'Salesperson', Comment = 'ESP="Vendedor"';
        Text001: label 'Total %1', Comment = 'ESP="Total %1"';
        Text002: label 'Total %1 Incl. VAT', Comment = 'ESP="Total %1 IVA incl."';
        Text004: label 'Return Order Confirmation %1', comment = 'ESP="Confirmación devolución %1"';
        Text005: label 'Page %1', comment = 'ESP="Pág. %1"';
        Text006: label 'Total %1 Excl. VAT', comment = 'ESP="Total %1 IVA excl."';
        GLSetup: Record "General Ledger Setup";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo3: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo: Record "Company Information";
        VATAmountLine: Record "VAT Amount Line" temporary;
        SalesLine: Record "Sales Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        //ini - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
        //Language: Record Language;
        cLanguage: Codeunit Language;
        //fin - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
        CurrExchRate: Record "Currency Exchange Rate";
        SalesCountPrinted: Codeunit "Sales-Printed";
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        CustAddr: array[8] of Text[50];
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
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        LogInteraction: Boolean;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        Text007: label 'VAT Amount Specification in ', comment = 'ESP="Especificar importe IVA en "';
        Text008: label 'Local Currency', comment = 'ESP="Divisa local"';
        Text009: label 'Exchange rate: %1/%2', comment = 'ESP="Tipo cambio: %1/%2"';
        OutputNo: Integer;
        TypeInt: Integer;
        SalesLineNo: Code[20];
        SalesLineLineNo: Integer;
        LogInteractionEnable: Boolean;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        SalesSetup: Record "Sales & Receivables Setup";
        PhoneNoCaptionLbl: label 'Phone No.', comment = 'ESP="Nº teléfono"';
        VATRegNoCaptionLbl: label 'VAT Registration No.', comment = 'ESP="CIF/NIF"';
        GiroNoCaptionLbl: label 'Giro No.', comment = 'ESP="Nº giro postal"';
        BankNameCaptionLbl: label 'Bank', comment = 'ESP="Banco"';
        BankAccNoCaptionLbl: label 'Account No.', comment = 'ESP="Nº cuenta"';
        ReturnOrderNoCaptionLbl: label 'Return Order No.';
        DocumentDateCaptionLbl: label 'Document Date', comment = 'ESP="Fecha emisión documento"';
        HomePageCaptionLbl: label 'Home Page', comment = 'ESP="Página Web"';
        UnitPriceCaptionLbl: label 'Unit Price', comment = 'ESP="Precio venta"';
        DiscPercentCaptionLbl: label 'Discount %', comment = 'ESP="% Descuento"';
        AmountCaptionLbl: label 'Amount', comment = 'ESP="Importe"';
        EmailCaptionLbl: label 'E-Mail', comment = 'ESP="Correo electrónico"';
        AllowInvoiceDiscCaptionLbl: label 'Allow Invoice Discount', comment = 'ESP="Permitir descuento factura"';
        InvDiscAmtCaptionLbl: label 'Invoice Discount Amount', comment = 'ESP="Importe descuento factura"';
        SubtotalCaptionLbl: label 'Subtotal', comment = 'ESP="Subtotal"';
        PaymentDiscReceivedAmtCaptionLbl: label 'Payment Discount Received Amount', comment = 'ESP="Importe recibido descuento pago"';
        PaymentDisconVATCaptionLbl: label 'Payment Discount on VAT', comment = 'ESP="Descuento P.P. sobre IVA"';
        HeaderDimensionsCaptionLbl: label 'Header Dimensions', comment = 'ESP="Dimensiones cabecera"';
        LineDimensionsCaptionLbl: label 'Line Dimensions', comment = 'ESP="Dimensiones línea"';
        VATPercentCaptionLbl: label 'VAT %', comment = 'ESP="% IVA"';
        VATBaseCaptionLbl: label 'VAT Base', comment = 'ESP="Base IVA"';
        VATAmountCaptionLbl: label 'VAT Amount', comment = 'ESP="Importe IVA"';
        VATAmountSpecificationCaptionLbl: label 'VAT Amount Specification', comment = 'ESP="Especificación importe IVA"';
        InvDiscBaseAmtCaptionLbl: label 'Invoice Discount Base Amount', comment = 'ESP="Importe base descuento factura"';
        LineAmtCaptionLbl: label 'Line Amount', comment = 'ESP="Importe línea"';
        InvandPmtDiscountsCaptionLbl: label 'Invoice and Payment Discounts', comment = 'ESP="Descuentos facturas y pagos"';
        VATIdentifierCaptionLbl: label 'VAT Identifier', comment = 'ESP="Identific. IVA"';
        ECCaptionLbl: label 'EC %', comment = 'ESP="% RE"';
        ECAmountCaptionLbl: label 'EC Amount', comment = 'ESP="Importe RE"';
        TotalCaptionLbl: label 'Total', comment = 'ESP="Total';
        ShiptoAddressCaptionLbl: label 'Ship-to Address', comment = 'ESP="Dirección de envío"';
        Valorado: Boolean;
        FormatDocument: Codeunit "Format Document";

    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Sales Return Order") <> '';
    end;

    procedure InitializeRequest(ShowInternalInfoFrom: Boolean; LogInteractionFrom: Boolean)
    begin
        InitLogInteraction;
        ShowInternalInfo := ShowInternalInfoFrom;
        LogInteraction := LogInteractionFrom;
    end;
}
