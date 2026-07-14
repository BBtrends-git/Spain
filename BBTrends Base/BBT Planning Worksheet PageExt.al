PageExtension 50265 "BBT Planning Worksheet" extends "Planning Worksheet"
{
    layout
    {
        addafter("Vendor No.")
        {
            field("Item Category Code"; Rec."Item Category Code")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
        }
    }
    var Stockkeeping_Unit: Record "Stockkeeping Unit";
    ReqLine: Record "Requisition Line";
}
