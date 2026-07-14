Table 51451 "SGA Blocked Documents"
{
    fields
    {
        field(1; "SGA Document Type"; Enum "SGA Document Type")
        {
            Caption = 'Document Type', Comment = 'ESP="Tipo Documento"';
        }
        field(2; "SGA Document No."; Code[20])
        {
            Caption = 'Document No.', Comment = 'ESP="No. Documento"';
        }
    }
    keys
    {
        key(Key1; "SGA Document Type", "SGA Document No.")
        {
            Clustered = true;
        }
    }
}