Report 50021 "Packing List Palet"
{
    // //14/01/18 RND-106 Packing List
    // // SDA 16/03/2022. Ajustes para uso Lidl
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/Packing List Palet.rdl';
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
            column(CompanyInfoVATRegtnNo; CompanyInfo."VAT Registration No.")
            { }
            column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
            { }
            column(PackingListCaption; PackingListCaptionLbl)
            { }
            column(RegTextCaption; RegTextCaptionLbl)
            { }
        }
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Shipment', comment = 'ESP="Histórico albaranes venta"';

            column(ReportForNavId_3595; 3595)
            { }
            column(No_SalesShptHeader; "No.")
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
                    column(ShipToCode; ShipToCode)
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
                    column(Cust_OurAccountNo; Cust."Our Account No.")
                    { }
                    column(CompanyCountryCaption; CompanyCountryCaptionLbl)
                    { }
                    column(ExtDocNoCaption; ExtDocNoCaptionLbl)
                    { }
                    column(ExtDocNo_SalesShptHeader; "Sales Shipment Header"."External Document No.")
                    { }
                    column(ShptDate_SalesShptHeader; Format("Sales Shipment Header"."Posting Date", 0, 4))
                    { }
                    column(ShippingAgent_Name; ShippingAgent.Name)
                    { }
                    column(OutputNo; OutputNo)
                    { }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    { }
                    column(VATRegNoCaption; VATRegNoCaptionLbl)
                    { }
                    column(ShipmentNoCaption; ShipmentNoCaptionLbl)
                    { }
                    column(ShipmentDateCaption; ShipmentDateCaptionLbl)
                    { }
                    column(ShipmentMethod_SalesShptHeader; ShippingMet.Description)
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
                    column(GrossWeightCaption; GrossWeightLbl)
                    { }
                    column(NetWeightCaption; NetWeightLbl)
                    { }
                    column(VolumenCaption; VolumenLbl)
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
                    dataitem("Sales Shipment Palet"; "Sales Shipment Palet")
                    {
                        DataItemLink = "Sales Shipment No." = field("No.");
                        DataItemLinkReference = "Sales Shipment Header";
                        DataItemTableView = sorting("Sales Shipment No.", "Sales Shipment Line Number", "Palet No.");

                        column(ReportForNavId_1100234029; 1100234029)
                        { }
                        column(Description_SalesShptLine; ItemDescription)
                        { }
                        column(Type_SalesShptLine; Format("Sales Shipment Line".Type, 0, 2))
                        { }
                        column(DocumentNo_SalesShptLine; "Sales Shipment Line"."Document No.")
                        { }
                        column(No_SalesShptLine; "Sales Shipment Line"."No.")
                        { }
                        column(LineNo_SalesShptLine; "Sales Shipment Line"."Line No.")
                        { }
                        column(CrossReferenceNo; CrossReference)
                        { }
                        column(GTIN_Producto; GTIN_Producto)
                        { }
                        column(CodPaletSSCC; CodPaletSSCC)
                        { }
                        column(Quantity_SalesShptLine; "Sales Shipment Palet".Boxes)
                        { }
                        column(Gross_Weight; "Sales Shipment Palet"."Gross Weight")
                        { }
                        column(Net_Weight; "Sales Shipment Palet"."Net Weight")
                        { }
                        column(Volumen; "Sales Shipment Palet".Volume)
                        { }
                        column(Cajas; NCajas)
                        { }
                        column(No_Palet; "Sales Shipment Palet"."Bulk number")
                        { }
                        trigger OnAfterGetRecord()
                        begin
                            "Sales Shipment Line".Get("Sales Shipment No.", "Sales Shipment Line Number");
                            if not Item.Get("Sales Shipment Line"."No.") then Item.Init;
                            //>> SDA 16/03/2022
                            ItemDescription := '';
                            CrossReference := '';
                            GTIN_Producto := '';
                            ItemDescription := "Sales Shipment Line".Description;
                            GTIN_Producto := "Sales Shipment Line"."EAN Code";
                            // Ficha Producto
                            if GTIN_Producto = '' then GTIN_Producto := Item."EAN Code";
                            // Identificador del producto
                            rItemIdentifier.Reset;
                            rItemIdentifier.SetRange("Item No.", "Sales Shipment Line"."No.");
                            rItemIdentifier.SetRange("Unit of Measure Code", "Sales Shipment Line"."Unit of Measure Code");
                            if rItemIdentifier.FindFirst then GTIN_Producto := rItemIdentifier.Code;
                            // Referencia cruzada con el Cliente
                            rItemReference.Reset;
                            rItemReference.SetRange("Item No.", "Sales Shipment Line"."No.");
                            rItemReference.SetRange("Reference Type", rItemReference."Reference Type"::Customer);
                            rItemReference.SetRange("Reference Type No.", "Sales Shipment Line"."Sell-to Customer No.");
                            rItemReference.SetRange("Unit of Measure", "Sales Shipment Line"."Unit of Measure Code");
                            if rItemReference.FindFirst then begin
                                if rItemReference.Description <> '' then ItemDescription := rItemReference.Description;
                                CrossReference := rItemReference."Reference No.";
                            end;
                            // Referencia cruzada con el Cliente - EAN13
                            rItemReference.Reset;
                            rItemReference.SetRange("Item No.", "Sales Shipment Line"."No.");
                            rItemReference.SetRange("Reference Type", rItemReference."Reference Type"::"Bar Code");
                            rItemReference.SetRange("Reference Type No.", 'EAN13');
                            rItemReference.SetRange("Unit of Measure", "Sales Shipment Line"."Unit of Measure Code");
                            if rItemReference.FindFirst then begin
                                if rItemReference.Description <> '' then ItemDescription := rItemReference.Description;
                                GTIN_Producto := rItemReference."Reference No.";
                            end;
                            NCajas := CalculoCajas(Item."No.", "Sales Shipment Palet".Boxes);
                            // SSCC
                            CodPaletSSCC := FormatSSCC_GS1_NoPalet("Sales Shipment Palet"."Palet No.");
                            //<<
                        end;
                    }
                }
                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := FormatDocument.GetCOPYText();
                        ;
                        OutputNo += 1;
                    end;
                    //CurrReport.PageNo := 1;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := 1 + Abs(NoOfCopies);
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                LanguageCode := 'ESP';
                if ("Sales Shipment Header"."Language Code" <> '') and ("Sales Shipment Header"."Language Code" <> 'ESP') then LanguageCode := 'ENU';
                CurrReport.Language := cLanguage.GetLanguageID(LanguageCode);
                ShipToCode := "Sales Shipment Header"."Ship-to Code";
                if not Cust.Get("Bill-to Customer No.") then Clear(Cust);
                if not ShippingAgent.Get("Shipping Agent Code") then ShippingAgent.Init;
                if not ShippingMet.Get("Shipment Method Code") then ShippingMet.Init;
                "Ship-to Contact" := '';
                "Bill-to Contact" := '';
                FormatAddr.SalesShptShipTo(ShipToAddr, "Sales Shipment Header");
                "Sales Shipment Palet".BulkCount("No.");
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
    {
    }
    trigger OnInitReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        PackingListCaptionLbl: label 'Packing List';
        CompanyInfo: Record "Company Information";
        cLanguage: Codeunit Language;
        Cust: Record Customer;
        ShippingAgent: Record "Shipping Agent";
        PaymentMethod: Record "Payment Method";
        FormatAddr: Codeunit "Format Address";
        ShipToAddr: array[8] of Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        OutputNo: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        PhoneNoCaptionLbl: label 'Phone:', comment = 'ESP="Tel:"';
        VATRegNoCaptionLbl: label 'CIF:';
        CompanyCountryCaptionLbl: label 'Spain', comment = 'ESP="España"';
        ShipmentNoCaptionLbl: label 'Shipment No.:', comment = 'ESP="Nº Albarán"';
        ShipmentDateCaptionLbl: label 'Delivery Date:', comment = 'ESP="Fecha Entrega:"';
        ExtDocNoCaptionLbl: label 'Customer Order No.:', comment = 'ESP="Nº Pedido Cliente"';
        DescriptionCaptionLbl: label 'Description', comment = 'ESP="Descripción"';
        NoCaptionLbl: label 'Code', comment = 'ESP="Código"';
        PageCaptionCap: label 'Page %1 of %2', comment = 'ESP="Página %1 de %2"';
        ShipmentMethodCaptionLbl: label 'Shipment Method:', comment = 'ESP="Método Envío:"';
        VendorCaptionLbl: label 'Cust. nº', comment = 'ESP="Cliente nº"';
        VendorCodeCaptionLbl: label 'Customer Reference', comment = 'ESP="Referencia Cliente"';
        EanCodeCaptionLbl: label 'EAN Code', comment = 'ESP="EAN13"';
        NpaletCaptionLbl: label 'SSCC';
        NetWeightLbl: label 'Net Weight', comment = 'ESP="Peso Neto"';
        GrossWeightLbl: label 'Gross Weight', comment = 'ESP="Peso Bruto"';
        VolumenLbl: label 'Vol.';
        CaseCaptionLbl: label 'Boxes', comment = 'ESP="Cajas"';
        NrCasesCaptionLbl: label 'Pallet', comment = 'ESP="Palet"';
        TotalUnitsCaptionLbl: label 'Units', comment = 'ESP="Unid."';
        TotalShipmentCaptionLbl: label 'Total';
        TotalPalletsCaptionLbl: label 'Total pallets', comment = 'ESP="Total palets"';
        TotalPackagesCaptionLbl: label 'Total packages', comment = 'ESP="Total bultos"';
        TotalWeightCaptionLbl: label 'Total weight', comment = 'ESP="Total peso"';
        RegTextCaptionLbl: label 'Reg. Mercantil Madrid, tomo 31650, Folio 117,Hoja M-569538, C.I.F - B86880473';
        "Sales Shipment Line": Record "Sales Shipment Line";
        Item: Record Item;
        ShippingMet: Record "Shipment Method";
        LanguageCode: Code[10];
        NCajas: Integer;
        CrossReference: Text[50];
        //rItemCrossReference: Record "Item Cross Reference";
        rItemReference: Record "Item Reference";
        ItemDescription: Text[100];
        rItemIdentifier: Record "Item Identifier";
        GTIN_Producto: Text[20];
        CodPaletSSCC: Text[20];
        ShipToCode: Text[20];
        FormatDocument: Codeunit "Format Document";

    local procedure CalculoCajas(ItemNo: Code[20]; UnidadesPalet: Integer): Integer
    var
        rItemUnitofMeasure: Record "Item Unit of Measure";
        NNCajas: Integer;
    begin
        NNCajas := UnidadesPalet;
        rItemUnitofMeasure.Reset;
        rItemUnitofMeasure.SetRange("Item No.", ItemNo);
        rItemUnitofMeasure.SetRange(Code, 'CAJA');
        if rItemUnitofMeasure.FindFirst then begin
            NNCajas := UnidadesPalet DIV rItemUnitofMeasure."Qty. per Unit of Measure";
            NNCajas := NNCajas + (UnidadesPalet - (NNCajas * rItemUnitofMeasure."Qty. per Unit of Measure")); // Sumamos los picos.
        end;
        exit(NNCajas);
    end;

    local procedure FormatSSCC_GS1_NoPalet(NoPalet: Text[20]): Text
    var
        GLNEmpresa: Text[10];
        Ind: Integer;
        CheckSum: Text[20];
        CheckString: label '31313131313131313';
    begin
        //>> SDA - 16/03/2022
        // GLN Empresa
        GLNEmpresa := '';
        if CompanyInfo.Get() then GLNEmpresa := CopyStr(CompanyInfo.GLN, 1, 9);
        for Ind := StrLen(GLNEmpresa) + 1 to 9 do // Rellenar las 9 posiciones del GTIN Empresa
            GLNEmpresa := '0' + GLNEmpresa;
        // No. Palet
        if StrLen(NoPalet) > 8 then //Tamaño de Número de Palet máximo 8
            NoPalet := CopyStr(NoPalet, StrLen(NoPalet) - 7, 8);
        for Ind := StrLen(NoPalet) + 1 to 8 do // Rellenar las 8 posiciones del número de palet.
            NoPalet := '0' + NoPalet;
        CheckSum := Format(StrCheckSum(GLNEmpresa + NoPalet, CheckString, 10), 1);
        exit(GLNEmpresa + NoPalet + CheckSum);
        //<<
    end;
}
