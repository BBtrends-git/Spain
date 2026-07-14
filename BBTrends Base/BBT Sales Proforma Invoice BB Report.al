Report 50047 "BBT Sales - Proforma Invoice"
{
    // //INC-2017-04-70496. Añadir cod divisa para imprimir
    // 
    // //INC-2019-01-105854 : Mostrar pie Protección de datos
    // 
    // //04/07/19 TC-006 Mostrar el número de albarán en la factura de venta
    // 
    // //INC-2020-05-119482: Error base imponible
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/Sales - Proforma Invoice BB.rdl';
    Caption = 'Sales - Invoice', comment = 'ESP="Ventas - Factura"';
    Permissions = TableData "Sales Shipment Buffer" = rimd;
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
            column(CompanyInfoHomePage; CompanyInfo."Home Page")
            { }
            column(CompanyInfoEmail; CompanyInfo."E-Mail")
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
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Invoice', comment = 'ESP="Histórico facturas venta"';

            column(ReportForNavId_5581; 5581)
            { }
            column(CompanyInfoVATRegistrationNo; vatregn)
            { }
            column(No_SalesInvHdr; "Sales Header"."No.")
            { }
            column(PaymentTermsDescription; PaymentTerms.Description)
            { }
            column(ShipmentMethodDescription; ShipmentMethod.Code)
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
            column(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
            { }
            column(OurAccountNo_Cust; Cust."Our Account No.")
            { }
            column(CompanyInfoCountry; CompanyInfoCountryLbl)
            { }
            column(ReferenceCaption; "Sales Header".FieldCaption("External Document No."))
            { }
            column(CurrencyText; CurrencyText)
            { }
            column(ContractNo_Cust; Cust."Contract No")
            { }
            column(ContractNo_Cust_Caption; 'Contract number')
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
                    column(DocumentCaption; CopyText)
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
                    column(BilltoCustNo_SalesInvHdr; "Sales Header"."Bill-to Customer No.")
                    { }
                    column(PostingDate_SalesInvHdr; "Sales Header"."Posting Date")
                    { }
                    column(VATNoText; VATNoText)
                    { }
                    column(VATRegNo_SalesInvHeader; "Sales Header"."VAT Registration No.")
                    { }
                    column(DueDate_SalesInvHeader; "Sales Header"."Due Date")
                    { }
                    column(SalesPersonText; SalesPersonText)
                    { }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    { }
                    column(No_SalesInvoiceHeader1; "Sales Header"."No.")
                    { }
                    column(ReferenceText; ReferenceText)
                    { }
                    column(YourReference_SalesInvHdr; "Sales Header"."Your Reference")
                    { }
                    column(OrderNoText; OrderNoText)
                    { }
                    column(OrderNo_SalesInvHeader; "Sales Header"."No.")
                    { }
                    column(DocDate_SalesInvoiceHdr; Format("Sales Header"."Document Date", 0, 4))
                    { }
                    column(PricesInclVAT_SalesInvHdr; "Sales Header"."Prices Including VAT")
                    { }
                    column(OutputNo; OutputNo)
                    { }
                    column(ExternalDocumentNo_SalesInvHeader; "Sales Header"."External Document No.")
                    { }
                    column(PaymentDiscPct_SalesInvHdr; "Sales Header"."Payment Discount %")
                    { }
                    column(Ship_to_Name_SalesInvHdr; "Sales Header"."Ship-to Name")
                    { }
                    column(Ship_to_Code_SalesInvHdr; "Sales Header"."Ship-to Code")
                    { }
                    column(Ship_to_Address_SalesInvHdr; "Sales Header"."Ship-to Address")
                    { }
                    column(Ship_to_City_SalesInvHdr; "Sales Header"."Ship-to City")
                    { }
                    column(Ship_to_Post_Code_SalesInvHdr; "Sales Header"."Ship-to Post Code")
                    { }
                    column(Ship_to_County_SalesInvHdr; "Sales Header"."Ship-to County")
                    { }
                    column(Ship_to_CountryRegion_Code_SalesInvHdr; Country.Name)
                    { }
                    column(CCC_Bank_No_CustBankAccount; CCCBankNo)
                    { }
                    column(CCC_Bank_Branch_No_CustBankAccount; CCCBankBranchNo)
                    { }
                    column(CCC_Control_Digits_CustBankAccount; CCCControlDigits)
                    { }
                    column(CCC_Swift_CustBankAccount; CCCSwiftCode)
                    { }
                    column(IBAN_CustBankAccount; CodeIBAN)
                    { }
                    column(PageCaption; PageCaptionCap)
                    { }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    { }
                    column(VATRegNoCaption; VATRegNoCaptionLbl)
                    { }
                    column(GiroNoCaption; GiroNoCaptionVar)
                    { }
                    column(BankNameCaption; BankNameCaptionVar)
                    { }
                    column(BankAccNoCaption; BankAccNoCaptionLbl)
                    { }
                    column(DueDateCaption; DueDateCaptionLbl)
                    { }
                    column(InvoiceNoCaption; InvoiceNoCaptionLbl)
                    { }
                    column(PostingDateCaption; PostingDateCaptionLbl)
                    { }
                    column(BilltoCustNo_SalesInvHdrCaption; "Sales Header".FieldCaption("Bill-to Customer No."))
                    { }
                    column(CACCaption; CACCaptionLbl)
                    { }
                    column(GrupoCompraCaption; GrupoCompraCaptionLbl)
                    { }
                    //>> BBT. 16/03/2026. Implantación de la extensión SMG
                    // No se puede quitar el campo:
                    // Rendering output for the report failed.....
                    // Lo ocupamos con un filler.
                    //column(GrupoCompra_SalesInvHdr; "Sales Invoice Header"."Purchase Group")
                    column(GrupoCompra_SalesInvHdr; Filler)
                    { }
                    //<<
                    column(ShiptoAddressCaption; ShiptoAddressCaptionLbl)
                    { }
                    column(VendorCaption; VendorCaptionLbl)
                    { }
                    column(ObservationsCaption; ObservationsCaptionLbl)
                    { }
                    column(AGCaption; AGCaptionVar)
                    { }
                    column(DCCaption; DCCaptionVar)
                    { }
                    column(AmountCaption; AmountCaptionLbl)
                    { }
                    column(SalesShipmentNo; SalesShipNo)
                    { }
                    column(WhouseShipmentNo; WarhouseShipNo)
                    { }
                    column(SalesShipmentNoCaption; SalesShipmentNoLbl)
                    { }
                    column(WhouseShipmentNoCaption; WhouseShipmentNoLbl)
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
                        column(HdrDimsCaption; HdrDimsCaptionLbl)
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
                    dataitem("Sales Line"; "Sales Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = sorting("Document No.", "Line No.");

                        column(ReportForNavId_1570; 1570)
                        { }
                        trigger OnAfterGetRecord()
                        begin
                            //I AHR
                            if ("Sales Line".Type.AsInteger() <> 0) and ("Sales Line".Quantity = 0) and ("Sales Line"."Line Amount" = 0) then CurrReport.Skip;
                            //F AHR
                            PostedShipmentDate := 0D;
                            if "Sales Line".Quantity <> 0 then PostedShipmentDate := FindPostedShipmentDate;
                            if ("Sales Line".Type = "Sales Line".Type::"G/L Account") and (not ShowInternalInfo) then "Sales Line"."No." := '';
                            if VATPostingSetup.Get("Sales Line"."VAT Bus. Posting Group", "Sales Line"."VAT Prod. Posting Group") then begin
                                VATAmountLine.Init;
                                VATAmountLine."VAT Identifier" := "Sales Line"."VAT Identifier";
                                VATAmountLine."VAT Calculation Type" := "Sales Line"."VAT Calculation Type";
                                VATAmountLine."Tax Group Code" := "Sales Line"."Tax Group Code";
                                VATAmountLine."VAT %" := VATPostingSetup."VAT %";
                                VATAmountLine."EC %" := VATPostingSetup."EC %";
                                //ini - 'Record "VAT Amount Line" temporary' does not contain a definition for 'VAT+EC Base'
                                //    - 'Record "VAT Amount Line" temporary' does not contain a definition for 'Amount Including VAT+EC'
                                // VATAmountLine."VAT+EC Base" := "Sales Line".Amount;
                                // VATAmountLine."Amount Including VAT+EC" := "Sales Line"."Amount Including VAT";
                                VATAmountLine."VAT Base" := "Sales Line".Amount;
                                VATAmountLine."Amount Including VAT" := "Sales Line"."Amount Including VAT";
                                //fin - 'Record "VAT Amount Line" temporary' does not contain a definition for 'VAT+EC Base'
                                //    - 'Record "VAT Amount Line" temporary' does not contain a definition for 'Amount Including VAT+EC'
                                VATAmountLine."Line Amount" := "Sales Line"."Line Amount";
                                //ini - 'Record "VAT Amount Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                                //    - 'Record "Sales Line"' does not contain a definition for 'Pmt. Disc. Given Amount'
                                //VATAmountLine."Pmt. Disc. Given Amount" := "Sales Line"."Pmt. Disc. Given Amount";
                                VATAmountLine."Pmt. Discount Amount" := "Sales Line"."Pmt. Discount Amount";
                                //fin - 'Record "VAT Amount Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                                //    - 'Record "Sales Line"' does not contain a definition for 'Pmt. Disc. Given Amount'
                                if "Sales Line"."Allow Invoice Disc." then VATAmountLine."Inv. Disc. Base Amount" := "Sales Line"."Line Amount";
                                VATAmountLine."Invoice Discount Amount" := "Sales Line"."Inv. Discount Amount";
                                VATAmountLine.SetCurrencyCode("Sales Header"."Currency Code");
                                VATAmountLine."VAT Difference" := "Sales Line"."VAT Difference";
                                VATAmountLine."EC Difference" := "Sales Line"."EC Difference";
                                if "Sales Header"."Prices Including VAT" then VATAmountLine."Prices Including VAT" := true;
                                VATAmountLine."VAT Clause Code" := "Sales Line"."VAT Clause Code";
                                VATAmountLine.InsertLine;
                                TotalSubTotal += "Sales Line"."Line Amount";
                                TotalInvoiceDiscountAmount -= "Sales Line"."Inv. Discount Amount";
                                TotalAmount += "Sales Line".Amount;
                                TotalAmountVAT += "Sales Line"."Amount Including VAT" - "Sales Line".Amount;
                                TotalAmountInclVAT += "Sales Line"."Amount Including VAT";
                                //ini - 'Record "Sales Line"' does not contain a definition for 'Pmt. Disc. Given Amount'
                                // TotalGivenAmount -= "Sales Line"."Pmt. Disc. Given Amount";
                                // TotalPaymentDiscountOnVAT += -("Sales Line"."Line Amount" - "Sales Line"."Inv. Discount Amount" - "Sales Line"."Pmt. Disc. Given Amount" - "Sales Line"."Amount Including VAT");
                                TotalGivenAmount -= "Sales Line"."Pmt. Discount Amount";
                                TotalPaymentDiscountOnVAT += -("Sales Line"."Line Amount" - "Sales Line"."Inv. Discount Amount" - "Sales Line"."Pmt. Discount Amount" - "Sales Line"."Amount Including VAT");
                                //fin - 'Record "Sales Line"' does not contain a definition for 'Pmt. Disc. Given Amount'
                            end;
                            SalesInvLineBuffer.Init;
                            SalesInvLineBuffer := "Sales Line";
                            SalesInvLineBuffer.Insert;
                            DocLineNo := "Sales Line"."Line No.";
                            ReportPrintedLines += 1;
                            /*CountryOrigin :='';
                                CountryOriginLabel := 'Country of origin';


                                IF Type=Type::Item THEN

                                BEGIN
                                  Item.RESET;
                                  Item.SETRANGE("No.","No.");
                                  IF Item.FINDFIRST THEN
                                  BEGIN

                                    CountryRegion.RESET;
                                    CountryRegion.SETRANGE(Code,"Sales Header"."Bill-to Country/Region Code");
                                    IF CountryRegion.FINDFIRST THEN BEGIN
                                      IF CountryRegion."Country Origin on Sales Docs" THEN
                                      BEGIN
                                        CountryOriginAux.RESET;
                                        CountryOriginAux.SETRANGE(CountryOriginAux.Code,Item."Country/Region of Origin Code");
                                        IF CountryOriginAux.FINDFIRST THEN
                                        BEGIN
                                          CountryOrigin := CountryOriginAux."Export Name";
                                          CountryOriginLabel := 'Country of origin';
                                        END;
                                      END;

                                      TariffCode :='';
                                      TariffCodeCaption := '';
                                      IF CountryRegion."Tariff Code on Sales Docs" THEN
                                      BEGIN
                                        TariffCode := Item."Tariff No.";
                                        TariffCodeCaption:= 'Tariff Code';
                                      END;
                                    END;
                                  END;
                                END;*/
                        end;

                        trigger OnPreDataItem()
                        begin
                            VATAmountLine.DeleteAll;
                            SalesShipmentBuffer.Reset;
                            SalesShipmentBuffer.DeleteAll;
                            FirstValueEntryNo := 0;
                            MoreLines := "Sales Line".Find('+');
                            while MoreLines and ("Sales Line".Description = '') and ("Sales Line"."No." = '') and ("Sales Line".Quantity = 0) and ("Sales Line".Amount = 0) do MoreLines := "Sales Line".Next(-1) <> 0;
                            if not MoreLines then CurrReport.Break;
                            "Sales Line".SetRange("Sales Line"."Line No.", 0, "Sales Line"."Line No.");
                            //ini - 'Record "Sales Line"' does not contain a definition for 'Pmt. Disc. Given Amount'
                            // CurrReport.CreateTotals("Sales Line"."Line Amount","Sales Line".Amount,"Sales Line"."Amount Including VAT","Sales Line"."Inv. Discount Amount","Sales Line"."Pmt. Disc. Given Amount");
                            //>> BBT. CreateTotals. Marcada como obsoleta.  
                            //CurrReport.CreateTotals("Sales Line"."Line Amount", "Sales Line".Amount, "Sales Line"."Amount Including VAT", "Sales Line"."Inv. Discount Amount", "Sales Line"."Pmt. Discount Amount");
                            //<<
                            //fin - 'Record "Sales Line"' does not contain a definition for 'Pmt. Disc. Given Amount'
                            ReportPrintedLines := 0;
                        end;
                    }
                    dataitem(SalesLineLoop; "Integer")
                    {
                        DataItemTableView = sorting(Number);

                        column(ReportForNavId_1100234011; 1100234011)
                        { }
                        column(GetCarteraInvoice; GetCarteraInvoice)
                        { }
                        column(LineAmt_SalesInvoiceLine; "Sales Line"."Line Amount")
                        {
                            AutoFormatType = 1;
                        }
                        column(Description_SalesInvLine; "Sales Line".Description)
                        { }
                        column(No_SalesInvoiceLine; "Sales Line"."No.")
                        { }
                        column(Quantity_SalesInvoiceLine; "Sales Line".Quantity)
                        { }
                        column(UOM_SalesInvoiceLine; Unidades)
                        { }
                        column(UnitPrice_SalesInvLine; "Sales Line"."Unit Price")
                        {
                            AutoFormatType = 2;
                        }
                        column(LineDisc_SalesInvoiceLine; "Sales Line"."Line Discount %")
                        { }
                        column(VATIdent_SalesInvLine; "Sales Line"."VAT Identifier")
                        { }
                        column(PostedShipmentDate; Format(PostedShipmentDate))
                        { }
                        column(Type_SalesInvoiceLine; Format("Sales Line".Type))
                        { }
                        column(InvDiscountAmount; -"Sales Line"."Inv. Discount Amount")
                        {
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
                        column(TotalAmount; TotalAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalGivenAmount; TotalGivenAmount)
                        { }
                        column(SalesInvoiceLineAmount; "Sales Line".Amount)
                        {
                            AutoFormatType = 1;
                        }
                        column(AmountIncludingVATAmount; "Sales Line"."Amount Including VAT" - "Sales Line".Amount)
                        {
                            AutoFormatType = 1;
                        }
                        column(Amount_SalesInvoiceLineIncludingVAT; "Sales Line"."Amount Including VAT")
                        {
                            AutoFormatType = 1;
                        }
                        column(EANCode_SalesInvLine; "Sales Line"."EAN Code")
                        { }
                        //>> BBT. 16/03/2026. Implantación de la extensión SMG.
                        /*
                        column(Disc1_SalesInvLine; "Sales Line"."Discount 1 %")
                        { }
                        column(Disc2_SalesInvLine; "Sales Line"."Discount 2 %")
                        { }
                        column(Disc3_SalesInvLine; "Sales Line"."Discount 3 %")
                        { }
                        column(Disc4_SalesInvLine; "Sales Line"."Discount 4 %")
                        { }
                        column(Disc5_SalesInvLine; "Sales Line"."Discount 5 %")
                        { }
                        column(DiscTotalAmt_SalesInvLine; "Sales Line"."Discounts Total Amount")
                        { }
                        */
                        column(SMGDisc1_SalesInvLine; "Sales Line"."SMG Discount 1 %")
                        { }
                        column(SMGDisc2_SalesInvLine; "Sales Line"."SMG Discount 2 %")
                        { }
                        column(SMGDisc3_SalesInvLine; "Sales Line"."SMG Discount 3 %")
                        { }
                        column(SMGDisc4_SalesInvLine; "Sales Line"."SMG Discount 4 %")
                        { }
                        column(SMGDisc5_SalesInvLine; "Sales Line"."SMG Discount 5 %")
                        { }
                        column(SMGDiscTotalAmt_SalesInvLine; "Sales Line"."Line Discount Amount")
                        { }
                        //<<
                        column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText)
                        { }
                        column(TotalExclVATText; TotalExclVATText)
                        { }
                        column(TotalInclVATText; TotalInclVATText)
                        { }
                        column(TotalAmountVAT; TotalAmountVAT)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseDisc_SalesInvHdr; "Sales Header"."VAT Base Discount %")
                        {
                            AutoFormatType = 1;
                        }
                        column(TotalPaymentDiscountOnVAT; TotalPaymentDiscountOnVAT)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATCalcType; VATAmountLine."VAT Calculation Type")
                        { }
                        column(LineNo_SalesInvoiceLine; "Sales Line"."Line No.")
                        { }
                        column(PmtinvfromdebtpaidtoFactCompCaption; PmtinvfromdebtpaidtoFactCompCaptionLbl)
                        { }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        { }
                        column(DiscountCaption; DiscountCaptionLbl)
                        { }
                        column(AmtCaption; AmtCaptionLbl)
                        { }
                        column(PostedShpDateCaption; PostedShpDateCaptionLbl)
                        { }
                        column(InvDiscAmtCaption; InvDiscAmtCaptionLbl)
                        { }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        { }
                        column(PmtDiscGivenAmtCaption; PmtDiscGivenAmtCaptionLbl)
                        { }
                        column(PmtDiscVATCaption; PmtDiscVATCaptionLbl)
                        { }
                        column(Description_SalesInvLineCaption; "Sales Line".FieldCaption(Description))
                        { }
                        column(UOM_SalesInvoiceLineCaption; "Sales Line".FieldCaption("Unit of Measure"))
                        { }
                        column(VATIdent_SalesInvLineCaption; "Sales Line".FieldCaption("VAT Identifier"))
                        { }
                        column(No_SalesInvoiceLineCaption; ItemNoCaptionLbl)
                        { }
                        column(Quantity_SalesInvoiceLineCaption; UnitsCaptionLbl)
                        { }
                        column(EANCaption; EANCaptionLbl)
                        { }
                        column(TotalDiscCaption; TotalDiscCaptionLbl)
                        { }
                        column(NetUnitCaption; NetUnitCaptionLbl)
                        { }
                        column(DiccountsCaption; DiccountsCaptionLbl)
                        { }
                        column(SimbPctCaption; SimbPctCaptionLbl)
                        { }
                        column(AmountsCaption; AmountsCaptionLbl)
                        { }
                        column(ECAmtCaption; ECAmtCaptionLbl)
                        { }
                        column(DiscPctCaption; DiscPctCaptionLbl)
                        { }
                        column(DiscAmtCaption; DiscAmtCaptionLbl)
                        { }
                        column(PaymentDiscPctCaption; PaymentDiscPctCaptionLbl)
                        { }
                        column(PDAmtCaption; PDAmtCaptionLbl)
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
                        column(VATECBaseCaption; VATECBaseCaptionLbl)
                        { }
                        column(VATAmtLineVATCaption; VATAmtLineVATCaptionLbl)
                        { }
                        column(VATAmountCaption; VATAmountCaptionLbl)
                        { }
                        column(ECCaption; ECCaptionLbl)
                        { }
                        column(ECCAmtCaption; ECCAmtCaptionLbl)
                        { }
                        column(TotalInvCaption; TotalInvCaptionLbl)
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
                        column(TariffCode_Label; TariffCode)
                        { }
                        column(TariffCodeCaption_SalesShptLine; TariffCodeCaption)
                        { }
                        column(CountryOrigin_SalesShptLine; CountryOrigin)
                        { }
                        column(CountryOriginCaption_SalesShptLine; CountryOriginLabel)
                        { }
                        dataitem("Sales Shipment Buffer"; "Integer")
                        {
                            DataItemTableView = sorting(Number);

                            column(ReportForNavId_1484; 1484)
                            { }
                            column(PostingDate_SalesShipmentBuffer; Format(SalesShipmentBuffer."Posting Date"))
                            { }
                            column(Quantity_SalesShipmentBuffer; SalesShipmentBuffer.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(ShpCaption; ShpCaptionLbl)
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
                                SalesShipmentBuffer.SetRange("Document No.", "Sales Line"."Document No.");
                                SalesShipmentBuffer.SetRange("Line No.", "Sales Line"."Line No.");
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
                            column(LineDimsCaption; LineDimsCaptionLbl)
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
                            column(TempPostedAsmLineUOMCode; GetUOMText(TempPostedAsmLine."Unit of Measure Code"))
                            {
                                //DecimalPlaces = 0:5; //The property 'DecimalPlaces' can only be set if the property 'Type' is set to 'Decimal'
                            }
                            column(TempPostedAsmLineQuantity; TempPostedAsmLine.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(TempPostedAsmLineVariantCode; BlanksForIndent + TempPostedAsmLine."Variant Code")
                            {
                                //DecimalPlaces = 0:5; //The property 'DecimalPlaces' can only be set if the property 'Type' is set to 'Decimal'
                            }
                            column(TempPostedAsmLineDescrip; BlanksForIndent + TempPostedAsmLine.Description)
                            { }
                            column(TempPostedAsmLineNo; BlanksForIndent + TempPostedAsmLine."No.")
                            { }
                            trigger OnAfterGetRecord()
                            var
                                ItemTranslation: Record "Item Translation";
                            begin
                                if AsmLoop.Number = 1 then
                                    TempPostedAsmLine.FindSet
                                else
                                    TempPostedAsmLine.Next;
                                if ItemTranslation.Get(TempPostedAsmLine."No.", TempPostedAsmLine."Variant Code", "Sales Header"."Language Code") then TempPostedAsmLine.Description := ItemTranslation.Description;
                            end;

                            trigger OnPreDataItem()
                            begin
                                CurrReport.Break;
                                Clear(TempPostedAsmLine);
                                if not DisplayAssemblyInformation then CurrReport.Break;
                                CollectAsmInformation;
                                Clear(TempPostedAsmLine);
                                AsmLoop.SetRange(AsmLoop.Number, 1, TempPostedAsmLine.Count);
                            end;
                        }
                        trigger OnAfterGetRecord()
                        begin
                            Unidades := "Sales Line"."Unit of Measure Code";
                            if ("Sales Header"."Language Code" <> '') and ("Sales Header"."Language Code" <> 'ESP') then if rUnidades.Get("Sales Line"."Unit of Measure Code") then Unidades := rUnidades."International Standard Code";
                            if SalesLineLoop.Number = 1 then
                                SalesInvLineBuffer.FindSet
                            else
                                SalesInvLineBuffer.Next;
                            "Sales Line" := SalesInvLineBuffer;
                            NetoUnit := 0;
                            if "Sales Line".Quantity <> 0 then NetoUnit := ROUND("Sales Line"."Line Amount" / "Sales Line".Quantity, 0.01);
                            ContLine += 1;
                            if ContLine > (PageLines) then ContLine := 1;
                            if "Sales Line".Type = "Sales Line".Type::Item then begin
                                Item.Reset;
                                Item.SetRange("No.", "Sales Line"."No.");
                                if Item.FindFirst then begin
                                    CountryOrigin := '';
                                    CountryOriginLabel := 'Country of origin';
                                    CountryRegion.Reset;
                                    CountryRegion.SetRange(Code, "Sales Header"."Bill-to Country/Region Code");
                                    if CountryRegion.FindFirst then begin
                                        if CountryRegion."Country Origin on Sales Docs" then begin
                                            CountryOriginAux.Reset;
                                            CountryOriginAux.SetRange(CountryOriginAux.Code, Item."Country/Region of Origin Code");
                                            if CountryOriginAux.FindFirst then begin
                                                CountryOrigin := CountryOriginAux."Export Name";
                                                CountryOriginLabel := 'Country of origin';
                                            end;
                                        end;
                                        TariffCode := '';
                                        TariffCodeCaption := '';
                                        if CountryRegion."Tariff Code on Sales Docs" then begin
                                            TariffCode := Item."Tariff No.";
                                            TariffCodeCaption := 'Tariff Code';
                                        end;
                                    end;
                                end;
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            BlankLines := CalculateBlankLines(ReportPrintedLines);
                            if BlankLines > 0 then begin
                                for i := 1 to BlankLines do begin
                                    DocLineNo += 1;
                                    SalesInvLineBuffer.Init;
                                    SalesInvLineBuffer."No." := "Sales Header"."No.";
                                    SalesInvLineBuffer."Line No." := DocLineNo;
                                    SalesInvLineBuffer.Insert;
                                end;
                            end;
                            TotalRepLines := SalesInvLineBuffer.Count;
                            SalesLineLoop.SetRange(SalesLineLoop.Number, 1, TotalRepLines);
                            ContLine := 0;
                        end;
                    }
                    dataitem(VATCounter; "Integer")
                    {
                        DataItemTableView = sorting(Number);

                        column(ReportForNavId_6558; 6558)
                        { }
                        //ini - 'Record "VAT Amount Line" temporary' does not contain a definition for 'VAT+EC Base'
                        // column(VATAmountLineVATBase;VATAmountLine."VAT+EC Base")
                        // {
                        //     AutoFormatType = 1;
                        // }
                        column(VATAmountLineVATBase; VATAmountLine."VAT Base")
                        {
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
                        // column(VATAmtLineInvDiscountAmt;VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Disc. Given Amount")
                        // {
                        //     AutoFormatExpression = "Sales Header"."Currency Code";
                        //     AutoFormatType = 1;
                        // }
                        column(VATAmtLineInvDiscountAmt; VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        //fin - 'Record "VAT Amount Line" temporary' does not contain a definition for 'Pmt. Disc. Given Amount'
                        column(VATAmtLineECAmount; VATAmountLine."EC Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVAT; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 6;
                        }
                        column(VATAmtLineVATIdentifier; VATAmountLine."VAT Identifier")
                        { }
                        column(VATAmountLineEC; VATAmountLine."EC %")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtSpecCaption; VATAmtSpecCaptionLbl)
                        { }
                        column(VATIdentCaption; VATIdentCaptionLbl)
                        { }
                        column(InvDiscBaseAmtCaption; InvDiscBaseAmtCaptionLbl)
                        { }
                        column(LineAmtCaption1; LineAmtCaption1Lbl)
                        { }
                        column(InvPmtDiscCaption; InvPmtDiscCaptionLbl)
                        { }
                        column(TotalCaption; TotalCaptionLbl)
                        { }
                        column(TotalAmountInclVAT; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(VATCounter.Number);
                            if VATAmountLine."VAT Amount" = 0 then VATAmountLine."VAT %" := 0;
                            if VATAmountLine."EC Amount" = 0 then VATAmountLine."EC %" := 0;
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
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATClausesCaption; VATClausesCap)
                        { }
                        column(VATClauseVATIdentifierCaption; VATIdentifierCaptionLbl)
                        { }
                        column(VATClauseVATAmtCaption; VATAmtCaptionLbl)
                        { }
                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(VATClauseEntryCounter.Number);
                            if not VATClause.Get(VATAmountLine."VAT Clause Code") then CurrReport.Skip;
                            VATClause.TranslateDescription("Sales Header"."Language Code");
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
                    dataitem(VatCounterLCY; "Integer")
                    {
                        DataItemTableView = sorting(Number);

                        column(ReportForNavId_9347; 9347)
                        { }
                        column(VALSpecLCYHeader; VALSpecLCYHeader)
                        { }
                        column(VALExchRate; VALExchRate)
                        { }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATAmountLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVAT1; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier1; VATAmountLine."VAT Identifier")
                        { }
                        column(VALVATBaseLCYCaption1; VALVATBaseLCYCaption1Lbl)
                        { }
                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(VatCounterLCY.Number);
                            VALVATBaseLCY := VATAmountLine.GetBaseLCY("Sales Header"."Posting Date", "Sales Header"."Currency Code", "Sales Header"."Currency Factor");
                            VALVATAmountLCY := VATAmountLine.GetAmountLCY("Sales Header"."Posting Date", "Sales Header"."Currency Code", "Sales Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or ("Sales Header"."Currency Code" = '') then CurrReport.Break;
                            VatCounterLCY.SetRange(VatCounterLCY.Number, 1, VATAmountLine.Count);
                            //>> BBT. CreateTotals. Marcada como obsoleta.
                            //CurrReport.CreateTotals(VALVATBaseLCY, VALVATAmountLCY);
                            //<<
                            if GLSetup."LCY Code" = '' then
                                VALSpecLCYHeader := Text007 + Text008
                            else
                                VALSpecLCYHeader := Text007 + Format(GLSetup."LCY Code");
                            CurrExchRate.FindCurrency("Sales Header"."Posting Date", "Sales Header"."Currency Code", 1);
                            CalculatedExchRate := ROUND(1 / "Sales Header"."Currency Factor" * CurrExchRate."Exchange Rate Amount", 0.000001);
                            VALExchRate := StrSubstNo(Text009, CalculatedExchRate, CurrExchRate."Exchange Rate Amount");
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
                        column(SelltoCustNo_SalesInvHdr; "Sales Header"."Sell-to Customer No.")
                        { }
                        column(SelltoCustNo_SalesInvHdrCaption; "Sales Header".FieldCaption("Sell-to Customer No."))
                        { }
                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break;
                            //IF NOT ShowShippingAddr THEN
                            //  CurrReport.BREAK;
                        end;
                    }
                    dataitem(LineFee; "Integer")
                    {
                        DataItemTableView = sorting(Number) order(ascending) where(Number = filter(1 ..));

                        column(ReportForNavId_300; 300)
                        { }
                        column(LineFeeCaptionLbl; TempLineFeeNoteOnReportHist.ReportText)
                        { }
                        trigger OnAfterGetRecord()
                        begin
                            if not DisplayAdditionalFeeNote then CurrReport.Break;
                            if LineFee.Number = 1 then begin
                                if not TempLineFeeNoteOnReportHist.FindSet then CurrReport.Break
                            end
                            else if TempLineFeeNoteOnReportHist.Next = 0 then CurrReport.Break;
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break;
                        end;
                    }
                    trigger OnAfterGetRecord()
                    begin
                        Clear(SalesInvLineBuffer);
                        SalesInvLineBuffer.DeleteAll;
                    end;

                    trigger OnPreDataItem()
                    begin
                        //04/07/19 TC-006 Mostrar el número de albarán en la factura de venta
                        //"Sales Header".CALCFIELDS("Sales Header"."Sales Shipment No","Sales Header"."Warehose Ship No.");
                        ValueEntry.Reset;
                        ValueEntry.SetRange("Document No.", "Sales Header"."No.");
                        ValueEntry.SetRange("Posting Date", "Sales Header"."Posting Date");
                        if ValueEntry.FindFirst then begin
                            ItemLedgerEntry.Reset;
                            ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."document type"::"Sales Shipment");
                            ItemLedgerEntry.SetRange("Entry No.", ValueEntry."Item Ledger Entry No.");
                            if ItemLedgerEntry.FindFirst then
                                SalesShipNo := ItemLedgerEntry."Document No."
                            else
                                SalesShipNo := '';
                            PostedWhseShipmentLine.Reset;
                            PostedWhseShipmentLine.SetRange("Posted Source No.", SalesShipNo);
                            if PostedWhseShipmentLine.FindFirst then WarhouseShipNo := PostedWhseShipmentLine."Whse. Shipment No.";
                        end;
                        //04/07/19 TC-006 Mostrar el número de albarán en la factura de venta
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    if CopyLoop.Number > 1 then begin
                        CopyText := FormatDocument.GetCOPYText();
                        OutputNo += 1;
                    end;
                    //CurrReport.PageNo := 1;
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
                    if not CurrReport.Preview then SalesInvCountPrinted.Run("Sales Header");
                end;

                trigger OnPreDataItem()
                begin
                    //>> BBT 11/03/2026. Obsoleto
                    //NoOfLoops := Abs(NoOfCopies) + Cust."Invoice Copies" + 1;
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    //<<
                    if NoOfLoops <= 0 then NoOfLoops := 1;
                    CopyText := '';
                    CopyLoop.SetRange(CopyLoop.Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                if ("Sales Header"."Language Code" <> '') and ("Sales Header"."Language Code" <> 'ESP') then begin
                    //ini - 'Record Language' does not contain a definition for 'GetUserLanguage'
                    //CurrReport.Language := Language.GetLanguageID("Sales Header"."Language Code");
                    CurrReport.Language := cLanguage.GetLanguageID("Sales Header"."Language Code");
                    //fin - 'Record Language' does not contain a definition for 'GetUserLanguage'
                end;
                if RespCenter.Get("Sales Header"."Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end
                else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                DimSetEntry1.SetRange("Dimension Set ID", "Sales Header"."Dimension Set ID");
                if "Sales Header"."No." = '' then
                    OrderNoText := ''
                else
                    OrderNoText := "Sales Header".FieldCaption("Sales Header"."No.");
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
                //I_INC-2017-04-70496
                Clear(CurrencyText);
                //F_INC-2017-04-70496
                if "Sales Header"."Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(Text001, GLSetup."LCY Code");
                    TotalInclVATText := StrSubstNo(Text1100000, GLSetup."LCY Code");
                    TotalExclVATText := StrSubstNo(Text1100001, GLSetup."LCY Code");
                    //I_INC-2017-04-70496
                    CurrencyText := ' ' + GLSetup."LCY Code";
                    //F_INC-2017-04-70496
                end
                else begin
                    TotalText := StrSubstNo(Text001, "Sales Header"."Currency Code");
                    TotalInclVATText := StrSubstNo(Text1100000, "Sales Header"."Currency Code");
                    TotalExclVATText := StrSubstNo(Text1100001, "Sales Header"."Currency Code");
                    //I_INC-2017-04-70496
                    CurrencyText := ' ' + "Sales Header"."Currency Code";
                    //F_INC-2017-04-70496
                end;
                //"Ship-to Contact" := '';
                //"Bill-to Contact" := '';
                FormatAddr.SalesHeaderSellTo(CustAddr, "Sales Header");
                if not Cust.Get("Sales Header"."Bill-to Customer No.") then Clear(Cust);
                if not CustBankAccount.Get("Sales Header"."Bill-to Customer No.", "Sales Header"."Cust. Bank Acc. Code") then Clear(CustBankAccount);
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
                GiroNoCaptionVar := GiroNoCaptionLbl;
                BankNameCaptionVar := BankNameCaptionLbl;
                AGCaptionVar := AGCaptionLbl;
                DCCaptionVar := DCCaptionLbl;
                CCCBankNo := CustBankAccount."CCC Bank No.";
                CCCBankBranchNo := CustBankAccount."CCC Bank Branch No.";
                CCCControlDigits := CustBankAccount."CCC Control Digits";
                CCCSwiftCode := CustBankAccount."SWIFT Code";
                CodeIBAN := CustBankAccount.Iban;
                if PaymentMethod.Code <> '' then
                    if SalesSetup."Transfer Payment Method" = PaymentMethod.Code then begin
                        if not BankAccount.Get(Cust."Collection Bank Account") then Clear(BankAccount);
                        CCCBankNo := BankAccount."CCC Bank No.";
                        CCCBankBranchNo := BankAccount."CCC Bank Branch No.";
                        CCCControlDigits := BankAccount."CCC Control Digits";
                        CCCSwiftCode := BankAccount."SWIFT Code";
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
                //ShowCashAccountingCriteria("Sales Header");
                GetLineFeeNoteOnReportHist("Sales Header"."No.");
                if LogInteraction then
                    if not CurrReport.Preview then begin
                        if "Sales Header"."Bill-to Contact No." <> '' then
                            SegManagement.LogDocument(4, "Sales Header"."No.", 0, 0, Database::Contact, "Sales Header"."Bill-to Contact No.", "Sales Header"."Salesperson Code", "Sales Header"."Campaign No.", "Sales Header"."Posting Description", '')
                        else
                            SegManagement.LogDocument(4, "Sales Header"."No.", 0, 0, Database::Customer, "Sales Header"."Bill-to Customer No.", "Sales Header"."Salesperson Code", "Sales Header"."Campaign No.", "Sales Header"."Posting Description", '');
                    end;
                if "Sales Header"."Ship-to Code" <> '' then if not Country.Get("Sales Header"."Ship-to Country/Region Code") then Clear(Country);
                GeneralLedgerSetup.Get;
                CustomerAux.SetRange("No.", "Sales Header"."Bill-to Customer No.");
                if CustomerAux.FindFirst then;
                if CustomerAux."VAT PL" then
                    vatregn := GeneralLedgerSetup."PolishVAT Registration No."
                else
                    vatregn := CompanyInfo."VAT Registration No.";
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
                    field(DisplayAsmInformation; DisplayAssemblyInformation)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Assembly Components', comment = 'ESP="Mostrar componentes del ensamblado"';
                        Visible = false;
                    }
                    field(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Additional Fee Note', comment = 'ESP="Mostrar nota recargo"';
                        Visible = false;
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
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
        end;
    }
    labels
    { }

    trigger OnInitReport()
    begin
        GLSetup.Get;
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
        SalesSetup.Get;

        //>> BBT. 16/03/2026. Implantación de la extensión SMG.
        /*
        SMGEnable := cuSMGManagement.IsMarginEnabled();
        cuSMGManagement.InitializeMarginConfiguration(rSMGSetup);

        if not SMGEnable then begin
            if SalesSetup."Disc. 1 % Caption" <> '' then
                DiscLabel[1] := SalesSetup."Disc. 1 % Caption"
            else
                DiscLabel[1] := CopyStr("Sales Line".FieldCaption("Discount 1 %"), 1, MaxStrLen(DiscLabel[1]));
            if SalesSetup."Disc. 2 % Caption" <> '' then
                DiscLabel[2] := SalesSetup."Disc. 2 % Caption"
            else
                DiscLabel[2] := CopyStr("Sales Line".FieldCaption("Discount 2 %"), 1, MaxStrLen(DiscLabel[2]));
            if SalesSetup."Disc. 3 % Caption" <> '' then
                DiscLabel[3] := SalesSetup."Disc. 3 % Caption"
            else
                DiscLabel[3] := CopyStr("Sales Line".FieldCaption("Discount 3 %"), 1, MaxStrLen(DiscLabel[3]));
            if SalesSetup."Disc. 4 % Caption" <> '' then
                DiscLabel[4] := SalesSetup."Disc. 4 % Caption"
            else
                DiscLabel[4] := CopyStr("Sales Line".FieldCaption("Discount 4 %"), 1, MaxStrLen(DiscLabel[4]));
            if SalesSetup."Disc. 5 % Caption" <> '' then
                DiscLabel[5] := SalesSetup."Disc. 5 % Caption"
            else
                DiscLabel[5] := CopyStr("Sales Line".FieldCaption("Discount 5 %"), 1, MaxStrLen(DiscLabel[5]));
        end
        else begin
        */
        if (rSMGSetup."Discount 1 Enabled") and (rSMGSetup."Discount 1 Caption" <> '') then
            DiscLabel[1] := rSMGSetup."Discount 1 Caption"
        else
            DiscLabel[1] := CopyStr("Sales Line".FieldCaption("SMG Discount 1 %"), 1, MaxStrLen(DiscLabel[1]));
        if (rSMGSetup."Discount 2 Enabled") and (rSMGSetup."Discount 2 Caption" <> '') then
            DiscLabel[2] := rSMGSetup."Discount 2 Caption"
        else
            DiscLabel[2] := CopyStr("Sales Line".FieldCaption("SMG Discount 2 %"), 1, MaxStrLen(DiscLabel[2]));
        if (rSMGSetup."Discount 3 Enabled") and (rSMGSetup."Discount 3 Caption" <> '') then
            DiscLabel[3] := rSMGSetup."Discount 3 Caption"
        else
            DiscLabel[3] := CopyStr("Sales Line".FieldCaption("SMG Discount 3 %"), 1, MaxStrLen(DiscLabel[3]));
        if (rSMGSetup."Discount 4 Enabled") and (rSMGSetup."Discount 4 Caption" <> '') then
            DiscLabel[4] := rSMGSetup."Discount 4 Caption"
        else
            DiscLabel[4] := CopyStr("Sales Line".FieldCaption("SMG Discount 4 %"), 1, MaxStrLen(DiscLabel[4]));
        if (rSMGSetup."Discount 5 Enabled") and (rSMGSetup."Discount 5 Caption" <> '') then
            DiscLabel[5] := rSMGSetup."Discount 5 Caption"
        else
            DiscLabel[5] := CopyStr("Sales Line".FieldCaption("SMG Discount 5 %"), 1, MaxStrLen(DiscLabel[5]));
        //end;

        //I. INC-2018-05-93291
        //PageLines  := 30;
        PageLines := 15;
        //F. INC-2018-05-93291
    end;

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage then InitLogInteraction;
    end;

    var
        //>> BBT. SMG Extension.
        cuSMGManagement: Codeunit "SMG Management";
        rSMGSetup: Record "SMG Setup";
        SMGEnable: Boolean;
        //<<

        Text000: label 'Salesperson', Comment = 'ESP="Representante"';
        Text001: label 'Total %1', Comment = 'ESP="Total %1"';
        Text004: label 'Sales - Proforma Invoice %1', comment = 'ESP="Ventas - Factura Proforma %1"';
        PageCaptionCap: label 'Page %1 of %2', comment = 'ESP="Página %1 de %2"';
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        VATAmountLine: Record "VAT Amount Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        //ini - 'Record Language' does not contain a definition for 'GetUserLanguage'
        //Language: Record Language;
        cLanguage: Codeunit Language;
        //fin - 'Record Language' does not contain a definition for 'GetUserLanguage'
        CurrExchRate: Record "Currency Exchange Rate";
        TempPostedAsmLine: Record "Posted Assembly Line" temporary;
        VATClause: Record "VAT Clause";
        TempLineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist." temporary;
        SalesInvCountPrinted: Codeunit "Sales-Printed";
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        SalesShipmentBuffer: Record "Sales Shipment Buffer" temporary;
        SalesInvLineBuffer: Record "Sales Line" temporary;
        CustBankAccount: Record "Customer Bank Account";
        BankAccount: Record "Bank Account";
        Country: Record "Country/Region";
        PostedShipmentDate: Date;
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        OrderNoText: Text[80];
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
        NextEntryNo: Integer;
        FirstValueEntryNo: Integer;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        Text007: label 'VAT Amount Specification in ', comment = 'ESP="Especificar importe IVA en "';
        Text008: label 'Local Currency', comment = 'ESP="Divisa local"';
        VALExchRate: Text[50];
        Text009: label 'Exchange rate: %1/%2', comment = 'ESP="Tipo cambio: %1/%2"';
        CalculatedExchRate: Decimal;
        Text010: label 'Sales - Prepayment Invoice %1', comment = 'ESP="Ventas - Factura prepago %1"';
        OutputNo: Integer;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        TotalPaymentDiscountOnVAT: Decimal;
        Text1100000: label 'Total %1 Incl. VAT+EC', comment = 'ESP="Total %1 IVA+RE incl."';
        Text1100001: label 'Total %1 Excl. VAT+EC', comment = 'ESP="Total %1 IVA+RE excl."';
        VATPostingSetup: Record "VAT Posting Setup";
        PaymentMethod: Record "Payment Method";
        TotalGivenAmount: Decimal;
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        PhoneNoCaptionLbl: label 'Phone', comment = 'ESP="Tel."';
        VATRegNoCaptionLbl: label 'VAT No.', comment = 'ESP="NIF"';
        GiroNoCaptionLbl: label 'Domiciliación';
        BankNameCaptionLbl: label 'Bank', comment = 'ESP="C. Ban"';
        BankAccNoCaptionLbl: label 'Bank Account No.', comment = 'ESP="Cuenta Corriente Bancaria"';
        DueDateCaptionLbl: label 'Due Date', comment = 'ESP="Vto."';
        InvoiceNoCaptionLbl: label 'PROFORMA INVOICE', comment = 'ESP="FACTURA PROFORMA"';
        PostingDateCaptionLbl: label 'Invoice Date', comment = 'ESP="Fecha factura"';
        HdrDimsCaptionLbl: label 'Header Dimensions', comment = 'ESP="Dimensiones cabecera"';
        PmtinvfromdebtpaidtoFactCompCaptionLbl: label 'The payment of this invoice, in order to be released from the debt, has to be paid to the Factoring Company.', comment = 'ESP="Para que se libere de la deuda, el pago de esta factura se debe realizar a la compañía Factoring."';
        UnitPriceCaptionLbl: label 'Tarif Price', comment = 'ESP="Precio tarifa"';
        DiscountCaptionLbl: label 'Disc.', comment = 'ESP="Dto."';
        AmtCaptionLbl: label 'Amount', comment = 'ESP="Importe"';
        VATClausesCap: label 'VAT Clause', comment = 'ESP="Clausula de IVA"';
        PostedShpDateCaptionLbl: label 'Posted Shipment Date', comment = 'ESP="Fecha envío registrada"';
        InvDiscAmtCaptionLbl: label 'Invoice Discount Amount', comment = 'ESP="Importe descuento factura"';
        SubtotalCaptionLbl: label 'Subtotal', comment = 'ESP="Subtotal"';
        PmtDiscGivenAmtCaptionLbl: label 'Payment Disc Given Amount', comment = 'ESP="Importe descuento pago"';
        PmtDiscVATCaptionLbl: label 'Payment Discount on VAT', comment = 'ESP="Descuento P.P. sobre IVA"';
        ShpCaptionLbl: label 'Shipment', comment = 'ESP="Envío"';
        LineDimsCaptionLbl: label 'Line Dimensions', comment = 'ESP="Dimensiones línea"';
        VATAmtLineVATCaptionLbl: label 'VAT %', comment = 'ESP="% IVA"';
        VATECBaseCaptionLbl: label 'VAT Base', comment = 'ESP="Base Imponible"';
        VATAmountCaptionLbl: label 'VAT Amt.', comment = 'ESP="Cuota IVA"';
        VATAmtSpecCaptionLbl: label 'VAT Amount Specification', comment = 'ESP="Especificación importe IVA"';
        VATIdentCaptionLbl: label 'VAT Identifier', comment = 'ESP="Identific. IVA"';
        InvDiscBaseAmtCaptionLbl: label 'Invoice Discount Base Amount', comment = 'ESP="Importe base descuento factura"';
        LineAmtCaption1Lbl: label 'Line Amount', comment = 'ESP="Importe línea"';
        InvPmtDiscCaptionLbl: label 'Invoice and Payment Discounts', comment = 'ESP="Descuentos facturas y pagos"';
        ECAmtCaptionLbl: label 'EC Amount', comment = 'ESP="Recargo"';
        ECCaptionLbl: label 'EC %', comment = 'ESP="% REC. EQ."';
        TotalCaptionLbl: label 'Total', comment = 'ESP="Total';
        VALVATBaseLCYCaption1Lbl: label 'VAT Base', comment = 'ESP="Base IVA"';
        VATAmtCaptionLbl: label 'VAT Amt.', comment = 'ESP="Importe IVA"';
        VATIdentifierCaptionLbl: label 'VAT Identifier', comment = 'ESP="Identific. IVA"';
        ShiptoAddressCaptionLbl: label 'Ship-to', comment = 'ESP="Entrega en"';
        PmtTermsDescCaptionLbl: label 'Payment Terms', comment = 'ESP="Términos pago"';
        ShpMethodDescCaptionLbl: label 'SHIPMENT METHOD', comment = 'ESP="CONDICIONES ENVIO"';
        PmtMethodDescCaptionLbl: label 'Payment Method', comment = 'ESP="Forma de pago"';
        DocDateCaptionLbl: label 'Document Date', comment = 'ESP="Fecha emisión documento"';
        HomePageCaptionCap: label 'Home Page', comment = 'ESP="Página Web"';
        EmailCaptionLbl: label 'E-Mail', comment = 'ESP="Correo electrónico"';
        CACCaptionLbl: Text;
        CACTxt: label 'Régimen especial del criterio de caja', comment = 'ESP="Régimen especial del criterio de caja"';
        DisplayAdditionalFeeNote: Boolean;
        CompanyInfoCountryLbl: label 'Spain';
        GrupoCompraCaptionLbl: label 'Group', comment = 'ESP="Grupo"';
        VendorCaptionLbl: label 'VENDOR', comment = 'ESP="Proveedor"';
        ReportPrintedLines: Integer;
        PageLines: Integer;
        BlankLines: Integer;
        TotalRepLines: Integer;
        DocLineNo: Integer;
        ItemNoCaptionLbl: label 'Item', comment = 'ESP="Art."';
        EANCaptionLbl: label 'EAN', comment = 'ESP="EAN"';
        UnitsCaptionLbl: label 'PCS', comment = 'ESP="Uds."';
        TotalDiscCaptionLbl: label 'Total Discount', comment = 'ESP="Total Descuento"';
        NetUnitCaptionLbl: label 'Net Unit', comment = 'ESP="Neto Unitario"';
        DiccountsCaptionLbl: label 'Discounts', comment = 'ESP="Descuentos"';
        SimbPctCaptionLbl: label '%';
        AmountsCaptionLbl: label 'Amounts', comment = 'ESP="Importes"';
        DiscPctCaptionLbl: label 'Disc. %', comment = 'ESP="% Dto."';
        DiscAmtCaptionLbl: label 'Disc. Amt.', comment = 'ESP="Cuota Dto"';
        PaymentDiscPctCaptionLbl: label 'D.P. %', comment = 'ESP="% P.P."';
        PDAmtCaptionLbl: label 'D.P. Amt.', comment = 'ESP="Cuota P.P."';
        ECCAmtCaptionLbl: label 'EC Amt.', comment = 'ESP="Cuota EQ"';
        TotalInvCaptionLbl: label 'Total Invoice', comment = 'ESP="Total Factura"';
        ContLine: Integer;
        ObservationsCaptionLbl: label 'Observations', comment = 'ESP="Observaciones"';
        AGCaptionLbl: label 'AG';
        DCCaptionLbl: label 'DC';
        AmountCaptionLbl: label 'Amount', comment = 'ESP="Importe"';
        ReferenceCaptionLbl: label 'Reference', comment = 'ESP="Referencia"';
        FooterText1: label 'Para toda cuestion derivada de esta compra venta las partes se someten expresamente a la jurisdiccion de los juzgados y tribunales de Barcelona, con renuncia expresa a su propio fuero.';
        FooterText2: label 'Ambas partes se comprometen a cumplir con sus respectivas obligaciones legales en relación a los residuos de los envases de tipo comercial o doméstico parte de este acuerdo y en especial en cuanto del Artículo 18 del RD 782/1998.';
        DiscLabel: array[5] of Text[30];
        NetoUnit: Decimal;
        CodeIBAN: Code[50];
        GiroNoCaptionVar: Text[30];
        BankNameCaptionVar: Text[10];
        AGCaptionVar: Text[2];
        DCCaptionVar: Text[2];
        CCCBankNo: Text[4];
        CCCBankBranchNo: Text[4];
        CCCControlDigits: Text[2];
        CCCSwiftCode: Code[20];
        CurrencyText: Code[10];
        LOPDtxt: Text;
        SalesShipmentNoLbl: label 'Sales Shipment No', comment = 'ESP="Nº albarán venta"';
        WhouseShipmentNoLbl: label 'Shipment No.', comment = 'ESP="Nº envío"';
        SalesShipNo: Code[20];
        WarhouseShipNo: Code[20];
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        vatregn: Code[20];
        GeneralLedgerSetup: Record "General Ledger Setup";
        CountryRegion: Record "Country/Region";
        CountryOrigin: Text[50];
        CountryOriginLabel: Code[30];
        CountryOriginAux: Record "Country/Region";
        TariffCode: Text[30];
        TariffCodeCaption: Text[20];
        Item: Record Item;
        CustomerAux: Record Customer;
        Unidades: Text;
        rUnidades: Record "Unit of Measure";
        FormatDocument: Codeunit "Format Document";
        Filler: Text;

    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Sales Inv.") <> '';
    end;

    procedure FindPostedShipmentDate(): Date
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentBuffer2: Record "Sales Shipment Buffer" temporary;
    begin
        NextEntryNo := 1;
        if "Sales Line"."Shipment No." <> '' then if SalesShipmentHeader.Get("Sales Line"."Shipment No.") then exit(SalesShipmentHeader."Posting Date");
        if "Sales Header"."No." = '' then exit("Sales Header"."Posting Date");
        // CASE "Sales Line".Type OF
        //  "Sales Line".Type::Item:
        //    GenerateBufferFromValueEntry("Sales Line");
        //  "Sales Line".Type::"G/L Account","Sales Line".Type::Resource,
        //  "Sales Line".Type::"Charge (Item)","Sales Line".Type::"Fixed Asset":
        //    GenerateBufferFromShipment("Sales Line");
        //  "Sales Line".Type::" ":
        //    EXIT(0D);
        // END;
        SalesShipmentBuffer.Reset;
        SalesShipmentBuffer.SetRange("Document No.", "Sales Line"."Document No.");
        SalesShipmentBuffer.SetRange("Line No.", "Sales Line"."Line No.");
        if SalesShipmentBuffer.Find('-') then begin
            SalesShipmentBuffer2 := SalesShipmentBuffer;
            if SalesShipmentBuffer.Next = 0 then begin
                SalesShipmentBuffer.Get(SalesShipmentBuffer2."Document No.", SalesShipmentBuffer2."Line No.", SalesShipmentBuffer2."Entry No.");
                SalesShipmentBuffer.Delete;
                exit(SalesShipmentBuffer2."Posting Date");
            end;
            SalesShipmentBuffer.CalcSums(Quantity);
            if SalesShipmentBuffer.Quantity <> "Sales Line".Quantity then begin
                SalesShipmentBuffer.DeleteAll;
                exit("Sales Header"."Posting Date");
            end;
        end
        else
            exit("Sales Header"."Posting Date");
    end;

    procedure CorrectShipment(var SalesShipmentLine: Record "Sales Shipment Line")
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        SalesInvoiceLine.SetCurrentkey("Shipment No.", "Shipment Line No.");
        SalesInvoiceLine.SetRange("Shipment No.", SalesShipmentLine."Document No.");
        SalesInvoiceLine.SetRange("Shipment Line No.", SalesShipmentLine."Line No.");
        if SalesInvoiceLine.Find('-') then
            repeat
                SalesShipmentLine.Quantity := SalesShipmentLine.Quantity - SalesInvoiceLine.Quantity;
            until SalesInvoiceLine.Next = 0;
    end;

    procedure AddBufferEntry(SalesInvoiceLine: Record "Sales Invoice Line"; QtyOnShipment: Decimal; PostingDate: Date)
    begin
        SalesShipmentBuffer.SetRange("Document No.", SalesInvoiceLine."Document No.");
        SalesShipmentBuffer.SetRange("Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentBuffer.SetRange("Posting Date", PostingDate);
        if SalesShipmentBuffer.Find('-') then begin
            SalesShipmentBuffer.Quantity := SalesShipmentBuffer.Quantity + QtyOnShipment;
            SalesShipmentBuffer.Modify;
            exit;
        end;
        begin
            SalesShipmentBuffer."Document No." := SalesInvoiceLine."Document No.";
            SalesShipmentBuffer."Line No." := SalesInvoiceLine."Line No.";
            SalesShipmentBuffer."Entry No." := NextEntryNo;
            SalesShipmentBuffer.Type := SalesInvoiceLine.Type;
            SalesShipmentBuffer."No." := SalesInvoiceLine."No.";
            SalesShipmentBuffer.Quantity := QtyOnShipment;
            SalesShipmentBuffer."Posting Date" := PostingDate;
            SalesShipmentBuffer.Insert;
            NextEntryNo := NextEntryNo + 1
        end;
    end;

    local procedure DocumentCaption(): Text[250]
    begin
        exit(Text004);
    end;

    procedure GetCarteraInvoice(): Boolean
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        begin
            CustLedgEntry.SetCurrentkey(CustLedgEntry."Document No.", CustLedgEntry."Document Type", CustLedgEntry."Customer No.");
            CustLedgEntry.SetRange(CustLedgEntry."Document Type", CustLedgEntry."document type"::Invoice);
            CustLedgEntry.SetRange(CustLedgEntry."Document No.", "Sales Header"."No.");
            CustLedgEntry.SetRange(CustLedgEntry."Customer No.", "Sales Header"."Bill-to Customer No.");
            CustLedgEntry.SetRange(CustLedgEntry."Posting Date", "Sales Header"."Posting Date");
            if CustLedgEntry.FindFirst then
                if CustLedgEntry."Document Situation" = CustLedgEntry."document situation"::" " then
                    exit(false)
                else
                    exit(true)
            else
                exit(false);
        end;
    end;

    procedure ShowCashAccountingCriteria(SalesInvoiceHeader: Record "Sales Invoice Header"): Text
    var
        VATEntry: Record "VAT Entry";
    begin
        GLSetup.Get;
        if not GLSetup."Unrealized VAT" then exit;
        CACCaptionLbl := '';
        VATEntry.SetRange("Document No.", SalesInvoiceHeader."No.");
        VATEntry.SetRange("Document Type", VATEntry."document type"::Invoice);
        if VATEntry.FindSet then
            repeat
                if VATEntry."VAT Cash Regime" then CACCaptionLbl := CACTxt;
            until (VATEntry.Next = 0) or (CACCaptionLbl <> '');
        exit(CACCaptionLbl);
    end;

    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean; DisplayAsmInfo: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;

    procedure CollectAsmInformation()
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        SalesShipmentLine: Record "Sales Shipment Line";
    begin
        TempPostedAsmLine.DeleteAll;
        if "Sales Line".Type <> "Sales Line".Type::Item then exit;
        begin
            ValueEntry.SetCurrentkey(ValueEntry."Document No.");
            ValueEntry.SetRange(ValueEntry."Document No.", "Sales Line"."Document No.");
            ValueEntry.SetRange(ValueEntry."Document Type", ValueEntry."document type"::"Sales Invoice");
            ValueEntry.SetRange(ValueEntry."Document Line No.", "Sales Line"."Line No.");
            ValueEntry.SetRange(ValueEntry.Adjustment, false);
            if not ValueEntry.FindSet then exit;
        end;
        repeat
            if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then
                if ItemLedgerEntry."Document Type" = ItemLedgerEntry."document type"::"Sales Shipment" then begin
                    SalesShipmentLine.Get(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.");
                    if SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) then begin
                        PostedAsmLine.SetRange("Document No.", PostedAsmHeader."No.");
                        if PostedAsmLine.FindSet then
                            repeat
                                TreatAsmLineBuffer(PostedAsmLine);
                            until PostedAsmLine.Next = 0;
                    end;
                end;
        until ValueEntry.Next = 0;
    end;

    procedure TreatAsmLineBuffer(PostedAsmLine: Record "Posted Assembly Line")
    begin
        Clear(TempPostedAsmLine);
        TempPostedAsmLine.SetRange(Type, PostedAsmLine.Type);
        TempPostedAsmLine.SetRange("No.", PostedAsmLine."No.");
        TempPostedAsmLine.SetRange("Variant Code", PostedAsmLine."Variant Code");
        TempPostedAsmLine.SetRange(Description, PostedAsmLine.Description);
        TempPostedAsmLine.SetRange("Unit of Measure Code", PostedAsmLine."Unit of Measure Code");
        if TempPostedAsmLine.FindFirst then begin
            TempPostedAsmLine.Quantity += PostedAsmLine.Quantity;
            TempPostedAsmLine.Modify;
        end
        else begin
            Clear(TempPostedAsmLine);
            TempPostedAsmLine := PostedAsmLine;
            TempPostedAsmLine.Insert;
        end;
    end;

    procedure GetUOMText(UOMCode: Code[10]): Text[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if not UnitOfMeasure.Get(UOMCode) then exit(UOMCode);
        exit(UnitOfMeasure.Description);
    end;

    procedure BlanksForIndent(): Text[10]
    begin
        exit(PadStr('', 2, ' '));
    end;

    local procedure GetLineFeeNoteOnReportHist(SalesInvoiceHeaderNo: Code[20])
    var
        LineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist.";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Customer: Record Customer;
    begin
        TempLineFeeNoteOnReportHist.DeleteAll;
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."document type"::Invoice);
        CustLedgerEntry.SetRange("Document No.", SalesInvoiceHeaderNo);
        if not CustLedgerEntry.FindFirst then exit;
        if not Customer.Get(CustLedgerEntry."Customer No.") then exit;
        LineFeeNoteOnReportHist.SetRange("Cust. Ledger Entry No", CustLedgerEntry."Entry No.");
        LineFeeNoteOnReportHist.SetRange("Language Code", Customer."Language Code");
        if LineFeeNoteOnReportHist.FindSet then begin
            repeat
                TempLineFeeNoteOnReportHist.Init;
                TempLineFeeNoteOnReportHist.Copy(LineFeeNoteOnReportHist);
                TempLineFeeNoteOnReportHist.Insert;
            until LineFeeNoteOnReportHist.Next = 0;
        end
        else begin
            //ini - 'Record Language' does not contain a definition for 'GetUserLanguage'
            //LineFeeNoteOnReportHist.SetRange("Language Code", Language.GetUserLanguage);
            LineFeeNoteOnReportHist.SetRange("Language Code", cLanguage.GetUserLanguageCode());
            //fin - 'Record Language' does not contain a definition for 'GetUserLanguage'
            if LineFeeNoteOnReportHist.FindSet then
                repeat
                    TempLineFeeNoteOnReportHist.Init;
                    TempLineFeeNoteOnReportHist.Copy(LineFeeNoteOnReportHist);
                    TempLineFeeNoteOnReportHist.Insert;
                until LineFeeNoteOnReportHist.Next = 0;
        end;
    end;

    local procedure CalculateBlankLines(PrintedLines: Integer): Integer
    var
        i: Integer;
    begin
        i := 1;
        // WHILE (PageLines * i < PrintedLines) DO
        //  i += 1;
        //
        // EXIT(PageLines * i - PrintedLines);
    end;
}
