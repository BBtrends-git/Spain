TableExtension 50176 "BBT Warehouse Shipment Header" extends "Warehouse Shipment Header"
{
    fields
    {
        field(50000; "Destination Type"; Enum "Warehouse Destination Type")
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            CalcFormula = lookup("Warehouse Shipment Line"."Destination Type" where("No." = field("No.")));
            Caption = 'Destination Type';
            Description = 'SGA';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "Destination No."; Code[20])
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            CalcFormula = lookup("Warehouse Shipment Line"."Destination No." where("No." = field("No.")));
            Caption = 'Destination No.';
            Description = 'SGA';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = if ("Destination Type" = const(Customer)) Customer."No."
            else if ("Destination Type" = const(Vendor)) Vendor."No."
            else if ("Destination Type" = const(Location)) Location.Code;
        }
        field(50002; "Status SGA"; Option)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Caption = 'Status SGA';
            Description = 'SGA';
            Editable = false;
            OptionCaption = ' ,SGA Sent,SGA Locked', Comment = 'ESP=" ,Enviado SGA,Bloqueado SGA"';
            OptionMembers = " ","Enviado SGA","Bloqueado SGA";
        }
        field(50003; "Grabado SGA"; DateTime)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Description = 'SGA';
            Editable = false;
        }
        field(50004; "Leido SGA"; DateTime)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Description = 'SGA';
            Editable = false;
        }
        field(50005; ModificadoSGA; Boolean)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Description = 'SGA';
            Editable = false;
        }
        field(50006; "No. entrega almacen"; Code[20])
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Description = 'SGA';
        }
        field(50007; "Source No."; Code[20])
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            CalcFormula = lookup("Warehouse Shipment Line"."Source No." where("No." = field("No.")));
            Caption = 'Source No.';
            Description = 'TC-007';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
