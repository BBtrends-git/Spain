PageExtension 51459 "SGA Warehouse Shipment Subform" extends "Whse. Shipment Subform"
{
    layout
    {
        modify("Zone Code")
        {
            Editable = DocEditable;
        }
        modify("Bin Code")
        {
            Editable = DocEditable;
        }
        modify("Shelf No.")
        {
            Editable = DocEditable;
        }
        modify("Qty. to Ship")
        {
            Editable = DocEditable;
        }
        modify("Qty. to Ship (Base)")
        {
            Editable = DocEditable;
        }
        modify("Due Date")
        {
            Editable = DocEditable;
        }
    }
    var
        cuSGAManagement: Codeunit "SGA Management";
        DocEditable: Boolean;
        SGAEnabled: Boolean;
        rWarehouseShipmentHeader: Record "Warehouse Shipment Header";
        Error01: Label 'Sent to SGA', Comment = 'ESP="Enviado a SGA"';

    trigger OnOpenPage()
    begin
        DocEditable := true;
        SGAEnabled := cuSGAManagement.IsSGAEnabled();
    end;

    trigger OnAfterGetRecord()
    begin
        if SGAEnabled then begin
            rWarehouseShipmentHeader.Get(Rec."No.");
            DocEditable := not (rWarehouseShipmentHeader."SGA Status" = rWarehouseShipmentHeader."SGA Status"::"SGA Locked");
        end;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if SGAEnabled then begin
            if rWarehouseShipmentHeader."SGA Status" <> rWarehouseShipmentHeader."SGA Status"::" " then
                if rec."Qty. to Ship" <> 0 then
                    Error(Error01);
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if SGAEnabled then begin
            if rWarehouseShipmentHeader.Get(Rec."No.") then
                if rWarehouseShipmentHeader."SGA Status" <> rWarehouseShipmentHeader."SGA Status"::" " then
                    Error(Error01);
        end;
    end;
}