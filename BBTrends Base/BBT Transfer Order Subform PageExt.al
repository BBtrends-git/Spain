PageExtension 50189 "BBT Transfer Order Subform" extends "Transfer Order Subform"
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
        addafter("ShortcutDimCode[8]")
        {
            field("Transfer-from Code"; Rec."Transfer-from Code")
            {
                ApplicationArea = Basic;
            }
            field("Transfer-to Code"; Rec."Transfer-to Code")
            {
                ApplicationArea = Basic;
            }
        }
    }
    var
        _Cabtransfer: Record "Transfer Header";
        _InfoCompany: Record "Company Information";
        DocEditable: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        // SGA
        SetDocEditable;
    end;

    trigger OnAfterGetRecord()
    begin
        rec.ShowShortcutDimCode(ShortcutDimCode);
        // SGA
        SetDocEditable;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        COMMIT;
        // SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN BEGIN
            _Cabtransfer.GET(rec."Document No.");
            IF (_Cabtransfer."Status SGA" <> _Cabtransfer."Status SGA"::" ") AND (rec."Qty. to Ship" <> 0) THEN ERROR('Pedido enviado a SGA.');
        END;
        // SGA
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        _Cabtransfer: Record "Transfer Header";
        _InfoCompany: Record "Company Information";
    begin
        // SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN BEGIN
            _Cabtransfer.GET(rec."Document No.");
            IF _Cabtransfer."Status SGA" <> _Cabtransfer."Status SGA"::" " THEN ERROR('Pedido enviado a SGA.');
        END;
    end;

    local procedure SetDocEditable()
    var
        _CabTransfer: Record "Transfer Header";
        _InfoCompany: Record "Company Information";
    begin
        // SGA
        _InfoCompany.Get;
        DocEditable := true;
        if _InfoCompany.SGA then
            if _CabTransfer.Get(Rec."Document No.") then
                DocEditable := (_CabTransfer."Status SGA" = _CabTransfer."status sga"::" ");
    end;
}
