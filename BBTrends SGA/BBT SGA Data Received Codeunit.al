Codeunit 51451 "SGA Data Received"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        SGAEnable: Boolean;
        CuSGAManagement: Codeunit "SGA Management";
    begin
        SGAEnable := CuSGAManagement.IsSGAEnabled();
        if SGAEnable then begin
            case rec."Parameter String" of
                'SGAPROCESS':
                    SGAProcess;
                'SGAPROVA':
                    SGAProva;
                'SGACONFIG':
                    SGAConfig;
                else
                    Error(ErrorParameter);
            end;
        end;
    end;

    var
        ErrorParameter: Label 'Incorrect Parameter', Comment = 'Parametro Incorrecto';

    procedure SGAProva()
    var
        SGAInterfaces: Codeunit "SGA Interfaces";             // CU-51452
    begin

        CLEAR(SGAInterfaces);
        SGAInterfaces.LimpiarCamposError;
        COMMIT;

        // OK
        //CLEAR(SGAInterfaces);
        //SGAInterfaces.AjustesStock;
        //COMMIT;

        CLEAR(SGAInterfaces);
        SGAInterfaces.GrabarTablaBloqueo;
        COMMIT;

        CLEAR(SGAInterfaces);
        SGAInterfaces.LeerTablaBloqueo;
        COMMIT;

        // OK
        //CLEAR(SGAInterfaces);
        //SGAInterfaces.RecepPedCompra;
        //COMMIT;

        // OK
        //CLEAR(SGAInterfaces);
        //SGAInterfaces.AlbVentaDocEnvio;
        //COMMIT;

        // PDTE - NO SE VA A USAR.
        //CLEAR(SGAInterfaces);
        //SGAInterfaces.FechaExpedicion;
        //COMMIT;

        // OK
        //CLEAR(SGAInterfaces);
        //SGAInterfaces.RecepDevVentas;
        //COMMIT;

        // PDTE - NO SE USA
        //CLEAR(SGAInterfaces);
        //SGAInterfaces.AlbDevCompraDocEnvio;
        //COMMIT

        // OK
        //CLEAR(SGAInterfaces);
        //SGAInterfaces."PedidoTransferencia<--SGA";
        //COMMIT;

        // OK
        //CLEAR(SGAInterfaces);
        //SGAInterfaces.EntregasExpedidas;
        //COMMIT;

        CLEAR(SGAInterfaces);
        SGAInterfaces.LeerCamposError;
        COMMIT;

    end;

    procedure SGAProcess()
    var
        SGAInterfaces: Codeunit "SGA Interfaces";
    begin

        CLEAR(SGAInterfaces);
        SGAInterfaces.LimpiarCamposError;
        COMMIT;

        CLEAR(SGAInterfaces);
        SGAInterfaces.AjustesStock;
        COMMIT;

        CLEAR(SGAInterfaces);
        SGAInterfaces.GrabarTablaBloqueo;
        COMMIT;

        CLEAR(SGAInterfaces);
        SGAInterfaces.LeerTablaBloqueo;
        COMMIT;

        CLEAR(SGAInterfaces);
        SGAInterfaces.RecepPedCompra;
        COMMIT;

        CLEAR(SGAInterfaces);
        SGAInterfaces.AlbVentaDocEnvio;
        COMMIT;

        //>> BBT. 01/07/2026. No es necesario. 
        //   Se actualizará la fecha en el 'SGAInterfaces.EntregasExpedidas'
        //CLEAR(SGAInterfaces);
        //SGAInterfaces.FechaExpedicion;
        //COMMIT;
        //<<

        CLEAR(SGAInterfaces);
        SGAInterfaces.RecepDevVentas;
        COMMIT;

        //>> BBT. 13/07/2026. NO SE USA
        //CLEAR(SGAInterfaces);
        //SGAInterfaces.AlbDevCompraDocEnvio;
        //COMMIT;
        //<<

        CLEAR(SGAInterfaces);
        SGAInterfaces."PedidoTransferencia<--SGA";
        COMMIT;

        CLEAR(SGAInterfaces);
        SGAInterfaces.EntregasExpedidas;
        COMMIT;

        CLEAR(SGAInterfaces);
        SGAInterfaces.LeerCamposError;
        COMMIT;
    end;

    //>> Quitar una vez ejecutado en producción
    /**/
    procedure SGAConfig()
    var
        cuSGAManagement: Codeunit "SGA Management";
        ritem: Record Item;
        rPurchaseHeader: Record "Purchase Header";
        rTransferHeader: Record "Transfer Header";
        rSalesHeader: Record "Sales Header";
        rWarehouseShipmentHeader: Record "Warehouse Shipment Header";
    begin
        if cuSGAManagement.IsSGAEnabled() then begin
            //Productos
            rItem.Reset();
            ritem.SetRange("No SGA management", false);
            if rItem.FindSet() then
                repeat
                    rItem."SGA Item Management" := true;
                    rItem."SGA Batch Management" := rItem."SGA lot management";
                    rItem."SGA Forced Batch Purchases" := rItem."Forced buy SGA";
                    rItem."SGA Forced Batch Sales" := rItem."Forced sales SGA";
                    rItem.Modify();
                until rItem.Next() = 0;
            Commit();
            /*
            // Documentos de Envio de Almacén
            rWarehouseShipmentHeader.Reset();
            if rWarehouseShipmentHeader.FindSet() then
                repeat
                    rWarehouseShipmentHeader."SGA Status" := rWarehouseShipmentHeader."Status SGA";
                    rWarehouseShipmentHeader."SGA Readed" := rWarehouseShipmentHeader."Leido SGA";
                    rWarehouseShipmentHeader."SGA Inserted" := rWarehouseShipmentHeader."Grabado SGA";
                    rWarehouseShipmentHeader.Modify();
                until rWarehouseShipmentHeader.Next() = 0;
            Commit();
            // Pedidos Compras
            rPurchaseHeader.Reset();
            if rPurchaseHeader.FindSet() then
                repeat
                    rPurchaseHeader."SGA Status" := rPurchaseHeader."Status SGA";
                    rPurchaseHeader."SGA Readed" := rPurchaseHeader."Leido SGA";
                    rPurchaseHeader."SGA Inserted" := rPurchaseHeader."Grabado SGA";
                    rPurchaseHeader.Modify();
                until rPurchaseHeader.Next() = 0;
            Commit();
            // Ordenes de Transferencia
            rTransferHeader.Reset();
            if rTransferHeader.FindSet() then
                repeat
                    rTransferHeader."SGA Status" := rTransferHeader."Status SGA";
                    rTransferHeader."SGA Readed" := rTransferHeader."Leido SGA";
                    rTransferHeader."SGA Inserted" := rTransferHeader."Grabado SGA";
                    rTransferHeader.Modify();
                until rTransferHeader.Next() = 0;
            Commit();
            // Devoluciones
            rSalesHeader.Reset();
            rSalesHeader.SetRange("Document Type", rSalesHeader."Document Type"::"Return Order");
            if rSalesHeader.FindSet() then
                repeat
                    rSalesHeader."SGA Status" := rSalesHeader."Status SGA";
                    rSalesHeader."SGA Readed" := rSalesHeader."Leido SGA";
                    rSalesHeader."SGA Inserted" := rSalesHeader."Grabado SGA";
                    rSalesHeader.Modify();
                until rSalesHeader.Next() = 0;
            Commit();
            // Pedidos de Venta
            rSalesHeader.Reset();
            rSalesHeader.SetRange("Document Type", rSalesHeader."Document Type"::Order);
            if rSalesHeader.FindSet() then
                repeat
                    rSalesHeader."SGA Status" := rSalesHeader."Status SGA";
                    rSalesHeader."SGA Readed" := rSalesHeader."Leido SGA";
                    rSalesHeader."SGA Inserted" := rSalesHeader."Grabado SGA";
                    rSalesHeader.Modify();
                until rSalesHeader.Next() = 0;
            Commit();
            */
        end;
    end;
    /**/
    //<<
}