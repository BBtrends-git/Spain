Report 50007 "Transport Shipment"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/Transport Shipment.rdl';
    Caption = 'Transport Shipment', comment = 'ESP="Envío de transporte"';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Transport Shipment"; "Transport Shipment")
        {
            CalcFields = "Shipping Agent Name";
            DataItemTableView = sorting("Shipment No.");
            RequestFilterFields = "Shipment No.", "Shipment Date", "Transport Date", "Shipping Agent Code";

            column(ReportForNavId_1100234042; 1100234042)
            { }
            column(TransportShipment_ShipmentNo; "Transport Shipment"."Shipment No.")
            { }
            column(TransportShipment_ShipmentDate; Format("Transport Shipment"."Shipment Date", 0, '<Day,2>-<Month,2>-<Year4>'))
            { }
            column(TransportShipment_TransportDate; Format("Transport Shipment"."Transport Date", 0, '<Day,2>-<Month,2>-<Year4>'))
            { }
            column(TransportShipment_ShippingAgentName; "Transport Shipment"."Shipping Agent Name")
            { }
            column(TransportShipment_VehicleRegistrationNo; "Transport Shipment"."Vehicle Registration No.")
            { }
            column(TransportShipment_TotalPackages; "Transport Shipment"."Total Packages")
            { }
            column(TransportShipment_TotalWeight; "Transport Shipment"."Total Weight")
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
            column(CompanyInfoFaxNo; CompanyInfo."Fax No.")
            { }
            column(CompanyInfoEMail; CompanyInfo."E-Mail")
            { }
            column(CompanyInfoHomePage; CompanyInfo."Home Page")
            { }
            column(PhoneNoCaption; PhoneNoCaptionLbl)
            { }
            column(FaxNoCaption; FaxNoCaptionLbl)
            { }
            column(CompanyCountryCaption; CompanyCountryCaptionLbl)
            { }
            column(ReportTitle; ReportTitleLbl)
            { }
            column(DatePrintedCaption; StrSubstNo(DatePrintedCaptionLbl, Format(Today, 0, '<Day,2>-<Month,2>-<Year4>'), Format(Time, 0, '<Hours24>:<Minutes,2>')))
            { }
            column(ShipNumberCaption; ShipNumberCaptionLbl)
            { }
            column(ShipmentDateCaption; ShipmentDateCaptionLbl)
            { }
            column(TransportDateCaption; TransportDateCaptionLbl)
            { }
            column(ShippingAggentCaption; ShippingAggentCaptionLbl)
            { }
            column(VehicleRegCaption; VehicleRegCaptionLbl)
            { }
            column(TotalPackagesCaption; TotalPackagesCaptionLbl)
            { }
            column(TotalWeigthCaption; TotalWeigthCaptionLbl)
            { }
            column(RefNumberCaption; RefNumberCaptionLbl)
            { }
            column(ShipMethodCaption; ShipMethodCaptionLbl)
            { }
            column(ReferenceCaption; ReferenceCaptionLbl)
            { }
            column(ReceiverCaption; ReceiverCaptionLbl)
            { }
            column(PackagesCaption; PackagesCaptionLbl)
            { }
            column(WeigthCaption; WeigthCaptionLbl)
            { }
            column(VolumeCaption; VolumeCaptionLbl)
            { }
            column(PageNoCaption; PageNoCaptionLbl)
            { }
            dataitem("Sales Shipment Header"; "Sales Shipment Header")
            {
                DataItemLink = "Transport Shipment No." = field("Shipment No.");
                DataItemTableView = sorting("Transport Shipment No.");

                column(DeliveryNoteCaption; DeliveryNoteCaptionLbl)
                {
                }
                column(SalesShipmentHeader_No; "Sales Shipment Header"."No.")
                {
                }
                column(SalesShipmentHeader_ShiptoName; "Sales Shipment Header"."Ship-to Name")
                {
                }
                column(SalesShipmentHeader_ShiptoAddress; "Sales Shipment Header"."Ship-to Address")
                {
                }
                column(SalesShipmentHeader_ShiptoCity; "Sales Shipment Header"."Ship-to City")
                {
                }
                column(SalesShipmentHeader_ShiptoPostCode; "Sales Shipment Header"."Ship-to Post Code")
                {
                }
                column(SalesShipmentHeader_ShiptoCounty; "Sales Shipment Header"."Ship-to County")
                {
                }
                column(SalesShipmentHeader_ShiptoCountryName; Country.Name)
                {
                }
                column(SalesShipmentHeader_Reference; "Sales Shipment Header".Reference)
                {
                }
                column(SalesShipmentHeader_NumberofPackages; "Sales Shipment Header"."Number of Packages")
                {
                }
                column(SalesShipmentHeader_TotalGrossWeight; "Sales Shipment Header"."Total Gross Weight (Actual)")
                {
                }
                column(SalesShipmentHeader_TotalVolume; "Sales Shipment Header"."Total Volume (Actual)")
                {
                }
                column(ShipmentMethod_Description; ShipmentMethod.Description)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    if ("Sales Shipment Header"."Language Code" <> '') and ("Sales Shipment Header"."Language Code" <> 'ESP') then begin
                        //ini - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
                        //CurrReport.Language := Language.GetLanguageID("Sales Shipment Header"."Language Code");
                        CurrReport.Language := cLanguage.GetLanguageID("Sales Shipment Header"."Language Code");
                        //fin - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
                    end;
                    if not Country.Get("Sales Shipment Header"."Ship-to Country/Region Code") then Clear(Country);
                    if not ShipmentMethod.Get("Sales Shipment Header"."Shipment Method Code") then Clear(ShipmentMethod);
                end;
            }
        }
    }
    requestpage
    {
        layout
        {
        }
        actions
        {
        }
    }
    labels
    {
    }
    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        ReportTitleLbl: label 'Transport Shipment', comment = 'ESP="Albarán de transporte"';
        PhoneNoCaptionLbl: label 'Phone:', comment = 'ESP="Tel."';
        FaxNoCaptionLbl: label 'Fax:', comment = 'ESP="Fax:"';
        CompanyCountryCaptionLbl: Label '(Spain)', comment = 'ESP="(España)"';
        PageNoCaptionLbl: label 'Page', comment = 'ESP="Pág."';
        ShipNumberCaptionLbl: label 'Ship. Number', comment = 'ESP="Núm. albarán"';
        ShipmentDateCaptionLbl: label 'Shipment Date', comment = 'ESP="Fecha albarán"';
        TransportDateCaptionLbl: label 'Transport Date', comment = 'ESP="Fecha transporte"';
        ShippingAggentCaptionLbl: label 'Shipping agent', comment = 'ESP="Transportista"';
        VehicleRegCaptionLbl: label 'Vehicle reg. number', comment = 'ESP="Matrícula del vehículo"';
        TotalPackagesCaptionLbl: label 'Total Packages', comment = 'ESP="Total bultos"';
        TotalWeigthCaptionLbl: label 'Total Weight', comment = 'ESP="Total peso"';
        DatePrintedCaptionLbl: label 'Printed on %1 at %2', comment = 'ESP="Impreso el %1 a las %2"';
        DeliveryNoteCaptionLbl: label 'Delivery Note', comment = 'ESP="Albarán de entrega"';
        //ini - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
        //Language: Record Language;
        cLanguage: Codeunit Language;
        //fin - Method 'GetLanguageId' is marked for removal. Reason: Please use function with the same name from this modules facade codeunit 43 - "Language".. Tag: 16.0.
        RefNumberCaptionLbl: label 'Ref. No.', comment = 'ESP="Nº Ref."';
        ShipMethodCaptionLbl: label 'Ship. Method', comment = 'ESP="Portes"';
        ReferenceCaptionLbl: label 'Reference', comment = 'ESP="Referencia"';
        ReceiverCaptionLbl: label 'Receiver', comment = 'ESP="Destinatario"';
        PackagesCaptionLbl: label 'Packages', comment = 'ESP="Bultos"';
        WeigthCaptionLbl: label 'Weight (KG)', comment = 'ESP="Peso (KG)"';
        VolumeCaptionLbl: label 'Volume (m3)', comment = 'ESP="Volumen (m3)"';
        Country: Record "Country/Region";
        ShipmentMethod: Record "Shipment Method";
}
