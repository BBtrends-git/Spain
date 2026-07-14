Table 50004 "Temp SQL"
{
    //>> SGA Extension
    ObsoleteState = Pending;
    //<<

    // SGA Tabla Temporal.

    fields
    {
        field(1; ID; BigInteger)
        { }
        field(2; Error; Text[250])
        { }
        field(3; Tipo; Text[10])
        { }
        field(4; "No. Documento"; Code[20])
        { }
    }
    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }
}
