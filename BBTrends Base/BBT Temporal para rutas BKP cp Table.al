Table 50118 "Temporal para rutas BKP cp"
{
    ObsoleteState = Removed;    //BBT 01/07/2025

    fields
    {
        field(1; Clave; Integer)
        { }
        field(2; "Descripción"; Text[200])
        { }
        field(3; Bloque; Integer)
        { }
        field(4; Letra; Text[10])
        { }
        field(5; Maquina; Text[10])
        { }
    }
    keys
    {
        key(Key1; Clave)
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }
}
