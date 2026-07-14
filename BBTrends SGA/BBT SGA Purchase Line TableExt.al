TableExtension 51460 "SGA Purchase Line" extends "Purchase Line"
{
    fields
    {
        field(51450; "SGA Modified"; Boolean)
        {
            Caption = 'SGA Modified', Comment = 'ESP="Modificado SGA"';
        }
    }

    procedure SGASent()
    var
        cuSGAManagement: Codeunit "SGA Management";
        rPurchaseHeader: Record "Purchase Header";
    begin
        rPurchaseHeader.Reset();
        if cuSGAManagement.IsSGAEnabled() then begin
            if Rec."Document Type" = Rec."document type"::Order then begin
                rPurchaseHeader.Get(Rec."Document Type", Rec."Document No.");
                if rPurchaseHeader."SGA Status" <> rPurchaseHeader."SGA Status"::" " then begin
                    rPurchaseHeader."SGA Modified" := true;
                    rPurchaseHeader.Modify;
                    Rec."SGA Modified" := true;
                    Rec.Modify;
                end;
            end;
        end;
    end;
}