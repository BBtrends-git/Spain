PageExtension 51460 "SGA Transfer Order" extends "Transfer Order"
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
        addafter(Status)
        {
            field("SGA Status"; Rec."SGA Status")
            {
                ApplicationArea = All;
                Visible = SGAEnabled;
            }
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
        }
    }

    var
        cuSGAManagement: Codeunit "SGA Management";
        cuSGAInterfaces: Codeunit "SGA Interfaces";
        SGAEnabled: Boolean;
        DocEditable: Boolean;

    trigger OnOpenPage()
    begin
        SGAEnabled := cuSGAManagement.IsSGAEnabled();
    end;

    trigger OnAfterGetRecord()
    begin
        DocEditable := true;
        if SGAEnabled then
            DocEditable := (Rec."SGA Status" = Rec."SGA Status"::" ");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        DocEditable := true;
    end;

    trigger OnDeleteRecord(): Boolean
    var
        CONFIRM01: Label 'The document is locked by the SGA. Do you wish to continue?',
                Comment = 'ESP="El documento se encuentra bloqueado por el SGA.¿Desea continuar?"';
        ERROR01: Label 'Document not deleted', Comment = 'ESP="Documento no borrado"';
    begin
        Rec.TestField(Status, Rec.Status::Open);
        CLEAR(cuSGAInterfaces);
        Rec."SGA Modified" := false;
        if (Rec."SGA Status" in [REC."SGA Status"::"SGA Sent", Rec."SGA Status"::"SGA Locked"]) then begin
            if Rec."SGA Status" = Rec."SGA Status"::"SGA Locked" then
                if not Confirm(CONFIRM01, false) then
                    Error(ERROR01);

            cuSGAInterfaces.BorradoPedTrans(rec."No.");
            CLEAR(cuSGAInterfaces);
        end;
    end;

    trigger OnClosePage()
    var
        rTempTransferLine: Record "Transfer Line" temporary;
        rTransferLine: Record "Transfer Line";
        TipoLinea: Integer;
    begin
        CurrPage.update(false);
        if Rec."SGA Modified" then
            if Rec."SGA Status" <> Rec."SGA Status"::" " then begin
                rTempTransferLine.Reset();
                rTempTransferLine.DeleteAll();
                rTransferLine.Reset();
                rTransferLine.SETRANGE("Document No.", rec."No.");
                IF rTransferLine.FindSet() THEN
                    REPEAT
                        rTempTransferLine := rTransferLine;
                        rTempTransferLine.Insert();
                    UNTIL rTransferLine.Next() = 0;

                if cuSGAManagement.SGAWarehouse(rec."Transfer-from Code") then
                    TipoLinea := 0
                else
                    TipoLinea := 1;

                cuSGAInterfaces."PedidoTransferencia-->SGA"(rec."No.", TipoLinea, rTempTransferLine, false);
            END;
        CLEAR(cuSGAInterfaces);
    end;
}
