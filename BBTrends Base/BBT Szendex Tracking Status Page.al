Page 50075 "Szendex Tracking Status"
{
    Caption = 'Estados tracking Szendex';
    PageType = List;
    SourceTable = "Szendex Tracking Status";
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shipment Delivered"; Rec."Shipment Delivered")
                {
                    ApplicationArea = Basic;
                }
                field("Shipment Finished"; Rec."Shipment Finished")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
    actions
    {
    }
}
