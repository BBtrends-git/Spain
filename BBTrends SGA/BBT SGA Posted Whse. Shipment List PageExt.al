PageExtension 51464 "SGA Posted Whse Shipment List" extends "Posted Whse. Shipment List"
{
    layout
    {
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("No. Series")
        {
            Visible = false;
        }
        modify("Shipping Agent Code")
        {
            Visible = true;
        }
        addafter("Shipping Agent Code")
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