TableExtension 51458 "SGA Warehouse Shipment Line" extends "Warehouse Shipment Line"
{
    fields
    {
        field(51450; "SGA Quantity"; Decimal)
        {
            Caption = 'SGA Quantity', Comment = 'ESp="Cantidad SGA"';
            DecimalPlaces = 0 : 5;
            Editable = false;

            trigger OnValidate()
            begin
                TestField(Rec."Qty. per Unit of Measure");
                Rec."SGA Quantity (Base)" := Round(Rec."SGA Quantity" + Rec."Qty. per Unit of Measure", 0.00001);
            end;
        }
        field(51451; "SGA Quantity (Base)"; Decimal)
        {
            Caption = 'SGA Quantity (Base)', Comment = 'ESP="Cantidad Base SGA"';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(51452; "SGA Warehouse Delivery Number"; Code[25])
        {
            Caption = 'SGA Warehouse Delivery Number', Comment = 'ESP="Número Entrega Almacén"';
            Editable = false;
        }
        field(51453; "SGA Status"; enum "SGA Status")
        {
            Caption = 'SGA Status', comment = 'ESP="Status SGA';
            Editable = false;
            CalcFormula = lookup("Warehouse Shipment Header"."SGA Status" where("No." = field("No.")));
            FieldClass = FlowField;
        }
    }

    procedure SGASent(): Boolean
    var
        cuSGAManagement: Codeunit "SGA Management";
        rWarehouseShipmentHeader: Record "Warehouse Shipment Header";
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            rWarehouseShipmentHeader.Get(rec."No.");
            exit(rWarehouseShipmentHeader."SGA Status" <> rWarehouseShipmentHeader."SGA Status"::" ");
        end else
            exit(false);
    end;

    procedure SGAUpdateInserted()
    var
        cuSGAManagement: Codeunit "SGA Management";
        rWarehouseShipmentHeader: Record "Warehouse Shipment Header";
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            rWarehouseShipmentHeader.Get(Rec."No.");
            rWarehouseShipmentHeader."SGA Modified" := true;
            rWarehouseShipmentHeader.Modify;
        end;
    end;
}
