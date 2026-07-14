reportextension 50007 "BBT Subcont. - Dispatch List" extends "Subcontractor - Dispatch List"
{
    RDLCLayout = './src/ReportExtension/Layouts/SubcontractorDispatchList.rdl';

    dataset
    {
        modify("Prod. Order Component")
        {
        trigger OnAfterPreDataItem()
        begin
            "Prod. Order Component".SetRange("Remaining Quantity");
        end;
        }
    }
}
