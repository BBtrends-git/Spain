Table 50047 "Atributos basicos"
{
    // *** PRECINTIA ***

    Caption = 'Atributos basicos';
    ObsoleteState = Removed;

    fields
    {
        field(1; Valor; Text[100])
        { }
        field(2; Atributo; Option)
        {
            OptionCaption = 'Material,Color,Tecnología Impresión';
            OptionMembers = Material,Color,"Tecnología Impresión";
        }
    }
    keys
    {
        key(Key1; Valor, Atributo)
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }
}
