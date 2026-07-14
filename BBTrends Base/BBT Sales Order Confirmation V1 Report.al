Report 50029 "Confirmacion Pedido V1"
{
    // //INC-2019-01-105854 : Mostrar pie Protección de datos
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/Confirmacion Pedido V1.rdl';
    Caption = 'Sales - Order', comment = 'ESP="Venta - Confirmación"';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Sales Quote', comment = 'ESP="Oferta venta"';

            column(ReportForNavId_6640; 6640)
            { }
            column(TXTRefCliente; TXTRefCliente)
            { }
            column(TXTFechaEntrega; TXTFechaEntrega)
            { }
            column(TXTTitulo; TXTTitulo)
            { }
            column(FormaPago; FormaPago)
            { }
            column(Domiciliacion1; Domiciliacion[1])
            { }
            column(Domiciliacion2; Domiciliacion[2])
            { }
            column(DatosComercial3; DatosComercial[3])
            { }
            column(DatosComercial2; DatosComercial[2])
            { }
            column(DatosComercial1; DatosComercial[1])
            { }
            column(TXTDomiciliacion; TXTDomiciliacion)
            { }
            column(TXTFormaPago; TXtFormaPago)
            { }
            column(TXTComercial; TXTComercial)
            { }
            column(MedioEnvio; MedioEnvio)
            { }
            column(CondEnvio; CondEnvio)
            { }
            column(TXTMedioEnvio; TXTMedioEnvio)
            { }
            column(TXTCondEnvio; TXTCondEnvio)
            { }
            column(SelltoCustNo_SalesHeader; "Sales Header"."Sell-to Customer No.")
            { }
            column(ShiptoAddressCaption; ShiptoAddressCaptionLbl)
            { }
            column(SelltoCustNo_SalesHeaderCaption; "Sales Header".FieldCaption("Sell-to Customer No."))
            { }
            column(VATIdentifierCaption; VATIdentifierCaptionLbl)
            { }
            column(PaymentTermsCaption; PaymentTermsCaptionLbl)
            { }
            column(ShipmentMethodCaption; ShipmentMethodCaptionLbl)
            { }
            column(PaymentMethodCaption; PaymentMethodCaptionLbl)
            { }
            column(DocumentDateCaption; DocumentDateCaptionLbl)
            { }
            column(AllowInvDiscCaption; AllowInvDiscCaptionLbl)
            { }
            column(CodDivisa; CurrText)
            { }
            column(TotalSinIVA; "Sales Header".Amount)
            { }
            column(TXTTotal; TXTTotal)
            { }
            column(DocType_SalesHeader; "Sales Header"."Document Type")
            { }
            column(No_SalesHeader; "Sales Header"."No.")
            { }
            column(CompanyInfoPicture; CompanyInfo.Picture)
            { }
            column(PaymentTermsDescription; PaymentTerms.Description)
            { }
            column(ShipmentMethodDescription; ShipmentMethod.Description)
            { }
            column(PaymentMethodDescription; PaymentMethod.Description)
            { }
            column(SalesCopyText; StrSubstNo(Text004, CopyText))
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
            column(No1_SalesHeader; "Sales Header"."No.")
            { }
            column(ReferenceText; ReferenceText)
            { }
            column(YourReference_SalesHeader; "Sales Header"."Your Reference")
            { }
            column(CustAddr7; CustAddr[7])
            { }
            column(CustAddr8; CustAddr[8])
            { }
            column(CompanyAddr5; CompanyAddr[5])
            { }
            column(CompanyAddr6; CompanyAddr[6])
            { }
            column(PricesIncludingVAT_SalesHdr; "Sales Header"."Prices Including VAT")
            { }
            column(PageCaption; StrSubstNo(Text005, ''))
            { }
            column(OutputNo; OutputNo)
            { }
            column(PricesInclVATYesNo_SalesHdr; Format("Sales Header"."Prices Including VAT"))
            { }
            column(PhoneNoCaption; PhoneNoCaptionLbl)
            { }
            column(VATRegNoCaption; VATRegNoCaptionLbl)
            { }
            column(GiroNoCaption; GiroNoCaptionLbl)
            { }
            column(BankNameCaption; BankNameCaptionLbl)
            { }
            column(BankAccountNoCaption; BankAccountNoCaptionLbl)
            { }
            column(ShipmentDateCaption; ShipmentDateCaptionLbl)
            { }
            column(QuoteNoCaption; QuoteNoCaptionLbl)
            { }
            column(HomepageCaption; HomepageCaptionLbl)
            { }
            column(EMailCaption; EMailCaptionLbl)
            { }
            column(BilltoCustNo_SalesHeaderCaption; "Sales Header".FieldCaption("Bill-to Customer No."))
            { }
            column(PricesIncludingVAT_SalesHdrCaption; "Sales Header".FieldCaption("Prices Including VAT"))
            { }
            column(DirEntregaTxt; DirEntregaTxt)
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
            column(OfertNoTxt; OfertNoTxt)
            { }
            column(DeFechaTxt; DeFechaTxt)
            { }
            column(DivisaTxt; DivisaTxt)
            { }
            column(CurrText; CurrText)
            { }
            column(AtencionTxt; AtencionTxt)
            { }
            column(VentaAtencion; "Sales Header"."Sell-to Contact")
            { }
            column(SReferencia; SReferencia)
            { }
            column(CompanyAddr8; CompanyAddr[8])
            { }
            column(CompanyAddr7; CompanyAddr[7])
            { }
            column(ExternalDoc; "Sales Header"."External Document No.")
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
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                        column(ReportForNavId_7574; 7574)
                        { }
                        column(DimText; DimText)
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
                        column(FechaEntrega; FechaEntrega)
                        { }
                        column(LineAmt_SalesLine; SalesLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(No_SalesLine; "Sales Line"."No.")
                        { }
                        column(Description1_SalesLine; "Sales Line".Description)
                        { }
                        column(Quantity_SalesLine; "Sales Line".Quantity)
                        { }
                        column(UnitofMeasure_SalesLine; Unidades)
                        { }
                        column(NetoUnit; NetoUnit)
                        { }
                        column(LineAmt1_SalesLine; "Sales Line"."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(UnitPrice_SalesLine; "Sales Line"."Unit Price")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(LineDiscount_SalesLine; "Sales Line"."Line Discount %")
                        { }
                        column(AllowInvoiceDisc_SalesLine; "Sales Line"."Allow Invoice Disc.")
                        {
                            IncludeCaption = false;
                        }
                        column(VATIdentifier_SalesLine; "Sales Line"."VAT Identifier")
                        { }
                        column(Type_SalesLine; Format("Sales Line".Type))
                        { }
                        column(No1_SalesLine; "Sales Line"."Line No.")
                        { }
                        column(AllowInvoiceDisYesNo; Format("Sales Line"."Allow Invoice Disc."))
                        { }
                        column(SalesLineInvDiscountAmount; -SalesLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(DiscTotalAmt_SalesInvLine; "Sales Line"."Line Discount Amount")
                        { }
                        //ini - 'Record "Sales Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                        // column(DiscountAmt_SalesLine;-SalesLine."Pmt. Disc. Given Amount")
                        // {
                        //     AutoFormatExpression = "Sales Header"."Currency Code";
                        //     AutoFormatType = 1;
                        // }
                        column(DiscountAmt_SalesLine; -SalesLine."Pmt. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //fin - 'Record "Sales Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                        column(VATAmtText_VATAmtLine; VATAmountLine.VATAmountText)
                        { }
                        column(TotalExclVATText; TotalExclVATText)
                        { }
                        column(TotalInclVATText; TotalInclVATText)
                        { }
                        column(VATAmount; VATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesLine_PricesIncludingVAt; "Sales Header"."Prices Including VAT")
                        { }
                        column(VATDiscountAmount; -VATDiscountAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmountInclVAT; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseAmount; VATBaseAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        { }
                        column(DiscountPercentCaption; DiscountPercentCaptionLbl)
                        { }
                        column(AmountCaption; AmountCaptionLbl)
                        { }
                        column(InvDiscAmtCaption; InvDiscAmtCaptionLbl)
                        { }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        { }
                        column(PmtDiscGivenAmt; PmtDiscGivenAmtLbl)
                        { }
                        column(PmtDiscVATCaption; PmtDiscVATCaptionLbl)
                        { }
                        column(No_SalesLineCaption; TXTArticulo)
                        { }
                        column(Description1_SalesLineCaption; "Sales Line".FieldCaption(Description))
                        { }
                        column(Quantity_SalesLineCaption; UnitsCaptionLbl)
                        { }
                        column(TotalDiscCaption; TotalDiscCaptionLbl)
                        { }
                        column(NetUnitCaption; NetUnitCaptionLbl)
                        { }
                        column(UnitofMeasure_SalesLineCaption; "Sales Line".FieldCaption("Unit of Measure"))
                        { }
                        //ini - Field 'Cross-Reference No.' is marked for removal. Reason: Cross-Reference replaced by Item Reference feature.. Tag: 17.0.
                        // column(CrossReference; "Sales Line"."Cross-Reference No.")
                        // { }
                        column(CrossReference; "Sales Line"."Item Reference No.")
                        { }
                        //fin - Field 'Cross-Reference No.' is marked for removal. Reason: Cross-Reference replaced by Item Reference feature.. Tag: 17.0.
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
                            //>> Precio Neto Unitario
                            NetoUnit := 0;
                            if "Sales Line".Quantity <> 0 then NetoUnit := ROUND("Sales Line"."Line Amount" / "Sales Line".Quantity, 0.01);
                            //<<
                            if not "Sales Header"."Prices Including VAT" and (SalesLine."VAT Calculation Type" = SalesLine."vat calculation type"::"Full VAT") then SalesLine."Line Amount" := 0;
                            if (SalesLine.Type = SalesLine.Type::"G/L Account") and (not ShowInternalInfo) then "Sales Line"."No." := '';
                            Unidades := "Sales Line"."Unit of Measure Code";
                            if ("Sales Header"."Language Code" <> '') and ("Sales Header"."Language Code" <> 'ESP') then if rUnidades.Get("Sales Line"."Unit of Measure Code") then Unidades := rUnidades."International Standard Code";
                            FechaEntrega := Format("Sales Line"."Planned Delivery Date");
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
                        // column(VATBase_VATAmtLine; VATAmountLine."VAT+EC Base")
                        // {
                        //     AutoFormatExpression = "Sales Header"."Currency Code";
                        //     AutoFormatType = 1;
                        // }
                        column(VATBase_VATAmtLine; VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //fin - 'Record "VAT Amount Line" temporary' does not contain a definition for 'VAT+EC Base'
                        column(VATAmt_VATAmtLine; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(LineAmt_VATAmtLine; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(InvDiscBaseAmt_VATAmtLine; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //ini - 'Record "VAT Amount Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                        // column(InvDiscountAmt_VATAmtLine; VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Disc. Given Amount")
                        // {
                        //     AutoFormatExpression = "Sales Header"."Currency Code";
                        //     AutoFormatType = 1;
                        // }
                        column(InvDiscountAmt_VATAmtLine; VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //fin - 'Record "VAT Amount Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                        column(ECAmount_VATAmtLine; VATAmountLine."EC Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VAT_VATAmtLine; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 6;
                        }
                        column(VATIdentifier_VATAmtLine; VATAmountLine."VAT Identifier")
                        { }
                        column(EC_VATAmtLine; VATAmountLine."EC %")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATPercentCaption; VATPercentCaptionLbl)
                        { }
                        column(VATECBaseCaption; VATECBaseCaptionLbl)
                        { }
                        column(VATAmtCaption; VATAmtCaptionLbl)
                        { }
                        column(VATAmountSpecCaption; VATAmountSpecCaptionLbl)
                        { }
                        column(LineAmtCaption; LineAmtCaptionLbl)
                        { }
                        column(InvDiscBaseAmtCaption; InvDiscBaseAmtCaptionLbl)
                        { }
                        column(InvPmtDiscCaption; InvPmtDiscCaptionLbl)
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
                        column(VATCtrl_VATAmtLine; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATIdentifier1_VATAmtLine; VATAmountLine."VAT Identifier")
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
                                VALSpecLCYHeader := Text008 + Text009
                            else
                                VALSpecLCYHeader := Text008 + Format(GLSetup."LCY Code");
                            CurrExchRate.FindCurrency("Sales Header"."Order Date", "Sales Header"."Currency Code", 1);
                            VALExchRate := StrSubstNo(Text010, CurrExchRate."Relational Exch. Rate Amount", CurrExchRate."Exchange Rate Amount");
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
            var
                "Sell-to Country": Text[50];
            begin
                if ("Sales Header"."Language Code" <> '') and ("Sales Header"."Language Code" <> 'ESP') then begin
                    //ini - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
                    //CurrReport.Language := Language.GetLanguageID('ENU');
                    CurrReport.Language := cLanguage.GetLanguageID('ENU');
                    //fin - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
                end;
                if RespCenter.Get("Sales Header"."Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end
                else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                CompanyAddr[1] := CompanyAddr[1];
                CompanyAddr[9] := TXTTel + CompanyInfo."Phone No.";
                //CompanyAddr[10] := 'Fax:' + CompanyInfo."Telex No.";
                CompanyAddr[10] := 'CIF:' + CompanyInfo."VAT Registration No.";
                CompressArray(CompanyAddr);
                DimSetEntry1.SetRange("Dimension Set ID", "Sales Header"."Dimension Set ID");
                if "Sales Header"."Salesperson Code" = '' then begin
                    SalesPurchPerson.Init;
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
                    TotalInclVATText := StrSubstNo(Text1100000, GLSetup."LCY Code");
                    TotalExclVATText := StrSubstNo(Text1100001, GLSetup."LCY Code");
                end
                else begin
                    TotalText := StrSubstNo(Text001, "Sales Header"."Currency Code");
                    TotalInclVATText := StrSubstNo(Text1100000, "Sales Header"."Currency Code");
                    TotalExclVATText := StrSubstNo(Text1100001, "Sales Header"."Currency Code");
                end;
                FormatAddr.SalesHeaderSellTo(CustAddr, "Sales Header");
                CustAddr[1] := "Sales Header"."Sell-to Customer No." + ' - ' + CustAddr[1];
                CustAddr[9] := 'CIF:' + "Sales Header"."VAT Registration No.";
                CompressArray(CustAddr);
                if "Sales Header"."Payment Terms Code" = '' then
                    PaymentTerms.Init
                else begin
                    PaymentTerms.Get("Sales Header"."Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Sales Header"."Language Code");
                end;
                if "Sales Header"."Payment Method Code" = '' then
                    PaymentMethod.Init
                else
                    PaymentMethod.Get("Sales Header"."Payment Method Code");
                if "Sales Header"."Shipment Method Code" = '' then
                    ShipmentMethod.Init
                else begin
                    ShipmentMethod.Get("Sales Header"."Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Sales Header"."Language Code");
                end;
                if Country.Get("Sales Header"."Sell-to Country/Region Code") then "Sell-to Country" := Country.Name;
                //ini - There is no argument given that corresponds to the required formal parameter 'SalesHeader' of 'SalesHeaderShipTo(var array[8] of Text[100], array[8] of Text[100], var Record "Sales Header")'                
                // FormatAddr.SalesHeaderShipTo(ShipToAddr, "Sales Header");
                FormatAddr.SalesHeaderShipTo(ShipToAddr, CustAddr, "Sales Header");
                //fin - There is no argument given that corresponds to the required formal parameter 'SalesHeader' of 'SalesHeaderShipTo(var array[8] of Text[100], array[8] of Text[100], var Record "Sales Header")'                
                ShowShippingAddr := "Sales Header"."Sell-to Customer No." <> "Sales Header"."Bill-to Customer No.";
                for i := 1 to ArrayLen(ShipToAddr) do if (ShipToAddr[i] <> CustAddr[i]) and (ShipToAddr[i] <> '') and (ShipToAddr[i] <> "Sell-to Country") then ShowShippingAddr := true;
                if Print then begin
                    if ArchiveDocument then ArchiveManagement.StoreSalesDocument("Sales Header", LogInteraction);
                    if LogInteraction then begin
                        "Sales Header".CalcFields("Sales Header"."No. of Archived Versions");
                        if "Sales Header"."Bill-to Contact No." <> '' then
                            SegManagement.LogDocument(1, "Sales Header"."No.", "Sales Header"."Doc. No. Occurrence", "Sales Header"."No. of Archived Versions", Database::Contact, "Sales Header"."Bill-to Contact No.", "Sales Header"."Salesperson Code", "Sales Header"."Campaign No.", "Sales Header"."Posting Description", "Sales Header"."Opportunity No.")
                        else
                            SegManagement.LogDocument(1, "Sales Header"."No.", "Sales Header"."Doc. No. Occurrence", "Sales Header"."No. of Archived Versions", Database::Customer, "Sales Header"."Bill-to Customer No.", "Sales Header"."Salesperson Code", "Sales Header"."Campaign No.", "Sales Header"."Posting Description", "Sales Header"."Opportunity No.");
                    end;
                end;
                Clear(CurrText);
                if "Sales Header"."Currency Code" = '' then
                    CurrText := 'EUR'
                else
                    CurrText := "Sales Header"."Currency Code";
                "Sales Header".Mark(true);
                "Sales Header".CalcFields(Amount);
                CondEnvio := '';
                rShipmentMethod.Reset();
                if rShipmentMethod.Get("Sales Header"."Shipment Method Code") then begin
                    CondEnvio := rShipmentMethod.Code + ' - ' + rShipmentMethod.Description;
                    if "Sales Header"."Language Code" <> '' then begin
                        rShipTransMethod.Reset();
                        rShipTransMethod.SetRange("Language Code", "Sales Header"."Language Code");
                        rShipTransMethod.SetRange("Shipment Method", "Sales Header"."Shipment Method Code");
                        if rShipTransMethod.FindSet() then CondEnvio := rShipmentMethod.Code + ' - ' + rShipTransMethod.Description;
                    end;
                end;
                DatosComercial[1] := '';
                DatosComercial[2] := '';
                DatosComercial[3] := '';
                if "Sales Header"."Salesperson Code" <> '' then begin
                    rComercial.Reset();
                    if rComercial.Get("Sales Header"."Salesperson Code") then begin
                        DatosComercial[1] := rComercial.Name;
                        DatosComercial[2] := rComercial."Phone No.";
                        DatosComercial[3] := rComercial."E-Mail";
                    end;
                end;
                Domiciliacion[1] := '';
                Domiciliacion[2] := '';
                Domiciliacion[3] := '';
                rBanco.Reset();
                CodBanco := "Sales Header"."Cust. Bank Acc. Code";
                if CodBanco = '' then if rCustomer.Get("Sales Header"."Sell-to Customer No.") then CodBanco := rCustomer."Collection Bank Account";
                if "Sales Header"."Cust. Bank Acc. Code" <> '' then begin
                    rBanco.SetRange(Code, "Sales Header"."Cust. Bank Acc. Code");
                    rBanco.SetRange("Customer No.", "Sales Header"."Sell-to Customer No.");
                    if rBanco.FindSet() then begin
                        Domiciliacion[1] := rBanco.Name;
                        Domiciliacion[2] := rBanco.Iban;
                        Domiciliacion[3] := rBanco."SWIFT Code";
                    end;
                end
                else begin
                    if rBancoCobro.Get(CodBanco) then begin
                        Domiciliacion[1] := rBancoCobro.Name;
                        Domiciliacion[2] := rBancoCobro.Iban;
                        Domiciliacion[3] := rBancoCobro."SWIFT Code";
                    end;
                end;
                FormaPago := '';
                if "Sales Header"."Payment Method Code" <> '' then if PaymentMethod.Get("Sales Header"."Payment Method Code") then FormaPago := "Sales Header"."Payment Method Code" + ' - ' + PaymentMethod.Description;
                if "Sales Header"."Payment Terms Code" <> '' then
                    if rTerminosPago.Get("Sales Header"."Payment Terms Code") then
                        if ("Sales Header"."Language Code" = '') or ("Sales Header"."Language Code" = 'ESP') then
                            FormaPago := FormaPago + ', ' + rTerminosPago.Description
                        else begin
                            rTradTerminosPago.Reset();
                            rTradTerminosPago.SetRange("Payment Term", "Sales Header"."Payment Terms Code");
                            rTradTerminosPago.SetRange("Language Code", 'ENU|ENG');
                            if rTradTerminosPago.FindSet() then FormaPago := FormaPago + ', ' + rTradTerminosPago.Description
                        end;
            end;

            trigger OnPostDataItem()
            var
                ToDo: Record "To-do";
                FileManagement: Codeunit "File Management";
            begin
                "Sales Header".MarkedOnly := true;
                Commit;
                CurrReport.Language := GlobalLanguage;
                //ini - 'Codeunit "File Management"' does not contain a definition for 'IsWebClient'
                //    - 'Record "Sales Header"' does not contain a definition for 'CreateTodo'
                // if not FileManagement.IsWebClient then
                //     if "Sales Header".Find('-') and ToDo.WritePermission then
                //         if Print and (NoOfRecords = 1) then
                //             if Confirm(Text007) then
                //                 "Sales Header".CreateTodo;
                //fin - 'Codeunit "File Management"' does not contain a definition for 'IsWebClient'
                //    - 'Record "Sales Header"' does not contain a definition for 'CreateTodo'
            end;

            trigger OnPreDataItem()
            begin
                NoOfRecords := "Sales Header".Count;
                Print := Print or not CurrReport.Preview;
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
            // ArchiveDocument := SalesSetup."Archive Quotes and Orders";
            ArchiveDocument := SalesSetup."Archive Orders";
            //fin - Field 'Archive Quotes and Orders' is removed. Reason: Replaced by new fields Archive Quotes and Archive Orders. Tag: 18.0.
            LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Sales Qte.") <> '';
            LogInteractionEnable := LogInteraction;
        end;
    }
    labels
    { }
    trigger OnInitReport()
    begin
        GLSetup.Get;
        CompanyInfo.Get;
        SalesSetup.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        Text000: label 'Salesperson', Comment = 'ESP="Vendedor"';
        Text001: label 'Total %1', Comment = 'ESP="Total %1"';
        Text002: label 'Total %1 Incl. VAT', Comment = 'ESP="Total %1 IVA incl."';
        Text004: label 'Quote%1', comment = 'ESP="Oferta %1"';
        Text005: label 'Page %1', comment = 'ESP="Pág. %1"';
        Text006: label 'Total %1 Excl. VAT', comment = 'ESP="Total %1 IVA excl."';
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        VATAmountLine: Record "VAT Amount Line" temporary;
        SalesLine: Record "Sales Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        //ini - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
        //Language: Record Language;
        cLanguage: Codeunit Language;
        //fin - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
        Country: Record "Country/Region";
        CurrExchRate: Record "Currency Exchange Rate";
        SalesCountPrinted: Codeunit "Sales-Printed";
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        ArchiveManagement: Codeunit ArchiveManagement;
        CustAddr: array[11] of Text[60];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[11] of Text[50];
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
        NetoUnit: Decimal;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        Text007: label 'Do you want to create a follow-up to-do?', comment = 'ESP="¿Desea crear una tarea de seguimiento?"';
        NoOfRecords: Integer;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        Text008: label 'VAT Amount Specification in ', comment = 'ESP="Especificar importe IVA en "';
        Text009: label 'Local Currency', comment = 'ESP="Divisa local"';
        Text010: label 'Exchange rate: %1/%2', comment = 'ESP="Tipo cambio: %1/%2"';
        OutputNo: Integer;
        Print: Boolean;
        Text1100000: label 'Total %1 Incl. VAT+EC', comment = 'ESP="Total %1 IVA+RE incl."';
        Text1100001: label 'Total %1 Excl. VAT+EC', comment = 'ESP="Total %1 IVA+RE excl."';
        VATPostingSetup: Record "VAT Posting Setup";
        PaymentMethod: Record "Payment Method";
        //[InDataSet]
        ArchiveDocumentEnable: Boolean;
        //[InDataSet]
        LogInteractionEnable: Boolean;
        VATIdentifierCaptionLbl: label 'VAT Identifier', comment = 'ESP="Identific. IVA"';
        PhoneNoCaptionLbl: label 'Phone No.', comment = 'ESP="Nº teléfono"';
        VATRegNoCaptionLbl: label 'VAT Registration No.', comment = 'ESP="CIF/NIF"';
        GiroNoCaptionLbl: label 'Giro No.', comment = 'ESP="Nº giro postal"';
        BankNameCaptionLbl: label 'Bank', comment = 'ESP="Banco"';
        BankAccountNoCaptionLbl: label 'Account No.', comment = 'ESP="Nº cuenta"';
        ShipmentDateCaptionLbl: label 'Shipment Date', comment = 'ESP="Fecha envío"';
        QuoteNoCaptionLbl: label 'Quote No.', comment = 'ESP="Nº oferta"';
        HomepageCaptionLbl: label 'Home Page', comment = 'ESP="Página Web"';
        EMailCaptionLbl: label 'E-Mail', comment = 'ESP="Correo electrónico"';
        HeaderDimensionsCaptionLbl: label 'Header Dimensions', comment = 'ESP="Dimensiones cabecera"';
        UnitsCaptionLbl: label 'PCS', comment = 'ESP="Uds."';
        TotalDiscCaptionLbl: label 'Total Discount', comment = 'ESP="Total Descuento"';
        NetUnitCaptionLbl: label 'Net Unit', comment = 'ESP="Neto Unitario"';
        UnitPriceCaptionLbl: label 'Unit Price', comment = 'ESP="Precio venta"';
        DiscountPercentCaptionLbl: label 'Discount %', comment = 'ESP="% Descuento"';
        AmountCaptionLbl: label 'Amount', comment = 'ESP="Importe"';
        InvDiscAmtCaptionLbl: label 'Invoice Discount Amount', comment = 'ESP="Importe descuento factura"';
        SubtotalCaptionLbl: label 'Subtotal', comment = 'ESP="Subtotal"';
        PmtDiscGivenAmtLbl: label 'Payment Discount Given Amount', comment = 'ESP="Importe descuento pago"';
        PmtDiscVATCaptionLbl: label 'Payment Discount on VAT', comment = 'ESP="Descuento P.P. sobre IVA"';
        LineDimensionsCaptionLbl: label 'Line Dimensions', comment = 'ESP="Dimensiones línea"';
        VATPercentCaptionLbl: label 'VAT %', comment = 'ESP="% IVA"';
        VATECBaseCaptionLbl: label 'VAT+EC Base', comment = 'ESP="Base IVA+RE"';
        VATAmtCaptionLbl: label 'VAT Amount', comment = 'ESP="Importe IVA"';
        VATAmountSpecCaptionLbl: label 'VAT Amount Specification', comment = 'ESP="Especificación importe IVA"';
        LineAmtCaptionLbl: label 'Line Amount', comment = 'ESP="Importe línea"';
        InvDiscBaseAmtCaptionLbl: label 'Invoice Discount Base Amount', comment = 'ESP="Importe base descuento factura"';
        InvPmtDiscCaptionLbl: label 'Invoice and Payment Discounts', comment = 'ESP="Descuentos facturas y pagos"';
        ECCaptionLbl: label 'EC %', comment = 'ESP="% RE"';
        ECAmountCaptionLbl: label 'EC Amount', comment = 'ESP="Importe RE"';
        TotalCaptionLbl: label 'Total', comment = 'ESP="Total';
        VATBaseCaptionLbl: label 'VAT Base', comment = 'ESP="Base IVA"';
        ShiptoAddressCaptionLbl: label 'Ship-to Address', comment = 'ESP="Dirección de envío"';
        PaymentTermsCaptionLbl: label 'Payment Terms', comment = 'ESP="Términos pago"';
        ShipmentMethodCaptionLbl: label 'Shipment Method', comment = 'ESP="Condiciones envío"';
        PaymentMethodCaptionLbl: label 'Payment Method', comment = 'ESP="Forma Pago"';
        DocumentDateCaptionLbl: label 'Document Date', comment = 'ESP="Fecha emisión documento"';
        AllowInvDiscCaptionLbl: label 'Allow Invoice Discount', comment = 'ESP="Permitir descuento factura"';
        DirEntregaTxt: label 'Shipment Address', comment = 'ESP="Dirección Entrega"';
        OfertNoTxt: label 'Order No.', comment = 'ESP="Pedido No."';
        DeFechaTxt: label 'Date', comment = 'ESP="de Fecha"';
        DivisaTxt: label 'Currency', comment = 'ESP="Divisa"';
        CurrText: Text[3];
        AtencionTxt: label 'For the attention of', comment = 'ESP="A la atención de"';
        SReferencia: label 'Your reference', comment = 'ESP="S/Referenncia"';
        TXTTel: label 'Phone:', comment = 'ESP="Teléfono:"';
        TXTTotal: label 'Total Amount (without VAT)', comment = 'ESP="Importe Total (sin IVA)"';
        ImporteTotal: Decimal;
        TXTArticulo: label 'No.', comment = 'ESP="Artículo"';
        TXTCondEnvio: label 'Shipment instructions', comment = 'ESP="Cond. envío"';
        TXTMedioEnvio: label 'Shipment method', comment = 'ESP="Medio envío"';
        CondEnvio: Text;
        MedioEnvio: Text;
        rShipmentMethod: Record "Shipment Method";
        rShipTransMethod: Record "Shipment Method Translation";
        TXtFormaPago: label 'Payment method', comment = 'ESP="Forma de pago"';
        TXTDomiciliacion: label 'Domiciliation', comment = 'ESP="Domiciliación"';
        TXTComercial: label 'Seller', comment = 'ESP="Comercial"';
        DatosComercial: array[3] of Text;
        rComercial: Record "Salesperson/Purchaser";
        rBanco: Record "Customer Bank Account";
        Domiciliacion: array[3] of Text;
        FormaPago: Text;
        TXTTitulo: label 'Sales Order confirmation', comment = 'ESP="Confirmación de Pedido"';
        rTerminosPago: Record "Payment Terms";
        rTradTerminosPago: Record "Payment Term Translation";
        rCustomer: Record Customer;
        CodBanco: Text;
        rBancoCobro: Record "Bank Account";
        Unidades: Text;
        rUnidades: Record "Unit of Measure";
        TXTFechaEntrega: label 'Delivery Date', comment = 'ESP="Fecha de entrega"';
        FechaEntrega: Text;
        TXTRefCliente: label 'Customer Ref.', comment = 'ESP="Referencia cliente"';
        FormatDocument: Codeunit "Format Document";

    procedure InitializeRequest(NoOfCopiesFrom: Integer; ShowInternalInfoFrom: Boolean; ArchiveDocumentFrom: Boolean; LogInteractionFrom: Boolean; PrintFrom: Boolean)
    begin
        NoOfCopies := NoOfCopiesFrom;
        ShowInternalInfo := ShowInternalInfoFrom;
        ArchiveDocument := ArchiveDocumentFrom;
        LogInteraction := LogInteractionFrom;
        Print := PrintFrom;
    end;
}
