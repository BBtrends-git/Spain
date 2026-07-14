Codeunit 59007 "SGA Forward Order Transfer"
{
    Permissions = tableData "Transfer Header" = r,
                    tabledata "Transfer Line" = r;

    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin

        if rec."Parameter String" <> format('') then begin
            ForwardOrderTransfer(rec."Parameter String");  // El parametro debería ser el pedido de transferencia
            Commit();
        end
        else
            Error('Parámetro no reconocido: ' + Rec."Parameter String");
    end;

    var
        InferfaceSGA: Codeunit "Interface SGA";
        SGACallType: Enum "SGA Call Type";
        SGAJsonObject: JsonObject;

    local procedure ForwardOrderTransfer(_NumDoc: Code[20])
    var
        _Cabtransfer: Record "Transfer Header";
        _RecAlmacen: Record Location;
        _AlmEnvioSGA: Boolean;
        _AlmRecepSGA: Boolean;
        _Lintransfer: Record "Transfer Line";
        _Tipo: Code[3];
        _Cantidad: Decimal;
        _FechaServicio: DateTime;
        _FechaServicioTxt: Text;
        _InfoCompany: Record "Company Information";
        _CodAlmEnvioSGA: Text[10];
        _CodAlmRecepSGA: Text[10];
    begin
        _InfoCompany.GET;
        if _InfoCompany.SGA then begin
            _Cabtransfer.GET(_NumDoc);
            _RecAlmacen.GET(_Cabtransfer."Transfer-from Code");
            _AlmEnvioSGA := _RecAlmacen.SGA;
            _CodAlmEnvioSGA := _RecAlmacen."SGA Whse Code";
            _RecAlmacen.GET(_Cabtransfer."Transfer-to Code");
            _AlmRecepSGA := _RecAlmacen.SGA;
            _CodAlmRecepSGA := _RecAlmacen."SGA Whse Code";

            _Lintransfer.RESET;
            _Lintransfer.SETRANGE("Document No.", _Cabtransfer."No.");
            _Lintransfer.SETRANGE("Derived From Line No.", 0);
            _Lintransfer.SETFILTER("Item No.", '<>%1', '');
            _Lintransfer.SetFilter(Quantity, '<>%1', 0);
            if _Lintransfer.FINDSET then
                repeat
                    _Tipo := '310';          // Entrada al almacén del SGA
                    _Cantidad := _Lintransfer."Qty. to Receive (Base)";

                    if _Cabtransfer."Posting Date" = 0D then
                        _FechaServicioTxt := 'NULL'
                    else
                        _FechaServicio := CREATEDATETIME(_Cabtransfer."Posting Date", 0T);


                    Clear(SGAJsonObject);
                    SGAJsonObject.Add('CodigoAlmacenWMS', _CodAlmRecepSGA);
                    SGAJsonObject.Add('IdAlmacenERP', _Lintransfer."Transfer-to Code");
                    SGAJsonObject.Add('CodigoAlmacenOrigenWMS', _CodAlmEnvioSGA);
                    SGAJsonObject.Add('IdAlmacenOrigenERP', _Lintransfer."Transfer-from Code");
                    SGAJsonObject.Add('IdEmpresaERP', COMPANYNAME);
                    SGAJsonObject.Add('TipoDocumento', _Tipo);
                    SGAJsonObject.Add('NumeroDocumento', _Cabtransfer."No.");
                    SGAJsonObject.Add('FechaAlta', CREATEDATETIME(WORKDATE, TIME));

                    if _FechaServicioTxt = 'NULL' then
                        SGAJsonObject.Add('FechaServicioPrevista', _FechaServicioTxt)
                    else
                        SGAJsonObject.Add('FechaServicioPrevista', _FechaServicio);

                    SGAJsonObject.Add('NumeroLinea', FORMAT(_Lintransfer."Line No."));
                    SGAJsonObject.Add('CodigoArticulo', _Lintransfer."Item No.");
                    SGAJsonObject.Add('CantidadPedidaUMB', _Cantidad);
                    SGAJsonObject.Add('FechaAltaEnlace', CREATEDATETIME(WORKDATE, TIME));

                    InferfaceSGA.HttpCall(SGACallType::"Insertar pedido transferencia", SGAJsonObject);

                until _Lintransfer.NEXT = 0;
        end;
    end;
}