PageExtension 50188 "BBT Transfer Order" extends "Transfer Order"
{
    layout
    {
        modify(General)
        {
            Editable = DocEditable;
        }
        modify("Transfer-from")
        {
            Editable = DocEditable;
        }
        modify("Transfer-to")
        {
            Editable = DocEditable;
        }
        modify("Foreign Trade")
        {
            Editable = DocEditable;
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("Production Order No."; Rec."Production Order No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Status)
        {
            //>> SGA
            field("Status SGA"; Rec."Status SGA")
            {
                ApplicationArea = All;
                Visible = EnabledSGA;
            }
            field("Grabado SGA"; Rec."Grabado SGA")
            {
                ApplicationArea = All;
                Visible = EnabledSGA;
            }
            field("Leido SGA"; Rec."Leido SGA")
            {
                ApplicationArea = All;
                Visible = EnabledSGA;
            }
            //<<
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic;
            }
            field("Created By"; UserCreation."User Name")
            {
                Caption = 'User Creation Transfer Order', comment = 'ESP="Usuario creación ped. transferencia"';
                Editable = false;
                ApplicationArea = All;
            }
            field("Modificated By"; UserModification."User Name")
            {
                Caption = 'User Last Modification Transfer Order', comment = 'ESP="Usuario última modificación ped. transferencia"';
                Editable = false;
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        modify(Post)
        {
            Visible = true;
        }
        modify(PostAndPrint)
        {
            Visible = false;
        }

        addafter(Post)
        {
            action("Traer componentes")
            {
                ApplicationArea = Basic;
                Image = PickLines;

                trigger OnAction()
                begin
                    //I DAGA
                    if Rec."Production Order No." <> '' then begin
                        TransfLine2.Reset;
                        TransfLine2.SetRange(TransfLine2."Document No.", Rec."No.");
                        if TransfLine2.FindLast then
                            NumLinea := TransfLine2."Line No." + 10000
                        else
                            NumLinea := 10000;
                        Componentes.Reset;
                        Componentes.SetRange("Prod. Order No.", Rec."Production Order No.");
                        if Componentes.FindFirst then begin
                            if Componentes.FindFirst then
                                repeat
                                    TransfLine.Init;
                                    TransfLine.Validate("Document No.", Rec."No.");
                                    TransfLine.Validate("Line No.", NumLinea);
                                    TransfLine.Validate("Item No.", Componentes."Item No.");
                                    TransfLine.Validate(Quantity, Componentes."Expected Quantity");
                                    TransfLine.Insert;
                                    NumLinea := NumLinea + 10000;
                                until Componentes.Next = 0;
                        end
                        else begin
                            Message('No hay componentes para esta orden de producción');
                        end;
                    end
                    else begin
                        Message('Debe introducir número orden de producción');
                    end;
                    //F DAGA
                end;
            }
        }
    }
    var
        _InterfaceSGA: Codeunit "Interface SGA";
        _InfoCompany: Record "Company Information";
        EnabledSGA: Boolean;
        UserCreation: Record User;
        UserModification: Record User;
        Componentes: Record "Prod. Order Component";
        TransfLine: Record "Transfer Line";
        TransfLine2: Record "Transfer Line";
        NumLinea: Integer;
        Text50000: label 'El envio esta %1 por el SGA.';
        DocEditable: Boolean;

    trigger OnAfterGetRecord()
    begin
        // SGA
        SetDocEditable;
        //Mostrar usuario creación y última modificación del pedido de transferencia
        //Lo hacemos asi para mostrar el nombre en lugar del GUID
        Clear(UserCreation);
        if UserCreation.Get(Rec.SystemCreatedBy) then;
        Clear(UserModification);
        if UserModification.Get(Rec.SystemModifiedBy) then;
    end;

    trigger OnClosePage()
    var
        Proceso: Codeunit 50000;
        _TempLineasOLD: Record "Transfer Line" temporary;
        _Lintransfer: Record "Transfer Line";
        _TipoLinea: Integer;
    begin
        // SGA
        CurrPage.UPDATE(FALSE);
        IF rec.ModificadoSGA THEN
            IF rec."Status SGA" <> rec."Status SGA"::" " THEN BEGIN
                _TempLineasOLD.RESET;
                _TempLineasOLD.DELETEALL;
                _Lintransfer.RESET;
                _Lintransfer.SETRANGE("Document No.", rec."No.");
                IF _Lintransfer.FINDSET THEN
                    REPEAT
                        _TempLineasOLD := _Lintransfer;
                        _TempLineasOLD.INSERT;
                    UNTIL _Lintransfer.NEXT = 0;
                IF Proceso.AlmacenSGA(rec."Transfer-from Code") THEN
                    _TipoLinea := 0
                ELSE
                    _TipoLinea := 1;
                Proceso."PedidoTransferencia-->SGA"(rec."No.", _TipoLinea, _TempLineasOLD, FALSE);
            END;
        CLEAR(Proceso);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        rec.TESTFIELD(Status, rec.Status::Open);
        // + SGA
        CLEAR(_InterfaceSGA);
        rec.ModificadoSGA := FALSE;
        IF (rec."Status SGA" IN [rec."Status SGA"::"Enviado SGA", rec."Status SGA"::"Bloqueado SGA"]) THEN BEGIN
            IF rec."Status SGA" = rec."Status SGA"::"Bloqueado SGA" THEN IF NOT CONFIRM('El documento se encuentra bloqueado por el SGA.¿Desea continuar?', FALSE) THEN ERROR('Documento no borrado');
            _InterfaceSGA.BorradoPedTrans(rec."No.");
            CLEAR(_InterfaceSGA);
        END;
        // - SGA
    end;

    trigger OnOpenPage()
    begin
        // SGA
        _InfoCompany.Reset();
        _InfoCompany.Get();

        EnabledSGA := _InfoCompany.SGA;
        SetDocEditable;
        //Mostrar usuario creación y última modificación del pedido de transferencia
        //Lo hacemos asi para mostrar el nombre en lugar del GUID
        Clear(UserCreation);
        if UserCreation.Get(Rec.SystemCreatedBy) then;
        Clear(UserModification);
        if UserModification.Get(Rec.SystemModifiedBy) then;
    end;

    local procedure SetDocEditable()
    begin
        // SGA
        DocEditable := (Rec."Status SGA" = Rec."status sga"::" ") or (not EnabledSGA);
    end;
}
