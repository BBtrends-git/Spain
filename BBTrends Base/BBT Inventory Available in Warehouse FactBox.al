page 51120 "BBT Available in Warehouse"
{
    Caption = 'Inventory Available', Comment = 'ESP="Disponibilidad"';
    Editable = false;
    PageType = CardPart;
    SourceTable = "Item";
    UsageCategory = None;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;

                field(QuantityInWarehouse; QuantityInWarehouse)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity In Warehouse', Comment = 'ESP="Existencia en Almacén"';
                    DecimalPlaces = 0 : 5;
                }
                field(QuantityInShipments; QuantityInShipments)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity In Shipments', Comment = 'ESP="Existencia en Envío"';
                    DecimalPlaces = 0 : 5;
                }
                field(QuantityInTransfers; QuantityInTransfers)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity In Transfers', Comment = 'ESP="Existencia en Transferencias"';
                    DecimalPlaces = 0 : 5;
                }
                field(QuantityAvalilable; QuantityAvalilable)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity Avalilable', Comment = 'ESP="Existencia Disponible"';
                    DecimalPlaces = 0 : 5;
                    StyleExpr = ColorTxt;
                }
            }
        }
    }

    var
        LocationFilter: Code[10];
        QuantityInWarehouse: Decimal;
        QuantityInShipments: Decimal;
        QuantityInTransfers: Decimal;
        QuantityAvalilable: Decimal;
        ColorTxt: Text;

    trigger OnAfterGetCurrRecord()
    begin
        Clear(QuantityInWarehouse);
        Clear(QuantityInShipments);
        Clear(QuantityInTransfers);
        Clear(QuantityAvalilable);
        CalculateInventory();
        CalculateProductToShipping();
        CalculateProductToTransfer();
        QuantityAvalilable := QuantityInWarehouse - (QuantityInShipments + QuantityInTransfers);
        ColorTxt := 'Standard';
        if QuantityAvalilable < 0 then begin
            QuantityAvalilable := 0;
            ColorTxt := 'Unfavorable';
        end;
    end;

    local procedure CalculateInventory()
    begin
        if Rec."No." <> '' then begin
            Rec.SetRange("Location Filter", LocationFilter);
            Rec.CalcFields(Inventory);
            QuantityInWarehouse := Rec.Inventory;
        end;
    end;


    local procedure CalculateProductToShipping();
    var
        rWarehouseShipmentLine: Record "Warehouse Shipment Line";
    begin
        rWarehouseShipmentLine.Reset();
        rWarehouseShipmentLine.SetRange("Item No.", Rec."No.");
        rWarehouseShipmentLine.SetFilter("Qty. to Ship (Base)", '<>%1', 0);
        rWarehouseShipmentLine.SetRange("Location Code", LocationFilter);
        if rWarehouseShipmentLine.FindSet() then
            repeat
                QuantityInShipments += rWarehouseShipmentLine."Qty. to Ship (Base)";
            until rWarehouseShipmentLine.Next() = 0;
    end;

    local procedure CalculateProductToTransfer()
    var
        rTransferLine: Record "Transfer Line";
    begin
        rTransferLine.Reset();
        rTransferLine.SetRange("Item No.", Rec."No.");
        rTransferLine.SetFilter("Qty. to Ship (Base)", '<>%1', 0);
        rTransferLine.SetRange("Transfer-from Code", LocationFilter);
        if rTransferLine.FindSet() then
            repeat
                QuantityInTransfers += rTransferLine."Qty. to Ship (Base)";
            until rTransferLine.Next() = 0;
    end;

    procedure SetLocationFilter(pLocationCode: Code[10])
    begin
        LocationFilter := pLocationCode;
    end;
}