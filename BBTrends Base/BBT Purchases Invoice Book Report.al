Report 50063 "BBT Purchases Invoice Book"
//fin - The application object identifier '10705' is not valid. It must be within the allowed ranges '[50000..90500]'.
//    - An application object of type 'Report' with name 'Purchases Invoice Book' is already declared by the extension 'Base Application by Microsoft (18.0.23013.23795)'
{
    // //INC-2018-11-102352: //INC-2018-04-91435: SII MICROSOFT ABRIL
    //                         - Filtrar por "Fecha emisión documento"
    //                         - Mostrar en Layout "Fecha emisión documento"
    //                         - Cambios en diseño Layout
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/Purchases Invoice Book.rdl';
    Caption = 'Purchases Invoice Book', comment = 'ESP="Libro facturas recibidas"';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("<Integer3>"; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            column(ReportForNavId_1432; 1432)
            { }
            column(USERID; UserId)
            { }
            column(CompanyAddr_7_; CompanyAddr[7])
            { }
            column(CompanyAddr_4_; CompanyAddr[4])
            { }
            column(CompanyAddr_5_; CompanyAddr[5])
            { }
            column(CompanyAddr_6_; CompanyAddr[6])
            { }
            column(CompanyAddr_3_; CompanyAddr[3])
            { }
            column(CompanyAddr_2_; CompanyAddr[2])
            { }
            column(CompanyAddr_1_; CompanyAddr[1])
            { }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            { }
            column(SortPostDate; SortPostDate)
            { }
            column(PrintAmountsInAddCurrency; PrintAmountsInAddCurrency)
            { }
            column(HeaderText; HeaderText)
            { }
            column(AuxVatEntry; AuxVatEntry)
            { }
            column(Integer3__Number; "<Integer3>".Number)
            { }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            { }
            column(Purchases_Invoice_BookCaption; Purchases_Invoice_BookCaptionLbl)
            { }
            column(TotalCaption; TotalCaptionLbl)
            { }
            column(AmountCaption; AmountCaptionLbl)
            { }
            column(EC_Caption; EC_CaptionLbl)
            { }
            column(VAT_Caption; VAT_CaptionLbl)
            { }
            column(BaseCaption; BaseCaptionLbl)
            { }
            column(VAT_RegistrationCaption; VAT_RegistrationCaptionLbl)
            { }
            column(NameCaption; NameCaptionLbl)
            { }
            column(External_Document_No_Caption; External_Document_No_CaptionLbl)
            { }
            column(Posting_DateCaption; Posting_DateCaptionLbl)
            { }
            column(Document_DateCaption; Document_DateCaptionLbl)
            { }
            column(Document_No_Caption; Document_No_CaptionLbl)
            { }
            column(Epedition_DateCaption; Epedition_DateCaptionLbl)
            { }
            dataitem(VATEntry; "VAT Entry")
            {
                DataItemTableView = sorting("No. Series", "Posting Date") where(Type = const(Purchase));
                RequestFilterFields = "Posting Date", "Document Date", "Document Type", "Document No.";

                column(ReportForNavId_2276; 2276)
                { }
                column(Base_TotalBaseImport; VATEntry.Base - TotalBaseImport)
                { }
                column(AmountVatReverse3; AmountVatReverse3)
                { }
                column(Base_AmountVatReverse3; VATEntry.Base + AmountVatReverse3)
                { }
                column(Additional_Currency_Base__TotalBaseImport; VATEntry."Additional-Currency Base" - TotalBaseImport)
                { }
                column(AmountVatReverse3_Control30; AmountVatReverse3)
                { }
                column(Additional_Currency_Base__AmountVatReverse3; VATEntry."Additional-Currency Base" + AmountVatReverse3)
                { }
                column(Base_Base2__TotalBaseImport; (VATEntry.Base + Base2) - TotalBaseImport)
                { }
                column(AmountVatReverse3_Amount2; AmountVatReverse3 + Amount2)
                { }
                column(Base_Base2___AmountVatReverse3_Amount2_; (VATEntry.Base + Base2) + (AmountVatReverse3 + Amount2))
                { }
                column(Additional_Currency_Base__Base2__TotalBaseImport; (VATEntry."Additional-Currency Base" + Base2) - TotalBaseImport)
                { }
                column(AmountVatReverse3___Amount2; AmountVatReverse3 + Amount2)
                { }
                column(Additional_Currency_Base__Base2___AmountVatReverse3_Amount2_; (VATEntry."Additional-Currency Base" + Base2) + (AmountVatReverse3 + Amount2))
                { }
                column(VATEntry__No__Series_; VATEntry."No. Series")
                { }
                column(Base_AmountVatReverse; VATEntry.Base + AmountVatReverse)
                { }
                column(AmountVatReverse; AmountVatReverse)
                { }
                column(Base_TotalBaseImport_Control74; VATEntry.Base - TotalBaseImport)
                { }
                column(VATEntry__No__Series__Control75; VATEntry."No. Series")
                { }
                column(VATEntry__No__Series__Control80; VATEntry."No. Series")
                { }
                column(Additional_Currency_Base__TotalBaseImport_Control84; VATEntry."Additional-Currency Base" - TotalBaseImport)
                { }
                column(AmountVatReverse_Control85; AmountVatReverse)
                { }
                column(Additional_Currency_Base__AmountVatReverse; VATEntry."Additional-Currency Base" + AmountVatReverse)
                { }
                column(Base_TotalBaseImport_Control23; VATEntry.Base - TotalBaseImport)
                { }
                column(AmountVatReverse3_Control40; AmountVatReverse3)
                { }
                column(Base_AmountVatReverse3_Control65; VATEntry.Base + AmountVatReverse3)
                { }
                column(Additional_Currency_Base__TotalBaseImport_Control33; VATEntry."Additional-Currency Base" - TotalBaseImport)
                { }
                column(AmountVatReverse3_Control34; AmountVatReverse3)
                { }
                column(Additional_Currency_Base__AmountVatReverse3_Control35; VATEntry."Additional-Currency Base" + AmountVatReverse3)
                { }
                column(Base_Base2__TotalBaseImport_Control131; (VATEntry.Base + Base2) - TotalBaseImport)
                { }
                column(AmountVatReverse3_Amount2_Control132; AmountVatReverse3 + Amount2)
                { }
                column(Base_Base2___AmountVatReverse3_Amount2__Control133; (VATEntry.Base + Base2) + (AmountVatReverse3 + Amount2))
                { }
                column(Additional_Currency_Base__TotalBaseImport_Control135; VATEntry."Additional-Currency Base" - TotalBaseImport)
                { }
                column(AmountVatReverse3_Control136; AmountVatReverse3)
                { }
                column(Additional_Currency_Base__AmountVatReverse3_Control137; VATEntry."Additional-Currency Base" + AmountVatReverse3)
                { }
                column(Base_Base2__TotalBaseImport_Control57; (VATEntry.Base + Base2) - TotalBaseImport)
                { }
                column(AmountVatReverse_Amount2; AmountVatReverse + Amount2)
                { }
                column(Base_Base2___AmountVatReverse_Amount2_; (VATEntry.Base + Base2) + (AmountVatReverse + Amount2))
                { }
                column(Additional_Currency_Base__Base2__TotalBaseImport_Control124; (VATEntry."Additional-Currency Base" + Base2) - TotalBaseImport)
                { }
                column(AmountVatReverse___Amount2; AmountVatReverse + Amount2)
                { }
                column(Additional_Currency_Base__Base2___AmountVatReverse_Amount2_; (VATEntry."Additional-Currency Base" + Base2) + (AmountVatReverse + Amount2))
                { }
                column(VATEntry_Entry_No_; VATEntry."Entry No.")
                { }
                column(VATEntry_Type; VATEntry.Type)
                { }
                column(VATEntry_Posting_Date; VATEntry."Posting Date")
                { }
                column(VATEntry_Document_Type; VATEntry."Document Type")
                { }
                column(VATEntry_Document_No_; VATEntry."Document No.")
                { }
                column(ContinuedCaption; ContinuedCaptionLbl)
                { }
                column(ContinuedCaption_Control28; ContinuedCaption_Control28Lbl)
                { }
                column(ContinuedCaption_Control48; ContinuedCaption_Control48Lbl)
                { }
                column(ContinuedCaption_Control49; ContinuedCaption_Control49Lbl)
                { }
                column(VATEntry__No__Series_Caption; VATEntry.FieldCaption(VATEntry."No. Series"))
                { }
                column(VATEntry__No__Series__Control75Caption; VATEntry.FieldCaption(VATEntry."No. Series"))
                { }
                column(TotalCaption_Control77; TotalCaption_Control77Lbl)
                { }
                column(TotalCaption_Control78; TotalCaption_Control78Lbl)
                { }
                column(VATEntry__No__Series__Control80Caption; VATEntry.FieldCaption(VATEntry."No. Series"))
                { }
                column(ContinuedCaption_Control18; ContinuedCaption_Control18Lbl)
                { }
                column(ContinuedCaption_Control32; ContinuedCaption_Control32Lbl)
                { }
                column(ContinuedCaption_Control130; ContinuedCaption_Control130Lbl)
                { }
                column(ContinuedCaption_Control134; ContinuedCaption_Control134Lbl)
                { }
                column(TotalCaption_Control54; TotalCaption_Control54Lbl)
                { }
                column(TotalCaption_Control127; TotalCaption_Control127Lbl)
                { }
                dataitem(VATEntry6; "VAT Entry")
                {
                    DataItemTableView = sorting(Type, "Posting Date", "Document Type", "Document No.", "Bill-to/Pay-to No.") where(Type = const(Purchase));

                    column(ReportForNavId_7035; 7035)
                    { }
                    column(VATEntry6_Entry_No_; VATEntry6."Entry No.")
                    { }
                    column(VATEntry6_Type; VATEntry6.Type)
                    { }
                    column(VATEntry6_Posting_Date; VATEntry6."Posting Date")
                    { }
                    column(VATEntry6_Document_Date; VATEntry6."Document Date")
                    { }
                    column(VATEntry6_Document_Type; VATEntry6."Document Type")
                    { }
                    column(VATEntry6_Document_No_; VATEntry6."Document No.")
                    { }
                    dataitem(VATEntry7; "VAT Entry")
                    {
                        DataItemLink = Type = field(Type), "Posting Date" = field("Posting Date"), "Document Type" = field("Document Type"), "Document No." = field("Document No.");
                        DataItemTableView = sorting(Type, "Posting Date", "Document Type", "Document No.", "Bill-to/Pay-to No.");

                        column(ReportForNavId_1904; 1904)
                        { }
                        trigger OnAfterGetRecord()
                        begin
                            VATBuffer3."VAT %" := VATEntry7."VAT %";
                            VATBuffer3."EC %" := VATEntry7."EC %";
                            if VATEntry7."VAT Calculation Type" = VATEntry7."vat calculation type"::"Reverse Charge VAT" then begin
                                if not PrintAmountsInAddCurrency then
                                    if VATBuffer3.Find then begin
                                        VATBuffer3.Base := VATBuffer3.Base + VATEntry7.Base;
                                        VATBuffer3.Amount := VATBuffer3.Amount + VATEntry7.Amount;
                                        VATBuffer3.Modify;
                                    end
                                    else begin
                                        VATBuffer3.Base := VATEntry7.Base;
                                        VATBuffer3.Amount := VATEntry7.Amount;
                                        VATBuffer3.Insert;
                                    end
                                else if VATBuffer3.Find then begin
                                    VATBuffer3.Base := VATBuffer3.Base + VATEntry7."Additional-Currency Base";
                                    VATBuffer3.Amount := VATBuffer3.Amount + VATEntry7."Additional-Currency Amount";
                                    VATBuffer3.Modify;
                                end
                                else begin
                                    VATBuffer3.Base := VATEntry7."Additional-Currency Base";
                                    VATBuffer3.Amount := VATEntry7."Additional-Currency Amount";
                                    VATBuffer3.Insert;
                                end
                            end;
                            if VATEntry7."VAT Calculation Type" = VATEntry7."vat calculation type"::"Reverse Charge VAT" then begin
                                NotBaseReverse := NotBaseReverse + VATBuffer3.Base;
                                NotAmountReverse := NotAmountReverse + VATBuffer3.Amount;
                            end;
                        end;

                        trigger OnPostDataItem()
                        begin
                            VATEntry6 := VATEntry7;
                        end;

                        trigger OnPreDataItem()
                        begin
                            Clear(PurchCrMemoHeader);
                            Clear(PurchInvHeader);
                            Clear(Vendor);
                            PurchInvHeader.Reset;
                            PurchCrMemoHeader.Reset;
                            Vendor.Reset;
                            VendLedgEntry.SetCurrentkey("Document No.", "Document Type", "Vendor No.");
                            case VATEntry6."Document Type" of
                                VATEntry7."document type"::"Credit Memo":
                                    if PurchCrMemoHeader.Get(VATEntry6."Document No.") then begin
                                        Vendor.Name := PurchCrMemoHeader."Pay-to Name";
                                        Vendor."VAT Registration No." := PurchCrMemoHeader."VAT Registration No.";
                                        VendLedgEntry.SetRange("Document No.", VATEntry6."Document No.");
                                        VendLedgEntry.SetRange("Document Type", VATEntry7."document type"::"Credit Memo");
                                        if VendLedgEntry.FindFirst then AutoDocNo := VendLedgEntry."Autodocument No.";
                                        exit;
                                    end;
                                VATEntry7."document type"::Invoice:
                                    if PurchInvHeader.Get(VATEntry6."Document No.") then begin
                                        Vendor.Name := PurchInvHeader."Pay-to Name";
                                        Vendor."VAT Registration No." := PurchInvHeader."VAT Registration No.";
                                        VendLedgEntry.SetRange("Document No.", VATEntry6."Document No.");
                                        VendLedgEntry.SetRange("Document Type", VATEntry7."document type"::Invoice);
                                        if VendLedgEntry.FindFirst then AutoDocNo := VendLedgEntry."Autodocument No.";
                                        exit;
                                    end;
                            end;
                            if not Vendor.Get(VATEntry6."Bill-to/Pay-to No.") then Vendor.Name := Text1100003;
                            VendLedgEntry.SetCurrentkey("Document No.", "Document Type", "Vendor No.");
                            VendLedgEntry.SetRange("Document No.", VATEntry6."Document No.");
                            VendLedgEntry.SetFilter("Document Type", Text1100004);
                            if VendLedgEntry.FindFirst then;
                        end;
                    }
                    dataitem("<Integer4>"; "Integer")
                    {
                        DataItemTableView = sorting(Number);

                        column(ReportForNavId_6868; 6868)
                        { }
                        column(VATBuffer4_Base_VATBuffer4_Amount; VATBuffer4.Base + VATBuffer4.Amount)
                        { }
                        column(VATBuffer4_Amount; VATBuffer4.Amount)
                        { }
                        column(VATBuffer4_Base; VATBuffer4.Base)
                        { }
                        column(CompanyInfo_Name; CompanyInfo.Name)
                        { }
                        column(VATEntry7__Document_No__; VATEntry7."Document No.")
                        { }
                        column(VATEntry7__Posting_Date_; Format(VATEntry7."Posting Date"))
                        { }
                        column(VATEntry7__Document_Date_; Format(VATEntry7."Document Date"))
                        { }
                        column(AutoDocNo; AutoDocNo)
                        { }
                        column(DocType; DocType)
                        { }
                        column(CompanyInfo__VAT_Registration_No__; CompanyInfo."VAT Registration No.")
                        { }
                        column(VATBuffer4__VAT___; VATBuffer4."VAT %")
                        { }
                        column(VATBuffer4__EC___; VATBuffer4."EC %")
                        { }
                        column(FORMAT_VATEntry7__Document_Date__; Format(VATEntry7."Document Date"))
                        { }
                        column(VATBuffer4_Base_VATBuffer4_Amount_Control43; VATBuffer4.Base + VATBuffer4.Amount)
                        { }
                        column(VATBuffer4_Amount_Control44; VATBuffer4.Amount)
                        { }
                        column(VATBuffer4_Base_Control47; VATBuffer4.Base)
                        { }
                        column(VATBuffer4__VAT____Control10; VATBuffer4."VAT %")
                        { }
                        column(VATBuffer4__EC____Control19; VATBuffer4."EC %")
                        { }
                        column(Integer4__Number; "<Integer4>".Number)
                        { }
                        trigger OnAfterGetRecord()
                        begin
                            if Fin then CurrReport.Break;
                            VATBuffer4 := VATBuffer3;
                            Fin := VATBuffer3.Next = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            VATBuffer3.Find('-');
                            //>> BBT. CreateTotals. Marcada como obsoleta. 
                            //CurrReport.CreateTotals(VATBuffer4.Base, VATBuffer4.Amount);
                            //<<
                            Fin := false;
                            LineNo := 0;
                        end;
                    }
                    trigger OnAfterGetRecord()
                    begin
                        if not Show then CurrReport.Break;
                        VATBuffer3.DeleteAll;
                        NoSeriesAuxPrev := NoSeriesAux;
                        if VATEntry6."Document Type" = VATEntry6."document type"::"Credit Memo" then begin
                            GLSetup.Get;
                            NoSeriesAux := GLSetup."Autocredit Memo Nos.";
                        end;
                        if VATEntry6."Document Type" = VATEntry6."document type"::Invoice then begin
                            GLSetup.Get;
                            NoSeriesAux := GLSetup."Autoinvoice Nos.";
                        end;
                        if NoSeriesAux <> NoSeriesAuxPrev then begin
                            NotBaseReverse := 0;
                            NotAmountReverse := 0;
                        end;
                    end;

                    trigger OnPostDataItem()
                    begin
                        PrevData := VATEntry."Posting Date" + 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not SortPostDate or not ShowAutoInvCred then CurrReport.Break;
                        VATEntry6.SetRange(VATEntry6."Generated Autodocument", true);
                        if VATEntry6.Find('-') then;
                        if i = 1 then begin
                            repeat
                                VatEntryTemporary.Init;
                                VatEntryTemporary.Copy(VATEntry6);
                                VatEntryTemporary.Insert;
                                VatEntryTemporary.Next;
                            until VATEntry6.Next = 0;
                            if VATEntry6.Find('-') then;
                            i := 0;
                        end;
                        VATEntry6.SetFilter(VATEntry6."Posting Date", '%1..%2', PrevData, VATEntry."Posting Date");
                        VATEntry6.SetFilter(VATEntry6."Document No.", VATEntry.GetFilter("Document No."));
                        VATEntry6.SetFilter(VATEntry6."Document Type", VATEntry.GetFilter("Document Type"));
                        if VatEntryTemporary.Find('-') then;
                        VatEntryTemporary.SetRange("Generated Autodocument", true);
                        VatEntryTemporary.SetFilter("Posting Date", '%1..%2', PrevData, VATEntry."Posting Date");
                        if VatEntryTemporary.Find('-') then begin
                            Show := true;
                            VatEntryTemporary.DeleteAll;
                        end
                        else
                            Show := false;
                    end;
                }
                dataitem(VATEntry2; "VAT Entry")
                {
                    DataItemLink = Type = field(Type), "Posting Date" = field("Posting Date"), "Document Type" = field("Document Type"), "Document No." = field("Document No.");
                    DataItemTableView = sorting("No. Series", "Posting Date");

                    column(ReportForNavId_8013; 8013)
                    { }
                    trigger OnAfterGetRecord()
                    begin
                        if ShowAutoInvCred and (VATEntry2."VAT Calculation Type" = VATEntry2."vat calculation type"::"Reverse Charge VAT") then begin
                            VATBuffer."VAT %" := 0;
                            VATBuffer."EC %" := 0;
                        end
                        else begin
                            VATBuffer."VAT %" := VATEntry2."VAT %";
                            VATBuffer."EC %" := VATEntry2."EC %";
                        end;
                        if not PrintAmountsInAddCurrency then begin
                            if VATEntry2."VAT Calculation Type" = VATEntry2."vat calculation type"::"Full VAT" then VATEntry2.Base := 0;
                            if VATBuffer.Find then begin
                                VATBuffer.Base := VATBuffer.Base + VATEntry2.Base;
                                if VATEntry2."VAT Calculation Type" = VATEntry2."vat calculation type"::"Full VAT" then BaseImport := BaseImport + VATEntry2.Base;
                                if (not ShowAutoInvCred) or (VATEntry2."VAT Calculation Type" <> VATEntry2."vat calculation type"::"Reverse Charge VAT") then begin
                                    VATBuffer.Amount := VATBuffer.Amount + VATEntry2.Amount;
                                    AmountVatReverse := AmountVatReverse + VATEntry2.Amount;
                                end;
                                VATBuffer.Modify;
                            end
                            else begin
                                VATBuffer.Base := VATEntry2.Base;
                                if VATEntry2."VAT Calculation Type" = VATEntry2."vat calculation type"::"Full VAT" then BaseImport := VATEntry2.Base;
                                if (not ShowAutoInvCred) or (VATEntry2."VAT Calculation Type" <> VATEntry2."vat calculation type"::"Reverse Charge VAT") then begin
                                    VATBuffer.Amount := VATEntry2.Amount;
                                    AmountVatReverse := AmountVatReverse + VATEntry2.Amount;
                                end
                                else
                                    VATBuffer.Amount := 0;
                                VATBuffer.Insert;
                            end;
                        end
                        else begin
                            if VATEntry2."VAT Calculation Type" = VATEntry2."vat calculation type"::"Full VAT" then VATEntry2."Additional-Currency Base" := 0;
                            if VATBuffer.Find then begin
                                VATBuffer.Base := VATBuffer.Base + VATEntry2."Additional-Currency Base";
                                if VATEntry2."VAT Calculation Type" = VATEntry2."vat calculation type"::"Full VAT" then BaseImport := BaseImport + VATEntry2."Additional-Currency Base";
                                if (not ShowAutoInvCred) or (VATEntry2."VAT Calculation Type" <> VATEntry2."vat calculation type"::"Reverse Charge VAT") then begin
                                    VATBuffer.Amount := VATBuffer.Amount + VATEntry2."Additional-Currency Amount";
                                    AmountVatReverse := AmountVatReverse + VATEntry2."Additional-Currency Amount";
                                end;
                                VATBuffer.Modify;
                            end
                            else begin
                                VATBuffer.Base := VATEntry2."Additional-Currency Base";
                                if VATEntry2."VAT Calculation Type" = VATEntry2."vat calculation type"::"Full VAT" then BaseImport := VATEntry2."Additional-Currency Base";
                                if (not ShowAutoInvCred) or (VATEntry2."VAT Calculation Type" <> VATEntry2."vat calculation type"::"Reverse Charge VAT") then begin
                                    VATBuffer.Amount := VATEntry2."Additional-Currency Amount";
                                    AmountVatReverse := AmountVatReverse + VATEntry2."Additional-Currency Amount";
                                end
                                else
                                    VATBuffer.Amount := 0;
                                VATBuffer.Insert;
                            end;
                        end;
                        if VATEntry2."VAT Calculation Type" = VATEntry2."vat calculation type"::"Full VAT" then TotalBaseImport := TotalBaseImport + BaseImport;
                        TempVATEntry := VATEntry2;
                        if not TempVATEntry.Find then TempVATEntry.Insert;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if SortPostDate then
                            VATEntry2.SetCurrentkey(VATEntry2.Type, VATEntry2."Posting Date", VATEntry2."Document Type", VATEntry2."Document No.", VATEntry2."Bill-to/Pay-to No.")
                        else
                            VATEntry2.SetCurrentkey(VATEntry2."No. Series", VATEntry2."Posting Date");
                        VATEntry2.SetRange(VATEntry2."No. Series", VATEntry."No. Series");
                        Clear(PurchCrMemoHeader);
                        Clear(PurchInvHeader);
                        Clear(Vendor);
                        if not PrintAmountsInAddCurrency then
                            GLSetup.Get
                        else begin
                            GLSetup.Get;
                            Currency.Get(GLSetup."Additional Reporting Currency");
                        end;
                        case VATEntry."Document Type" of
                            VATEntry2."document type"::"Credit Memo":
                                if PurchCrMemoHeader.Get(VATEntry."Document No.") then begin
                                    Vendor.Name := PurchCrMemoHeader."Pay-to Name";
                                    Vendor."VAT Registration No." := PurchCrMemoHeader."VAT Registration No.";
                                    exit;
                                end;
                            VATEntry2."document type"::Invoice:
                                if PurchInvHeader.Get(VATEntry."Document No.") then begin
                                    Vendor.Name := PurchInvHeader."Pay-to Name";
                                    Vendor."VAT Registration No." := PurchInvHeader."VAT Registration No.";
                                    exit;
                                end;
                        end;
                        if not Vendor.Get(VATEntry."Bill-to/Pay-to No.") then Vendor.Name := Text1100003;
                    end;
                }
                dataitem("Integer"; "Integer")
                {
                    DataItemTableView = sorting(Number);

                    column(ReportForNavId_5444; 5444)
                    { }
                    column(VATEntry2__Document_No__; VATEntry2."Document No.")
                    { }
                    column(VATBuffer2_Base; VATBuffer2.Base)
                    { }
                    column(VATEntry2__Posting_Date_; Format(VATEntry2."Posting Date"))
                    { }
                    column(VATEntry2__Document_Date_; Format(VATEntry2."Document Date"))
                    { }
                    column(Vendor_Name; Vendor.Name)
                    { }
                    column(DocType_Control11; DocType)
                    { }
                    column(VATBuffer2_Amount; VATBuffer2.Amount)
                    { }
                    column(VATBuffer2_Base_VATBuffer2_Amount; VATBuffer2.Base + VATBuffer2.Amount)
                    { }
                    column(VATEntry2__External_Document_No__; VATEntry2."External Document No.")
                    { }
                    column(Vendor__VAT_Registration_No__; Vendor."VAT Registration No.")
                    { }
                    column(VATBuffer2__VAT___; VATBuffer2."VAT %")
                    { }
                    column(VATBuffer2__EC___; VATBuffer2."EC %")
                    { }
                    column(FORMAT_VATEntry2__Document_Date__; Format(VATEntry2."Document Date"))
                    { }
                    column(VATBuffer2_Base_VATBuffer2_Amount_Control53; VATBuffer2.Base + VATBuffer2.Amount)
                    { }
                    column(VATBuffer2_Amount_Control58; VATBuffer2.Amount)
                    { }
                    column(VATBuffer2_Base_Control61; VATBuffer2.Base)
                    { }
                    column(VATBuffer2__VAT____Control59; VATBuffer2."VAT %")
                    { }
                    column(VATBuffer2__EC____Control60; VATBuffer2."EC %")
                    { }
                    column(VATBuffer2_Base_Control62; VATBuffer2.Base)
                    { }
                    column(VATBuffer2_Amount_Control63; VATBuffer2.Amount)
                    { }
                    column(VATBuffer2_Base_VATBuffer2_Amount_Control64; VATBuffer2.Base + VATBuffer2.Amount)
                    { }
                    column(Integer_Number; Integer.Number)
                    { }
                    column(TotalCaption_Control26; TotalCaption_Control26Lbl)
                    { }
                    trigger OnAfterGetRecord()
                    begin
                        if Fin then CurrReport.Break;
                        VATBuffer2 := VATBuffer;
                        Fin := VATBuffer.Next = 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        VATBuffer.Find('-');
                        //>> BBT. CreateTotals. Marcada como obsoleta. 
                        //CurrReport.CreateTotals(VATBuffer2.Base, VATBuffer2.Amount);
                        //<<
                        Fin := false;
                        LineNo := 0;
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    VATBuffer.DeleteAll;
                    TempVATEntry := VATEntry;
                    if TempVATEntry.Find then CurrReport.Skip;
                    AmountVatReverse3 := AmountVatReverse;
                    DocType := Format(VATEntry."Document Type");
                    if VATEntry."Document Type" = VATEntry."document type"::"Credit Memo" then DocType := Text1100005;
                end;

                trigger OnPreDataItem()
                begin
                    if VATEntry.GetFilter(VATEntry."Posting Date") = '' then
                        PrevData := 0D
                    else
                        PrevData := VATEntry.GetRangeMin(VATEntry."Posting Date");
                    i := 1;
                    if SortPostDate then
                        VATEntry.SetCurrentkey(VATEntry.Type, VATEntry."Posting Date", VATEntry."Document Type", VATEntry."Document No.", VATEntry."Bill-to/Pay-to No.")
                    else
                        VATEntry.SetCurrentkey(VATEntry."No. Series", VATEntry."Posting Date", VATEntry."Document No.");
                    TempVATEntry.Reset;
                    TempVATEntry.DeleteAll;
                end;
            }
            dataitem(VATEntry3; "VAT Entry")
            {
                DataItemTableView = sorting("Document Type", "No. Series", "Posting Date") where(Type = const(Purchase));

                column(ReportForNavId_7061; 7061)
                { }
                column(VarNotAmountReverse; VarNotAmountReverse)
                { }
                column(VarNotBaseReverse; VarNotBaseReverse)
                { }
                column(VarNotBaseReverse_VarNotAmountReverse; VarNotBaseReverse + VarNotAmountReverse)
                { }
                column(No_SeriesAux_; NoSeriesAux)
                { }
                column(No_SeriesAux__Control107; NoSeriesAux)
                { }
                column(NotBaseReverse; NotBaseReverse)
                { }
                column(NotAmountReverse; NotAmountReverse)
                { }
                column(NotBaseReverse_NotAmountReverse; NotBaseReverse + NotAmountReverse)
                { }
                column(VarNotBaseReverse_Control120; VarNotBaseReverse)
                { }
                column(VarNotAmountReverse_Control156; VarNotAmountReverse)
                { }
                column(VarNotBaseReverse_VarNotAmountReverse_Control159; VarNotBaseReverse + VarNotAmountReverse)
                { }
                column(VATEntry3_Entry_No_; VATEntry3."Entry No.")
                { }
                column(VATEntry3_Document_Type; VATEntry3."Document Type")
                { }
                column(VATEntry3_Type; VATEntry3.Type)
                { }
                column(VATEntry3_Posting_Date; VATEntry3."Posting Date")
                { }
                column(VATEntry3_Document_No_; VATEntry3."Document No.")
                { }
                column(ContinuedCaption_Control103; ContinuedCaption_Control103Lbl)
                { }
                column(No_SerieCaption; No_SerieCaptionLbl)
                { }
                column(TotalCaption_Control96; TotalCaption_Control96Lbl)
                { }
                column(No_SerieCaption_Control97; No_SerieCaption_Control97Lbl)
                { }
                column(ContinuedCaption_Control119; ContinuedCaption_Control119Lbl)
                { }
                dataitem(VATEntry4; "VAT Entry")
                {
                    DataItemLink = Type = field(Type), "Posting Date" = field("Posting Date"), "Document Type" = field("Document Type"), "Document No." = field("Document No.");
                    DataItemTableView = sorting("No. Series", "Posting Date");

                    column(ReportForNavId_3078; 3078)
                    { }
                    column(VATEntry4_Type; VATEntry4.Type)
                    { }
                    column(VATEntry4_Entry_No_; VATEntry4."Entry No.")
                    { }
                    column(VATEntry4_Posting_Date; VATEntry4."Posting Date")
                    { }
                    column(VATEntry4_Document_Date; VATEntry4."Document Date")
                    { }
                    column(VATEntry4_Document_Type; VATEntry4."Document Type")
                    { }
                    column(VATEntry4_Document_No_; VATEntry4."Document No.")
                    { }
                    trigger OnAfterGetRecord()
                    begin
                        VATBuffer."VAT %" := VATEntry4."VAT %";
                        VATBuffer."EC %" := VATEntry4."EC %";
                        if VATEntry4."VAT Calculation Type" = VATEntry4."vat calculation type"::"Reverse Charge VAT" then begin
                            if not PrintAmountsInAddCurrency then
                                if VATBuffer.Find then begin
                                    VarBase2 := (VATBuffer.Base + VATEntry4.Base) - VATBuffer.Base;
                                    VarAmount2 := (VATBuffer.Amount + VATEntry4.Amount) - VATBuffer.Amount;
                                    VATBuffer.Base := VATBuffer.Base + VATEntry4.Base;
                                    VATBuffer.Amount := VATBuffer.Amount + VATEntry4.Amount;
                                    VATBuffer.Modify;
                                end
                                else begin
                                    VarBase2 := VATEntry4.Base;
                                    VarAmount2 := VATEntry4.Amount;
                                    VATBuffer.Base := VATEntry4.Base;
                                    VATBuffer.Amount := VATEntry4.Amount;
                                    VATBuffer.Insert;
                                end
                            else if VATBuffer.Find then begin
                                VATBuffer.Base := VATBuffer.Base + VATEntry4."Additional-Currency Base";
                                VATBuffer.Amount := VATBuffer.Amount + VATEntry4."Additional-Currency Amount";
                                VATBuffer.Modify;
                            end
                            else begin
                                VATBuffer.Base := VATEntry4."Additional-Currency Base";
                                VATBuffer.Amount := VATEntry4."Additional-Currency Amount";
                                VATBuffer.Insert;
                            end
                        end;
                        if VATEntry4."VAT Calculation Type" = VATEntry4."vat calculation type"::"Reverse Charge VAT" then begin
                            if not PrintAmountsInAddCurrency then begin
                                NotBaseReverse := NotBaseReverse + VarBase2;
                                NotAmountReverse := NotAmountReverse + VarAmount2;
                            end
                            else begin
                                NotBaseReverse := NotBaseReverse + VATBuffer.Base;
                                NotAmountReverse := NotAmountReverse + VATBuffer.Amount;
                            end;
                        end;
                    end;

                    trigger OnPostDataItem()
                    begin
                        VATEntry3 := VATEntry4;
                    end;

                    trigger OnPreDataItem()
                    begin
                        Clear(PurchCrMemoHeader);
                        Clear(PurchInvHeader);
                        Clear(Vendor);
                        PurchInvHeader.Reset;
                        PurchCrMemoHeader.Reset;
                        Vendor.Reset;
                        VendLedgEntry.SetCurrentkey("Document No.", "Document Type", "Vendor No.");
                        case VATEntry3."Document Type" of
                            VATEntry4."document type"::"Credit Memo":
                                if PurchCrMemoHeader.Get(VATEntry3."Document No.") then begin
                                    Vendor.Name := PurchCrMemoHeader."Pay-to Name";
                                    Vendor."VAT Registration No." := PurchCrMemoHeader."VAT Registration No.";
                                    VendLedgEntry.SetRange("Document No.", VATEntry3."Document No.");
                                    VendLedgEntry.SetRange("Document Type", VATEntry4."document type"::"Credit Memo");
                                    if VendLedgEntry.FindFirst then AutoDocNo := VendLedgEntry."Autodocument No.";
                                    exit;
                                end;
                            VATEntry4."document type"::Invoice:
                                if PurchInvHeader.Get(VATEntry3."Document No.") then begin
                                    Vendor.Name := PurchInvHeader."Pay-to Name";
                                    Vendor."VAT Registration No." := PurchInvHeader."VAT Registration No.";
                                    VendLedgEntry.SetRange("Document No.", VATEntry3."Document No.");
                                    VendLedgEntry.SetRange("Document Type", VATEntry4."document type"::Invoice);
                                    if VendLedgEntry.FindFirst then AutoDocNo := VendLedgEntry."Autodocument No.";
                                    exit;
                                end;
                        end;
                        if not Vendor.Get(VATEntry3."Bill-to/Pay-to No.") then Vendor.Name := Text1100003;
                        VendLedgEntry.SetCurrentkey("Document No.", "Document Type", "Vendor No.");
                        VendLedgEntry.SetRange("Document No.", VATEntry3."Document No.");
                        VendLedgEntry.SetFilter("Document Type", Text1100004);
                        if VendLedgEntry.FindFirst then;
                    end;
                }
                dataitem("<Integer2>"; "Integer")
                {
                    DataItemTableView = sorting(Number);

                    column(ReportForNavId_9601; 9601)
                    { }
                    column(VATBuffer2_Base_VATBuffer2_Amount_Control81; VATBuffer2.Base + VATBuffer2.Amount)
                    { }
                    column(VATBuffer2_Amount_Control82; VATBuffer2.Amount)
                    { }
                    column(VATBuffer2__EC____Control83; VATBuffer2."EC %")
                    { }
                    column(VATBuffer2__VAT____Control87; VATBuffer2."VAT %")
                    { }
                    column(VATBuffer2_Base_Control88; VATBuffer2.Base)
                    { }
                    column(CompanyInfo__VAT_Registration_No___Control89; CompanyInfo."VAT Registration No.")
                    { }
                    column(CompanyInfo_Name_Control90; CompanyInfo.Name)
                    { }
                    column(VATEntry4__Document_No__; VATEntry4."Document No.")
                    { }
                    column(VATEntry4__Document_Type_; VATEntry4."Document Type")
                    { }
                    column(AutoDocNo_Control93; AutoDocNo)
                    { }
                    column(VATEntry4__Posting_Date_; Format(VATEntry4."Posting Date"))
                    { }
                    column(FORMAT_VATEntry4__Document_Date__; Format(VATEntry4."Document Date"))
                    { }
                    column(VATBuffer2_Base_Control98; VATBuffer2.Base)
                    { }
                    column(VATBuffer2__VAT____Control99; VATBuffer2."VAT %")
                    { }
                    column(VATBuffer2__EC____Control100; VATBuffer2."EC %")
                    { }
                    column(VATBuffer2_Amount_Control101; VATBuffer2.Amount)
                    { }
                    column(VATBuffer2_Base_VATBuffer2_Amount_Control102; VATBuffer2.Base + VATBuffer2.Amount)
                    { }
                    column(VATBuffer2_Base_Control22; VATBuffer2.Base)
                    { }
                    column(VATBuffer2_Amount_Control24; VATBuffer2.Amount)
                    { }
                    column(VATBuffer2_Base_VATBuffer2_Amount_Control27; VATBuffer2.Base + VATBuffer2.Amount)
                    { }
                    column(Integer2__Number; "<Integer2>".Number)
                    { }
                    column(TotalCaption_Control21; TotalCaption_Control21Lbl)
                    { }
                    trigger OnAfterGetRecord()
                    begin
                        if Fin then CurrReport.Break;
                        VATBuffer2 := VATBuffer;
                        Fin := VATBuffer.Next = 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        VATBuffer.Find('-');
                        //>> BBT. CreateTotals. Marcada como obsoleta. 
                        //CurrReport.CreateTotals(VATBuffer2.Base, VATBuffer2.Amount);
                        //
                        Fin := false;
                        LineNo := 0;
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    VATBuffer.DeleteAll;
                    NoSeriesAuxPrev := NoSeriesAux;
                    if VATEntry3."Document Type" = VATEntry3."document type"::"Credit Memo" then begin
                        GLSetup.Get;
                        NoSeriesAux := GLSetup."Autocredit Memo Nos.";
                    end;
                    if VATEntry3."Document Type" = VATEntry3."document type"::Invoice then begin
                        GLSetup.Get;
                        NoSeriesAux := GLSetup."Autoinvoice Nos.";
                    end;
                    if NoSeriesAux <> NoSeriesAuxPrev then begin
                        NotBaseReverse := 0;
                        NotAmountReverse := 0;
                        VarNotBaseReverse := 0;
                        VarNotAmountReverse := 0;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if SortPostDate or not ShowAutoInvCred then CurrReport.Break;
                    VATEntry3.SetRange(VATEntry3."Generated Autodocument", true);
                    if VATEntry3.Find('-') then;
                    VATEntry3.SetFilter(VATEntry3."Posting Date", VATEntry.GetFilter("Posting Date"));
                    VATEntry3.SetFilter(VATEntry3."Document No.", VATEntry.GetFilter("Document No."));
                    VATEntry3.SetFilter(VATEntry3."Document Type", VATEntry.GetFilter("Document Type"));
                    NotBaseReverse := 0;
                    NotAmountReverse := 0;
                end;
            }
            trigger OnPreDataItem()
            begin
                GLSetup.Get;
                if PrintAmountsInAddCurrency then
                    HeaderText := StrSubstNo(Text1100002, GLSetup."Additional Reporting Currency")
                else begin
                    GLSetup.TestField("LCY Code");
                    HeaderText := StrSubstNo(Text1100002, GLSetup."LCY Code");
                end;
                CompanyInfo.Get;
                CompanyAddr[1] := CompanyInfo.Name;
                CompanyAddr[2] := CompanyInfo."Name 2";
                CompanyAddr[3] := CompanyInfo.Address;
                CompanyAddr[4] := CompanyInfo."Address 2";
                CompanyAddr[5] := CompanyInfo.City;
                CompanyAddr[6] := CompanyInfo."Post Code" + ' ' + CompanyInfo.County;
                if CompanyInfo."VAT Registration No." <> '' then
                    CompanyAddr[7] := Text1100000 + CompanyInfo."VAT Registration No."
                else
                    Error(Text1100001);
                CompressArray(CompanyAddr);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', comment = 'ESP="Opciones"';

                    field(PrintAmountsInAddCurrency; PrintAmountsInAddCurrency)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Amounts in Add. Currency', comment = 'ESP="Muestra importes en divisa adicional"';
                    }
                    field(SortPostDate; SortPostDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Order by posting date', comment = 'ESP="Ordena por fecha regis."';
                    }
                    field(ShowAutoInvCred; ShowAutoInvCred)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Autoinvoices/Autocr. memo', comment = 'ESP="Muestra autofacturas/autoabonos"';
                    }
                }
            }
        }
        actions
        {
        }
        trigger OnOpenPage()
        begin
            ShowAutoInvCred := false;
        end;
    }
    labels
    { }

    trigger OnPreReport()
    begin
        AuxVatEntry := VATEntry.GetFilters;
        MaxLines := 52;
    end;

    var
        Text1100000: label 'VAT Registration No.: ', comment = 'ESP="CIF/NIF "';
        Text1100001: label 'Please, specify the VAT Registration Nº of your Company in the Company information Window', comment = 'ESP="Especifique el CIF/NIF de su empresa en la ventana Información empresa"';
        Text1100002: label 'All Amounts are in %1', comment = 'ESP="Importes en %1"';
        Text1100003: label 'UNKNOWN', comment = 'ESP="DESCONOCIDO"';
        Text1100004: label 'Invoice|Credit Memo', comment = 'ESP="Factura|Abono"';
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        Vendor: Record Vendor;
        CompanyInfo: Record "Company Information";
        VATBuffer: Record "Sales/Purch. Book VAT Buffer" temporary;
        VATBuffer2: Record "Sales/Purch. Book VAT Buffer";
        VATBuffer3: Record "Sales/Purch. Book VAT Buffer" temporary;
        VATBuffer4: Record "Sales/Purch. Book VAT Buffer" temporary;
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        VendLedgEntry: Record "Vendor Ledger Entry";
        VatEntryTemporary: Record "VAT Entry" temporary;
        HeaderText: Text[250];
        CompanyAddr: array[7] of Text[50];
        LineNo: Decimal;
        Fin: Boolean;
        PrintAmountsInAddCurrency: Boolean;
        NoSeriesAux: Code[20];
        AutoDocNo: Code[20];
        AmountVatReverse: Decimal;
        NotBaseReverse: Decimal;
        NotAmountReverse: Decimal;
        NoSeriesAuxPrev: Code[20];
        AuxVatEntry: Text[250];
        SortPostDate: Boolean;
        Show: Boolean;
        i: Integer;
        PrevData: Date;
        Base2: Decimal;
        Amount2: Decimal;
        ShowAutoInvCred: Boolean;
        VarBase2: Decimal;
        VarAmount2: Decimal;
        VarNotBaseReverse: Decimal;
        VarNotAmountReverse: Decimal;
        AmountVatReverse3: Decimal;
        BaseImport: Decimal;
        TotalBaseImport: Decimal;
        MaxLines: Integer;
        Text1100005: label 'Corrective Invoice', comment = 'ESP="Factura correctiva"';
        DocType: Text[30];
        CurrReport_PAGENOCaptionLbl: label 'Page', comment = 'ESP="Pág."';
        Purchases_Invoice_BookCaptionLbl: label 'Purchases Invoice Book', comment = 'ESP="Libro facturas recibidas"';
        TotalCaptionLbl: label 'Total', comment = 'ESP="Total"';
        AmountCaptionLbl: label 'Amount', comment = 'ESP="Importe"';
        EC_CaptionLbl: label 'EC%', comment = 'ESP="%RE"';
        VAT_CaptionLbl: label 'VAT%', comment = 'ESP="%IVA"';
        BaseCaptionLbl: label 'Base', comment = 'ESP="Base"';
        VAT_RegistrationCaptionLbl: label 'VAT Registration', comment = 'ESP="CIF/NIF"';
        NameCaptionLbl: label 'Name', comment = 'ESP="Nombre"';
        External_Document_No_CaptionLbl: label 'External Document No.', comment = 'ESP="Nº documento externo"';
        Posting_DateCaptionLbl: label 'Posting Date', comment = 'ESP="Fecha registro"';
        Document_DateCaptionLbl: label 'Document Date', comment = 'ESP="Fecha de documento"';
        Document_No_CaptionLbl: label 'Document No.', comment = 'ESP="Nº documento"';
        Epedition_DateCaptionLbl: label 'Expedition Date', comment = 'ESP="Fecha expedición"';
        ContinuedCaptionLbl: label 'Continued', comment = 'ESP="Continuación"';
        ContinuedCaption_Control28Lbl: label 'Continued', comment = 'ESP="Continuación"';
        ContinuedCaption_Control48Lbl: label 'Continued', comment = 'ESP="Continuación"';
        ContinuedCaption_Control49Lbl: label 'Continued', comment = 'ESP="Continuación"';
        TotalCaption_Control77Lbl: label 'Total', comment = 'ESP="Total"';
        TotalCaption_Control78Lbl: label 'Total', comment = 'ESP="Total"';
        ContinuedCaption_Control18Lbl: label 'Continued', comment = 'ESP="Continuación"';
        ContinuedCaption_Control32Lbl: label 'Continued', comment = 'ESP="Continuación"';
        ContinuedCaption_Control130Lbl: label 'Continued', comment = 'ESP="Continuación"';
        ContinuedCaption_Control134Lbl: label 'Continued', comment = 'ESP="Continuación"';
        TotalCaption_Control54Lbl: label 'Total', comment = 'ESP="Total"';
        TotalCaption_Control127Lbl: label 'Total', comment = 'ESP="Total"';
        TotalCaption_Control26Lbl: label 'Total', comment = 'ESP="Total"';
        ContinuedCaption_Control103Lbl: label 'Continued', comment = 'ESP="Continuación"';
        No_SerieCaptionLbl: label 'No.Serie', comment = 'ESP="Nos. serie"';
        TotalCaption_Control96Lbl: label 'Total', comment = 'ESP="Total"';
        No_SerieCaption_Control97Lbl: label 'No.Serie', comment = 'ESP="Nos. serie"';
        ContinuedCaption_Control119Lbl: label 'Continued', comment = 'ESP="Continuación"';
        TotalCaption_Control21Lbl: label 'Total', comment = 'ESP="Total"';
        TempVATEntry: Record "VAT Entry" temporary;
}
