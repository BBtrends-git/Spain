PageExtension 51454 "SGA Purchase Order" extends "Purchase Order"
{
    layout
    {
        addafter(Status)
        {
            field("SGA Status"; Rec."SGA Status")
            {
                ApplicationArea = All;
                Visible = SGAEnable;
                Enabled = SGAEnable;
            }
            field("SGA Inserted"; Rec."SGA Inserted")
            {
                ApplicationArea = All;
                Visible = SGAEnable;
                Enabled = SGAEnable;
            }
            field("SGA Readed"; Rec."SGA Readed")
            {
                ApplicationArea = All;
                Visible = SGAEnable;
                Enabled = SGAEnable;
            }
        }
    }
    actions
    {
        addafter("Co&mments")
        {
            action("Send SGA")
            {
                ApplicationArea = Basic;
                Caption = 'Send SGA', Comment = 'ESP="Enviar SGA"';
                Enabled = SGAEnable;
                Visible = SGAEnable;
                Image = SKU;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SGAInterfaces: Codeunit "SGA Interfaces";
                    SGAWarning: Label 'Changing the status may cause inconsistencies with the SGA. Should we continue?',
                                Comment = 'LA MODIFICACION DEL ESTATUS, PUEDE PROVOCAR PROBLEMAS DE INCONSISTENCIA CON EL SGA. CONTINUAR?';
                begin
                    if Rec."SGA Status" <> Rec."SGA Status"::" " then begin
                        if Confirm(SGAWarning, false) then begin
                            Rec."SGA Status" := Rec."SGA Status"::" ";
                            Rec.Modify;
                        end;
                    end
                    else begin
                        Clear(SGAInterfaces);
                        SGAInterfaces.GestionPedidoCompra(Rec."No.");
                        Clear(SGAInterfaces);
                    end;
                end;
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
}