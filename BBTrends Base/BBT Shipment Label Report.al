Report 50009 "Shipment Label"
{
    // //INC-2017-03-70215. en layout para CurrentLabel y totalLabel se hacen mas grandes y la letra de 48 a 43
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/Shipment Label.rdl';
    Caption = 'Shipment Label', comment = 'ESP="Etiquetas Envío"';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Company_Logo; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            column(ReportForNavId_1100234022; 1100234022)
            { }
            column(CompanyInfo_Logo; CompanyInfo.Picture)
            { }
        }
        dataitem(Label_Captions; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            column(ReportForNavId_1100234004; 1100234004)
            { }
            column(ShipToCaption; ShipToCaptionLbl)
            { }
            column(ShippingAgentCaption; ShippingAgentCaptionLbl)
            { }
            column(ShipmentNoCaption; ShipmentNoCaptionLbl)
            { }
            column(ShipmentDateCaption; ShipmentDateCaptionLbl)
            { }
            column(ReferenceCaption; ReferenceCaptionLbl)
            { }
            column(CompanyInfo_Data; CompanyInfo.Name + ' ' + CompanyInfo.Address + ' ' + CompanyInfo."Post Code" + ' ' + CompanyInfo.City + ' ' + CompanyInfo.County)
            { }
            dataitem("Sales Shipment Header"; "Sales Shipment Header")
            {
                DataItemTableView = sorting("No.");
                RequestFilterFields = "No.", "Posting Date";

                column(ReportForNavId_1100234000; 1100234000)
                { }
                dataitem(Label_Number; "Integer")
                {
                    DataItemTableView = sorting(Number);

                    column(ReportForNavId_1100234013; 1100234013)
                    { }
                    column(ShippingAggent_Name; ShippingAggent.Name)
                    { }
                    column(SalesShipmentHeader_No; "Sales Shipment Header"."No.")
                    { }
                    column(SalesShipmentHeader_PostingDate; "Sales Shipment Header"."Posting Date")
                    { }
                    column(SalesShipmentHeader_ShiptoName; "Sales Shipment Header"."Ship-to Name")
                    { }
                    column(SalesShipmentHeader_ShiptoAddress; "Sales Shipment Header"."Ship-to Address")
                    { }
                    column(SalesShipmentHeader_ShiptoPostCode; "Sales Shipment Header"."Ship-to Post Code")
                    { }
                    column(SalesShipmentHeader_ShiptoCity; "Sales Shipment Header"."Ship-to City")
                    { }
                    column(SalesShipmentHeader_ShiptoCounty; "Sales Shipment Header"."Ship-to County")
                    { }
                    column(SalesShipmentHeader_ExternalDocumentNo; "Sales Shipment Header"."External Document No.")
                    { }
                    column(SalesShipmentHeader_ShiptoCountryRegionCode; Country.Name)
                    { }
                    column(CurrentLabel; CurrentLabel)
                    { }
                    column(TotalLabels; TotalLabels)
                    { }
                    trigger OnAfterGetRecord()
                    begin
                        CurrentLabel += 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        CurrentLabel := 0;
                        Label_Number.SetRange(Label_Number.Number, 1, TotalLabels);
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    if not ShippingAggent.Get("Sales Shipment Header"."Shipping Agent Code") then Clear(ShippingAggent);
                    if not Country.Get("Sales Shipment Header"."Ship-to Country/Region Code") then Clear(Country);
                    TotalLabels := "Number of Packages";
                    if TotalLabels = 0 then TotalLabels := 1;
                end;
            }
        }
    }
    requestpage
    {
        layout
        { }
        actions
        { }
    }
    labels
    { }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        ShippingAggent: Record "Shipping Agent";
        ShipToCaptionLbl: label 'Ship-to', comment = 'ESP="Destinatario"';
        ShippingAgentCaptionLbl: label 'Shipping Agent', comment = 'ESP="Transportista"';
        ShipmentNoCaptionLbl: label 'Shipment No.', comment = 'ESP="Albarán"';
        ShipmentDateCaptionLbl: label 'Shipment Date', comment = 'ESP="Fecha albarán"';
        Country: Record "Country/Region";
        TotalLabels: Integer;
        CurrentLabel: Integer;
        ReferenceCaptionLbl: label 'Reference', comment = 'ESP="Referencia"';
}
