Table 51301 "SMG Customer Classification"
{
    Caption = 'Customer Classification', comment = 'ESP="Clasificación Cliente"';
    DataCaptionFields = Code, Description;

    fields
    {
        field(1; Type; enum "SMG Customer Classification")
        {
            Caption = 'Type', comment = 'ESP="Tipo"';
        }
        field(2; Code; Code[20])
        {
            Caption = 'Code', comment = 'ESP="Código"';
            NotBlank = true;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
        field(4; "Exclude Margin Calculation"; Boolean)
        {
            Caption = 'Exclude Margin Calculation', Comment = 'ESP="Excluye Cálculo Margen"';
        }
        field(5; "Minimum Margin %"; Decimal)
        {
            Caption = 'Minimum Margin %', Comment = 'ESP="% Mínimo de Margen"';
            DecimalPlaces = 2 : 2;
            MaxValue = 100;
            MinValue = 0;
        }
    }
    keys
    {
        key(Key1; Type, Code)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Code, Description)
        { }

    }
}
