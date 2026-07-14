TableExtension 50142 "BBT No. Series" extends "No. Series"
{
    // Campos obsoletos. PRECINTIA.
    fields
    {
        field(50000; "Serie Producto"; Boolean)
        {
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
        field(50001; "Lote Repetido"; Boolean)
        {
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
    }
}
