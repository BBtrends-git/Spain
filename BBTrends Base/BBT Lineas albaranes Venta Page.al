Page 50046 "Lineas albaranes Venta"
{
    Editable = false;
    PageType = List;
    SourceTable = "Sales Shipment Line";
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Venta a-Nombre"; SalesShipmentHeader."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field("Cód. vendedor"; SalesShipmentHeader."Salesperson Code")
                {
                    ApplicationArea = Basic;
                }
                field("Nº pedido"; SalesShipmentHeader."Order No.")
                {
                    ApplicationArea = Basic;
                }
                field("Nº documento externo"; SalesShipmentHeader."External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Nº envio"; ShipNo)
                {
                    ApplicationArea = Basic;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Qty. Shipped Not Invoiced"; Rec."Qty. Shipped Not Invoiced")
                {
                    ApplicationArea = Basic;
                }
                field("Precio venta"; NetUnitPrice)
                {
                    ApplicationArea = Basic;
                }
                field(Importe; SalesOrderAmount)
                {
                    ApplicationArea = Basic;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Actualizar)
            {
                ApplicationArea = Basic;
                Caption = 'Actualizar Documento';
                Visible = true;
                Enabled = true;
                RunPageMode = Edit;
                Image = DocumentEdit;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                RunObject = page "BBT Lin Albaran Venta Upd";
                RunPageLink = "Document No." = field("Document No."), "Line No." = field("Line No.");

            }
        }
    }
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        ShipNo: Code[20];
        Amount: Decimal;
        AmountInclVat: Decimal;
        SalesOrderLine: Record "Sales Line";
        NetUnitPrice: Decimal;
        SalesOrderAmount: Decimal;

    trigger OnAfterGetRecord()
    begin
        SalesShipmentHeader.Get(Rec."Document No.");
        SalesShipmentHeader.CalcFields(SalesShipmentHeader."Warehose Ship No.");
        ShipNo := SalesShipmentHeader."Warehose Ship No.";
        SalesOrderLine.Reset;
        SalesOrderLine.SetRange(SalesOrderLine."Document Type", SalesOrderLine."document type"::Order);
        SalesOrderLine.SetRange("Document No.", Rec."Order No.");
        SalesOrderLine.SetRange("Line No.", Rec."Order Line No.");
        if SalesOrderLine.FindFirst then begin
            if SalesOrderLine.Quantity <> 0 then begin
                NetUnitPrice := ROUND(SalesOrderLine.Amount / SalesOrderLine.Quantity, 0.01);
                SalesOrderAmount := Rec.Quantity * NetUnitPrice;
            end
            else begin
                NetUnitPrice := 0;
                SalesOrderAmount := 0;
            end;
        end;
    end;
}
