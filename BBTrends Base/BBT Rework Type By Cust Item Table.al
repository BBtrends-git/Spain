table 50054 "BBT Rework Type By Cust./Item"
{
    Caption = 'Rework Type By Customer/Item', comment = 'ESP="Tipo retrabajo por cliente/producto"';
    LookupPageId = "BBT Rework Type By Cust./Item";
    DrillDownPageId = "BBT Rework Type By Cust./Item";
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "BBT Customer No."; Code[20])
        {
            Caption = 'Customer No.', comment = 'ESP="Nº cliente"';
            TableRelation = Customer;
            DataClassification = ToBeClassified;
        }
        field(2; "BTT Rework Item No."; Code[20])
        {
            Caption = 'Rework Item No.', comment = 'ESP="Nº producto retrabajo"';
            TableRelation = Item where("BBT Rework" = const(true));
            NotBlank = true;
            DataClassification = ToBeClassified;
        }
        field(50031; "BBT Rework Type"; Text[250])
        {
            Caption = 'Rework Type', comment = 'ESP="Tipo retrabajo"';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "BBT Customer No.", "BTT Rework Item No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        myInt: Integer;
        Rework: Record "BBT Rework Type By Cust./Item";
    begin
        If Rec."BBT Customer No." <> '' then begin
            Clear(Rework);
            Rework.SetRange("BBT Customer No.", '');
            Rework.SetRange("BTT Rework Item No.", Rec."BTT Rework Item No.");
            IF Rework.FindFirst() then Error(' Ya existe un retrabajo generico para ese producto.');
        end;
    end;
}
