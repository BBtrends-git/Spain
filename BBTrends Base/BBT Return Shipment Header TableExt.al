tableextension 50005 "BBT Return Shipment Header" extends "Return Shipment Header"
{
    fields
    {
        field(50057; "BBT ETA Planning"; Date)
        {
            Caption = 'ETA Planning', comment = 'ESP="Planning ETA"';
            DataClassification = ToBeClassified;
        }
        field(50058; "BBT Proforma"; Boolean)
        {
            Caption = 'Proforma', comment = 'ESP="Proforma"';
            DataClassification = ToBeClassified;
        }
        field(50059; "BBT ETD PI"; Date)
        {
            Caption = 'ETD PI', comment = 'ESP="ETD PI"';
            DataClassification = ToBeClassified;
        }
        field(50060; "BBT LC Opening Date"; Date)
        {
            Caption = 'LC Opening Date', comment = 'ESP="LC Fecha apertura"';
            DataClassification = ToBeClassified;
        }
        field(50061; "BBT LC Status"; Code[20])
        {
            Caption = 'LC Status', comment = 'ESP="Estado LC"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const("Status LC"));
            DataClassification = ToBeClassified;
        }
        field(50062; "BBT LC Date Received"; Date)
        {
            Caption = 'LC Date Received', comment = 'ESP="Fecha LC recibida"';
            DataClassification = ToBeClassified;
        }
        field(50063; "BBT LC No."; Code[20])
        {
            Caption = 'LC No.', comment = 'ESP="Nº LC"';
            DataClassification = ToBeClassified;
        }
        field(50064; "BBT Bank"; Code[20])
        {
            Caption = 'Bank', comment = 'ESP="Banco"';
            TableRelation = "Bank Account";
            DataClassification = ToBeClassified;
        }
        field(50065; "BBT ETD LC"; Date)
        {
            Caption = 'ETD LC', comment = 'ESP="ETD LC"';
            DataClassification = ToBeClassified;
        }
        field(50066; "BBT Due Date ETD PI"; Date)
        {
            Caption = 'Due Date ETD PI', comment = 'ESP="Fecha vencimiento ETD PI"';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50067; "BBT Status"; Code[20])
        {
            Caption = 'Status', comment = 'ESP="Estado"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const("Status"));
            DataClassification = ToBeClassified;
        }
        field(50068; "BBT Situation"; Code[20])
        {
            Caption = 'Situation', comment = 'ESP="Situación"';
            TableRelation = "BBT Purchase Auxiliary Status"."BBT Code" where("BBT Type" = const(Situation));
            DataClassification = ToBeClassified;
        }
    }
}
