Report 50071 "BBT Whse. - Shipment"
//fin - The application object identifier '7317' is not valid. It must be within the allowed ranges '[50000..90500]'.
//    - An application object of type 'Report' with name 'Whse. - Shipment' is already declared by the extension 'Base Application by Microsoft (21.5.53619.54899)'
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/Whse. - Shipment.rdl';
    Caption = 'Whse. - Shipment', comment = 'ESP="Alm. - Envío"';
    UsageCategory = Documents;

    dataset
    {
        dataitem("Warehouse Shipment Header"; "Warehouse Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";

            column(ReportForNavId_5944; 5944)
            { }
            column(HeaderNo_WhseShptHeader; "Warehouse Shipment Header"."No.")
            { }
            column(CompanyPicture; rCompanyInformation.Picture)
            { }
            column(CompanyName; COMPANYNAME)
            { }
            column(TodayFormatted; Format(Today, 0, 4))
            { }
            column(AssUid__WhseShptHeader; "Warehouse Shipment Header"."Assigned User ID")
            {
                IncludeCaption = true;
            }
            column(HrdLocCode_WhseShptHeader; "Warehouse Shipment Header"."Location Code")
            {
                IncludeCaption = true;
            }
            column(HeaderNo1_WhseShptHeader; "Warehouse Shipment Header"."No.")
            {
                IncludeCaption = true;
            }
            column(Show1; not Location."Bin Mandatory")
            { }
            column(Show2; Location."Bin Mandatory")
            { }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            { }
            column(WarehouseShipmentCaption; WarehouseShipmentCaptionLbl)
            { }
            column(Cliente; Cliente)
            { }
            column(NombreEnvio; rPedido."Ship-to Name")
            { }
            column(Direccion1; rPedido."Ship-to Address")
            { }
            column(Direccion2; rPedido."Ship-to Address 2")
            { }
            column(CodPostal; rPedido."Ship-to Post Code")
            { }
            column(Poblacion; rPedido."Ship-to City")
            { }
            column(Provincia; rPedido."Ship-to County")
            { }
            column(NombrePais; UpperCase(rCountry.Name))
            { }
            dataitem("Warehouse Shipment Line"; "Warehouse Shipment Line")
            {
                DataItemLink = "No." = field("No.");
                DataItemLinkReference = "Warehouse Shipment Header";
                DataItemTableView = sorting("No.", "Line No.");

                column(ReportForNavId_6896; 6896)
                { }
                column(ShelfNo_WhseShptLine; "Warehouse Shipment Line"."Shelf No.")
                {
                    IncludeCaption = true;
                }
                column(ItemNo_WhseShptLine; "Warehouse Shipment Line"."Item No.")
                {
                    IncludeCaption = true;
                }
                column(Desc_WhseShptLine; "Warehouse Shipment Line".Description)
                {
                    IncludeCaption = true;
                }
                column(UomCode_WhseShptLine; "Warehouse Shipment Line"."Unit of Measure Code")
                {
                    IncludeCaption = true;
                }
                column(LocCode_WhseShptLine; "Warehouse Shipment Line"."Location Code")
                {
                    IncludeCaption = true;
                }
                column(Qty_WhseShptLine; "Warehouse Shipment Line".Quantity)
                {
                    IncludeCaption = true;
                }
                column(SourceNo_WhseShptLine; "Warehouse Shipment Line"."Source No.")
                {
                    IncludeCaption = true;
                }
                column(SourceDoc_WhseShptLine; "Warehouse Shipment Line"."Source Document")
                {
                    IncludeCaption = true;
                }
                column(ZoneCode_WhseShptLine; "Warehouse Shipment Line"."Zone Code")
                {
                    IncludeCaption = true;
                }
                column(BinCode_WhseShptLine; "Warehouse Shipment Line"."Bin Code")
                {
                    IncludeCaption = true;
                }
                column(CdadEnviar; "Warehouse Shipment Line"."Qty. to Ship")
                { }
                column(Lotes; Lotes)
                { }
                trigger OnAfterGetRecord()
                begin
                    GetLocation("Warehouse Shipment Line"."Location Code");
                    Lotes := '';
                    rReservas.Reset();
                    rReservas.SetRange("Item No.", "Warehouse Shipment Line"."Item No.");
                    rReservas.SetRange("Source ID", "Warehouse Shipment Line"."Source No.");
                    if rReservas.FindSet() then
                        repeat //    Lotes:=Lotes+rReservas."Lot No."+':  [ '+FORMAT(ABS(rReservas.Quantity))+' ];  ';
                            if Lotes = '' then
                                Lotes := Lotes + rReservas."Lot No."
                            else
                                Lotes := Lotes + ' - ' + rReservas."Lot No.";
                        until rReservas.Next = 0;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                GetLocation("Warehouse Shipment Header"."Location Code");
                "Warehouse Shipment Header".CalcFields("Source No.");
                Cliente := '';
                rPedido.Reset();
                rPedido.SetRange("No.", "Warehouse Shipment Header"."Source No.");
                rPedido.SetRange("Document Type", rPedido."document type"::Order);
                if rPedido.FindSet() then Cliente := rPedido."Sell-to Customer No." + ' - ' + rPedido."Sell-to Customer Name";
                rCountry.Reset;
                rCountry.SetRange(Code, rPedido."Ship-to Country/Region Code");
                if rCountry.FindFirst then;
            end;
        }
    }
    requestpage
    {
        Caption = 'Whse. - Posted Shipment', comment = 'ESP="Alm. - Envío regis."';

        layout
        { }
        actions
        { }
    }
    labels
    {
    }
    trigger OnInitReport()
    begin
        rCompanyInformation.Get;
        rCompanyInformation.CalcFields(Picture);
    end;

    var
        Location: Record Location;
        CurrReportPageNoCaptionLbl: label 'Page', comment = 'ESP="Pág."';
        WarehouseShipmentCaptionLbl: label 'Warehouse Shipment', comment = 'ESP="Envío almacén"';
        rPedido: Record "Sales Header";
        rReservas: Record "Reservation Entry";
        rCompanyInformation: Record "Company Information";
        rCountry: Record "Country/Region";
        Lotes: Text;
        Cliente: Text;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Location.Init
        else if Location.Code <> LocationCode then Location.Get(LocationCode);
    end;
}
