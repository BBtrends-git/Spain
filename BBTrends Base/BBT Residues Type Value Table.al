table 50063 "BBT Residues Type Value"
{
    Caption = 'Residues Type Value', Comment = 'ESP="Valores tipo residuo"';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code', Comment = 'ESP="Cód. residuo"';
            TableRelation = "BBT Residues";
        }
        field(2; Value; Text[20])
        {
            Caption = 'Value', Comment = 'ESP="Valor"';
            NotBlank = true;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
    }
    keys
    {
        key(PK; Code, Value)
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        rlResidues: Record "BBT Residues";
        rlResiduesValues: Record "BBT Residues Type Value";
    begin
        if Rec.Value = '' then Error('Debe rellenar el campo Valor para insertar el registro.');
        if rlResidues.Get(Rec.Code)then if rlResidues.Type = rlResidues.Type::Decimal then begin
                // rlResiduesValues.Reset();
                // rlResiduesValues.SetRange("Code", rlResidues."No.");
                // if rlResiduesValues.FindFirst() then
                Error('Los residuos de tipo Decimal no pueden insertar un valor.');
            end;
    end;
}
