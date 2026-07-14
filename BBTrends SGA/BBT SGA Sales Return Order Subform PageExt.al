PageExtension 51466 "SGA Sales Return Order Subform" extends "Sales Return Order Subform"
{
    layout
    {
        modify(Type)
        {
            Editable = SGADocEditable;
        }
        modify("No.")
        {
            Editable = SGADocEditable;
        }
        modify("Item Reference No.")
        {
            Editable = SGADocEditable;
        }
        modify("IC Partner Ref. Type")
        {
            Editable = SGADocEditable;
        }
        modify("IC Partner Reference")
        {
            Editable = SGADocEditable;
        }
        modify("Variant Code")
        {
            Editable = SGADocEditable;
        }
        modify("VAT Prod. Posting Group")
        {
            Editable = SGADocEditable;
        }
        modify(Description)
        {
            Editable = SGADocEditable;
        }
        modify("Return Reason Code")
        {
            Editable = SGADocEditable;
        }
        modify("Location Code")
        {
            Editable = SGADocEditable;
        }
        modify("Bin Code")
        {
            Editable = SGADocEditable;
        }
        modify(Control28)
        {
            Editable = SGADocEditable;
        }
        modify("Reserved Quantity")
        {
            Editable = SGADocEditable;
        }
        modify("Unit of Measure Code")
        {
            Editable = SGADocEditable;
        }
        modify(Quantity)
        {
            Editable = SGADocEditable;
        }
        modify("Unit of Measure")
        {
            Editable = SGADocEditable;
        }
        modify("Unit Cost (LCY)")
        {
            Editable = SGADocEditable;
        }
        modify("Line Amount")
        {
            Editable = SGADocEditable;
        }
        modify("Line Discount %")
        {
            Editable = false;
            Visible = false;
        }
        modify("Line Discount Amount")
        {
            Editable = SGADocEditable;
        }
        modify("Allow Invoice Disc.")
        {
            Editable = SGADocEditable;
        }
        modify("Return Qty. to Receive")
        {
            Editable = SGADocEditable;
        }
        modify("Qty. to Invoice")
        {
            Editable = SGADocEditable;
        }
        modify("Allow Item Charge Assignment")
        {
            Editable = SGADocEditable;
        }
        modify("Requested Delivery Date")
        {
            Editable = SGADocEditable;
        }
        modify("Promised Delivery Date")
        {
            Editable = SGADocEditable;
        }
        modify("Planned Delivery Date")
        {
            Editable = SGADocEditable;
        }
        modify("Planned Shipment Date")
        {
            Editable = SGADocEditable;
        }
        modify("Shipment Date")
        {
            Editable = SGADocEditable;
        }
        modify("Shipping Agent Code")
        {
            Editable = SGADocEditable;
        }
        modify("Shipping Agent Service Code")
        {
            Editable = SGADocEditable;
        }
        modify("Shipping Time")
        {
            Editable = SGADocEditable;
        }
        modify("Blanket Order No.")
        {
            Editable = SGADocEditable;
        }
        modify("Blanket Order Line No.")
        {
            Editable = SGADocEditable;
        }
        modify("Appl.-from Item Entry")
        {
            Editable = SGADocEditable;
        }
        modify("Appl.-to Item Entry")
        {
            Editable = SGADocEditable;
        }
        modify("Deferral Code")
        {
            Editable = SGADocEditable;
        }
        modify("Returns Deferral Start Date")
        {
            Editable = SGADocEditable;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Editable = SGADocEditable;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Editable = SGADocEditable;
        }
        modify(ShortcutDimCode3)
        {
            Editable = SGADocEditable;
        }
        modify(ShortcutDimCode4)
        {
            Editable = SGADocEditable;
        }
        modify(ShortcutDimCode5)
        {
            Editable = SGADocEditable;
        }
        modify(ShortcutDimCode6)
        {
            Editable = SGADocEditable;
        }
        modify(ShortcutDimCode7)
        {
            Editable = SGADocEditable;
        }
        modify(ShortcutDimCode8)
        {
            Editable = SGADocEditable;
        }
    }

    var
        cuSGAManagement: Codeunit "SGA Management";
        rSalesHeader: Record "Sales Header";
        SGADocEditable: Boolean;
        Error01: Label 'Return sent to the SGA', Comment = 'ESP="Devolución enviada a SGA"';

    trigger OnOpenPage()
    begin
        //SetSGADocEditable;
    end;

    trigger OnAfterGetRecord()
    begin
        rec.ShowShortcutDimCode(ShortcutDimCode);
        SetSGADocEditable;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetSGADocEditable;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            rSalesHeader.Reset();
            if rSalesHeader.Get(rec."Document Type", rec."Document No.") then
                IF rSalesHeader."SGA Status" <> rSalesHeader."SGA Status"::" " then
                    Error(Error01);
        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        rSalesHeader: Record "Sales Header";
        rWarehouseSetup: Record "Warehouse Setup";
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            rSalesHeader.Reset();
            if rSalesHeader.Get(rec."Document Type", rec."Document No.") then
                IF rSalesHeader."SGA Status" <> rSalesHeader."SGA Status"::" " then
                    Error(Error01);
        end;
    end;

    local procedure SetSGADocEditable()
    begin
        SGADocEditable := true;
        if cuSGAManagement.IsSGAEnabled() then begin
            rSalesHeader.Reset();
            if rSalesHeader.Get(Rec."Document Type", Rec."Document No.") then
                if rSalesHeader."SGA Status" <> rSalesHeader."SGA Status"::" " then
                    SGADocEditable := false;
        end;
    end;
}
