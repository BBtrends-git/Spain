PageExtension 50128 "BBT Sales Cr. Memo Subform" extends "Sales Cr. Memo Subform"
{
    layout
    {
        addafter("No.")
        {
            field("EAN Code"; Rec."EAN Code")
            {
                ApplicationArea = Basic;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        rWarehouseSetup: Record "Warehouse Setup";
    begin
        if rWarehouseSetup.Get() then
            Rec."Location Code" := rWarehouseSetup."Default Sales CR Memo Location";
    end;
}
