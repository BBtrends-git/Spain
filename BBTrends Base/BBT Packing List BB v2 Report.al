Report 50045 "Packing List BB v2"
{
    // //INC-2019-02-107551 : Mostrar pie Protección de datos
    // // BBT 331012022. Tomar Pesos y Volumen de la unidad de medida del producto.
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/Packing List BB v2.rdl';
    Caption = 'Packing List', comment = 'ESP="Lista de embalaje"';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(CompanyLogo; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            column(ReportForNavId_1100234016; 1100234016)
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
            column(PackingListCaption; PackingListCaptionLbl)
            { }
            column(RegTextCaption; RegTextCaptionLbl)
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
                    column(CopyText; CopyText)
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
                    column(CompanyInfoVATRegtnNo; vatregn)
                    { }
                    column(Cust_OurAccountNo; Cust."Our Account No.")
                    { }
                    column(CompanyCountryCaption; CompanyCountryCaptionLbl)
                    { }
                    column(ExtDocNoCaption; "Sales Shipment Header".FieldCaption("External Document No."))
                    { }
                    column(ExtDocNo_SalesShptHeader; "Sales Shipment Header"."External Document No.")
                    { }
                    column(ShptDate_SalesShptHeader; Format("Sales Shipment Header"."Shipment Date"))
                    { }
                    column(ShippingAgent_Name; ShippingAgent.Name)
                    { }
                    column(OutputNo; OutputNo)
                    { }
                    column(SellCustNo; "Sales Shipment Header"."Sell-to Customer No.")
                    { }
                    column(SellCustNoCaption; SellCustCaptionLbl)
                    { }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    { }
                    column(VATRegNoCaption; VATRegNoCaptionLbl)
                    { }
                    column(ShipmentNoCaption; ShipmentNoCaptionLbl)
                    { }
                    column(ShipmentDateCaption; ShipmentDateCaptionLbl)
                    { }
                    column(ShipmentMethodCode; ShipmentMethod.Description)
                    { }
                    column(ShipmentMethodCaption; ShipmentMethodCaptionLbl)
                    { }
                    column(VendorCaption; VendorCaptionLbl)
                    { }
                    column(NpaletCaption; NpaletCaptionLbl)
                    { }
                    column(No_SalesShptLineCaption; NoCaptionLbl)
                    { }
                    column(Description_SalesShptLineCaption; "Sales Shipment Line".FieldCaption(Description))
                    { }
                    column(VendorCodeCaption; VendorCodeCaptionLbl)
                    { }
                    column(EanCodeCaption; EanCodeCaptionLbl)
                    { }
                    column(CaseCaption; CaseCaptionLbl)
                    { }
                    column(NrCasesCaption; NrCasesCaptionLbl)
                    { }
                    column(TotalUnitsCaption; TotalUnitsCaptionLbl)
                    { }
                    column(TotalShipmentCaption; TotalShipmentCaptionLbl)
                    { }
                    column(TotalPalletsCaption; TotalPalletsCaptionLbl)
                    { }
                    column(TotalPackagesCaption; TotalPackagesCaptionLbl)
                    { }
                    column(TotalWeightCaption; TotalWeightCaptionLbl)
                    { }
                    column(OurAccountNo; Cust."Our Account No.")
                    { }
                    column(OurAccountNoCaption; OurAccountNoLbl)
                    { }
                    column(ContractNoLbl; Cust."Contract No")
                    { }
                    column(ContractNoCaption; ContractNoLbl)
                    { }
                    column(ReferenceLabel; "Sales Shipment Header".Reference)
                    { }
                    column(WarehoseShipNo; ShipNo)
                    { }
                    dataitem("Sales Shipment Line"; "Sales Shipment Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = "Sales Shipment Header";
                        //DataItemTableView = sorting("Document No.", "Pallet No.", "Line No.");

                        column(ReportForNavId_2502; 2502)
                        { }
                        column(Description_SalesShptLine; "Sales Shipment Line".Description)
                        { }
                        column(Type_SalesShptLine; Format("Sales Shipment Line".Type, 0, 2))
                        { }
                        column(DocumentNo_SalesShptLine; "Sales Shipment Line"."Document No.")
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
                        column(EAN_SalesShptLine; "Sales Shipment Line"."EAN Code")
                        { }
                        column(PalleteNo_SalesShptLine; "Sales Shipment Line"."Pallet No.")
                        { }
                        column(Quantity_SalesShptLine; "Sales Shipment Line".Quantity)
                        { }
                        column(QtyCartons_SalesShptLine; QtyCartons)
                        { }
                        column(cb_SalesShptLine; CBM)
                        { }
                        column(nw_SalesShptLine; NW)
                        { }
                        column(gw_SalesShptLine; GW)
                        { }
                        column(CountryOrigin_SalesShptLine; CountryOrigin)
                        { }
                        column(CountryOriginCaption_SalesShptLine; CountryOriginLabel)
                        { }
                        column(TariffCode_Label; TariffCode)
                        { }
                        column(TariffCodeCaption_SalesShptLine; TariffCodeCaption)
                        { }
                        trigger OnAfterGetRecord()
                        begin
                            //>> BBT 331012022
                            //ItemUnitofMeasure.RESET;
                            //ItemUnitofMeasure.SETRANGE("Item No.","No.");
                            //ItemUnitofMeasure.SETRANGE(Code,'CAJA');
                            //IF ItemUnitofMeasure.FINDFIRST THEN
                            //BEGIN
                            //  QtyCartons := ROUND(Quantity/ItemUnitofMeasure."Qty. per Unit of Measure",1,'>');
                            //END ELSE QtyCartons := Quantity;
                            //
                            //Item.RESET;
                            //Item.SETRANGE("No.","No.");
                            //IF Item.FINDFIRST THEN
                            //BEGIN
                            //  CBM := ROUND(Item."Unit Volume" * "Sales Shipment Line".Quantity,0.01);
                            //  GW := ROUND(Item."Gross Weight" * "Sales Shipment Line".Quantity,0.01);
                            //  NW := ROUND(Item."Net Weight" * "Sales Shipment Line".Quantity,0.01);
                            //END;
                            Item.Reset;
                            Item.SetRange("No.", "Sales Shipment Line"."No.");
                            if Item.FindFirst then CalcWeight;
                            //<< BBT 331012022
                            if "Sales Shipment Line".Type = "Sales Shipment Line".Type::Item then begin
                                CountryOrigin := '';
                                CountryOriginLabel := '';
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

                        trigger OnPreDataItem()
                        begin
                            "Sales Shipment Line".SetFilter("Sales Shipment Line".Quantity, '>0');
                            MoreLines := "Sales Shipment Line".Find('+');
                            while MoreLines and ("Sales Shipment Line".Description = '') and ("Sales Shipment Line"."No." = '') and ("Sales Shipment Line".Quantity = 0) do MoreLines := "Sales Shipment Line".Next(-1) <> 0;
                            if not MoreLines then CurrReport.Break;
                            //SETRANGE("Line No.",0,"Line No.");
                        end;
                    }
                    trigger OnAfterGetRecord()
                    begin
                        "Sales Shipment Header".CalcFields("Warehose Ship No.");
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    if CopyLoop.Number > 1 then begin
                        CopyText := FormatDocument.GetCOPYText();
                        OutputNo += 1;
                    end;
                    //CurrReport.PageNo := 1;
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
                if ("Sales Shipment Header"."Language Code" <> '') and ("Sales Shipment Header"."Language Code" <> 'ESP') then begin
                    //ini - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.        
                    //CurrReport.Language := Language.GetLanguageID("Sales Shipment Header"."Language Code");
                    CurrReport.Language := cLanguage.GetLanguageID("Sales Shipment Header"."Language Code");
                    //fin - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.        
                end;
                if not Cust.Get("Sales Shipment Header"."Bill-to Customer No.") then Clear(Cust);
                if not ShippingAgent.Get("Sales Shipment Header"."Shipping Agent Code") then ShippingAgent.Init;
                GeneralLedgerSetup.Get;
                if Cust."VAT PL" then
                    vatregn := GeneralLedgerSetup."PolishVAT Registration No."
                else
                    vatregn := CompanyInfo."VAT Registration No.";
                ShipmentMethod.SetRange(Code, "Sales Shipment Header"."Shipment Method Code");
                if ShipmentMethod.FindFirst then;
                "Sales Shipment Header"."Ship-to Contact" := '';
                "Sales Shipment Header"."Bill-to Contact" := '';
                FormatAddr.SalesShptShipTo(ShipToAddr, "Sales Shipment Header");
                FormatAddr.SalesShptSellTo(SellToAddr, "Sales Shipment Header");
                CountryRegion.Reset;
                CountryRegion.SetRange(Code, "Sales Shipment Header"."Bill-to Country/Region Code");
                if CountryRegion.FindFirst then;
                ShipNo := '';
                "Sales Shipment Header".CalcFields("Warehose Ship No.");
                ShipNo := "Sales Shipment Header"."Warehose Ship No.";
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
                }
            }
        }
        actions
        {
        }
    }
    labels
    { }

    trigger OnInitReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        PackingListCaptionLbl: label 'Packing List';
        CompanyInfo: Record "Company Information";
        //ini - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.        
        //Language: Record Language;
        cLanguage: Codeunit Language;
        //fin - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
        Cust: Record Customer;
        ShippingAgent: Record "Shipping Agent";
        PaymentMethod: Record "Payment Method";
        FormatAddr: Codeunit "Format Address";
        ShipToAddr: array[8] of Text[50];
        SellToAddr: array[8] of Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        OutputNo: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        PhoneNoCaptionLbl: label 'Phone:', comment = 'ESP="Tel:"';
        VATRegNoCaptionLbl: label 'Vat Number';
        CompanyCountryCaptionLbl: label 'Spain';
        ShipmentNoCaptionLbl: label 'Shipment No.', comment = 'ESP="Nº albarán"';
        ShipmentDateCaptionLbl: label 'Shipment Date', comment = 'ESP="Fecha envío"';
        DescriptionCaptionLbl: label 'Description', comment = 'ESP="Descripción"';
        NoCaptionLbl: label 'Item Nr.', comment = 'ESP="Código"';
        PageCaptionCap: label 'Page %1 of %2', comment = 'ESP="Página %1 de %2"';
        ShipmentMethodCaptionLbl: label 'TERMS OF DELIVERY', comment = 'ESP="Medio de envío"';
        VendorCaptionLbl: label 'Supplier nº', comment = 'ESP="Proveedor nº"';
        VendorCodeCaptionLbl: label 'Vend. Code', comment = 'ESP="Código Prov."';
        EanCodeCaptionLbl: label 'EAN Code', comment = 'ESP="EAN13"';
        NpaletCaptionLbl: label 'Palet No.', comment = 'ESP="Nº palet"';
        CaseCaptionLbl: label 'Units', comment = 'ESP="Case"';
        NrCasesCaptionLbl: label 'Nr.Cases', comment = 'ESP="Nr.Case"';
        TotalUnitsCaptionLbl: label 'Total Units', comment = 'ESP="Total unidades"';
        TotalShipmentCaptionLbl: label 'Total', comment = 'ESP="Total';
        TotalPalletsCaptionLbl: label 'Total pallets', comment = 'ESP="Total palets"';
        TotalPackagesCaptionLbl: label 'Total packages', comment = 'ESP="Total bultos"';
        TotalWeightCaptionLbl: label 'Total weight', comment = 'ESP="Total peso"';
        RegTextCaptionLbl: label 'Reg. Mercantil Madrid, tomo 31650, Folio 117,Hoja M-569538, C.I.F - B86880473';
        ShipmentMethod: Record "Shipment Method";
        SellCustCaptionLbl: label 'Customer', comment = 'ESP="Nº cliente"';
        ItemUnitofMeasure: Record "Item Unit of Measure";
        QtyCartons: Decimal;
        CBM: Decimal;
        GW: Decimal;
        NW: Decimal;
        Item: Record Item;
        CountryRegion: Record "Country/Region";
        CountryOrigin: Text[50];
        CountryOriginLabel: Code[30];
        CountryOriginAux: Record "Country/Region";
        OurAccountNoLbl: label 'Vendor', comment = 'ESP="Proveedor"';
        TariffCode: Text[30];
        TariffCodeCaption: Text[20];
        vatregn: Text[20];
        GeneralLedgerSetup: Record "General Ledger Setup";
        ContractNoLbl: label 'Contract Number';
        ShipNo: Text;
        FormatDocument: Codeunit "Format Document";

    local procedure CalcWeight()
    var
        UnitNr: Decimal;
        BoxDec: Decimal;
        BoxNr: Decimal;
        ItemUnitofMeasureCJ: Record "Item Unit of Measure";
        UnitBase: Decimal;
    begin
        NW := 0;
        GW := 0;
        CBM := 0;
        QtyCartons := 0;
        UnitNr := 0;
        UnitBase := 0;
        ItemUnitofMeasure.Reset;
        ItemUnitofMeasure.SetRange("Item No.", "Sales Shipment Line"."No.");
        //ItemUnitofMeasure.SETRANGE(Code,'UNID');
        ItemUnitofMeasure.SetRange(Code, Item."Base Unit of Measure");
        if ItemUnitofMeasure.FindFirst then begin
            UnitBase := "Sales Shipment Line"."Quantity (Base)";
            ItemUnitofMeasureCJ.Reset;
            ItemUnitofMeasureCJ.SetRange("Item No.", "Sales Shipment Line"."No.");
            ItemUnitofMeasureCJ.SetRange(Code, 'CAJA');
            if ItemUnitofMeasureCJ.FindFirst then begin
                BoxDec := "Sales Shipment Line"."Quantity (Base)" / ItemUnitofMeasureCJ."Qty. per Unit of Measure";
                BoxNr := ROUND(BoxDec, 1, '<');
                UnitNr := "Sales Shipment Line"."Quantity (Base)" - (ItemUnitofMeasureCJ."Qty. per Unit of Measure" * BoxNr);
                //>> REV1. Si no tiene valores la CAJA usamos los de la UNID * cantidad por caja.
                //
                //NW := NW + ROUND(ItemUnitofMeasureCJ.Weight * BoxNr + ItemUnitofMeasure.Weight * UnitNr,0.01);
                //GW := GW + ROUND(ItemUnitofMeasureCJ."Gross weight" * BoxNr + ItemUnitofMeasure."Gross weight" * UnitNr,0.01);
                //CBM := CBM + ROUND(ItemUnitofMeasureCJ.Cubage * BoxNr + ItemUnitofMeasure.Cubage * UnitNr,0.01);
                if ItemUnitofMeasureCJ.Weight > 0 then
                    NW := NW + ROUND(ItemUnitofMeasureCJ.Weight * BoxNr + ItemUnitofMeasure.Weight * UnitNr, 0.01)
                else
                    NW := NW + ROUND(ItemUnitofMeasure.Weight * UnitBase, 0.01);
                //END;
                if ItemUnitofMeasureCJ."Gross weight" > 0 then
                    GW := GW + ROUND(ItemUnitofMeasureCJ."Gross weight" * BoxNr + ItemUnitofMeasure."Gross weight" * UnitNr, 0.01)
                else
                    GW := GW + ROUND(ItemUnitofMeasure."Gross weight" * UnitBase, 0.01);
                //END;
                if ItemUnitofMeasureCJ.Cubage > 0 then
                    CBM := CBM + ROUND(ItemUnitofMeasureCJ.Cubage * BoxNr + ItemUnitofMeasure.Cubage * UnitNr, 0.01)
                else
                    CBM := CBM + ROUND(ItemUnitofMeasure.Cubage * UnitBase, 0.01);
                //END;
                //<< REV1
            end
            else begin
                BoxNr := "Sales Shipment Line".Quantity;
                NW := NW + ROUND(ItemUnitofMeasure.Weight * UnitBase, 0.01);
                GW := GW + ROUND(ItemUnitofMeasure."Gross weight" * UnitBase, 0.01);
                CBM := CBM + ROUND(ItemUnitofMeasure.Cubage * UnitBase, 0.01);
            end;
        end;
        QtyCartons := BoxNr;
    end;
}
