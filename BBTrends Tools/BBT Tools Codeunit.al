Codeunit 59001 "BBT Tools Codeunit"
{
    Permissions = TableData "Item Ledger Entry" = rimd, Tabledata "Sales Shipment Line" = rimd;
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var

    begin

        case Rec."Parameter String" of

            'UPDITEMENTRY':
                UpdateItemEntry;              // Modificar registro de la Item Ledger Entry
            'UPDSHIPMENT':
                UpdateShipment;              // Modificar registro de la Sales Shipment Line
            else
                Error('Parámetro no reconocido: ' + Rec."Parameter String");

        end;

    end;

    procedure UpdateItemEntry()
    var
        rItemLedgerEntry: Record "Item Ledger Entry";

    begin
        rItemLedgerEntry.Reset();

        rItemLedgerEntry.SetFilter("Location Code", '=%1', '');
        if rItemLedgerEntry.FindSet() then
            repeat begin
                case rItemLedgerEntry."Entry No." of
                /*
                780512:
                    begin
                        rItemLedgerEntry.Validate("Location Code", 'MARGA');
                        rItemLedgerEntry.Validate("Posting Date", DMY2Date(07, 10, 2025));
                        rItemLedgerEntry.Validate("Document No.", 'SGA0278678');
                        rItemLedgerEntry.Validate("Description", 'Alta de stock por cambio situacion de stock');
                        rItemLedgerEntry.Validate("Unit of Measure Code", 'UNID');
                        rItemLedgerEntry.Validate("Remaining Quantity", 0);
                        rItemLedgerEntry.Validate(Open, false);
                        rItemLedgerEntry.Validate("Qty. per Unit of Measure", 1);
                        rItemLedgerEntry.Validate("Transaction Type", '00');
                        rItemLedgerEntry.Validate("External Document No.", '2799454');
                        rItemLedgerEntry.Validate("User ID", 'ADMINISTRADOR');
                        rItemLedgerEntry.Validate("Invoiced Quantity", 50);
                        rItemLedgerEntry.Validate("Item Category Code", '8320');
                        rItemLedgerEntry.Validate("Global Dimension 2 Code", 'UFESA');
                        rItemLedgerEntry."Hora Registro" := rItemLedgerEntry.SystemCreatedAt;
                        rItemLedgerEntry.Modify()
                    end;
                697429:
                    begin
                        rItemLedgerEntry.Validate("Location Code", 'MARGA');
                        rItemLedgerEntry.Validate("Posting Date", DMY2Date(16, 07, 2025));
                        rItemLedgerEntry.Validate("Document No.", 'SGA0244786');
                        rItemLedgerEntry.Validate("Description", 'Alta de stock por cambio situacion de stock');
                        rItemLedgerEntry.Validate("Unit of Measure Code", 'UNID');
                        rItemLedgerEntry.Validate("Remaining Quantity", 288);
                        rItemLedgerEntry.Validate(Open, true);
                        rItemLedgerEntry.Validate("Qty. per Unit of Measure", 1);
                        rItemLedgerEntry.Validate("Transaction Type", '00');
                        rItemLedgerEntry.Validate("External Document No.", '2694952');
                        rItemLedgerEntry.Validate("User ID", 'ADMINISTRADOR');
                        rItemLedgerEntry.Validate("Invoiced Quantity", 294);
                        rItemLedgerEntry.Validate("Item Category Code", '6010');
                        rItemLedgerEntry.Validate("Global Dimension 2 Code", 'UFESA');
                        rItemLedgerEntry."Hora Registro" := rItemLedgerEntry.SystemCreatedAt;
                        rItemLedgerEntry.Modify()
                    end;
                780504:
                    begin
                        rItemLedgerEntry.Validate("Location Code", 'MARGA');
                        rItemLedgerEntry.Validate("Posting Date", DMY2Date(07, 10, 2025));
                        rItemLedgerEntry.Validate("Document No.", 'SGA0278678');
                        rItemLedgerEntry.Validate("Description", 'Alta de stock por cambio situacion de stock');
                        rItemLedgerEntry.Validate("Unit of Measure Code", 'UNID');
                        rItemLedgerEntry.Validate("Remaining Quantity", 37);
                        rItemLedgerEntry.Validate(Open, true);
                        rItemLedgerEntry.Validate("Qty. per Unit of Measure", 1);
                        rItemLedgerEntry.Validate("Transaction Type", '00');
                        rItemLedgerEntry.Validate("External Document No.", '2799438');
                        rItemLedgerEntry.Validate("User ID", 'ADMINISTRADOR');
                        rItemLedgerEntry.Validate("Invoiced Quantity", 50);
                        rItemLedgerEntry.Validate("Item Category Code", '8320');
                        rItemLedgerEntry.Validate("Global Dimension 2 Code", 'UFESA');
                        rItemLedgerEntry."Hora Registro" := rItemLedgerEntry.SystemCreatedAt;
                        rItemLedgerEntry.Modify()
                    end;
                786992:
                    begin
                        rItemLedgerEntry.Validate("Location Code", 'MARGA');
                        rItemLedgerEntry.Validate("Posting Date", DMY2Date(10, 10, 2025));
                        rItemLedgerEntry.Validate("Document No.", 'SGA0280444');
                        rItemLedgerEntry.Validate("Description", 'Alta de stock por cambio situacion de stock');
                        rItemLedgerEntry.Validate("Unit of Measure Code", 'UNID');
                        rItemLedgerEntry.Validate("Remaining Quantity", 8);
                        rItemLedgerEntry.Validate(Open, true);
                        rItemLedgerEntry.Validate("Qty. per Unit of Measure", 1);
                        rItemLedgerEntry.Validate("Transaction Type", '00');
                        rItemLedgerEntry.Validate("External Document No.", '2807792');
                        rItemLedgerEntry.Validate("User ID", 'ADMINISTRADOR');
                        rItemLedgerEntry.Validate("Invoiced Quantity", 50);
                        rItemLedgerEntry.Validate("Item Category Code", '6020');
                        rItemLedgerEntry.Validate("Global Dimension 2 Code", 'UFESA');
                        rItemLedgerEntry."Hora Registro" := rItemLedgerEntry.SystemCreatedAt;
                        rItemLedgerEntry.Modify()
                    end;
                774206:
                    begin
                        rItemLedgerEntry.Validate("Location Code", 'MARGA');
                        rItemLedgerEntry.Validate("Posting Date", DMY2Date(02, 10, 2025));
                        rItemLedgerEntry.Validate("Entry Type", rItemLedgerEntry."Entry Type"::Transfer);
                        rItemLedgerEntry.Validate("Order Type", rItemLedgerEntry."Order Type"::Transfer);
                        rItemLedgerEntry.Validate("Document Type", rItemLedgerEntry."Document Type"::"Transfer Receipt");
                        rItemLedgerEntry.Validate("Document No.", 'RER36080');
                        rItemLedgerEntry.Validate("Order No.", 'EN038342');
                        rItemLedgerEntry.Validate("Description", 'Calientacamas Flexy Heat CME 150x130cm');
                        rItemLedgerEntry.Validate("Unit of Measure Code", 'UNID');
                        rItemLedgerEntry.Validate("Remaining Quantity", 0);
                        rItemLedgerEntry.Validate(Open, false);
                        rItemLedgerEntry.Validate("Qty. per Unit of Measure", 1);
                        rItemLedgerEntry.Validate("Transaction Type", '');
                        rItemLedgerEntry.Validate("External Document No.", '');
                        rItemLedgerEntry.Validate("User ID", 'VENTAS');
                        rItemLedgerEntry.Validate("Invoiced Quantity", 3);
                        rItemLedgerEntry.Validate("Item Category Code", '1030');
                        rItemLedgerEntry.Validate("Global Dimension 2 Code", 'UFESA');
                        rItemLedgerEntry."Hora Registro" := rItemLedgerEntry.SystemCreatedAt;
                        rItemLedgerEntry.Modify()
                    end;
            */
                end;
            end;
            until rItemLedgerEntry.Next() = 0;
    end;

    procedure UpdateShipment()
    var
        rSalesShipmentLine: Record "Sales Shipment Line";
    begin
        /*
        rSalesShipmentLine.Reset();
        rSalesShipmentLine.SetRange("Document No.", 'EV2564361');
        rSalesShipmentLine.SetRange("Line No.", 5);
        if rSalesShipmentLine.Findfirst() then
            if rSalesShipmentLine.Quantity = 0 then
                rSalesShipmentLine.Delete()
            else
                Error('Error1 - %1 - %2', rSalesShipmentLine."Document No.", rSalesShipmentLine."Line No.")
        else
            Error('Error2 - %1 - %2', rSalesShipmentLine."Document No.", rSalesShipmentLine."Line No.");
        */
    end;
}