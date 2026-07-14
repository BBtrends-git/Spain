PageExtension 50210 "BBT Sales Return Order Subform" extends "Sales Return Order Subform"
{
    layout
    {
        modify(Type)
        {
            Editable = DocEditable;
        }
        modify("No.")
        {
            Editable = DocEditable;
        }
        modify("IC Partner Ref. Type")
        {
            Editable = DocEditable;
        }
        modify("IC Partner Reference")
        {
            Editable = DocEditable;
        }
        modify("Variant Code")
        {
            Editable = DocEditable;
        }
        modify("VAT Prod. Posting Group")
        {
            Editable = DocEditable;
        }
        modify(Description)
        {
            Editable = DocEditable;
        }
        modify("Return Reason Code")
        {
            Editable = DocEditable;
        }
        modify("Location Code")
        {
            Editable = DocEditable;
        }
        modify("Bin Code")
        {
            Editable = DocEditable;
        }
        modify(Control28)
        {
            Editable = DocEditable;
        }
        modify("Reserved Quantity")
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
        modify("Unit Cost (LCY)")
        {
            Editable = DocEditable;
        }
        //>> BBT 15/12/2025. Permitimos cambiar el precio.
        //modify("Unit Price")
        //{
        //    Editable = DocEditable;
        //}
        //<<
        modify("Line Amount")
        {
            Editable = DocEditable;
        }
        modify("Line Discount %")
        {
            Editable = false;
            Visible = false;
        }
        modify("Line Discount Amount")
        {
            Editable = DocEditable;
        }
        modify("Allow Invoice Disc.")
        {
            Editable = DocEditable;
        }
        modify("Return Qty. to Receive")
        {
            Editable = DocEditable;
        }
        modify("Qty. to Invoice")
        {
            Editable = DocEditable;
        }
        modify("Allow Item Charge Assignment")
        {
            Editable = DocEditable;
        }
        modify("Requested Delivery Date")
        {
            Editable = DocEditable;
        }
        modify("Promised Delivery Date")
        {
            Editable = DocEditable;
        }
        modify("Planned Delivery Date")
        {
            Editable = DocEditable;
        }
        modify("Planned Shipment Date")
        {
            Editable = DocEditable;
        }
        modify("Shipment Date")
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
        modify("Blanket Order No.")
        {
            Editable = DocEditable;
        }
        modify("Blanket Order Line No.")
        {
            Editable = DocEditable;
        }
        modify("Appl.-from Item Entry")
        {
            Editable = DocEditable;
        }
        modify("Appl.-to Item Entry")
        {
            Editable = DocEditable;
        }
        modify("Deferral Code")
        {
            Editable = DocEditable;
        }
        modify("Returns Deferral Start Date")
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
        modify(ShortcutDimCode3)
        {
            Editable = DocEditable;
        }
        modify(ShortcutDimCode4)
        {
            Editable = DocEditable;
        }
        modify(ShortcutDimCode5)
        {
            Editable = DocEditable;
        }
        modify(ShortcutDimCode6)
        {
            Editable = DocEditable;
        }
        modify(ShortcutDimCode7)
        {
            Editable = DocEditable;
        }
        modify(ShortcutDimCode8)
        {
            Editable = DocEditable;
        }
    }
    var
        _CabVenta: Record "Sales Header";
        _InfoCompany: Record "Company Information";
        DocEditable: Boolean;

    trigger OnOpenPage()
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
        // SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN BEGIN
            _CabVenta.GET(rec."Document Type", rec."Document No.");
            IF _CabVenta."Status SGA" <> _CabVenta."Status SGA"::" " THEN ERROR('Devolución enviada a SGA.');
        END;
        // SGA
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        _CabVenta: Record "Sales Header";
        _InfoCompany: Record "Company Information";
        rWarehouseSetup: Record "Warehouse Setup";
    begin
        // SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN BEGIN
            _CabVenta.GET(rec."Document Type", rec."Document No.");
            IF _CabVenta."Status SGA" <> _CabVenta."Status SGA"::" " THEN ERROR('Devolución enviada a SGA.');
        END;

        if rWarehouseSetup.Get() then
            Rec."Location Code" := rWarehouseSetup."Default Return Location";
    end;

    procedure SetDocEditable()
    var
        _InfoCompany: Record "Company Information";
    begin
        // SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN BEGIN
            IF NOT _Cabventa.GET(rec."Document Type", rec."Document No.") THEN
                DocEditable := TRUE
            ELSE
                DocEditable := (rec."Document Type" <> rec."Document Type"::"Return Order") OR (_Cabventa."Status SGA" = _Cabventa."Status SGA"::" ");
        END
        ELSE
            DocEditable := TRUE;
    end;
}
