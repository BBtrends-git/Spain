reportextension 73100 "BBT Shpfy Filter Sync Shipment" extends "Shpfy Sync Shipm. to Shopify"
{
    dataset
    {
        modify("Sales Shipment Header")
        {
            trigger OnAfterPreDataItem()
            begin
                // SetFilter("Shpfy Order Id", '<>%1', 0);
                // SetRange("Shpfy Fulfillment Id", 0);
                SetFilter("Package Tracking No.", '<>%1', '');
            end;
        }
    }
}
