PageExtension 51468 "SGA Posted Sales Shipment" extends "Posted Sales Shipment"
{
    layout
    {
        addafter("Shipment Date")
        {
            field("SGA Warehouse Delivery No"; Rec."SGA Warehouse Delivery No")
            {
                ApplicationArea = All;
                Visible = SGAEnable;
                Enabled = SGAEnable;
            }
            field("SGA Expedition Date"; Rec."SGA Expedition Date")
            {
                ApplicationArea = All;
                Visible = SGAEnable;
                Enabled = SGAEnable;
            }
        }
    }
    var
        CuSGAManagement: Codeunit "SGA Management";
        SGAEnable: Boolean;

    trigger OnOpenPage()
    begin
        SGAEnable := CuSGAManagement.IsSGAEnabled();
    end;
}