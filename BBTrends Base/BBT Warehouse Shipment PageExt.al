PageExtension 50215 "BBT Warehouse Shipment" extends "Warehouse Shipment"
{
    layout
    {
        modify(General)
        {
            Editable = DocEditable;
        }

        moveafter("Posting Date"; "External Document No.")

        modify("External Document No.")
        {
            Visible = true;
            Editable = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Assignment Date")
        {
            Visible = false;
        }
        modify("Assignment Time")
        {
            Visible = false;
        }
        modify("Sorting Method")
        {
            visible = false;
        }

        //>> SGA
        addafter(Status)
        {
            field("Status SGA"; Rec."Status SGA")
            {
                ApplicationArea = All;
                Visible = SGAENABLE;
            }
        }
        addafter("Sorting Method")
        {
            field("Grabado SGA"; Rec."Grabado SGA")
            {
                ApplicationArea = All;
                Visible = SGAENABLE;
            }
            field("Leido SGA"; Rec."Leido SGA")
            {
                ApplicationArea = All;
                Visible = SGAENABLE;
            }
            field("Source No."; Rec."Source No.")
            {
                ApplicationArea = All;
                Visible = SGAENABLE;
            }
        }
        //<<
        //>> BBT 03/07/2026. Disponibilidad del producto

        addafter(Control1901796907)
        {
            part(AvailableInWarehouse; "BBT Available in Warehouse")
            {
                ApplicationArea = Warehouse;
                Provider = WhseShptLines;
                SubPageLink = "No." = field("Item No.");
                Visible = true;
            }
        }
        //<<
    }

    actions
    {
        addafter("Create Pick")
        {
            separator(Action1100234000)
            { }

            action("Envio SGA")
            {
                ApplicationArea = Basic;
                Caption = 'Envio SGA';
                Enabled = SGAENABLE;
                Visible = SGAENABLE;
                Image = CreateInteraction;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ProcesoSGA: Codeunit "Interface SGA";
                    _LinEnvio: Record "Warehouse Shipment Line";
                begin
                    // SGA
                    if Rec."Status SGA" = Rec."status sga"::" " then begin
                        if Rec.Status = Rec.Status::Released then begin
                            _LinEnvio.SetRange("No.", Rec."No.");
                            if _LinEnvio.FindFirst then begin
                                ProcesoSGA.ChequeoStockEnvio(Rec."No.");
                                Clear(ProcesoSGA);
                                if (_LinEnvio."Source Type" = 39) and (_LinEnvio."Source Subtype" = 5) then
                                    ProcesoSGA.DevCompraDocEnvio(Rec."No.", false)
                                else if (_LinEnvio."Source Type" = 37) and (_LinEnvio."Source Subtype" = 1) then
                                    ProcesoSGA.PedVentaDocEnvio(Rec."No.", false);
                                Clear(ProcesoSGA);
                            end;
                        end
                        else
                            Error('El envio no esta lanzado');
                    end
                    else
                        Message('Envio ya informado en SGA');
                end;
            }
        }
    }

    var
        DocEditable: Boolean;
        SGAENABLE: Boolean;

    trigger OnAfterGetRecord()
    var
        rSGABlockedDocuments: Record "BBT-IT SGA Blocked Documents";
    begin
        // SGA
        SetSGAEnabled;
        SetDocEditable;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.AvailableInWarehouse.PAGE.SetLocationFilter(Rec."Location Code");
    end;

    trigger OnClosePage()
    var
        Proceso: Codeunit 50000;
        _InfoCompany: Record "Company Information";
    begin
        // SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN BEGIN
            CurrPage.UPDATE(FALSE);
            IF rec.ModificadoSGA AND (rec.Status = rec.Status::Released) THEN
                IF rec."Status SGA" <> rec."Status SGA"::" " THEN
                    Proceso.PedVentaDocEnvio(rec."No.", FALSE);
        END;
        CLEAR(Proceso);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        _InterfaceSGA: Codeunit 50000;
        _InfoCompany: Record "Company Information";
    begin
        // + SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN BEGIN
            rec.ModificadoSGA := FALSE;
            CLEAR(_InterfaceSGA);
            //>> 
            IF (rec."Status SGA" IN [rec."Status SGA"::"Enviado SGA", rec."Status SGA"::"Bloqueado SGA"]) THEN BEGIN
                //>> BBT 24/11/2025
                //IF rec."Status SGA" = rec."Status SGA"::"Bloqueado SGA" THEN
                //IF NOT CONFIRM('El documento se encuentra bloqueado por el SGA.¿Desea continuar?', FALSE) THEN
                //ERROR('Documento no borrado.');
                //_InterfaceSGA.BorradoEnvios(rec."No.");
                if rec."Status SGA" = rec."Status SGA"::"Enviado SGA" then
                    _InterfaceSGA.BorradoEnvios(rec."No.")
                else
                    Error('El documento se encuentra bloqueado por el SGA. No se puede eliminar');
                //<<
            END;
        end;
        // - SGA
    end;

    trigger OnOpenPage()
    begin
        rec.ErrorIfUserIsNotWhseEmployee;
        // SGA
        SetDocEditable;
        SetSGAEnabled;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        _InfoCompany: Record "Company Information";
    begin
        // SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN BEGIN
            IF rec.ModificadoSGA AND (rec.Status = rec.Status::Open) THEN BEGIN
                IF CONFIRM('El envio esta modificado y se debe mandar a SGA pero no esta lanzado y no se enviara.\' + '¿Desea continuar?', FALSE) THEN BEGIN
                    rec.ModificadoSGA := FALSE;
                    rec.MODIFY;
                    EXIT(TRUE);
                END
                ELSE BEGIN
                    MESSAGE('Vuelva a lanzar el envio antes de salir');
                    EXIT(FALSE);
                END;
            END
            ELSE
                EXIT(TRUE);
        END;
    end;

    local procedure SetDocEditable()
    var
        _InfoCompany: Record "Company Information";
    begin
        // SGA
        _InfoCompany.Get;
        DocEditable := (Rec."Status SGA" = Rec."status sga"::" ") or (not _InfoCompany.SGA);
    end;

    local procedure SetSGAEnabled()
    var
        _InfoCompany: Record "Company Information";
    begin
        // SGA
        _InfoCompany.Get;
        SGAENABLE := _InfoCompany.SGA;
    end;
}
