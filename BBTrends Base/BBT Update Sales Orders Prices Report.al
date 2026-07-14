report 50014 "BBT Update Sales Orders Prices"
{
    ApplicationArea = All;
    Caption = 'Update Sales Orders Prices', comment = 'ESP="Actualizar precios pedidos venta"';
    UsageCategory = None;
    ProcessingOnly = true;
    Permissions = tabledata "Sales Header"=r,
        tabledata "Sales Line"=rm;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.")where("Document Type"=const("Order"));
            RequestFilterFields = "No.", "Sell-to Customer No.";

            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLinkReference = "Sales Header";
                DataItemLink = "Document Type"=field("Document Type"), "Document No."=field("No.");
                DataItemTableView = sorting("Document Type", "No.")where("Document Type"=const("Order"));

                trigger OnAfterGetRecord()
                begin
                    "Sales Line".UpdateUnitPrice(FieldNo("No."));
                    "Sales Line".Modify(true);
                end;
            }
        }
    }
    trigger OnPostReport()
    var
        LocalText000Lbl: Label 'Process completed', comment = 'ESP="Proceso completado"';
    begin
        Message(LocalText000Lbl);
    end;
}
