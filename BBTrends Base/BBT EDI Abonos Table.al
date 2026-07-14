Table 50008 "Abonos EDI"
{
    fields
    {
        field(1; "ERE1L Descripcion1Articulo"; Text[70])
        { }

        field(2; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.', comment = 'ESP="Nº cuenta"';
            TableRelation = "G/L Account";
        }
    }
    keys
    {
        key(Key1; "ERE1L Descripcion1Articulo")
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }
}
