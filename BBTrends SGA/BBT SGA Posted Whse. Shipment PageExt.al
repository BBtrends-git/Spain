PageExtension 51463 "SGA Posted Whse Shipment" extends "Posted Whse. Shipment"
{
    layout
    {
        addafter("Posting Date")
        {
            field("SGAWarehouseDeliveryNumber"; Rec."SGA Warehouse Delivery Number")
            {
                ApplicationArea = All;
                Visible = SGAEnabled;
                Enabled = SGAEnabled;
                Editable = false;
            }
        }
    }

    var
        cuSGAManagement: Codeunit "SGA Management";
        SGAEnabled: Boolean;

    trigger OnOpenPage()
    begin
        SGAEnabled := cuSGAManagement.IsSGAEnabled();
    end;

}