reportextension 73101 "BBT Shpfy Orders" extends "Shpfy Sync Orders from Shopify"
{
    dataset
    {
        modify(Shop)
        {
            trigger OnAfterPreDataItem()
            begin
                SetRange(Enabled, true);
            end;
        }
    }
}
