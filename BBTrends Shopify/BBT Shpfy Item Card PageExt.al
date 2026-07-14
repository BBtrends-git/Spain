pageextension 73101 "BBT Shpfy Item Card Ext" extends "Item Card"
{
    layout
    {
        addbefore(InventoryGrp)
        {
            group(Shopify)
            {
                Caption = 'Shopify', Comment = 'ESP="Shopify"';

                field("e-commerce"; Rec."e-commerce")
                {
                    ApplicationArea = All;
                    Enabled = true;
                    Editable = false;
                }
                field("En Liquidación"; Rec."En Liquidación")
                {
                    ApplicationArea = All;
                    Enabled = true;
                    Editable = IsEcommerce;
                }
            }
        }
    }
    var
        IsEcommerce: Boolean;

    trigger OnAfterGetRecord()
    begin
        IsEcommerce := SetIsEcommerce;
        if Rec."e-commerce" <> IsEcommerce then begin
            Rec."e-commerce" := IsEcommerce;
            if not Rec."e-commerce" and Rec."En Liquidación" then
                Rec."En Liquidación" := false;
            Rec.Modify();
        end;
    end;

    local procedure SetIsEcommerce(): Boolean
    var
        rShpfyVariant: Record "Shpfy Variant";
    begin
        rShpfyVariant.SetRange("Item SystemId", Rec.SystemId);
        if rShpfyVariant.FindFirst() then
            exit(true)
        else
            exit(false);
    end;
}
