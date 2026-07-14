TableExtension 50190 "BBT Where-Used Line" extends "Where-Used Line"
{
    fields
    {
        field(50000; "Production BOM Header No."; Code[20])
        {
            Caption = 'Versión L.M. producción';
            Description = '//03/07/19 TC-003 Mostrar Lista de Materiales y puntos de Uso en Consulta\';
            TableRelation = "Production BOM Header";
        }
    }
}
