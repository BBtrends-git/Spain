PageExtension 50216 "BBT Whse. Shipment Subform" extends "Whse. Shipment Subform"
{
    layout
    {
        modify("Zone Code")
        {
            Editable = DocEditable;
        }
        modify("Bin Code")
        {
            Editable = DocEditable;
        }
        modify("Shelf No.")
        {
            Editable = DocEditable;
        }
        modify("Qty. to Ship")
        {
            Editable = DocEditable;
        }
        modify("Qty. to Ship (Base)")
        {
            Editable = DocEditable;
        }
        modify("Due Date")
        {
            Editable = DocEditable;
        }
    }
    var
        DocEditable: Boolean;
        _InfoCompany: Record "Company Information";
        _Cabenvio: Record "Warehouse Shipment Header";

    trigger OnOpenPage()
    begin
        // SGA
        _InfoCompany.Get;
        DocEditable := TRUE
    end;

    trigger OnAfterGetRecord()
    begin
        _Cabenvio.Get(Rec."No.");
        SetDocEditable();
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        IF rec.Enviado_A_SGA AND (rec."Qty. to Ship" <> 0) THEN ERROR('Envio en SGA.');
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // SGA
        IF rec.Enviado_A_SGA THEN ERROR('Envio en SGA.');
    end;

    local procedure SetDocEditable()
    begin
        //SGA
        DocEditable := not ((_InfoCompany.SGA) and (_Cabenvio."Status SGA" = _Cabenvio."status sga"::"Bloqueado SGA"));
    end;
}
