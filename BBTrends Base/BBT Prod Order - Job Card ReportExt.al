reportextension 50004 "BBT Prod. Order - Job Card" extends "Prod. Order - Job Card"
{
    //001 IBER AGI 05/05/16 - P13: Mostrar campo Cantidad de la O.P. en cabecera del informe
    RDLCLayout = './src/ReportExtension/Layouts/ProdOrderJobCard.rdl';

    dataset
    {
        add("Production Order")
        {
            column(Quantity_ProdOrder; Quantity)
            {
            IncludeCaption = true;
            }
        }
    }
}
