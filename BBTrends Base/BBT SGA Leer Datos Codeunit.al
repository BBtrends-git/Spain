Codeunit 50001 "Leer Datos SGA"
{
    //>> BBT SGA Extension
    ObsoleteState = Pending;
    //<<
    TableNo = "Job Queue Entry";
    trigger OnRun()
    var
        rCompanyInformation: Record "Company Information";
    begin
        rCompanyInformation.Reset;
        rCompanyInformation.Get;
        if rCompanyInformation.SGA then begin
            case rec."Parameter String" of
                'PROCESOSGA':
                    ProcesoSGA;
                else
                    Error('Parametro Incorrecto');
            end;
        end;
    end;

    procedure ProcesoSGA()
    var
        InterfaseSGA: Codeunit "Interface SGA";             // CU-50000
    begin

        CLEAR(InterfaseSGA);
        InterfaseSGA.LimpiarCamposError;
        COMMIT;

        CLEAR(InterfaseSGA);
        InterfaseSGA.AjustesStock;
        COMMIT;

        CLEAR(InterfaseSGA);
        InterfaseSGA.GrabarTablaBloqueo;
        COMMIT;

        CLEAR(InterfaseSGA);
        InterfaseSGA.LeerTablaBloqueo;
        COMMIT;

        CLEAR(InterfaseSGA);
        InterfaseSGA.RecepPedCompra;
        COMMIT;

        CLEAR(InterfaseSGA);
        InterfaseSGA.AlbVentaDocEnvio;
        COMMIT;

        CLEAR(InterfaseSGA);
        InterfaseSGA.FechaExpedicion;
        COMMIT;

        CLEAR(InterfaseSGA);
        InterfaseSGA.RecepDevVentas;
        COMMIT;

        CLEAR(InterfaseSGA);
        InterfaseSGA.AlbDevCompraDocEnvio;
        COMMIT;

        CLEAR(InterfaseSGA);
        InterfaseSGA."PedidoTransferencia<--SGA";
        COMMIT;

        CLEAR(InterfaseSGA);
        InterfaseSGA.EntregasExpedidas;
        COMMIT;

        CLEAR(InterfaseSGA);
        InterfaseSGA.LeerCamposError;
        COMMIT;
    end;
}
