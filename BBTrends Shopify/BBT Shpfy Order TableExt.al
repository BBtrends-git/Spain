tableextension 73102 "BBT Shpfy Order Ext" extends "Shpfy Order Header"
{
    fields
    {
        field(73100; "Blocked per price"; Boolean)
        {
            Caption = 'Locked by price', Comment = 'ESP="Bloqueado por precio"';
        }
        field(73101; "Validado"; Boolean)
        {
            Caption = 'Validate', Comment = 'ESP="Validado"';
        }
    }
    trigger OnAfterInsert()
    var
        rlShpfyShop: Record "Shpfy Shop";
        rlShpfyOrderHeader: Record "Shpfy Order Header";
    begin
        if rlShpfyShop.Get(Rec."Shop Code") then
            if rlShpfyOrderHeader.Get(Rec."Shopify Order Id") then begin
                //>>BBT 01/07/2025. ERROR Provocado en la V26 de Shopify.
                //rlShpfyOrderHeader.Validate("VAT Included", rlShpfyShop."Prices Including VAT");
                rlShpfyOrderHeader."VAT Included" := rlShpfyShop."Prices Including VAT";
                //<<
                rlShpfyOrderHeader.Modify();
            end;
    end;
}
