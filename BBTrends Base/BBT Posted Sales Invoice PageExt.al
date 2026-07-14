PageExtension 50133 "BBT Posted Sales Invoice" extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Order No.")
        {
            field("Warehouse Shipment Nº"; WarehouseShipNo)
            {
                ApplicationArea = Basic;
                Caption = 'Nº envío';
                Editable = false;
                TableRelation = "Posted Whse. Shipment Header";
            }
            field("Sales Shipment Nº"; ShipmentNo)
            {
                ApplicationArea = Basic;
                Caption = 'Nº albarán';
                Editable = false;
                TableRelation = "Sales Shipment Header";
            }
        }
    }
    actions
    {
        addafter("&Navigate")
        {
            action("Imp. Factura Export")
            {
                ApplicationArea = Basic;
                Caption = 'Print Export Invoice', Comment = 'ESP="Imp. Factura Export"';
                Image = PrintForm;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category6;
                Visible = true;

                trigger OnAction()
                var
                    rSalesInvoiceHeader: Record "Sales Invoice Header";
                begin
                    rSalesInvoiceHeader.SetRange("No.", Rec."No.");
                    if rSalesInvoiceHeader.FindFirst then
                        Report.Run(51101, true, true, rSalesInvoiceHeader);
                end;
            }
        }
    }
    var
        ShipmentNo: Code[20];
        WarehouseShipNo: Code[20];
        ValueEntry: Record "Value Entry";
        ValueEntryAux: Record "Value Entry";
        SalesShipmentHeader: Record "Sales Shipment Header";

    trigger OnAfterGetRecord()
    begin
        //>> BBT 14/05/2021
        ShipmentNo := '';
        WarehouseShipNo := '';
        ValueEntryAux.RESET;
        ValueEntryAux.SETCURRENTKEY("Document No.");
        ValueEntryAux.SETRANGE("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
        ValueEntryAux.SetRange("Source Type", ValueEntry."Source Type"::Customer);
        ValueEntryAux.SetRange("Source No.", Rec."Bill-to Customer No.");
        ValueEntryAux.SETRANGE("Document Type", ValueEntry."Document Type"::"Sales Invoice");
        ValueEntryAux.SETRANGE("Document No.", rec."No.");
        IF ValueEntryAux.FINDFIRST THEN BEGIN
            ValueEntry.RESET;
            ValueEntry.SETRANGE("Item Ledger Entry No.", ValueEntryAux."Item Ledger Entry No.");
            ValueEntry.SETRANGE("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
            ValueEntry.SETRANGE("Document Type", ValueEntry."Document Type"::"Sales Shipment");
            ValueEntry.SetRange("Source Type", ValueEntryAux."Source Type");
            ValueEntry.SetRange("Source No.", ValueEntryAux."Source No.");
            IF ValueEntry.FINDFIRST THEN BEGIN
                ShipmentNo := ValueEntry."Document No.";
                SalesShipmentHeader.RESET;
                SalesShipmentHeader.SETRANGE("No.", ShipmentNo);
                IF SalesShipmentHeader.FINDFIRST THEN BEGIN
                    // - Incidencia 133
                    //WarehouseShipNo := SalesShipmentHeader."Warehose Ship No.2";
                    SalesShipmentHeader.CalcFields("Warehose Ship No.");
                    WarehouseShipNo := SalesShipmentHeader."Warehose Ship No.";
                    // + Incidencia 133
                END;
            END;
        END;
        //<< BBT 14/05/2021
    end;

    trigger OnOpenPage()
    begin
        rec.CalcFields("Sales Shipment No");
    end;

}
