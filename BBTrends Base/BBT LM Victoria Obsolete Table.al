Table 50106 "LM_Victoria"
{
    ObsoleteState = Removed;    // BBT 01/07/2025

    fields
    {
        field(1; Orden; Integer)
        { }
        field(2; level; Integer)
        { }
        field(3; CodPadre; Code[20])
        { }
        field(4; OrdLM; Code[20])
        { }
        field(5; Componente; Code[20])
        { }
        field(6; Descripcion; Text[100])
        { }
        field(7; Cantidad; Decimal)
        { }
        field(8; UnidadMedida; Code[20])
        { }
        field(9; Relevanciacoste; Boolean)
        { }
        field(10; dummy; Boolean)
        { }
        field(11; DumySub; Integer)
        { }
        field(12; ProdNivel0; Code[20])
        { }
        field(13; Posicion3; Code[10])
        { }
    }
    keys
    {
        key(Key1; Orden)
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }
}
