Report 50006 "Packing List"
{
    // //INC-2019-02-107551 : Mostrar pie Protección de datos
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/Packing List.rdl';
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
                    column(Cust_OurAccountNo; Cust."Our Account No.")
                    { }
                    column(CompanyCountryCaption; CompanyCountryCaptionLbl)
                    { }
                    column(ExtDocNoCaption; ExtDocNoCaptionLbl)
                    { }
                    column(ExtDocNo_SalesShptHeader; "Sales Shipment Header"."External Document No.")
                    { }
                    column(ShptDate_SalesShptHeader; Format("Sales Shipment Header"."Shipment Date", 0, 4))
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
                    column(ShipmentMethod_SalesShptHeader; "Sales Shipment Header"."Shipment Method Code")
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
                        trigger OnPreDataItem()
                        begin
                            "Sales Shipment Line".SetFilter("Sales Shipment Line".Quantity, '>0');
                            MoreLines := "Sales Shipment Line".Find('+');
                            while MoreLines and ("Sales Shipment Line".Description = '') and ("Sales Shipment Line"."No." = '') and ("Sales Shipment Line".Quantity = 0) do MoreLines := "Sales Shipment Line".Next(-1) <> 0;
                            if not MoreLines then CurrReport.Break;
                            //SETRANGE("Line No.",0,"Line No.");
                        end;
                    }
                }
                trigger OnAfterGetRecord()
                begin
                    if CopyLoop.Number > 1 then begin
                        CopyText := Text001;
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
                "Sales Shipment Header"."Ship-to Contact" := '';
                "Sales Shipment Header"."Bill-to Contact" := '';
                FormatAddr.SalesShptShipTo(ShipToAddr, "Sales Shipment Header");
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
        Text001: label 'COPY';
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
        MoreLines: Boolean;
        NoOfCopies: Integer;
        OutputNo: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        PhoneNoCaptionLbl: label 'Phone:', comment = 'ESP="Tel:"';
        VATRegNoCaptionLbl: label 'CIF', comment = 'ESP="CIF"';
        CompanyCountryCaptionLbl: label 'Spain';
        ShipmentNoCaptionLbl: label 'Shipment No.', comment = 'ESP="Nº albarán"';
        ShipmentDateCaptionLbl: label 'Delivery Date', comment = 'ESP="Fecha entrega"';
        ExtDocNoCaptionLbl: label 'Supplier Order No.', comment = 'ESP="Nº Pedido proveedor"';
        DescriptionCaptionLbl: label 'Description', comment = 'ESP="Descripción"';
        NoCaptionLbl: label 'Code', comment = 'ESP="Código"';
        PageCaptionCap: label 'Page %1 of %2', comment = 'ESP="Página %1 de %2"';
        ShipmentMethodCaptionLbl: label 'Shipment Method', comment = 'ESP="Medio de envío"';
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
}
