PageExtension 50124 "BBT Purchase Order Subform" extends "Purchase Order Subform"
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
        modify("IC Partner Code")
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
        modify(Nonstock)
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
        modify("Drop Shipment")
        {
            Editable = DocEditable;
        }
        modify("Return Reason Code")
        {
            Editable = DocEditable;
            Visible = false;
        }
        modify("Location Code")
        {
            Editable = DocEditable;
        }
        modify("Bin Code")
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
        modify("Indirect Cost %")
        {
            Editable = DocEditable;
        }
        modify("Unit Cost (LCY)")
        {
            Editable = DocEditable;
        }
        modify("Unit Price (LCY)")
        {
            Editable = DocEditable;
        }
        modify("Line Amount")
        {
            Editable = DocEditable;
        }
        modify("Line Discount %")
        {
            Editable = DocEditable;
        }
        modify("Line Discount Amount")
        {
            Editable = DocEditable;
        }
        modify("Prepayment %")
        {
            Editable = DocEditable;
        }
        modify("Prepmt. Line Amount")
        {
            Editable = DocEditable;
        }
        modify("Prepmt. Amt. Inv.")
        {
            Editable = DocEditable;
        }
        modify("Allow Invoice Disc.")
        {
            Editable = DocEditable;
        }
        modify("Inv. Discount Amount")
        {
            Editable = DocEditable;
        }
        modify("Prepmt Amt to Deduct")
        {
            Editable = DocEditable;
        }
        modify("Allow Item Charge Assignment")
        {
            Editable = DocEditable;
        }
        modify("Job No.")
        {
            Editable = DocEditable;
        }
        modify("Job Task No.")
        {
            Editable = DocEditable;
        }
        modify("Job Planning Line No.")
        {
            Editable = DocEditable;
        }
        modify("Job Line Type")
        {
            Editable = DocEditable;
        }
        modify("Job Unit Price")
        {
            Editable = DocEditable;
        }
        modify("Job Line Amount")
        {
            Editable = DocEditable;
        }
        modify("Job Line Discount Amount")
        {
            Editable = DocEditable;
        }
        modify("Job Line Discount %")
        {
            Editable = DocEditable;
        }
        modify("Job Total Price")
        {
            Editable = DocEditable;
        }
        modify("Job Unit Price (LCY)")
        {
            Editable = DocEditable;
        }
        modify("Job Total Price (LCY)")
        {
            Editable = DocEditable;
        }
        modify("Requested Receipt Date")
        {
            Editable = DocEditable;
            Visible = false;
        }
        modify("Promised Receipt Date")
        {
            Editable = DocEditable;
            Visible = false;
        }
        modify("Planned Receipt Date")
        {
            Editable = DocEditable;
        }
        modify("Expected Receipt Date")
        {
            Editable = DocEditable;
        }
        modify("Order Date")
        {
            Editable = DocEditable;
        }
        modify("Lead Time Calculation")
        {
            Editable = DocEditable;
        }
        modify("Planning Flexibility")
        {
            Editable = DocEditable;
        }
        modify(Finished)
        {
            Editable = DocEditable;
        }
        modify("Inbound Whse. Handling Time")
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
        modify("Appl.-to Item Entry")
        {
            Editable = DocEditable;
        }
        modify("Deferral Code")
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
        modify("Over-Receipt Code")
        {
            Visible = false;
        }
        modify("Reserved Quantity")
        {
            Visible = false;
        }
        addafter("Qty. to Assign")
        {
            field("BBT Line Status"; Rec."BBT Line Status")
            {
                ApplicationArea = all;
                Visible = false;
                Editable = false;
            }
            field("BBT ETA Planning"; Rec."BBT ETA Planning")
            {
                ApplicationArea = all;
                Visible = false;
                Editable = false;
            }
            field("Container Nr"; Rec."Container Nr")
            {
                ApplicationArea = all;
                Visible = false;
                Editable = false;
            }
            field("Container Volumen"; Rec."Container Volume")
            {
                ApplicationArea = all;
                Visible = false;
                Editable = false;
            }
            field("Ship Name"; Rec."Ship Name")
            {
                ApplicationArea = all;
                Visible = false;
                Editable = false;
            }
            //>> Campo Obsoleto
            /*
            field("Consolidated Shipment"; Rec."Consolidated Shipment")
            {
                ApplicationArea = all;
                Visible = false;
                Editable = false;
            }
            */
            //
            field("Consolidation Reference"; Rec."Consolidation Reference")
            {
                ApplicationArea = all;
                Visible = false;
                Editable = false;
            }
            field("BBT Cntr Type"; Rec."BBT Cntr Type")
            {
                ApplicationArea = all;
                Visible = false;
                Editable = false;
            }
            field("BBT Inspection"; Rec."BBT Inspection")
            {
                ApplicationArea = all;
                Visible = false;
                Editable = false;
                ;
            }
            field("BBT Result"; Rec."BBT Result")
            {
                ApplicationArea = all;
                Visible = false;
                Editable = false;
            }
            field("BBT Forwarder"; Rec."BBT Forwarder")
            {
                ApplicationArea = all;
                Visible = false;
                Editable = false;
            }
            field("BBT ENS"; Rec."BBT ENS")
            {
                ApplicationArea = all;
                Visible = false;
                Editable = false;
            }
            field(ETA; Rec.ETA)
            {
                ApplicationArea = all;
                Visible = false;
                Editable = false;
            }
            field("Shipping container"; Rec."Shipping container")
            {
                ApplicationArea = all;
                Visible = false;
                Editable = false;
            }
            field("Receipt Nr"; Rec."Receipt Nr")
            {
                ApplicationArea = all;
                Visible = false;
                Editable = false;
            }
            field("Receipt Line Nr"; Rec."Receipt Line Nr")
            {
                ApplicationArea = all;
                Visible = false;
                Editable = false;
            }
        }
        addafter("Job Line Amount (LCY)")
        {
            field("Port - POL"; Rec."Port - POL")
            {
                ApplicationArea = all;
                Visible = false;
                Editable = false;
            }
            field("Port - POD"; Rec."Port - POD")
            {
                ApplicationArea = all;
                Visible = false;
                Editable = false;
            }
        }
        addafter("Deferral Code")
        {
            field("FA Posting Type"; Rec."FA Posting Type")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
    }
    var
        _InfoCompany: Record "Company Information";
        _CabCompra: Record "Purchase Header";
        DocEditable: Boolean;
        TypeChosen: Boolean;

    trigger OnAfterGetRecord()
    begin
        rec.ShowShortcutDimCode(ShortcutDimCode);
        TypeChosen := HasTypeToFillMandatotyFields;
        // SGA
        SetDocEditable;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        // SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN BEGIN
            _CabCompra.GET(rec."Document Type", rec."Document No.");
            IF _CabCompra."Status SGA" <> _CabCompra."Status SGA"::" " THEN ERROR('Pedido enviado a SGA.');
        END;
        // SGA
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        _CabCompra: Record "Purchase Header";
        _InfoCompany: Record "Company Information";
    begin
        // SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN BEGIN
            _CabCompra.GET(rec."Document Type", rec."Document No.");
            IF _CabCompra."Status SGA" <> _CabCompra."Status SGA"::" " THEN ERROR('Pedido enviado a SGA.');
        END;
    end;

    trigger OnOpenPage()
    begin
        // SGA
        IF Rec."Document No." <> '' then begin
            IF NOT rec.FINDSET THEN
                DocEditable := TRUE
            ELSE
                SetDocEditable;
        end
        else
            DocEditable := true;
    end;

    local procedure SetDocEditable()
    var
        _CabCompra: Record "Purchase Header";
    begin
        _CabCompra.Get(Rec."Document Type", Rec."Document No.");
        DocEditable := (Rec."Document Type" <> Rec."document type"::Order) or (_CabCompra."Status SGA" = _CabCompra."status sga"::" ");
    end;

    procedure HasTypeToFillMandatotyFields(): Boolean
    begin
        EXIT(rec.Type <> rec.Type::" ");
    end;

}
