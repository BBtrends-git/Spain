table 51103 "BBT Item Exclusive Sales"
{
    ObsoleteState = Pending;

    Caption = 'Item Exclusive Sales', Comment = 'ESP="Ventas Exclusiva Articulos"';
    DataClassification = ToBeClassified;

    fields
    {
        field(51165; "Item No."; Code[20])
        {
            Caption = 'Item No.', Comment = 'ESP="Nº producto"';
        }
        field(51166; "National Group"; Code[10])
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