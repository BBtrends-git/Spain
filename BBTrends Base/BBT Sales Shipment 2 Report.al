Report 50000 "Sales - Shipment 2"
{
    // //INC-2016-11-63831
    //   - Quitar la forma de la variable Vendortext
    // 
    // //INC-2019-01-105854 : Mostrar pie Protección de datos
    // 
    // //11/03/19 SDA - Mostrar Referencia Cruzada.
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/Sales - Shipment 2.rdl';
    Caption = 'Sales - Shipment', comment = 'ESP="Venta - Alb. venta"';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(CompanyLogo; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            column(ReportForNavId_1100234016; 1100234016)
            { }
            column(CompanyInfo1Picture; CompanyInfo.Picture)
            { }
        }
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Shipment', comment = 'ESP="Histórico albaranes venta"';

            column(ReportForNavId_3595; 3595)
            { }
            column(No_SalesShptHeader; "Sales Shipment Header"."No.")
            { }
            column(PageCaption; PageCaptionCap)
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
                    column(SalesShptCopyText; StrSubstNo(Text002, CopyText))
                    { }
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
                    column(SellToAddr1; SellToAddr[1])
                    { }
                    column(SellToAddr2; SellToAddr[2])
                    { }
                    column(SellToAddr3; SellToAddr[3])
                    { }
                    column(SellToAddr4; SellToAddr[4])
                    { }
                    column(SellToAddr5; SellToAddr[5])
                    { }
                    column(SellToAddr6; SellToAddr[6])
                    { }
                    column(SellToAddr7; SellToAddr[7])
                    { }
                    column(SellToAddr8; SellToAddr[8])
                    { }
                    column(SellCustCaption; SellCustLbl)
                    { }
                    column(SellCust; "Sales Shipment Header"."Sell-to Customer No.")
                    { }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    { }
                    column(CompanyInfoEmail; CompanyInfo."E-Mail")
                    { }
                    column(CompanyInfoFaxNo; CompanyInfo."Fax No.")
                    { }
                    column(CompanyInfoVATRegtnNo; CompanyInfo."VAT Registration No.")
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
                    column(CompanyInfoRegTextopie5; CompanyInfo."Commercial Register Text")
                    { }
                    column(SelltoCustNo_SalesShptHeader; "Sales Shipment Header"."Sell-to Customer No.")
                    { }
                    column(DocDate_SalesShptHeader; Format("Sales Shipment Header"."Document Date", 0, 4))
                    { }
                    column(SalesPersonText; SalesPersonText)
                    { }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    { }
                    column(SalespersonCode_SalesShptHeader; "Sales Shipment Header"."Salesperson Code")
                    { }
                    column(ReferenceText; ReferenceText)
                    { }
                    column(YourRef_SalesShptHeader; "Sales Shipment Header"."Your Reference")
                    { }
                    column(ShipToAddr7; ShipToAddr[7])
                    { }
                    column(ShipToAddr8; ShipToAddr[8])
                    { }
                    column(CompanyAddr5; CompanyAddr[5])
                    { }
                    column(CompanyAddr6; CompanyAddr[6])
                    { }
                    column(ShptDate_SalesShptHeader; "Sales Shipment Header"."Posting Date")
                    { }
                    column(OutputNo; OutputNo)
                    { }
                    column(ItemTrackingAppendixCaption; ItemTrackingAppendixCaptionLbl)
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
                    column(ShipmentNoCaption; ShipmentNoCaptionLbl)
                    { }
                    column(ShipmentDateCaption; ShipmentDateCaptionLbl)
                    { }
                    column(HomePageCaption; HomePageCaptionLbl)
                    { }
                    column(EmailCaption; EmailCaptionLbl)
                    { }
                    column(DocumentDateCaption; DocumentDateCaptionLbl)
                    { }
                    column(SelltoCustNo_SalesShptHeaderCaption; SelltoCustNoCaptionLbl)
                    { }
                    column(ShipmentMethod_SalesShptHeader; "Sales Shipment Header"."Shipment Method Code")
                    { }
                    column(ShipmentMethodCaption; ShipmentMethodCaptionLbl)
                    { }
                    column(ShipAgentCaption; ShipAgentCaptionLbl)
                    { }
                    column(VendorCaption; VendorCaptionLbl)
                    { }
                    column(VendorText; VendorText)
                    { }
                    column(Name_ShippingAgent; ShippingAgent.Name)
                    { }
                    column(OrderNo_SalesShptHeaderSales; "Sales Shipment Header"."External Document No.")
                    { }
                    column(CommentsCaption; CommentsCaptionTxt)
                    { }
                    column(CommentLine1; CommentLine[1])
                    { }
                    column(CommentLine2; CommentLine[2])
                    { }
                    column(CommentLine3; CommentLine[3])
                    { }
                    column(CommentLine4; CommentLine[4])
                    { }
                    column(OrderNoCaption; OrderNoCaptionLbl)
                    { }
                    column(ValuedShipment; ValuedShipment)
                    { }
                    column(WhseShipmentNoLbl; WhseShipmentNoLbl)
                    { }
                    column(No_Envio; LinEnvioReg."Whse. Shipment No.")
                    { }
                    column(Ref; "Sales Shipment Header".Reference)
                    { }
                    column(RefTxt; RefLbl)
                    { }
                    column(RequestDeliveryCaption; "Sales Shipment Header".Fieldcaption("Request delivery appointment"))
                    { }
                    column(RequestDelivery; "Sales Shipment Header"."Request delivery appointment")
                    { }
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Sales Shipment Header";
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
                    dataitem("Sales Shipment Line"; "Sales Shipment Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = "Sales Shipment Header";
                        DataItemTableView = sorting("Document No.", "Line No.");

                        column(ReportForNavId_2502; 2502)
                        { }
                        column(Description_SalesShptLine; "Sales Shipment Line".Description)
                        { }
                        column(ShowInternalInfo; ShowInternalInfo)
                        { }
                        column(ShowCorrectionLines; ShowCorrectionLines)
                        { }
                        column(Type_SalesShptLine; Format("Sales Shipment Line".Type, 0, 2))
                        { }
                        column(AsmHeaderExists; AsmHeaderExists)
                        { }
                        column(DocumentNo_SalesShptLine; "Sales Shipment Line"."Document No.")
                        { }
                        column(LinNo; LinNo)
                        { }
                        column(Qty_SalesShptLine; "Sales Shipment Line".Quantity)
                        { }
                        column(UOM_SalesShptLine; "Sales Shipment Line"."Unit of Measure")
                        { }
                        column(No_SalesShptLine; "Sales Shipment Line"."No.")
                        { }
                        column(LineNo_SalesShptLine; "Sales Shipment Line"."Line No.")
                        { }
                        //ini - Field 'Cross-Reference No.' is marked for removal. Reason: Cross-Reference replaced by Item Reference feature.. Tag: 17.0.
                        // column(CrossReferenceNo_SalesShptLine;"Sales Shipment Line"."Cross-Reference No.")
                        // {
                        // }
                        column(CrossReferenceNo_SalesShptLine; "Sales Shipment Line"."Item Reference No.")
                        { }
                        //fin - Field 'Cross-Reference No.' is marked for removal. Reason: Cross-Reference replaced by Item Reference feature.. Tag: 17.0.
                        column(Description_SalesShptLineCaption; "Sales Shipment Line".FieldCaption("Sales Shipment Line".Description))
                        { }
                        column(Qty_SalesShptLineCaption; QuantityCaptionLbl)
                        { }
                        column(UOM_SalesShptLineCaption; "Sales Shipment Line".FieldCaption("Sales Shipment Line"."Unit of Measure"))
                        { }
                        column(No_SalesShptLineCaption; NoCaptionLbl)
                        { }
                        column(PriceCaption; PriceCaptionLbl)
                        { }
                        column(TotalDiscCaption; TotalDiscCaptionLbl)
                        { }
                        column(EanCodeCaption; EanCodeCaptionLbl)
                        { }
                        column(NetUnitCaption; NetUnitCaptionLbl)
                        { }
                        column(NetLinCaption; NetLinCaptionLbl)
                        { }
                        column(UnitPrice_SalesShptLine; "Sales Shipment Line"."Unit Price")
                        { }
                        column(UnitDiscount; UnitDiscount)
                        { }
                        column(NetUnit; NetUnit)
                        { }
                        column(NetLine; NetLine)
                        { }
                        column(TotalShipmentCaption; TotalShipmentCaptionLbl)
                        { }
                        column(EAN_SalesShptLine; "Sales Shipment Line"."EAN Code")
                        { }
                        column(CrossReferenceNoCaption; CrossReferenceNoCaptionLbl)
                        { }
                        column(LineCount; LineCount)
                        { }
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
                        dataitem(DisplayAsmInfo; "Integer")
                        {
                            DataItemTableView = sorting(Number);

                            column(ReportForNavId_7359; 7359)
                            { }
                            column(PostedAsmLineItemNo; BlanksForIndent + PostedAsmLine."No.")
                            { }
                            column(PostedAsmLineDescription; BlanksForIndent + PostedAsmLine.Description)
                            { }
                            column(PostedAsmLineQuantity; PostedAsmLine.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(PostedAsmLineUOMCode; GetUnitOfMeasureDescr(PostedAsmLine."Unit of Measure Code"))
                            {
                                //DecimalPlaces = 0:5; //The property 'DecimalPlaces' can only be set if the property 'Type' is set to 'Decimal'
                            }
                            trigger OnAfterGetRecord()
                            var
                                ItemTranslation: Record "Item Translation";
                            begin
                                if DisplayAsmInfo.Number = 1 then
                                    PostedAsmLine.FindSet
                                else
                                    PostedAsmLine.Next;
                                if ItemTranslation.Get(PostedAsmLine."No.", PostedAsmLine."Variant Code", "Sales Shipment Header"."Language Code") then PostedAsmLine.Description := ItemTranslation.Description;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not DisplayAssemblyInformation then CurrReport.Break;
                                if not AsmHeaderExists then CurrReport.Break;
                                PostedAsmLine.SetRange("Document No.", PostedAsmHeader."No.");
                                DisplayAsmInfo.SetRange(DisplayAsmInfo.Number, 1, PostedAsmLine.Count);
                            end;
                        }
                        trigger OnAfterGetRecord()
                        begin
                            LinNo := "Sales Shipment Line"."Line No.";
                            if not ShowCorrectionLines and "Sales Shipment Line".Correction then CurrReport.Skip;
                            //I AHR
                            if ("Sales Shipment Line".Type.AsInteger() <> 0) and ("Sales Shipment Line".Quantity = 0) then CurrReport.Skip;
                            //F AHR
                            DimSetEntry2.SetRange("Dimension Set ID", "Sales Shipment Line"."Dimension Set ID");
                            if DisplayAssemblyInformation then AsmHeaderExists := "Sales Shipment Line".AsmToShipmentExists(PostedAsmHeader);
                            UnitDiscount := 0;
                            if "Sales Shipment Line".Quantity <> 0 then
                                //>> BBT. 16/03/2026. Implantación de la extensión SMG.
                                //UnitDiscount := ROUND("Discounts Total Amount" / "Sales Shipment Line".Quantity, 0.01);
                                UnitDiscount := ROUND("SMG Discounts Total Amount" / "Sales Shipment Line".Quantity, 0.01);
                            //<<
                            NetUnit := "Sales Shipment Line"."Unit Price" - UnitDiscount;
                            NetLine := ROUND("Sales Shipment Line".Quantity * NetUnit, 0.01);
                            LineCount += 1;
                        end;

                        trigger OnPostDataItem()
                        begin
                            if ShowLotSN then begin
                                ItemTrackingDocMgt.SetRetrieveAsmItemTracking(true);
                                TrackingSpecCount := ItemTrackingDocMgt.RetrieveDocumentItemTracking(TrackingSpecBuffer, "Sales Shipment Header"."No.", Database::"Sales Shipment Header", 0);
                                ItemTrackingDocMgt.SetRetrieveAsmItemTracking(false);
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := "Sales Shipment Line".Find('+');
                            while MoreLines and ("Sales Shipment Line".Description = '') and ("Sales Shipment Line"."No." = '') and ("Sales Shipment Line".Quantity = 0) do MoreLines := "Sales Shipment Line".Next(-1) <> 0;
                            if not MoreLines then CurrReport.Break;
                            "Sales Shipment Line".SetRange("Sales Shipment Line"."Line No.", 0, "Sales Shipment Line"."Line No.");
                            LineCount := 0;
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
                        column(BilltoCustNo_SalesShptHeader; "Sales Shipment Header"."Bill-to Customer No.")
                        { }
                        column(CustAddr1; CustAddr[1])
                        { }
                        column(CustAddr2; CustAddr[2])
                        { }
                        column(CustAddr3; CustAddr[3])
                        { }
                        column(CustAddr4; CustAddr[4])
                        { }
                        column(CustAddr5; CustAddr[5])
                        { }
                        column(CustAddr6; CustAddr[6])
                        { }
                        column(CustAddr7; CustAddr[7])
                        { }
                        column(CustAddr8; CustAddr[8])
                        { }
                        column(BilltoAddressCaption; BilltoAddressCaptionLbl)
                        { }
                        column(BilltoCustNo_SalesShptHeaderCaption; "Sales Shipment Header".FieldCaption("Bill-to Customer No."))
                        { }
                        trigger OnPreDataItem()
                        begin
                            if not ShowCustAddr then CurrReport.Break;
                        end;
                    }
                    dataitem(ItemTrackingLine; "Integer")
                    {
                        DataItemTableView = sorting(Number);

                        column(ReportForNavId_6034; 6034)
                        { }
                        column(TrackingSpecBufferNo; TrackingSpecBuffer."Item No.")
                        { }
                        column(TrackingSpecBufferDesc; TrackingSpecBuffer.Description)
                        { }
                        column(TrackingSpecBufferLotNo; TrackingSpecBuffer."Lot No.")
                        { }
                        column(TrackingSpecBufferSerNo; TrackingSpecBuffer."Serial No.")
                        { }
                        column(TrackingSpecBufferQty; TrackingSpecBuffer."Quantity (Base)")
                        { }
                        column(ShowTotal; ShowTotal)
                        { }
                        column(ShowGroup; ShowGroup)
                        { }
                        column(QuantityCaption; QuantityCaptionLbl)
                        { }
                        column(SerialNoCaption; SerialNoCaptionLbl)
                        { }
                        column(LotNoCaption; LotNoCaptionLbl)
                        { }
                        column(DescriptionCaption; DescriptionCaptionLbl)
                        { }
                        column(NoCaption; NoCaptionLbl)
                        { }
                        dataitem(TotalItemTracking; "Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number = const(1));

                            column(ReportForNavId_3353; 3353)
                            { }
                            column(Quantity1; TotalQty)
                            { }
                        }
                        trigger OnAfterGetRecord()
                        begin
                            if ItemTrackingLine.Number = 1 then
                                TrackingSpecBuffer.FindSet
                            else
                                TrackingSpecBuffer.Next;
                            if not ShowCorrectionLines and TrackingSpecBuffer.Correction then CurrReport.Skip;
                            if TrackingSpecBuffer.Correction then TrackingSpecBuffer."Quantity (Base)" := -TrackingSpecBuffer."Quantity (Base)";
                            ShowTotal := false;
                            if ItemTrackingAppendix.IsStartNewGroup(TrackingSpecBuffer) then ShowTotal := true;
                            ShowGroup := false;
                            if (TrackingSpecBuffer."Source Ref. No." <> OldRefNo) or (TrackingSpecBuffer."Item No." <> OldNo) then begin
                                OldRefNo := TrackingSpecBuffer."Source Ref. No.";
                                OldNo := TrackingSpecBuffer."Item No.";
                                TotalQty := 0;
                            end
                            else
                                ShowGroup := true;
                            TotalQty += TrackingSpecBuffer."Quantity (Base)";
                        end;

                        trigger OnPreDataItem()
                        begin
                            if TrackingSpecCount = 0 then CurrReport.Break;
                            //>> BBT. CurrReport.Newpage marcada como obsoleta.
                            //CurrReport.Newpage;
                            //<<
                            ItemTrackingLine.SetRange(ItemTrackingLine.Number, 1, TrackingSpecCount);
                            TrackingSpecBuffer.SetCurrentkey("Source ID", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");
                        end;
                    }
                    trigger OnPreDataItem()
                    begin
                        // Item Tracking:
                        if ShowLotSN then begin
                            TrackingSpecCount := 0;
                            OldRefNo := 0;
                            ShowGroup := false;
                        end;
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    if CopyLoop.Number > 1 then begin
                        CopyText := FormatDocument.GetCOPYText();
                        OutputNo += 1;
                    end;
                    //CurrReport.PageNo := 1; //'PageNo' is being deprecated in the versions: '1.0' or greater.  This warning will become an error in a future release.
                    TotalQty := 0; // Item Tracking
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then ShptCountPrinted.Run("Sales Shipment Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := 1 + Abs(NoOfCopies);
                    CopyText := '';
                    CopyLoop.SetRange(CopyLoop.Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                //ini - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
                //CurrReport.Language := Language.GetLanguageID("Sales Shipment Header"."Language Code");
                IF "Sales Shipment Header"."Language Code" <> '' then
                    CurrReport.Language := cLanguage.GetLanguageID("Sales Shipment Header"."Language Code")
                else
                    CurrReport.Language := cLanguage.GetLanguageID('ESP');
                //fin - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
                if RespCenter.Get("Sales Shipment Header"."Responsibility Center") then begin
                    RespCenter.Contact := '';
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end
                else begin
                    CompanyInfo."Address 2" := '';
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                end;
                DimSetEntry1.SetRange("Dimension Set ID", "Sales Shipment Header"."Dimension Set ID");
                if "Sales Shipment Header"."Salesperson Code" = '' then begin
                    SalesPurchPerson.Init;
                    SalesPersonText := '';
                end
                else begin
                    SalesPurchPerson.Get("Sales Shipment Header"."Salesperson Code");
                    SalesPersonText := Text000;
                end;
                if "Sales Shipment Header"."Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := "Sales Shipment Header".FieldCaption("Sales Shipment Header"."Your Reference");
                "Sales Shipment Header"."Ship-to Contact" := '';
                "Sales Shipment Header"."Bill-to Contact" := '';
                FormatAddr.SalesShptShipTo(ShipToAddr, "Sales Shipment Header");
                FormatAddr.SalesShptSellTo(SellToAddr, "Sales Shipment Header");
                //ini - There is no argument given that corresponds to the required formal parameter 'SalesShptHeader' of 'SalesShptBillTo(var array[8] of Text[100], array[8] of Text[100], var Record "Sales Shipment Header")'
                //FormatAddr.SalesShptBillTo(CustAddr,"Sales Shipment Header");
                FormatAddr.SalesShptBillTo(CustAddr, ShipToAddr, "Sales Shipment Header");
                //fin - There is no argument given that corresponds to the required formal parameter 'SalesShptHeader' of 'SalesShptBillTo(var array[8] of Text[100], array[8] of Text[100], var Record "Sales Shipment Header")'
                ShowCustAddr := "Sales Shipment Header"."Bill-to Customer No." <> "Sales Shipment Header"."Sell-to Customer No.";
                for i := 1 to ArrayLen(CustAddr) do if CustAddr[i] <> ShipToAddr[i] then ShowCustAddr := true;
                VendorText := '';
                if Cust.Get("Sales Shipment Header"."Sell-to Customer No.") then begin
                    if Cust."Our Account No." <> '' then VendorText := Cust."Our Account No.";
                    //I-INC-2016-11-63831
                    /*
                        IF PaymentMethod.GET("Payment Method Code") THEN
                          IF PaymentMethod.Description <> '' THEN
                          BEGIN
                            IF VendorText <> '' THEN
                              VendorText := VendorText + ' - ' + PaymentMethod.Description;
                          END;
                        */
                    //F-INC-2016-11-63831
                end;
                if not ShippingAgent.Get("Sales Shipment Header"."Shipping Agent Code") then ShippingAgent.Init;
                Clear(CommentLine);
                CommentsCaptionTxt := '';
                i := 1;
                SalesComment.Reset;
                SalesComment.SetRange("Document Type", SalesComment."document type"::Shipment);
                SalesComment.SetRange("No.", "Sales Shipment Header"."No.");
                if SalesComment.FindSet then
                    repeat
                        if SalesComment.Comment <> '' then begin
                            CommentLine[i] := SalesComment.Comment;
                            CommentsCaptionTxt := CopyStr(CommentsCaptionLbl, 1, MaxStrLen(CommentsCaptionTxt));
                            i += 1
                        end;
                    until (SalesComment.Next = 0) or (i > 4);
                CompressArray(CommentLine);
                // SGA
                LinEnvioReg.Reset;
                LinEnvioReg.SetCurrentkey("Posted Source No.", "Posting Date");
                LinEnvioReg.SetRange("Posted Source Document", LinEnvioReg."posted source document"::"Posted Shipment");
                LinEnvioReg.SetRange("Posted Source No.", "Sales Shipment Header"."No.");
                //LinEnvioReg.SETRANGE("Posting Date","Posting Date");
                if not LinEnvioReg.FindFirst then Clear(LinEnvioReg);
                // SGA
                if LogInteraction then if not CurrReport.Preview then SegManagement.LogDocument(5, "Sales Shipment Header"."No.", 0, 0, Database::Customer, "Sales Shipment Header"."Sell-to Customer No.", "Sales Shipment Header"."Salesperson Code", "Sales Shipment Header"."Campaign No.", "Sales Shipment Header"."Posting Description", '');
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

                    field(ValuedShipment; ValuedShipment)
                    {
                        ApplicationArea = Basic, Suite;
                        Visible = false;
                        Caption = 'Valued shipment', comment = 'ESP="Envío valorado"';
                    }
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
                    field("Show Correction Lines"; ShowCorrectionLines)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Correction Lines', comment = 'ESP="Muestra líneas corrección"';
                        Visible = false;
                    }
                    field(ShowLotSN; ShowLotSN)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Serial/Lot Number Appendix', comment = 'ESP="Mostrar apéndice números serie/lote"';
                        Visible = false;
                    }
                    field(DisplayAsmInfo; DisplayAssemblyInformation)
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
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
        end;
    }
    labels
    {
    }
    trigger OnInitReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
        //Imprimir albarán valorado
        ValuedShipment := false;
    end;

    trigger OnPreReport()
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        Customer: Record Customer;
    begin
        if not CurrReport.UseRequestPage then InitLogInteraction;
        AsmHeaderExists := false;
        Clear(SalesShipmentHeader);
        Clear(Customer);
        SalesShipmentHeader.SetRange("No.", "Sales Shipment Header".GetFilter("No."));
        IF SalesShipmentHeader.FindFirst() then begin
            IF Customer.get(SalesShipmentHeader."Bill-to Customer No.") then begin
                IF Customer."Valued Shipment" then
                    ValuedShipment := true
                else
                    ValuedShipment := false;
            end;
        end;
    end;

    var
        Text000: label 'Salesperson', Comment = 'ESP="Representante"';
        Text002: label 'Sales Shipment %1', comment = 'ESP="Venta - Alb. venta %1"';
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        //ini - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
        //Language: Record Language;
        cLanguage: Codeunit Language;
        //fin - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
        TrackingSpecBuffer: Record "Tracking Specification" temporary;
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        Cust: Record Customer;
        SalesComment: Record "Sales Comment Line";
        ShippingAgent: Record "Shipping Agent";
        ShptCountPrinted: Codeunit "Sales Shpt.-Printed";
        SegManagement: Codeunit SegManagement;
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
        RespCenter: Record "Responsibility Center";
        ItemTrackingAppendix: Report "Item Tracking Appendix";
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        SalesPersonText: Text[20];
        ReferenceText: Text[80];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        OutputNo: Integer;
        NoOfLoops: Integer;
        TrackingSpecCount: Integer;
        OldRefNo: Integer;
        OldNo: Code[20];
        CopyText: Text[30];
        ShowCustAddr: Boolean;
        i: Integer;
        FormatAddr: Codeunit "Format Address";
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        ShowCorrectionLines: Boolean;
        ShowLotSN: Boolean;
        ShowTotal: Boolean;
        ShowGroup: Boolean;
        TotalQty: Decimal;
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        AsmHeaderExists: Boolean;
        LinNo: Integer;
        ItemTrackingAppendixCaptionLbl: label 'Item Tracking - Appendix', comment = 'ESP="Seguimiento productos - Apéndice"';
        PhoneNoCaptionLbl: label 'Phone:', comment = 'ESP="Teléfono:"';
        VATRegNoCaptionLbl: label 'VAT Reg. No.', comment = 'ESP="NIF"';
        GiroNoCaptionLbl: label 'Giro No.', comment = 'ESP="Nº giro postal"';
        BankNameCaptionLbl: label 'Bank', comment = 'ESP="Banco"';
        BankAccNoCaptionLbl: label 'Account No.', comment = 'ESP="Nº cuenta"';
        ShipmentNoCaptionLbl: label 'Shipment No.', comment = 'ESP="Núm. albarán"';
        ShipmentDateCaptionLbl: label 'Shipment Date', comment = 'ESP="Fecha albarán"';
        HomePageCaptionLbl: label 'Home Page', comment = 'ESP="Página Web"';
        EmailCaptionLbl: label 'E-Mail', comment = 'ESP="Correo electrónico"';
        DocumentDateCaptionLbl: label 'Document Date', comment = 'ESP="Fecha emisión documento"';
        HeaderDimensionsCaptionLbl: label 'Header Dimensions', comment = 'ESP="Dimensiones cabecera"';
        LineDimensionsCaptionLbl: label 'Line Dimensions', comment = 'ESP="Dimensiones línea"';
        BilltoAddressCaptionLbl: label 'Bill-to Address', comment = 'ESP="Fact. a-Dirección"';
        QuantityCaptionLbl: label 'Units', comment = 'ESP="Unidades"';
        SerialNoCaptionLbl: label 'Serial No.', comment = 'ESP="Nº serie"';
        LotNoCaptionLbl: label 'Lot No.', comment = 'ESP="Nº lote"';
        DescriptionCaptionLbl: label 'Description', comment = 'ESP="Descripción"';
        NoCaptionLbl: label 'Item', comment = 'ESP="Artículo"';
        PageCaptionCap: label 'Page %1 of %2', comment = 'ESP="Página %1 de %2"';
        ShipmentMethodCaptionLbl: label 'Shipment Method', comment = 'ESP="Medio envío"';
        GroupCaptionLbl: label 'Group', comment = 'ESP="Grupo"';
        VendorCaptionLbl: label 'Vendor', comment = 'ESP="Proveedor"';
        SelltoCustNoCaptionLbl: label 'Shipment address', comment = 'ESP="Dirección envío"';
        PaymentMethod: Record "Payment Method";
        VendorText: Text[85];
        PriceCaptionLbl: label 'Price', comment = 'ESP="Precio Tarifa"';
        TotalDiscCaptionLbl: label 'Total Unit Discount', comment = 'ESP="Todal descuento unitario"';
        EanCodeCaptionLbl: label 'EAN Code', comment = 'ESP="EAN"';
        NetUnitCaptionLbl: label 'Net Unit', comment = 'ESP="Neto unitario"';
        NetLinCaptionLbl: label 'Net Line', comment = 'ESP="Neto línea"';
        UnitDiscount: Decimal;
        NetUnit: Decimal;
        NetLine: Decimal;
        TotalShipmentCaptionLbl: label 'Total Shipment', comment = 'ESP="Total albarán"';
        CommentsCaptionLbl: label 'Commnents', comment = 'ESP="Observaciones"';
        ValuedShipment: Boolean;
        OrderNoCaptionLbl: label 'Order', comment = 'ESP="Pedido"';
        LineCount: Integer;
        CommentsCaptionTxt: Text[30];
        CommentLine: array[4] of Text[80];
        ShipAgentCaptionLbl: label 'Shipping Agent', comment = 'ESP="Transportista"';
        LinEnvioReg: Record "Posted Whse. Shipment Line";
        WhseShipmentNoLbl: label 'Whse. Shipment No.', comment = 'ESP="Nº envío almacén"';
        CrossReferenceNoCaptionLbl: label 'Customer Reference', comment = 'ESP="Producto cliente"';
        RefLbl: label 'Reference', comment = 'ESP="Referencia"';
        SellToAddr: array[8] of Text[50];
        SellCustLbl: label 'Customer No.', comment = 'ESP="Nº Cliente"';
        FormatDocument: Codeunit "Format Document";

    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Sales Shpt. Note") <> '';
    end;

    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean; NewShowCorrectionLines: Boolean; NewShowLotSN: Boolean; DisplayAsmInfo: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
        ShowCorrectionLines := NewShowCorrectionLines;
        ShowLotSN := NewShowLotSN;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;

    local procedure GetUnitOfMeasureDescr(UOMCode: Code[10]): Text[10]
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

    procedure setValuedShipment(Bool: Boolean)
    begin
        ValuedShipment := Bool;
    end;
}
