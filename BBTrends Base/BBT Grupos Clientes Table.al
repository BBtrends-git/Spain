Table 50017 "Grupos Clientes"
{
    ObsoleteState = Removed;

    DrillDownPageID = 50041;
    LookupPageID = 50041;

    fields
    {
        field(1; "Código"; Code[20])
        { }
        field(2; "Descripción"; Text[50])
        { }
        field(3; EDI; Boolean)
        { }
    }
    keys
    {
        key(Key1; "Código")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
}
