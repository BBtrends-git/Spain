TableExtension 51457 "SGA Warehouse Shipment Header" extends "Warehouse Shipment Header"
{
    fields
    {
        field(51450; "SGA Destination Type"; Enum "Warehouse Destination Type")
        {
            Caption = 'SGA Destination Type', Comment = 'ESP="Tipo Destino';
            Editable = false;
            CalcFormula = lookup("Warehouse Shipment Line"."Destination Type" where("No." = field("No.")));
            FieldClass = FlowField;
        }
        field(51451; "SGA Destination No."; Code[20])
        {
            Caption = 'SGA Destination No.', Comment = 'ESP="No. Destino';
            Editable = false;
            CalcFormula = lookup("Warehouse Shipment Line"."Destination No." where("No." = field("No.")));
            FieldClass = FlowField;
            TableRelation = if ("SGA Destination Type" = const(Customer)) Customer."No."
            else if ("SGA Destination Type" = const(Vendor)) Vendor."No."
            else if ("SGA Destination Type" = const(Location)) Location.Code;
        }
        field(51452; "SGA Status"; Enum "SGA Status")
        {
            Caption = 'SGA Status', Comment = 'ESP="Estado SGA"';
        }
        field(51453; "SGA Inserted"; DateTime)
        {
            Caption = 'SGA Inserted', Comment = 'ESP="Grabado SGA"';
            Editable = false;
        }
        field(51454; "SGA Readed"; DateTime)
        {
            Caption = 'SGA Readed', Comment = 'ESP="Leido SGA"';
            Editable = false;
        }
        field(51455; "SGA Source No."; Code[20])
        {
            Caption = 'SGA Source No.', Comment = 'ESP="No. Origen"';
            Editable = false;
            CalcFormula = lookup("Warehouse Shipment Line"."Source No." where("No." = field("No.")));
            FieldClass = FlowField;
        }
        field(51457; "SGA Modified"; Boolean)
        {
            Caption = 'SGA Modified', Comment = 'ESP="Modificado SGA"';
            Editable = false;
        }
        field(51458; "SGA Warehouse Delivery Number"; Code[20])
        {
            Caption = 'Warehouse Delivery Number', Comment = 'ESP="No. Entrega Almacen"';
            Editable = false;
        }
    }
}