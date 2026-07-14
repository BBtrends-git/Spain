TableExtension 50000 "BBT Purch. Inv. Line" extends "Purch. Inv. Line"
{
    fields
    {
        field(50002; ETA; Date)
        {
            Caption = 'ETA', comment = 'ESP="ETA"';
            DataClassification = ToBeClassified;
        }
        field(50003; ETD; Date)
        {
            Caption = 'ETD', comment = 'ESP="ETD"';
            DataClassification = ToBeClassified;
        }
        field(50050; "BBT Cntr Type"; Code[20])
        {
            Caption = 'Cntr Type', comment = 'ESP="Tipo Cntr"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const("Cntr Type"));
            DataClassification = ToBeClassified;
        }
        field(50051; "BBT Inspection"; Date)
        {
            Caption = 'Inspection', comment = 'ESP="Inspección"';
            DataClassification = ToBeClassified;
        }
        field(50052; "BBT Result"; Code[20])
        {
            Caption = 'Result', comment = 'ESP="Resultado"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const("Result"));
            DataClassification = ToBeClassified;
        }
        field(50053; "BBT Forwarder"; Code[20])
        {
            Caption = 'Forwarder', comment = 'ESP="Forwarder"';
            TableRelation = Vendor;
            DataClassification = ToBeClassified;
        }
        field(50054; "BBT ENS"; Date)
        {
            Caption = 'ENS', comment = 'ESP="ENS"';
            DataClassification = ToBeClassified;
        }
        field(50154; "Vendor Name"; Text[100])
        {
            CalcFormula = lookup(Vendor.Name where("No." = field("Buy-from Vendor No.")));
            Caption = 'Vendor Name';
            Description = '200916';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
