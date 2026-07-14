Table 50036 "PSHOP - Order State"
{
    Caption = 'Estado pedido Prestashop';
    //DrillDownPageID = "PSHOP - Order States";
    //LookupPageID = "PSHOP - Order States";

    ObsoleteState = Removed;        // BBT 01/07/2025

    fields
    {
        field(1; id; Integer)
        { }
        field(2; unremovable; Integer)
        { }
        field(3; delivery; Integer)
        { }
        field(4; hidden; Integer)
        { }
        field(5; send_email; Integer)
        { }
        field(6; module_name; Text[30])
        { }
        field(7; invoice; Integer)
        { }
        field(8; color; Text[30])
        { }
        field(9; logable; Integer)
        { }
        field(10; shipped; Integer)
        { }
        field(11; paid; Integer)
        { }
        field(12; pdf_delivery; Integer)
        { }
        field(13; pdf_invoice; Integer)
        { }
        field(14; deleted; Integer)
        { }
        field(15; name; Text[50])
        { }
        field(16; "Site Code"; Code[10])
        {
            TableRelation = "PSHOP - Site".Code;
        }
        field(100; "Convert Order"; Boolean)
        {
            Caption = 'Convertir a pedido NAV';
        }
        field(101; "Order Prepared"; Boolean)
        {
            Caption = 'Pedido preparado';

            //ObsoleteState = Removed;
            /*
            trigger OnValidate()
            var
                PSHOPOrderState: Record "PSHOP - Order State";
            begin
                if "Order Prepared" then begin
                    PSHOPOrderState.Reset;
                    PSHOPOrderState.SetFilter(id, '<>%1', id);
                    PSHOPOrderState.SetRange("Order Prepared", true);
                    if PSHOPOrderState.FindSet then Error('El estado ' + PSHOPOrderState.name + ' tiene ya está marcado como ' + FieldCaption("Order Prepared"));
                end;
            end;
            */
        }
        field(102; "Order Shipped"; Boolean)
        {
            Caption = 'Pedido enviado';
            //ObsoleteState = Removed;
            /*
            trigger OnValidate()
            var
                PSHOPOrderState: Record "PSHOP - Order State";
            begin
                if "Order Shipped" then begin
                    PSHOPOrderState.Reset;
                    PSHOPOrderState.SetFilter(id, '<>%1', id);
                    PSHOPOrderState.SetRange("Order Shipped", true);
                    if PSHOPOrderState.FindSet then Error('El estado ' + PSHOPOrderState.name + ' tiene ya está marcado como ' + FieldCaption("Order Shipped"));
                end;
            end;
            */
        }
        field(103; "Order Delivered"; Boolean)
        {
            Caption = 'Pedido entregado';

            //ObsoleteState = Removed;
            /*
            trigger OnValidate()
            var
                PSHOPOrderState: Record "PSHOP - Order State";
            begin
                if "Order Delivered" then begin
                    PSHOPOrderState.Reset;
                    PSHOPOrderState.SetFilter(id, '<>%1', id);
                    PSHOPOrderState.SetRange("Order Delivered", true);
                    if PSHOPOrderState.FindSet then Error('El estado ' + PSHOPOrderState.name + ' tiene ya está marcado como ' + FieldCaption("Order Delivered"));
                end;
            end;
            */
        }
    }
    keys
    {
        key(Key1; "Site Code", id)
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }
}
