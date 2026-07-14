PageExtension 51461 "SGA Transfer Order Subform" extends "Transfer Order Subform"
{
    layout
    {
        modify("Item No.")
        {
            Editable = DocEditable;
        }
        modify("Variant Code")
        {
            Editable = DocEditable;
        }
        modify("Planning Flexibility")
        {
            Editable = DocEditable;
        }
        modify(Description)
        {
            Editable = DocEditable;
        }
        modify(Quantity)
        {
            Editable = DocEditable;
        }
        modify("Unit of Measure Code")
        {
            Editable = DocEditable;
        }
        modify("Unit of Measure")
        {
            Editable = DocEditable;
        }
        modify("Shipment Date")
        {
            Editable = DocEditable;
        }
        modify("Receipt Date")
        {
            Editable = DocEditable;
        }
        modify("Shipping Agent Code")
        {
            Editable = DocEditable;
        }
        modify("Shipping Agent Service Code")
        {
            Editable = DocEditable;
        }
        modify("Shipping Time")
        {
            Editable = DocEditable;
        }
        modify("Outbound Whse. Handling Time")
        {
            Editable = DocEditable;
        }
        modify("Inbound Whse. Handling Time")
        {
            Editable = DocEditable;
        }
        modify("Appl.-to Item Entry")
        {
            Editable = DocEditable;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Editable = DocEditable;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Editable = DocEditable;
        }
        modify("ShortcutDimCode[3]")
        {
            Editable = DocEditable;
        }
        modify("ShortcutDimCode[4]")
        {
            Editable = DocEditable;
        }
        modify("ShortcutDimCode[5]")
        {
            Editable = DocEditable;
        }
        modify("ShortcutDimCode[6]")
        {
            Editable = DocEditable;
        }
        modify("ShortcutDimCode[7]")
        {
            Editable = DocEditable;
        }
        modify("ShortcutDimCode[8]")
        {
            Editable = DocEditable;
        }
    }
    var
        cuSGAManagement: Codeunit "SGA Management";
        rTransferHeader: Record "Transfer Header";
        DocEditable: Boolean;
        SGAEnabled: Boolean;
        Error01: Label 'Transfer Order sent to SGA', Comment = 'ESP="Pedido de Transferencia enviado al SGA"';

    trigger OnOpenPage()
    begin
        SGAEnabled := cuSGAManagement.IsSGAEnabled();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        DocEditable := true;
        if SGAEnabled then
            DocEditable := (rTransferHeader."SGA Status" = rTransferHeader."SGA Status"::" ");
    end;

    trigger OnAfterGetRecord()
    begin
        rec.ShowShortcutDimCode(ShortcutDimCode);

        DocEditable := true;
        if SGAEnabled then
            DocEditable := (rTransferHeader."SGA Status" = rTransferHeader."SGA Status"::" ");
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Commit();

        if SGAEnabled then begin
            rTransferHeader.Get(rec."Document No.");
            IF (rTransferHeader."SGA Status" <> rTransferHeader."SGA Status"::" ") and (Rec."Qty. to Ship" <> 0) then
                Error(Error01);
        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        _Cabtransfer: Record "Transfer Header";
        _InfoCompany: Record "Company Information";
    begin
        if SGAEnabled then begin
            rTransferHeader.Get(rec."Document No.");
            if (rTransferHeader."SGA Status" <> rTransferHeader."SGA Status"::" ") Then
                Error(Error01);
        END;
    end;
}
