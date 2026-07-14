reportextension 50005 "BBT Prod. Order - List" extends "Prod. Order - List"
{
    RDLCLayout = './src/ReportExtension/Layouts/ProdOrderList.rdl';

    dataset
    {
        modify("Production Order")
        {
            trigger OnAfterAfterGetRecord()
            begin
                // RND-113
                CLEAR(LinProdOrder);
                IF "Production Order"."Source Type" = "Production Order"."Source Type"::Item THEN BEGIN
                    LinProdOrder.SETRANGE(Status, Status);
                    LinProdOrder.SETRANGE("Prod. Order No.", "No.");
                    LinProdOrder.SETRANGE("Item No.", "Source No.");
                    IF NOT LinProdOrder.FINDFIRST THEN CLEAR(LinProdOrder);
                END;
            end;
        }
        add("Production Order")
        {
            column(BBT_Production_Order_Quantity; LinProdOrder.Quantity)
            { }
            column(BBT_Finished_quantity_caption; LinProdOrder.FIELDCAPTION("Finished Quantity"))
            { }
            column(BBT_Remaining_quantity_caption; LinProdOrder.FIELDCAPTION(LinProdOrder."Remaining Quantity"))
            { }
            column(BBT_Finished_quantity; LinProdOrder."Finished Quantity")
            { }
            column(BBT_Remaining_quantity; LinProdOrder."Remaining Quantity")
            { }
        }
    }
    var
        LinProdOrder: Record "Prod. Order Line";
}
