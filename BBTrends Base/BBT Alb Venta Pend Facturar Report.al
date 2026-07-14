Report 50026 "Alb.Venta Pend Facturar"
{
    // //LLUIS - Funcionalidades Gepesa
    // F1.04-Funcionalidad Informe de Albaranes pendientes de facturar
    DefaultLayout = RDLC;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/Report/Layouts/Alb.Venta Pend Facturar.rdl';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("Search Name") order(ascending);
            PrintOnlyIfDetail = true;

            column(ReportForNavId_6836; 6836)
            { }
            column(USERID; UserId)
            { }
            column(COMPANYNAME; COMPANYNAME)
            { }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            { }
            // column(CurrReport_PAGENO; CurrReport.PageNo)
            // { }
            column(Customer_Name; Customer.Name)
            { }
            column(Customer__No__; Customer."No.")
            { }
            column(decTotalImportePendiente; decTotalImportePendiente)
            { }
            column(Customer___Order_DetailCaption; Customer___Order_DetailCaptionLbl)
            { }
            column("Pág_Caption"; "Pág_CaptionLbl")
            { }
            column(PedidoCaption; PedidoCaptionLbl)
            { }
            column(DocumentoCaption; DocumentoCaptionLbl)
            { }
            column(F__registroCaption; F__registroCaptionLbl)
            { }
            column("DescripciónCaption"; "DescripciónCaptionLbl")
            { }
            column(CantidadCaption; CantidadCaptionLbl)
            { }
            column(ImporteCaption; ImporteCaptionLbl)
            { }
            column(Precio_unitarioCaption; Precio_unitarioCaptionLbl)
            { }
            column(Fecha_PedidoCaption; Fecha_PedidoCaptionLbl)
            { }
            column(Importe_total_pendiente_Caption; Importe_total_pendiente_CaptionLbl)
            { }
            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemLink = "Sell-to Customer No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.") order(ascending) where("Qty. Shipped Not Invoiced" = filter(<> 0));
                RequestFilterFields = "Shipment Date", "Sell-to Customer No.";

                column(ReportForNavId_2502; 2502)
                { }
                column(Sales_Shipment_Line__Sales_Shipment_Line___Order_No__; "Sales Shipment Line"."Order No.")
                { }
                column(Sales_Shipment_Line__Sales_Shipment_Line___Document_No__; "Sales Shipment Line"."Document No.")
                { }
                column(Fecha_registro; "Sales Shipment Line"."Posting Date")
                { }
                column(Sales_Shipment_Line_Description; "Sales Shipment Line".Description)
                { }
                column(Sales_Shipment_Line__Sales_Shipment_Line___Qty__Shipped_Not_Invoiced_; "Sales Shipment Line"."Qty. Shipped Not Invoiced")
                { }
                column(Sales_Shipment_Line__Sales_Shipment_Line___Unit_Price_; NetUnitPrice)
                { }
                column(Sales_Shipment_Line___Qty__Shipped_Not_Invoiced___Sales_Shipment_Line___Unit_Price_; "Sales Shipment Line"."Qty. Shipped Not Invoiced" * NetUnitPrice)
                { }
                column(FechaPedido; FechaPedido)
                { }
                column(SalesOrderAmount; SalesOrderAmount)
                { }
                column(Sales_Shipment_Line_Line_No_; "Sales Shipment Line"."Line No.")
                { }
                column(Sales_Shipment_Line_Sell_to_Customer_No_; "Sales Shipment Line"."Sell-to Customer No.")
                { }
                column(Divisa; Divisa)
                { }
                trigger OnAfterGetRecord()
                begin
                    if ("Sales Shipment Line".Quantity = "Sales Shipment Line"."Quantity Invoiced") then
                        CurrReport.Skip
                    else
                        SalesOrderLine.Reset;
                    SalesOrderLine.SetRange(SalesOrderLine."Document Type", SalesOrderLine."document type"::Order);
                    SalesOrderLine.SetRange("Document No.", "Sales Shipment Line"."Order No.");
                    SalesOrderLine.SetRange("Line No.", "Sales Shipment Line"."Order Line No.");
                    if SalesOrderLine.FindFirst then begin
                        NetUnitPrice := ROUND(SalesOrderLine.Amount / SalesOrderLine.Quantity, 0.01);
                        SalesOrderAmount := "Sales Shipment Line".Quantity * NetUnitPrice;
                    end;
                    RecSalesHeader.Reset;
                    RecSalesHeader.SetRange(RecSalesHeader."No.", "Sales Shipment Line"."Document No.");
                    if RecSalesHeader.Find('-') then begin
                        FechaPedido := RecSalesHeader."Order Date";
                        Fecharegistro := RecSalesHeader."Posting Date";
                        Divisa := RecSalesHeader."Currency Code";
                    end;
                    decTotalImportePendiente := decTotalImportePendiente + SalesOrderAmount;
                end;

                trigger OnPreDataItem()
                begin
                    //>> Obsoleto
                    //CurrReport.CreateTotals(SalesOrderAmount);
                    //<<
                end;
            }
            trigger OnPreDataItem()
            begin
                decTotalImportePendiente := 0;
            end;
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
    {
    }
    var
        SalesOrderAmount: Decimal;
        RecSalesHeader: Record "Sales Shipment Header";
        FechaPedido: Date;
        decTotalImportePendiente: Decimal;
        Fecharegistro: Date;
        Customer___Order_DetailCaptionLbl: label 'Customer - Order Detail', comment = 'ESP="Albaranes venta pendientes facturar"';
        "Pág_CaptionLbl": label 'Pág.';
        PedidoCaptionLbl: label 'Pedido';
        DocumentoCaptionLbl: label 'Documento';
        F__registroCaptionLbl: label 'F. registro';
        "DescripciónCaptionLbl": label 'Descripción';
        CantidadCaptionLbl: label 'Cantidad';
        ImporteCaptionLbl: label 'Importe';
        Precio_unitarioCaptionLbl: label 'Precio unitario';
        Fecha_PedidoCaptionLbl: label 'Fecha Pedido';
        Importe_total_pendiente_CaptionLbl: label 'Importe total pendiente:';
        Divisa: Code[10];
        NetUnitPrice: Decimal;
        SalesOrderLine: Record "Sales Line";
}
