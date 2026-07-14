PageExtension 50141 "BBT Posted Sales Invoices" extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Currency Code")
        {
            field("Warehouse SHip No"; WarehouseShipNo)
            {
                ApplicationArea = Basic;
                Caption = 'Nº envío';
            }
            field("Shipment No"; ShipmentNo)
            {
                ApplicationArea = Basic;
                Caption = 'Nº albarán venta';
            }
        }
        addafter("Salesperson Code")
        {
            field("Sales Person Name"; Rec."Sales Person Name")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Document Date")
        {
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(IncomingDocAttachFactBox)
        {
            part(Control1000000002; "Customer Details FactBox")
            {
                SubPageLink = "No." = field("Bill-to Customer No.");
                ApplicationArea = all;
            }
        }
        moveafter(IncomingDocAttachFactBox; Control1905767507)
    }
    actions
    {
        addafter("Update Document")
        {
            action(ChangeSII)
            {
                Caption = 'Mark/Unmark "Do Not Send To SII"', comment = 'ESP="Marcar/Desmarcar "No enviar a SII""';
                ToolTip = 'Change de "Do Not Send To SII" value field on selected records.', comment = 'ESP="Cambia el valor del campo "No enviar al SII" en los registros seleccionados."';
                Image = CheckList;
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Text000: label 'Choose an options to selected records:', comment = 'ESP="Elija una opción para los registros seleccionados:"';
                    Text001: label 'Check "Do Not Send To SII",Uncheck "Do Not Send To SII"', comment = 'ESP="Marcar "No enviar a SII",Desmarcar "No enviar a SII""';
                    SelectedOption: Integer;
                    Mark_Unmark: Boolean;
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                begin
                    SelectedOption := Dialog.StrMenu(Text001, 1, Text000);
                    Mark_Unmark := (SelectedOption = 1);
                    SalesInvoiceHeader.Reset();
                    CurrPage.SetSelectionFilter(SalesInvoiceHeader);
                    if SalesInvoiceHeader.FindSet() then begin
                        repeat
                            SalesInvoiceHeader."Do Not Send To SII" := Mark_Unmark;
                            CODEUNIT.Run(CODEUNIT::"Sales Invoice Header - Edit", SalesInvoiceHeader);
                        until SalesInvoiceHeader.Next() = 0;
                    end;
                end;
            }
        }
    }

    var
        ShipmentNo: Code[20];
        WarehouseShipNo: Code[20];
        ValueEntry: Record "Value Entry";
        ValueEntryAux: Record "Value Entry";
        SalesShipmentHeader: Record "Sales Shipment Header";

    trigger OnAfterGetRecord()
    begin
        ShipmentNo := '';
        WarehouseShipNo := '';
        ValueEntryAux.RESET;
        ValueEntryAux.SETCURRENTKEY("Document No.");
        ValueEntryAux.SETRANGE("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
        ValueEntryAux.SetRange("Source Type", ValueEntry."Source Type"::Customer);
        ValueEntryAux.SetRange("Source No.", Rec."Bill-to Customer No.");
        ValueEntryAux.SETRANGE("Document Type", ValueEntry."Document Type"::"Sales Invoice");
        ValueEntryAux.SETRANGE("Document No.", rec."No.");
        IF ValueEntryAux.FINDFIRST THEN begin
            ValueEntry.RESET;
            ValueEntry.SETRANGE("Item Ledger Entry No.", ValueEntryAux."Item Ledger Entry No.");
            ValueEntry.SETRANGE("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
            ValueEntry.SETRANGE("Document Type", ValueEntry."Document Type"::"Sales Shipment");
            ValueEntry.SetRange("Source Type", ValueEntryAux."Source Type");
            ValueEntry.SetRange("Source No.", ValueEntryAux."Source No.");
            IF ValueEntry.FINDFIRST THEN begin
                ShipmentNo := ValueEntry."Document No.";
                SalesShipmentHeader.RESET;
                SalesShipmentHeader.SETRANGE("No.", ShipmentNo);
                IF SalesShipmentHeader.FINDFIRST THEN begin
                    // - Incidencia 133
                    //WarehouseShipNo := SalesShipmentHeader."Warehose Ship No.2";
                    SalesShipmentHeader.CalcFields("Warehose Ship No.");
                    WarehouseShipNo := SalesShipmentHeader."Warehose Ship No.";
                    // + Incidencia 133
                end;
            end;
        end;
    end;
}
