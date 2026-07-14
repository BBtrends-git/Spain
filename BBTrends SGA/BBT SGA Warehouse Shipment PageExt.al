PageExtension 51458 "SGA Warehouse Shipment" extends "Warehouse Shipment"
{
    layout
    {
        modify(General)
        {
            Editable = SGADocEditable;
        }
        addafter(Status)
        {
            field("SGA Status"; Rec."SGA Status")
            {
                ApplicationArea = All;
                Visible = SGAEnabled;
            }
        }
        addafter("Sorting Method")
        {
            field("SGA Inserted"; Rec."SGA Inserted")
            {
                ApplicationArea = All;
                Visible = SGAEnabled;
            }
            field("SGA Readed"; Rec."SGA Readed")
            {
                ApplicationArea = All;
                Visible = SGAEnabled;
            }
            field("SGA Destination Type"; Rec."SGA Destination Type")
            {
                ApplicationArea = All;
                Visible = SGAEnabled;
            }
            field("SGA Destination No."; Rec."SGA Destination No.")
            {
                ApplicationArea = All;
                Visible = SGAEnabled;
            }
            field("SGA Source No."; Rec."SGA Source No.")
            {
                ApplicationArea = All;
                Visible = SGAEnabled;
            }
        }
    }
    actions
    {
        addafter("Create Pick")
        {
            action(SGASent)
            {
                ApplicationArea = All;
                Caption = 'Sent to SGA', Comment = 'Enviar SGA';
                Enabled = SGAEnabled;
                Visible = SGAEnabled;
                Image = CreateInteraction;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    cuSGAManagement: Codeunit "SGA Management";
                    rWarehouseShipmentLine: Record "Warehouse Shipment Line";
                    Error01: Label 'Shipment already Sent in SGA', Comment = 'ESP="Envio ya informado al SGA"';
                    Error02: Label 'Shipment Not Released', Comment = 'ESP="El envio no esta lanzado"';
                begin
                    if Rec."SGA Status" = Rec."SGA Status"::" " then begin
                        if Rec.Status = Rec.Status::Released then begin
                            rWarehouseShipmentLine.Reset();
                            rWarehouseShipmentLine.SetRange("No.", Rec."No.");
                            if rWarehouseShipmentLine.FindFirst then begin
                                Clear(cuSGAInterfaces);
                                cuSGAManagement.CheckStockShipment(Rec."No.");
                                Clear(cuSGAInterfaces);
                                if (rWarehouseShipmentLine."Source Type" = 39) and (rWarehouseShipmentLine."Source Subtype" = 5) then
                                    cuSGAInterfaces.DevCompraDocEnvio(Rec."No.", false)
                                else if (rWarehouseShipmentLine."Source Type" = 37) and (rWarehouseShipmentLine."Source Subtype" = 1) then
                                    cuSGAInterfaces.PedVentaDocEnvio(Rec."No.", false);
                                Clear(cuSGAInterfaces);
                            end;
                        end
                        else
                            Error(Error02);
                    end
                    else
                        Message(Error01);
                end;
            }
        }
    }

    var
        cuSGAManagement: Codeunit "SGA Management";
        cuSGAInterfaces: Codeunit "SGA Interfaces";
        SGADocEditable: Boolean;
        SGAEnabled: Boolean;

    trigger OnOpenPage()
    begin
        rec.ErrorIfUserIsNotWhseEmployee;
        SGAEnabled := cuSGAMANAGement.IsSGAEnabled();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SGADocEditable := true;
    end;

    trigger OnAfterGetCurrRecord()
    var
        rSalesHeader: Record "Sales Header";
    begin
        if SGAEnabled then begin
            Rec.CalcFields("SGA Destination Type", "SGA Destination No.", "SGA Source No.");
            if Rec."External Document No." = '' then begin
                Rec.CalcFields("SGA Destination Type", "SGA Destination No.", "SGA Source No.");
                if Rec."SGA Destination Type" = Rec."SGA Destination Type"::Customer then begin
                    rSalesHeader.Reset;
                    rSalesHeader.SetRange("Document Type", rSalesHeader."document type"::Order);
                    rSalesHeader.SetRange("No.", Rec."SGA Source No.");
                    if rSalesHeader.FindFirst then begin
                        Rec."External Document No." := rSalesHeader."External Document No.";
                        REc.Modify();
                    end;
                end;
            end;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        SGADocEditable := true;
        if SGAEnabled then
            SGADocEditable := (Rec."SGA Status" = Rec."SGA Status"::" ");
    end;

    trigger OnClosePage()
    begin
        clear(cuSGAInterfaces);
        if SGAEnabled then begin
            CurrPage.update(false);
            if Rec."SGA Modified" AND (Rec.Status = rec.Status::Released) then
                if Rec."SGA Status" <> Rec."SGA Status"::" " then
                    cuSGAInterfaces.PedVentaDocEnvio(Rec."No.", false);
        end;
        clear(cuSGAInterfaces);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        Error01: Label 'The document is locked by the WMS. IT CANNOT BE DELETED',
            Comment = 'ESP="El documento se encuentra bloqueado por el SGA. NO SE PUEDE ELIMINAR"';
    begin
        clear(cuSGAInterfaces);
        rec."SGA Modified" := false;
        IF (Rec."SGA Status" IN [Rec."SGA Status"::"SGA Sent", Rec."SGA Status"::"SGA Locked"]) THEN BEGIN
            if Rec."SGA Status" = Rec."SGA Status"::"SGA Sent" then
                cuSGAInterfaces.BorradoEnvios(Rec."No.")
            else
                Error(Error01);
        END;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        Confirm01: Label 'The shipment has been modified and must be sent to the WMS, but it has not been submitted and will not be sent\ Do you want to continue?',
                Comment = 'ESP="El envio esta modificado y se debe mandar a SGA pero no esta lanzado y no se enviara.\ ¿Desea continuar?"';
        Error01: Label 'Please resubmit the shipment before leaving.',
                Comment = 'ESP="Vuelva a lanzar el envio antes de salir"';
    begin
        if SGAEnabled THEN begin
            if rec."SGA Modified" AND (Rec.Status = Rec.Status::Open) then begin
                if CONFIRM(Confirm01, false) then begin
                    rec."SGA Modified" := false;
                    rec.Modify();
                    exit(true);
                end
                else begin
                    MESSAGE(Error01);
                    exit(false);
                end;
            end
            else
                exit(true);
        end;
    end;
}