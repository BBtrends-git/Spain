reportextension 50001 "BBT Phys. Inventory List" extends "Phys. Inventory List"
{
    RDLCLayout = './src/ReportExtension/Layouts/PhysInventoryList.rdl';

    dataset
    {
        add("Item Journal Line")
        {
            column(UnitOfMeasure_ItemJnlLin; "Item Journal Line"."Unit of Measure Code")
            { }
        }
    }
}
