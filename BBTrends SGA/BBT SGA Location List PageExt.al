PageExtension 51451 "SGA Location List" extends "Location List"
{
    layout
    {
        addafter(Name)
        {
            field("SGA Enabled"; Rec."SGA Enabled")
            {
                Caption = 'SGA Enabled', Comment = 'ESP="SGA Activado"';
                ApplicationArea = All;
                Visible = SGAEnable;
                Enabled = SGAEnable;
            }
            field("SGA Warehouse Code"; Rec."SGA Warehouse Code")
            {
                Caption = 'SGA Warehouse Code', Comment = 'ESP="SGA Código Almacén"';
                ApplicationArea = All;
                Visible = SGAEnable;
                Enabled = SGAEnable;
            }
        }
    }
    var
        SGAEnable: Boolean;
        CuSGAManagement: Codeunit "SGA Management";

    trigger OnOpenPage()
    begin
        SGAEnable := CuSGAManagement.IsSGAEnabled()
    end;
}