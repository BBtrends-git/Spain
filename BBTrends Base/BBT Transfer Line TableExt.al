TableExtension 50163 "BBT Transfer Line" extends "Transfer Line"
{
    fields
    {
        field(50000; "Status SGA"; Option)
        {
            CalcFormula = lookup("Transfer Header"."Status SGA" where("No." = field("Document No.")));
            Description = 'SGA';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = ' ,SGA Sent,SGA Locked', Comment = 'ESP=" ,Enviado SGA,Bloqueado SGA"';
            OptionMembers = " ","Enviado SGA","Bloqueado SGA";
        }
        field(50001; "Automatic creation"; Boolean)
        {
            Caption = 'Automatic creation';
        }
        field(50100; "Exported to CSV"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50101; "Exported to CSV Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "Exported to Suus"; Boolean)
        {
        }
        field(50103; "Exported to Suus Datetime"; DateTime)
        {
        }
    }

    procedure EnviarSGA()
    var
        _Cabtransfer: Record "Transfer Header";
        _InfoCompany: Record "Company Information";
    begin
        // SGA
        _InfoCompany.Get;
        if _InfoCompany.SGA then begin
            _Cabtransfer.Get(Rec."Document No.");
            if _Cabtransfer."Status SGA" <> _Cabtransfer."status sga"::" " then begin
                _Cabtransfer.ModificadoSGA := true;
                _Cabtransfer.Modify;
            end;
        end;
    end;

}
