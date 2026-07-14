report 50022 "Shipment Label 2"
{
    // version RND-107
    // //14/01/18 RND-107 Etiqueta de Envío.
    // // SDA 16/03/2022. Ajuste de la etiqueta a estandares GTIN
    // // SDA 01/05/2022. Sustitución del código de producto con la referencia cruzada.
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/Shipment Label 2.rdl';
    Caption = 'Shipment Label', comment = 'ESP="Etiqueta de envío"';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Company_Info; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            column(CompanyInfo_Name; CompanyAddr[1])
            { }
            column(CompanyInfo_Address; CompanyAddr[2])
            { }
            column(CompanyInfo_Address2; CompanyAddr[3])
            { }
            column(CompanyInfo_PostCode_City_County; CompanyAddr[4])
            { }
            column(CompanyInfo_Country_Region_Code; CompanyAddr[5])
            { }
        }
        dataitem("Sales Shipment Line"; "Sales Shipment Line")
        {
            DataItemTableView = SORTING("Document No.", "Line No.");
            RequestFilterFields = "Document No.";

            column(ShipToLbl; ShipToLbl)
            { }
            column(ShipToCode; ShipToCode)
            { }
            column(ShipmentNoLbl; ShipmentNoLbl)
            { }
            column(OrderLbl; OrderLbl)
            { }
            column(CustOrderLbl; CustOrderLbl)
            { }
            column(DateLbl; DateLbl)
            { }
            column(PackagesLbl; PackagesLbl)
            { }
            column(PackNumberLbl; PackNumberLbl)
            { }
            column(WeightLbl; WeightLbl)
            { }
            column(VolumeLbl; VolumeLbl)
            { }
            column(DeliveryDateLbl; DeliveryDateLbl)
            { }
            column(IncotermLbl; IncotermLbl)
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
            column(SalesShipmentHdr_ShipmentDate; ShipmentDate)
            { }
            column(SalesShipmentHdr_OrderNo; SalesShipmentHdr."Order No.")
            { }
            column(SalesHeader_YourReference; SalesShipmentHdr."External Document No.")
            { }
            column(ShippingAgent_Name; ShippingAgent.Name)
            { }
            column(ShippingConditions_Name; ShippingConditions.Description)
            { }
            column(ItemNumberLbl; ItemNumberLbl)
            { }
            column(ItemNumber; ItemNumber)
            { }
            column(ItemDescriptionLbl; ItemDescriptionLbl)
            { }
            column(ItemDescription; ItemDescription)
            { }
            column(GTIN_Producto; GTIN_Producto)
            { }
            dataitem(SalesShipmentPalet; "Sales Shipment Palet")
            {
                DataItemLink = "Sales Shipment No." = FIELD("Document No."), "Sales Shipment Line Number" = FIELD("Line No.");
                DataItemTableView = SORTING("Sales Shipment No.", "Sales Shipment Line Number", "Palet No.");

                dataitem(CopyLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number);

                    column(SalesShipmentPalet_SalesShipmentNo; SalesShipmentPalet."Sales Shipment No.")
                    { }
                    column(SalesShipmentPalet_PaletNo; SalesShipmentPalet."Palet No.")
                    { }
                    column(SalesShipmentPalet_GrossWeight; SalesShipmentPalet."Gross Weight")
                    { }
                    column(SalesShipmentPalet_Volume; SalesShipmentPalet.Volume)
                    { }
                    column(Packages; PackagesText)
                    { }
                    column(PackNumber; PackNumber)
                    { }
                    // Column that stores the barcode encoded string
                    column(CodBarras_00; EncodedText)
                    { }
                    column(LabelNo; CopyLoop.Number)
                    { }
                    column(CodBarras_02_400; EncodedText2)
                    { }
                    column(CodBarrasText_00; CodbarrasText_00)
                    { }
                    column(CodBarrasText_02_400; CodBarrasText_02_400)
                    { }
                    column(UnidadesTxt; UnidadesTxt)
                    { }
                    column(Unidades; Unidades)
                    { }
                    column(CajasTxt; CajasTxt)
                    { }
                    column(NCajas; NCajas)
                    { }
                    column(Cli_NonFoodTxt; Cli_NonFoodTxt)
                    { }
                    trigger OnAfterGetRecord();
                    var
                        BarcodeString: Text;
                        BarcodeSymbology: Enum "Barcode Symbology";
                        BarcodeFontProvider: Interface "Barcode Font Provider";
                    begin
                        if OldPalletNo <> SalesShipmentPalet."Palet No." then PackNo += 1;
                        // PackagesText := FORMAT(PackNo) + ' / ' + FORMAT(PackNumber);
                        PackagesText := FORMAT(SalesShipmentPalet."Bulk number") + ' / ' + FORMAT(PackNumber);
                        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                        BarcodeSymbology := Enum::"Barcode Symbology"::Code128;
                        if CodbarrasText_00 <> '' then begin
                            BarcodeString := CodbarrasText_00;
                            BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
                            EncodedText := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
                        end;
                        if CodBarrasText_02_400 <> '' then begin
                            BarcodeString := CodBarrasText_02_400;
                            BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
                            EncodedText2 := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
                        end;
                        OldPalletNo := SalesShipmentPalet."Palet No.";
                    end;

                    trigger OnPreDataItem();
                    begin
                        SETRANGE(Number, 1, LabelsNumb);
                    end;
                }
                trigger OnAfterGetRecord();
                begin
                    //>> SDA 16/03/2022
                    //CodbarrasText := "Palet No.";
                    CodbarrasText_00 := FormatSSCC_GS1_NoPalet("Palet No.");
                    //Cajas son las Master que Pueden llevar más de 1 unidad de producto
                    Unidades := SalesShipmentPalet.Boxes; // Boxes = cajas de unidades de producto
                    NCajas := CalculoCajas("Sales Shipment Line"."No.", Unidades);
                    //<<
                end;

                trigger OnPreDataItem();
                begin
                    PackNumber := BulkCount("Sales Shipment Line"."Document No.");
                    // PackNumber := COUNT;
                    OldPalletNo := '';
                    PackNo := 0;
                end;
            }
            trigger OnAfterGetRecord();
            begin
                SalesShipmentHdr.GET("Document No.");
                FormatShipToAddress(SalesShipmentHdr);
                Cli_NonFoodTxt := '';
                if SalesShipmentHdr."Sell-to Customer No." = 'C02511' then //Texto solo para Lidl (para BBTrends)
                    Cli_NonFoodTxt := NonFoodTxt;
                ShipmentDate := SalesShipmentHdr."Requested Delivery Date";
                //IF SalesShipmentHdr."Requested Delivery Date" < SalesShipmentHdr."Posting Date" THEN
                if SalesShipmentHdr."Requested Delivery Date" = 0D then ShipmentDate := SalesShipmentHdr."Posting Date";
                ShipToCode := SalesShipmentHdr."Ship-to Code";
                if SalesShipmentHdr."Order No." <> '' then begin
                    if not SalesHeader.GET(SalesHeader."Document Type"::Order, SalesShipmentHdr."Order No.") then SalesHeader.INIT;
                end;
                if not ShippingAgent.GET(SalesShipmentHdr."Shipping Agent Code") then ShippingAgent.INIT;
                if not ShippingConditions.GET(SalesShipmentHdr."Shipment Method Code") then ShippingConditions.INIT;
                ItemNumber := '';
                ItemDescription := '';
                GTIN_Producto := '';
                //>> SDA 16/03/2022. GTIN PRODUCTO
                ////>> SDA 01/05/2022. No se utiliza el GTDIN --> SE USA EL EAN. {
                /*
                rItem.RESET;
                IF rItem.GET("Sales Shipment Line"."No.") THEN;
                
                ItemDescription := "Sales Shipment Line".Description;
                GTIN_Producto := "Sales Shipment Line"."EAN Code";
                
                IF GTIN_Producto = '' THEN
                  GTIN_Producto := rItem."EAN Code";
                
                // Identificador del producto
                rItemIdentifier.RESET;
                rItemIdentifier.SETRANGE("Item No.","Sales Shipment Line"."No.");
                rItemIdentifier.SETRANGE("Unit of Measure Code","Sales Shipment Line"."Unit of Measure Code");
                IF rItemIdentifier.FINDFIRST THEN
                  GTIN_Producto := rItemIdentifier.Code;
                
                // Referencia cruzada con el Cliente
                rItemCrossReference.RESET;
                rItemCrossReference.SETRANGE("Item No.","Sales Shipment Line"."No.");
                rItemCrossReference.SETRANGE("Cross-Reference Type",rItemCrossReference."Cross-Reference Type"::Customer);
                rItemCrossReference.SETRANGE("Cross-Reference Type No.","Sales Shipment Line"."Sell-to Customer No.");
                rItemCrossReference.SETRANGE("Unit of Measure","Sales Shipment Line"."Unit of Measure Code");
                IF rItemCrossReference.FINDFIRST THEN BEGIN
                  IF rItemCrossReference.Description <> '' THEN
                    ItemDescription := rItemCrossReference.Description;
                  GTIN_Producto := rItemCrossReference."Cross-Reference No.";
                END;
                
                // Referencia cruzada con el Cliente - EAN13
                rItemCrossReference.RESET;
                rItemCrossReference.SETRANGE("Item No.","Sales Shipment Line"."No.");
                rItemCrossReference.SETRANGE("Cross-Reference Type",rItemCrossReference."Cross-Reference Type"::"Bar Code");
                rItemCrossReference.SETRANGE("Cross-Reference Type No.",'EAN13');
                rItemCrossReference.SETRANGE("Unit of Measure","Sales Shipment Line"."Unit of Measure Code");
                IF rItemCrossReference.FINDFIRST THEN BEGIN
                  IF rItemCrossReference.Description <> '' THEN
                    ItemDescription := rItemCrossReference.Description;
                  GTIN_Producto := rItemCrossReference."Cross-Reference No.";
                END;
                
                IF STRLEN(GTIN_Producto) > 14 THEN                //Tamaño de GTIN máximo 14
                  GTIN_Producto := COPYSTR(GTIN_Producto, STRLEN(GTIN_Producto) - 13,14);
                FOR Index := STRLEN(GTIN_Producto) + 1 TO 14 DO  // Rellenar las 14 posiciones del GTIN
                  GTIN_Producto := '0' + GTIN_Producto;
                
                CodBarrasText_02_400 := '02' + GTIN_Producto + '400' + SalesShipmentHdr."External Document No.";
                
                ItemNumber := GTIN_Producto;
                */
                ////<< }
                //<< SDA 16/03/2022
                //>> SDA. 01/05/2022. Nuevo Código de producto y descripción.
                rItem.RESET;
                if rItem.GET("Sales Shipment Line"."No.") then;
                ItemDescription := "Sales Shipment Line".Description;
                ItemNumber := "Sales Shipment Line"."Item Reference No.";
                if ItemNumber = '' then ItemNumber := "Sales Shipment Line"."No.";
                //<< SDA. 01/05/2022
            end;

            trigger OnPreDataItem();
            begin
                FiltroShipNo := "Sales Shipment Line".GETFILTER("Document No.");
                if FiltroShipNo <> '' then
                    if SalesShipmentHdr.GET(FiltroShipNo) then
                        if RecCustomer.GET(SalesShipmentHdr."Sell-to Customer No.") then begin
                            //CurrReport.LANGUAGE := LanguageCu.GetLanguageId(RecCustomer."Language Code");
                            IF SalesShipmentHdr."Language Code" <> '' then
                                CurrReport.Language := LanguageCu.GetLanguageID(SalesShipmentHdr."Language Code")
                            else
                                CurrReport.Language := LanguageCu.GetLanguageID('ESP');
                        end;
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

                    field(LabelsNumb; LabelsNumb)
                    {
                        Caption = 'Labels Number', comment = 'ESP="Nº de etiquetas"';
                        ApplicationArea = all;
                        MinValue = 1;
                    }
                }
            }
        }
        actions
        { }

        trigger OnOpenPage();
        begin
            LabelsNumb := 1;
        end;
    }
    labels
    { }

    trigger OnPreReport();
    begin
        FormatCompanyInfo;
    end;

    var
        CompanyInfo: Record "Company Information";
        ShipToLbl: Label 'Ship-To:', comment = 'ESP="Destino:"';
        VATRegLbl: Label 'VAT Reg. %1', comment = 'ESP="CIF %1"';
        ShipmentNoLbl: Label 'Shipment No.:', comment = 'ESP="No. Albarán:"';
        OrderLbl: Label 'Order:', comment = 'ESP="Pedido:"';
        CustOrderLbl: Label 'Customer Order:', comment = 'ESP="Ped. Cliente:"';
        DateLbl: Label 'Date:', comment = 'ESP="Fecha:"';
        PackagesLbl: Label 'Pallet Number:', comment = 'ESP="Bulto No.:"';
        WeightLbl: Label 'Weight:', comment = 'ESP="Peso:"';
        VolumeLbl: Label 'Volume:', comment = 'ESP="Volumen:"';
        SalesShipmentHdr: Record "Sales Shipment Header";
        SalesHeader: Record "Sales Header";
        ShippingAgent: Record "Shipping Agent";
        TempBlob_00: Codeunit "Temp Blob";
        //BarCodeMgt: Codeunit BarCodeMgt;
        CompanyAddr: array[5] of Text;
        ShipToAddr: array[5] of Text;
        CodbarrasText_00: Text[1024];
        PackagesText: Text;
        OldPalletNo: Code[20];
        PackNumber: Integer;
        PackNo: Integer;
        LabelsNumb: Integer;
        ShippingConditions: Record "Shipment Method";
        FiltroShipNo: Text;
        RecCustomer: Record Customer;
        LanguageCu: Codeunit Language;
        GTIN_Producto: Text[20];
        TempBlob_02_400: Codeunit "Temp Blob";
        CodBarrasText_02_400: Text[1024];
        ItemNumber: Text[20];
        ItemDescription: Text[100];
        rItemCrossReference: Record "Item Reference";
        Index: Integer;
        rItemIdentifier: Record "Item Identifier";
        PackNumberLbl: Label 'Number of Pallets:', comment = 'ESP="No. de Bultos:"';
        DeliveryDateLbl: Label 'Delivery Date:', comment = 'ESP="Fecha Entrega:"';
        IncotermLbl: Label 'Incoterm:', comment = 'ESP="Incoterm:"';
        ItemNumberLbl: Label 'Content :', comment = 'ESP="Producto :"';
        ItemDescriptionLbl: Label 'Description:', comment = 'ESP="Descripción:"';
        Unidades: Integer;
        Cajas: Integer;
        CajasTxt: Label 'Boxes:', comment = 'ESP="Cajas:"';
        UnidadesTxt: Label 'Units:', comment = 'ESP="Unidades:"';
        NCajas: Integer;
        rItem: Record Item;
        ShipToCode: Text[20];
        NonFoodTxt: Label 'NON FOOD LOGISTICS', comment = 'ESP="NON FOOD LOGISTICS"';
        Cli_NonFoodTxt: Text[20];
        ShipmentDate: Date;
        EncodedText: Text;
        EncodedText2: Text;

    local procedure FormatCompanyInfo();
    var
        Country: Record "Country/Region";
        PC_City_County_Txt: Text;
    begin
        CLEAR(CompanyAddr);
        CompanyInfo.GET;
        PC_City_County_Txt := CompanyInfo."Post Code";
        if PC_City_County_Txt > '' then
            PC_City_County_Txt := PC_City_County_Txt + ' ' + CompanyInfo.City
        else
            PC_City_County_Txt := CompanyInfo.City;
        if UPPERCASE(CompanyInfo.City) <> UPPERCASE(CompanyInfo.County) then begin
            if PC_City_County_Txt > '' then
                PC_City_County_Txt := PC_City_County_Txt + ', ' + CompanyInfo.County
            else
                PC_City_County_Txt := CompanyInfo.County;
        end;
        if not Country.GET(CompanyInfo."Country/Region Code") then Country.INIT;
        CompanyAddr[1] := CompanyInfo.Name;
        CompanyAddr[2] := CompanyInfo.Address;
        CompanyAddr[3] := CompanyInfo."Address 2";
        CompanyAddr[4] := PC_City_County_Txt;
        CompanyAddr[5] := Country.Name;
        COMPRESSARRAY(CompanyAddr);
    end;

    local procedure FormatShipToAddress(SalesShptHdr: Record "Sales Shipment Header");
    var
        Cust: Record Customer;
        PC_City_County_Txt: Text;
    begin
        CLEAR(ShipToAddr);
        PC_City_County_Txt := SalesShptHdr."Ship-to Post Code";
        if PC_City_County_Txt > '' then
            PC_City_County_Txt := PC_City_County_Txt + ' ' + SalesShptHdr."Ship-to City"
        else
            PC_City_County_Txt := SalesShptHdr."Ship-to City";
        if UPPERCASE(SalesShptHdr."Ship-to City") <> UPPERCASE(SalesShptHdr."Ship-to County") then begin
            if PC_City_County_Txt > '' then
                PC_City_County_Txt := PC_City_County_Txt + ', ' + SalesShptHdr."Ship-to County"
            else
                PC_City_County_Txt := SalesShptHdr."Ship-to County";
        end;
        ShipToAddr[1] := SalesShptHdr."Ship-to Name";
        ShipToAddr[2] := SalesShptHdr."Ship-to Address";
        ShipToAddr[3] := SalesShptHdr."Ship-to Address 2";
        ShipToAddr[4] := PC_City_County_Txt;
        if not Cust.GET(SalesShptHdr."Sell-to Customer No.") then Cust.INIT;
        if Cust."VAT Registration No." <> '' then ShipToAddr[5] := STRSUBSTNO(VATRegLbl, Cust."VAT Registration No.");
        COMPRESSARRAY(ShipToAddr);
    end;

    local procedure FormatSSCC_GS1_NoPalet(NoPalet: Text[20]): Text[1024];
    var
        GLNEmpresa: Text[10];
        Ind: Integer;
        CheckSum: Text[1];
        Valor: Integer;
        StringAux: Text[20];
        ValorTotal: Integer;
        CheckString: Label '31313131313131313';
    begin
        // SDA - 16/03/2022
        // GLN Empresa
        GLNEmpresa := '';
        if CompanyInfo.GET() then GLNEmpresa := COPYSTR(CompanyInfo.GLN, 1, 9);
        for Ind := STRLEN(GLNEmpresa) + 1 to 9 do // Rellenar las 9 posiciones del GTIN Empresa
            GLNEmpresa := '0' + GLNEmpresa;
        // No. Palet
        if STRLEN(NoPalet) > 8 then //Tamaño de Número de Palet máximo 8
            NoPalet := COPYSTR(NoPalet, STRLEN(NoPalet) - 7, 8);
        for Ind := STRLEN(NoPalet) + 1 to 8 do // Rellenar las 8 posiciones del número de palet.
            NoPalet := '0' + NoPalet;
        //>> Calculo sustituido por la Rutina std de NAV
        //
        //Valor := 0;
        //ValorTotal := 0;
        //CheckSum := '';
        //StringAux := GLNEmpresa + NoPalet;
        //FOR Index := 17 DOWNTO 1 DO BEGIN
        //  EVALUATE( Valor , COPYSTR(StringAux, Index , 1));
        //  IF  ( Index MOD 2 ) = 0 THEN
        //    ValorTotal := ValorTotal + Valor * 1
        //  ELSE
        //    ValorTotal := ValorTotal + Valor * 3
        //  END;
        //
        //CheckSum := FORMAT(((((ValorTotal DIV 10) + 1) * 10 ) - ValorTotal) MOD 10);
        //
        CheckSum := FORMAT(STRCHECKSUM(GLNEmpresa + NoPalet, CheckString, 10), 1);
        //<<
        exit('00' + GLNEmpresa + NoPalet + CheckSum);
    end;

    local procedure CalculoCajas(ItemNo: Code[20]; UnidadesPalet: Integer): Integer;
    var
        rItemUnitofMeasure: Record "Item Unit of Measure";
        NNCajas: Integer;
    begin
        NNCajas := UnidadesPalet;
        rItemUnitofMeasure.RESET;
        rItemUnitofMeasure.SETRANGE("Item No.", ItemNo);
        rItemUnitofMeasure.SETRANGE(Code, 'CAJA');
        if rItemUnitofMeasure.FINDFIRST then begin
            NNCajas := UnidadesPalet div rItemUnitofMeasure."Qty. per Unit of Measure";
            NNCajas := NNCajas + (UnidadesPalet - (NNCajas * rItemUnitofMeasure."Qty. per Unit of Measure")); // Sumamos los picos.
        end;
        exit(NNCajas);
    end;
}
