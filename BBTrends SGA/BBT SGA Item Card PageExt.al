PageExtension 51452 "SGA Item Card" extends "Item Card"
{
    layout
    {
        addafter(Warehouse)
        {
            group(SGATab)
            {
                Caption = 'SGA', Comment = 'ESP="SGA"';
                Visible = SGAEnable;
                Enabled = SGAEnable;

                field("SGA Item Management"; Rec."SGA Item Management")
                {
                    ApplicationArea = ALL;
                }
                field("SGA Batch Management"; Rec."SGA Batch Management")
                {
                    ApplicationArea = All;
                }
                field("SGA Forced Batch Sales"; Rec."SGA Forced Batch Sales")
                {
                    ApplicationArea = All;
                }
                field("SGA Forced Batch Purchases"; Rec."SGA Forced Batch Purchases")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        CuSGAManagement: Codeunit "SGA Management";
        SGAEnable: Boolean;

    trigger OnOpenPage()
    begin
        SGAEnable := CuSGAManagement.IsSGAEnabled();
    end;

    trigger OnClosePage()
    var
        rItem: Record Item;
        cuSGAInterfaces: Codeunit "SGA Interfaces";
    begin
        if CuSGAManagement.IsSGAEnabled() then begin

            rItem.RESET;
            rItem.SETRANGE("No.", rec."NO.");
            rItem.SetRange("SGA Item Management", true);
            rItem.SetRange("Last Date Modified", Today);
            rItem.SetRange("SGA Requires Modification", true);
            if rItem.FindSet() then
                repeat
                    clear(cuSGAInterfaces);
                    cuSGAInterfaces.GestionProducto(rItem);
                    Clear(cuSGAInterfaces);

                    ritem."SGA Requires Modification" := false;
                    rItem.Modify();
                until rItem.Next() = 0;
        end;
    end;
}