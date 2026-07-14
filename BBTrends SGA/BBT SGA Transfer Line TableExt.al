TableExtension 51459 "SGA Transfer Line" extends "Transfer Line"
{
    fields
    {
        field(51450; "SGA Status"; Enum "SGA Status")
        {
            Caption = 'SGA Status', Comment = 'ESP="Estado SGA"';
            Editable = false;
            CalcFormula = lookup("Transfer Header"."SGA Status" where("No." = field("Document No.")));
            FieldClass = FlowField;
        }
    }

    procedure SGAEnviar()
    var
        cuSGAManagement: Codeunit "SGA Management";
        rTransferHeader: Record "Transfer Header";
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            rTransferHeader.Get(Rec."Document No.");
            if rTransferHeader."SGA Status" <> rTransferHeader."SGA Status"::" " then begin
                rTransferHeader."SGA Modified" := true;
                rTransferHeader.Modify();
            end;
        end;
    end;

}