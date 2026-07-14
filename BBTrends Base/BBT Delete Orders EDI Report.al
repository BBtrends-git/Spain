Report 50012 "BBT Delete Orders EDI"
{
    Caption = 'BBT Delete Orders EDI', comment = 'ESP="BBT Delete Orders EDI"';
    Permissions = TableData "Change Log Entry" = rid,
        TableData "Sales Header" = rid,
        TableData "Sales Line" = rid;
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            RequestFilterFields = "No.";

            trigger OnPreDataItem()
            begin
                "Sales Header".SetRange("Sell-to Customer No.", 'C02544');
                "Sales Header".SetRange("External Document No.", '87002624');
                "Sales Header".SetRange(Status, "Sales Header".Status::Open);
                IF "Sales Header".GetFilter("No.") = '' then Error('Debe indicar un rango de pedido!');
                if GuiAllowed then Window.Open(Text000 + Text001);
            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                if GuiAllowed then Window.Update(1, "Sales Header"."No.");
                IF ("Sales Header"."No." = 'PV2314899') OR ("Sales Header"."No." = 'PV2314900') OR ("Sales Header"."No." = 'PV2337586') then Error('los filtros introducidos no son validos');
                "Sales Header".Delete(true);
            end;

            trigger OnPostDataItem()
            begin
            end;
        }
    }
    trigger OnPostReport()
    var
        myInt: Integer;
    begin
        Message('proceso finalizado');
    end;

    var
        Window: Dialog;
        Text000: label 'Eliminando pedidos...\\';
        Text001: label 'Pedido Nº   #1##########\';
}
