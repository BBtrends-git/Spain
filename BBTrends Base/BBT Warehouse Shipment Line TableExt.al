TableExtension 50177 "BBT Warehouse Shipment Line" extends "Warehouse Shipment Line"
{
    fields
    {
        field(50000; "Qty. SGA"; Decimal)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<
            Caption = 'Qty. SGA';
            DecimalPlaces = 0 : 5;
            Description = 'SGA';
            Editable = false;

            trigger OnValidate()
            begin
                Rec."Qty. SGA (Base)" := CalcBaseQty(Rec."Qty. SGA");
            end;
        }
        field(50001; "Qty. SGA (Base)"; Decimal)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<
            Caption = 'Qty. SGA (Base)';
            DecimalPlaces = 0 : 5;
            Description = 'SGA';
            Editable = false;

            trigger OnValidate()
            begin
                Rec.Validate(Rec."Qty. SGA", Rec.CalcQty(Rec."Qty. SGA (Base)"));
            end;
        }
        field(50002; "Warehouse delivery number"; Code[25])
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<
            Description = 'SGA';
        }
        field(50003; "Status SGA"; Option)
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<
            CalcFormula = lookup("Warehouse Shipment Header"."Status SGA" where("No." = field("No.")));
            Caption = 'Status SGA';
            Description = 'SGA';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = ' ,SGA Sent,SGA Locked', Comment = 'ESP=" ,Enviado SGA,Bloqueado SGA"';
            OptionMembers = " ","Enviado SGA","Bloqueado SGA";
        }
    }

    procedure CalcBaseQty(Qty: Decimal): Decimal
    begin
        TESTFIELD("Qty. per Unit of Measure");
        EXIT(ROUND(Qty * "Qty. per Unit of Measure", 0.00001));
    end;

    procedure Enviado_A_SGA(): Boolean
    var
        _CabEnvio: Record "Warehouse Shipment Header";
        _InfoCompany: Record "Company Information";
    begin
        // SGA
        _InfoCompany.Get;
        _CabEnvio.Get(Rec."No.");
        if _InfoCompany.SGA then
            exit(_CabEnvio."Status SGA" <> _CabEnvio."status sga"::" ")
        else
            exit(false);
    end;

    procedure ActModifSGA()
    var
        _Cabenvio: Record "Warehouse Shipment Header";
        _InfoCompany: Record "Company Information";
    begin
        // SGA
        _InfoCompany.Get;
        if _InfoCompany.SGA then begin
            _Cabenvio.Get(Rec."No.");
            _Cabenvio.ModificadoSGA := true;
            _Cabenvio.Modify;
        end;
    end;
}
