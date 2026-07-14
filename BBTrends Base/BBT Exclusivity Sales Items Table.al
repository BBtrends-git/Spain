table 51105 "BBT Exclusivity Sales Items"
{
    Caption = 'Exclusivity Sales Items', Comment = 'ESP="Artículos Venta Exclusiva"';
    DataClassification = ToBeClassified;

    fields
    {
        field(51165; "Item No."; Code[20])
        {
            Caption = 'Item No.', Comment = 'ESP="Nº producto"';
        }
        field(51166; "National Group"; Code[20])
        {
            Caption = 'National Group', Comment = 'ESP="Grupo Nacional"';
        }
        field(51167; "Related"; Boolean)
        {
            Caption = 'Related', Comment = 'ESP="Relacionado"';
        }
    }
    keys
    {
        key(PK; "Item No.", "National Group")
        {
            Clustered = true;
        }
    }
}