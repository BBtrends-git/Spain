Report 50008 "Customer - Outstd. Order Lines"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Report/Layouts/Customer - Outstd. Order Lines.rdl';
    Caption = 'Customer - Order Lines', comment = 'ESP="Clientes - Líneas pedido"';

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = sorting("Document Type", "Bill-to Customer No.", "Currency Code") where("Document Type" = const(Order), Type = const(Item), "Outstanding Quantity" = filter(<> 0));
            RequestFilterFields = "Sell-to Customer No.", "Posting Date";
            RequestFilterHeading = 'Sales Order Line', comment = 'ESP="Línea de pedido de venta"';

            column(ReportForNavId_2844; 2844)
            { }
            column(CompanyName; COMPANYNAME)
            { }
            column(SalesOrderLineFilter; StrSubstNo(Text001, SalesLineFilter))
            { }
            column(SalesLineFilter; SalesLineFilter)
            { }
            column(CustOrderDetailCaption; CustOrderDetailCaptionLbl)
            { }
            column(PageCaption; PageCaptionLbl)
            { }
            column(ShipmentDateCaption; ShipmentDateCaptionLbl)
            { }
            column(SalesHeaderNo; SalesHeader."No.")
            { }
            column(SalesHeaderOrderDate; SalesHeader."Order Date")
            { }
            column(SalesHeaderOrderDateCaption; SalesHeader.FieldCaption("Order Date"))
            { }
            column(Description_SalesLine; "Sales Line".Description)
            {
                IncludeCaption = true;
            }
            column(No_SalesLine; "Sales Line"."No.")
            {
                IncludeCaption = true;
            }
            column(ShipmentDate_SalesLine; Format("Sales Line"."Shipment Date"))
            { }
            column(Quantity_SalesLine; "Sales Line"."Outstanding Quantity")
            {
                IncludeCaption = true;
            }
            column(SalesHeaderCurrCode; SalesHeader."Currency Code")
            { }
            column(No_Customer; Customer."No.")
            { }
            column(Name_Customer; Customer.Name)
            { }
            column(NoCaption_Customer; CustomerNoCaptionLbl)
            { }
            column(NameCaption_Customer; CustomerNameCaptionLbl)
            { }
            column(ItemNoCaption; ItemNoCaptionLbl)
            { }
            column(RequestedDeliveryDate_SalesLine; "Sales Line"."Requested Delivery Date")
            {
                IncludeCaption = true;
            }
            column(LineAmount_SalesLine; RemAmt)
            { }
            column(LineAmountCaption; LineAmountCaptionLbl)
            { }
            column(CommentCaption; CommentCaptionLbl)
            { }
            column(PageGroupNo; PageGroupNo)
            { }
            column(CustCounter; CustCounter)
            { }
            column(CommentLine; CommentLine)
            { }
            column(ExtDocNo; SalesHeader."External Document No.")
            { }
            column(ExtDocNoCaption; SalesHeader.FieldCaption("External Document No."))
            { }
            //>> BBT. SMG
            /*
            column(Margin; Format(ROUND("Sales Line"."Margin %", 0.01)))
            { }
            column(MarginLbl; "Sales Line".FieldCaption("Margin %"))
            { }
            */
            column(Margin; Format(ROUND("Sales Line"."SMG Margin %", 0.01)))
            { }
            column(MarginLbl; "Sales Line".FieldCaption("SMG Margin %"))
            { }
            //<<
            column(ServiceZoneCaption; SalesHeader.FieldCaption("Service Zone Code"))
            { }
            column(ServiceZone; SalesHeader."Service Zone Code")
            { }
            trigger OnAfterGetRecord()
            begin
                if (OldCustNo <> '') and (OldCustNo <> "Sales Line"."Bill-to Customer No.") then
                    if PrintOnlyOnePerPage then
                        PageGroupNo := PageGroupNo + 1
                    else
                        CustCounter := CustCounter + 1;
                if not SalesHeader.Get(1, "Sales Line"."Document No.") then Clear(SalesHeader);
                if not Customer.Get("Sales Line"."Bill-to Customer No.") then Clear(Customer);
                Clear(CommentLine);
                SalesCommentLine.Reset;
                SalesCommentLine.SetRange("Document Type", SalesCommentLine."document type"::Order);
                SalesCommentLine.SetRange("No.", "Sales Line"."Document No.");
                SalesCommentLine.SetRange("Document Line No.", "Sales Line"."Line No.");
                if SalesCommentLine.FindSet then
                    repeat
                        if StrLen(CommentLine) = 0 then
                            CommentLine := SalesCommentLine.Comment
                        else
                            CommentLine := CopyStr(CommentLine + ' ' + SalesCommentLine.Comment, 1, MaxStrLen(CommentLine));
                    until SalesCommentLine.Next = 0;
                RemAmt := ("Sales Line"."Line Amount" / "Sales Line".Quantity) * "Sales Line"."Outstanding Quantity";
                OldCustNo := "Sales Line"."Bill-to Customer No.";
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;
                CustCounter := 1;
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

                    field(NewPagePerCustomer; PrintOnlyOnePerPage)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Page per Customer', comment = 'ESP="Página nueva por cliente"';
                    }
                }
            }
        }
        actions
        {
        }
    }
    trigger OnPreReport()
    begin
        SalesLineFilter := "Sales Line".GetFilters;
    end;

    var
        Text001: label 'Sales Order Line: %1', comment = 'ESP="Línea pedido venta: %1"';
        SalesHeader: Record "Sales Header";
        Customer: Record Customer;
        SalesCommentLine: Record "Sales Comment Line";
        SalesLineFilter: Text;
        PeriodText: Text[30];
        PrintOnlyOnePerPage: Boolean;
        PageGroupNo: Integer;
        CustOrderDetailCaptionLbl: label 'Customer - Outstanding Order Detail', comment = 'ESP="Cliente - Líneas pedidos pendientes"';
        PageCaptionLbl: label 'Page', comment = 'ESP="Pág."';
        ShipmentDateCaptionLbl: label 'Shipment Date', comment = 'ESP="Fecha envío"';
        CustomerNoCaptionLbl: label 'Cust. No.', comment = 'ESP="Cód. Cliente"';
        CustomerNameCaptionLbl: label 'Customer Name', comment = 'ESP="Nombre Cliente"';
        ItemNoCaptionLbl: label 'Item No.', comment = 'ESP="Cód. Producto"';
        LineAmountCaptionLbl: label 'Amount', comment = 'ESP="Importe"';
        CustCounter: Integer;
        OldCustNo: Code[20];
        CommentCaptionLbl: label 'Comments', comment = 'ESP="Observaciones"';
        CommentLine: Text[1024];
        RemAmt: Decimal;
}
