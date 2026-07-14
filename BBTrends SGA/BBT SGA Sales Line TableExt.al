TableExtension 51461 "SGA Sales Line" extends "Sales Line"
{
    procedure SGASent()
    var
        cuSGAManagement: Codeunit "SGA Management";
        rSalesHeader: Record "Sales Header";
    begin
        rSalesHeader.Reset();
        if cuSGAManagement.IsSGAEnabled() then begin
            if Rec."Document Type" = Rec."document type"::"Return Order" then begin
                if rSalesHeader.Get(Rec."Document Type", Rec."Document No.") then
                    if rSalesHeader."SGA Status" <> rSalesHeader."SGA Status"::" " then begin
                        rSalesHeader."SGA Modified" := true;
                        rSalesHeader.Modify;
                    end;
            end;
        end;
    end;
}