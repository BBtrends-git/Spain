Report 50002 "Purchase Order 2 v3"
{
    // //INC-2019-02-107551 : Mostrar pie Protección de datos
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/Purchase Order 2 v3.rdl';
    Caption = 'Purchase Order', comment = 'ESP="Pedido de compra"';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(CompanyLogo; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            column(ReportForNavId_1100234024; 1100234024)
            { }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
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
            column(CompanyInfoTextoIsoEsp; CompanyInfo.Text_ISO_ESP)
            { }
            column(CompanyInfoTextoIsoEng; CompanyInfo.Text_ISO_ENG)
            { }
        }
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            RequestFilterFields = "No.", "Buy-from Vendor No.", "No. Printed";
            RequestFilterHeading = 'Purchase Order', comment = 'ESP="Pedido compra"';

            column(ReportForNavId_4458; 4458)
            { }
            column(DocType_PurchHeader; "Document Type")
            { }
            column(No_PurchHeader; "No.")
            { }
            column(HomepageCaption; HomepageCaptionLbl)
            { }
            column(EmailCaption; EmailCaptionLbl)
            { }
            column(AmtCaption; AmtCaptionLbl)
            { }
            column(PaymentTermsCaption; PaymentTermsCaptionLbl)
            { }
            column(ShpMethodCaption; ShpMethodCaptionLbl)
            { }
            column(PrePmtTermsDescCaption; PrePmtTermsDescCaptionLbl)
            { }
            column(DocDateCaption; DocDateCaptionLbl)
            { }
            column(AllowInvDiscCaption; AllowInvDiscCaptionLbl)
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
                    column(OrderCopyText; StrSubstNo(Text004, CopyText))
                    { }
                    column(CompanyAddr1; CompanyAddr[1])
                    { }
                    column(CompanyAddr2; CompanyAddr[2])
                    { }
                    column(CompanyAddr3; CompanyAddr[3])
                    { }
                    column(CompanyAddr4; CompanyAddr[4])
                    { }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    { }
                    column(CompanyInfoHomepage; CompanyInfo."Home Page")
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
                    column(CompanyInfoFaxNo; CompanyInfo."Fax No.")
                    { }
                    column(DocDate_PurchHeader; "Purchase Header"."Document Date")
                    { }
                    column(VATNoText; VATNoText)
                    { }
                    column(VATRegNo_PurchHeader; "Purchase Header"."VAT Registration No.")
                    { }
                    column(PurchaserText; PurchaserText)
                    { }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    { }
                    column(ReferenceText; ReferenceText)
                    { }
                    column(YourReference_PurchHeader; "Purchase Header"."Your Reference")
                    { }
                    column(CompanyAddr5; CompanyAddr[5])
                    { }
                    column(CompanyAddr6; CompanyAddr[6])
                    { }
                    column(BuyfromVenNo_PurchHeader; "Purchase Header"."Buy-from Vendor No.")
                    { }
                    column(BuyFromAddr1; BuyFromAddr[1])
                    { }
                    column(BuyFromAddr2; BuyFromAddr[2])
                    { }
                    column(BuyFromAddr3; BuyFromAddr[3])
                    { }
                    column(BuyFromAddr4; BuyFromAddr[4])
                    { }
                    column(BuyFromAddr5; BuyFromAddr[5])
                    { }
                    column(BuyFromAddr6; BuyFromAddr[6])
                    { }
                    column(BuyFromAddr7; BuyFromAddr[7])
                    { }
                    column(BuyFromAddr8; BuyFromAddr[8])
                    { }
                    column(PricesIncludingVAT_PurchHeader; "Purchase Header"."Prices Including VAT")
                    { }
                    column(OutputNo; OutputNo)
                    { }
                    column(VATBaseDisc_PurchHeader; "Purchase Header"."VAT Base Discount %")
                    { }
                    column(PricesInclVATtxt; PricesInclVATtxt)
                    { }
                    column(ShowInternalInfo; ShowInternalInfo)
                    { }
                    column(PrepmtPayTermsDesc; PrepmtPaymentTerms.Description)
                    { }
                    column(PayTermsDesc; PaymentTerms.Description)
                    { }
                    column(PayMethDesc; PaymentMethod.Description)
                    { }
                    column(ShipMethodDesc; ShipmentMethod.Description)
                    { }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    { }
                    column(VATRegNoCaption; VATRegNoCaptionLbl)
                    { }
                    column(GiroNoCaption; GiroNoCaptionLbl)
                    { }
                    column(BankCaption; BankCaptionLbl)
                    { }
                    column(BankAccNoCaption; BankAccNoCaptionLbl)
                    { }
                    column(OrderNoCaption; OrderNoCaptionLbl)
                    { }
                    column(PageCaption; PageCaptionLbl)
                    { }
                    column(BuyfromVenNo_PurchHeaderCaption; "Purchase Header".FieldCaption("Buy-from Vendor No."))
                    { }
                    column(PricesIncludingVAT_PurchHeaderCaption; "Purchase Header".FieldCaption("Prices Including VAT"))
                    { }
                    column(CACCaption; CACCaptionLbl)
                    { }
                    column(FaxNoCaption; FaxNoCaptionLbl)
                    { }
                    column(VendNoCaption; VendNoCaptionLbl)
                    { }
                    column(ShiptoAddCaption; ShiptoAddCaptionLbl)
                    { }
                    column(AttCaption; AttCaptionLbl)
                    { }
                    column(DeliveryDateCaption; DeliveryDateCaptionLbl)
                    { }
                    column(DeliveryDate2Caption; DeliveryDate2CaptionLbl)
                    { }
                    column(TransportMethodCaption; TransportMethodCaptionLbl)
                    { }
                    column(ETDCaption; ETDCaptionLbl)
                    { }
                    column(ETACaption; ETACaptionLbl)
                    { }
                    column(CurrencyCaption; CurrencyCaptionLbl)
                    { }
                    column(HorarioCaption; HorarioCaptionLbl)
                    { }
                    column(BuyfromContact_PurchHeader; BuyfromContact)
                    { }
                    column(DeliveryDate_PurchHeader; DeliveryDate)
                    { }
                    column(CurrencyCode_PurchHeader; CurrencyCode)
                    { }
                    column(TransportMethodDesc_PurchHeader; TransportMethod.Description)
                    { }
                    column(ETD; "Purchase Header"."ETD PO")
                    { }
                    column(ETA; "Purchase Header"."BBT ETA Planning")
                    { }
                    column(TotalLineCaption; TotalLineCaptionLbl)
                    { }
                    column(LineCaption; LineCaptionLbl)
                    { }
                    column(IntRep; IntRep)
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
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Purchase Header";
                        DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                        column(ReportForNavId_7574; 7574)
                        { }
                        column(DimText; DimText)
                        { }
                        column(HdrDimsCaption; HdrDimsCaptionLbl)
                        { }
                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
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
                    dataitem("Purchase Line"; "Purchase Line")
                    {
                        DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                        DataItemLinkReference = "Purchase Header";
                        DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                        column(ReportForNavId_6547; 6547)
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
                        column(PurchLineLineAmt; PurchLine."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Desc_PurchLine; "Purchase Line".Description)
                        { }
                        column(LineNo_PurchLine; "Purchase Line"."Line No.")
                        { }
                        column(AllowInvDisctxt; AllowInvDisctxt)
                        { }
                        column(Type_PurchLine; Format("Purchase Line".Type, 0, 2))
                        { }
                        column(No_PurchLine; "Purchase Line"."No.")
                        { }
                        column(Quantity_PurchLine; "Purchase Line".Quantity)
                        { }
                        column(UnitofMeasure_PurchLine; "Purchase Line"."Unit of Measure Code")
                        { }
                        column(DirectUnitCost_PurchLine; "Purchase Line"."Direct Unit Cost")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(LineDisc_PurchLine; "Purchase Line"."Line Discount %")
                        { }
                        column(LineAmt_PurchLine; "Purchase Line"."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(AllowInvDisc_PurchLine; "Purchase Line"."Allow Invoice Disc.")
                        { }
                        column(VATIdentifier_PurchLine; "Purchase Line"."VAT Identifier")
                        { }
                        column(InvDiscAmt_PurchLine; -PurchLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //ini - 'Record "Purchase Line" temporary' does not contain a definition for 'Pmt. Disc. Rcd. Amount'
                        // column(LineAmtInvDiscAmt_PurchLine;-PurchLine."Pmt. Disc. Rcd. Amount")
                        // {
                        //     AutoFormatExpression = "Purchase Line"."Currency Code";
                        //     AutoFormatType = 1;
                        // }
                        column(LineAmtInvDiscAmt_PurchLine; -PurchLine."Pmt. Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //fin - 'Record "Purchase Line" temporary' does not contain a definition for 'Pmt. Disc. Rcd. Amount'
                        column(ExpectedReceiptDate_PurchLine; "Purchase Line"."Expected Receipt Date")
                        { }
                        column(TotalInclVATText; TotalInclVATText)
                        { }
                        column(VATAmtLineText; VATAmountLine.VATAmountText)
                        { }
                        column(VATAmt; VATAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalExclVATText; TotalExclVATText)
                        { }
                        column(VATDiscAmt; -VATDiscountAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseAmt; VATBaseAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmtInclVAT; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalSubTotal; TotalSubTotal)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInvDiscAmt; TotalInvoiceDiscountAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmt; TotalAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(DirectUnitCostCaption; DirectUnitCostCaptionLbl)
                        { }
                        column(DiscountPercentCaption; DiscountPercentCaptionLbl)
                        { }
                        column(InvDiscAmtCaption; InvDiscAmtCaptionLbl)
                        { }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        { }
                        column(TotalText; TotalTextLbl)
                        { }
                        column(VATDiscountAmtCaption; VATDiscountAmtCaptionLbl)
                        { }
                        column(Desc_PurchLineCaption; "Purchase Line".FieldCaption(Description))
                        { }
                        column(No_PurchLineCaption; NoPurchLineCaptionLbl)
                        { }
                        column(Quantity_PurchLineCaption; "Purchase Line".FieldCaption(Quantity))
                        { }
                        column(UnitofMeasure_PurchLineCaption; "Purchase Line".FieldCaption("Unit of Measure"))
                        { }
                        column(VATIdentifier_PurchLineCaption; "Purchase Line".FieldCaption("VAT Identifier"))
                        { }
                        column(PurchLineNo; PurchLineNo)
                        { }
                        column(Quantity_Received_PurchLine; PurchLine."Quantity Received")
                        { }
                        column(Quantity_Received_PurchLineCaption; QuantityReceivedLbl)
                        { }
                        //>> BBT 16/06/2026. Cambio de fecha. Se usa para todas las líneas la PurchaseHeader."ETD PO" 
                        //column(PlannedReceiptDate; PurchLine."Planned Receipt Date")
                        column(PlannedReceiptDate; "Purchase Header"."ETD PO")
                        //<<
                        { }
                        column(AdicText; AdicTextLbl)
                        { }
                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                            column(ReportForNavId_3591; 3591)
                            { }
                            column(DimText1; DimText)
                            { }
                            column(LineDimsCaption; LineDimsCaptionLbl)
                            { }
                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
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
                                DimSetEntry2.SetRange("Dimension Set ID", "Purchase Line"."Dimension Set ID");
                            end;
                        }
                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then
                                PurchLine.Find('-')
                            else
                                PurchLine.Next;
                            "Purchase Line" := PurchLine;
                            if not "Purchase Header"."Prices Including VAT" and (PurchLine."VAT Calculation Type" = PurchLine."vat calculation type"::"Full VAT") then PurchLine."Line Amount" := 0;
                            if (PurchLine.Type = PurchLine.Type::"G/L Account") and (not ShowInternalInfo) then "Purchase Line"."No." := '';
                            AllowInvDisctxt := Format("Purchase Line"."Allow Invoice Disc.");
                            TotalSubTotal += "Purchase Line"."Line Amount";
                            TotalInvoiceDiscountAmount -= "Purchase Line"."Inv. Discount Amount";
                            TotalAmount += "Purchase Line".Amount;
                            if "Purchase Line".Type.AsInteger() > 0 then PurchLineNo += 10;
                        end;

                        trigger OnPostDataItem()
                        begin
                            PurchLine.DeleteAll;
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := PurchLine.Find('+');
                            while MoreLines and (PurchLine.Description = '') and (PurchLine."Description 2" = '') and (PurchLine."No." = '') and (PurchLine.Quantity = 0) and (PurchLine.Amount = 0) do MoreLines := PurchLine.Next(-1) <> 0;
                            if not MoreLines then CurrReport.Break;
                            PurchLine.SetRange("Line No.", 0, PurchLine."Line No.");
                            SetRange(Number, 1, PurchLine.Count);
                            //ini - 'Record "Purchase Line" temporary' does not contain a definition for 'Pmt. Disc. Rcd. Amount'
                            //CurrReport.CreateTotals(PurchLine."Line Amount", PurchLine."Inv. Discount Amount", PurchLine."Pmt. Disc. Rcd. Amount");
                            //>> BBT. CreateTotals. Marcada como obsoleta.  
                            //CurrReport.CreateTotals(PurchLine."Line Amount", PurchLine."Inv. Discount Amount", PurchLine."Pmt. Discount Amount");
                            //<<
                            //fin - 'Record "Purchase Line" temporary' does not contain a definition for 'Pmt. Disc. Rcd. Amount'
                            PurchLineNo := 0;
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
                        //     AutoFormatExpression = "Purchase Header"."Currency Code";
                        //     AutoFormatType = 1;
                        // }
                        column(VATAmtLineVATECBase; VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //fin - 'Record "VAT Amount Line" temporary' does not contain a definition for 'VAT+EC Base'
                        column(VATAmtLineVATAmt; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineLineAmt; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //ini - 'Record "VAT Amount Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                        // column(VATAmtLineInvDiscAmtPmtDiscGivenAmt; VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Disc. Given Amount")
                        // {
                        //     AutoFormatExpression = "Purchase Header"."Currency Code";
                        //     AutoFormatType = 1;
                        // }
                        column(VATAmtLineInvDiscAmtPmtDiscGivenAmt; VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //fin - 'Record "VAT Amount Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                        column(VATAmtLineECAmt; VATAmountLine."EC Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT1; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 6;
                        }
                        column(VATAmtLineVATIsdentifier; VATAmountLine."VAT Identifier")
                        { }
                        //ini - 'Record "VAT Amount Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                        // column(VATAmtLineInvDiscAmt1; VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Disc. Given Amount")
                        // {
                        //     AutoFormatExpression = "Purchase Header"."Currency Code";
                        //     AutoFormatType = 1;
                        // }
                        column(VATAmtLineInvDiscAmt1; VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //fin - 'Record "VAT Amount Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                        column(VATAmtLineEC; VATAmountLine."EC %")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATPercentCaption; VATPercentCaptionLbl)
                        { }
                        column(VATBaseCaption; VATBaseCaptionLbl)
                        { }
                        column(VATAmtCaption; VATAmtCaptionLbl)
                        { }
                        column(VATAmtSpecCaption; VATAmtSpecCaptionLbl)
                        { }
                        column(VATIdentCaption; VATIdentCaptionLbl)
                        { }
                        column(InvDiscBaseAmtCaption; InvDiscBaseAmtCaptionLbl)
                        { }
                        column(LineAmtCaption; LineAmtCaptionLbl)
                        { }
                        column(InvDiscAmt1Caption; InvDiscAmt1CaptionLbl)
                        { }
                        column(ECAmtCaption; ECAmtCaptionLbl)
                        { }
                        column(ECCaption; ECCaptionLbl)
                        { }
                        column(TotalCaption; TotalCaptionLbl)
                        { }
                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (VATAmount = 0) and (VATAmountLine."VAT %" + VATAmountLine."EC %" = 0) then CurrReport.Break;
                            SetRange(Number, 1, VATAmountLine.Count);
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
                        column(VALSpecLCYHdr; VALSpecLCYHeader)
                        { }
                        column(VALVATAmtLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT2; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier3; VATAmountLine."VAT Identifier")
                        { }
                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            VALVATBaseLCY := VATAmountLine.GetBaseLCY("Purchase Header"."Posting Date", "Purchase Header"."Currency Code", "Purchase Header"."Currency Factor");
                            VALVATAmountLCY := VATAmountLine.GetAmountLCY("Purchase Header"."Posting Date", "Purchase Header"."Currency Code", "Purchase Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or ("Purchase Header"."Currency Code" = '') or (VATAmountLine.GetTotalVATAmount = 0) then CurrReport.Break;
                            SetRange(Number, 1, VATAmountLine.Count);
                            //>> BBT. CreateTotals. Marcada como obsoleta.  
                            //CurrReport.CreateTotals(VALVATBaseLCY, VALVATAmountLCY);
                            //<<
                            if GLSetup."LCY Code" = '' then
                                VALSpecLCYHeader := Text007 + Text008
                            else
                                VALSpecLCYHeader := Text007 + Format(GLSetup."LCY Code");
                            CurrExchRate.FindCurrency("Purchase Header"."Posting Date", "Purchase Header"."Currency Code", 1);
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
                        column(PaytoVendNo_PurchHeader; "Purchase Header"."Pay-to Vendor No.")
                        { }
                        column(VendAddr8; VendAddr[8])
                        { }
                        column(VendAddr7; VendAddr[7])
                        { }
                        column(VendAddr6; VendAddr[6])
                        { }
                        column(VendAddr5; VendAddr[5])
                        { }
                        column(VendAddr4; VendAddr[4])
                        { }
                        column(VendAddr3; VendAddr[3])
                        { }
                        column(VendAddr2; VendAddr[2])
                        { }
                        column(VendAddr1; VendAddr[1])
                        { }
                        column(PaymentDetailsCaption; PaymentDetailsCaptionLbl)
                        { }
                        trigger OnPreDataItem()
                        begin
                            //IF "Purchase Header"."Buy-from Vendor No." = "Purchase Header"."Pay-to Vendor No." THEN
                            CurrReport.Break;
                        end;
                    }
                    dataitem(Total3; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));

                        column(ReportForNavId_8272; 8272)
                        { }
                        trigger OnPreDataItem()
                        begin
                            //IF ("Purchase Header"."Sell-to Customer No." = '') AND (ShipToAddr[1] = '') THEN
                            CurrReport.Break;
                        end;
                    }
                    dataitem(PrepmtLoop; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                        column(ReportForNavId_1849; 1849)
                        { }
                        column(PrepmtLineAmt; PrepmtLineAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtInvBufGLAccNo; PrepmtInvBuf."G/L Account No.")
                        { }
                        column(PrepmtInvBufDesc; PrepmtInvBuf.Description)
                        { }
                        column(TotalExclVATText1; TotalExclVATText)
                        { }
                        column(PrepmtVATAmtLineTxt; PrepmtVATAmountLine.VATAmountText)
                        { }
                        column(PrepmtVATAmt; PrepmtVATAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATTxt1; TotalInclVATText)
                        { }
                        column(PrepmtInvBufAmtPrepmtVATAmt; PrepmtInvBuf.Amount + PrepmtVATAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtTotalAmtInclVAT; PrepmtTotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Number_IntegerLine; Number)
                        { }
                        column(DescCaption; DescCaptionLbl)
                        { }
                        column(GLAccNoCaption; GLAccNoCaptionLbl)
                        { }
                        column(PrepmtSpecCaption; PrepmtSpecCaptionLbl)
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
                                if Number = 1 then begin
                                    if not TempPrepmtDimSetEntry.FindSet then CurrReport.Break;
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
                            if Number = 1 then begin
                                if not PrepmtInvBuf.Find('-') then CurrReport.Break;
                            end
                            else if PrepmtInvBuf.Next = 0 then CurrReport.Break;
                            if ShowInternalInfo then TempPrepmtDimSetEntry.SetRange("Dimension Set ID", PrepmtInvBuf."Dimension Set ID");
                            if "Purchase Header"."Prices Including VAT" then
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
                        column(PrepmtVATAmtLineVATAmt; PrepmtVATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //ini - 'Record "VAT Amount Line" temporary' does not contain a definition for 'VAT+EC Base'
                        // column(PrepmtVATAmtLineVATBase; PrepmtVATAmountLine."VAT+EC Base")
                        // {
                        //     AutoFormatExpression = "Purchase Header"."Currency Code";
                        //     AutoFormatType = 1;
                        // }
                        column(PrepmtVATAmtLineVATBase; PrepmtVATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //fin - 'Record "VAT Amount Line" temporary' does not contain a definition for 'VAT+EC Base'
                        column(PrepmtVATAmtLineLineAmt; PrepmtVATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmtLineVAT; PrepmtVATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(PrepmtVATAmtLineVATIdentifier; PrepmtVATAmountLine."VAT Identifier")
                        { }
                        column(PrepmtVATAmtSpecCaption; PrepmtVATAmtSpecCaptionLbl)
                        { }
                        column(PrepmtVATPercentCaption; VATPercentCaptionLbl)
                        { }
                        column(PrepmtVATBaseCaption; VATBaseCaptionLbl)
                        { }
                        column(PrepmtVATAmtCaption; VATAmtCaptionLbl)
                        { }
                        column(PrepmtVATIdentCaption; VATIdentCaptionLbl)
                        { }
                        column(PrepmtLineAmtCaption; LineAmtCaptionLbl)
                        { }
                        column(PrepmtTotalCaption; TotalCaptionLbl)
                        { }
                        trigger OnAfterGetRecord()
                        begin
                            PrepmtVATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number, 1, PrepmtVATAmountLine.Count);
                        end;
                    }
                    dataitem(PrepmtTotal; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));

                        column(ReportForNavId_7808; 7808)
                        { }
                        trigger OnPreDataItem()
                        begin
                            if not PrepmtInvBuf.Find('-') then CurrReport.Break;
                        end;
                    }
                }
                trigger OnAfterGetRecord()
                var
                    PrepmtPurchLine: Record "Purchase Line" temporary;
                    TempPurchLine: Record "Purchase Line" temporary;
                begin
                    Clear(PurchLine);
                    Clear(PurchPost);
                    PurchLine.DeleteAll;
                    VATAmountLine.DeleteAll;
                    PurchPost.GetPurchLines("Purchase Header", PurchLine, 0);
                    PurchLine.CalcVATAmountLines(0, "Purchase Header", PurchLine, VATAmountLine);
                    PurchLine.UpdateVATOnLines(0, "Purchase Header", PurchLine, VATAmountLine);
                    VATAmount := VATAmountLine.GetTotalVATAmount;
                    VATBaseAmount := VATAmountLine.GetTotalVATBase;
                    VATDiscountAmount := VATAmountLine.GetTotalVATDiscount("Purchase Header"."Currency Code", "Purchase Header"."Prices Including VAT");
                    TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;
                    if (VATAmountLine."VAT Calculation Type" = VATAmountLine."vat calculation type"::"Reverse Charge VAT") and "Purchase Header"."Prices Including VAT" then begin
                        VATBaseAmount := VATAmountLine.GetTotalLineAmount(false, "Purchase Header"."Currency Code");
                        TotalAmountInclVAT := VATAmountLine.GetTotalLineAmount(false, "Purchase Header"."Currency Code");
                    end;
                    PrepmtInvBuf.DeleteAll;
                    PurchPostPrepmt.GetPurchLines("Purchase Header", 0, PrepmtPurchLine);
                    if not PrepmtPurchLine.IsEmpty then begin
                        PurchPostPrepmt.GetPurchLinesToDeduct("Purchase Header", TempPurchLine);
                        if not TempPurchLine.IsEmpty then PurchPostPrepmt.CalcVATAmountLines("Purchase Header", TempPurchLine, PrePmtVATAmountLineDeduct, 1);
                    end;
                    PurchPostPrepmt.CalcVATAmountLines("Purchase Header", PrepmtPurchLine, PrepmtVATAmountLine, 0);
                    PrepmtVATAmountLine.DeductVATAmountLine(PrePmtVATAmountLineDeduct);
                    PurchPostPrepmt.UpdateVATOnLines("Purchase Header", PrepmtPurchLine, PrepmtVATAmountLine, 0);
                    PurchPostPrepmt.BuildInvLineBuffer("Purchase Header", PrepmtPurchLine, 0, PrepmtInvBuf);
                    PrepmtVATAmount := PrepmtVATAmountLine.GetTotalVATAmount;
                    PrepmtVATBaseAmount := PrepmtVATAmountLine.GetTotalVATBase;
                    PrepmtTotalAmountInclVAT := PrepmtVATAmountLine.GetTotalAmountInclVAT;
                    if Number > 1 then CopyText := FormatDocument.GetCOPYText();
                    //CurrReport.PageNo := 1;
                    OutputNo := OutputNo + 1;
                    TotalSubTotal := 0;
                    TotalAmount := 0;
                    TotalInvoiceDiscountAmount := 0;
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then PurchCountPrinted.Run("Purchase Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 0;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                IntRep := '0';
                if ("Language Code" <> '') and ("Language Code" <> 'ESP') then begin
                    "Language Code" := 'ENU';
                    IntRep := '1';
                end;
                if ("Purchase Header"."Language Code" <> '') and ("Purchase Header"."Language Code" <> 'ESP') then begin
                    //ini - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
                    //CurrReport.Language := Language.GetLanguageID("Language Code");
                    CurrReport.Language := cLanguage.GetLanguageID("Language Code");
                    //fin - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
                end;
                //CompanyInfo.GET;
                if RespCenter.Get("Responsibility Center") then begin
                    RespCenter.Contact := '';
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end
                else begin
                    CompanyInfo."Address 2" := '';
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                end;
                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");
                if "Purchaser Code" = '' then begin
                    SalesPurchPerson.Init;
                    PurchaserText := '';
                end
                else begin
                    SalesPurchPerson.Get("Purchaser Code");
                    PurchaserText := Text000
                end;
                if "Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := FieldCaption("Your Reference");
                if "VAT Registration No." = '' then
                    VATNoText := ''
                else
                    VATNoText := FieldCaption("VAT Registration No.");
                if "Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(Text001, GLSetup."LCY Code");
                    TotalInclVATText := StrSubstNo(Text002, GLSetup."LCY Code");
                    TotalExclVATText := StrSubstNo(Text006, GLSetup."LCY Code");
                end
                else begin
                    TotalText := StrSubstNo(Text001, "Currency Code");
                    TotalInclVATText := StrSubstNo(Text002, "Currency Code");
                    TotalExclVATText := StrSubstNo(Text006, "Currency Code");
                end;
                BuyfromContact := "Buy-from Contact";
                "Ship-to Contact" := '';
                "Buy-from Contact" := '';
                FormatAddr.PurchHeaderBuyFrom(BuyFromAddr, "Purchase Header");
                if not Vendor.Get("Buy-from Vendor No.") then Vendor.Init;
                Index := 1;
                InsertText := 1;
                repeat
                    if BuyFromAddr[Index] = '' then begin
                        case InsertText of
                            1:
                                if "VAT Registration No." <> '' then
                                    BuyFromAddr[Index] := VATRegNoCaptionLbl + ' ' + "VAT Registration No.";
                            2:
                                if Vendor."Phone No." <> '' then
                                    BuyFromAddr[Index] := PhoneNoCaptionLbl + ' ' + Vendor."Phone No.";
                            3:
                                if Vendor."Fax No." <> '' then
                                    BuyFromAddr[Index] := FaxNoCaptionLbl + ' ' + Vendor."Fax No.";
                        end;
                        InsertText := InsertText + 1;
                    end;
                    Index := Index + 1;
                until Index = 9;
                CompressArray(BuyFromAddr);
                if "Buy-from Vendor No." <> "Pay-to Vendor No." then FormatAddr.PurchHeaderPayTo(VendAddr, "Purchase Header");
                if "Payment Terms Code" = '' then
                    PaymentTerms.Init
                else begin
                    PaymentTerms.Get("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                end;
                if "Prepmt. Payment Terms Code" = '' then
                    PrepmtPaymentTerms.Init
                else begin
                    PrepmtPaymentTerms.Get("Prepmt. Payment Terms Code");
                    PrepmtPaymentTerms.TranslateDescription(PrepmtPaymentTerms, "Language Code");
                end;
                if "Shipment Method Code" = '' then
                    ShipmentMethod.Init
                else begin
                    ShipmentMethod.Get("Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                end;
                FormatAddr.PurchHeaderShipTo(ShipToAddr, "Purchase Header");
                ShowCashAccountingCriteria("Purchase Header");
                if not CurrReport.Preview then begin
                    if ArchiveDocument then ArchiveManagement.StorePurchDocument("Purchase Header", LogInteraction);
                    if LogInteraction then begin
                        CalcFields("No. of Archived Versions");
                        SegManagement.LogDocument(13, "No.", "Doc. No. Occurrence", "No. of Archived Versions", Database::Vendor, "Buy-from Vendor No.", "Purchaser Code", '', "Posting Description", '');
                    end;
                end;
                PricesInclVATtxt := Format("Prices Including VAT");
                if not TransportMethod.Get("Transport Method") then TransportMethod.Init;
                if not PaymentMethod.Get("Payment Method Code") then PaymentMethod.Init;
                //>> BBT 16/06/2026. Cambio de fecha. Se usa para todas las líneas la PurchaseHeader."ETD PO" 
                //DeliveryDate := "Expected Receipt Date";
                DeliveryDate := "Purchase Header"."ETD PO";
                //<<
                CurrencyCode := "Currency Code";
                if CurrencyCode = '' then CurrencyCode := 'EUR';
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

                    field(NoofCopies; NoOfCopies)
                    {
                        ApplicationArea = Basic;
                        Caption = 'No. of Copies', comment = 'ESP="Nº copias"';
                    }
                    field(ShowInternalInformation; ShowInternalInfo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Internal Information', comment = 'ESP="Mostrar información interna"';
                    }
                    field(ArchiveDocument; ArchiveDocument)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Archive Document', comment = 'ESP="Archivar documento"';

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
            // ArchiveDocument := PurchSetup."Archive Quotes and Orders";
            ArchiveDocument := PurchSetup."Archive Orders";
            //fin - Field 'Archive Quotes and Orders' is removed. Reason: Replaced by new fields Archive Quotes and Archive Orders. Tag: 18.0.
            LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Purch. Ord.") <> '';
            LogInteractionEnable := LogInteraction;
        end;
    }
    labels
    {
    }
    trigger OnInitReport()
    begin
        GLSetup.Get;
        PurchSetup.Get;
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        Text000: label 'Purchaser', comment = 'ESP="Comprador"';
        Text001: label 'Total %1', Comment = 'ESP="Total %1"';
        Text002: label 'Total %1 Incl. VAT', Comment = 'ESP="Total %1 IVA incl."';
        Text004: label 'Order %1', comment = 'ESP="Pedido %1"';
        Text006: label 'Total %1 Excl. VAT', comment = 'ESP="Total %1 IVA excl."';
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PrepmtPaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        VATAmountLine: Record "VAT Amount Line" temporary;
        PrepmtVATAmountLine: Record "VAT Amount Line" temporary;
        PrePmtVATAmountLineDeduct: Record "VAT Amount Line" temporary;
        PurchLine: Record "Purchase Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        TempPrepmtDimSetEntry: Record "Dimension Set Entry" temporary;
        PrepmtInvBuf: Record "Prepayment Inv. Line Buffer" temporary;
        RespCenter: Record "Responsibility Center";
        //ini - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
        // Language: Record Language;
        cLanguage: Codeunit Language;
        //fin - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
        CurrExchRate: Record "Currency Exchange Rate";
        PurchSetup: Record "Purchases & Payables Setup";
        Vendor: Record Vendor;
        TransportMethod: Record "Transport Method";
        PaymentMethod: Record "Payment Method";
        PurchCountPrinted: Codeunit "Purch.Header-Printed";
        FormatAddr: Codeunit "Format Address";
        PurchPost: Codeunit "Purch.-Post";
        ArchiveManagement: Codeunit ArchiveManagement;
        SegManagement: Codeunit SegManagement;
        PurchPostPrepmt: Codeunit "Purchase-Post Prepayments";
        VendAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        BuyFromAddr: array[8] of Text[50];
        PurchaserText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalInclVATText: Text[50];
        TotalExclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        OutputNo: Integer;
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
        VALExchRate: Text[50];
        Text007: label 'VAT Amount Specification in ', comment = 'ESP="Especificar importe IVA en "';
        Text008: label 'Local Currency', comment = 'ESP="Divisa local"';
        Text009: label 'Exchange rate: %1/%2', comment = 'ESP="Tipo cambio: %1/%2"';
        PrepmtVATAmount: Decimal;
        PrepmtVATBaseAmount: Decimal;
        PrepmtTotalAmountInclVAT: Decimal;
        PrepmtLineAmount: Decimal;
        PricesInclVATtxt: Text[30];
        AllowInvDisctxt: Text[30];
        ArchiveDocumentEnable: Boolean;
        LogInteractionEnable: Boolean;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        PhoneNoCaptionLbl: label 'Phone', comment = 'ESP="Teléfono"';
        VATRegNoCaptionLbl: label 'NIF', comment = 'ESP="NIF"';
        GiroNoCaptionLbl: label 'Giro No.', comment = 'ESP="Nº giro postal"';
        BankCaptionLbl: label 'Bank', comment = 'ESP="Banco"';
        BankAccNoCaptionLbl: label 'Account No.', comment = 'ESP="Nº cuenta"';
        OrderNoCaptionLbl: label 'Purchase order nº', comment = 'ESP="Pedido compra nº"';
        PageCaptionLbl: label 'Page', comment = 'ESP="Página"';
        HdrDimsCaptionLbl: label 'Header Dimensions', comment = 'ESP="Dimensiones cabecera"';
        DirectUnitCostCaptionLbl: label 'Price', comment = 'ESP="Precio"';
        DiscountPercentCaptionLbl: label 'Disc. %', comment = 'ESP="% Dto."';
        InvDiscAmtCaptionLbl: label 'Invoice Discount Amount', comment = 'ESP="Importe descuento factura"';
        SubtotalCaptionLbl: label 'Subtotal', comment = 'ESP="Subtotal"';
        TotalTextLbl: label 'Payment Discount Received Amount', comment = 'ESP="Importe recibido descuento pago"';
        VATDiscountAmtCaptionLbl: label 'Payment Discount on VAT', comment = 'ESP="Descuento P.P. sobre IVA"';
        LineDimsCaptionLbl: label 'Line Dimensions', comment = 'ESP="Dimensiones línea"';
        VATPercentCaptionLbl: label 'VAT %', comment = 'ESP="% IVA"';
        VATBaseCaptionLbl: label 'VAT Base', comment = 'ESP="Base IVA"';
        VATAmtCaptionLbl: label 'VAT Amount', comment = 'ESP="Importe IVA"';
        VATAmtSpecCaptionLbl: label 'VAT Amount Specification', comment = 'ESP="Especificación importe IVA"';
        VATIdentCaptionLbl: label 'VAT Identifier', comment = 'ESP="Identific. IVA"';
        InvDiscBaseAmtCaptionLbl: label 'Invoice Discount Base Amount', comment = 'ESP="Importe base descuento factura"';
        LineAmtCaptionLbl: label 'Line Amount', comment = 'ESP="Importe línea"';
        InvDiscAmt1CaptionLbl: label 'Invoice and Payment Discounts', comment = 'ESP="Descuentos facturas y pagos"';
        ECAmtCaptionLbl: label 'EC Amount', comment = 'ESP="Importe RE"';
        ECCaptionLbl: label 'EC %', comment = 'ESP="% RE"';
        TotalCaptionLbl: label 'Total', comment = 'ESP="Total';
        PaymentDetailsCaptionLbl: label 'Payment Details', comment = 'ESP="Detalles del pago"';
        VendNoCaptionLbl: label 'Supplier', comment = 'ESP="Proveedor"';
        ShiptoAddCaptionLbl: label 'Delivery Location', comment = 'ESP="Almacén de entraga"';
        DescCaptionLbl: label 'Description', comment = 'ESP="Descripción"';
        GLAccNoCaptionLbl: label 'G/L Account No.', comment = 'ESP="Nº cuenta"';
        PrepmtSpecCaptionLbl: label 'Prepayment Specification', comment = 'ESP="Especificación prepago"';
        PrepmtVATAmtSpecCaptionLbl: label 'Prepayment VAT Amount Specification', comment = 'ESP="Especificación importe IVA prepago"';
        HomepageCaptionLbl: label 'Home Page', comment = 'ESP="Página Web"';
        EmailCaptionLbl: label 'E-Mail', comment = 'ESP="Correo electrónico"';
        AmtCaptionLbl: label 'Amount', comment = 'ESP="Importe"';
        PaymentTermsCaptionLbl: label 'Payment', comment = 'ESP="Forma de pago"';
        ShpMethodCaptionLbl: label 'Incoterms', comment = 'ESP="Portes"';
        PrePmtTermsDescCaptionLbl: label 'Prepayment Payment Terms', comment = 'ESP="Condiciones prepago"';
        DocDateCaptionLbl: label 'Dated', comment = 'ESP="de fecha"';
        AllowInvDiscCaptionLbl: label 'Allow Invoice Discount', comment = 'ESP="Permitir descuento factura"';
        CACCaptionLbl: Text;
        CACTxt: label 'Régimen especial del criterio de caja', comment = 'ESP="Régimen especial del criterio de caja"';
        FaxNoCaptionLbl: label 'Fax', comment = 'ESP="Fax"';
        Index: Integer;
        InsertText: Integer;
        AttCaptionLbl: label 'Attn:', comment = 'ESP="A la atención de"';
        DeliveryDateCaptionLbl: label 'Delivery date', comment = 'ESP="Fecha entrega"';
        DeliveryDate2CaptionLbl: label 'Delivery Date ', comment = 'ESP="F. Entreg."';
        ShipmentMethodCaptionLbl: label 'Incoterms', comment = 'ESP="Portes"';
        TransportMethodCaptionLbl: label 'Shipment Method', comment = 'ESP="Medio envío"';
        ETDCaptionLbl: label 'ETD';
        ETACaptionLbl: label 'ETA';
        CurrencyCaptionLbl: label 'Currency', comment = 'ESP="Divisa"';
        BuyfromContact: Text[50];
        DeliveryDate: Date;
        CurrencyCode: Text[10];
        HorarioCaptionLbl: label 'Horario de descarga';
        NoPurchLineCaptionLbl: label 'Item', comment = 'ESP="Art."';
        IntRep: Text[1];
        TotalLineCaptionLbl: label 'Total Amount', comment = 'ESP="Importe líneas"';
        LineCaptionLbl: label 'Line', comment = 'ESP="Lín."';
        PurchLineNo: Integer;
        QuantityReceivedLbl: label 'Delivery Qty', comment = 'ESP="Cantidad Entregada"';
        AdicTextLbl: label 'This order is subject to the latest conditions agreed between parties', comment = 'ESP="Este pedido está sujeto a las últimas condiciones pactadas entre las partes"';
        FormatDocument: Codeunit "Format Document";

    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewArchiveDocument: Boolean; NewLogInteraction: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        ArchiveDocument := NewArchiveDocument;
        LogInteraction := NewLogInteraction;
    end;

    procedure ShowCashAccountingCriteria(PurchaseHeader: Record "Purchase Header"): Text
    var
        VATPostingSetup: Record "VAT Posting Setup";
        PurchaseLine: Record "Purchase Line";
    begin
        GLSetup.Get;
        if not GLSetup."Unrealized VAT" then exit;
        CACCaptionLbl := '';
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        if PurchaseLine.FindSet then
            repeat
                if VATPostingSetup.Get(PurchaseHeader."VAT Bus. Posting Group", PurchaseLine."VAT Prod. Posting Group") then if VATPostingSetup."VAT Cash Regime" then CACCaptionLbl := CACTxt;
            until (PurchaseLine.Next = 0) or (CACCaptionLbl <> '');
        exit(CACCaptionLbl);
    end;
}
