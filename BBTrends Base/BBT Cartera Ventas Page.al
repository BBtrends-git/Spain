Page 50030 "Cartera Ventas"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Sales Line";
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Order Date"; FechaPedido)
                {
                    ApplicationArea = Basic;
                    Caption = 'Order date';
                }
                field("Reason Code"; StatusAuditoria)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reason Code';
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field("Customer Name"; NombreCliente)
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer Name';
                }
                field("Salesperson Code"; NoVendedor)
                {
                    ApplicationArea = Basic;
                    Caption = 'Salesperson Code';
                }
                field("Salesperson Name"; NombreVendedor)
                {
                    ApplicationArea = Basic;
                    Caption = 'Salesperson Name';
                }
                field("Ship-to Country"; PaisEnvio)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-to Country';
                }
                field(DocExterno; DocExterno)
                {
                    ApplicationArea = Basic;
                    Caption = 'External Document';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = Basic;
                    StyleExpr = ColorTxt;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Outstanding amount"; AmountPdte)
                {
                    ApplicationArea = Basic;
                    Caption = 'Outstanding amount';
                }
                field("Outstandig amount (DL)"; AmountPdteDL)
                {
                    ApplicationArea = Basic;
                    Caption = 'Outstandig amout (LCY)';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("Inventory Location"; InvLocation)
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory Location';
                }
                field("Inventory in other locations"; InvOtherLocations)
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory in  other locations';
                }
                field("Qty on Sales Order"; QtySalesOrder)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. on Sales Order';
                }
                field("Qty on Aprov. Order"; QtyAprovOrder)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty on Aprov. Order';
                }
                field("Base Unit of Measure"; UDMBase)
                {
                    ApplicationArea = Basic;
                    Caption = 'Base Unit of Measure';
                }
                field("Unit Aprov. Order"; UDMAprovOrder)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit Aprov. Order';
                    Enabled = false;
                    Visible = false;
                }
                field("Aprov. Order"; AprovOrder)
                {
                    ApplicationArea = Basic;
                    Caption = 'Aprov. Order';
                }
                field("Provisioning Date"; DataAprovOrder)
                {
                    ApplicationArea = Basic;
                    Caption = 'Provisioning Date';
                }
                field("Whse. Shipment Document"; NoDEA)
                {
                    ApplicationArea = Basic;
                    Caption = 'Whse. Shipment Document';
                }
                field("Status DEA"; StatusDEA)
                {
                    ApplicationArea = Basic;
                    Caption = 'Status DEA';
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Qty. to Ship"; Rec."Qty. to Ship")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Quantity Shipped"; Rec."Quantity Shipped")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Shipped Not Invoiced"; Rec."Shipped Not Invoiced")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Qty. Shipped Not Invoiced"; Rec."Qty. Shipped Not Invoiced")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Qty. to Invoice"; Rec."Qty. to Invoice")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Outstanding Amount (LCY)"; Rec."Outstanding Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Shipped Not Invoiced (LCY)"; Rec."Shipped Not Invoiced (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("VAT Base Amount"; Rec."VAT Base Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Completely Shipped"; Rec."Completely Shipped")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Promised Delivery Date"; Rec."Promised Delivery Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Planned Delivery Date"; Rec."Planned Delivery Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Planned Shipment Date"; Rec."Planned Shipment Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                //>> BBT. SMG
                /*
                field("Blocked for Short Margin"; Rec."Blocked for Short Margin")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Margin %"; Rec."Margin %")
                {
                    ApplicationArea = Basic;
                }
                */
                field("Blocked for Short Margin"; Rec."SMG Blocked for Short Margin")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Margin %"; Rec."SMG Margin %")
                {
                    ApplicationArea = Basic;
                }
                //<<
                field("Item Tracking Code"; Rec."Item Tracking Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                //>> BBT 01/07/2025
                /*
                field("Lot Nos."; Rec."Lot Nos.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                */
                //<<
            }
        }
        area(factboxes)
        {
            part(Control1000000271; "Customer Details FactBox")
            {
                SubPageLink = "No." = field("Sell-to Customer No.");
            }
            part(Control1000000270; "Sales Line FactBox")
            {
                SubPageLink = "Document Type" = field("Document Type"), "Document No." = field("Document No."), "Line No." = field("Line No.");
            }
            part(Control1000000269; "Item Warehouse FactBox")
            {
                SubPageLink = "No." = field("No.");
            }
        }
    }
    actions
    {
    }
    trigger OnAfterGetRecord()
    begin
        // Datos Producto - cantidades
        Rec.CalcFields("Inventoy Location Code");
        InvLocation := Rec."Inventoy Location Code";
        if RItem.Get(Rec."No.") then;
        RItem.CalcFields(Inventory);
        InvOtherLocations := RItem.Inventory - Rec."Inventoy Location Code";
        UDMBase := RItem."Base Unit of Measure";
        if Rec."Posting Group" = 'NOSTOCK' then begin
            InvLocation := 0;
            InvOtherLocations := 0;
        end;
        RItem.CalcFields("Qty. on Sales Order");
        QtySalesOrder := RItem."Qty. on Sales Order";
        RItem.CalcFields("Qty. on Prod. Order");
        QtyProdOrder := RItem."Qty. on Prod. Order";
        RItem.CalcFields("Qty. on Purch. Order");
        QtyPurchOrder := RItem."Qty. on Purch. Order";
        // Datos Pedido Venta
        RSalesHeader.Reset;
        RSalesHeader.SetRange("Document Type", Rec."Document Type");
        RSalesHeader.SetRange("No.", Rec."Document No.");
        if RSalesHeader.FindFirst then;
        DocExterno := RSalesHeader."External Document No.";
        NombreCliente := RSalesHeader."Bill-to Name";
        FechaPedido := RSalesHeader."Order Date";
        PaisEnvio := RSalesHeader."Ship-to Country/Region Code";
        // Status Auditoria Pedido Venta - Reason Code
        StatusAuditoria := '';
        rReasonCode.Reset;
        rReasonCode.SetRange(Code, RSalesHeader."Reason Code");
        if rReasonCode.FindFirst then StatusAuditoria := rReasonCode.Description;
        // Datos Vendedor
        NoVendedor := RSalesHeader."Salesperson Code";
        NombreVendedor := '';
        rSalespersonPurchaser.Reset;
        rSalespersonPurchaser.SetRange(Code, NoVendedor);
        if rSalespersonPurchaser.FindFirst then NombreVendedor := rSalespersonPurchaser.Name;
        // Datos Compras
        PurchOrder := '';
        UDMPurchOrder := '';
        DataPurchOrder := '';
        if QtyPurchOrder > 0 then begin
            RPurchaseLine.Reset;
            RPurchaseLine.SetRange("Document Type", RPurchaseLine."document type"::Order);
            RPurchaseLine.SetRange(Type, RPurchaseLine.Type::Item);
            RPurchaseLine.SetRange("No.", Rec."No.");
            RPurchaseLine.SetFilter("Outstanding Quantity", '> %1', 0);
            if RPurchaseLine.FindFirst then begin
                PurchOrder := RPurchaseLine."Document No.";
                UDMPurchOrder := RPurchaseLine."Unit of Measure Code";
                DataPurchOrder := Format(RPurchaseLine."Order Date");
            end;
        end;
        // Datos Produccion
        ProdOrder := '';
        UDMProdOrder := '';
        DataProdOrder := '';
        if QtyProdOrder > 0 then begin
            // Buscar si el pedido está relacionado con una OF
            RProductionOrder.Reset;
            RProductionOrder.SetRange("Source Type", RProductionOrder."source type"::Item);
            RProductionOrder.SetRange("Source No.", Rec."No.");
            RProductionOrder.SetFilter(Status, '%1..%2', 2, 3);
            RProductionOrder.SetRange("Cód. Pedido", Rec."Document No.");
            if RProductionOrder.FindFirst then begin
                RProdOrderLine.Reset;
                RProdOrderLine.SetRange("Prod. Order No.", RProductionOrder."No.");
                RProdOrderLine.SetFilter("Remaining Quantity", '> %1', 0);
                if RProdOrderLine.FindFirst then begin
                    ProdOrder := RProductionOrder."No.";
                    UDMProdOrder := RProdOrderLine."Unit of Measure Code";
                    DataProdOrder := Format(RProdOrderLine."Ending Date");
                end;
            end;
            // Si no esta relacionado se busca por si está planificado Manual o MPS
            if ProdOrder = '' then begin
                RProductionOrder.Reset;
                RProductionOrder.SetRange("Source Type", RProductionOrder."source type"::Item);
                RProductionOrder.SetRange("Source No.", Rec."No.");
                RProductionOrder.SetFilter(Status, '%1..%2', 2, 3);
                RProductionOrder.SetFilter("Cód. Pedido", '= %1', '');
                if RProductionOrder.FindFirst then begin
                    RProdOrderLine.Reset;
                    RProdOrderLine.SetRange("Prod. Order No.", RProductionOrder."No.");
                    RProdOrderLine.SetFilter("Remaining Quantity", '> %1', 0);
                    if RProdOrderLine.FindFirst then begin
                        ProdOrder := RProductionOrder."No.";
                        UDMProdOrder := RProdOrderLine."Unit of Measure Code";
                        DataProdOrder := Format(RProdOrderLine."Ending Date");
                    end;
                end;
            end;
        end;
        if ProdOrder = '' then QtyProdOrder := 0;
        // Consolidamos datos Aprovisionamiento - Producción o Compras.
        AprovOrder := '';
        UDMAprovOrder := '';
        QtyAprovOrder := 0;
        DataAprovOrder := '';
        if QtyPurchOrder > 0 then begin
            AprovOrder := PurchOrder;
            QtyAprovOrder := QtyPurchOrder;
            UDMAprovOrder := UDMPurchOrder;
            DataAprovOrder := DataPurchOrder;
        end;
        if QtyProdOrder > 0 then begin
            AprovOrder := ProdOrder;
            QtyAprovOrder := QtyProdOrder;
            UDMAprovOrder := UDMProdOrder;
            DataAprovOrder := DataProdOrder;
        end;
        // Datos Envio
        NoDEA := '';
        StatusDEA := '';
        RWhseShipmentLine.Reset;
        RWhseShipmentLine.SetRange("Source No.", Rec."Document No.");
        RWhseShipmentLine.SetRange("Source Line No.", Rec."Line No.");
        RWhseShipmentLine.SetRange("Item No.", Rec."No.");
        if RWhseShipmentLine.FindFirst then begin
            NoDEA := RWhseShipmentLine."No.";
            RWhseShipmentHeader.Reset;
            RWhseShipmentHeader.SetRange("No.", RWhseShipmentLine."No.");
            if RWhseShipmentHeader.FindFirst then StatusDEA := Format(RWhseShipmentHeader.Status);
        end;
        // Calculo del importe en DL
        AmountPdte := Rec."Outstanding Quantity" * Rec."Unit Price";
        AmountPdteDL := AmountPdte;
        if RSalesHeader."Currency Code" <> '' then AmountPdteDL := AmountPdte / RSalesHeader."Currency Factor";
        // Semaforo Advertencia
        ColorTxt := 'Standard';
        if Rec."Outstanding Qty. (Base)" <= QtyAprovOrder then ColorTxt := 'Ambiguous';
        //IF "Outstanding Quantity" <= "Inventoy Location Code" THEN
        if Rec."Outstanding Qty. (Base)" <= RItem.Inventory then ColorTxt := 'Favorable';
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange(Rec."Document Type", Rec."document type"::Order);
        Rec.SetRange(Rec.Type, Rec.Type::Item);
        Rec.SetRange(Rec."Completely Shipped", false);
        Rec.SetFilter(Rec."Outstanding Quantity", '<>%1', 0);
        //SETFILTER("Posting Group" ,'<>%1','NOSTOCK');
        //SETRANGE("No.",'APRE023416');
    end;

    var
        InvLocation: Decimal;
        InvOtherLocations: Decimal;
        QtyProdOrder: Decimal;
        QtySalesOrder: Decimal;
        QtyPurchOrder: Decimal;
        QtyAprovOrder: Decimal;
        UDMAprovOrder: Code[10];
        UDMPurchOrder: Code[10];
        UDMProdOrder: Code[10];
        UDMBase: Code[10];
        RItem: Record Item;
        AprovOrder: Code[20];
        ProdOrder: Code[20];
        PurchOrder: Code[20];
        RProductionOrder: Record "Production Order";
        RProdOrderLine: Record "Prod. Order Line";
        RSalesLine: Record "Sales Line";
        PaisEnvio: Code[10];
        DocExterno: Text[50];
        NombreCliente: Text[50];
        FechaPedido: Date;
        RSalesHeader: Record "Sales Header";
        RWhseShipmentLine: Record "Warehouse Shipment Line";
        RWhseShipmentHeader: Record "Warehouse Shipment Header";
        RPurchaseLine: Record "Purchase Line";
        NoDEA: Code[20];
        StatusDEA: Text[50];
        AmountPdteDL: Decimal;
        AmountPdte: Decimal;
        ColorTxt: Text[20];
        DataPurchOrder: Text[10];
        DataProdOrder: Text[10];
        DataAprovOrder: Text[10];
        NoVendedor: Code[10];
        NombreVendedor: Text[50];
        rSalespersonPurchaser: Record "Salesperson/Purchaser";
        rReasonCode: Record "Reason Code";
        StatusAuditoria: Text[50];
}
