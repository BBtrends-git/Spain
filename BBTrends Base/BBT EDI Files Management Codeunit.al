Codeunit 50006 "BBT EDI Files Management"
{
    //
    // SU- Proveedor.
    // II- Emisor de una factura (Quien Factura)
    // DP- Punto destino de la mercancía
    // UC- Destinatario final
    // BY- Comprador
    // IV- A quien se factura
    // PE- Sujeto del pago (A quien se paga)
    // PR- Pagador (Quien Paga)
    // MS- Emisor del mensaje
    // MR- Receptor del mensaje
    // 
    // 
    // // Antes de llamar a esta codeunit, es importante hacerle un CLEAR a la variable que hace referencia a la misma.
    // // Hay controles de recursividad que podrían dar falsos positivos de no hacerlo.
    // // Gracias :-)
    //

    TableNo = "EDI - EDI Entry";

    trigger OnRun()
    /*
    var
    File: File;
    IStream: InStream;
    OStream: OutStream;
    parArchivo: Text;
    */
    begin
        CompanyInformation.Reset;
        CompanyInformation.Get;
        if CompanyInformation."EDI ID" = '' then exit;
        SalesReceivablesSetup.Reset;
        SalesReceivablesSetup.Get;
        //if GuiAllowed and not Retry then Error('Este proceso solo está pensado para ser ejecutado por el NAS');
        ClearGlobals;
        case Rec."Inbound/Outbound" of
            Rec."inbound/outbound"::Inbound: // Procesamos los documentos recibidos por parte de EDI
                begin
                    case Rec."Document type" of
                        Rec."document type"::Order:
                            begin
                                TempOrder.deleteall;
                                ProcessIncomingOrders(Rec);
                                TempOrder.deleteall;
                            end;
                        Rec."document type"::Invoice: //La recepción de facturas implica que con mucha seguridad serán abonos o devoluciones
                            begin
                                TempOrder.deleteall;
                                ProcessIncomingInvoices(Rec);
                                TempOrder.deleteall;
                            end;
                        Rec."document type"::Shipment: //albaranes de devolución
                            begin
                                TempDoc.deleteall;
                                ProcessIncomingReturns(Rec);
                                TempDoc.deleteall;
                            end;
                        else
                            Error('Tipo de documento no soportado ' + Format(Rec."Document type"));
                    end;
                end;
            Rec."inbound/outbound"::Outbound: // Enviamos documentos a EDI
                begin
                    case Rec."Document type" of
                        Rec."document type"::Shipment:
                            begin
                                TempOrder.deleteall;
                                if SalesReceivablesSetup."EDI - Sales Shpt. Auto Send" or Retry then begin
                                    CreateShipmentEDIBlob(Rec);
                                end;
                            end;
                        Rec."document type"::Invoice:
                            begin
                                TempOrder.deleteall;
                                if SalesReceivablesSetup."EDI - Sales Invoice Auto Send" or Retry then begin
                                    CreateInvoiceEDIBlob(Rec);
                                end;
                            end;
                        else
                            Error('Tipo de documento no soportado ' + Format(Rec."Document type"));
                    end;
                end;
        end;
        Rec.Validate("Processed at", CurrentDateTime);
        rec.validate(Uploaded, true);
        IF rec."Document Nos." = '' then
            Rec.Validate("Document Nos.", GetDocumentNo());
        rec.Modify();
        Commit();
    end;

    var
        CompanyInformation: Record "Company Information";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        TempOrder: Record "EDI - Temporary Orders";
        TempOrderAux: Record "EDI - Temporary Orders";
        TempDoc: Record "EDI - Temporary Documents";
        HasError: Boolean;
        Retry: Boolean;
        cont: Integer;
        CreateDocsNo: Code[250];
        EdiCustCode: Text[35];
        PackagingMissingErr: label 'No se ha encontrado información de embalajes para enviar mediante EDI';
        LineNo: Integer;
        PackageNo: Integer;
        RECTLIdentificacionMensaje: Text;
        IsRMA: Boolean;
        RMANo: Code[50];
        GetInTouchSA: label 'Por favor póngase en contacto con el administrador del sistema.';

    /*******************************************************************************************/
    /****************************** EDI - ORDERS ***********************************************/
    /*******************************************************************************************/
    local procedure ProcessIncomingOrders(var EDIEntry: record "EDI - EDI Entry")
    var
        IStream: InStream;
        StreamText: Text;
    begin
        cont := 0;
        //IF NOT TempBlob.ISTEMPORARY THEN ERROR('La variable debe ser temporal');
        //TempBlob.CALCFIELDS(Blob);
        // IF NOT TempBlob.Blob.HASVALUE THEN
        //  ERROR('Debe especificar datos válidos');
        EDIEntry.CalcFields("File Blob");
        EDIEntry."File Blob".CreateInstream(IStream);
        // Leemos todas las líneas, una a una
        while not IStream.eos do begin
            StreamText := '';
            IStream.ReadText(StreamText);
            // Dependiendo del tipo de línea que venga, la procesamos a su modo
            if StreamText <> '' then
                case CopyStr(StreamText, 1, 5) of
                    'RECTL':
                        ProcessRECTL(StreamText, 'ORDERS');
                    'ERE1C':
                        ProcessERE1C(StreamText); //CABECERA
                    'ERE1T':
                        ProcessERE1T(StreamText); //OBSERVACIONES CABECERA
                    'ERE1P':
                        ProcessERE1P(StreamText); //INFORMACION PARTES
                    'ERE1I':
                        ProcessERE1I(StreamText); //DESGLOSE IMPUESTOS
                    'ERE1V':
                        ProcessERE1V(StreamText); //VENCIMIENTOS
                    'ERE1L':
                        ProcessERE1L(StreamText); //LINEA DETALLE
                    'ERE1E':
                        ProcessERE1E(StreamText); //LINEA DESCUENTOS/CARGOS
                    'ERE1U':
                        ProcessERE1U(StreamText); //LINEA COMENTARIOS 
                    else
                        Error('Se está utilizando un tipo de línea no contemplado: ' + CopyStr(StreamText, 1, 5));
                end;
        end;
        Commit;
        //CREO LA CABECERA
        //CreateHeaderOrder(StreamText);
        CreateHeaderOrderv2(EDIEntry);
        //CREO LAS LINEAS
        //CreateLinesOrder;
    end;

    local procedure ProcessRECTL(StreamText: Text; ExpectedMessageType: Text[6])
    // Registro de control (Obligatorio) - Solo debería haber una repetición por fichero
    begin
        TempOrder.Init;
        cont := cont + 1;
        TempOrder."Entry No." := cont;
        // Primero leemos todos los campos
        ReadTextField(TempOrder.Type, StreamText, 1, 6);
        ReadTextField(TempOrder."RECTL TipodeMensaje", StreamText, 7, 6); // Tipo de mensaje 
        ReadTextField(TempOrder."RECTL CodigoEmisor", StreamText, 13, 35); // Código emisor
        ReadTextField(TempOrder."RECTL CodigoReceptor", StreamText, 48, 35); // Código receptor
        ReadTextField(TempOrder."RECTL IdentificacionMensaje", StreamText, 83, 40); // Identificación única del mensaje asignada por el emisor (nº doc externo?)
        RECTLIdentificacionMensaje := TempOrder."RECTL IdentificacionMensaje"; // Para control general
        ReadDatetimeField(TempOrder."RECTL FechaHoraMensaje", StreamText, 123, 12); // Fecha/hora del mens
        TempOrder.Insert;
    end;

    local procedure ProcessERE1C(StreamText: Text)
    // Lectura de campos
    begin
        TempOrder.Init;
        cont := cont + 1;
        TempOrder."Entry No." := cont;
        ReadTextField(TempOrder."ERE1C TipoDocumento", StreamText, 7, 3); // Usado
        ReadTextField(TempOrder."ERE1C NumeroPedido", StreamText, 10, 17); // Usado
        ReadTextField(TempOrder."ERE1C FuncionMensaje", StreamText, 27, 3); // Usado
        ReadDatetimeField(TempOrder."ERE1C FechaHoraDocumento", StreamText, 30, 12);
        ReadTextField(TempOrder."ERE1C CalificadorFechaHora1", StreamText, 42, 3);
        ReadDatetimeField(TempOrder."ERE1C FechaHora1", StreamText, 45, 12);
        ReadTextField(TempOrder."ERE1C CalificadorFechaHora2", StreamText, 57, 3);
        ReadDatetimeField(TempOrder."ERE1C FechaHora2", StreamText, 60, 12);
        ReadTextField(TempOrder."ERE1C InformacionAdicional", StreamText, 72, 3); // Usado
        ReadTextField(TempOrder."ERE1C NumeroPedidoAbierto", StreamText, 75, 17);
        ReadTextField(TempOrder."ERE1C NumeroListaPrecios", StreamText, 92, 17);
        ReadTextField(TempOrder."ERE1C NumeroPedidoProveedor", StreamText, 109, 17);
        ReadTextField(TempOrder."ERE1C CalificadorReferenciaAdi", StreamText, 126, 3); // Usado
        ReadTextField(TempOrder."ERE1C NumeroReferenciaAdi", StreamText, 129, 17); // Usado
        ReadTextField(TempOrder."ERE1C CodigoMoneda", StreamText, 146, 3); // Usado
        ReadDateField(TempOrder."ERE1C FechaVencimientoUnico", StreamText, 149, 8); // Usado
        ReadTextField(TempOrder."ERE1C MetodoPagoCostesTransp", StreamText, 157, 3); // Usado
        ReadTextField(TempOrder."ERE1C CondicionesEntrega", StreamText, 160, 3); // Usado
        ReadDecimalField(TempOrder."ERE1C ImporteTotalNeto", StreamText, 163, 18); // Usado
        ReadDecimalField(TempOrder."ERE1C ImporteTotalDtosCargos", StreamText, 181, 18); // Usado
        ReadDecimalField(TempOrder."ERE1C BaseImponible", StreamText, 199, 18); // Usado
        ReadDecimalField(TempOrder."ERE1C ImporteTotalImpuestos", StreamText, 217, 18); // Usado
        ReadDecimalField(TempOrder."ERE1C ImporteAPagar", StreamText, 235, 18); // Usado
        ReadDecimalField(TempOrder."ERE1C ImporteTotalBruto", StreamText, 253, 18); // Usado
        ReadTextField(TempOrder."ERE1C ExpedienteDeContratSAS", StreamText, 271, 17);
        TempOrder.Insert;
    end;
    /*
        //SalesHeader.VALIDATE("Sell-to Customer No.",Customer."No.");
        case TipoDocumento of
            ' ', '':
                SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::" ");
            '220':
                SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"220");
            '221':
                SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"221");
            '224':
                SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"224");
            '226':
                SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"226");
            '227':
                SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"227");
            '22E':
                SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"22E");
            else
                Error('Tipo de documento no reconocido ' + TipoDocumento);
        end;
        SalesHeader.Validate("External Document No.", CopyStr(NumeroPedido, 1, MaxStrLen(SalesHeader."External Document No.")));
        case FuncionMensaje of
            '', ' ':
                SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::" ");
            '6':
                SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"6");
            '7':
                SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"7");
            '9':
                SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"9");
            '16':
                SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"16");
            '31':
                SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"31");
            '42':
                SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"42");
            '46':
                SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"46");
            else
                Error('Función del mensaje no reconocida - ' + FuncionMensaje);
        end;
        case InformacionAdicional of
            '', ' ':
                SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::" ");
            '71E':
                SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"71E");
            '72E':
                SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"72E");
            '73E':
                SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"73E");
            '81E':
                SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"81E");
            '82E':
                SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"82E");
            '83E':
                SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"83E");
            'X42':
                SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X42);
            'X41':
                SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X41);
            'X44':
                SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X44);
            'X45':
                SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X45);
            'X46':
                SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X46);
            'PP2':
                SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::PP2);
            'X17':
                SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X17);
            else
                Error('Información adicional no contemplada ' + InformacionAdicional);
        end;
        case CalificadorReferenciaAdicional of
            '', ' ':
                SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::" ");
            'ATZ':
                SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::ATZ);
            'CR':
                SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::CR);
            'CT':
                SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::CT);
            'IP':
                SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::IP);
            'PD':
                SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::PD);
            'UC':
                SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::UC);
            'ZZZ':
                SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::ZZZ);
            'AAN':
                SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::AAN);
            else
                Error('Calificador de referencia adicional no contemplado ' + CalificadorReferenciaAdicional);
        end;
        if NumeroReferenciaAdicional <> '' then
            SalesHeader.Validate("EDI - Additional ref No.", CopyStr(NumeroReferenciaAdicional, 1, MaxStrLen(SalesHeader."EDI - Additional ref No.")));
        if CodigoMoneda <> '' then
            SalesHeader.Validate("EDI - Currency Code", CodigoMoneda);
        if FechaVencimientoUnico <> 0D then
            SalesHeader.Validate("EDI - Unique due date", FechaVencimientoUnico);
        case MetodoPagoCostesTransportes of
            '', ' ':
                SalesHeader.Validate("EDI - Shipment cost payment", SalesHeader."edi - shipment cost payment"::" ");
            'DF':
                SalesHeader.Validate("EDI - Shipment cost payment", SalesHeader."edi - shipment cost payment"::DF);
            'PC':
                SalesHeader.Validate("EDI - Shipment cost payment", SalesHeader."edi - shipment cost payment"::PC);
            'PP':
                SalesHeader.Validate("EDI - Shipment cost payment", SalesHeader."edi - shipment cost payment"::PP);
            else
                Error('Método pago de costes de transportes no contemplado ' + MetodoPagoCostesTransportes);
        end;
        case CondicionesEntrega of
            '', ' ':
                SalesHeader.Validate("EDI - Delivery condition", SalesHeader."edi - delivery condition"::" ");
            'PD':
                SalesHeader.Validate("EDI - Delivery condition", SalesHeader."edi - delivery condition"::PD);
            'EP':
                SalesHeader.Validate("EDI - Delivery condition", SalesHeader."edi - delivery condition"::EP);
            'DDP':
                SalesHeader.Validate("EDI - Delivery condition", SalesHeader."edi - delivery condition"::DDP);
            else
                Error('Condición de entrega no contemplada ' + CondicionesEntrega);
        //SalesHeader."EDI - Delivery datetime" := "ERE1C FechaHora1";
        end;
    end;
    */

    local procedure ProcessERE1T(StreamText: Text)
    begin
        cont := cont + 1;
        TempOrder.Init;
        TempOrder."Entry No." := cont;
        // Lectura de campos
        ReadTextField(TempOrder."ERE1T CalificadorTemaTexto", StreamText, 7, 6);
        ReadTextField(TempOrder."ERE1T Texto1", StreamText, 13, 70);
        ReadTextField(TempOrder."ERE1T Texto2", StreamText, 83, 70);
        ReadTextField(TempOrder."ERE1T Texto3", StreamText, 153, 70);
        ReadTextField(TempOrder."ERE1T Texto4", StreamText, 223, 70);
        ReadTextField(TempOrder."ERE1T Texto5", StreamText, 293, 70);
        TempOrder.Insert;
    end;

    local procedure ProcessERE1P(StreamText: Text)
    begin

        cont := cont + 1;
        TempOrder.Init;
        TempOrder."Entry No." := cont;
        // Lectura de campos
        ReadTextField(TempOrder."ERE1P CalificadorDelInterloc", StreamText, 7, 3);
        ReadTextField(TempOrder."ERE1P CodigoInterlocutor", StreamText, 10, 17);
        ReadTextField(TempOrder."ERE1P AgenciaResponsableListaC", StreamText, 27, 3);
        ReadTextField(TempOrder."ERE1P Nombre1", StreamText, 30, 35);
        ReadTextField(TempOrder."ERE1P Nombre2", StreamText, 65, 35);
        ReadTextField(TempOrder."ERE1P Nombre3", StreamText, 100, 35);
        ReadTextField(TempOrder."ERE1P Nombre4", StreamText, 135, 35);
        ReadTextField(TempOrder."ERE1P Nombre5", StreamText, 170, 35);
        ReadTextField(TempOrder."ERE1P CalleNumero1", StreamText, 205, 35);
        ReadTextField(TempOrder."ERE1P CalleNumero2", StreamText, 240, 35);
        ReadTextField(TempOrder."ERE1P CalleNumero3", StreamText, 275, 35);
        ReadTextField(TempOrder."ERE1P CalleNumero4", StreamText, 310, 35);
        ReadTextField(TempOrder."ERE1P Poblacion", StreamText, 345, 35);
        ReadTextField(TempOrder."ERE1P Provincia", StreamText, 380, 9);
        ReadTextField(TempOrder."ERE1P CodigoPostal", StreamText, 389, 9);
        ReadTextField(TempOrder."ERE1P CodigoPais", StreamText, 398, 3);
        ReadTextField(TempOrder."ERE1P CalificadorReferencia1", StreamText, 401, 3);
        ReadTextField(TempOrder."ERE1P Referencia1", StreamText, 404, 35);
        ReadTextField(TempOrder."ERE1P FuncionContacto", StreamText, 439, 3);
        ReadTextField(TempOrder."ERE1P DepartamentoOIdentific", StreamText, 442, 17);
        ReadTextField(TempOrder."ERE1P DepartamentoOEmpleado", StreamText, 459, 35);
        ReadTextField(TempOrder."ERE1P CalificadorReferencia2", StreamText, 494, 3);
        ReadTextField(TempOrder."ERE1P Referencia2", StreamText, 497, 17);
        TempOrder.Insert;
    end;

    local procedure ProcessERE1I(StreamText: Text)
    // Lectura de campos
    begin
        cont := cont + 1;
        TempOrder.Init;
        TempOrder."Entry No." := cont;
        ReadIntegerField(TempOrder."ERE1I NumeroLineaImpuesto", StreamText, 7, 2);
        ReadTextField(TempOrder."ERE1I CalificadorTipoImpuesto", StreamText, 9, 6);
        ReadDecimalField(TempOrder."ERE1I PorImpuesto", StreamText, 15, 6);
        ReadDecimalField(TempOrder."ERE1I ImporteImpuesto", StreamText, 21, 18);
        ReadDecimalField(TempOrder."ERE1I BaseImponible", StreamText, 39, 18);
        TempOrder.Insert;
    end;

    local procedure ProcessERE1V(StreamText: Text)

    begin
        cont := cont + 1;
        TempOrder.Init;
        TempOrder."Entry No." := cont;
        //Lectura de campos
        ReadIntegerField(TempOrder."ERE1V ContadorVencimiento", StreamText, 7, 2);
        ReadTextField(TempOrder."ERE1V ReferenciaTiempoPagoCod", StreamText, 9, 3);
        ReadTextField(TempOrder."ERE1V RelacionTiempoCodificado", StreamText, 12, 3);
        ReadTextField(TempOrder."ERE1V TipoPeriodoCodificado", StreamText, 15, 3);
        ReadIntegerField(TempOrder."ERE1V NumeroPeriodos", StreamText, 18, 3);
        ReadDateField(TempOrder."ERE1V FechaVencimiento", StreamText, 21, 8);
        ReadDecimalField(TempOrder."ERE1V ImporteVencimiento", StreamText, 29, 18);
        TempOrder.Insert;
    end;

    local procedure ProcessERE1L(StreamText: Text)
    begin
        cont := cont + 1;
        TempOrder.Init;
        TempOrder."Entry No." := cont;
        // Lectura de campos
        ReadIntegerField(TempOrder."ERE1L NumeroLineaArticulo", StreamText, 7, 6); // Usado
        ReadTextField(TempOrder."ERE1L CodigoEAN13DUN14Articulo", StreamText, 13, 15); // Usado
        ReadTextField(TempOrder."ERE1L TipoCodigoArticulo", StreamText, 28, 3);
        ReadTextField(TempOrder."ERE1L TipoIdentificacionArt", StreamText, 31, 17);
        ReadTextField(TempOrder."ERE1L Descripcion1Articulo", StreamText, 48, 70); // Usado
        ReadTextField(TempOrder."ERE1L Descripcion2Articulo", StreamText, 118, 70); // Usado
        ReadTextField(TempOrder."ERE1L TipoArticulo", StreamText, 118, 1);
        ReadTextField(TempOrder."ERE1L NumeroArticuloProveedor", StreamText, 189, 35);
        ReadTextField(TempOrder."ERE1L NumeroArticuloComprador", StreamText, 224, 35);
        ReadTextField(TempOrder."ERE1L VariablePromocional", StreamText, 259, 35); // Usado
        ReadTextField(TempOrder."ERE1L CodigoEANDelArticuloAdic", StreamText, 294, 35); // Usado
        ReadDecimalField(TempOrder."ERE1L CantidadPedida", StreamText, 329, 16); // Usado
        ReadDecimalField(TempOrder."ERE1L CantidadBonificada", StreamText, 345, 16); // Usado
        ReadTextField(TempOrder."ERE1L CalificadorUnidadMedida", StreamText, 361, 6); // Usado
        ReadDecimalField(TempOrder."ERE1L NumeroUnidDeConsEnUExped", StreamText, 367, 16);
        ReadTextField(TempOrder."ERE1L CalificadorFechaHora1", StreamText, 383, 3);
        ReadDatetimeField(TempOrder."ERE1L FechaHora1", StreamText, 386, 12);
        ReadTextField(TempOrder."ERE1L CalificadorFechaHora2", StreamText, 398, 3);
        ReadDatetimeField(TempOrder."ERE1L FechaHora2", StreamText, 401, 12);
        ReadDecimalField(TempOrder."ERE1L ImporteNetoLinea", StreamText, 413, 18); // Usado
        ReadDecimalField(TempOrder."ERE1L PrecioBrutoUnitario", StreamText, 431, 16); // Usado
        ReadDecimalField(TempOrder."ERE1L PrecioNetoUnitario", StreamText, 447, 16); // Usado
        ReadDecimalField(TempOrder."ERE1L PrecioATituloInformativo", StreamText, 463, 16);
        ReadTextField(TempOrder."ERE1L CalifiUDeMedidaPrecio", StreamText, 479, 6); // Usado
        ReadTextField(TempOrder."ERE1L CalificadorIVAIGIC", StreamText, 485, 6); // Usado
        ReadDecimalField(TempOrder."ERE1L PorcentajeIVAIGIC", StreamText, 491, 6); // Usado
        ReadDecimalField(TempOrder."ERE1L ImporteIVAIGIC", StreamText, 497, 18); // Usado
        ReadDecimalField(TempOrder."ERE1L PorRecargoEquivalencia", StreamText, 515, 6); // Usado
        ReadDecimalField(TempOrder."ERE1L ImporteRecargoEquiv", StreamText, 521, 18); // Usado
        ReadTextField(TempOrder."ERE1L CalificadorOtroTipoDeImp", StreamText, 539, 6); // Usado
        ReadDecimalField(TempOrder."ERE1L PorOtroTipoDeImpuesto", StreamText, 545, 6); // Usado
        ReadDecimalField(TempOrder."ERE1L ImporteOtroTipoDeImp", StreamText, 551, 18); // Usado
        ReadDecimalField(TempOrder."ERE1L PesoNeto", StreamText, 569, 18); // Usado
        ReadTextField(TempOrder."ERE1L CalificadorUDeMedidaPeso", StreamText, 587, 6); // Usado
        ReadTextField(TempOrder."ERE1L DescripcionDelModelo", StreamText, 593, 25); // Usado
        ReadTextField(TempOrder."ERE1L Color", StreamText, 618, 25); // Usado
        ReadTextField(TempOrder."ERE1L AnchuraOTalla", StreamText, 643, 25); // Usado
        ReadTextField(TempOrder."ERE1L PresentacionCantidadForm", StreamText, 668, 25);
        ReadTextField(TempOrder."ERE1L CodigoGrupoArticuloCompr", StreamText, 693, 35);
        ReadTextField(TempOrder."ERE1L NumeroSerieArticulo", StreamText, 728, 35); // Usado
        ReadTextField(TempOrder."ERE1L NumeroArticuloFabricante", StreamText, 763, 35); // Usado
        ReadTextField(TempOrder."ERE1L NumeroLote", StreamText, 798, 35); // Usado
        ReadTextField(TempOrder."ERE1L CalificadorFechaHora3", StreamText, 833, 3);
        ReadDatetimeField(TempOrder."ERE1L FechaHora3", StreamText, 836, 12);
        ReadDecimalField(TempOrder."ERE1L ImporteLíneaConImpuestos", StreamText, 848, 18); // Usado
        ReadIntegerField(TempOrder."ERE1L BasePrecioNetoUnitario", StreamText, 866, 9); // Usado
        ReadDecimalField(TempOrder."ERE1L PrecioArticuloConImp", StreamText, 875, 16); // Usado
        ReadIntegerField(TempOrder."ERE1L BasePrecioArticuloConImp", StreamText, 891, 9); // Usado
        ReadTextField(TempOrder."ERE1L NumeroAlbaran", StreamText, 900, 17); // Usado
        ReadDateField(TempOrder."ERE1L FechaAlbaran", StreamText, 917, 12); // Usado
        ReadTextField(TempOrder."ERE1L CodigoClienteFinal", StreamText, 929, 17); // Usado
        ReadTextField(TempOrder."ERE1L NombreClienteFinal", StreamText, 946, 70); // Usado
        ReadTextField(TempOrder."ERE1L DireccionClienteFinal", StreamText, 1016, 70); // Usado
        ReadTextField(TempOrder."ERE1L PoblacionClienteFinal", StreamText, 1086, 35); // Usado
        ReadTextField(TempOrder."ERE1L CodigoPostalClienteFinal", StreamText, 1121, 9); // Usado
        ReadTextField(TempOrder."ERE1L IdentificadorProdLinPed", StreamText, 1130, 15); // Usado
        TempOrder.Insert;
    end;

    local procedure ProcessERE1E(StreamText: Text)
    begin
        cont := cont + 1;
        TempOrder.Init;
        TempOrder."Entry No." := cont;
        //Lectura de campos
        ReadTextField(TempOrder.Type, StreamText, 1, 6);
        ReadIntegerField(TempOrder."ERE1E NumeroDescuentoCargo", StreamText, 7, 2);
        ReadTextField(TempOrder."ERE1E IndicadorDescuentoCargo", StreamText, 9, 1);
        ReadTextField(TempOrder."ERE1E IndicadorSecuenciaCalcul", StreamText, 10, 3);
        ReadTextField(TempOrder."ERE1E TipoDescuentoCargo", StreamText, 13, 3);
        ReadTextField(TempOrder."ERE1E DescripcionDescuentoCarg", StreamText, 16, 70);
        ReadDecimalField(TempOrder."ERE1E PorcentajeDescuentoCargo", StreamText, 86, 9);
        ReadDecimalField(TempOrder."ERE1E ImporteDescuentoCargo", StreamText, 95, 18);
        ReadDecimalField(TempOrder."ERE1E ImporteTotalSujetoAAplic", StreamText, 113, 18);
        ReadDecimalField(TempOrder."ERE1E DtoMonetariosPorUnidad", StreamText, 131, 18);
        ReadTextField(TempOrder."ERE1E UnidadMedida", StreamText, 149, 6);
        ReadDecimalField(TempOrder."ERE1E CantidadDescuentoCargo", StreamText, 155, 16);
        TempOrder.Insert;
    end;

    local procedure ProcessERE1U(StreamText: Text)
    begin
        cont := cont + 1;
        TempOrder.Init;
        TempOrder."Entry No." := cont;
        // Lectura de campos. 
        // Se aprovechan los campos de las lineas de observaciones de la cabecera ERE1T.
        // Solo el campo Type indica que es un ERE1U
        ReadTextField(TempOrder.Type, StreamText, 1, 6);
        ReadTextField(TempOrder."ERE1T CalificadorTemaTexto", StreamText, 7, 6);
        ReadTextField(TempOrder."ERE1T Texto1", StreamText, 13, 70);
        ReadTextField(TempOrder."ERE1T Texto2", StreamText, 83, 70);
        ReadTextField(TempOrder."ERE1T Texto3", StreamText, 153, 70);
        ReadTextField(TempOrder."ERE1T Texto4", StreamText, 223, 70);
        ReadTextField(TempOrder."ERE1T Texto5", StreamText, 293, 70);
        TempOrder.Insert;
    end;

    local procedure CreateHeaderOrderv2(var pEDIEntry: record "EDI - EDI Entry")       // Alta de Pedidos de Ventas 
    var
        rTempOrderHeader: Record "EDI - Temporary Orders";
        rTempOrderHeader2: Record "EDI - Temporary Orders";
        //rEDIDocumentinterlocutor: Record "EDI - Document interlocutor";
        rEDIDocumentinstallment: Record "EDI - Document installment";
        rCustomerAddress: Record "Ship-to Address";
        rCustomer: record Customer;
        rVendor: Record Vendor;
        CalificadorDelInterlocBY: Text[10];
        IStream: InStream;
        DummyTxt: Text;
        PreviousTxt: Text;
        OStream: OutStream;
        CalificadorTemaTexto: Text[6];
        CurrentOrderFromEntryNo: Integer;
        CurrentOrderToEntryNo: Integer;
        ERE1PCodigoInterlocutor: Text[17];
    begin
        rTempOrderHeader.Reset;
        rTempOrderHeader.SetRange(Type, 'RECTL');
        if rTempOrderHeader.FindSet then
            repeat
                CurrentOrderFromEntryNo := rTempOrderHeader."Entry No.";
                rTempOrderHeader2.Reset;
                rTempOrderHeader2.SetFilter("Entry No.", '%1..', CurrentOrderFromEntryNo + 1);
                rTempOrderHeader2.SetRange(Type, rTempOrderHeader.Type);
                if not rTempOrderHeader2.FindSet then begin
                    rTempOrderHeader2.SetRange(Type);
                    rTempOrderHeader2.FindLast;
                    CurrentOrderToEntryNo := rTempOrderHeader2."Entry No.";
                end
                else
                    CurrentOrderToEntryNo := rTempOrderHeader2."Entry No." - 1;
                // Creación cabecera
                Clear(SalesHeader);
                SalesHeader.TestField("No.", ''); // Que no haya pasado por aquí más veces
                Clear(PurchaseHeader);
                PurchaseHeader.TestField("No.", '');
                SalesHeader.Init;
                SalesHeader.Validate("Document Type", SalesHeader."document type"::Order);
                SalesHeader.Validate("No.", '');
                SalesHeader.Insert(true);
                SalesHeader.TestField("No."); // Debe tener número asignado ya
                if CreateDocsNo <> '' then
                    CreateDocsNo += '|' + SalesHeader."No."
                else
                    CreateDocsNo := SalesHeader."No.";
                //BUSCO EL CLIENTE
                //ERE1P CalificadorDelInterloc BY
                TempOrder.Reset;
                TempOrder.SetRange("Entry No.", CurrentOrderFromEntryNo, CurrentOrderToEntryNo);
                TempOrder.SetRange(TempOrder."ERE1P CalificadorDelInterloc", 'BY');
                if not TempOrder.FindFirst then
                    Error('No se encuentra el cliente. Error CalificadorDelInterlocutor BY')
                else begin
                    if SalesHeader."No." <> '' then begin
                        ERE1PCodigoInterlocutor := TempOrder."ERE1P CodigoInterlocutor";
                        //>> BBT 08/08/2025. EXCEPCION ALZA. Comprobamos si el IV es para Chequia o Slovaquia
                        if ERE1PCodigoInterlocutor = '8594177950005' then begin    // GLN de ALZA Chequia.
                            TempOrderAux.Reset;
                            TempOrderAux.SetRange("Entry No.", CurrentOrderFromEntryNo, CurrentOrderToEntryNo);
                            TempOrderAux.SetRange("ERE1P CalificadorDelInterloc", 'IV');
                            if TempOrderAux.FindFirst then begin
                                ERE1PCodigoInterlocutor := TempOrderAux."ERE1P CodigoInterlocutor";    // Asignamos el GLN 'IV' que puede ser el de ALZA Slovaquia
                            end;
                        end;
                        //<<
                        // Buscamos el cliente.
                        rCustomer.Reset;
                        rCustomer.SetRange("EDI ID", ERE1PCodigoInterlocutor);
                        if not rCustomer.FindSet then
                            Error('No se ha podido localizar el cliente con código ' + rCustomer.GetFilter("EDI ID"));
                        if rCustomer.Count > 1 then
                            Error('Se han encontrado múltiples clientes con el código ' + rCustomer.GetFilter("EDI ID") + '. El procesamiento del documento se ha detenido');
                        // - Comprobar cliente existe y no bloqueado
                        if rCustomer.Blocked <> rCustomer.Blocked::" " then
                            Error('El cliente %1 está bloqueado', rCustomer."No.");
                        // - Comprobar cliente existe y la gestión EDI está activada
                        if rCustomer."No EDI" = true then
                            Error('El cliente %1 no tiene activa la gestión EDI', rCustomer."No.");

                        SalesHeader.Validate(SalesHeader."Sell-to Customer No.", rCustomer."No.");
                        SalesHeader.Modify;

                        //>> 12/03/2025 Marcamos el registro NAC/PL y actualizamos el código del cliente
                        pEDIEntry.Validate("Source Type", pEDIEntry."Source Type"::Customer);
                        pEDIEntry.Validate("Sourde Id", rCustomer."No.");
                        pEDIEntry.Validate("Source Name", rCustomer.Name);
                        pEDIEntry.Validate("PL Entry", false);
                        if rCustomer."VAT PL" then
                            pEDIEntry.Validate("PL Entry", true);
                        //<<

                        CalificadorDelInterlocBY := TempOrder."ERE1P CalificadorDelInterloc";
                        // BY - Referencia1 - Referencia2
                        SalesHeader."EDI - Calificador Referencia 1" := TempOrder."ERE1P CalificadorReferencia1";
                        SalesHeader."EDI - Referencia 1" := TempOrder."ERE1P Referencia1";
                        SalesHeader."EDI - Calificador Referencia 2" := TempOrder."ERE1P CalificadorReferencia2";
                        SalesHeader."EDI - Referencia 2" := TempOrder."ERE1P Referencia2";
                        //>> Departamento y sucursal para el grupo CORTICOR - DEBE DE VENIR RELLENO
                        if rCustomer."SMG Purchase Group" = 'CORTICOR' then begin
                            if TempOrder."ERE1P CalificadorReferencia1" = '' then
                                Error('No se puede encontrar el departamento')
                            else
                                SalesHeader."Cód. Departamento" := TempOrder."ERE1P Referencia1";
                            if TempOrder."ERE1P CalificadorReferencia2" = '' then
                                Error('No se puede encontrar la sucursal')
                            else
                                SalesHeader."Cód. Sucursal" := TempOrder."ERE1P Referencia2";
                        end
                        //<<

                    end
                    else begin
                        PurchaseHeader.TestField("No.");
                        // - Buscamos el proveedor 
                        rVendor.Reset;
                        rVendor.SetRange("EDI ID", TempOrder."ERE1P CodigoInterlocutor");
                        if not rVendor.FindSet then
                            Error('No se ha podido localizar el proveedor con código ' + rVendor.GetFilter("EDI ID"))
                        else if rVendor.Count > 1 then
                            Error('Se han encontrado múltiples proveedor con el código ' + rVendor.GetFilter("EDI ID") + '. El procesamiento del documento se ha detenido')
                        // - Comprobar cliente existe y no bloquead
                        else if rVendor.Blocked <> rVendor.Blocked::" " then
                            Error('El proveedor %1 está bloqueado', rVendor."No.")
                        else begin
                            PurchaseHeader.Validate("Buy-from Vendor No.", rVendor."No.");
                            PurchaseHeader.Modify;

                            //>> 12/03/2025 Marcamos el registro NAC/PL y actualizamos el código del proveedor
                            pEDIEntry.Validate("Source Type", pEDIEntry."Source Type"::Vendor);
                            pEDIEntry.Validate("Sourde Id", rVendor."No.");
                            pEDIEntry.Validate("Source Name", rVendor.Name);
                            pEDIEntry.Validate("PL Entry", false);
                            if rVendor."VAT PL" then
                                pEDIEntry.Validate("PL Entry", true);
                            //<<

                            CalificadorDelInterlocBY := TempOrder."ERE1P CalificadorDelInterloc";
                        end;
                    end;
                end;
                //END;
                //BUSCO DIR ENVIO CLIENTE
                //ERE1P CalificadorDelInterloc DP
                if SalesHeader."No." <> '' then begin
                    if SalesHeader."Document Type" = SalesHeader."document type"::Order then begin
                        TempOrder.Reset;
                        TempOrder.SetRange("Entry No.", CurrentOrderFromEntryNo, CurrentOrderToEntryNo);
                        TempOrder.SetRange(TempOrder."ERE1P CalificadorDelInterloc", 'DP');
                        if not TempOrder.FindFirst then
                            Error('No se encuentra el cliente. Error CalificadorDelInterlocutor DP');
                        if CalificadorDelInterlocBY <> TempOrder."ERE1P CodigoInterlocutor" then begin
                            rCustomerAddress.Reset;
                            rCustomerAddress.SetRange("Customer No.", SalesHeader."Sell-to Customer No.");
                            rCustomerAddress.SetRange("EDI ID", TempOrder."ERE1P CodigoInterlocutor");
                            if not rCustomerAddress.FindSet then
                                Error('No se ha encontrado la dirección del cliente con código ' + rCustomerAddress.GetFilter("EDI ID"))
                            else if rCustomerAddress.Count > 1 then
                                Error('Se han encontrado múltiples direcciones del cliente ' + SalesHeader."Sell-to Customer No." + ' con el código ' + rCustomerAddress.GetFilter("EDI ID"))
                            else begin
                                SalesHeader.Validate(SalesHeader."Ship-to Code", rCustomerAddress.Code);
                                SalesHeader.Modify;
                            end;
                        end;
                    end
                    else if SalesHeader."Document Type" = SalesHeader."document type"::"Credit Memo" then begin
                        SalesHeader.Validate("Your Reference", TempOrder."SINCC DocumentoRectificado");
                    end
                    else
                        Error('Tipo de documento no soportado ' + Format(SalesHeader."Document Type"));
                end
                else begin
                    PurchaseHeader.TestField("No.");
                    // Para las facturas de compra no gestionamos direcciones de envío/recepción - Comentarlo en caso que se deba ajustar
                end;
                TempOrder.Reset;
                TempOrder.SetRange("Entry No.", CurrentOrderFromEntryNo, CurrentOrderToEntryNo);
                TempOrder.SetFilter(TempOrder."ERE1C TipoDocumento", '<>%1', '');
                if TempOrder.FindFirst then begin
                    begin
                        if SalesHeader."No." <> '' then begin
                            SalesHeader.Validate("EDI - Delivery datetime", TempOrder."ERE1C FechaHora1");
                            SalesHeader."Requested Delivery Date" := Dt2Date(SalesHeader."EDI - Delivery datetime");
                            case TempOrder."ERE1C TipoDocumento" of
                                ' ', '':
                                    SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::" ");
                                '220':
                                    SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"220");
                                '221':
                                    SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"221");
                                '224':
                                    SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"224");
                                '226':
                                    SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"226");
                                '227':
                                    SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"227");
                                '22E':
                                    SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"22E");
                            //    else
                            //        Error('Tipo de documento no reconocido ' + TempOrder."ERE1C TipoDocumento");
                            end;
                            SalesHeader.Validate("External Document No.", CopyStr(TempOrder."ERE1C NumeroPedido", 1, MaxStrLen(SalesHeader."External Document No.")));
                            case TempOrder."ERE1C FuncionMensaje" of
                                '', ' ':
                                    SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::" ");
                                '6':
                                    SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"6");
                                '7':
                                    SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"7");
                                '9':
                                    SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"9");
                                '16':
                                    SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"16");
                                '31':
                                    SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"31");
                                '42':
                                    SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"42");
                                '46':
                                    SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"46");
                            //    else
                            //        Error('Función del mensaje no reconocida - ' + TempOrder."ERE1C FuncionMensaje");
                            end;
                            case TempOrder."ERE1C InformacionAdicional" of
                                '', ' ':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::" ");
                                '71E':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"71E");
                                '72E':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"72E");
                                '73E':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"73E");
                                '81E':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"81E");
                                '82E':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"82E");
                                '83E':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"83E");
                                'X42':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X42);
                                'X41':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X41);
                                'X44':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X44);
                                'X45':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X45);
                                'X46':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X46);
                                'PP2':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::PP2);
                                'X17':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X17);
                            //    else
                            //        Error('Información adicional no contemplada ' + TempOrder."ERE1C InformacionAdicional");
                            end;
                            case TempOrder."ERE1C CalificadorReferenciaAdi" of
                                '', ' ':
                                    SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::" ");
                                'ATZ':
                                    SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::ATZ);
                                'CR':
                                    SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::CR);
                                'CT':
                                    SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::CT);
                                'IP':
                                    SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::IP);
                                'PD':
                                    SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::PD);
                                'UC':
                                    SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::UC);
                                'AAN':
                                    SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::AAN);
                                'ZZZ':
                                    SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::ZZZ);
                            //    else
                            //        Error('Calificador de referencia adicional no contemplado ' + TempOrder."ERE1C CalificadorReferenciaAdi");
                            end;
                            if TempOrder."ERE1C NumeroReferenciaAdi" <> '' then
                                SalesHeader.Validate("EDI - Additional ref No.", CopyStr(TempOrder."ERE1C NumeroReferenciaAdi", 1, MaxStrLen(SalesHeader."EDI - Additional ref No.")));
                            if TempOrder."ERE1C CodigoMoneda" <> '' then
                                SalesHeader.Validate("EDI - Currency Code", TempOrder."ERE1C CodigoMoneda");
                            if TempOrder."ERE1C FechaVencimientoUnico" <> 0D then
                                SalesHeader.Validate("EDI - Unique due date", TempOrder."ERE1C FechaVencimientoUnico");
                            case TempOrder."ERE1C MetodoPagoCostesTransp" of
                                '', ' ':
                                    SalesHeader.Validate("EDI - Shipment cost payment", SalesHeader."edi - shipment cost payment"::" ");
                                'DF':
                                    SalesHeader.Validate("EDI - Shipment cost payment", SalesHeader."edi - shipment cost payment"::DF);
                                'PC':
                                    SalesHeader.Validate("EDI - Shipment cost payment", SalesHeader."edi - shipment cost payment"::PC);
                                'PP':
                                    SalesHeader.Validate("EDI - Shipment cost payment", SalesHeader."edi - shipment cost payment"::PP);
                            //    else
                            //        Error('Método pago de costes de transportes no contemplado ' + TempOrder."ERE1C MetodoPagoCostesTransp");
                            end;
                            case TempOrder."ERE1C CondicionesEntrega" of
                                '', ' ':
                                    SalesHeader.Validate("EDI - Delivery condition", SalesHeader."edi - delivery condition"::" ");
                                'PD':
                                    SalesHeader.Validate("EDI - Delivery condition", SalesHeader."edi - delivery condition"::PD);
                                'EP':
                                    SalesHeader.Validate("EDI - Delivery condition", SalesHeader."edi - delivery condition"::EP);
                                'DDP':
                                    SalesHeader.Validate("EDI - Delivery condition", SalesHeader."edi - delivery condition"::DDP);
                            //    else
                            //        Error('Condición de entrega no contemplada ' + TempOrder."ERE1C CondicionesEntrega");
                            end;
                            SalesHeader.Validate("EDI - Total Amount", TempOrder."ERE1C ImporteTotalNeto");
                            SalesHeader.Validate("EDI - Total discount/charges", TempOrder."ERE1C ImporteTotalDtosCargos");
                            SalesHeader.Validate("EDI - Amount Base", TempOrder."ERE1C BaseImponible");
                            SalesHeader.Validate("EDI - Taxes amt.", TempOrder."ERE1C ImporteTotalImpuestos");
                            SalesHeader.Validate("EDI - Paying amt.", TempOrder."ERE1C ImporteAPagar");
                            SalesHeader.Validate("EDI - Gross amt.", TempOrder."ERE1C ImporteTotalBruto");
                            SalesHeader.Validate("EDI - EDI Order", true);
                            SalesHeader.Modify(true);
                        end
                        else begin
                            PurchaseHeader.TestField("No.");
                            PurchaseHeader.Validate("EDI - Delivery datetime", TempOrder."ERE1C FechaHora1");
                            case TempOrder."ERE1C TipoDocumento" of
                                ' ', '':
                                    PurchaseHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::" ");
                                '220':
                                    PurchaseHeader.Validate("EDI - Order Type", PurchaseHeader."edi - order type"::"220");
                                '221':
                                    PurchaseHeader.Validate("EDI - Order Type", PurchaseHeader."edi - order type"::"221");
                                '224':
                                    PurchaseHeader.Validate("EDI - Order Type", PurchaseHeader."edi - order type"::"224");
                                '226':
                                    PurchaseHeader.Validate("EDI - Order Type", PurchaseHeader."edi - order type"::"226");
                                '227':
                                    PurchaseHeader.Validate("EDI - Order Type", PurchaseHeader."edi - order type"::"227");
                                '22E':
                                    PurchaseHeader.Validate("EDI - Order Type", PurchaseHeader."edi - order type"::"22E");
                                '381', '383', '325': // Ver si es necesario el tipo de abono
                                    begin
                                    end;
                            //    else
                            //        Error('Tipo de documento no reconocido ' + TempOrder."ERE1C TipoDocumento");
                            end;
                            PurchaseHeader.Validate("Your Reference", CopyStr(TempOrder."ERE1C NumeroPedido", 1, MaxStrLen(PurchaseHeader."Your Reference")));
                            case TempOrder."ERE1C FuncionMensaje" of
                                '', ' ':
                                    PurchaseHeader.Validate("EDI - Message function", PurchaseHeader."edi - message function"::" ");
                                '6':
                                    PurchaseHeader.Validate("EDI - Message function", PurchaseHeader."edi - message function"::"6");
                                '7':
                                    PurchaseHeader.Validate("EDI - Message function", PurchaseHeader."edi - message function"::"7");
                                '9':
                                    PurchaseHeader.Validate("EDI - Message function", PurchaseHeader."edi - message function"::"9");
                                '16':
                                    PurchaseHeader.Validate("EDI - Message function", PurchaseHeader."edi - message function"::"16");
                                '31':
                                    PurchaseHeader.Validate("EDI - Message function", PurchaseHeader."edi - message function"::"31");
                                '42':
                                    PurchaseHeader.Validate("EDI - Message function", PurchaseHeader."edi - message function"::"42");
                                '46':
                                    PurchaseHeader.Validate("EDI - Message function", PurchaseHeader."edi - message function"::"46");
                            //ELSE
                            //  ERROR('Función del mensaje no reconocida - '+"ERE1C FuncionMensaje");
                            end;
                            case TempOrder."ERE1C InformacionAdicional" of
                                '', ' ':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::" ");
                                '71E':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::"71E");
                                '72E':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::"72E");
                                '73E':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::"73E");
                                '81E':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::"81E");
                                '82E':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::"82E");
                                '83E':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::"83E");
                                'X42':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::X42);
                                'X41':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::X41);
                                'X44':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::X44);
                                'X45':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::X45);
                                'X46':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::X46);
                            //    else
                            //        Error('Información adicional no contemplada ' + TempOrder."ERE1C InformacionAdicional");
                            end;
                            case TempOrder."ERE1C CalificadorReferenciaAdi" of
                                '', ' ':
                                    PurchaseHeader.Validate("EDI - Additional ref type", PurchaseHeader."edi - additional ref type"::" ");
                                'ATZ':
                                    PurchaseHeader.Validate("EDI - Additional ref type", PurchaseHeader."edi - additional ref type"::ATZ);
                                'CR':
                                    PurchaseHeader.Validate("EDI - Additional ref type", PurchaseHeader."edi - additional ref type"::CR);
                                'CT':
                                    PurchaseHeader.Validate("EDI - Additional ref type", PurchaseHeader."edi - additional ref type"::CT);
                                'IP':
                                    PurchaseHeader.Validate("EDI - Additional ref type", PurchaseHeader."edi - additional ref type"::IP);
                                'PD':
                                    PurchaseHeader.Validate("EDI - Additional ref type", PurchaseHeader."edi - additional ref type"::PD);
                                'UC':
                                    PurchaseHeader.Validate("EDI - Additional ref type", PurchaseHeader."edi - additional ref type"::UC);
                                'AAN':
                                    PurchaseHeader.Validate("EDI - Additional ref type", PurchaseHeader."edi - additional ref type"::AAN);
                                'ZZZ':
                                    PurchaseHeader.Validate("EDI - Additional ref type", PurchaseHeader."edi - additional ref type"::ZZZ);
                            //    else
                            //        Error('Calificador de referencia adicional no contemplado ' + TempOrder."ERE1C CalificadorReferenciaAdi");
                            end;
                            if TempOrder."ERE1C NumeroReferenciaAdi" <> '' then
                                PurchaseHeader.Validate("EDI - Additional ref No.", CopyStr(TempOrder."ERE1C NumeroReferenciaAdi", 1, MaxStrLen(PurchaseHeader."EDI - Additional ref No.")));
                            if TempOrder."ERE1C CodigoMoneda" <> '' then
                                PurchaseHeader.Validate("EDI - Currency Code", TempOrder."ERE1C CodigoMoneda");
                            if TempOrder."ERE1C FechaVencimientoUnico" <> 0D then
                                PurchaseHeader.Validate("EDI - Unique due date", TempOrder."ERE1C FechaVencimientoUnico");
                            case TempOrder."ERE1C MetodoPagoCostesTransp" of
                                '', ' ':
                                    PurchaseHeader.Validate("EDI - Shipment cost payment", PurchaseHeader."edi - shipment cost payment"::" ");
                                'DF':
                                    PurchaseHeader.Validate("EDI - Shipment cost payment", PurchaseHeader."edi - shipment cost payment"::DF);
                                'PC':
                                    PurchaseHeader.Validate("EDI - Shipment cost payment", PurchaseHeader."edi - shipment cost payment"::PC);
                                'PP':
                                    PurchaseHeader.Validate("EDI - Shipment cost payment", PurchaseHeader."edi - shipment cost payment"::PP);
                            //    else
                            //        Error('Método pago de costes de transportes no contemplado ' + TempOrder."ERE1C MetodoPagoCostesTransp");
                            end;
                            case TempOrder."ERE1C CondicionesEntrega" of
                                '', ' ':
                                    PurchaseHeader.Validate("EDI - Delivery condition", PurchaseHeader."edi - delivery condition"::" ");
                                'PD':
                                    PurchaseHeader.Validate("EDI - Delivery condition", PurchaseHeader."edi - delivery condition"::PD);
                                'EP':
                                    PurchaseHeader.Validate("EDI - Delivery condition", PurchaseHeader."edi - delivery condition"::EP);
                                'DDP':
                                    SalesHeader.Validate("EDI - Delivery condition", SalesHeader."edi - delivery condition"::DDP);
                            //    else
                            //        Error('Condición de entrega no contemplada ' + TempOrder."ERE1C CondicionesEntrega");
                            end;
                            PurchaseHeader.Validate("EDI - Total Amount", TempOrder."ERE1C ImporteTotalNeto");
                            PurchaseHeader.Validate("EDI - Total discount/charges", TempOrder."ERE1C ImporteTotalDtosCargos");
                            PurchaseHeader.Validate("EDI - Amount Base", TempOrder."ERE1C BaseImponible");
                            PurchaseHeader.Validate("EDI - Taxes amt.", TempOrder."ERE1C ImporteTotalImpuestos");
                            PurchaseHeader.Validate("EDI - Paying amt.", TempOrder."ERE1C ImporteAPagar");
                            PurchaseHeader.Validate("EDI - Gross amt.", TempOrder."ERE1C ImporteTotalBruto");
                            PurchaseHeader.Validate("EDI - EDI Order", true);
                            PurchaseHeader.Modify(true);
                        end;
                    end;
                end;
                TempOrder.Reset;
                TempOrder.SetRange("Entry No.", CurrentOrderFromEntryNo, CurrentOrderToEntryNo);
                TempOrder.SetFilter(TempOrder."ERE1T CalificadorTemaTexto", '<>%1', '');
                if TempOrder.FindFirst then
                    repeat begin
                        if SalesHeader."No." <> '' then begin
                            SalesHeader.CalcFields("EDI - Comments");
                            SalesHeader."EDI - Comments".CreateInstream(IStream); // Primero leemos todos los datos, para no reemplazar
                            while not IStream.eos do begin
                                IStream.Read(DummyTxt);
                                PreviousTxt := PreviousTxt + DummyTxt;
                            end;
                            SalesHeader."EDI - Comments".CreateOutstream(OStream);
                            //OStream.WRITE(PreviousTxt+CalificadorTemaTexto+' '+"ERE1T Texto1"+"ERE1T Texto2"+"ERE1T Texto3"+"ERE1T Texto4"+"ERE1T Texto5"); // Actualizamos la info
                            OStream.Write(DummyTxt + CalificadorTemaTexto + ' ' + TempOrder."ERE1T Texto1" + TempOrder."ERE1T Texto2" + TempOrder."ERE1T Texto3" + TempOrder."ERE1T Texto4" + TempOrder."ERE1T Texto5"); // Actualizamos la info
                            SalesHeader.Modify(true);
                        end
                        else begin
                            PurchaseHeader.TestField("No.");
                            PurchaseHeader.CalcFields("EDI - Comments");
                            PurchaseHeader."EDI - Comments".CreateInstream(IStream); // Primero leemos todos los datos, para no reemplazar
                            while not IStream.eos do begin
                                IStream.Read(DummyTxt);
                                PreviousTxt := PreviousTxt + DummyTxt;
                            end;
                            PurchaseHeader."EDI - Comments".CreateOutstream(OStream);
                            //OStream.WRITE(PreviousTxt+CalificadorTemaTexto+' '+"ERE1T Texto1"+"ERE1T Texto2"+"ERE1T Texto3"+"ERE1T Texto4"+"ERE1T Texto5"); // Actualizamos la info
                            OStream.Write(DummyTxt + CalificadorTemaTexto + ' ' + TempOrder."ERE1T Texto1" + TempOrder."ERE1T Texto2" + TempOrder."ERE1T Texto3" + TempOrder."ERE1T Texto4" + TempOrder."ERE1T Texto5"); // Actualizamos la info
                            if PurchaseHeader."Document Type" = PurchaseHeader."document type"::"Credit Memo" then PurchaseHeader."Invoice Disc. Code" := '';
                            PurchaseHeader.Modify(true);
                        end;
                    end;
                    until TempOrder.Next = 0;
                TempOrder.Reset;
                TempOrder.SetRange("Entry No.", CurrentOrderFromEntryNo, CurrentOrderToEntryNo);
                TempOrder.SetFilter(TempOrder."ERE1V ContadorVencimiento", '>%1', 0);
                if TempOrder.FindFirst then begin
                    begin
                        rEDIDocumentinstallment.Init;
                        if SalesHeader."No." <> '' then begin
                            case SalesHeader."Document Type" of
                                SalesHeader."document type"::Order:
                                    rEDIDocumentinstallment.Validate("Document Type", rEDIDocumentinstallment."document type"::Order);
                                else
                                    Error('Tipo de documento no contemplado');
                            end;
                            rEDIDocumentinstallment.Validate("Document No.", SalesHeader."No.");
                        end
                        else begin
                            PurchaseHeader.TestField("No.");
                            case PurchaseHeader."Document Type" of
                                PurchaseHeader."document type"::Invoice:
                                    rEDIDocumentinstallment.Validate("Document Type", rEDIDocumentinstallment."document type"::Invoice);
                                else
                                    Error('Tipo de documento no contemplado');
                            end;
                            rEDIDocumentinstallment.Validate("Document No.", PurchaseHeader."No.");
                        end;
                        rEDIDocumentinstallment.Validate("Line No.", TempOrder."ERE1V ContadorVencimiento");
                        case TempOrder."ERE1V ReferenciaTiempoPagoCod" of
                            '', ' ':
                                rEDIDocumentinstallment.Validate("Payment time ref. type", rEDIDocumentinstallment."payment time ref. type"::" ");
                            '5':
                                rEDIDocumentinstallment.Validate("Payment time ref. type", rEDIDocumentinstallment."payment time ref. type"::"5");
                            '29':
                                rEDIDocumentinstallment.Validate("Payment time ref. type", rEDIDocumentinstallment."payment time ref. type"::"29");
                            '66':
                                rEDIDocumentinstallment.Validate("Payment time ref. type", rEDIDocumentinstallment."payment time ref. type"::"66");
                            '68':       // No tenemos el tipo 68 - Asignamos el 29 por defecto.
                                rEDIDocumentinstallment.Validate("Payment time ref. type", rEDIDocumentinstallment."payment time ref. type"::"29");
                            '69':
                                rEDIDocumentinstallment.Validate("Payment time ref. type", rEDIDocumentinstallment."payment time ref. type"::"69");
                            '81':
                                rEDIDocumentinstallment.Validate("Payment time ref. type", rEDIDocumentinstallment."payment time ref. type"::"81");
                        //    else
                        //        Error('Referencia tiempo pago no contemplada ' + TempOrder."ERE1V ReferenciaTiempoPagoCod");
                        end;
                        case TempOrder."ERE1V RelacionTiempoCodificado" of
                            '', ' ':
                                rEDIDocumentinstallment.Validate("Time relation type", rEDIDocumentinstallment."time relation type"::" ");
                            '1':
                                rEDIDocumentinstallment.Validate("Time relation type", rEDIDocumentinstallment."time relation type"::"1");
                            '3':
                                rEDIDocumentinstallment.Validate("Time relation type", rEDIDocumentinstallment."time relation type"::"3");
                        //    else
                        //        Error('Relación de tiempo sin contemplar');
                        end;
                        case TempOrder."ERE1V TipoPeriodoCodificado" of
                            '', ' ':
                                rEDIDocumentinstallment.Validate("Period type", rEDIDocumentinstallment."period type"::" ");
                            'D':
                                rEDIDocumentinstallment.Validate("Period type", rEDIDocumentinstallment."period type"::D);
                            'M':
                                rEDIDocumentinstallment.Validate("Period type", rEDIDocumentinstallment."period type"::M);
                            'WD':
                                rEDIDocumentinstallment.Validate("Period type", rEDIDocumentinstallment."period type"::WD);
                            'Y':
                                rEDIDocumentinstallment.Validate("Period type", rEDIDocumentinstallment."period type"::Y);
                        //    else
                        //        Error('Tipo de período no contemplado ' + TempOrder."ERE1V TipoPeriodoCodificado");
                        end;
                        rEDIDocumentinstallment.Validate("Period number", TempOrder."ERE1V NumeroPeriodos");
                        rEDIDocumentinstallment.Validate("Due date", TempOrder."ERE1V FechaVencimiento");
                        rEDIDocumentinstallment.Validate(Amount, TempOrder."ERE1V ImporteVencimiento");
                        rEDIDocumentinstallment.Insert(true);
                    end;
                end;

                //Lineas del Pedido V2
                CreateLinesOrderv2(CurrentOrderFromEntryNo, CurrentOrderToEntryNo);

            until rTempOrderHeader.Next = 0;
    end;

    local procedure CreateLinesOrderv2(CurrentOrderFromEntryNo: Integer; CurrentOrderToEntryNo: Integer)
    var
        rItemIdentifier: Record "Item Identifier";
        rUnitofMeasure: Record "Unit of Measure";
        rItem: Record Item;
        rItemReference: Record "Item Reference";
        rItemUnitofMeasure: Record "Item Unit of Measure";
    begin
        TempOrderAux.Reset;
        TempOrderAux.SetRange("Entry No.", CurrentOrderFromEntryNo, CurrentOrderToEntryNo);
        TempOrderAux.SetFilter("ERE1L NumeroLineaArticulo", '<>%1', 0);
        if TempOrderAux.FindSet then
            repeat begin
                if SalesHeader."No." <> '' then begin
                    SalesLine.Init;
                    SalesLine.Validate("Document Type", SalesHeader."Document Type");
                    SalesLine.Validate("Document No.", SalesHeader."No.");
                    SalesLine.Validate("Line No.", TempOrderAux."ERE1L NumeroLineaArticulo");
                    SalesLine.Insert(true);
                    //Localizamos el producto
                    SalesLine.Validate(Type, SalesLine.Type::Item);
                    if TempOrderAux."ERE1L CodigoEAN13DUN14Articulo" <> '' then begin
                        SalesLine.Validate("EDI - EAN13/DUN14", TempOrderAux."ERE1L CodigoEAN13DUN14Articulo");
                        rItemIdentifier.Reset;
                        rItemIdentifier.SetRange(Code, TempOrderAux."ERE1L CodigoEAN13DUN14Articulo");
                        if rItemIdentifier.FindFirst then begin
                            SalesLine.Validate("No.", rItemIdentifier."Item No.");
                            rItem.Reset;
                            rItem.Get(SalesLine."No.");
                            rItem.TestField("Base Unit of Measure");
                            rItemUnitofMeasure.Reset;
                            rItemUnitofMeasure.SetRange("Item No.", rItem."No.");
                            rItemUnitofMeasure.SetRange(Code, rItemIdentifier."Unit of Measure Code");
                            if not rItemUnitofMeasure.FindFirst then
                                Error('Falta Cdad. por Unidad Medida %1 del producto %2', rItemIdentifier."Unit of Measure Code", rItem."No.");
                        end
                        else
                            Error('No se ha podido encontrar el producto con EAN13/DUN14 ' + TempOrderAux."ERE1L CodigoEAN13DUN14Articulo");

                        //>>BBT 11/03/2025 Tenemos referencia de producto del cliente. Si no existe la damos de alta.
                        if TempOrderAux."ERE1L NumeroArticuloComprador" <> '' then begin
                            rItemReference.Reset;
                            rItemReference.SetRange("Item No.", rItem."No.");
                            rItemReference.SetRange("Unit of Measure", rItem."Base Unit of Measure");
                            rItemReference.SetRange("Reference Type", rItemReference."Reference Type"::Customer);
                            rItemReference.SetRange("Reference Type No.", SalesHeader."Sell-to Customer No.");
                            rItemReference.SetRange("Reference No.", TempOrderAux."ERE1L NumeroArticuloComprador");
                            if not rItemReference.FindFirst() then begin
                                rItemReference.Init;
                                rItemReference.Validate("Item No.", rItem."No.");
                                rItemReference.Validate("Unit of Measure", rItem."Base Unit of Measure");
                                rItemReference.Validate("Reference Type", rItemReference."Reference Type"::Customer);
                                rItemReference.Validate("Reference Type No.", SalesHeader."Sell-to Customer No.");
                                rItemReference.Validate("Reference No.", TempOrderAux."ERE1L NumeroArticuloComprador");
                                rItemReference.Insert();
                            end;
                        end;
                        //<<    
                    end
                    else begin
                        if TempOrderAux."ERE1L NumeroArticuloComprador" <> '' then begin
                            rItemReference.Reset;
                            rItemReference.SetRange("Reference Type", rItemReference."Reference Type"::Customer);
                            rItemReference.SetRange("Reference Type No.", SalesHeader."Sell-to Customer No.");
                            rItemReference.SetRange("Reference No.", TempOrderAux."ERE1L NumeroArticuloComprador");
                            if rItemReference.FindFirst() then begin
                                SalesLine.Validate("No.", rItemReference."Item No.");
                                rItem.Reset;
                                rItem.Get(SalesLine."No.");
                                rItem.TestField("Base Unit of Measure");
                                rItemUnitofMeasure.Reset;
                                rItemUnitofMeasure.SetRange("Item No.", rItem."No.");
                                rItemUnitofMeasure.SetRange(Code, rItemReference."Unit of Measure");
                                if not rItemUnitofMeasure.FindFirst then
                                    Error('Falta Cdad. por Unidad Medida %1 del producto %2', rItemReference."Unit of Measure", rItem."No.");
                            end
                        end
                        else
                            Error('No se ha podido encontrar el producto con Referencia Cruzada ' + TempOrderAux."ERE1L NumeroArticuloComprador");
                    end;

                    SalesLine.Validate("EDI - Item code type", TempOrderAux."ERE1L TipoCodigoArticulo");
                    SalesLine.Validate("EDI - Promotion variable", TempOrderAux."ERE1L VariablePromocional");
                    SalesLine.Validate("EDI - Extra item EAN", TempOrderAux."ERE1L CodigoEANDelArticuloAdic");
                    SalesLine.Validate(Quantity, TempOrderAux."ERE1L CantidadPedida" * rItemUnitofMeasure."Qty. per Unit of Measure");
                    SalesLine.Validate("EDI - Reimbursed Qty.", TempOrderAux."ERE1L CantidadBonificada");
                    SalesLine.Validate("Unit of Measure Code", rItem."Base Unit of Measure");
                    SalesLine.Validate("EDI - Line Amount", TempOrderAux."ERE1L ImporteNetoLinea");
                    if TempOrderAux."ERE1L PrecioBrutoUnitario" <> 0 then
                        SalesLine.Validate("EDI - Gross unit price", TempOrderAux."ERE1L PrecioBrutoUnitario")
                    else
                        if TempOrderAux."ERE1L PrecioNetoUnitario" <> 0 then
                            SalesLine.Validate("EDI - Gross unit price", TempOrderAux."ERE1L PrecioNetoUnitario")
                        else
                            SalesLine.Validate("EDI - Gross unit price", TempOrderAux."ERE1L PrecioATituloInformativo");
                    SalesLine.Validate("EDI - Price UOM", TempOrderAux."ERE1L CalifiUDeMedidaPrecio");
                    SalesLine.Validate("EDI - Tax type", TempOrderAux."ERE1L CalificadorIVAIGIC");
                    SalesLine.Validate("EDI - Tax %", TempOrderAux."ERE1L PorcentajeIVAIGIC");
                    SalesLine.Validate("EDI - Tax Amt.", TempOrderAux."ERE1L ImporteIVAIGIC");
                    SalesLine.Validate("EDI - RE %", TempOrderAux."ERE1L PorRecargoEquivalencia");
                    SalesLine.Validate("EDI - RE Amt.", TempOrderAux."ERE1L ImporteRecargoEquiv");
                    SalesLine.Validate("EDI - Other tax type", TempOrderAux."ERE1L CalificadorOtroTipoDeImp");
                    SalesLine.Validate("EDI - Other tax %", TempOrderAux."ERE1L PorOtroTipoDeImpuesto");
                    SalesLine.Validate("EDI - Other tax amt.", TempOrderAux."ERE1L ImporteOtroTipoDeImp");
                    SalesLine.Validate("EDI - Net weight", TempOrderAux."ERE1L PesoNeto");
                    if TempOrderAux."ERE1L CalificadorUDeMedidaPeso" <> '' then begin
                        rUnitofMeasure.Reset;
                        rUnitofMeasure.SetRange("EDI - Unit of measure code", TempOrderAux."ERE1L CalificadorUDeMedidaPeso");
                        if rUnitofMeasure.FindSet then
                            SalesLine.Validate("EDI - Weight UOM", TempOrderAux."ERE1L CalificadorUDeMedidaPeso")
                        else
                            Error('No se encuentra traducción para el cód. Ud. Medida ' + TempOrderAux."ERE1L CalificadorUDeMedidaPeso");
                    end;
                    SalesLine.Validate("EDI - Model description", TempOrderAux."ERE1L DescripcionDelModelo");
                    SalesLine.Validate("EDI - Color", TempOrderAux."ERE1L Color");
                    SalesLine.Validate("EDI - Width or size", TempOrderAux."ERE1L AnchuraOTalla");
                    SalesLine.Validate("EDI - Item SN", TempOrderAux."ERE1L NumeroSerieArticulo");
                    SalesLine.Validate("EDI - Item Lot", TempOrderAux."ERE1L NumeroLote");
                    SalesLine.Validate("EDI - Manufacturer Item No.", TempOrderAux."ERE1L NumeroArticuloFabricante");
                    SalesLine.Validate("EDI - Line Amt. Tax incl.", TempOrderAux."ERE1L ImporteLíneaConImpuestos");
                    SalesLine.Validate("EDI - Net unit price base", TempOrderAux."ERE1L BasePrecioNetoUnitario");
                    SalesLine.Validate("EDI - Item price taxes incl.", TempOrderAux."ERE1L PrecioArticuloConImp");
                    SalesLine.Validate("EDI - Shipment No.", TempOrderAux."ERE1L NumeroAlbaran");
                    SalesLine.Validate("EDI - Shipment date", TempOrderAux."ERE1L FechaAlbaran");
                    SalesLine.Validate("EDI - End customer code", TempOrderAux."ERE1L CodigoClienteFinal");
                    SalesLine.Validate("EDI - End customer name", TempOrderAux."ERE1L NombreClienteFinal");
                    SalesLine.Validate("EDI - End customer address", TempOrderAux."ERE1L DireccionClienteFinal");
                    SalesLine.Validate("EDI - End customer city", TempOrderAux."ERE1L PoblacionClienteFinal");
                    SalesLine.Validate("EDI - End customer post code", TempOrderAux."ERE1L CodigoPostalClienteFinal");
                    SalesLine.Validate("EDI - Item ID/Order Line", TempOrderAux."ERE1L IdentificadorProdLinPed");
                    SalesLine.Validate("Ship-to Code", SalesHeader."Ship-to Code");
                    SalesLine.Modify(true);

                    //>>NO QUIERES IMPORTAR LOS DESCUENTOS
                    //ApplyDiscounts(SalesLine);
                    //<<NO QUIERES IMPORTAR LOS DESCUENTOS

                end
                else begin // Los docs de compra por este circuito no han funcionado nunca, se deberían revisar antes de arrancar
                    Error('Función no permitida. Póngase en contacto con el administrador del sistema');
                    /*
                    PurchaseHeader.TESTFIELD("No.");

                    PurchaseLine.INIT;
                    PurchaseLine.VALIDATE("Document Type",PurchaseHeader."Document Type");
                    PurchaseLine.VALIDATE("Document No.",PurchaseHeader."No.");
                    PurchaseLine.VALIDATE("Line No.","ERE1L NumeroLineaArticulo");
                    PurchaseLine.INSERT(TRUE);
                    PurchaseLine.VALIDATE(Type,PurchaseLine.Type::Item);

                    IF "ERE1L CodigoEAN13DUN14Articulo"<>'' THEN BEGIN
                    PurchaseLine.VALIDATE("EDI - EAN13/DUN14","ERE1L CodigoEAN13DUN14Articulo");
                    PurchaseLine.VALIDATE("No.",ItemCrossReference."Item No.")
                    END ELSE
                    ERROR('El código EAN13/DUN14 debe estar informado');

                    PurchaseLine.VALIDATE("EDI - Item code type","ERE1L TipoCodigoArticulo");

                    IF PurchaseLine."Document Type"=PurchaseLine."Document Type"::"Credit Memo" THEN
                    BEGIN
                    ItemCode := SalesLine.Description;
                    PurchaseLine.VALIDATE("No.",'/');
                    PurchaseLine.VALIDATE(PurchaseLine."Location Code",'5-DES');
                    PurchaseLine.VALIDATE("Direct Unit Cost","ERE1L ImporteNetoLinea");
                    END;

                    PurchaseLine.VALIDATE("EDI - Promotion variable","ERE1L VariablePromocional");
                    PurchaseLine.VALIDATE("EDI - Extra item EAN","ERE1L CodigoEANDelArticuloAdic");
                    PurchaseLine.VALIDATE(Quantity,"ERE1L CantidadPedida");
                    PurchaseLine.VALIDATE("EDI - Reimbursed Qty.","ERE1L CantidadBonificada");
                    PurchaseLine.VALIDATE("Unit of Measure Code",'UD.');
                    PurchaseLine.VALIDATE("EDI - Line Amount","ERE1L ImporteNetoLinea");
                    IF "ERE1L PrecioBrutoUnitario"<>0 THEN
                    PurchaseLine.VALIDATE("EDI - Gross unit price","ERE1L PrecioBrutoUnitario")
                    ELSE
                        if TempOrderAux."ERE1L PrecioNetoUnitario" <> 0 then
                            SalesLine.Validate("EDI - Gross unit price", TempOrderAux."ERE1L PrecioNetoUnitario")
                        else
                            SalesLine.Validate("EDI - Gross unit price", TempOrderAux."ERE1L PrecioATituloInformativo");
                    PurchaseLine.VALIDATE("EDI - Price UOM","ERE1L CalifiUDeMedidaPrecio");
                    PurchaseLine.VALIDATE("EDI - Tax type","ERE1L CalificadorIVAIGIC");
                    PurchaseLine.VALIDATE("EDI - Tax %","ERE1L PorcentajeIVAIGIC");
                    PurchaseLine.VALIDATE("EDI - Tax Amt.","ERE1L ImporteIVAIGIC");
                    PurchaseLine.VALIDATE("EDI - RE %","ERE1L PorRecargoEquivalencia");
                    PurchaseLine.VALIDATE("EDI - RE Amt.","ERE1L ImporteRecargoEquiv");
                    PurchaseLine.VALIDATE("EDI - Other tax type","ERE1L CalificadorOtroTipoDeImp");
                    PurchaseLine.VALIDATE("EDI - Other tax %","ERE1L PorOtroTipoDeImpuesto");
                    PurchaseLine.VALIDATE("EDI - Other tax amt.","ERE1L ImporteOtroTipoDeImp");
                    PurchaseLine.VALIDATE("EDI - Net weight","ERE1L PesoNeto");
                    IF "ERE1L CalificadorUDeMedidaPeso"<>'' THEN BEGIN
                    UnitofMeasure.RESET;
                    UnitofMeasure.SETRANGE("EDI - Unit of measure code","ERE1L CalificadorUDeMedidaPeso");
                    IF UnitofMeasure.FINDSET THEN
                        PurchaseLine.VALIDATE("EDI - Weight UOM","ERE1L CalificadorUDeMedidaPeso")
                    ELSE
                        ERROR('No se encuentra traducción para el cód. Ud. Medida '+"ERE1L CalificadorUDeMedidaPeso");
                    END;
                    PurchaseLine.VALIDATE("EDI - Model description","ERE1L DescripcionDelModelo");
                    PurchaseLine.VALIDATE("EDI - Color","ERE1L Color");
                    PurchaseLine.VALIDATE("EDI - Width or size","ERE1L AnchuraOTalla");
                    PurchaseLine.VALIDATE("EDI - Item SN","ERE1L NumeroSerieArticulo");
                    PurchaseLine.VALIDATE("EDI - Item Lot","ERE1L NumeroLote");
                    PurchaseLine.VALIDATE("EDI - Manufacturer Item No.","ERE1L NumeroArticuloFabricante");
                    PurchaseLine.VALIDATE("EDI - Line Amt. Tax incl.","ERE1L ImporteLíneaConImpuestos");
                    PurchaseLine.VALIDATE("EDI - Net unit price base","ERE1L BasePrecioNetoUnitario");
                    PurchaseLine.VALIDATE("EDI - Item price taxes incl.","ERE1L PrecioArticuloConImp");
                    PurchaseLine.VALIDATE("EDI - Shipment No.","ERE1L NumeroAlbaran");
                    PurchaseLine.VALIDATE("EDI - Shipment date","ERE1L FechaAlbaran");
                    PurchaseLine.VALIDATE("EDI - End customer code","ERE1L CodigoClienteFinal");
                    PurchaseLine.VALIDATE("EDI - End customer name","ERE1L NombreClienteFinal");
                    PurchaseLine.VALIDATE("EDI - End customer address","ERE1L DireccionClienteFinal");
                    PurchaseLine.VALIDATE("EDI - End customer city","ERE1L PoblacionClienteFinal");
                    PurchaseLine.VALIDATE("EDI - End customer post code","ERE1L CodigoPostalClienteFinal");
                    PurchaseLine.VALIDATE("EDI - Item ID/Order Line","ERE1L IdentificadorProdLinPed");
                    //PurchaseLine.VALIDATE("Ship-to Code",PurchaseHeader."Ship-to Code");
                    PurchaseLine.Description := ItemCode;
                    IF PurchaseLine."Document Type"=PurchaseLine."Document Type"::"Credit Memo" THEN
                    BEGIN
                    PurchaseLine.VALIDATE("Direct Unit Cost","ERE1L ImporteNetoLinea");
                    END;

                    PurchaseLine.MODIFY(TRUE);
                    */
                end;
            end;
            until TempOrderAux.Next = 0;

    end;

    local procedure ControlData()
    begin
        TempOrder.Reset;
        TempOrder.SetRange("RECTL TipodeMensaje", 'ORDERS');
        if TempOrder.FindFirst then //IF LineProcessedRECTL THEN
            if TempOrder.Count <> 1 then Error('El tipo de registro RECTL debería aparecer una vez por fichero');
        if TempOrder."RECTL FechaHoraMensaje" = 0DT then Error('No se ha especificado una fecha/hora válida para este documento');
        /*
            SalesHeaderAux.RESET;
            SalesHeaderAux.SETRANGE("External Document No.",COPYSTR(NumeroPedido,1,MAXSTRLEN(SalesHeader."External Document No.")));
            IF SalesHeaderAux.FINDSET THEN
              ERROR('Este documento se había procesado con anterioridad')
            ELSE BEGIN
              SalesShipmentHeader.RESET;
              SalesShipmentHeader.SETRANGE("External Document No.",COPYSTR(NumeroPedido,1,MAXSTRLEN(SalesHeader."External Document No.")));
              IF SalesShipmentHeader.FINDSET THEN
                ERROR('Este documento se había procesado con anterioridad')
            END;
            */
    end;

    local procedure ApplyDiscounts(var rSalesLine: Record "Sales Line")
    var
        rEDITemporaryOrders: Record "EDI - Temporary Orders";
        NoOfDiscountsToBeApplied: Integer;
        CommercialDiscountCount: Integer;
    begin
        begin
            rSalesLine.TestField(rSalesLine."No.");
            rSalesLine.TestField(rSalesLine."Line Discount %", 0); //Si esto peta puede ser porque vengan descuentos predefinidos de cliente/estándar NAV, lo controlamos? Comentar internamente
            //TempOrderAux.TESTFIELD("ERE1L CodigoEAN13DUN14Articulo");
            NoOfDiscountsToBeApplied := 0;
            CommercialDiscountCount := 0;
            rEDITemporaryOrders.Reset;
            rEDITemporaryOrders.SetFilter("Entry No.", '%1..', TempOrderAux."Entry No." + 1);
            if rEDITemporaryOrders.FindSet then
                repeat
                    if rEDITemporaryOrders.Type = 'ERE1E' then begin
                        NoOfDiscountsToBeApplied += 1;
                        if NoOfDiscountsToBeApplied > 1 then
                            Error('La línea del documento cuenta con más de un descuento. Por favor póngase en contacto con el administrador del sistema'); // Pendiente de ver cómo lo aplicamos
                        case rEDITemporaryOrders."ERE1E TipoDescuentoCargo" of
                            'TD', '': // Dto. Comercial
                                begin
                                    CommercialDiscountCount += 1;
                                    case CommercialDiscountCount of
                                        1:
                                            rSalesLine.Validate("SMG Discount 1 %", rEDITemporaryOrders."ERE1E PorcentajeDescuentoCargo");
                                        2:
                                            rSalesLine.Validate("SMG Discount 2 %", rEDITemporaryOrders."ERE1E PorcentajeDescuentoCargo");
                                        3:
                                            rSalesLine.Validate("SMG Discount 3 %", rEDITemporaryOrders."ERE1E PorcentajeDescuentoCargo");
                                        4:
                                            rSalesLine.Validate("SMG Discount 4 %", rEDITemporaryOrders."ERE1E PorcentajeDescuentoCargo");
                                        5:
                                            rSalesLine.Validate("SMG Discount 5 %", rEDITemporaryOrders."ERE1E PorcentajeDescuentoCargo");
                                        else
                                            Error('Se ha llegado al máximo de descuentos aplicables. Contacte con el administrador del sistema.');
                                    end;
                                    rSalesLine.Modify;
                                end;
                            'EAB', // Dto Pronto Pago
                            'FC', // Cargo por fletes
                            'PC', // Cargo por embalajes
                            'SH': // Cargo por montajes
                                Error('Pendiente de gestionar el tipo de descuento/cargo ' + rEDITemporaryOrders."ERE1E TipoDescuentoCargo" + '. Contacte con el administrador dle sistema');
                            else
                                Error('Opción de descuento/cargo no contemplada: ' + rEDITemporaryOrders."ERE1E TipoDescuentoCargo" + '. Contacte con el administrador del sistema');
                        end;
                    end;
                until (rEDITemporaryOrders.Next = 0) or (rEDITemporaryOrders.Type <> 'ERE1E');
        end;
    end;

    /*******************************************************************************************/
    /******************************** EDI - DESADV - ALBARAN ***********************************/
    /*******************************************************************************************/
    /*
     Tipo   Nombre registro                                   Repeticiones
     _____  ____________________________________  ___________ _____________
     RECTL    Registro de control                 Obligatorio           1
     SEH1C    Cabecera                            Obligatorio           1
     SEH1D    Información de partes               Obligatorio           N
     SEH1P    Secuencia de embalajes              Obligatorio           N
     SEH1L    Línea de artículos                  Obligatorio           N
     SEH1G    Desglose cantidad/Localizaciones    Opcional              N
     SEH1B    Información de lotes                Opcional              N
    */
    procedure CreateShipmentEDIEntry(rSalesShipmentHeader: Record "Sales Shipment Header")
    var
        rEDIEDIEntry: Record "EDI - EDI Entry";
        rCompanyInformation: Record "Company Information";
        rCustomer: Record Customer;
    begin
        begin
            rCompanyInformation.Reset;
            rCompanyInformation.Get;
            if rCompanyInformation."EDI ID" = '' then exit;
            rCustomer.Reset;
            if rCustomer.Get(rSalesShipmentHeader."Sell-to Customer No.") then begin
                if rCustomer."No EDI" then exit;
                // Se llama al registrar el albarán
                //>> Nos aseguramos que se eliminan las partes existentes del albarán
                //   AddShipmentParts(rSalesShipmentHeader, false); 
                AddShipmentParts(rSalesShipmentHeader, true);
                //<<
                if not (rCustomer."Send EDI Documents" in [rCustomer."send edi documents"::All, rCustomer."send edi documents"::Shipment]) then
                    exit;
            end
            else
                exit;
            if rSalesShipmentHeader."EDI - Do not send EDI" then
                exit;
            rEDIEDIEntry.Reset;
            rEDIEDIEntry.SetRange("Document Nos.", rSalesShipmentHeader."No.");
            rEDIEDIEntry.SetRange("Inbound/Outbound", rEDIEDIEntry."inbound/outbound"::Outbound);
            //>> Comprobamos que el albarán no exista ya en los documentos EDI
            if rEDIEDIEntry.FindSet then exit;
            //<<
            rEDIEDIEntry.Init;
            rEDIEDIEntry.Validate("Document type", rEDIEDIEntry."document type"::Shipment);
            rEDIEDIEntry.Validate("Inbound/Outbound", rEDIEDIEntry."inbound/outbound"::Outbound);
            //EDIEDIEntry."File name"
            //EDIEDIEntry."File Blob"
            rEDIEDIEntry.Validate("Document Nos.", rSalesShipmentHeader."No.");
            rEDIEDIEntry.Insert(true);
        end;
    end;

    local procedure CreateShipmentEDIBlob(var rEDIEDIEntry: Record "EDI - EDI Entry")
    var
        OStream: OutStream;
        rSalesReceivablesSetup: Record "Sales & Receivables Setup";
        EdiFilesProcesing: Codeunit "BBT EDI Files Procesing";
        rSalesShipment: Record "Sales Shipment Header";
        rCustomer: Record "Customer";
    begin
        begin
            if (rEDIEDIEntry."Processed at" <> 0DT) or (rEDIEDIEntry."Manually processed") then exit;
            rSalesReceivablesSetup.Reset;
            rSalesReceivablesSetup.Get;
            rSalesReceivablesSetup.TestField("EDI - Sales Shpt. Prefix");
            rEDIEDIEntry.Validate(rEDIEDIEntry."File name", rSalesReceivablesSetup."EDI - Sales Shpt. Prefix" + rEDIEDIEntry."Document Nos." + '.TXT');
            Clear(rEDIEDIEntry."File Blob");
            rEDIEDIEntry."File Blob".CreateOutstream(OStream);
            CreateShipmentRECTLine(rEDIEDIEntry, OStream); // Registro de control - 1 iteración
            CreateShipmentSEH1CLine(rEDIEDIEntry, OStream); // Cabecera - 1 iteración
            CreateShipmentSEH1DLine(rEDIEDIEntry, OStream); // Información de partes - N iteraciones
            CreateShipmentSEH1PLine(rEDIEDIEntry, OStream); // Secuencia de embalajes - N iteraciones

            //CreateShipmentSEH1Line(EDIEDIEntry,OStream); // Línea de artículos - N iteraciones - Esta función la llamamos desde los embalajes

            //>> 12/03/2025 Marcamos el registro NAC/PL y actualizamos el código del cliente
            rSalesShipment.Reset;
            rSalesShipment.Get(rEDIEDIEntry."Document Nos.");
            rCustomer.Reset;
            rCustomer.Get(rSalesShipment."Sell-to Customer No.");
            rEDIEDIEntry.Validate("Source Type", rEDIEDIEntry."Source Type"::Customer);
            rEDIEDIEntry.Validate("Sourde Id", rCustomer."No.");
            rEDIEDIEntry.Validate("Source Name", rCustomer."Name");
            rEDIEDIEntry.Validate("PL Entry", false);
            if rCustomer."VAT PL" then
                rEDIEDIEntry.Validate("PL Entry", true);
            //<<

            rEDIEDIEntry.Modify(true);
            EdiFilesProcesing.UploadShipmentFileToFTP(rEDIEDIEntry);
        end;
    end;

    local procedure CreateShipmentRECTLine(rEDIEDIEntry: Record "EDI - EDI Entry"; var OStream: OutStream)
    var
        EDILineTxt: Text;
        rCompanyInformation: Record "Company Information";
        rSalesShipmentHeader: Record "Sales Shipment Header";
        rCustomer: Record Customer;
    begin
        begin
            rEDIEDIEntry.TestField("Document Nos.");
            rEDIEDIEntry.TestField("Document type", rEDIEDIEntry."document type"::Shipment);
            rCompanyInformation.Reset;
            rCompanyInformation.Get;
            rCompanyInformation.TestField("EDI ID");
            rCompanyInformation.TestField("EDI ID PL"); // EDI ID de venta con CIF Polonia
            rSalesShipmentHeader.Reset;
            rSalesShipmentHeader.Get(rEDIEDIEntry."Document Nos.");
            rSalesShipmentHeader.TestField("EDI - Do not send EDI", false); // Si no se tiene que enviar a EDI, el registro del que partimos (EDI Entry) no debería haberse generado desde un principio
            rCustomer.Reset;
            rCustomer.Get(rSalesShipmentHeader."Sell-to Customer No.");
            rCustomer.TestField("EDI ID");
            // Escribimos la línea
            EDILineTxt := '';
            WriteTextField('RECTL', EDILineTxt, 6);                                     // 001 - Tipo de Registro - RECTL
            WriteTextField('DESADV', EDILineTxt, 6);                                    // 007 - Tipo de mensaje - DESADV
            if rCustomer."VAT PL" then                                                  // 013 - Código emisor
                WriteTextField(rCompanyInformation."EDI ID PL", EDILineTxt, 35)
            else
                WriteTextField(rCompanyInformation."EDI ID", EDILineTxt, 35);

            if rCustomer."SMG Purchase Group" = 'ALZA' then
                EdiCustCode := '8594177950005'
            else
                EdiCustCode := rCustomer."EDI ID";
            WriteTextField(EdiCustCode, EDILineTxt, 35);                                // 048 - Código receptor
            WriteTextField(CopyStr(rSalesShipmentHeader."No.", 3, 7), EDILineTxt, 40);  // 083 - Identificación del mensaje 
                                                                                        // Esto podría necesitar cambiarse - Añado el "ALB" inicial
                                                                                        // al código de albarán para que si se arranca EDI para dev. compras,
                                                                                        // o transfers, podamos diferenciar los distintos tipos de expediciones
            WriteDatetimeField(CurrentDatetime, EDILineTxt, 12);                        // 123 - Fecha/hora del mensaje
            // Comprobación de longitud
            if (StrLen(EDILineTxt) <> 134) then
                Error('La línea de tipo RECTL tiene una longitud distinta a la esperada (esperada 134, real ' + Format(StrLen(EDILineTxt)) + ')');
            OStream.WriteText(EDILineTxt);
            OStream.WriteText; // Salto de línea
        end;
    end;

    local procedure CreateShipmentSEH1CLine(rEDIEDIEntry: Record "EDI - EDI Entry"; var OStream: OutStream)
    var
        EDILineTxt: Text;
        rSalesShipment: Record "Sales Shipment Header";
        rSalesHeader: Record "Sales Header";
    begin
        begin
            rEDIEDIEntry.TestField("Document Nos.");
            rEDIEDIEntry.TestField("Document type", rEDIEDIEntry."document type"::Shipment);
            rSalesShipment.Reset;
            rSalesShipment.Get(rEDIEDIEntry."Document Nos.");
            rSalesHeader.Reset();
            rSalesHeader.Get(rSalesHeader."Document Type"::Order, rSalesShipment."Order No.");
            if not rSalesHeader."EDI - EDI Order" then
                Error('El pedido relacionado %1 no es EDI', rSalesShipment."Order No.");
            if rSalesShipment."EDI - Delivery datetime" = 0DT then Error('Debe especificar Fecha entrega EDI');

            // Escribimos la línea
            EDILineTxt := '';
            WriteTextField('SEH1C', EDILineTxt, 6);                                 // 001 - Tipo registro
            WriteTextField('351', EDILineTxt, 6);                                   // 007 - Tipo documento
            WriteTextField(CopyStr(rSalesShipment."No.", 3, 7), EDILineTxt, 17);    // 013 - Número documento
            WriteTextField('9', EDILineTxt, 6);                                     // 030 - Función del mensaje - Ponemos fijo: 9-Original
            WriteDatetimeField(CurrentDatetime, EDILineTxt, 12);                    // 036 - Fecha/hora del documento
            WriteDatetimeField(rSalesShipment."EDI - Delivery datetime", EDILineTxt, 12); // 048 - Fecha/hora entrega estimada
            WriteTextField('11', EDILineTxt, 3);                                    // 060 - Calificador fecha/hora1 - Representa una fecha adicional que pueda o no ser necesaria
            WriteDatetimeField(CurrentDatetime, EDILineTxt, 12);                    // 063 - Fecha/hora1
            WriteTextField('', EDILineTxt, 3);                                      // 075 - Calificador fecha/hora2 - Representa una fecha adicional que pueda o no ser necesaria
            WriteDatetimeField(0DT, EDILineTxt, 12);                                // 078 - Fecha/hora 2
            WriteTextField('', EDILineTxt, 6);                                      // 090 - Información adicional - Podemos decir si es "enviado y no facturado"
            WriteTextField(rSalesShipment."External Document No.", EDILineTxt, 17); // 096 - Número pedido comprador
            WriteDatetimeField(CreateDatetime(rSalesShipment."Order Date", 000000T), EDILineTxt, 12); // 113 - Fecha/hora número pedido
            WriteTextField(CopyStr(rSalesShipment."No.", 3, 7), EDILineTxt, 17);    // 125 - Nº Albarán
            WriteDatetimeField(CreateDatetime(rSalesShipment."Posting Date", 0T), EDILineTxt, 12); // 142 - Fecha/hora albarán
            WriteTextField('', EDILineTxt, 3);                                      // 154 - Calificador de referencia 1
            WriteTextField('', EDILineTxt, 17);                                     // 157 - Numero de referencia 1
            WriteDatetimeField(0DT, EDILineTxt, 12);                                // 174 - Fecha/hora ref. adicional 
            WriteTextField('', EDILineTxt, 3);                                      // 186 - Calificador referencia adicional 2
            WriteTextField('', EDILineTxt, 17);                                     // 189 - Referencia adicional 2
            WriteDatetimeField(0DT, EDILineTxt, 12);                                // 206 - Fecha/hora ref. adicional 2
            case rSalesShipment."EDI - Shipment cost payment" of                    // 218 - Método pago de costes de transporte
                rSalesShipment."edi - shipment cost payment"::" ":
                    WriteTextField('', EDILineTxt, 3);
                rSalesShipment."edi - shipment cost payment"::DF:
                    WriteTextField('DF', EDILineTxt, 3);
                rSalesShipment."edi - shipment cost payment"::PC:
                    WriteTextField('PC', EDILineTxt, 3);
                rSalesShipment."edi - shipment cost payment"::PP:
                    WriteTextField('PP', EDILineTxt, 3);
                else
                    Error('No se ha contemplado la siguiente opción en la generación de expediciones: ' +
                    rSalesShipment.FieldCaption("EDI - Shipment cost payment") + ' ' +
                    Format(rSalesShipment."EDI - Shipment cost payment"));
            end;
            case rSalesShipment."EDI - Delivery condition" of                       // 221 - Condiciones de entrega o transporte, codificada
                rSalesShipment."edi - delivery condition"::" ":
                    WriteTextField('', EDILineTxt, 3);
                rSalesShipment."edi - delivery condition"::EP:
                    WriteTextField('EP', EDILineTxt, 3);
                rSalesShipment."edi - delivery condition"::PD:
                    WriteTextField('PD', EDILineTxt, 3);
                rSalesShipment."edi - delivery condition"::DDP:
                    WriteTextField('PD', EDILineTxt, 3);
                else
                    Error('No se ha contemplado la siguiente opción en la generación de expediciones: ' +
                    rSalesShipment.FieldCaption("EDI - Delivery condition") + ' ' +
                    Format(rSalesShipment."EDI - Delivery condition"));
            end;
            WriteTextField('', EDILineTxt, 70);                                     // 224 - Condiciones de entrega o transporte, texto libre
            case rSalesShipment."EDI - Shipping method" of                          // 294 - Modo de transporte , codificado
                rSalesShipment."edi - shipping method"::" ":
                    WriteTextField('', EDILineTxt, 3);
                rSalesShipment."edi - shipping method"::"10":
                    WriteTextField('10', EDILineTxt, 3);
                rSalesShipment."edi - shipping method"::"20":
                    WriteTextField('20', EDILineTxt, 3);
                rSalesShipment."edi - shipping method"::"30":
                    WriteTextField('30', EDILineTxt, 3);
                rSalesShipment."edi - shipping method"::"40":
                    WriteTextField('40', EDILineTxt, 3);
                rSalesShipment."edi - shipping method"::"60":
                    WriteTextField('60', EDILineTxt, 3);
                else
                    Error('No se ha contemplado la siguiente opción en la generación de expediciones: ' +
                    rSalesShipment.FieldCaption("EDI - Shipping method") + ' ' +
                    Format(rSalesShipment."EDI - Shipping method"));
            end;
            WriteTextField(rSalesShipment."EDI - Shipping Agent Id.", EDILineTxt, 13);  // 297 - Identificación de transportista
            WriteTextField(rSalesShipment."EDI - Shipping Agent Name", EDILineTxt, 35); // 310 - Nombre del transportista
            WriteTextField(rSalesShipment."EDI - Vehicle plate", EDILineTxt, 17);       // 345 - Matricula del vehículo 
            WriteTextField(rSalesShipment."Ship-to Code", EDILineTxt, 17);              // 362 - Lugar de entrega, codificado
            WriteTextField(rSalesShipment."Ship-to Name" + rSalesShipment."Ship-to Name 2", EDILineTxt, 70); // 379 - Lugar de entrega, texto libre
            // Comprobación de longitud
            if (StrLen(EDILineTxt) <> 448) then
                Error('La línea de tipo SEH1C tiene una longitud distinta a la esperada (esperada 448, real ' + Format(StrLen(EDILineTxt)) + ')');
            OStream.WriteText(EDILineTxt);
            OStream.WriteText; // Salto de línea
        end;
    end;

    local procedure CreateShipmentSEH1DLine(rEDIEDIEntry: Record "EDI - EDI Entry"; var OStream: OutStream)
    var
        EDILineTxt: Text;
        rSalesShipmentHeader: Record "Sales Shipment Header";
        rCustomer: Record Customer;
        rEDIDocumentinterlocutor: Record "EDI - Document interlocutor";
    begin
        begin
            rEDIEDIEntry.TestField("Document Nos.");
            rEDIEDIEntry.TestField("Document type", rEDIEDIEntry."document type"::Shipment);
            rSalesShipmentHeader.Reset;
            rSalesShipmentHeader.Get(rEDIEDIEntry."Document Nos.");
            rCustomer.Reset;
            rCustomer.Get(rSalesShipmentHeader."Sell-to Customer No.");
            rEDIDocumentinterlocutor.Reset;
            rEDIDocumentinterlocutor.SetRange(rEDIDocumentinterlocutor."Document Type", rEDIDocumentinterlocutor."document type"::Shipment);
            rEDIDocumentinterlocutor.SetRange("Document No.", rSalesShipmentHeader."No.");
            if not rEDIDocumentinterlocutor.FindSet then
                Error('El albarán ' + rSalesShipmentHeader."No." + ' no tiene información de las partes especificada');
            repeat // Escribimos la línea
                EDILineTxt := '';
                WriteTextField('SEH1D', EDILineTxt, 6);                                         // 001 - Tipo registro
                WriteTextField(rEDIDocumentinterlocutor."Interlocutor type", EDILineTxt, 3);    // 007 - Calificador del Interlocutor
                WriteTextField(rEDIDocumentinterlocutor."Interlocutor No.", EDILineTxt, 17);    // 010 - Código Interlocutor
                WriteTextField('9', EDILineTxt, 3);                                             // 027 - Agencia responsable de la lista de códigos - Fijo 9 - EAN
                WriteTextField('', EDILineTxt, 35);                                             // 030 - Nombre 1 
                WriteTextField('', EDILineTxt, 35);                                             // 065 - Nombre 2
                WriteTextField('', EDILineTxt, 35);                                             // 100 - Nombre 3
                WriteTextField('', EDILineTxt, 35);                                             // 135 - Nombre 4
                WriteTextField('', EDILineTxt, 35);                                             // 170 - Nombre 5
                WriteTextField(rEDIDocumentinterlocutor."Street and number 1", EDILineTxt, 35); // 205 - Calle y numero 1  
                WriteTextField(rEDIDocumentinterlocutor."Street and number 2", EDILineTxt, 35); // 240 - Calle y numero 2
                WriteTextField(rEDIDocumentinterlocutor."Street and number 3", EDILineTxt, 35); // 275 - Calle y numero 3
                WriteTextField(rEDIDocumentinterlocutor."Street and number 4", EDILineTxt, 35); // 310 - Calle y numero 4
                WriteTextField(rEDIDocumentinterlocutor.City, EDILineTxt, 35);                  // 345 - Población
                WriteTextField(rEDIDocumentinterlocutor.County, EDILineTxt, 9);                 // 380 - Provincia
                WriteTextField(rEDIDocumentinterlocutor."Post Code", EDILineTxt, 9);            // 389 - Código Postal
                WriteTextField(rEDIDocumentinterlocutor."Country/Region Code", EDILineTxt, 3);  // 398 - Código País
                if (rCustomer."SMG Purchase Group" = 'CORTICOR') and                         // 401 - Calificador referencia 1
                    (rSalesShipmentHeader."Cód. Departamento" <> '') and                        // 404 - Referencia 1
                    (rEDIDocumentinterlocutor."Interlocutor type" = 'BY') then begin
                    WriteTextField('API', EDILineTxt, 3);
                    WriteTextField(rSalesShipmentHeader."Cód. Departamento", EDILineTxt, 35);
                end
                else if (rCustomer."SMG Purchase Group" = 'MM') and
                        ((rEDIDocumentinterlocutor."Interlocutor type" = 'BY') or
                            (rEDIDocumentinterlocutor."Interlocutor type" = 'DP') or
                            (rEDIDocumentinterlocutor."Interlocutor type" = 'SU')) then begin
                    WriteTextField('VA', EDILineTxt, 3);
                    WriteTextField(rCustomer."VAT Registration No.", EDILineTxt, 35);
                end
                else begin
                    WriteTextField(rEDIDocumentinterlocutor."Reference type 1", EDILineTxt, 3);
                    WriteTextField(rEDIDocumentinterlocutor."Reference 1", EDILineTxt, 35);
                end;
                WriteTextField(rEDIDocumentinterlocutor."Contact function", EDILineTxt, 3);     // 439 - Función de contacto
                WriteTextField(rEDIDocumentinterlocutor."Dept. or employee ID", EDILineTxt, 17);// 442 - Departamento o identificación del empleado
                WriteTextField(rEDIDocumentinterlocutor."Dept. or employee", EDILineTxt, 35);   // 459 - Departamento o empleado
                if (rSalesShipmentHeader."Cód. Sucursal" <> '') and (rEDIDocumentinterlocutor."Interlocutor type" = 'BY') then begin
                    WriteTextField('ZZZ', EDILineTxt, 3);                                       // 494 - Calificador referencia 2
                    WriteTextField(rSalesShipmentHeader."Cód. Sucursal", EDILineTxt, 17);       // 497 - Referencia 2
                end
                else begin
                    WriteTextField(rEDIDocumentinterlocutor."Reference type 2", EDILineTxt, 3);
                    WriteTextField(rEDIDocumentinterlocutor."Reference 2", EDILineTxt, 17);
                end;
                // Comprobación de longitud
                if (StrLen(EDILineTxt) <> 513) then
                    Error('La línea de tipo SEH1D tiene una longitud distinta a la esperada (esperada 513, real ' + Format(StrLen(EDILineTxt)) + ')');
                OStream.WriteText(EDILineTxt);
                OStream.WriteText; // Salto de línea
            until rEDIDocumentinterlocutor.Next = 0;
        end;
    end;

    local procedure CreateShipmentSEH1PLine(rEDIEDIEntry: Record "EDI - EDI Entry"; var OStream: OutStream)
    var
        EDILineTxt: Text;
        rCustomer: Record Customer;
        rSalesHeader: Record "Sales Header";
        rSalesShipmentHeader: Record "Sales Shipment Header";
        rSalesShipmentLine: Record "Sales Shipment Line";
        rPackaging: Record "Packaging";
        rPackagingLine: Record "Packaging Line";
        rItemUnitMeasure: Record "Item Unit of Measure";
        //InterfaceSGA: Codeunit "Interface SGA";
        cuPackaging: Codeunit "BBT Packaging";
        NoSeries: Codeunit "No. Series";
        NetWeight: Decimal;
        GrossWeight: Decimal;
        Boxes: Decimal;
        ECI_X17: Boolean; //Esta variable identifica si el pedido de ventas es ECI (C00607) y es 'X17 - Pedido para Almacenar 
    begin
        begin
            rEDIEDIEntry.TestField("Document Nos.");
            rEDIEDIEntry.TestField("Document type", rEDIEDIEntry."document type"::Shipment);

            rSalesShipmentHeader.Reset;
            rSalesShipmentHeader.Get(rEDIEDIEntry."Document Nos.");

            rSalesHeader.Reset;
            rSalesHeader.SetRange("Document Type", rSalesHeader."Document Type"::Order);
            rSalesHeader.SetRange("No.", rSalesShipmentHeader."Order No.");
            if not rSalesHeader.FindFirst() then
                Error('No existe el pedido de ventas ' + rSalesShipmentHeader."Order No." + ' relacionado con el albarán');

            ECI_X17 := false;
            If (rSalesHeader."Sell-to Customer No." = 'C00607') and //ECI
                (rSalesHeader."EDI - Additional info" = rSalesHeader."EDI - Additional info"::X17) then // Pedido para Almacenar
                ECI_X17 := true;

            rSalesShipmentLine.Reset;
            rSalesShipmentLine.SetRange("Document No.", rSalesShipmentHeader."No.");
            rSalesShipmentLine.SetRange(Type, rSalesShipmentLine.Type::Item);
            rSalesShipmentLine.SetFilter(Quantity, '<>0');
            if not rSalesShipmentLine.FindFirst then
                Error('El albarán ' + rSalesShipmentHeader."No." + ' no tiene líneas de producto disponibles para enviar por EDI');

            rCustomer.Reset;
            rCustomer.Get(rSalesShipmentHeader."Sell-to Customer No.");
            if rCustomer."VAT PL" then begin //Cliente Venta NIF PL - Sin información de embalaje - Envio desde STOCK PL

                rPackaging.Reset();
                rPackaging.SetRange("Posted Source No.", rSalesShipmentHeader."No.");
                if not rPackaging.FindFirst then begin
                    rPackaging.Init;
                    rPackaging."No." := NoSeries.GetNextNo('UAS-EDI-PL', 0D, true);
                    rPackaging."Creation Date" := TODAY;
                    rPackaging."Created by" := USERID;
                    rPackaging."Location Code" := rSalesShipmentHeader."Location Code";
                    rPackaging."Posted by" := '';
                    rPackaging."Info Code" := rPackaging."Info Code"::"50";
                    rPackaging."Terms and Conditions Code" := rPackaging."Terms and Conditions Code"::"1"; // Pagado por el proveedor
                    rPackaging.Roadmap := rSalesShipmentHeader."No.";
                    rPackaging."Type Code" := rPackaging."Type Code"::"201";
                    rPackaging."Shipping Payment Responsible" := rPackaging."Shipping Payment Responsible"::"3"; // Pagado por el proveedor
                                                                                                                 //rPackaging."Net Weight 1 (AAC)" := 0;   
                    rPackaging."Net Weight Type" := rPackaging."Net Weight Type"::" ";
                    rPackaging."Net Weight UOM" := '';
                    //rPackaging."Gross Weight 1 (AAD)" := 0; 
                    rPackaging."Gross Weight Type" := rPackaging."Gross Weight Type"::" ";
                    rPackaging."Gross Weight UOM" := '';
                    rPackaging."Height Dimension 1 (HT)" := 0;
                    rPackaging."Height Type" := rPackaging."Height Type"::" ";
                    rPackaging."Height UOM" := '';
                    rPackaging."Width Dimension 1 (WD)" := 0;
                    rPackaging."Width Type" := rPackaging."Width Type"::" ";
                    rPackaging."Width UOM" := '';
                    rPackaging."Length Dimension 1 (LN)" := 0;
                    rPackaging."Length Type" := rPackaging."Length Type"::" ";
                    rPackaging."Length UOM" := '';
                    rPackaging."Handling Instructions Code" := rPackaging."Handling Instructions Code"::" ";
                    //rPackaging."Number of Boxes" := 0; 
                    rPackaging."Source Type" := 37;
                    rPackaging."Source No." := rSalesShipmentHeader."Order No.";    //PV
                    rPackaging."Posted Source Type" := 111;
                    rPackaging."Posted Source No." := rSalesShipmentHeader."No.";   //EV
                    rPackaging.Insert(true);

                    Clear(GrossWeight);
                    Clear(NetWeight);
                    Clear(Boxes);
                    rSalesShipmentLine.Reset;
                    rSalesShipmentLine.SetRange("Document No.", rSalesShipmentHeader."No.");
                    rSalesShipmentLine.SetRange(Type, rSalesShipmentLine.Type::Item);
                    rSalesShipmentLine.SetFilter(Quantity, '<>0');
                    if rSalesShipmentLine.FindSet then begin
                        repeat
                            rItemUnitMeasure.Reset;
                            rItemUnitMeasure.SetRange("Item No.", rSalesShipmentLine."No.");
                            rItemUnitMeasure.SetRange(Code, rSalesShipmentLine."Unit of Measure Code");
                            if rItemUnitMeasure.findfirst then begin
                                GrossWeight += rItemUnitMeasure."Gross weight" * rSalesShipmentLine.Quantity;
                                NetWeight += rItemUnitMeasure."Weight" * rSalesShipmentLine.Quantity;
                            end;
                            Boxes += rSalesShipmentLine.Quantity;

                            rPackagingLine.Init;
                            rPackagingLine."No." := rPackaging."No.";
                            rPackagingLine."Line No." := rSalesShipmentLine."Line No.";
                            //rPackagingLine."Source Type" := 0;
                            //rPackagingLine."Source No." := '';
                            //rPackagingLine."Source Line No." := 0;
                            //rPackagingLine."Posted Source Type" := 0;
                            //rPackagingLine."Posted Source No." := '';
                            rPackagingLine."Item No." := rSalesShipmentLine."No.";
                            rPackagingLine."Unit of Measure Code" := rSalesShipmentLine."Unit of Measure Code";
                            rPackagingLine.Quantity := rSalesShipmentLine.Quantity;
                            rPackagingLine."Qty. (Base)" := rSalesShipmentLine."Quantity (Base)";
                            rPackagingLine."Qty. per Unit of Measure" := rSalesShipmentLine."Qty. per Unit of Measure";
                            rPackagingLine.Insert(true);
                        until rSalesShipmentLine.Next = 0;
                    end;

                    rPackaging."Gross Weight 1 (AAD)" := GrossWeight;
                    rPackaging."Net Weight 1 (AAC)" := NetWeight;
                    rPackaging."Number of Boxes" := Boxes;
                    rPackaging.Modify;
                end;
            end
            else begin  // Cliente Venta NIF ES

                rPackaging.Reset;
                rPackaging.SetRange("Posted Source Type", Database::"Sales Shipment Line");
                rPackaging.SetRange("Posted Source No.", rSalesShipmentHeader."No.");
                rPackaging.SetAutocalcFields("Qty. (Base)");
                if not rPackaging.FindSet then
                    //InterfaceSGA.GetPackagingLinesFromSalesShptHeader(rSalesShipmentHeader);
                    cuPackaging.GetPackagingLinesFromSalesShptHeader(rSalesShipmentHeader);
            end;

            rPackaging.Reset;
            rPackaging.SetRange("Posted Source Type", Database::"Sales Shipment Line");
            rPackaging.SetRange("Posted Source No.", rSalesShipmentHeader."No.");
            rPackaging.SetAutocalcFields("Qty. (Base)");
            if not rPackaging.FindSet then
                Error(PackagingMissingErr); // Error:   NO hay información de embalajes.

            CreateShipmentSEH1PLineMandatory(rEDIEDIEntry, OStream); // Info envío y palet (Solo un palet único)
            PackageNo := 1;
            repeat
                PackageNo += 1;
                rPackaging.TestField("Number of Boxes");
                // Escribimos la línea
                EDILineTxt := '';
                WriteTextField('SEH1P', EDILineTxt, 6);                                             // 001 - Tipo registro
                WriteTextField(Format(PackageNo), EDILineTxt, 12);                                  // 007 - Número de jerarquía de embalaje
                WriteTextField('1', EDILineTxt, 12);                                                // 019 - Número de jerarquía padre de embalaje
                WriteIntegerField(1, EDILineTxt, 8);                                                // 031 - Número de paquetes
                case rPackaging."Info Code" of                                                      // 039 - Información sobre el embalaje, codificado
                    rPackaging."info code"::"50":
                        WriteTextField('50', EDILineTxt, 6);
                    rPackaging."info code"::"51":
                        WriteTextField('51', EDILineTxt, 6);
                    rPackaging."info code"::"52":
                        WriteTextField('52', EDILineTxt, 6);
                    else
                        Error('Debe especificar información del embalaje válida');
                end;
                case rPackaging."Terms and Conditions Code" of                                      // 045 - Términos y Condiciones del embalaje, codificado
                    rPackaging."terms and conditions code"::"1":
                        WriteTextField('1', EDILineTxt, 6);
                    rPackaging."terms and conditions code"::"2":
                        WriteTextField('2', EDILineTxt, 6);
                    rPackaging."terms and conditions code"::"3":
                        WriteTextField('3', EDILineTxt, 6);
                    else
                        Error('Debe especificar unos términos y condiciones de embalaje válidos');
                end;
                if (rSalesShipmentHeader."Sell-to Customer No." <> 'C00607') or ECI_X17 then        // 051 - Tipo de embalaje, codificado
                    WriteTextField('CS', EDILineTxt, 6)
                else
                    WriteTextField('CT', EDILineTxt, 6);
                WriteTextField(rPackaging."Type Text", EDILineTxt, 35);                             // 057 - Tipo de embalaje, texto libre
                case rPackaging."Shipping Payment Responsible" of                                   // 092 - Responsabilidad Pago Transporte de Embalaje 
                    rPackaging."shipping payment responsible"::"1":
                        WriteTextField('1', EDILineTxt, 6);
                    rPackaging."shipping payment responsible"::"2":
                        WriteTextField('2', EDILineTxt, 6);
                    rPackaging."shipping payment responsible"::"3":
                        WriteTextField('3', EDILineTxt, 6);
                    else
                        Error('Debe especificar la responsabilidad pago transporte');
                end;
                WriteDecimalVarField(rPackaging."Net Weight 1 (AAC)", EDILineTxt, 18, 3);           // 098 - Peso neto1 (AAC)
                WriteDecimalVarField(rPackaging."Net Weight 2", EDILineTxt, 18, 3);                 // 116 - Peso neto 2
                case rPackaging."Net Weight Type" of                                                // 134 - Código significación de la medida peso neto       
                    rPackaging."net weight type"::"3":
                        WriteTextField('3', EDILineTxt, 6);
                    rPackaging."net weight type"::"4":
                        WriteTextField('4', EDILineTxt, 6);
                    rPackaging."net weight type"::" ":
                        WriteTextField(' ', EDILineTxt, 6);
                    else
                        Error('Debe especificar un cód. Significación para el peso neto válido');
                end;
                WriteTextField(rPackaging."Net Weight UOM", EDILineTxt, 6);                         // 140 - Unidad de medida para el peso neto
                WriteDecimalVarField(rPackaging."Gross Weight 1 (AAD)", EDILineTxt, 18, 3);         // 146 - Peso bruto 1 (AAD)
                WriteDecimalVarField(rPackaging."Gross Weight 2", EDILineTxt, 18, 3);               // 164 - Peso bruto 2
                case rPackaging."Gross Weight Type" of                                              // 182 - Código significación de la medida peso bruto 
                    rPackaging."gross weight type"::"3":
                        WriteTextField('3', EDILineTxt, 6);
                    rPackaging."gross weight type"::"4":
                        WriteTextField('4', EDILineTxt, 6);
                    rPackaging."gross weight type"::" ":
                        WriteTextField(' ', EDILineTxt, 6);
                    else
                        Error('Debe especificar un cód. Significación para el peso bruto válido');
                end;
                WriteTextField(rPackaging."Gross Weight UOM", EDILineTxt, 6);                       // 188 - Unidad de medida para el peso bruto
                WriteDecimalVarField(rPackaging."Height Dimension 1 (HT)", EDILineTxt, 18, 3);      // 194 - Dimensión de altura 1 (HT)
                WriteDecimalVarField(rPackaging."Height Dimension 2", EDILineTxt, 18, 3);           // 212 - Dimensión de altura 2
                case rPackaging."Height Type" of                                                    // 230 - Código significación de la medida altura
                    rPackaging."height type"::"3":
                        WriteTextField('3', EDILineTxt, 6);
                    rPackaging."height type"::"4":
                        WriteTextField('4', EDILineTxt, 6);
                    rPackaging."height type"::" ":
                        WriteTextField(' ', EDILineTxt, 6);
                    else
                        Error('Debe especificar un cód. Significación para la altura válido');
                end;
                WriteTextField(rPackaging."Height UOM", EDILineTxt, 6);                             // 236 - Unidad de medida para la altura
                WriteDecimalVarField(rPackaging."Width Dimension 1 (WD)", EDILineTxt, 18, 3);       // 242 - Dimensión de ancho 1 (WD)
                WriteDecimalVarField(rPackaging."Width Dimension 2", EDILineTxt, 18, 3);            // 260 - Dimensión de ancho 2               
                case rPackaging."Width Type" of                                                     // 278 - Código significación de la medida ancho
                    rPackaging."width type"::"3":
                        WriteTextField('3', EDILineTxt, 6);
                    rPackaging."width type"::"4":
                        WriteTextField('4', EDILineTxt, 6);
                    rPackaging."width type"::" ":
                        WriteTextField(' ', EDILineTxt, 6);
                    else
                        Error('Debe especificar un cód. Significación para el ancho válido');
                end;
                WriteTextField(rPackaging."Width UOM", EDILineTxt, 6);                              // 284 - Unidad de medida para el ancho
                WriteDecimalVarField(rPackaging."Length Dimension 1 (LN)", EDILineTxt, 18, 3);      // 290 - Dimensión de longitud 1 (LN)
                WriteDecimalVarField(rPackaging."Length Dimension 2", EDILineTxt, 18, 3);           // 308 - Dimensión de longitud 2 
                case rPackaging."Length Type" of                                                    // 326 - Código significación de la medida longitud
                    rPackaging."length type"::"3":
                        WriteTextField('3', EDILineTxt, 6);
                    rPackaging."length type"::"4":
                        WriteTextField('4', EDILineTxt, 6);
                    rPackaging."length type"::" ":
                        WriteTextField(' ', EDILineTxt, 6);
                    else
                        Error('Debe especificar un cód. Significación para la longitud válido');
                end;
                WriteTextField(rPackaging."Length UOM", EDILineTxt, 6);                             // 332 - Unidad de medida para la longitud
                WriteDecimalVarField(rPackaging."Temp Dimension 1 (TC)", EDILineTxt, 18, 3);        // 338 - Dimensión de temperatura 1 (TC)        
                WriteDecimalVarField(rPackaging."Temp Dimension 2", EDILineTxt, 18, 3);             // 356 - Dimensión de temperatura 2 
                case rPackaging."Temp Type" of                                                      // 374 - Código significación de la medida temperatura
                    rPackaging."temp type"::"3":
                        WriteTextField('3', EDILineTxt, 6);
                    rPackaging."temp type"::"4":
                        WriteTextField('4', EDILineTxt, 6);
                    rPackaging."temp type"::" ":
                        WriteTextField(' ', EDILineTxt, 6);
                    else
                        Error('Debe especificar un cód. Significación para la temperatura válido');
                end;
                WriteTextField(rPackaging."Temp UOM", EDILineTxt, 6);                               // 380 - Unidad de medida para la temperatura
                WriteDecimalVarField(rPackaging."Qty. (Base)", EDILineTxt, 16, 3);                  // 386 - Cantidad por embalaje
                case rPackaging."Handling Instructions Code" of                                     // 402 - Instrucciones de manejo, codificado
                    rPackaging."handling instructions code"::BIG:
                        WriteTextField('BIG', EDILineTxt, 6);
                    rPackaging."handling instructions code"::CRU:
                        WriteTextField('CRU', EDILineTxt, 6);
                    rPackaging."handling instructions code"::EAT:
                        WriteTextField('EAT', EDILineTxt, 6);
                    rPackaging."handling instructions code"::HWC:
                        WriteTextField('HWC', EDILineTxt, 6);
                    rPackaging."handling instructions code"::PSC:
                        WriteTextField('PSC', EDILineTxt, 6);
                    rPackaging."handling instructions code"::STR:
                        WriteTextField('STR', EDILineTxt, 6);
                    rPackaging."handling instructions code"::UST:
                        WriteTextField('UST', EDILineTxt, 6);
                    else
                        WriteTextField('', EDILineTxt, 6);
                //ERROR('Debe especificar un cód. Instrucciones manejo válido');
                end;
                WriteTextField(rPackaging."Handling Instructions Text", EDILineTxt, 70);            // 408 - Instrucciones de manejo, texto libre
                WriteTextField(rPackaging."Shipment mark 1", EDILineTxt, 35);                       // 478 - Marca de envió 1
                WriteTextField(rPackaging."Shipment mark 2", EDILineTxt, 35);                       // 513 - Marca de envió 2
                WriteTextField(rPackaging."Shipment mark 3", EDILineTxt, 35);                       // 548 - Marca de envió 3
                WriteTextField(rPackaging."Shipment mark 4", EDILineTxt, 35);                       // 583 - Marca de envió 4
                if (rSalesShipmentHeader."Sell-to Customer No." <> 'C00607') or ECI_X17 then        // 618 - Número Serial 1 o número de identificación inferior
                    WriteTextField('', EDILineTxt, 35)
                else
                    WriteTextField(rPackaging."No.", EDILineTxt, 35);
                //EN LOS ENVIOS DEL CLIENTE DIFERENE A 607 SE ENVIA EL SSCC EN LA LINEA 3
                WriteTextField(rPackaging."Upper SN or ID 1", EDILineTxt, 35);                      // 653 - Número Serial 1 o número de identificación superior
                WriteTextField(rPackaging."Lower SN or ID 2", EDILineTxt, 35);                      // 688 - Número Serial 2o número de identificación inferior
                WriteTextField(rPackaging."Upper SN or ID 2", EDILineTxt, 35);                      // 723 - Número Serial 2 o número de identificación superior
                WriteTextField(rPackaging."Lower SN or ID 3", EDILineTxt, 35);                      // 758 - Número Serial 3 o número de identificación inferior
                WriteTextField(rPackaging."Upper SN or ID 3", EDILineTxt, 35);                      // 793 - Número Serial 3 o número de identificación superior

                if (StrLen(EDILineTxt) <> 827) then                                                 // Comprobación de longitud
                    Error('La línea de tipo SEH1P tiene una longitud distinta a la esperada (esperada 827, real ' + Format(StrLen(EDILineTxt)) + ')');
                OStream.WriteText(EDILineTxt);
                OStream.WriteText; // Salto de línea
                LineNo := 0;
                /////////////////////////////////////////////////////////
                //ENVIO VIRTIUAL DE LA CAJA DE CARTON PARA GRAN CONSUMO//
                /////////////////////////////////////////////////////////
                if (rSalesShipmentHeader."Sell-to Customer No." <> 'C00607') or ECI_X17 then begin   // C00607 - EL CORTE INGLES
                    PackageNo += 1;
                    rPackaging.TestField("Number of Boxes");
                    // Escribimos la línea
                    EDILineTxt := '';
                    WriteTextField('SEH1P', EDILineTxt, 6);                                         // 001 - Tipo registro
                    WriteTextField(Format(PackageNo), EDILineTxt, 12);                              // 007 - Número de jerarquía de embalaje
                    WriteTextField(Format(PackageNo - 1), EDILineTxt, 12);                          // 019 - Número de jerarquía padre de embalaje
                    WriteIntegerField(1, EDILineTxt, 8);                                            // 031 - Número de paquetes
                    case rPackaging."Info Code" of                                                  // 039 - Información sobre el embalaje, codificado
                        rPackaging."info code"::"50":
                            WriteTextField('50', EDILineTxt, 6);
                        rPackaging."info code"::"51":
                            WriteTextField('51', EDILineTxt, 6);
                        rPackaging."info code"::"52":
                            WriteTextField('52', EDILineTxt, 6);
                        else
                            Error('Debe especificar información del embalaje válida');
                    end;
                    case rPackaging."Terms and Conditions Code" of                                  // 045 - Términos y Condiciones del embalaje, codificado
                        rPackaging."terms and conditions code"::"1":
                            WriteTextField('1', EDILineTxt, 6);
                        rPackaging."terms and conditions code"::"2":
                            WriteTextField('2', EDILineTxt, 6);
                        rPackaging."terms and conditions code"::"3":
                            WriteTextField('3', EDILineTxt, 6);
                        else
                            Error('Debe especificar unos términos y condiciones de embalaje válidos');
                    end;
                    WriteTextField('CT', EDILineTxt, 6);                                            // 051 - Tipo de embalaje, codificado
                    WriteTextField(rPackaging."Type Text", EDILineTxt, 35);                         // 057 - Tipo de embalaje, texto libre
                    case rPackaging."Shipping Payment Responsible" of                               // 092 - Responsabilidad Pago Transporte de Embalaje 
                        rPackaging."shipping payment responsible"::"1":
                            WriteTextField('1', EDILineTxt, 6);
                        rPackaging."shipping payment responsible"::"2":
                            WriteTextField('2', EDILineTxt, 6);
                        rPackaging."shipping payment responsible"::"3":
                            WriteTextField('3', EDILineTxt, 6);
                        else
                            Error('Debe especificar la responsabilidad pago transporte');
                    end;
                    WriteDecimalVarField(rPackaging."Net Weight 1 (AAC)", EDILineTxt, 18, 3);       // 098 - Peso neto1 (AAC
                    WriteDecimalVarField(rPackaging."Net Weight 2", EDILineTxt, 18, 3);             // 116 - Peso neto 2
                    case rPackaging."Net Weight Type" of                                            // 134 - Código significación de la medida peso neto 
                        rPackaging."net weight type"::"3":
                            WriteTextField('3', EDILineTxt, 6);
                        rPackaging."net weight type"::"4":
                            WriteTextField('4', EDILineTxt, 6);
                        rPackaging."net weight type"::" ":
                            WriteTextField(' ', EDILineTxt, 6);
                        else
                            Error('Debe especificar un cód. Significación para el peso neto válido');
                    end;
                    WriteTextField(rPackaging."Net Weight UOM", EDILineTxt, 6);                     // 140 - Unidad de medida para el peso neto
                    WriteDecimalVarField(rPackaging."Gross Weight 1 (AAD)", EDILineTxt, 18, 3);     // 146 - Peso bruto 1 (AAD)
                    WriteDecimalVarField(rPackaging."Gross Weight 2", EDILineTxt, 18, 3);           // 164 - Peso bruto 2
                    case rPackaging."Gross Weight Type" of                                          // 182 - Código significación de la medida peso brut
                        rPackaging."gross weight type"::"3":
                            WriteTextField('3', EDILineTxt, 6);
                        rPackaging."gross weight type"::"4":
                            WriteTextField('4', EDILineTxt, 6);
                        rPackaging."gross weight type"::" ":
                            WriteTextField(' ', EDILineTxt, 6);
                        else
                            Error('Debe especificar un cód. Significación para el peso bruto válido');
                    end;
                    WriteTextField(rPackaging."Gross Weight UOM", EDILineTxt, 6);                   // 188 - Unidad de medida para el peso bruto
                    WriteDecimalVarField(rPackaging."Height Dimension 1 (HT)", EDILineTxt, 18, 3);  // 194 - Dimensión de altura 1 (HT)
                    WriteDecimalVarField(rPackaging."Height Dimension 2", EDILineTxt, 18, 3);       // 212 - Dimensión de altura 2
                    case rPackaging."Height Type" of                                                // 230 - Código significación de la medida altura
                        rPackaging."height type"::"3":
                            WriteTextField('3', EDILineTxt, 6);
                        rPackaging."height type"::"4":
                            WriteTextField('4', EDILineTxt, 6);
                        rPackaging."height type"::" ":
                            WriteTextField(' ', EDILineTxt, 6);
                        else
                            Error('Debe especificar un cód. Significación para la altura válido');
                    end;
                    WriteTextField(rPackaging."Height UOM", EDILineTxt, 6);                         // 236 - Unidad de medida para la altura
                    WriteDecimalVarField(rPackaging."Width Dimension 1 (WD)", EDILineTxt, 18, 3);   // 242 - Dimensión de ancho 1 (WD)
                    WriteDecimalVarField(rPackaging."Width Dimension 2", EDILineTxt, 18, 3);        // 260 - Dimensión de ancho 2
                    case rPackaging."Width Type" of                                                 // 278 - Código significación de la medida ancho
                        rPackaging."width type"::"3":
                            WriteTextField('3', EDILineTxt, 6);
                        rPackaging."width type"::"4":
                            WriteTextField('4', EDILineTxt, 6);
                        rPackaging."width type"::" ":
                            WriteTextField(' ', EDILineTxt, 6);
                        else
                            Error('Debe especificar un cód. Significación para el ancho válido');
                    end;
                    WriteTextField(rPackaging."Width UOM", EDILineTxt, 6);                          // 284 - Unidad de medida para el ancho
                    WriteDecimalVarField(rPackaging."Length Dimension 1 (LN)", EDILineTxt, 18, 3);  // 290 - Dimensión de longitud 1 (LN)
                    WriteDecimalVarField(rPackaging."Length Dimension 2", EDILineTxt, 18, 3);       // 308 - Dimensión de longitud 2
                    case rPackaging."Length Type" of                                                // 326 - Código significación de la medida longitud
                        rPackaging."length type"::"3":
                            WriteTextField('3', EDILineTxt, 6);
                        rPackaging."length type"::"4":
                            WriteTextField('4', EDILineTxt, 6);
                        rPackaging."length type"::" ":
                            WriteTextField(' ', EDILineTxt, 6);
                        else
                            Error('Debe especificar un cód. Significación para la longitud válido');
                    end;
                    WriteTextField(rPackaging."Length UOM", EDILineTxt, 6);                         // 332 - Unidad de medida para la longitud
                    WriteDecimalVarField(rPackaging."Temp Dimension 1 (TC)", EDILineTxt, 18, 3);    // 338 - Dimensión de temperatura 1 (TC
                    WriteDecimalVarField(rPackaging."Temp Dimension 2", EDILineTxt, 18, 3);         // 356 - Dimensión de temperatura 2
                    case rPackaging."Temp Type" of                                                  // 374 - Código significación de la medida temperatura
                        rPackaging."temp type"::"3":
                            WriteTextField('3', EDILineTxt, 6);
                        rPackaging."temp type"::"4":
                            WriteTextField('4', EDILineTxt, 6);
                        rPackaging."temp type"::" ":
                            WriteTextField(' ', EDILineTxt, 6);
                        else
                            Error('Debe especificar un cód. Significación para la temperatura válido');
                    end;
                    WriteTextField(rPackaging."Temp UOM", EDILineTxt, 6);                           // 380 - Unidad de medida para la temperatura
                    WriteDecimalVarField(rPackaging."Qty. (Base)", EDILineTxt, 16, 3);              // 386 - Cantidad por embalaje
                    case rPackaging."Handling Instructions Code" of                                 // 402 - Instrucciones de manejo, codificado
                        rPackaging."handling instructions code"::BIG:
                            WriteTextField('BIG', EDILineTxt, 6);
                        rPackaging."handling instructions code"::CRU:
                            WriteTextField('CRU', EDILineTxt, 6);
                        rPackaging."handling instructions code"::EAT:
                            WriteTextField('EAT', EDILineTxt, 6);
                        rPackaging."handling instructions code"::HWC:
                            WriteTextField('HWC', EDILineTxt, 6);
                        rPackaging."handling instructions code"::PSC:
                            WriteTextField('PSC', EDILineTxt, 6);
                        rPackaging."handling instructions code"::STR:
                            WriteTextField('STR', EDILineTxt, 6);
                        rPackaging."handling instructions code"::UST:
                            WriteTextField('UST', EDILineTxt, 6);
                        else
                            WriteTextField('', EDILineTxt, 6);
                    end;
                    WriteTextField(rPackaging."Handling Instructions Text", EDILineTxt, 70);        // 408 - Instrucciones de manejo, texto libre
                    WriteTextField(rPackaging."Shipment mark 1", EDILineTxt, 35);                   // 478 - Marca de envió 1
                    WriteTextField(rPackaging."Shipment mark 2", EDILineTxt, 35);                   // 513 - Marca de envió 2
                    WriteTextField(rPackaging."Shipment mark 3", EDILineTxt, 35);                   // 548 - Marca de envió 3
                    WriteTextField(rPackaging."Shipment mark 4", EDILineTxt, 35);                   // 583 - Marca de envió 4
                    WriteTextField(rPackaging."No.", EDILineTxt, 35);                               // 618 - Número Serial 1 o número de identificación inferior
                    WriteTextField(rPackaging."Upper SN or ID 1", EDILineTxt, 35);                  // 653 - Número Serial 1 o número de identificación superior
                    WriteTextField(rPackaging."Lower SN or ID 2", EDILineTxt, 35);                  // 688 - Número Serial 2o número de identificación inferior
                    WriteTextField(rPackaging."Upper SN or ID 2", EDILineTxt, 35);                  // 723 - Número Serial 2 o número de identificación superior
                    WriteTextField(rPackaging."Lower SN or ID 3", EDILineTxt, 35);                  // 758 - Número Serial 3 o número de identificación inferior
                    WriteTextField(rPackaging."Upper SN or ID 3", EDILineTxt, 35);                  // 793 - Número Serial 3 o número de identificación superior
                                                                                                    // Comprobación de longitud
                    if (StrLen(EDILineTxt) <> 827) then
                        Error('La línea de tipo SEH1P tiene una longitud distinta a la esperada (esperada 827, real ' + Format(StrLen(EDILineTxt)) + ')');
                    OStream.WriteText(EDILineTxt);
                    OStream.WriteText; // Salto de línea
                    LineNo := 0;
                end;
                ///////////////////////////////////////////////////////
                //ENVIO VIRTIUAL DE LA CAJA DE CARTON PARA GRAN CONSUMO
                ///////////////////////////////////////////////////////
                CreateShipmentSEH1Line(rEDIEDIEntry, OStream, rPackaging);
            until rPackaging.Next = 0;
        end;
    end;

    local procedure CreateShipmentSEH1PLineMandatory(rEDIEDIEntry: Record "EDI - EDI Entry"; var OStream: OutStream)
    var
        rSalesShipmentHeader: Record "Sales Shipment Header";
        EDILineTxt: Text;
        rPackagingAux: Record "Packaging";
        NSSCC: Integer;
    begin
        begin
            rEDIEDIEntry.TestField("Document Nos.");
            rEDIEDIEntry.TestField("Document type", rEDIEDIEntry."document type"::Shipment);
            // Escribimos la línea de palet
            EDILineTxt := '';
            WriteTextField('SEH1P', EDILineTxt, 6);             // 001 - Tipo registro
            WriteTextField('1', EDILineTxt, 12);                // 007 - Número de jerarquía de embalaje
            WriteTextField('', EDILineTxt, 12);                 // 019 - Número de jerarquía padre de embalaje
            //CALCULO EL NUMERO DE SSCC
            rPackagingAux.Reset;
            rPackagingAux.SetRange("Posted Source No.", rEDIEDIEntry."Document Nos.");
            NSSCC := rPackagingAux.Count;
            if NSSCC <> 0 then                                  // 031 - Número de paquetes
                WriteIntegerField(NSSCC, EDILineTxt, 8)
            else
                WriteIntegerField(1, EDILineTxt, 8);
            //CALCULO EL NUMERO DE SSCC
            WriteTextField('', EDILineTxt, 6);                  // 039 - Información sobre el embalaje, codificado
            WriteTextField('', EDILineTxt, 6);                  // 045 - Términos y Condiciones del embalaje, codificado
            WriteTextField('201', EDILineTxt, 6);               // 051 - Tipo de embalaje, codificado
            WriteTextField('', EDILineTxt, 35);                 // 057 - Tipo de embalaje, texto libre
            WriteTextField('', EDILineTxt, 6);                  // 092 - Responsabilidad Pago Transporte de Embalaje 
            WriteDecimalVarField(0, EDILineTxt, 18, 3);         // 098 - Peso neto1 (AAC)
            WriteDecimalVarField(0, EDILineTxt, 18, 3);         // 116 - Peso neto 2
            WriteTextField(' ', EDILineTxt, 6);                 // 134 - Código significación de la medida peso neto    
            WriteTextField('', EDILineTxt, 6);                  // 140 - Unidad de medida para el peso neto
            WriteDecimalVarField(0, EDILineTxt, 18, 3);         // 146 - Peso bruto 1 (AAD)
            WriteDecimalVarField(0, EDILineTxt, 18, 3);         // 164 - Peso bruto 2
            WriteTextField(' ', EDILineTxt, 6);                 // 182 - Código significación de la medida peso bruto
            WriteTextField('', EDILineTxt, 6);                  // 188 - Unidad de medida para el peso bruto
            WriteDecimalVarField(0, EDILineTxt, 18, 3);          // 194 - Dimensión de altura 1 (HT)
            WriteDecimalVarField(0, EDILineTxt, 18, 3);          // 212 - Dimensión de altura 2
            WriteTextField(' ', EDILineTxt, 6);                 // 230 - Código significación de la medida altura
            WriteTextField('', EDILineTxt, 6);                  // 236 - Unidad de medida para la altura
            WriteDecimalVarField(0, EDILineTxt, 18, 3);          // 242 - Dimensión de ancho 1 (WD)
            WriteDecimalVarField(0, EDILineTxt, 18, 3);          // 260 - Dimensión de ancho 2
            WriteTextField(' ', EDILineTxt, 6);                 // 278 - Código significación de la medida ancho
            WriteTextField('', EDILineTxt, 6);                  // 284 - Unidad de medida para el ancho
            WriteDecimalVarField(0, EDILineTxt, 18, 3);          // 290 - Dimensión de longitud 1 (LN)
            WriteDecimalVarField(0, EDILineTxt, 18, 3);          // 308 - Dimensión de longitud 2
            WriteTextField(' ', EDILineTxt, 6);                 // 326 - Código significación de la medida longitud
            WriteTextField('', EDILineTxt, 6);                  // 332 - Unidad de medida para la longitud
            WriteDecimalVarField(0, EDILineTxt, 18, 3);          // 338 - Dimensión de temperatura 1 (TC)     
            WriteDecimalVarField(0, EDILineTxt, 18, 3);          // 356 - Dimensión de temperatura 2 
            WriteTextField(' ', EDILineTxt, 6);                 // 374 - Código significación de la medida temperatura
            WriteTextField('', EDILineTxt, 6);                  // 380 - Unidad de medida para la temperatura
            WriteDecimalVarField(0, EDILineTxt, 16, 3);          // 386 - Cantidad por embalaje
            WriteTextField('', EDILineTxt, 6);                  // 402 - Instrucciones de manejo, codificado
            WriteTextField('', EDILineTxt, 70);                 // 408 - Instrucciones de manejo, texto libre
            WriteTextField('', EDILineTxt, 35);                 // 478 - Marca de envió 1
            WriteTextField('', EDILineTxt, 35);                 // 513 - Marca de envió 2
            WriteTextField('', EDILineTxt, 35);                 // 548 - Marca de envió 3
            WriteTextField('', EDILineTxt, 35);                 // 583 - Marca de envió 4
            WriteTextField('', EDILineTxt, 35);                 // 618 - Número Serial 1 o número de identificación inferior
            WriteTextField('', EDILineTxt, 35);                 // 653 - Número Serial 1 o número de identificación superior
            WriteTextField('', EDILineTxt, 35);                 // 688 - Número Serial 2o número de identificación inferior
            WriteTextField('', EDILineTxt, 35);                 // 723 - Número Serial 2 o número de identificación superior
            WriteTextField('', EDILineTxt, 35);                 // 758 - Número Serial 3 o número de identificación inferior
            WriteTextField('', EDILineTxt, 35);                 // 793 - Número Serial 3 o número de identificación superior
            // Comprobación de longitud
            if (StrLen(EDILineTxt) <> 827) then
                Error('La línea de tipo SEH1P tiene una longitud distinta a la esperada (esperada 827, real ' + Format(StrLen(EDILineTxt)) + ')');
            OStream.WriteText(EDILineTxt);
            OStream.WriteText; // Salto de línea
        end;
        //LINEA ESPECIAL GRAN CONSUMO ECI
        if (rSalesShipmentHeader."Sell-to Customer No." = '00000') then begin
            // Escribimos la línea de envío
            PackageNo += 1;
            EDILineTxt := '';
            WriteTextField('SEH1P', EDILineTxt, 6);             // 001 - Tipo registro
            WriteTextField(Format(PackageNo), EDILineTxt, 12);  // 007 - Número de jerarquía de embalaje
            WriteTextField('', EDILineTxt, 12);                 // 019 - Número de jerarquía padre de embalaje
            WriteIntegerField(1, EDILineTxt, 8);                // 031 - Número de paquetes
            WriteTextField('', EDILineTxt, 6);                  // 039 - Información sobre el embalaje, codificado
            WriteTextField('', EDILineTxt, 6);                  // 045 - Términos y Condiciones del embalaje, codificado
            WriteTextField('201', EDILineTxt, 6);               // 051 - Tipo de embalaje, codificado
            WriteTextField('', EDILineTxt, 35);                 // 057 - Tipo de embalaje, texto libre
            WriteTextField('', EDILineTxt, 6);                  // 092 - Responsabilidad Pago Transporte de Embalaje 
            WriteDecimalVarField(0, EDILineTxt, 18, 3);         // 098 - Peso neto1 (AAC)
            WriteDecimalVarField(0, EDILineTxt, 18, 3);         // 116 - Peso neto 2
            WriteTextField(' ', EDILineTxt, 6);                 // 134 - Código significación de la medida peso neto    
            WriteTextField('', EDILineTxt, 6);                  // 140 - Unidad de medida para el peso neto
            WriteDecimalVarField(0, EDILineTxt, 18, 3);         // 146 - Peso bruto 1 (AAD)
            WriteDecimalVarField(0, EDILineTxt, 18, 3);         // 164 - Peso bruto 2
            WriteTextField(' ', EDILineTxt, 6);                 // 182 - Código significación de la medida peso bruto
            WriteTextField('', EDILineTxt, 6);                  // 188 - Unidad de medida para el peso bruto
            WriteDecimalVarField(0, EDILineTxt, 18, 3);          // 194 - Dimensión de altura 1 (HT)
            WriteDecimalVarField(0, EDILineTxt, 18, 3);          // 212 - Dimensión de altura 2
            WriteTextField(' ', EDILineTxt, 6);                 // 230 - Código significación de la medida altura
            WriteTextField('', EDILineTxt, 6);                  // 236 - Unidad de medida para la altura
            WriteDecimalVarField(0, EDILineTxt, 18, 3);          // 242 - Dimensión de ancho 1 (WD)
            WriteDecimalVarField(0, EDILineTxt, 18, 3);          // 260 - Dimensión de ancho 2
            WriteTextField(' ', EDILineTxt, 6);                 // 278 - Código significación de la medida ancho
            WriteTextField('', EDILineTxt, 6);                  // 284 - Unidad de medida para el ancho
            WriteDecimalVarField(0, EDILineTxt, 18, 3);          // 290 - Dimensión de longitud 1 (LN)
            WriteDecimalVarField(0, EDILineTxt, 18, 3);          // 308 - Dimensión de longitud 2
            WriteTextField(' ', EDILineTxt, 6);                 // 326 - Código significación de la medida longitud
            WriteTextField('', EDILineTxt, 6);                  // 332 - Unidad de medida para la longitud
            WriteDecimalVarField(0, EDILineTxt, 18, 3);          // 338 - Dimensión de temperatura 1 (TC)     
            WriteDecimalVarField(0, EDILineTxt, 18, 3);          // 356 - Dimensión de temperatura 2 
            WriteTextField(' ', EDILineTxt, 6);                 // 374 - Código significación de la medida temperatura
            WriteTextField('', EDILineTxt, 6);                  // 380 - Unidad de medida para la temperatura
            WriteDecimalVarField(0, EDILineTxt, 16, 3);          // 386 - Cantidad por embalaje
            WriteTextField('', EDILineTxt, 6);                  // 402 - Instrucciones de manejo, codificado
            WriteTextField('', EDILineTxt, 70);                 // 408 - Instrucciones de manejo, texto libre
            WriteTextField('', EDILineTxt, 35);                 // 478 - Marca de envió 1
            WriteTextField('', EDILineTxt, 35);                 // 513 - Marca de envió 2
            WriteTextField('', EDILineTxt, 35);                 // 548 - Marca de envió 3
            WriteTextField('', EDILineTxt, 35);                 // 583 - Marca de envió 4
            WriteTextField('', EDILineTxt, 35);                 // 618 - Número Serial 1 o número de identificación inferior
            WriteTextField('', EDILineTxt, 35);                 // 653 - Número Serial 1 o número de identificación superior
            WriteTextField('', EDILineTxt, 35);                 // 688 - Número Serial 2o número de identificación inferior
            WriteTextField('', EDILineTxt, 35);                 // 723 - Número Serial 2 o número de identificación superior
            WriteTextField('', EDILineTxt, 35);                 // 758 - Número Serial 3 o número de identificación inferior
            WriteTextField('', EDILineTxt, 35);                 // 793 - Número Serial 3 o número de identificación superior




            if (StrLen(EDILineTxt) <> 827) then
                Error('La línea de tipo SEH1P tiene una longitud distinta a la esperada (esperada 827, real ' + Format(StrLen(EDILineTxt)) + ')');
            OStream.WriteText(EDILineTxt);
            OStream.WriteText; // Salto de línea
        end;
    end;
    /*
        local procedure CreateShipmentSEH1PLineMandatory2(rEDIEDIEntry: Record "EDI - EDI Entry"; var OStream: OutStream)
        var
            EDILineTxt: Text;
            rSalesShipmentHeader: Record "Sales Shipment Header";
            rPackagingAux: Record "Packaging";
            NSSCC: Integer;
        begin
            begin
                rEDIEDIEntry.TestField("Document Nos.");
                rEDIEDIEntry.TestField("Document type", rEDIEDIEntry."document type"::Shipment);
                // Escribimos la línea de palet
                EDILineTxt := '';
                WriteTextField('SEH1P', EDILineTxt, 6);
                //WriteTextField('2',EDILineTxt,12);
                WriteTextField('1', EDILineTxt, 12);
                //WriteTextField('1',EDILineTxt,12);
                WriteTextField('', EDILineTxt, 12);
                //CALCULO EL NUMERO DE SSCC
                rPackagingAux.Reset;
                //PackagingAux.SETRANGE("Posted Source Type",DATABASE::"Sales Shipment Line");
                rPackagingAux.SetRange("Posted Source No.", rEDIEDIEntry."Document Nos.");
                NSSCC := rPackagingAux.Count;
                if NSSCC <> 0 then
                    WriteIntegerField(NSSCC, EDILineTxt, 8)
                else
                    WriteIntegerField(1, EDILineTxt, 8);
                //CALCULO EL NUMERO DE SSCC
                WriteTextField('', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 6);
                WriteTextField('CS', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 6);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteTextField(' ', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 6);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteTextField(' ', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 6);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteTextField(' ', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 6);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteTextField(' ', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 6);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteTextField(' ', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 6);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteTextField(' ', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 6);
                WriteDecimalField(0, EDILineTxt, 16);
                WriteTextField('', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 70);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                // Comprobación de longitud
                if (StrLen(EDILineTxt) <> 827) then
                    Error('La línea de tipo SEH1P tiene una longitud distinta a la esperada (esperada 827, real ' + Format(StrLen(EDILineTxt)) + ')');
                OStream.WriteText(EDILineTxt);
                OStream.WriteText; // Salto de línea
            end;
            //LINEA ESPECIAL GRAN CONSUMO ECI
            if (rSalesShipmentHeader."Sell-to Customer No." = '00000') then begin
                // Escribimos la línea de envío
                PackageNo += 1;
                EDILineTxt := '';
                WriteTextField('SEH1P', EDILineTxt, 6);
                WriteTextField(Format(PackageNo), EDILineTxt, 12);
                WriteTextField('', EDILineTxt, 32);
                WriteTextField('BE', EDILineTxt, 2);
                WriteTextField('', EDILineTxt, 45);
                WriteTextField('0', EDILineTxt, 32);
                WriteTextField('', EDILineTxt, 16);
                WriteTextField('0', EDILineTxt, 32);
                WriteTextField('', EDILineTxt, 16);
                WriteTextField('0', EDILineTxt, 32);
                WriteTextField('', EDILineTxt, 16);
                WriteTextField('0', EDILineTxt, 32);
                WriteTextField('', EDILineTxt, 16);
                WriteTextField('0', EDILineTxt, 32);
                WriteTextField('', EDILineTxt, 16);
                WriteTextField('0', EDILineTxt, 32);
                WriteTextField('', EDILineTxt, 16);
                WriteTextField('0', EDILineTxt, 16);
                WriteTextField('', EDILineTxt, 425);
                if (StrLen(EDILineTxt) <> 827) then
                    Error('La línea de tipo SEH1P tiene una longitud distinta a la esperada (esperada 827, real ' + Format(StrLen(EDILineTxt)) + ')');
                OStream.WriteText(EDILineTxt);
                OStream.WriteText; // Salto de línea
            end;
        end;
    */
    /*
        local procedure CreateShipmentSEH1PLineMandatory_BACKUP(rEDIEDIEntry: Record "EDI - EDI Entry"; var OStream: OutStream)
        var
            EDILineTxt: Text;
        begin
            begin
                rEDIEDIEntry.TestField("Document Nos.");
                rEDIEDIEntry.TestField("Document type", rEDIEDIEntry."document type"::Shipment);
                // Escribimos la línea de envío
                EDILineTxt := '';
                WriteTextField('SEH1P', EDILineTxt, 6);
                WriteTextField('1', EDILineTxt, 12);
                WriteTextField('', EDILineTxt, 12);
                WriteIntegerField(1, EDILineTxt, 8);
                WriteTextField('', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 6);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteTextField(' ', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 6);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteTextField(' ', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 6);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteTextField(' ', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 6);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteTextField(' ', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 6);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteTextField(' ', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 6);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteTextField(' ', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 6);
                WriteDecimalField(0, EDILineTxt, 16);
                WriteTextField('', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 70);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                // Comprobación de longitud
                if (StrLen(EDILineTxt) <> 827) then
                    Error('La línea de tipo SEH1P tiene una longitud distinta a la esperada (esperada 827, real ' + Format(StrLen(EDILineTxt)) + ')');
                OStream.WriteText(EDILineTxt);
                OStream.WriteText; // Salto de línea
                // Escribimos la línea de palet
                EDILineTxt := '';
                WriteTextField('SEH1P', EDILineTxt, 6);
                WriteTextField('2', EDILineTxt, 12);
                WriteTextField('1', EDILineTxt, 12);
                WriteIntegerField(1, EDILineTxt, 8);
                WriteTextField('', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 6);
                WriteTextField('201', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 6);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteTextField(' ', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 6);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteTextField(' ', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 6);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteTextField(' ', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 6);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteTextField(' ', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 6);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteTextField(' ', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 6);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteDecimalField(0, EDILineTxt, 18);
                WriteTextField(' ', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 6);
                WriteDecimalField(0, EDILineTxt, 16);
                WriteTextField('', EDILineTxt, 6);
                WriteTextField('', EDILineTxt, 70);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                WriteTextField('', EDILineTxt, 35);
                // Comprobación de longitud
                if (StrLen(EDILineTxt) <> 827) then
                    Error('La línea de tipo SEH1P tiene una longitud distinta a la esperada (esperada 827, real ' + Format(StrLen(EDILineTxt)) + ')');
                OStream.WriteText(EDILineTxt);
                OStream.WriteText; // Salto de línea
            end;
        end;
    */
    local procedure CreateShipmentSEH1Line(rEDIEDIEntry: Record "EDI - EDI Entry"; var OStream: OutStream; rPackaging: Record "Packaging")
    var
        EDILineTxt: Text;
        rSalesShipmentHeader: Record "Sales Shipment Header";
        rCustomer: Record Customer;
        rSalesShipmentLine: Record "Sales Shipment Line";
        rItemIdentifier: Record "Item Identifier";
        rPackagingLine: Record "Packaging Line";
        rItem: Record Item;
        rItemUnitofMeasure: Record "Item Unit of Measure";
    begin
        begin
            rEDIEDIEntry.TestField("Document Nos.");
            rEDIEDIEntry.TestField("Document type", rEDIEDIEntry."document type"::Shipment);
            rSalesShipmentHeader.Reset;
            rSalesShipmentHeader.Get(rEDIEDIEntry."Document Nos.");
            rCustomer.Reset;
            rCustomer.Get(rSalesShipmentHeader."Sell-to Customer No.");
            rPackaging.TestField("No.");
            rPackagingLine.Reset;
            rPackagingLine.SetRange("No.", rPackaging."No.");
            rPackagingLine.SetFilter("Item No.", '<>%1', '');
            if rPackagingLine.FindSet then
                repeat
                    rItem.Reset;
                    rItem.get(rPackagingLine."Item No.");
                    rSalesShipmentLine.Reset;
                    rSalesShipmentLine.SetRange("Document No.", rSalesShipmentHeader."No.");
                    rSalesShipmentLine.SetRange(Type, rSalesShipmentLine.Type::Item);
                    rSalesShipmentLine.SetFilter(Quantity, '<>0');
                    rSalesShipmentLine.SetRange("No.", rPackagingLine."Item No.");
                    if not rSalesShipmentLine.FindSet then
                        Error('El albarán ' + rSalesShipmentHeader."No." + ' no tiene líneas de producto disponibles para enviar por EDI');
                    //REPEAT
                    LineNo := LineNo + 1;
                    // Escribimos la línea
                    EDILineTxt := '';
                    WriteTextField('SEH1L', EDILineTxt, 6);                                         // 001 - Tipo de registro
                    WriteIntegerField(LineNo, EDILineTxt, 6);                                       // 007 - Número de línea del articulo   
                    rItemIdentifier.Reset;
                    rItemIdentifier.SetRange("Item No.", rSalesShipmentLine."No.");
                    rItemIdentifier.SetRange("EAN EDI", true);
                    rItemIdentifier.SetRange("Unit of Measure Code", rItem."Base Unit of Measure"); //UNID
                    if rItemIdentifier.FindSet then
                        WriteTextField(rItemIdentifier.Code, EDILineTxt, 15)                        // 013 - Código EAN del articulo
                    else
                        Error('No se encuentra el DUN13 del producto %1', rSalesShipmentLine."No.");
                    WriteTextField(rSalesShipmentLine.Description + rSalesShipmentLine."Description 2", EDILineTxt, 70); // 028 - Descripción del articulo
                    // BBT 17/06/2025. Por indicaciones de SERES se sustituye:
                    // CU --> Z
                    // DU --> O
                    case rItemIdentifier."Item ID Type" of                                          // 098 - Tipo de identificación del articulo (CU/DU)
                        rItemIdentifier."item id type"::CU:
                            //WriteTextField('CU', EDILineTxt, 7);
                            WriteTextField('Z', EDILineTxt, 7);
                        rItemIdentifier."item id type"::DU:
                            //WriteTextField('DU', EDILineTxt, 7);
                            WriteTextField('O', EDILineTxt, 7);
                        //>> BBT 06/03/2025
                        //rItemIdentifier."item id type"::" ":
                        //    WriteTextField(' ', EDILineTxt, 7);
                        //else
                        //    Error('Debe especificar un tipo de identificación de producto válido');
                        else
                            //WriteTextField('CU', EDILineTxt, 7);
                            WriteTextField('Z', EDILineTxt, 7);
                    //<<    
                    end;
                    WriteTextField(rSalesShipmentLine."No.", EDILineTxt, 15);                       // 105 - Número de articulo del proveedor (SA)
                    WriteTextField('', EDILineTxt, 15);                                             // 120 - Cód. variable promocional (PV)
                    rItemIdentifier.Reset;
                    rItemIdentifier.SetRange("Item No.", rSalesShipmentLine."No.");
                    rItemIdentifier.SetRange("Unit of Measure Code", 'CAJA');
                    if rItemIdentifier.FindFirst then
                        WriteTextField(rItemIdentifier.Code, EDILineTxt, 15)                        // 135 - Código DUN-14 (ADU)
                    else
                        //>> BBT 25/08/2025. No tiene sentido que se acepte el pedido sin el EAN14 y despues demos error con el albarán.
                        // Error('No se encuentra el DUN14 del producto %1', rSalesShipmentLine."No.");
                        WriteTextField('', EDILineTxt, 15);
                    //<<
                    WriteTextField('', EDILineTxt, 15);                                             // 150 - Código ACU (ACU)
                    WriteTextField('', EDILineTxt, 35);                                             // 165 - Número de lote (NB)
                    //BUSCO EL PRODUCTO PROVEEDOR EN UNA TABLA NUEVA
                    //        Codclieprod.RESET;
                    //        Codclieprod.SETRANGE("Item No.",SalesShipmentLine."No.");
                    //        Codclieprod.SETRANGE(Codclieprod."Cross-Reference Type No.",Customer."No.");
                    //        IF Codclieprod.FINDFIRST THEN
                    //          WriteTextField(Codclieprod."Cross-Reference No.",EDILineTxt,15)
                    //        ELSE
                    //          ERROR('Falta del codigo producto %1 del cliente %2',SalesShipmentLine."No.",Customer."No.");
                    // Probar així de moment, veure si dona error
                    WriteTextField('', EDILineTxt, 15);                                             // 200 - Número de articulo del comprador (IN)
                    WriteDecimalVarField(rPackagingLine.Quantity, EDILineTxt, 16, 3);               // 215 - Cantidad enviada
                    WriteTextField('PCE', EDILineTxt, 6);                                           // 231 - Unidad de medida cantidad enviada
                    rItemUnitofMeasure.Reset;
                    rItemUnitofMeasure.SetRange("Item No.", rSalesShipmentLine."No.");
                    rItemUnitofMeasure.SetRange(Code, 'CAJA');
                    if rItemUnitofMeasure.FindFirst then                                            // 237 - Unidades de consumo en unidad de expedición
                        WriteDecimalVarField(rItemUnitofMeasure."Qty. per Unit of Measure", EDILineTxt, 16, 3)
                    else
                        WriteDecimalVarField(1, EDILineTxt, 16, 3);
                    // BBT 01/10/2025 Añadir la fecha de caducidad ( ¿de garantia? )
                    //>>    
                    WriteDatetimeField(0DT, EDILineTxt, 12);                                        // 253 - Fecha de caducidad 
                    //WriteDatetimeField(CreateDateTime(CalcDate('<+3Y>', rSalesShipmentHeader."Posting Date"), 000000T), EDILineTxt, 12);
                    //<<
                    WriteTextField('', EDILineTxt, 6);                                              // 265 - Calificador  referencia 1
                    WriteTextField('', EDILineTxt, 17);                                             // 271 - Número referencia 1              
                    WriteDatetimeField(0DT, EDILineTxt, 12);                                        // 288 - Fecha/hora referencia 1
                    WriteTextField('', EDILineTxt, 6);                                              // 300 - Calificador referencia 2
                    WriteTextField('', EDILineTxt, 17);                                             // 306 - Número referencia 2
                    WriteDatetimeField(0DT, EDILineTxt, 12);                                        // 323 - Fecha/hora referencia 2
                    WriteTextField('', EDILineTxt, 6);                                              // 335 - Calificador referencia 3
                    WriteTextField('', EDILineTxt, 17);                                             // 341 - Número referencia 3
                    WriteDatetimeField(0DT, EDILineTxt, 12);                                        // 358 - Fecha/hora referencia 3
                    WriteTextField('', EDILineTxt, 16);                                             // 370 - Unidades en agrupación superior
                    WriteTextField('', EDILineTxt, 15);                                             // 386 - Código EAN adicional
                    WriteTextField('', EDILineTxt, 16);                                             // 401 - Cantidad sin cargo
                    WriteTextField('', EDILineTxt, 3);                                              // 417 - Calificador cantidad adicional
                    WriteDecimalVarField(0, EDILineTxt, 16, 3);                                     // 420 - Cantidad adicional
                    WriteTextField('', EDILineTxt, 6);                                              // 436 - Unidad medida cantidad adicional
                    WriteTextField('', EDILineTxt, 35);                                             // 442 - Número serie artículo
                    WriteTextField('', EDILineTxt, 35);                                             // 477 - Número artículo fabricante
                    WriteIntegerField(0, EDILineTxt, 6);                                            // 512 - Número línea referencia 1
                    WriteIntegerField(0, EDILineTxt, 6);                                            // 518 - Número línea referencia 2
                    WriteIntegerField(0, EDILineTxt, 6);                                            // 524 - Número línea referencia 3
                    WriteDecimalVarField(0, EDILineTxt, 16, 3);                                     // 530 - Diferencia cantidad pedida
                    WriteTextField('', EDILineTxt, 3);                                              // 546 - Código discrepancia
                    WriteDecimalVarField(0, EDILineTxt, 18, 3);                                      // 549 - Peso total neto de la línea (AAI/AAF)
                    WriteDecimalVarField(0, EDILineTxt, 18, 3);                                      // 567 - Peso total bruto de la línea (AAI/AAB)
                    //WriteDecimalField(SalesShipmentLine."Net Weight"/SalesShipmentLine.Quantity*PackagingLine.Quantity,EDILineTxt,18);    // 549 - Peso total neto de la línea (AAI/AAF)
                    //WriteDecimalField(SalesShipmentLine."Gross Weight"/SalesShipmentLine.Quantity*PackagingLine.Quantity,EDILineTxt,18);  // 567 - Peso total bruto de la línea (AAI/AAB)
                    WriteTextField('KG', EDILineTxt, 3);                                            // 585 - Unidad medida peso
                    WriteDecimalVarField(0, EDILineTxt, 18, 3);                                     // 588 - Dimensión temperatura 1
                    WriteDecimalVarField(0, EDILineTxt, 18, 3);                                     // 606 - Dimensión temperatura 2
                    WriteTextField('', EDILineTxt, 3);                                              // 624 - Unidad medida temperatura
                    WriteTextField('', EDILineTxt, 70);                                             // 627 - Denominación comercial - Obligatorio para pesca
                    WriteTextField('', EDILineTxt, 70);                                             // 697 - Denominación científica - Obligatorio para pesca
                    WriteTextField('', EDILineTxt, 17);                                             // 767 - País captura/producción/cosecha
                    WriteTextField('', EDILineTxt, 17);                                             // 784 - Zona FAO de captura
                    WriteTextField('', EDILineTxt, 17);                                             // 801 - Método de producción
                    WriteTextField('', EDILineTxt, 17);                                             // 818 - Código de presentación
                    WriteTextField('', EDILineTxt, 35);                                             // 835 - Código FAO de la especie
                    WriteTextField('', EDILineTxt, 16);                                             // 870 - Fecha o período de captura
                    WriteTextField('', EDILineTxt, 12);                                             // 886 - Fecha de producción
                    WriteTextField('', EDILineTxt, 17);                                             // 898 - Arte de pesca
                    WriteTextField('', EDILineTxt, 17);                                             // 915 - Información de congelado
                    WriteTextField('', EDILineTxt, 12);                                             // 932 - Fecha de congelación
                    WriteTextField('', EDILineTxt, 70);                                             // 944 - Información de congelado
                    WriteTextField('', EDILineTxt, 19);                                             // 1014 - Fecha de congelación
                    // Comprobación de longitud
                    if (StrLen(EDILineTxt) <> 1032) then
                        Error('La línea de tipo SEH1L tiene una longitud distinta a la esperada (esperada 1032, real ' + Format(StrLen(EDILineTxt)) + ')');
                    OStream.WriteText(EDILineTxt);
                    OStream.WriteText; // Salto de línea
                //UNTIL SalesShipmentLine.NEXT=0;
                until rPackagingLine.Next = 0;
        end;
    end;

    local procedure AddShipmentParts(rSalesShipmentHeader: Record "Sales Shipment Header"; ForceUpdate: Boolean)
    begin
        AddShipmentPartMR(rSalesShipmentHeader, ForceUpdate);
        AddShipmentPartMS(rSalesShipmentHeader, ForceUpdate);
        AddShipmentPartSU(rSalesShipmentHeader, ForceUpdate);
        AddShipmentPartDP(rSalesShipmentHeader, ForceUpdate);
        AddShipmentPartUC(rSalesShipmentHeader, ForceUpdate);
        AddShipmentPartIV(rSalesShipmentHeader, ForceUpdate);
    end;


    procedure AddShipmentPartMR(rSalesShipmentHeader: Record "Sales Shipment Header"; ForceUpdate: Boolean)
    var
        rEDIDocumentinterlocutor: Record "EDI - Document interlocutor";
        rCompanyInformation: Record "Company Information";
        rCust: Record Customer;
    begin
        // MR - Receptor del mensaje
        rCompanyInformation.Reset;
        rCompanyInformation.Get;
        rCompanyInformation.TestField("EDI ID");
        rCompanyInformation.TestField(Name);
        rCompanyInformation.TestField(Address);
        rCompanyInformation.TestField("VAT Registration No.");
        rEDIDocumentinterlocutor.Reset;
        rEDIDocumentinterlocutor.SetRange("Document Type", rEDIDocumentinterlocutor."document type"::Shipment);
        rEDIDocumentinterlocutor.SetRange("Document No.", rSalesShipmentHeader."No.");
        rEDIDocumentinterlocutor.SetRange("Interlocutor type", 'MR');
        if rEDIDocumentinterlocutor.FindSet then begin
            if ForceUpdate then
                rEDIDocumentinterlocutor.Delete
            else
                exit;
        end;
        rCust.Reset;
        if rSalesShipmentHeader."Bill-to Customer No." <> '' then
            rCust.Get(rSalesShipmentHeader."Bill-to Customer No.")
        else
            rCust.Get(rSalesShipmentHeader."Sell-to Customer No.");
        rCust.TestField("EDI ID");
        //SI EL CLIENTE TIENE INVOICE EDI LE PONGO ESTE VALOR
        if rCust."Invoice EDI" <> '' then
            EdiCustCode := rCust."Invoice EDI"
        else
            EdiCustCode := rCust."EDI ID";
        rEDIDocumentinterlocutor.Init;
        rEDIDocumentinterlocutor.Validate("Document Type", rEDIDocumentinterlocutor."document type"::Shipment);
        rEDIDocumentinterlocutor.Validate("Document No.", rSalesShipmentHeader."No.");
        rEDIDocumentinterlocutor.Validate("Interlocutor type", 'MR');
        rEDIDocumentinterlocutor.Validate("Interlocutor No.", EdiCustCode);

        if rSalesShipmentHeader."Bill-to Name 2" <> '' then begin
            rEDIDocumentinterlocutor.Validate("Name 1", CopyStr(rSalesShipmentHeader."Bill-to Name", 1, 35));
            rEDIDocumentinterlocutor.Validate("Name 2", CopyStr(rSalesShipmentHeader."Bill-to Name 2", 1, 35));
        end
        else begin
            rEDIDocumentinterlocutor.Validate("Name 1", CopyStr(rSalesShipmentHeader."Bill-to Name" + rSalesShipmentHeader."Bill-to Name 2", 1, 35));
            rEDIDocumentinterlocutor.Validate("Name 2", CopyStr(rSalesShipmentHeader."Bill-to Name" + rSalesShipmentHeader."Bill-to Name 2", 36, 35));
            rEDIDocumentinterlocutor.Validate("Name 3", CopyStr(rSalesShipmentHeader."Bill-to Name" + rSalesShipmentHeader."Bill-to Name 2", 71, 35));
        end;

        rEDIDocumentinterlocutor.Validate("Street and number 1", CopyStr(rSalesShipmentHeader."Bill-to Address" + rSalesShipmentHeader."Bill-to Address 2", 1, 35));
        rEDIDocumentinterlocutor.Validate("Street and number 2", CopyStr(rSalesShipmentHeader."Bill-to Address" + rSalesShipmentHeader."Bill-to Address 2", 36, 35));
        rEDIDocumentinterlocutor.Validate("Street and number 3", CopyStr(rSalesShipmentHeader."Bill-to Address" + rSalesShipmentHeader."Bill-to Address 2", 71, 35));

        rEDIDocumentinterlocutor.Validate(City, UpperCase(CopyStr(rSalesShipmentHeader."Bill-to City", 1, 30)));
        rEDIDocumentinterlocutor.Validate(County, CopyStr(rSalesShipmentHeader."Bill-to County", 1, 9));
        if rCust."SMG Purchase Group" = 'AMAZON' then
            rEDIDocumentinterlocutor.County := '';

        rEDIDocumentinterlocutor.Validate("Post Code", CopyStr(rSalesShipmentHeader."Bill-to Post Code", 1, 9));
        rEDIDocumentinterlocutor.Validate("Country/Region Code", rSalesShipmentHeader."Bill-to Country/Region Code");
        rEDIDocumentinterlocutor.Validate("VAT Registration No.", rSalesShipmentHeader."VAT Registration No.");
        rEDIDocumentinterlocutor.Insert(true);
    end;

    procedure AddShipmentPartSU(rSalesShipmentHeader: Record "Sales Shipment Header"; ForceUpdate: Boolean)
    var
        rEDIDocumentinterlocutor: Record "EDI - Document interlocutor";
        rCompanyInformation: Record "Company Information";
        rGeneralLedgerSetup: Record "General Ledger Setup";
        rCustomer: Record Customer;
        rBAnkAccount: Record "Bank Account";
    begin
        // SU - Proveedor
        rCompanyInformation.Reset;
        rCompanyInformation.Get;
        rCompanyInformation.TestField("EDI ID");
        rCompanyInformation.TestField("EDI ID PL"); // EDI ID de venta con CIF Polonia
        rCompanyInformation.TestField(Name);
        rCompanyInformation.TestField(Address);
        rCompanyInformation.TestField("VAT Registration No.");
        rGeneralLedgerSetup.Reset;
        rGeneralLedgerSetup.Get;
        rGeneralLedgerSetup.TestField("PolishVAT Registration No.");//CIF BBTrends Polonia
        rCustomer.Reset;
        rCustomer.get(rSalesShipmentHeader."Sell-to Customer No.");
        rEDIDocumentinterlocutor.Reset;
        rEDIDocumentinterlocutor.SetRange("Document Type", rEDIDocumentinterlocutor."document type"::Shipment);
        rEDIDocumentinterlocutor.SetRange("Document No.", rSalesShipmentHeader."No.");
        rEDIDocumentinterlocutor.SetRange("Interlocutor type", 'SU');
        if rEDIDocumentinterlocutor.FindSet then begin
            if ForceUpdate then
                rEDIDocumentinterlocutor.Delete
            else
                exit;
        end;
        rEDIDocumentinterlocutor.Init;
        rEDIDocumentinterlocutor.Validate("Document Type", rEDIDocumentinterlocutor."document type"::Shipment);
        rEDIDocumentinterlocutor.Validate("Document No.", rSalesShipmentHeader."No.");
        rEDIDocumentinterlocutor.Validate("Interlocutor type", 'SU');
        if rCustomer."VAT PL" then
            rEDIDocumentinterlocutor.Validate("Interlocutor No.", rCompanyInformation."EDI ID PL")
        else
            rEDIDocumentinterlocutor.Validate("Interlocutor No.", rCompanyInformation."EDI ID");
        rEDIDocumentinterlocutor.Validate("Name 1", CopyStr(rCompanyInformation.Name + rCompanyInformation."Name 2", 1, 35));
        rEDIDocumentinterlocutor.Validate("Name 2", CopyStr(rCompanyInformation.Name + rCompanyInformation."Name 2", 36, 35));
        rEDIDocumentinterlocutor.Validate("Name 3", CopyStr(rCompanyInformation.Name + rCompanyInformation."Name 2", 71, 35));
        rEDIDocumentinterlocutor.Validate("Street and number 1", CopyStr(rCompanyInformation.Address + rCompanyInformation."Address 2", 1, 35));
        rEDIDocumentinterlocutor.Validate("Street and number 2", CopyStr(rCompanyInformation.Address + rCompanyInformation."Address 2", 36, 35));
        rEDIDocumentinterlocutor.Validate("Street and number 3", CopyStr(rCompanyInformation.Address + rCompanyInformation."Address 2", 71, 35));
        rEDIDocumentinterlocutor.Validate(City, UpperCase(CopyStr(rCompanyInformation.City, 1, 35)));
        rEDIDocumentinterlocutor.Validate(County, CopyStr(rCompanyInformation.County, 1, 9));
        rEDIDocumentinterlocutor.Validate("Post Code", CopyStr(rCompanyInformation."Post Code", 1, 9));
        rEDIDocumentinterlocutor.Validate("Country/Region Code", rCompanyInformation."Country/Region Code");
        if rCustomer."VAT PL" then
            rEDIDocumentinterlocutor.Validate("VAT Registration No.", rGeneralLedgerSetup."PolishVAT Registration No.")
        else
            rEDIDocumentinterlocutor.Validate("VAT Registration No.", rCompanyInformation."VAT Registration No.");
        rEDIDocumentinterlocutor.Validate("Fax No.", rCompanyInformation."Fax No.");
        rEDIDocumentinterlocutor.Validate("Phone No.", rCompanyInformation."Phone No.");
        if rCustomer."Collection Bank Account" <> '' then begin
            rBankAccount.Reset();
            if rBankAccount.get(rCustomer."Collection Bank Account") then
                rEDIDocumentinterlocutor.validate(Iban, CopyStr(rBankAccount.IBAN, 1, 35));
            rEDIDocumentinterlocutor.validate(Swift, CopyStr(rBankAccount."SWIFT Code", 1, 20));
        end;
        rEDIDocumentinterlocutor.Insert(true);
    end;

    procedure AddShipmentPartMS(rSalesShipmentHeader: Record "Sales Shipment Header"; ForceUpdate: Boolean)
    var
        rEDIDocumentinterlocutor: Record "EDI - Document interlocutor";
        rCompanyInformation: Record "Company Information";
        rGeneralLedgerSetup: Record "General Ledger Setup";
        rCustomer: Record Customer;
        rBankAccount: record "Bank Account";
    begin
        // MS 
        rCompanyInformation.Reset;
        rCompanyInformation.Get;
        rCompanyInformation.TestField("EDI ID");
        rCompanyInformation.TestField("EDI ID PL"); // EDI ID de venta con CIF Polonia
        rCompanyInformation.TestField(Name);
        rCompanyInformation.TestField(Address);
        rCompanyInformation.TestField("VAT Registration No.");
        rGeneralLedgerSetup.Reset;
        rGeneralLedgerSetup.Get;
        rGeneralLedgerSetup.TestField("PolishVAT Registration No.");//CIF BBTrends Polonia
        rCustomer.Reset;
        rCustomer.get(rSalesShipmentHeader."Sell-to Customer No.");
        rEDIDocumentinterlocutor.Reset;
        rEDIDocumentinterlocutor.SetRange("Document Type", rEDIDocumentinterlocutor."document type"::Shipment);
        rEDIDocumentinterlocutor.SetRange("Document No.", rSalesShipmentHeader."No.");
        rEDIDocumentinterlocutor.SetRange("Interlocutor type", 'MS');
        if rEDIDocumentinterlocutor.FindSet then begin
            if ForceUpdate then
                rEDIDocumentinterlocutor.Delete
            else
                exit;
        end;
        rEDIDocumentinterlocutor.Init;
        rEDIDocumentinterlocutor.Validate("Document Type", rEDIDocumentinterlocutor."document type"::Shipment);
        rEDIDocumentinterlocutor.Validate("Document No.", rSalesShipmentHeader."No.");
        rEDIDocumentinterlocutor.Validate("Interlocutor type", 'MS');
        if rCustomer."VAT PL" then
            rEDIDocumentinterlocutor.Validate("Interlocutor No.", rCompanyInformation."EDI ID PL")
        else
            rEDIDocumentinterlocutor.Validate("Interlocutor No.", rCompanyInformation."EDI ID");
        rEDIDocumentinterlocutor.Validate("Name 1", CopyStr(rCompanyInformation.Name + rCompanyInformation."Name 2", 1, 35));
        rEDIDocumentinterlocutor.Validate("Name 2", CopyStr(rCompanyInformation.Name + rCompanyInformation."Name 2", 36, 35));
        rEDIDocumentinterlocutor.Validate("Name 3", CopyStr(rCompanyInformation.Name + rCompanyInformation."Name 2", 71, 35));
        rEDIDocumentinterlocutor.Validate("Street and number 1", CopyStr(rCompanyInformation.Address + rCompanyInformation."Address 2", 1, 35));
        rEDIDocumentinterlocutor.Validate("Street and number 2", CopyStr(rCompanyInformation.Address + rCompanyInformation."Address 2", 36, 35));
        rEDIDocumentinterlocutor.Validate("Street and number 3", CopyStr(rCompanyInformation.Address + rCompanyInformation."Address 2", 71, 35));
        rEDIDocumentinterlocutor.Validate(City, UpperCase(CopyStr(rCompanyInformation.City, 1, 35)));
        rEDIDocumentinterlocutor.Validate(County, CopyStr(rCompanyInformation.County, 1, 9));
        rEDIDocumentinterlocutor.Validate("Post Code", CopyStr(rCompanyInformation."Post Code", 1, 9));
        rEDIDocumentinterlocutor.Validate("Country/Region Code", rCompanyInformation."Country/Region Code");
        if rCustomer."VAT PL" then
            rEDIDocumentinterlocutor.Validate("VAT Registration No.", rGeneralLedgerSetup."PolishVAT Registration No.")
        else
            rEDIDocumentinterlocutor.Validate("VAT Registration No.", rCompanyInformation."VAT Registration No.");
        rEDIDocumentinterlocutor.Validate("Fax No.", rCompanyInformation."Fax No.");
        rEDIDocumentinterlocutor.Validate("Phone No.", rCompanyInformation."Phone No.");
        //>> BBT 12/06/2025. Segun indicaciones SERES el IBAN no debe de informarse en el interlocutor tipo MS 
        //if rCustomer."Collection Bank Account" <> '' then begin
        //    rBankAccount.Reset();
        //    if rBankAccount.get(rCustomer."Collection Bank Account") then
        //        rEDIDocumentinterlocutor.validate(Iban, CopyStr(rBankAccount.IBAN, 1, 35));
        //end;
        //<<

        rEDIDocumentinterlocutor.Insert(true);
    end;

    procedure AddShipmentPartDP(rSalesShipmentHeader: Record "Sales Shipment Header"; ForceUpdate: Boolean)
    var
        rEDIDocumentinterlocutor: Record "EDI - Document interlocutor";
        rShiptoAddress: Record "Ship-to Address";
        rCust: Record Customer;
    begin
        // DP - Punto de entrega
        rEDIDocumentinterlocutor.Reset;
        rEDIDocumentinterlocutor.SetRange("Document Type", rEDIDocumentinterlocutor."document type"::Shipment);
        rEDIDocumentinterlocutor.SetRange("Document No.", rSalesShipmentHeader."No.");
        rEDIDocumentinterlocutor.SetRange("Interlocutor type", 'DP');
        if rEDIDocumentinterlocutor.FindSet then begin
            if ForceUpdate then
                rEDIDocumentinterlocutor.Delete
            else
                exit;
        end;
        rCust.Reset;
        rCust.Get(rSalesShipmentHeader."Sell-to Customer No.");
        rShiptoAddress.Reset;
        if rSalesShipmentHeader."Ship-to Code" <> '' then begin
            rShiptoAddress.Get(rSalesShipmentHeader."Sell-to Customer No.", rSalesShipmentHeader."Ship-to Code");
            rShiptoAddress.TestField("EDI ID");
        end
        else begin
            //rCust.Get(rSalesShipmentHeader."Sell-to Customer No.");
            rCust.TestField("EDI ID");
        end;
        rEDIDocumentinterlocutor.Init;
        rEDIDocumentinterlocutor.Validate("Document Type", rEDIDocumentinterlocutor."document type"::Shipment);
        rEDIDocumentinterlocutor.Validate("Document No.", rSalesShipmentHeader."No.");
        rEDIDocumentinterlocutor.Validate("Interlocutor type", 'DP');
        if rSalesShipmentHeader."Ship-to Code" <> '' then
            rEDIDocumentinterlocutor.Validate("Interlocutor No.", rShiptoAddress."EDI ID")
        else
            rEDIDocumentinterlocutor.Validate("Interlocutor No.", rCust."EDI ID");

        if rSalesShipmentHeader."Ship-to Name 2" <> '' then begin
            rEDIDocumentinterlocutor.Validate("Name 1", CopyStr(rSalesShipmentHeader."Ship-to Name", 1, 35));
            rEDIDocumentinterlocutor.Validate("Name 2", CopyStr(rSalesShipmentHeader."Ship-to Name 2", 1, 35));
        end
        else begin
            rEDIDocumentinterlocutor.Validate("Name 1", CopyStr(rSalesShipmentHeader."Ship-to Name" + rSalesShipmentHeader."Ship-to Name 2", 1, 35));
            rEDIDocumentinterlocutor.Validate("Name 2", CopyStr(rSalesShipmentHeader."Ship-to Name" + rSalesShipmentHeader."Ship-to Name 2", 36, 35));
            rEDIDocumentinterlocutor.Validate("Name 3", CopyStr(rSalesShipmentHeader."Ship-to Name" + rSalesShipmentHeader."Ship-to Name 2", 71, 35));
        end;

        rEDIDocumentinterlocutor.Validate("Street and number 1", CopyStr(rSalesShipmentHeader."Ship-to Address" + rSalesShipmentHeader."Ship-to Address 2", 1, 35));
        rEDIDocumentinterlocutor.Validate("Street and number 2", CopyStr(rSalesShipmentHeader."Ship-to Address" + rSalesShipmentHeader."Ship-to Address 2", 36, 35));
        rEDIDocumentinterlocutor.Validate("Street and number 3", CopyStr(rSalesShipmentHeader."Ship-to Address" + rSalesShipmentHeader."Ship-to Address 2", 71, 35));

        rEDIDocumentinterlocutor.Validate(City, UpperCase(CopyStr(rSalesShipmentHeader."Ship-to City", 1, 30)));
        rEDIDocumentinterlocutor.Validate(County, CopyStr(rSalesShipmentHeader."Ship-to County", 1, 9));
        if rCust."SMG Purchase Group" = 'AMAZON' then
            rEDIDocumentinterlocutor.County := '';

        rEDIDocumentinterlocutor.Validate("Post Code", CopyStr(rSalesShipmentHeader."Ship-to Post Code", 1, 9));
        rEDIDocumentinterlocutor.Validate("Country/Region Code", rSalesShipmentHeader."Ship-to Country/Region Code");
        rEDIDocumentinterlocutor.Validate("VAT Registration No.", rSalesShipmentHeader."VAT Registration No.");
        rEDIDocumentinterlocutor.Insert(true);
    end;

    procedure AddShipmentPartUC(rSalesShipmentHeader: Record "Sales Shipment Header"; ForceUpdate: Boolean)
    var
        rEDIDocumentinterlocutor: Record "EDI - Document interlocutor";
        rCust: Record Customer;
        rSalesHeader: Record "Sales Header";
    begin
        // BY
        rCust.Reset;
        rCust.Get(rSalesShipmentHeader."Sell-to Customer No.");
        rCust.TestField("EDI ID");
        rSalesHeader.Reset;
        rSalesHeader.get(rSalesHeader."Document Type"::Order, rSalesShipmentHeader."Order No.");

        rEDIDocumentinterlocutor.Reset;
        rEDIDocumentinterlocutor.SetRange("Document Type", rEDIDocumentinterlocutor."document type"::Shipment);
        rEDIDocumentinterlocutor.SetRange("Document No.", rSalesShipmentHeader."No.");
        rEDIDocumentinterlocutor.SetRange("Interlocutor type", 'BY');
        if rEDIDocumentinterlocutor.FindSet then begin
            if ForceUpdate then
                rEDIDocumentinterlocutor.Delete
            else
                exit;
        end;

        //>> BBT 22/09/2025. EXCEPCION ALZA. El Interlocutor debe ser el de Chequia.
        EdiCustCode := rCust."EDI ID";
        if rCust."SMG Purchase Group" = 'ALZA' then
            EdiCustCode := '8594177950005';
        //<<                

        rEDIDocumentinterlocutor.Init;
        rEDIDocumentinterlocutor.Validate("Document Type", rEDIDocumentinterlocutor."document type"::Shipment);
        rEDIDocumentinterlocutor.Validate("Document No.", rSalesShipmentHeader."No.");
        rEDIDocumentinterlocutor.Validate("Interlocutor type", 'BY');
        rEDIDocumentinterlocutor.Validate("Interlocutor No.", EdiCustCode);

        if rSalesShipmentHeader."Bill-to Name 2" <> '' then begin
            rEDIDocumentinterlocutor.Validate("Name 1", CopyStr(rSalesShipmentHeader."Sell-to Customer Name", 1, 35));
            rEDIDocumentinterlocutor.Validate("Name 2", CopyStr(rSalesShipmentHeader."Sell-to Customer Name 2", 1, 35));
        end
        else begin
            rEDIDocumentinterlocutor.Validate("Name 1", CopyStr(rSalesShipmentHeader."Sell-to Customer Name" + rSalesShipmentHeader."Sell-to Customer Name 2", 1, 35));
            rEDIDocumentinterlocutor.Validate("Name 2", CopyStr(rSalesShipmentHeader."Sell-to Customer Name" + rSalesShipmentHeader."Sell-to Customer Name 2", 36, 35));
            rEDIDocumentinterlocutor.Validate("Name 3", CopyStr(rSalesShipmentHeader."Sell-to Customer Name" + rSalesShipmentHeader."Sell-to Customer Name 2", 71, 35));
        end;

        rEDIDocumentinterlocutor.Validate("Street and number 1", CopyStr(rSalesShipmentHeader."Sell-to Address" + rSalesShipmentHeader."Sell-to Address 2", 1, 35));
        rEDIDocumentinterlocutor.Validate("Street and number 2", CopyStr(rSalesShipmentHeader."Sell-to Address" + rSalesShipmentHeader."Sell-to Address 2", 36, 35));
        rEDIDocumentinterlocutor.Validate("Street and number 3", CopyStr(rSalesShipmentHeader."Sell-to Address" + rSalesShipmentHeader."Sell-to Address 2", 71, 35));

        rEDIDocumentinterlocutor.Validate(City, UpperCase(CopyStr(rSalesShipmentHeader."Sell-to City", 1, 30)));
        rEDIDocumentinterlocutor.Validate(County, CopyStr(rSalesShipmentHeader."Sell-to County", 1, 9));
        if rCust."SMG Purchase Group" = 'AMAZON' then
            rEDIDocumentinterlocutor.County := '';

        rEDIDocumentinterlocutor.Validate("Post Code", CopyStr(rSalesShipmentHeader."Sell-to Post Code", 1, 9));
        rEDIDocumentinterlocutor.Validate("Country/Region Code", rSalesShipmentHeader."Sell-to Country/Region Code");
        rEDIDocumentinterlocutor.Validate("VAT Registration No.", rSalesShipmentHeader."VAT Registration No.");
        //>> BBT 10/03/2025. Añadir para NIF PL la referencia 1 y referencia 2.
        if rCust."VAT PL" then begin
            rEDIDocumentinterlocutor.Validate("Reference type 1", rSalesHeader."EDI - Calificador Referencia 1");
            rEDIDocumentinterlocutor.Validate("Reference 1", rSalesHeader."EDI - Referencia 1");
            rEDIDocumentinterlocutor.Validate("Reference type 2", rSalesHeader."EDI - Calificador Referencia 2");
            rEDIDocumentinterlocutor.Validate("Reference 2", rSalesHeader."EDI - Referencia 2");
        end;
        //<<

        rEDIDocumentinterlocutor.Insert(true);
    end;

    procedure AddShipmentPartIV(rSalesShipmentHeader: Record "Sales Shipment Header"; ForceUpdate: Boolean)
    var
        rEDIDocumentinterlocutor: Record "EDI - Document interlocutor";
        rCust: Record Customer;
    begin
        // IV
        rEDIDocumentinterlocutor.Reset;
        rEDIDocumentinterlocutor.SetRange("Document Type", rEDIDocumentinterlocutor."document type"::Shipment);
        rEDIDocumentinterlocutor.SetRange("Document No.", rSalesShipmentHeader."No.");
        rEDIDocumentinterlocutor.SetRange("Interlocutor type", 'IV');
        if rEDIDocumentinterlocutor.FindSet then begin
            if ForceUpdate then
                rEDIDocumentinterlocutor.Delete
            else
                exit;
        end;
        rCust.Reset;
        if rSalesShipmentHeader."Bill-to Customer No." <> '' then
            rCust.Get(rSalesShipmentHeader."Bill-to Customer No.")
        else
            rCust.Get(rSalesShipmentHeader."Sell-to Customer No.");
        rCust.TestField("EDI ID");
        //SI EL CLIENTE TIENE INVOICE EDI LE PONGO ESTE VALOR
        if rCust."Invoice EDI" <> '' then
            EdiCustCode := rCust."Invoice EDI"
        else
            EdiCustCode := rCust."EDI ID";
        rEDIDocumentinterlocutor.Init;
        rEDIDocumentinterlocutor.Validate("Document Type", rEDIDocumentinterlocutor."document type"::Shipment);
        rEDIDocumentinterlocutor.Validate("Document No.", rSalesShipmentHeader."No.");
        rEDIDocumentinterlocutor.Validate("Interlocutor type", 'IV');
        rEDIDocumentinterlocutor.Validate("Interlocutor No.", EdiCustCode);

        if rSalesShipmentHeader."Bill-to Name 2" <> '' then begin
            rEDIDocumentinterlocutor.Validate("Name 1", CopyStr(rSalesShipmentHeader."Bill-to Name", 1, 35));
            rEDIDocumentinterlocutor.Validate("Name 2", CopyStr(rSalesShipmentHeader."Bill-to Name 2", 1, 35));
        end
        else begin
            rEDIDocumentinterlocutor.Validate("Name 1", CopyStr(rSalesShipmentHeader."Bill-to Name" + rSalesShipmentHeader."Bill-to Name 2", 1, 35));
            rEDIDocumentinterlocutor.Validate("Name 2", CopyStr(rSalesShipmentHeader."Bill-to Name" + rSalesShipmentHeader."Bill-to Name 2", 36, 35));
            rEDIDocumentinterlocutor.Validate("Name 3", CopyStr(rSalesShipmentHeader."Bill-to Name" + rSalesShipmentHeader."Bill-to Name 2", 71, 35));
        end;

        rEDIDocumentinterlocutor.Validate("Street and number 1", CopyStr(rSalesShipmentHeader."Bill-to Address" + rSalesShipmentHeader."Bill-to Address 2", 1, 35));
        rEDIDocumentinterlocutor.Validate("Street and number 2", CopyStr(rSalesShipmentHeader."Bill-to Address" + rSalesShipmentHeader."Bill-to Address 2", 36, 35));
        rEDIDocumentinterlocutor.Validate("Street and number 3", CopyStr(rSalesShipmentHeader."Bill-to Address" + rSalesShipmentHeader."Bill-to Address 2", 71, 35));

        rEDIDocumentinterlocutor.Validate(City, UpperCase(CopyStr(rSalesShipmentHeader."Bill-to City", 1, 30)));
        rEDIDocumentinterlocutor.Validate(County, CopyStr(rSalesShipmentHeader."Bill-to County", 1, 9));
        if rCust."SMG Purchase Group" = 'AMAZON' then
            rEDIDocumentinterlocutor.County := '';

        rEDIDocumentinterlocutor.Validate("Post Code", CopyStr(rSalesShipmentHeader."Bill-to Post Code", 1, 9));
        rEDIDocumentinterlocutor.Validate("Country/Region Code", rSalesShipmentHeader."Bill-to Country/Region Code");
        rEDIDocumentinterlocutor.Validate("VAT Registration No.", rSalesShipmentHeader."VAT Registration No.");
        rEDIDocumentinterlocutor.Insert(true);
    end;

    procedure PrepareShipmentsForRetry()
    var
        EDIEDIEntry: Record "EDI - EDI Entry";
        DelayProcess: DateFormula;
    begin
        Evaluate(DelayProcess, '<-7D>');
        EDIEDIEntry.Reset;
        EDIEDIEntry.SetRange("Has error", true);
        EDIEDIEntry.SetRange("Document type", EDIEDIEntry."document type"::Shipment);
        EDIEDIEntry.SetRange(EDIEDIEntry."Inbound/Outbound", EDIEDIEntry."Inbound/Outbound"::Outbound);
        EDIEDIEntry.SetFilter("SystemCreatedAt", '>=%1', CREATEDATETIME(CalcDate(DelayProcess, WorkDate), 0T));
        if EDIEDIEntry.FindSet then begin
            repeat
                EDIEDIEntry."Has error" := false;
                EDIEDIEntry."Last error text" := '';
                EDIEDIEntry."Processed at" := 0DT;
                EDIEDIEntry."Upload in progress" := false;
                EDIEDIEntry.Uploaded := false;
                EDIEDIEntry.Modify();
            until EDIEDIEntry.Next = 0;
            Commit;
        END;
    end;

    /************************************************************************************/
    /******************* EDI - INVOICES *************************************************/
    /************************************************************************************/
    /*
    Tipo     Nombre registro                                     Repeticiones
    _____    _______________________________________________     _____________
    RECTL    Registro de control                 Obligatorio         1
    SEH1C    Cabecera                            Obligatorio         1
    SEH1D    Información de partes               Obligatorio         N
    SEH1P    Secuencia de embalajes              Obligatorio         N
    SEH1L    Línea de artículos                  Obligatorio         N
    SEH1G    Desglose cantidad/Localizaciones    Opcional            N
    SEH1B    Información de lotes                Opcional            N
    */

    procedure CreateInvoiceEDIEntry(rSalesInvoiceHeader: Record "Sales Invoice Header")
    var
        rEDIEDIEntry: Record "EDI - EDI Entry";
        rCompanyInformation: Record "Company Information";
        rCustomer: Record Customer;
    begin
        rCompanyInformation.Reset;
        rCompanyInformation.Get;
        if rCompanyInformation."EDI ID" = '' then exit;
        rCustomer.Reset;
        if rCustomer.Get(rSalesInvoiceHeader."Sell-to Customer No.") then begin
            if rCustomer."No EDI" then
                exit;
            CopyPartsFromShipment(rSalesInvoiceHeader);
            if not (rCustomer."Send EDI Documents" in [rCustomer."send edi documents"::All, rCustomer."send edi documents"::Invoice]) then
                exit;
        end
        else
            exit;
        if rSalesInvoiceHeader."EDI - Do not send EDI" then exit;
        rEDIEDIEntry.Reset;
        rEDIEDIEntry.SetRange("Document Nos.", rSalesInvoiceHeader."No.");
        rEDIEDIEntry.SetRange("Inbound/Outbound", rEDIEDIEntry."inbound/outbound"::Outbound);
        //>> Se comprueba que la factura no este ya en los documentos EDI
        if rEDIEDIEntry.FindSet then exit;
        //<<
        rEDIEDIEntry.Init;
        rEDIEDIEntry.Validate("Document type", rEDIEDIEntry."document type"::Invoice);
        rEDIEDIEntry.Validate("Inbound/Outbound", rEDIEDIEntry."inbound/outbound"::Outbound);
        rEDIEDIEntry.Validate("Document Nos.", rSalesInvoiceHeader."No.");
        rEDIEDIEntry.Insert(true);
    end;

    local procedure CopyPartsFromShipment(rSalesInvoiceHeader: Record "Sales Invoice Header"): Boolean
    var
        rShipmentHeader: Record "Sales Shipment Header";
        rEdiParts: Record "EDI - Document interlocutor";
        rEdiPartsInvoice: Record "EDI - Document interlocutor";
        ShipmentNo: code[20];
    begin
        rShipmentHeader.Reset;
        //>> BBT 28/02/2025 Cambio en la obtención del número de albarán 
        //rShipHeader.SetRange(rShipHeader."Order No.", rSalesInvoiceHeader."Order No.");      
        ShipmentNo := GetShipmentNo(rSalesInvoiceHeader);
        rShipmentHeader.SetRange("No.", ShipmentNo);
        //<<
        if rShipmentHeader.FindFirst then begin
            rEdiParts.Reset;
            rEdiParts.SetRange(rEdiParts."Document Type", rEdiParts."document type"::Shipment);
            rEdiParts.SetRange(rEdiParts."Document No.", rShipmentHeader."No.");
            if rEdiParts.FindSet then
                repeat
                    rEdiPartsInvoice.Reset;
                    rEdiPartsInvoice.SetRange("Document Type", rEdiPartsInvoice."document type"::Invoice);
                    rEdiPartsInvoice.SetRange("Document No.", rSalesInvoiceHeader."No.");
                    rEdiPartsInvoice.SetRange("Interlocutor type", rEdiParts."Interlocutor type");
                    rEdiPartsInvoice.SetRange("Interlocutor No.", rEdiParts."Interlocutor No.");
                    if not rEdiPartsInvoice.FindFirst then begin
                        rEdiPartsInvoice.Reset; // Aseguramos que no existe ninguna linea '"Interlocutor type"' extra.
                        rEdiPartsInvoice.SetRange("Document Type", rEdiPartsInvoice."document type"::Invoice);
                        rEdiPartsInvoice.SetRange("Document No.", rSalesInvoiceHeader."No.");
                        rEdiPartsInvoice.SetRange("Interlocutor type", rEdiParts."Interlocutor type");
                        if rEdiPartsInvoice.FindSet then
                            repeat
                                rEdiPartsInvoice.Delete();
                            until rEdiPartsInvoice.Next = 0;

                        rEdiPartsInvoice."Document Type" := rEdiPartsInvoice."document type"::Invoice;
                        rEdiPartsInvoice."Document No." := rSalesInvoiceHeader."No.";
                        rEdiPartsInvoice."Interlocutor type" := rEdiParts."Interlocutor type";
                        rEdiPartsInvoice."Interlocutor No." := rEdiParts."Interlocutor No.";
                        rEdiPartsInvoice.Insert;
                    end;
                    rEdiPartsInvoice."Code responsible agency" := rEdiParts."Code responsible agency";
                    rEdiPartsInvoice."Name 1" := rEdiParts."Name 1";
                    rEdiPartsInvoice."Name 2" := rEdiParts."Name 2";
                    rEdiPartsInvoice."Name 3" := rEdiParts."Name 3";
                    rEdiPartsInvoice."Name 4" := rEdiParts."Name 4";
                    rEdiPartsInvoice."Name 5" := rEdiParts."Name 5";
                    rEdiPartsInvoice."Street and number 1" := rEdiParts."Street and number 1";
                    rEdiPartsInvoice."Street and number 2" := rEdiParts."Street and number 2";
                    rEdiPartsInvoice."Street and number 3" := rEdiParts."Street and number 3";
                    rEdiPartsInvoice."Street and number 4" := rEdiParts."Street and number 4";
                    rEdiPartsInvoice.City := rEdiParts.City;
                    rEdiPartsInvoice.County := rEdiParts.County;
                    rEdiPartsInvoice."Post Code" := rEdiParts."Post Code";
                    rEdiPartsInvoice."Country/Region Code" := rEdiParts."Country/Region Code";
                    rEdiPartsInvoice."Reference type 1" := rEdiParts."Reference type 1";
                    rEdiPartsInvoice."Reference 1" := rEdiParts."Reference 1";
                    rEdiPartsInvoice."Contact function" := rEdiParts."Contact function";
                    rEdiPartsInvoice."Dept. or employee ID" := rEdiParts."Dept. or employee ID";
                    rEdiPartsInvoice."Dept. or employee" := rEdiParts."Dept. or employee";
                    rEdiPartsInvoice."Reference type 2" := rEdiParts."Reference type 2";
                    rEdiPartsInvoice."Reference 2" := rEdiParts."Reference 2";
                    rEdiPartsInvoice."VAT Registration No." := rEdiParts."VAT Registration No.";
                    rEdiPartsInvoice."Fax No." := rEdiParts."Fax No.";
                    rEdiPartsInvoice."Phone No." := rEdiParts."Phone No.";
                    rEdiPartsInvoice.Iban := rEdiParts.Iban;
                    rEdiPartsInvoice.Swift := rEdiParts.Swift;
                    rEdiPartsInvoice."Issuer Commercial Register" := rEdiParts."Issuer Commercial Register";
                    rEdiPartsInvoice."Social Capital" := rEdiParts."Social Capital";
                    //>> BBT 03/12/2024.
                    //rEdiPartsInvoice.Insert;
                    rEdiPartsInvoice.Modify();
                //<<

                until rEdiParts.Next = 0;
            exit(true);
        end
        else
            exit(false);
    end;

    procedure CreateInvoiceEDIBlob(var rEDIEDIEntry: Record "EDI - EDI Entry")
    var
        OStream: OutStream;
        rSalesReceivablesSetup: Record "Sales & Receivables Setup";
        EdiFilesProcesing: Codeunit "BBT EDI Files Procesing";
        rSalesInvoice: Record "Sales Invoice Header";
        rCustomer: Record Customer;

    begin
        if (rEDIEDIEntry."Processed at" <> 0DT) or (rEDIEDIEntry."Manually processed") then exit;
        rSalesReceivablesSetup.Reset;
        rSalesReceivablesSetup.Get;
        rSalesReceivablesSetup.TestField("EDI - Sales Invoice Prefix");
        rEDIEDIEntry.Validate("File name", rSalesReceivablesSetup."EDI - Sales Invoice Prefix" + rEDIEDIEntry."Document Nos." + '.TXT');
        Clear(rEDIEDIEntry."File Blob");
        rEDIEDIEntry."File Blob".CreateOutstream(OStream); //, TextEncoding::Windows); //Revisar power automate
        CreateInvoiceRECTLine(rEDIEDIEntry, OStream); // Registro de control - 1 iteración
        CreateInvoiceSINCCLine(rEDIEDIEntry, OStream); // Registro cabecera - 1 iteración
        CreateInvoiceSINCPLine(rEDIEDIEntry, OStream); // Información partes involucradas - N iteraciones
        CreateInvoiceSINCTLine(rEDIEDIEntry, OStream); // Observaciones a nivel cabecera - N iteraciones
        CreateInvoiceSINCVLine(rEDIEDIEntry, OStream); // Vencimientos - N iteraciones
        CreateInvoiceSINCLLine(rEDIEDIEntry, OStream); // Detalle línea - N iteraciones (dentro están descuentos línea)
        CreateInvoiceSINCILine(rEDIEDIEntry, OStream); // Impuestos - N iteraciones

        //>> 12/03/2025 Marcamos el registro NAC/PL y actualizamos el código del cliente
        rSalesInvoice.Reset;
        rSalesInvoice.Get(rEDIEDIEntry."Document Nos.");
        rCustomer.Reset;
        rCustomer.Get(rSalesInvoice."Sell-to Customer No.");
        rEDIEDIEntry.Validate("Source Type", rEDIEDIEntry."Source Type"::Customer);
        rEDIEDIEntry.Validate("Sourde Id", rCustomer."No.");
        rEDIEDIEntry.Validate("Source Name", rCustomer.Name);
        rEDIEDIEntry.Validate("PL Entry", false);
        if rCustomer."VAT PL" then
            rEDIEDIEntry.Validate("PL Entry", true);
        //<<

        rEDIEDIEntry.Modify(true);
        EdiFilesProcesing.UploadInvoiceFileToFTP(rEDIEDIEntry);
    end;


    local procedure CreateInvoiceRECTLine(rEDIEDIEntry: Record "EDI - EDI Entry"; var OStream: OutStream)
    var
        EDILineTxt: Text;
        rCompanyInformation: Record "Company Information";
        rCustomer: Record Customer;
        rSalesInvoiceHeader: Record "Sales Invoice Header";

    begin
        rEDIEDIEntry.TestField("Document Nos.");
        rEDIEDIEntry.TestField("Document type", rEDIEDIEntry."document type"::Invoice);
        rCompanyInformation.Reset;
        rCompanyInformation.Get;
        rCompanyInformation.TestField("EDI ID");
        rCompanyInformation.TestField("EDI ID PL"); // EDI ID de venta con CIF Polonia
        rSalesInvoiceHeader.Reset;
        rSalesInvoiceHeader.Get(rEDIEDIEntry."Document Nos.");
        //>> Si no se tiene que enviar a EDI, el registro del que partimos (EDI Entry) no debería haberse generado desde un principio
        rSalesInvoiceHeader.TestField("EDI - Do not send EDI", false);
        //<<
        rCustomer.Reset;
        rCustomer.Get(rSalesInvoiceHeader."Sell-to Customer No.");
        rCustomer.TestField("EDI ID");
        // Escribimos la línea
        EDILineTxt := '';
        WriteTextField('RECTL', EDILineTxt, 6);
        WriteTextField('INVOIC', EDILineTxt, 6);
        if rCustomer."VAT PL" then
            WriteTextField(rCompanyInformation."EDI ID PL", EDILineTxt, 35)
        else
            WriteTextField(rCompanyInformation."EDI ID", EDILineTxt, 35);

        //>>GLN del Receptor del Mensaje. Excepciones por el Grupo de Compras.    
        //if rCustomer."Purchase Group" = 'SONAE' then
        //    WriteTextField('5600000000427', EDILineTxt, 35)
        //else
        //    WriteTextField(rCustomer."EDI ID", EDILineTxt, 35);
        if rCustomer."SMG Purchase Group" = 'SONAE' then
            WriteTextField('5600000000427', EDILineTxt, 35)
        else
            if rCustomer."SMG Purchase Group" = 'ALZA' then
                WriteTextField('8594177950005', EDILineTxt, 35)
            else
                WriteTextField(rCustomer."EDI ID", EDILineTxt, 35);

        //<<
        WriteTextField('INVOIC' + rSalesInvoiceHeader."No.", EDILineTxt, 40); // Esto podría necesitar cambiarse - Añado el "INVOIC" inicial
                                                                              // al código de la factura para que si se arranca EDI para circuito compras,
                                                                              // o transfers, podamos diferenciar los distintos tipos de expediciones
        WriteDatetimeField(CurrentDatetime, EDILineTxt, 12);
        // Comprobación de longitud
        if (StrLen(EDILineTxt) <> 134) then
            Error('La línea de tipo RECTL tiene una longitud distinta a la esperada (esperada 134, real ' + Format(StrLen(EDILineTxt)) + ')');
        OStream.WriteText(EDILineTxt);
        OStream.WriteText; // Salto de línea
    end;


    local procedure CreateInvoiceSINCCLine(rEDIEDIEntry: Record "EDI - EDI Entry"; var OStream: OutStream)
    var
        EDILineTxt: Text;
        rCustomer: Record Customer;
        rSalesInvoiceHeader: Record "Sales Invoice Header";
        rSalesShipmentHeader: Record "Sales Shipment Header";
        rPaymentMethod: Record "Payment Method";
        ShipmentNo: Code[20];
        OrderNo: Code[20];
        CurrencyCode: Code[10];
        UniqueDueDate: Date;
        GrossAmount: Decimal;

    begin
        rEDIEDIEntry.TestField("Document Nos.");
        rEDIEDIEntry.TestField("Document type", rEDIEDIEntry."document type"::Invoice);
        rSalesInvoiceHeader.Reset;
        rSalesInvoiceHeader.Get(rEDIEDIEntry."Document Nos.");
        //>> Si no se tiene que enviar a EDI, el registro del que partimos (EDI Entry) no debería haberse generado desde un principio
        rSalesInvoiceHeader.TestField("EDI - Do not send EDI", false);
        //<<
        rSalesInvoiceHeader.TestField("Payment Method Code");
        rSalesInvoiceHeader.CalcFields("Amount Including VAT", Amount);
        rSalesInvoiceHeader.TestField("Prices Including VAT", false);
        rCustomer.Reset;
        rCustomer.Get(rSalesInvoiceHeader."Sell-to Customer No.");
        rCustomer.TestField("EDI ID");
        rPaymentMethod.Reset;
        rPaymentMethod.Get(rSalesInvoiceHeader."Payment Method Code");
        rPaymentMethod.TestField("EDI - Payment Method");
        // Recuperamos albarán del servicio facturado en este documento
        rSalesShipmentHeader.Reset;
        ShipmentNo := GetShipmentNo(rSalesInvoiceHeader);
        if ShipmentNo <> '' then
            rSalesShipmentHeader.Get(ShipmentNo);
        OrderNo := GetOrderNo(rSalesInvoiceHeader);
        CurrencyCode := GetCurrencyCode(rSalesInvoiceHeader);
        UniqueDueDate := GetUniqueDueDate(rSalesInvoiceHeader); // Si hay varios vencimientos, van en el registro SINCV
        GrossAmount := GetGrossAmount(rSalesInvoiceHeader); // Importe bruto
                                                            // Escribimos la línea
        EDILineTxt := '';
        WriteTextField('SINCC', EDILineTxt, 6);
        WriteTextField('380', EDILineTxt, 6); // 380 = Factura comercial - Si hacemos abonos es el código 381
        if StrLen(rSalesInvoiceHeader."No.") > 17 then
            Error('El número de factura ' + rSalesInvoiceHeader."No." + ' es mayor de 17 carácteres. Revisar cómo solventar esta incidencia');
        WriteTextField(rSalesInvoiceHeader."No.", EDILineTxt, 17);
        WriteTextField('9', EDILineTxt, 6); //Invoice message function
        WriteDateField(rSalesInvoiceHeader."Posting Date", EDILineTxt, 8);
        WriteDateField(rSalesShipmentHeader."Posting Date", EDILineTxt, 16);
        WriteTextField('', EDILineTxt, 6); //Forma de pago en blanco
        WriteTextField('', EDILineTxt, 3); // Razón de cargo o abono - Solo utilizado para abonos
        WriteTextField('', EDILineTxt, 3); // Criterio rectificación - Solo utilizado para abonos
        WriteTextField(rSalesInvoiceHeader."External Document No.", EDILineTxt, 17); // Número de pedido
        if rCustomer."SMG Purchase Group" = 'MM' then
            WriteTextField(ShipmentNo, EDILineTxt, 17) // Número de albarán
        else
            WriteTextField(CopyStr(ShipmentNo, 5, 6), EDILineTxt, 17); // Número de albarán sin prefijo EVnn
        WriteTextField('', EDILineTxt, 3); // Calificador documento rectificado/sustituido - Solo utilizado para abonos
        WriteTextField('', EDILineTxt, 17); // Número documento rectificado/sustituido - Solo utilizado para abonos
        WriteTextField(rSalesInvoiceHeader."EDI - Contract No.", EDILineTxt, 17);
        WriteTextField('', EDILineTxt, 17); // Número de relación de entregas - Solo obligatorio si el tipo de factura es "Fra recapitulativa"
        WriteTextField(CurrencyCode, EDILineTxt, 6);
        WriteDateField(UniqueDueDate, EDILineTxt, 8); // Fecha vencimiento única
        WriteDecimalVarField(rSalesInvoiceHeader.Amount, EDILineTxt, 18, 3); // Importe neto total de factura
        WriteDecimalVarField(rSalesInvoiceHeader.Amount, EDILineTxt, 18, 3); // Base imponible
        WriteDecimalVarField(rSalesInvoiceHeader.Amount, EDILineTxt, 18, 3); // Importe bruto
        WriteDecimalVarField(rSalesInvoiceHeader."Amount Including VAT" - rSalesInvoiceHeader.Amount, EDILineTxt, 18, 3); // Importe total de impuestos
        WriteDecimalVarField(rSalesInvoiceHeader."Amount Including VAT", EDILineTxt, 18, 3); // Importe total a pagar - Habría que hacer solo lo pdte?
        WriteDecimalVarField(0, EDILineTxt, 18, 3); // Subvenciones vinculadas al precio
        WriteDecimalVarField(Abs(0), EDILineTxt, 18, 3); // Total incrementos importe bruto (si es positivo)
        WriteDecimalVarField(Abs(0), EDILineTxt, 18, 3); // Total minoraciones importe bruto (si es negativo). P.e. dtos factura
        //>> Pasamos a CASE las excepciones
        //if rCustomer."SMG Purchase Group" = 'CORTICOR' then
        //    WriteTextField('', EDILineTxt, 16)
        //else
        //    WritePeriodField(rSalesInvoiceHeader."Posting Date", EDILineTxt, 16);
        case rCustomer."SMG Purchase Group" of
            'CORTICOR':
                begin
                    WriteTextField('', EDILineTxt, 16);
                end;
            'ALZA':
                begin
                    WriteDateField(rSalesInvoiceHeader."Posting Date", EDILineTxt, 8);
                    WriteDateField(CalcDate('<+15D>', rSalesInvoiceHeader."Posting Date"), EDILineTxt, 8);
                end;
            else
                WritePeriodField(rSalesInvoiceHeader."Posting Date", EDILineTxt, 16);
        end;
        //<<    
        WriteDateField(rSalesShipmentHeader."Order Date", EDILineTxt, 8); // Fecha pedido
                                                                          // WriteDateField(SalesShipmentHeader."Posting Date", EDILineTxt, 8); // Fecha efectiva del servicio
        WriteDatetimeField(rSalesShipmentHeader.SystemCreatedAt, EDILineTxt, 12); // Fecha efectiva del servicio
        if (rCustomer."No." = 'C01865') or      //EROSKI S.COOP                                       
            (rCustomer."SMG Platform" = 'LM') then   //BCM BRICOLAGE S.A (LM Portugal)
            WriteTextField('', EDILineTxt, 17)  // Número confirmación de entrega VACIO
        else
            WriteTextField(rSalesInvoiceHeader."External Document No.", EDILineTxt, 17); // Número confirmación de entrega
                                                                                         // Comprobación de longitud
        if (StrLen(EDILineTxt) <> 370) then
            Error('La línea de tipo SINCC tiene una longitud distinta a la esperada (esperada 370, real ' + Format(StrLen(EDILineTxt)) + ')');
        OStream.WriteText(EDILineTxt);
        OStream.WriteText; // Salto de línea
    end;


    local procedure CreateInvoiceSINCTLine(rEDIEDIEntry: Record "EDI - EDI Entry"; var OStream: OutStream)
    var
        EDILineTxt: Text;
        rSalesInvoiceHeader: Record "Sales Invoice Header";
        EDIComments: Text;
        IStream: InStream;
        DummyTxt: Text;

    begin
        rEDIEDIEntry.TestField("Document Nos.");
        rEDIEDIEntry.TestField("Document type", rEDIEDIEntry."document type"::Invoice);
        rSalesInvoiceHeader.Reset;
        rSalesInvoiceHeader.Get(rEDIEDIEntry."Document Nos.");
        rSalesInvoiceHeader.TestField("EDI - Do not send EDI", false); // Si no se tiene que enviar a EDI, el registro del que partimos (EDI Entry) no debería haberse generado desde un principio
        rSalesInvoiceHeader.CalcFields("EDI - Comments");
        if not rSalesInvoiceHeader."EDI - Comments".Hasvalue then
            exit;
        Clear(IStream);
        rSalesInvoiceHeader."EDI - Comments".CreateInstream(IStream);
        while not IStream.eos do begin
            IStream.Read(DummyTxt);
            EDIComments := EDIComments + DummyTxt;
        end;
        // Escribimos la línea
        EDILineTxt := '';
        WriteTextField('SINCT', EDILineTxt, 6);
        WriteTextField('AAI', EDILineTxt, 6);
        WriteTextField(CopyStr(EDIComments, 1, 70), EDILineTxt, 70);
        WriteTextField(CopyStr(EDIComments, 71, 70), EDILineTxt, 70);
        WriteTextField(CopyStr(EDIComments, 141, 70), EDILineTxt, 70);
        WriteTextField(CopyStr(EDIComments, 211, 70), EDILineTxt, 70);
        WriteTextField(CopyStr(EDIComments, 281, 70), EDILineTxt, 70);
        // Comprobación de longitud
        if (StrLen(EDILineTxt) <> 362) then
            Error('La línea de tipo SINCT tiene una longitud distinta a la esperada (esperada 362, real ' + Format(StrLen(EDILineTxt)) + ')');
        OStream.WriteText(EDILineTxt);
        OStream.WriteText; // Salto de línea
    end;


    local procedure CreateInvoiceSINCPLine(rEDIEDIEntry: Record "EDI - EDI Entry"; var OStream: OutStream)
    var
        EDILineTxt: Text;
        rCustomer: Record Customer;
        rEDIDocumentinterlocutor: Record "EDI - Document interlocutor";
        rSalesInvoiceHeader: Record "Sales Invoice Header";

    begin
        rEDIEDIEntry.TestField("Document Nos.");
        rEDIEDIEntry.TestField("Document type", rEDIEDIEntry."document type"::Invoice);
        rSalesInvoiceHeader.Reset;
        rSalesInvoiceHeader.Get(rEDIEDIEntry."Document Nos.");
        rCustomer.Reset;
        rCustomer.Get(rSalesInvoiceHeader."Sell-to Customer No.");
        rEDIDocumentinterlocutor.Reset;
        rEDIDocumentinterlocutor.SetRange(rEDIDocumentinterlocutor."Document Type", rEDIDocumentinterlocutor."document type"::Invoice);
        rEDIDocumentinterlocutor.SetRange("Document No.", rSalesInvoiceHeader."No.");
        if not rEDIDocumentinterlocutor.FindSet then
            if not CopyPartsFromShipment(rSalesInvoiceHeader) then
                Error('La factura ' + rSalesInvoiceHeader."No." + ' no tiene información de las partes especificada');
        repeat // Escribimos la línea
            EDILineTxt := '';
            WriteTextField('SINCP', EDILineTxt, 6);                                                 //P1 - Tipo registro
            WriteTextField(rEDIDocumentinterlocutor."Interlocutor type", EDILineTxt, 3);            //P7
            WriteTextField(rEDIDocumentinterlocutor."Interlocutor No.", EDILineTxt, 17);            //P10
            WriteTextField('9', EDILineTxt, 3);                                                     //P27 -  Solo 9 - EDI
            WriteTextField(rEDIDocumentinterlocutor."Name 1", EDILineTxt, 35);                      //P30
            WriteTextField(rEDIDocumentinterlocutor."Name 2", EDILineTxt, 35);                      //P65
            WriteTextField(rEDIDocumentinterlocutor."Name 3", EDILineTxt, 35);                      //P100
            WriteTextField(rEDIDocumentinterlocutor."Name 4", EDILineTxt, 35);                      //P135
            WriteTextField(rEDIDocumentinterlocutor."Name 5", EDILineTxt, 35);                      //P170
            WriteTextField(rEDIDocumentinterlocutor."Street and number 1", EDILineTxt, 35);         //P205
            WriteTextField(rEDIDocumentinterlocutor."Street and number 2", EDILineTxt, 35);         //P240
            WriteTextField(rEDIDocumentinterlocutor."Street and number 3", EDILineTxt, 35);         //P275
            WriteTextField(rEDIDocumentinterlocutor."Street and number 4", EDILineTxt, 35);         //P310
            WriteTextField(rEDIDocumentinterlocutor.City, EDILineTxt, 35);                          //P345
            WriteTextField(rEDIDocumentinterlocutor.County, EDILineTxt, 9);                         //P380
            WriteTextField(rEDIDocumentinterlocutor."Post Code", EDILineTxt, 9);                    //P389
            WriteTextField(rEDIDocumentinterlocutor."Country/Region Code", EDILineTxt, 3);          //P398
            WriteTextField(rEDIDocumentinterlocutor."VAT Registration No.", EDILineTxt, 35);        //P401
            WriteTextField(rEDIDocumentinterlocutor."Reference 1", EDILineTxt, 35);                 //P436 - CAMBIAR POR "CODIGO ADICIONAL"
            WriteTextField(rEDIDocumentinterlocutor."Contact function", EDILineTxt, 3);             //P471
            WriteTextField(rEDIDocumentinterlocutor."Dept. or employee ID", EDILineTxt, 17);        //P474
            WriteTextField(rEDIDocumentinterlocutor."Dept. or employee", EDILineTxt, 35);           //P491
            WriteTextField(rEDIDocumentinterlocutor."Phone No.", EDILineTxt, 35);                   //P526
            WriteTextField(rEDIDocumentinterlocutor."Fax No.", EDILineTxt, 35);                     //P561
            WriteTextField(rEDIDocumentinterlocutor.Iban, EDILineTxt, 35);                          //P596
            WriteTextField(rEDIDocumentinterlocutor."Issuer Commercial Register", EDILineTxt, 70);  //P631
            WriteTextField(rEDIDocumentinterlocutor."Social Capital", EDILineTxt, 35);              //P701
            if rCustomer."SMG Purchase Group" = 'CORTICOR' then begin
                WriteTextField('API', EDILineTxt, 3);                                               //P736 Calificador referencia adicional
                WriteTextField(rSalesInvoiceHeader."Cód. Departamento", EDILineTxt, 35);            //P739 CAMBIAR POR REFERENCIA ADICIONAL
            end
            else begin
                WriteTextField(rEDIDocumentinterlocutor."Reference type 2", EDILineTxt, 3);         //P736 Calificador referencia adicional
                WriteTextField(rEDIDocumentinterlocutor."Reference 2", EDILineTxt, 35);             //P739 CAMBIAR POR REFERENCIA ADICIONAL
            end;
            WriteTextField(rEDIDocumentinterlocutor.Swift, EDILineTxt, 11);                         //P774
            // Comprobación de longitud
            if (StrLen(EDILineTxt) <> 784) then
                Error('La línea de tipo SINCP tiene una longitud distinta a la esperada (esperada 784, real ' + Format(StrLen(EDILineTxt)) + ')');
            OStream.WriteText(EDILineTxt);
            OStream.WriteText; // Salto de línea
        until rEDIDocumentinterlocutor.Next = 0;
    end;

    local procedure CreateInvoiceSINCVLine(rEDIEDIEntry: Record "EDI - EDI Entry"; var OStream: OutStream)
    var
        EDILineTxt: Text;
        rSalesInvoiceHeader: Record "Sales Invoice Header";
        UniqueDueDate: Date;
        rCustLedgerEntry: Record "Cust. Ledger Entry";
        i: Integer;

    begin
        rEDIEDIEntry.TestField("Document Nos.");
        rEDIEDIEntry.TestField("Document type", rEDIEDIEntry."document type"::Invoice);
        rSalesInvoiceHeader.Reset;
        rSalesInvoiceHeader.Get(rEDIEDIEntry."Document Nos.");
        UniqueDueDate := 0D;
        UniqueDueDate := GetUniqueDueDate(rSalesInvoiceHeader);
        if UniqueDueDate <> 0D then exit;
        rCustLedgerEntry.Reset;
        rCustLedgerEntry.SetRange("Document No.", rSalesInvoiceHeader."No.");
        rCustLedgerEntry.SetRange("Posting Date", rSalesInvoiceHeader."Posting Date");
        rCustLedgerEntry.SetRange("Document Type", rCustLedgerEntry."document type"::Bill);
        rCustLedgerEntry.FindSet; // Si no encuentra nada aquí, hay algún problema con la estructuración del código, posiblemente haya que revisar la función "GetUniqueDueDate"
        i := 0;
        repeat
            i += 1;
            // Escribimos la línea
            EDILineTxt := '';
            WriteTextField('SINCV', EDILineTxt, 6);                             // 001 - Tipo registro
            WriteIntegerField(i, EDILineTxt, 6);                                // 007 - Número vencimiento
            WriteDateField(rCustLedgerEntry."Due Date", EDILineTxt, 8);         // 013 - Fecha vencimiento
            WriteDecimalVarField(rCustLedgerEntry.Amount, EDILineTxt, 18, 3);   // 021 - Importe sujeto al vencimiento
            // Comprobación de longitud
            if (StrLen(EDILineTxt) <> 38) then
                Error('La línea de tipo SINCV tiene una longitud distinta a la esperada (esperada 38, real ' + Format(StrLen(EDILineTxt)) + ')');
            OStream.WriteText(EDILineTxt);
            OStream.WriteText; // Salto de línea
        until rCustLedgerEntry.Next = 0;
    end;

    local procedure CreateInvoiceSINCLLine(rEDIEDIEntry: Record "EDI - EDI Entry"; var OStream: OutStream)
    var
        EDILineTxt: Text;
        rItemReference: Record "Item Reference";
        rItemId: Record "Item Identifier";
        rCustomer: Record Customer;
        rSalesInvoiceHeader: Record "Sales Invoice Header";
        rSalesInvoiceLine: Record "Sales Invoice Line";
        rVATPostingSetup: Record "VAT Posting Setup";
        //LineOrderNo: Code[20];
        rSalesShipmentHeader: Record "Sales Shipment Header";
        rSalesHeader: Record "Sales Header";
        ShipmentNo: Code[20];
        OrderNo: Code[20];
        ReferenceNo: Code[50];
    begin
        rEDIEDIEntry.TestField("Document Nos.");
        rEDIEDIEntry.TestField("Document type", rEDIEDIEntry."document type"::Invoice);
        rSalesInvoiceHeader.Reset;
        rSalesInvoiceHeader.Get(rEDIEDIEntry."Document Nos.");
        rSalesInvoiceHeader.TestField("Prices Including VAT", false);
        ShipmentNo := GetShipmentNo(rSalesInvoiceHeader);
        rSalesShipmentHeader.Get(ShipmentNo);
        OrderNo := rSalesShipmentHeader."Order No.";
        rSalesHeader.Get(rSalesHeader."Document Type"::Order, OrderNo);

        rSalesInvoiceLine.Reset;
        rSalesInvoiceLine.SetRange("Document No.", rEDIEDIEntry."Document Nos.");
        rSalesInvoiceLine.SetFilter(Quantity, '<>0');
        rSalesInvoiceLine.FindSet; // Si alguna vez peta esto, tenemos un problema :-)
        repeat
            if not (rSalesInvoiceLine.Type in [rSalesInvoiceLine.Type::Item, rSalesInvoiceLine.Type::"G/L Account"]) then
                Error('En la factura ' + rSalesInvoiceHeader."No." + ' hay líneas de tipo ' + Format(rSalesInvoiceLine.Type) + '. Póngase en contacto con el administrador del sistema'); // Cómo transmitimos líneas de tipo cuenta?
            rCustomer.Reset;
            rCustomer.Get(rSalesInvoiceLine."Sell-to Customer No.");
            //Lectura del producto del cliente.
            Clear(ReferenceNo);
            rItemReference.Reset;
            rItemReference.SetRange("Item No.", rSalesInvoiceLine."No.");
            rItemReference.SetRange(rItemReference."Reference Type No.", rCustomer."No.");
            //>> BBT 11/07/2025 No es obligatorio tener la refrencia cruzada
            //if not rItemReference.FindFirst then
            //    Error('Falta el codigo producto %1 del cliente %2', rSalesInvoiceLine."No.", rCustomer."No.");
            if rItemReference.FindFirst then
                ReferenceNo := rItemReference."Reference No.";
            //<<
            /*
            LineOrderNo := '';
            if rSalesInvoiceHeader."Order No." = '' then begin
                if rSalesInvoiceLine."Shipment No." <> '' then begin
                    rSalesShipmentHeader.Reset;
                    rSalesShipmentHeader.Get(rSalesInvoiceLine."Shipment No.");
                    LineOrderNo := rSalesShipmentHeader."External Document No.";
                end;
            end
            else begin
                rSalesShipmentHeader.Reset;
                rSalesShipmentHeader.SetRange("Order No.", rSalesInvoiceHeader."Order No.");
                if rSalesShipmentHeader.FindLast then;
                // No asignamos la variable de "LineOrderNo" a propósito
            end;
            */
            rVATPostingSetup.Reset;
            if not rVATPostingSetup.Get(rSalesInvoiceLine."VAT Bus. Posting Group", rSalesInvoiceLine."VAT Prod. Posting Group") then
                Error('No existe la configuración de IVA : %1 - %2', rSalesInvoiceLine."VAT Bus. Posting Group", rSalesInvoiceLine."VAT Prod. Posting Group");
            rVATPostingSetup.TestField("EDI - VAT Type");
            rItemId.Reset;
            rItemId.SetRange(rItemId."Item No.", rSalesInvoiceLine."No.");
            rItemId.SetRange("EAN EDI", true);
            if not rItemId.FindFirst then
                Error('No se encuentra el EAN del producto %1', rSalesInvoiceLine."No.");
            // Escribimos la línea
            EDILineTxt := '';
            WriteTextField('SINCL', EDILineTxt, 6); // 001 - Tipo registro
            WriteIntegerField(rSalesInvoiceLine."Line No.", EDILineTxt, 6); // 007 - Número línea
            WriteTextField(rItemId.Code, EDILineTxt, 15);   // 013 - Código Artículo
            WriteTextField(CopyStr(rSalesInvoiceLine.Description, 1, 35), EDILineTxt, 35);  // 028 - Descripción artículo
            case rSalesInvoiceLine.Type of      // 063 - Tipo Artículo
                rSalesInvoiceLine.Type::"G/L Account":
                    WriteTextField('S', EDILineTxt, 1);        // S : Servicio
                rSalesInvoiceLine.Type::Item:
                    WriteTextField('M', EDILineTxt, 1);        // M : Mercancia 
                else
                    Error('Se ha especificado un tipo de línea inválida');
            end;
            WriteTextField(rSalesInvoiceLine."No.", EDILineTxt, 15); // 064 - Código interno artículo proveedor
            WriteTextField(ReferenceNo, EDILineTxt, 15); // 079 - Código interno artículo cliente
            WriteTextField('', EDILineTxt, 15); // 094 - Código variable promocional
            WriteTextField('', EDILineTxt, 15); // 109 - Código unidad expedición (en desuso de acuerdo a la documentación);
            WriteTextField('', EDILineTxt, 15); // 124 - Número de lote
            WriteDecimalVarField(rSalesInvoiceLine.Quantity, EDILineTxt, 16, 3); // 139 - Cantidad facturada
            WriteDecimalVarField(0, EDILineTxt, 16, 3); // 155 - Cantidad bonificada
            WriteTextField('PCE', EDILineTxt, 6); // 171 - Unidad medida
            WriteDecimalVarField(0, EDILineTxt, 16, 3); // 177 - Unidades Entregadas: Se usará solo para indicar en productos de peso variable, la cantidad de unidades entregadas.
            WriteDecimalVarField(0, EDILineTxt, 16, 3); // 193 - Unidades de consumo en u. expedición
            WriteDecimalVarField(rSalesInvoiceLine."Line Amount", EDILineTxt, 18, 3); // 209 - Importe total neto de la línea                                                                                   
            WriteDecimalVarField(ROUND(rSalesInvoiceLine.Amount / rSalesInvoiceLine.Quantity, 0.001), EDILineTxt, 16, 4); // 227 - Precio bruto unitario
            WriteDecimalVarField(ROUND(rSalesInvoiceLine.Amount / rSalesInvoiceLine.Quantity, 0.001), EDILineTxt, 16, 4); // 243 - Precio neto unitario
            if (rCustomer."SMG Purchase Group" = 'FEDEFARMA') or //FEDERACIO FARMACEUTICA
               (rCustomer."No." = 'C01865') or                   //EROSKI S.COOP    
               (rCustomer."SMG Platform" = 'LM') then            //BCM BRICOLAGE S.A (LM Portugal)
                WriteTextField('', EDILineTxt, 6)
            else
                WriteTextField(rSalesInvoiceLine."Unit of Measure Code", EDILineTxt, 6); // 259 - Unidad medida precio
            case rVATPostingSetup."EDI - VAT Type" of   // 265 - Calificador IVA/IGIG
                rVATPostingSetup."edi - vat type"::IGI:
                    WriteTextField('IGI', EDILineTxt, 6);
                rVATPostingSetup."edi - vat type"::VAT:
                    WriteTextField('VAT', EDILineTxt, 6);
                else
                    Error('Opción inválida para la configuración de IVA ' + rVATPostingSetup.GetFilters);
            end;
            WriteDecimalVarField(rSalesInvoiceLine."VAT %", EDILineTxt, 6, 2); // 271 - % Impuesto IVA/IGIG
            WriteDecimalVarField(rSalesInvoiceLine."Amount Including VAT" - rSalesInvoiceLine.Amount, EDILineTxt, 18, 3); // 277 - Importe Impuesto IVA/IGIG
            WriteDecimalVarField(0, EDILineTxt, 6, 2); // 295 - % Recargo equivalencia
            WriteDecimalVarField(0, EDILineTxt, 18, 2); // 301 - Importe recargo equivalencia
            WriteTextField('', EDILineTxt, 6); // 319 - Calificador otro tipo impuesto
            WriteDecimalVarField(0, EDILineTxt, 6, 2); // 325 - % Otro tipo de impuesto
            WriteDecimalVarField(0, EDILineTxt, 18, 3); // 331 - Importe otro tipo de impuesto
            WriteTextField(rSalesHeader."External Document No.", EDILineTxt, 17); // 349 - Número pedido
            WriteTextField(CopyStr(rSalesShipmentHeader."No.", 5, 6), EDILineTxt, 17); // 366 - Número albarán
            WriteIntegerField(0, EDILineTxt, 8);    // 383 - Número embalajes
            WriteTextField('', EDILineTxt, 7);      // 391 - Tipo Embalajes
            WriteDecimalVarField(0, EDILineTxt, 18, 3); // 398 - Importe total bruto de la línea de detalle - Utilizado para packs multireferencia
            WriteIntegerField(0, EDILineTxt, 6); // 416 - Número de línea superior
            WriteIntegerField(rSalesInvoiceLine."Line No.", EDILineTxt, 6); // 422 - Número de línea del pedido
            WriteDecimalVarField(0, EDILineTxt, 10, 3); // 428 - Unidad base precio
            WriteTextField(rSalesInvoiceLine."EDI - Item ID/Order Line", EDILineTxt, 15); // 438 - Identificador producto/línea de pedido (MP) (Solo para Carrefour??)
            WriteTextField('', EDILineTxt, 15); // 453 - Categoría producto
            WriteTextField('', EDILineTxt, 35); // 468 - Número artículo fabricante
            WriteTextField('', EDILineTxt, 17); // 503 - Número confirmación entrega
            WriteIntegerField(0, EDILineTxt, 6); // 520 - Número línea conf. entrega
            WriteDateField(rSalesHeader."Document Date", EDILineTxt, 8);    // 526 - Fecha Pedido
            WriteDateField(rSalesShipmentHeader."Posting Date", EDILineTxt, 8); // 534 - Fecha Albarán
            // Comprobación de longitud
            if (StrLen(EDILineTxt) <> 541) then
                Error('La línea de tipo SINCL tiene una longitud distinta a la esperada (esperada 541, real ' + Format(StrLen(EDILineTxt)) + ')');
            OStream.WriteText(EDILineTxt);
            OStream.WriteText; // Salto de línea
                               //CreateInvoiceSINCELine(SalesInvoiceLine,OStream);
        until rSalesInvoiceLine.Next = 0;
    end;


    local procedure CreateInvoiceSINCELine(rSalesInvoiceLine: Record "Sales Invoice Line"; var OStream: OutStream)
    var
        EDILineTxt: Text;
        rVATPostingSetup: Record "VAT Posting Setup";
    begin
        if rSalesInvoiceLine."Line Discount %" = 0 then exit;
        // Escribimos la línea
        EDILineTxt := '';
        WriteTextField('SINCE', EDILineTxt, 6); // 001 - Tipo registro
        WriteIntegerField(1, EDILineTxt, 2); // 007 - Nº descuento/cargo
        WriteTextField('A', EDILineTxt, 1); // 009 -Indicador dto/cargo
        WriteIntegerField(1, EDILineTxt, 3); // 010 - Secuencia cálculo
        WriteDecimalVarField(rSalesInvoiceLine."Line Discount %", EDILineTxt, 9, 4); // 013 - % Dto
        WriteDecimalVarField(rSalesInvoiceLine."Line Discount Amount", EDILineTxt, 18, 3); // 022 - Importe dto
        WriteDecimalVarField(rSalesInvoiceLine.Amount + rSalesInvoiceLine."Line Discount Amount", EDILineTxt, 18, 3); // 040 - Importe total sujeto a aplicación
        WriteDecimalVarField(rSalesInvoiceLine.Quantity, EDILineTxt, 16, 3); // 058 - Cantidad de unidades descontadas
        WriteTextField('', EDILineTxt, 6); // 074 - Tipo Descuento/Cargo  
        WriteDecimalVarField(ROUND(rSalesInvoiceLine."Line Discount Amount" / rSalesInvoiceLine.Quantity, 0.001), EDILineTxt, 19, 3); // 080 - Descuentos Monetarios por Unidad
        WriteTextField(rSalesInvoiceLine."Unit of Measure Code", EDILineTxt, 6); // 099 - Unidad de Medida 
        WriteTextField('', EDILineTxt, 35); // 105 - Descripción Descuento/Cargo
        WriteTextField('', EDILineTxt, 35); // 140 - Letra Régimen si Exento Impuesto Plásticos 
        // Comprobación de longitud
        if (StrLen(EDILineTxt) <> 174) then
            Error('La línea de tipo SINCE tiene una longitud distinta a la esperada (esperada 139, real ' + Format(StrLen(EDILineTxt)) + ')');
        OStream.WriteText(EDILineTxt);
        OStream.WriteText; // Salto de línea
    end;

    local procedure CreateInvoiceSINCILine(rEDIEDIEntry: Record "EDI - EDI Entry"; var OStream: OutStream)
    var
        EDILineTxt: Text;
        rSalesInvoiceHeader: Record "Sales Invoice Header";
        rSalesInvoiceLine: Record "Sales Invoice Line";
        rTempVATAmountLine: Record "VAT Amount Line" temporary;
        i: Integer;
        rVATPostingSetup: Record "VAT Posting Setup";
    begin

        rEDIEDIEntry.TestField("Document Nos.");
        rEDIEDIEntry.TestField("Document type", rEDIEDIEntry."document type"::Invoice);
        if not rTempVATAmountLine.IsTemporary then
            Error('Esta variable debe ser temporal');
        rSalesInvoiceHeader.Reset;
        rSalesInvoiceHeader.Get(rEDIEDIEntry."Document Nos.");
        rSalesInvoiceLine.Reset;
        rSalesInvoiceLine.SetRange("Document No.", rSalesInvoiceHeader."No.");
        rSalesInvoiceLine.FindSet;
        rSalesInvoiceLine.CalcVATAmountLines(rSalesInvoiceHeader, rTempVATAmountLine);
        rTempVATAmountLine.Reset;
        rTempVATAmountLine.FindSet; // Siempre deberíamos encontrar algo
        repeat
            i += 1;
            rVATPostingSetup.Reset;
            rVATPostingSetup.SetRange("VAT Identifier", rTempVATAmountLine."VAT Identifier");
            rVATPostingSetup.SetRange("VAT Calculation Type", rTempVATAmountLine."VAT Calculation Type");
            //VATPostingSetup.SETRANGE("Tax Category",TempVATAmountLine."Tax Category");
            if rTempVATAmountLine."VAT Calculation Type" = rTempVATAmountLine."vat calculation type"::"Normal VAT" then
                rVATPostingSetup.SetRange("VAT %", rTempVATAmountLine."VAT %");
            rVATPostingSetup.SetRange("VAT Bus. Posting Group", rSalesInvoiceHeader."VAT Bus. Posting Group");
            /////////////////////rVATPostingSetup.SetRange("VAT Prod. Posting Group",r);
            //>> 14/07/2025 BBT Sin Fundamento
            //rVATPostingSetup.SetRange("VAT Clause Code", rTempVATAmountLine."VAT Clause Code");
            //<<
            if not rVATPostingSetup.FindSet then
                Error('No existe la configuraciones de IVA con los criterios :' + rVATPostingSetup.GetFilters);
            if rVATPostingSetup.Count > 1 then
                Error('Documento %1 con criterios coincidentes en la Config. de IVA %2', rSalesInvoiceHeader."No.", rVATPostingSetup.GetFilters);

            rVATPostingSetup.TestField("EDI - VAT Type"); // Podriamos añadir el EDI-VAT Type al filtro de la rVATPostingSetup

            // Escribimos la línea
            EDILineTxt := '';
            WriteTextField('SINCI', EDILineTxt, 6);                                     // 001 - Tipo registro
            WriteIntegerField(i, EDILineTxt, 2);                                        // 007 - Número línea impuesto
            case rVATPostingSetup."EDI - VAT Type" of                                   // 009 - Calificador Tipo de Impuesto 
                rVATPostingSetup."edi - vat type"::EXT:
                    WriteTextField('EXT', EDILineTxt, 6);
                rVATPostingSetup."edi - vat type"::IGI:
                    WriteTextField('IGI', EDILineTxt, 6);
                rVATPostingSetup."edi - vat type"::VAT:
                    WriteTextField('VAT', EDILineTxt, 6);
                else
                    Error('Tipo IVA no contemplado');
            end;
            WriteDecimalVarField(rTempVATAmountLine."VAT %", EDILineTxt, 6, 2);         // 015 - % Tipo de Impuesto
            WriteDecimalVarField(rTempVATAmountLine."VAT Amount", EDILineTxt, 18, 3);   // 021 - Importe Tipo de Impuesto    
            WriteDecimalVarField(rTempVATAmountLine."VAT Base", EDILineTxt, 18, 3);     // 039 - Base Imponible
            WriteTextField('', EDILineTxt, 1);                                          // 057 - Indicador Exento Impuesto (E) - [Rev7– Impuesto plástico no reutilizable]
            // Comprobación de longitud
            if (StrLen(EDILineTxt) <> 57) then
                Error('La línea de tipo SINCI tiene una longitud distinta a la esperada (esperada 56, real ' + Format(StrLen(EDILineTxt)) + ')');
            OStream.WriteText(EDILineTxt);
            OStream.WriteText; // Salto de línea
        until rTempVATAmountLine.Next = 0;

    end;
    //>> BBTT 28/02/2025    Cambio para la obtención del albarán de ventas relacionado con la factura.
    //                      Se utiliza la Value Entry.
    //    local procedure GetShipmentNo(rSalesInvoiceHeader: Record "Sales Invoice Header") SalesShipmentNo: Code[20]
    //    var
    //        rSalesInvoiceLine: Record "Sales Invoice Line";
    //    begin
    //        begin
    //            //CALCFIELDS("Nº albarán");
    //            //>> BBT 02/12/2021
    //            //  IF "Sales Shipment No."='' THEN
    //            rSalesInvoiceHeader.CalcFields("Sales Shipment No");
    //            if rSalesInvoiceHeader."Sales Shipment No" = '' then //<<
    //                Error('No se ha encontrado un albarán relacionado');
    //            exit(rSalesInvoiceHeader."Sales Shipment No");
    //        end;
    //    end;

    local procedure GetShipmentNo(pSalesInvoiceHeader: Record "Sales Invoice Header") ShipmentNo: Code[20]
    var
        ValueEntry: Record "Value Entry";
        ValueEntryAux: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ShipmentNo := '';
        ValueEntryAux.Reset();
        ValueEntryAux.SetCurrentKey("Document No.");
        ValueEntryAux.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
        ValueEntryAux.SetRange("Source Type", ValueEntry."Source Type"::Customer);
        ValueEntryAux.SetRange("Source No.", pSalesInvoiceHeader."Bill-to Customer No.");
        ValueEntryAux.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");
        ValueEntryAux.SetRange("Document No.", pSalesInvoiceHeader."No.");
        if ValueEntryAux.FindFirst() then begin
            ValueEntry.Reset();
            ValueEntry.SetRange("Item Ledger Entry No.", ValueEntryAux."Item Ledger Entry No.");
            ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
            ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Shipment");
            ValueEntry.SetRange("Source Type", ValueEntryAux."Source Type");
            ValueEntry.SetRange("Source No.", ValueEntryAux."Source No.");
            IF ValueEntry.FindFirst() then
                ShipmentNo := ValueEntry."Document No.";

            //>> BBT 12/11/2025. Segunda Oportunidad
            if ShipmentNo = '' then begin
                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Sale);
                ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
                ItemLedgerEntry.SetRange("Entry No.", ValueEntryAux."Item Ledger Entry No.");
                IF ItemLedgerEntry.FindFirst() then
                    ShipmentNo := ItemLedgerEntry."Document No.";
            end;
            //<<
        end;
    end;
    //<< BBT 28/02/2025
    local procedure GetOrderNo(rSalesInvoiceHeader: Record "Sales Invoice Header") OrderNo: Code[20]
    var
        rSalesHeader: record "Sales Header";

    begin
        //>> BBT 30/01/2025. Cambio en la verificación de pedido de venta EDI
        //           if rSalesInvoiceHeader."Order No." = '' then
        //               Error('No se ha encontrado el pedido relacionado');
        //           exit(rSalesInvoiceHeader."Order No.");
        if rSalesInvoiceHeader."Order No." <> '' then begin
            rSalesHeader.SetRange("Document Type", rSalesHeader."Document Type"::Order);
            rSalesHeader.SetRange("No.", rSalesInvoiceHeader."Order No.");
            rSalesHeader.SetRange("EDI - EDI Order", true);
            if not rSalesHeader.FindFirst then
                Error('El pedido relacionado %1 no es EDI', rSalesInvoiceHeader."Order No.");

        end else
            Error('No se ha encontrado el pedido relacionado');

        exit(rSalesInvoiceHeader."Order No.")
        //<<

    end;

    local procedure GetCurrencyCode(rSalesInvoiceHeader: Record "Sales Invoice Header") OrderNo: Code[20]
    var
        rGeneralLedgerSetup: Record "General Ledger Setup";
    begin
        if rSalesInvoiceHeader."Currency Code" = '' then begin
            rGeneralLedgerSetup.Reset;
            rGeneralLedgerSetup.Get;
            rGeneralLedgerSetup.TestField("LCY Code");
            exit(rGeneralLedgerSetup."LCY Code");
        end
        else
            exit(rSalesInvoiceHeader."Currency Code");
    end;

    local procedure GetUniqueDueDate(rSalesInvoiceHeader: Record "Sales Invoice Header") UniqueDueDate: Date
    var
        rCustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        rCustLedgerEntry.Reset;
        rCustLedgerEntry.SetRange("Document No.", rSalesInvoiceHeader."No.");
        rCustLedgerEntry.SetRange("Posting Date", rSalesInvoiceHeader."Posting Date");
        rCustLedgerEntry.SetRange("Document Type", rCustLedgerEntry."document type"::Bill);
        if rCustLedgerEntry.Count > 1 then
            exit(0D)
        else if rCustLedgerEntry.Count = 1 then begin // Un solo efecto
            rCustLedgerEntry.FindSet;
            exit(rCustLedgerEntry."Due Date");
        end
        else begin // Sin efecto, solo factura
            rCustLedgerEntry.SetRange("Document Type", rCustLedgerEntry."document type"::Invoice);
            rCustLedgerEntry.FindSet;
            exit(rCustLedgerEntry."Due Date");
        end;
    end;

    local procedure GetGrossAmount(rSalesInvoiceHeader: Record "Sales Invoice Header") GrossAmount: Decimal
    var
        rSalesInvoiceLine: Record "Sales Invoice Line";
    begin
        GrossAmount := 0;
        rSalesInvoiceLine.Reset;
        rSalesInvoiceLine.SetRange("Document No.", rSalesInvoiceHeader."No.");
        rSalesInvoiceLine.SetFilter(Quantity, '<>0');
        rSalesInvoiceLine.FindSet;
        repeat
            GrossAmount += rSalesInvoiceLine.Quantity * rSalesInvoiceLine."Unit Price";
        until rSalesInvoiceLine.Next = 0;
    end;

    /**********************************************************************/
    /********************** EDI - CR MEMOS / DEV **************************/
    /**********************************************************************/
    /*
    Tipo   Nombre registro                             Repeticiones
    _____  ________________________________________    _____________
    RECTL Registro de control Obligatorio                     1
    SEH1C Cabecera Obligatorio                                1
    SEH1D Información de partes Obligatorio                   N
    SEH1P Secuencia de embalajes  Obligatorio                 N
    SEH1L Línea de artículos Obligatorio                      N
    SEH1G Desglose cantidad/Localizaciones Opcional           N
    SEH1B Información de lotes Opcional                       N
    */

    local procedure ProcessIncomingInvoices(var EDIEntry: record "EDI - EDI Entry")
    var
        IStream: InStream;
        StreamText: Text;
        ProcessRMA: Boolean;
    begin
        EDIEntry.CalcFields("File Blob");
        EDIEntry."File Blob".CreateInstream(IStream);
        while not IStream.eos do begin
            StreamText := '';
            IStream.ReadText(StreamText);
            // Dependiendo del tipo de línea que venga, la procesamos a su modo
            if StreamText <> '' then
                case CopyStr(StreamText, 1, 5) of // Info de cabecera
                    'RECTL':
                        ProcessRECTL(StreamText, 'INVOIC'); // Registro control
                    'SINCC':
                        ProcessSINCC(StreamText); // Cabecera
                    'SINCP':
                        ProcessSINCP(StreamText); // Información partes
                    'SINCT':
                        ProcessSINCT(StreamText); // Observaciones cabecera
                                                  //'SINCV':
                                                  //'SINCD':
                    'SINCL':
                        ProcessSINCL(StreamText); // Línea detalle
                    'SINCU':
                        ProcessSINCU(StreamText); // Observaciones línea
                                                  //'SINCE':
                    'SINCI':
                        ProcessSINCI(StreamText); // Desglose impuestos
                    else
                        Error('Se está utilizando un tipo de línea no contemplado: ' + CopyStr(StreamText, 1, 5));
                end;
        end;
        Commit;
        //CREO LA CABECERA
        //CreateHeaderOrder();
        CreateHeaderOrderv3(EDIEntry);
        //CREO LAS LINEAS
        //CreateLinesOrder; - Hacemos la creación de las líneas dentro de la creación de la cabecera

    end;

    local procedure ProcessSINCC(StreamText: Text)
    // Lectura de campos
    begin
        TempOrder.Init;
        cont := cont + 1;
        TempOrder."Entry No." := cont;
        TempOrder.Type := 'SINCC';
        TempOrder."RECTL IdentificacionMensaje" := RECTLIdentificacionMensaje; // Para control de documento

        ReadTextField(TempOrder."ERE1C TipoDocumento", StreamText, 7, 3); // Usado
        ReadTextField(TempOrder."ERE1C NumeroPedido", StreamText, 13, 17); // Usado     (13,23)??
        ReadTextField(TempOrder."ERE1C FuncionMensaje", StreamText, 30, 3); // Usado??
        ReadDatetimeField(TempOrder."ERE1C FechaHoraDocumento", StreamText, 36, 12); //Fecha de factura
        ReadDatetimeField(TempOrder."ERE1C FechaHora1", StreamText, 44, 12); // Fecha albarán
        ReadTextField(TempOrder."SINCC Mododepago", StreamText, 60, 6);
        ReadTextField(TempOrder."SINCC RazonDeCargoOAbono", StreamText, 66, 3);
        ReadTextField(TempOrder."SINCC CriterioDeModificacion", StreamText, 69, 3);
        ReadTextField(TempOrder."SINCC NumeroDePedido", StreamText, 72, 17);
        ReadTextField(TempOrder."SINCC NumeroDeAlbaran", StreamText, 89, 17);
        ReadTextField(TempOrder."SINCC CalificadorDocRectificad", StreamText, 106, 3);
        ReadTextField(TempOrder."SINCC NumeroDeContratoAcuerdoC", StreamText, 126, 17);
        ReadTextField(TempOrder."SINCC NumeroRelacionEntrega", StreamText, 143, 17);
        ReadTextField(TempOrder."ERE1C CodigoMoneda", StreamText, 160, 3); // Usado
        ReadDateField(TempOrder."ERE1C FechaVencimientoUnico", StreamText, 166, 8); // Usado
        ReadDecimalField(TempOrder."ERE1C ImporteTotalNeto", StreamText, 174, 18); // Usado
        ReadDecimalField(TempOrder."ERE1C BaseImponible", StreamText, 192, 18); // Usado
        ReadDecimalField(TempOrder."ERE1C ImporteTotalImpuestos", StreamText, 228, 18); // Usado
        ReadDecimalField(TempOrder."ERE1C ImporteAPagar", StreamText, 246, 18); // Usado
        ReadDecimalField(TempOrder."SINCC SubvencionesVinculadasAl", StreamText, 264, 18);
        ReadDecimalField(TempOrder."SINCC TotalIncrementosDelImpor", StreamText, 182, 18);
        ReadDecimalField(TempOrder."SINCC TotalMinoracionesDelImpo", StreamText, 300, 18);
        ReadDecimalField(TempOrder."SINCC PeriodoImposicionesFactu", StreamText, 318, 16); // Verificar datos de aquí
        ReadDateField(TempOrder."SINCC FechaPedido", StreamText, 334, 8);
        ReadDatetimeField(TempOrder."SINCC FechaHoraEfectivaDelServ", StreamText, 342, 12);
        ReadTextField(TempOrder."SINCC NumeroConfirmacionEntreg", StreamText, 354, 17);
        ReadTextField(TempOrder."SINCC NumeroFacturaRefAmpliada", StreamText, 371, 35);
        ReadDecimalField(TempOrder."SINCC ImporteRetenido", StreamText, 406, 18); // Comprobar que esté en blanco en proceso
        TempOrder.Insert;
    end;
    /******************** NO SE ESTA USANDO **********************************************
    Error('Pendiente continuar por aquí');
    //SalesHeader.VALIDATE("Sell-to Customer No.",Customer."No.");
    case TipoDocumento of
        ' ', '':
            SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::" ");
        '220':
            SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"220");
        '221':
            SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"221");
        '224':
            SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"224");
        '226':
            SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"226");
        '227':
            SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"227");
        '22E':
            SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"22E");
        else
            Error('Tipo de documento no reconocido ' + TipoDocumento);
    end;
    SalesHeader.Validate("External Document No.", CopyStr(NumeroPedido, 1, MaxStrLen(SalesHeader."External Document No.")));
    case FuncionMensaje of
        '', ' ':
            SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::" ");
        '6':
            SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"6");
        '7':
            SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"7");
        '9':
            SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"9");
        '16':
            SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"16");
        '31':
            SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"31");
        '42':
            SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"42");
        '46':
            SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"46");
        else
            Error('Función del mensaje no reconocida - ' + FuncionMensaje);
    end;
    case InformacionAdicional of
        '', ' ':
            SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::" ");
        '71E':
            SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"71E");
        '72E':
            SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"72E");
        '73E':
            SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"73E");
        '81E':
            SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"81E");
        '82E':
            SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"82E");
        '83E':
            SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"83E");
        'X42':
            SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X42);
        'X41':
            SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X41);
        'X44':
            SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X44);
        'X45':
            SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X45);
        'X46':
            SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X46);
        'PP2':
            SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::PP2);
        'X17':
            SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X17);
        else
            Error('Información adicional no contemplada ' + InformacionAdicional);
    end;
    case CalificadorReferenciaAdicional of
        '', ' ':
            SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::" ");
        'ATZ':
            SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::ATZ);
        'CR':
            SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::CR);
        'CT':
            SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::CT);
        'IP':
            SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::IP);
        'PD':
            SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::PD);
        'UC':
            SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::UC);
        'ZZZ':
            SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::ZZZ);
        'AAN':
            SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::AAN);
        else
            Error('Calificador de referencia adicional no contemplado ' + CalificadorReferenciaAdicional);
    end;
    if NumeroReferenciaAdicional <> '' then SalesHeader.Validate("EDI - Additional ref No.", CopyStr(NumeroReferenciaAdicional, 1, MaxStrLen(SalesHeader."EDI - Additional ref No.")));
    if CodigoMoneda <> '' then SalesHeader.Validate("EDI - Currency Code", CodigoMoneda);
    if FechaVencimientoUnico <> 0D then SalesHeader.Validate("EDI - Unique due date", FechaVencimientoUnico);
    case MetodoPagoCostesTransportes of
        '', ' ':
            SalesHeader.Validate("EDI - Shipment cost payment", SalesHeader."edi - shipment cost payment"::" ");
        'DF':
            SalesHeader.Validate("EDI - Shipment cost payment", SalesHeader."edi - shipment cost payment"::DF);
        'PC':
            SalesHeader.Validate("EDI - Shipment cost payment", SalesHeader."edi - shipment cost payment"::PC);
        'PP':
            SalesHeader.Validate("EDI - Shipment cost payment", SalesHeader."edi - shipment cost payment"::PP);
        else
            Error('Método pago de costes de transportes no contemplado ' + MetodoPagoCostesTransportes);
    end;
    case CondicionesEntrega of
        '', ' ':
            SalesHeader.Validate("EDI - Delivery condition", SalesHeader."edi - delivery condition"::" ");
        'PD':
            SalesHeader.Validate("EDI - Delivery condition", SalesHeader."edi - delivery condition"::PD);
        'EP':
            SalesHeader.Validate("EDI - Delivery condition", SalesHeader."edi - delivery condition"::EP);
        'DDP':
            SalesHeader.Validate("EDI - Delivery condition", SalesHeader."edi - delivery condition"::DDP);
        else
            Error('Condición de entrega no contemplada ' + CondicionesEntrega);
    //SalesHeader."EDI - Delivery datetime" := "ERE1C FechaHora1";
    end;

end;
******************************************************************/
    local procedure ProcessSINCP(StreamText: Text)
    begin
        cont := cont + 1;
        TempOrder.Init;
        TempOrder."Entry No." := cont;
        // Lectura de campos
        TempOrder.Type := 'SINCP';
        TempOrder."RECTL IdentificacionMensaje" := RECTLIdentificacionMensaje; // Para control de documento
        ReadTextField(TempOrder."ERE1P CalificadorDelInterloc", StreamText, 7, 3);
        ReadTextField(TempOrder."ERE1P CodigoInterlocutor", StreamText, 10, 17);
        ReadTextField(TempOrder."SINCP TipoInterlocutor", StreamText, 27, 3); // Falta el "Tipo interlocutor
        ReadTextField(TempOrder."ERE1P Nombre1", StreamText, 30, 35);
        ReadTextField(TempOrder."ERE1P Nombre2", StreamText, 65, 35);
        ReadTextField(TempOrder."ERE1P Nombre3", StreamText, 100, 35);
        ReadTextField(TempOrder."ERE1P Nombre4", StreamText, 135, 35);
        ReadTextField(TempOrder."ERE1P Nombre5", StreamText, 170, 35);
        ReadTextField(TempOrder."ERE1P CalleNumero1", StreamText, 205, 35);
        ReadTextField(TempOrder."ERE1P CalleNumero2", StreamText, 240, 35);
        ReadTextField(TempOrder."ERE1P CalleNumero3", StreamText, 275, 35);
        ReadTextField(TempOrder."ERE1P CalleNumero4", StreamText, 310, 35);
        ReadTextField(TempOrder."ERE1P Poblacion", StreamText, 345, 35);
        ReadTextField(TempOrder."ERE1P Provincia", StreamText, 380, 9);
        ReadTextField(TempOrder."ERE1P CodigoPostal", StreamText, 389, 9);
        ReadTextField(TempOrder."ERE1P CodigoPais", StreamText, 398, 3);
        ReadTextField(TempOrder."SINCP NumeroDeIdentificacionFi", StreamText, 401, 35);
        ReadTextField(TempOrder."SINCP CodigoAdicional", StreamText, 436, 35);
        ReadTextField(TempOrder."ERE1P FuncionContacto", StreamText, 439, 3);
        ReadTextField(TempOrder."ERE1P DepartamentoOIdentific", StreamText, 474, 17);
        ReadTextField(TempOrder."ERE1P DepartamentoOEmpleado", StreamText, 491, 35);
        ReadTextField(TempOrder."SINCP Telefono", StreamText, 526, 35);
        ReadTextField(TempOrder."SINCP Fax", StreamText, 561, 35);
        ReadTextField(TempOrder."SINCP NumeroCuentaIBAN", StreamText, 596, 35);
        ReadTextField(TempOrder."SINCP RegistroMercantilEmisor", StreamText, 631, 70);
        ReadTextField(TempOrder."SINCP CapitalSocial", StreamText, 701, 35);
        ReadTextField(TempOrder."ERE1P CalificadorReferencia1", StreamText, 736, 3);
        ReadTextField(TempOrder."ERE1P Referencia1", StreamText, 739, 35);
        TempOrder.Insert;
    end;

    local procedure ProcessSINCL(StreamText: Text)
    begin
        cont := cont + 1;
        TempOrder.Init;
        TempOrder."Entry No." := cont;
        // Lectura de campos
        TempOrder.Type := 'SINCL';
        TempOrder."RECTL IdentificacionMensaje" := RECTLIdentificacionMensaje; // Para control de documento
        ReadIntegerField(TempOrder."ERE1L NumeroLineaArticulo", StreamText, 7, 6); // Usado
        ReadTextField(TempOrder."ERE1L CodigoEAN13DUN14Articulo", StreamText, 13, 15); // Usado

        //ReadTextField("ERE1L TipoCodigoArticulo",StreamText,28,3);
        //ReadTextField("ERE1L TipoIdentificacionArt",StreamText,31,17);
        ReadTextField(TempOrder."ERE1L Descripcion1Articulo", StreamText, 28, 35); // Usado
        //ReadTextField("ERE1L Descripcion2Articulo",StreamText,118,70); 
        ReadTextField(TempOrder."ERE1L TipoArticulo", StreamText, 63, 1);
        ReadTextField(TempOrder."ERE1L NumeroArticuloProveedor", StreamText, 64, 15); // Proveedor (SA)
        ReadTextField(TempOrder."ERE1L NumeroArticuloComprador", StreamText, 79, 15); // Cliente (IN)
        ReadTextField(TempOrder."ERE1L VariablePromocional", StreamText, 94, 15); // Usado
        ReadTextField(TempOrder."ERE1L NumeroLote", StreamText, 124, 15); // Usado

        //ReadTextField("ERE1L CodigoEANDelArticuloAdic",StreamText,294,35); // Usado
        ReadDecimalField(TempOrder."ERE1L CantidadPedida", StreamText, 139, 16); // Usado
        ReadDecimalField(TempOrder."ERE1L CantidadBonificada", StreamText, 155, 16); // Usado
        ReadTextField(TempOrder."ERE1L CalificadorUnidadMedida", StreamText, 171, 6); // Usado
        ReadDecimalField(TempOrder."ERE1L NumeroUnidDeConsEnUExped", StreamText, 193, 16);
        //ReadTextField("ERE1L CalificadorFechaHora1",StreamText,383,3);
        //ReadDatetimeField("ERE1L FechaHora1",StreamText,386,12);
        //ReadTextField("ERE1L CalificadorFechaHora2",StreamText,398,3);
        //ReadDatetimeField("ERE1L FechaHora2",StreamText,401,12);
        ReadDecimalField(TempOrder."ERE1L ImporteNetoLinea", StreamText, 209, 18); // Usado
        ReadDecimalField(TempOrder."ERE1L PrecioBrutoUnitario", StreamText, 227, 16); // Usado
        ReadDecimalField(TempOrder."ERE1L PrecioNetoUnitario", StreamText, 243, 16); // Usado

        //ReadDecimalField("ERE1L PrecioATituloInformativo",StreamText,463,16);
        ReadTextField(TempOrder."ERE1L CalifiUDeMedidaPrecio", StreamText, 259, 6); // Usado
        ReadTextField(TempOrder."ERE1L CalificadorIVAIGIC", StreamText, 265, 6); // Usado
        ReadDecimalField(TempOrder."ERE1L PorcentajeIVAIGIC", StreamText, 271, 6); // Usado
        ReadDecimalField(TempOrder."ERE1L ImporteIVAIGIC", StreamText, 277, 18); // Usado
        ReadDecimalField(TempOrder."ERE1L PorRecargoEquivalencia", StreamText, 295, 6); // Usado
        ReadDecimalField(TempOrder."ERE1L ImporteRecargoEquiv", StreamText, 301, 18); // Usado
        ReadTextField(TempOrder."ERE1L CalificadorOtroTipoDeImp", StreamText, 319, 6); // Usado
        ReadDecimalField(TempOrder."ERE1L PorOtroTipoDeImpuesto", StreamText, 325, 6); // Usado
        ReadDecimalField(TempOrder."ERE1L ImporteOtroTipoDeImp", StreamText, 331, 18); // Usado

        //ReadDecimalField("ERE1L PesoNeto",StreamText,569,18); // Usado
        //ReadTextField("ERE1L CalificadorUDeMedidaPeso",StreamText,587,6); // Usado
        //ReadTextField("ERE1L DescripcionDelModelo",StreamText,593,25); // Usado
        //ReadTextField("ERE1L Color",StreamText,618,25); // Usado
        //ReadTextField("ERE1L AnchuraOTalla",StreamText,643,25); // Usado
        //ReadTextField("ERE1L PresentacionCantidadForm",StreamText,668,25);
        //ReadTextField("ERE1L CodigoGrupoArticuloCompr",StreamText,693,35);
        //ReadTextField("ERE1L NumeroSerieArticulo",StreamText,728,35); // Usado
        //ReadTextField("ERE1L NumeroArticuloFabricante",StreamText,763,35); // Usado
        ReadTextField(TempOrder."ERE1L IdentificadorProdLinPed", StreamText, 438, 15); // Usado

        ReadDecimalField(TempOrder."ERE1L CantidadDevuelta", StreamText, 739, 16);  //Usado Devoluciones

        //ReadTextField("ERE1L CalificadorFechaHora3",StreamText,833,3);
        //ReadDatetimeField("ERE1L FechaHora3",StreamText,836,12);
        //ReadDecimalField("ERE1L ImporteLíneaConImpuestos",StreamText,398,18); // Usado Importe total bruto de la línea de detalle
        //ReadIntegerField("ERE1L BasePrecioNetoUnitario",StreamText,866,9); // Usado
        //ReadDecimalField("ERE1L PrecioArticuloConImp",StreamText,875,16); // Usado
        //ReadIntegerField("ERE1L BasePrecioArticuloConImp",StreamText,891,9); // Usado
        //ReadTextField("ERE1L NumeroAlbaran",StreamText,534,17); // Usado
        ReadDateField(TempOrder."ERE1L FechaAlbaran", StreamText, 534, 8); // Usado

        TempOrder.Insert;
    end;

    local procedure ProcessSINCI(StreamText: Text)
    // Lectura de campos
    begin
        cont := cont + 1;
        TempOrder.Init;
        TempOrder."Entry No." := cont;
        TempOrder.Type := 'SINCI';
        TempOrder."RECTL IdentificacionMensaje" := RECTLIdentificacionMensaje; // Para control de documento
        ReadIntegerField(TempOrder."ERE1I NumeroLineaImpuesto", StreamText, 7, 2);
        ReadTextField(TempOrder."ERE1I CalificadorTipoImpuesto", StreamText, 9, 6);
        ReadDecimalField(TempOrder."ERE1I PorImpuesto", StreamText, 15, 6);
        ReadDecimalField(TempOrder."ERE1I ImporteImpuesto", StreamText, 21, 18);
        ReadDecimalField(TempOrder."ERE1I BaseImponible", StreamText, 39, 18);
        TempOrder.Insert;
    end;

    local procedure ProcessSINCT(StreamText: Text)
    // Lectura de campos
    begin
        cont := cont + 1;
        TempOrder.Init;
        TempOrder."Entry No." := cont;
        TempOrder.Type := 'SINCT';
        TempOrder."RECTL IdentificacionMensaje" := RECTLIdentificacionMensaje; // Para control de documento
        ReadTextField(TempOrder."ERE1T CalificadorTemaTexto", StreamText, 7, 6);
        ReadTextField(TempOrder."ERE1T Texto1", StreamText, 13, 70);
        ReadTextField(TempOrder."ERE1T Texto2", StreamText, 83, 70);
        ReadTextField(TempOrder."ERE1T Texto3", StreamText, 153, 70);
        ReadTextField(TempOrder."ERE1T Texto4", StreamText, 223, 70);
        ReadTextField(TempOrder."ERE1T Texto5", StreamText, 293, 70);
        TempOrder.Insert;
    end;

    local procedure ProcessSINCU(StreamText: Text)
    // Lectura de campos
    begin
        cont := cont + 1;
        TempOrder.Init;
        TempOrder."Entry No." := cont;
        TempOrder.Type := 'SINCU';
        TempOrder."RECTL IdentificacionMensaje" := RECTLIdentificacionMensaje; // Para control de documento
        ReadTextField(TempOrder."ERE1T CalificadorTemaTexto", StreamText, 7, 6);
        ReadTextField(TempOrder."ERE1T Texto1", StreamText, 13, 70);
        ReadTextField(TempOrder."ERE1T Texto2", StreamText, 83, 70);
        ReadTextField(TempOrder."ERE1T Texto3", StreamText, 153, 70);
        ReadTextField(TempOrder."ERE1T Texto4", StreamText, 223, 70);
        ReadTextField(TempOrder."ERE1T Texto5", StreamText, 293, 70);
        TempOrder.Insert;
    end;

    local procedure CheckRMA(IStream: InStream): Boolean
    var
        DummyLine: Text;
    begin
        while not IStream.eos do begin
            IStream.ReadText(DummyLine);
            if not IsRMA then IsRMA := (StrPos(DummyLine, ';RMA') <> 0) and (StrPos(DummyLine, 'AAI') <> 0);
            if IsRMA then RMANo := ReadRMANo(DummyLine);
        end;
        exit(RMANo <> '');
    end;

    local procedure CreateHeaderOrderv3(var pEDIEntry: record "EDI - EDI Entry")           // Alta de: Abonos de Ventas - Devoluciones de Ventas
    var
        rEDIDocumentinstallment: Record "EDI - Document installment";
        rEDITemporaryOrdersHeader: Record "EDI - Temporary Orders";
        rCustomer: Record Customer;
        rvendor: Record Vendor;
        rCustomerAddress: Record "Ship-to Address";
        IStream: InStream;
        OStream: OutStream;
        //01//CalificadorDelInterlocBY: Text[10];
        DummyTxt: Text;
        PreviousTxt: Text;
        CalificadorTemaTxt: Text[6];
    begin
        // Esta v2 incluye la gestión de líneas relacionadas con RECTL dentro de sí
        rEDITemporaryOrdersHeader.Reset;
        rEDITemporaryOrdersHeader.SetRange(Type, 'RECTL');
        if rEDITemporaryOrdersHeader.FindSet then
            repeat
                //rEDITemporaryOrdersHeader.TestField("RECTL CodigoEmisor");
                rEDITemporaryOrdersHeader.TestField("RECTL IdentificacionMensaje");

                /**********************************************************************************/
                //>> BBT 03/02/2025 Verificamos que el cliente (o proveedor) sea correcto
                TempOrderAux.Reset;
                TempOrderAux.SetRange("RECTL IdentificacionMensaje", rEDITemporaryOrdersHeader."RECTL IdentificacionMensaje");
                TempOrderAux.SetFilter("ERE1C TipoDocumento", '<>%1', '');
                if not TempOrderAux.FindSet then   //SOLO  debe de haber un registro 
                    Error('No se encuentra el tipo RECTL. IdentificacionMensaje ' + rEDITemporaryOrdersHeader."RECTL IdentificacionMensaje");

                if TempOrderAux."ERE1C TipoDocumento" <> '380' then begin  // verificar cliente
                    TempOrder.Reset;
                    TempOrder.SetRange("RECTL IdentificacionMensaje", rEDITemporaryOrdersHeader."RECTL IdentificacionMensaje");
                    TempOrder.SetRange(TempOrder."ERE1P CalificadorDelInterloc", 'MS');
                    if not TempOrder.FindFirst then begin
                        TempOrder.SetRange(TempOrder."ERE1P CalificadorDelInterloc", 'SCO');
                        if not TempOrder.FindFirst then
                            Error('No se encuentra el cliente. Error CalificadorDelInterlocutor: MS o SCO');
                    end;
                    rCustomer.Reset;
                    rCustomer.SetRange("Cr Memo EDI", TempOrder."ERE1P CodigoInterlocutor");
                    if rCustomer.FindSet then begin
                        if rCustomer.Count > 1 then
                            Error('Se han encontrado múltiples clientes con el código ' + TempOrder."ERE1P CodigoInterlocutor");

                        if rCustomer.Blocked <> rCustomer.Blocked::" " then
                            Error('El cliente %1 está bloqueado', rCustomer."No.");

                        if rCustomer."No EDI" = true then
                            Error('El cliente %1 no tiene activa la gestión EDI', rCustomer."No.")
                    end
                    else
                        Error('No existe el cliente con Id. EDI de Abonos/Devoluciones ' + TempOrder."ERE1P CodigoInterlocutor");

                    //>> 12/03/2025 Marcamos el registro NAC/PL y actualizamos el código del cliente
                    pEDIEntry.Validate("Source Type", pEDIEntry."Source Type"::Customer);
                    pEDIEntry.Validate("Sourde Id", rCustomer."No.");
                    pEDIEntry.Validate("Source Name", rCustomer."Name");
                    pEDIEntry.Validate("PL Entry", false);
                    if rCustomer."VAT PL" then
                        pEDIEntry.Validate("PL Entry", true);
                    //<<
                end
                else begin  // verificar proveedor . TempOrder."ERE1C TipoDocumento" = '380'
                    TempOrder.Reset;
                    TempOrder.SetRange("RECTL IdentificacionMensaje", rEDITemporaryOrdersHeader."RECTL IdentificacionMensaje");
                    TempOrder.SetRange(TempOrder."ERE1P CalificadorDelInterloc", 'SCO');
                    if not TempOrder.FindFirst then
                        Error('No se encuentra el proveedor. Error CalificadorDelInterlocutor: SCO');
                    if TempOrder."ERE1P CodigoInterlocutor" = '' then
                        Error('No se encuentra el proveedor. CodigoInterlocutor VACIO');
                    // - Buscamos el proveedor (puede ser que en lugar de usar el código emisor se deba usar el receptor)
                    rVendor.Reset;
                    rVendor.SetRange("EDI ID", TempOrder."ERE1P CodigoInterlocutor");
                    if rVendor.FindSet then begin
                        if rVendor.Count > 1 then
                            Error('Se han encontrado múltiples proveedores con el código ' + TempOrder."ERE1P CodigoInterlocutor");

                        if rVendor.Blocked <> rVendor.Blocked::" " then
                            Error('El proveedor %1 está bloqueado', rVendor."No.");
                    end
                    else
                        Error('No se ha podido localizar el proveedor con código ' + TempOrder."ERE1P CodigoInterlocutor");

                    //>> 12/03/2025 Marcamos el registro NAC/PL y actualizamos el código del proveedor
                    pEDIEntry.Validate("Source Type", pEDIEntry."Source Type"::Vendor);
                    pEDIEntry.Validate("Sourde Id", rVendor."No.");
                    pEDIEntry.Validate("Source Name", rVendor."Name");
                    pEDIEntry.Validate("PL Entry", false);
                    if rVendor."VAT PL" then
                        pEDIEntry.Validate("PL Entry", true);
                    //<<
                end;

                //ERE1P CalificadorDelInterloc BY
                //01//CalificadorDelInterlocBY := TempOrder."ERE1P CalificadorDelInterloc";
                //<<
                /**********************************************************************************/

                // Creación cabecera
                Clear(SalesHeader);
                SalesHeader.TestField("No.", ''); // Que no haya pasado por aquí más veces
                Clear(PurchaseHeader);
                PurchaseHeader.TestField("No.", '');

                TempOrder.Reset;
                TempOrder.SetRange("RECTL IdentificacionMensaje", rEDITemporaryOrdersHeader."RECTL IdentificacionMensaje"); // Solo debería haber una coincidencia
                TempOrder.SetFilter("ERE1C TipoDocumento", '<>%1', '');
                TempOrder.FindSet;
                case TempOrder."ERE1C TipoDocumento" of
                    '325':  //FACTURA PROFORMA
                        begin
                            Error('Tipo de documento no contemplado: 325 - Factura Proforma');
                        end;
                    '381':
                        begin
                            Error('Tipo de documento no identificado: 381');
                        end;
                    '383':  //DEVOLUCIONES - ABONOS RAPPELS
                        begin
                            SalesHeader.Init;
                            SalesHeader.Validate("Document Type", SalesHeader."document type"::"Credit Memo");          //ABONO
                            SalesHeader.Validate("Reason Code", '2-CANCELAR');
                            //>>
                            if TempOrder."SINCC RazonDeCargoOAbono" = '78E' then begin
                                SalesHeader.Validate("Document Type", SalesHeader."document type"::"Return Order");      //DEVOLUCION
                                SalesHeader.Validate("Reason Code", '1-DEVOL');
                            end;
                            SalesHeader.Validate("Sell-to Customer No.", rCustomer."No.");
                            //<<
                            SalesHeader.Validate("No.", '');
                            SalesHeader.Insert(true);
                            SalesHeader.TestField("No."); // Debe tener número asignado ya
                            if CreateDocsNo <> '' then
                                CreateDocsNo += '|' + SalesHeader."No."
                            else
                                CreateDocsNo := SalesHeader."No.";

                        end;

                    '380':  //FACTURA COMERCIAL. Colaboraciones - Transportes - Catalogos - Publicidad
                        begin
                            PurchaseHeader.Init;
                            PurchaseHeader.Validate("Document Type", PurchaseHeader."document type"::Invoice);
                            //>>
                            PurchaseHeader.Validate("Buy-from Vendor No.", rVendor."No.");
                            //<<
                            PurchaseHeader.Validate("No.", '');
                            PurchaseHeader.Insert(true); // Debe tener número asignado ya

                            TempOrderAux.Reset;
                            TempOrderAux.SetRange("RECTL IdentificacionMensaje", TempOrder."RECTL IdentificacionMensaje");
                            TempOrderAux.SetRange(Type, 'SINCT');
                            if TempOrderAux.FindFirst then
                                PurchaseHeader.Validate("Your Reference", CopyStr(TempOrderAux."ERE1T Texto1", 1, 35));
                        end;
                    else
                        Error('Tipo Documento no contemplado %1', TempOrder."ERE1C TipoDocumento");
                end;
                //BUSCO DIR ENVIO CLIENTE
                //ERE1P CalificadorDelInterloc DP
                if SalesHeader."No." <> '' then begin
                    case SalesHeader."Document Type" of
                        SalesHeader."document type"::Order:
                            begin
                                TempOrder.Reset;
                                TempOrder.SetRange("RECTL IdentificacionMensaje", rEDITemporaryOrdersHeader."RECTL IdentificacionMensaje");
                                TempOrder.SetRange(TempOrder."ERE1P CalificadorDelInterloc", 'DP');
                                if not TempOrder.FindFirst then
                                    Error('No se encuentra el cliente. Error CalificadorDelInterlocutor DP')
                                //01//if CalificadorDelInterlocBY <> TempOrder."ERE1P CodigoInterlocutor" then begin
                                else begin
                                    rCustomerAddress.Reset;
                                    rCustomerAddress.SetRange("Customer No.", SalesHeader."Sell-to Customer No.");
                                    rCustomerAddress.SetRange("EDI ID", TempOrder."ERE1P CodigoInterlocutor");
                                    if not rCustomerAddress.FindSet then
                                        Error('No se ha encontrado la dirección del cliente con código ' + rCustomerAddress.GetFilter("EDI ID"))
                                    else if rCustomerAddress.Count > 1 then
                                        Error('Se han encontrado múltiples clientes con el código ' + rCustomerAddress.GetFilter("EDI ID") + '. El procesamiento del documento se ha detenido')
                                    else begin
                                        SalesHeader.Validate(SalesHeader."Ship-to Code", rCustomerAddress.Code);
                                        SalesHeader.Modify;
                                    end;
                                end;
                            end;
                        SalesHeader."document type"::"Credit Memo":
                            begin
                                SalesHeader.Validate("Your Reference", TempOrder."SINCC DocumentoRectificado");
                            end;
                        SalesHeader."document type"::"Return Order":
                            begin
                                /****** NO PODEMOS LOCALIZAR EN LA INFORMACION DEL FICHERO LA DIRECCIÓN DE LA DEVOLUCIÓN **********
                                TempOrderAux.Reset;
                                TempOrderAux.SetRange(Type, 'SINCP');
                                TempOrderAux.SetRange("RECTL IdentificacionMensaje", rEDITemporaryOrdersHeader."RECTL IdentificacionMensaje");
                                TempOrderAux.SetRange(TempOrderAux."ERE1P CalificadorDelInterloc", 'BY');
                                if not TempOrderAux.FindFirst then
                                    Error('No se encuentra el cliente. Error CalificadorDelInterlocutor BY')
                                //01//if CalificadorDelInterlocBY <> TempOrderAux."ERE1P CodigoInterlocutor" then begin
                                else begin
                                    rCustomerAddress.Reset;
                                    rCustomerAddress.SetRange("Customer No.", SalesHeader."Sell-to Customer No.");
                                    rCustomerAddress.SetRange("EDI ID", TempOrderAux."ERE1P CodigoInterlocutor");
                                    if not rCustomerAddress.FindSet then
                                        Error('No se ha encontrado la dirección del cliente con código ' + rCustomerAddress.GetFilter("EDI ID"))
                                    else if rCustomerAddress.Count > 1 then
                                        Error('Se han encontrado múltiples clientes con el código ' + rCustomerAddress.GetFilter("EDI ID") + '. El procesamiento del documento se ha detenido')
                                    else begin
                                        SalesHeader.Validate(SalesHeader."Ship-to Code", rCustomerAddress.Code);
                                        SalesHeader.Modify;
                                    end;
                                end;
                                ********************************************/
                                // Por defecto el transporte de las devoluciones se gestiona con STI
                                if SalesHeader."No." <> '' then begin
                                    SalesHeader.Validate("Shipping Agent Code", 'STI');
                                    SalesHeader.Modify;
                                end;
                            end;
                        else
                            Error('Tipo de documento no soportado ' + Format(SalesHeader."Document Type"));
                    end;

                end
                else begin
                    PurchaseHeader.TestField("No.");
                    TempOrderAux.Reset;
                    TempOrderAux.SetRange("RECTL IdentificacionMensaje", rEDITemporaryOrdersHeader."RECTL IdentificacionMensaje");
                    TempOrderAux.SetRange(Type, 'SINCC');
                    if TempOrderAux.FindFirst then
                        PurchaseHeader.Validate("Vendor Invoice No.", TempOrderAux."ERE1C NumeroPedido");
                end;
                //
                //
                TempOrder.Reset;
                TempOrder.SetRange("RECTL IdentificacionMensaje", rEDITemporaryOrdersHeader."RECTL IdentificacionMensaje");
                TempOrder.SetFilter(TempOrder."ERE1C TipoDocumento", '<>%1', '');
                if TempOrder.FindFirst then begin
                    begin
                        if SalesHeader."No." <> '' then begin
                            SalesHeader.Validate("EDI - Delivery datetime", TempOrder."ERE1C FechaHora1");
                            case TempOrder."ERE1C TipoDocumento" of
                                ' ', '':
                                    SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::" ");
                                '220':
                                    SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"220");
                                '221':
                                    SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"221");
                                '224':
                                    SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"224");
                                '226':
                                    SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"226");
                                '227':
                                    SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"227");
                                '22E':
                                    SalesHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::"22E");
                                '381', '383', '325', '380': // Ver si es necesario el tipo de abono
                                    begin
                                    end;
                                else
                                    Error('Tipo de documento no reconocido ' + TempOrder."ERE1C TipoDocumento");
                            end;

                            SalesHeader.Validate("External Document No.", CopyStr(TempOrder."ERE1C NumeroPedido", 1, MaxStrLen(SalesHeader."External Document No.")));

                            case TempOrder."ERE1C FuncionMensaje" of
                                '', ' ':
                                    SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::" ");
                                '6':
                                    SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"6");
                                '7':
                                    SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"7");
                                '9':
                                    SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"9");
                                '16':
                                    SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"16");
                                '31':
                                    SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"31");
                                '42':
                                    SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"42");
                                '46':
                                    SalesHeader.Validate("EDI - Message function", SalesHeader."edi - message function"::"46");
                            //ELSE
                            //  ERROR('Función del mensaje no reconocida - '+"ERE1C FuncionMensaje");
                            end;
                            case TempOrder."ERE1C InformacionAdicional" of
                                '', ' ':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::" ");
                                '71E':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"71E");
                                '72E':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"72E");
                                '73E':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"73E");
                                '81E':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"81E");
                                '82E':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"82E");
                                '83E':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::"83E");
                                'X42':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X42);
                                'X41':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X41);
                                'X44':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X44);
                                'X45':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X45);
                                'X46':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X46);
                                'PP2':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::PP2);
                                'X17':
                                    SalesHeader.Validate("EDI - Additional info", SalesHeader."edi - additional info"::X17);
                            //    else
                            //        Error('Información adicional no contemplada ' + TempOrder."ERE1C InformacionAdicional");
                            end;
                            case TempOrder."ERE1C CalificadorReferenciaAdi" of
                                '', ' ':
                                    SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::" ");
                                'ATZ':
                                    SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::ATZ);
                                'CR':
                                    SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::CR);
                                'CT':
                                    SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::CT);
                                'IP':
                                    SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::IP);
                                'PD':
                                    SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::PD);
                                'UC':
                                    SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::UC);
                                'AAN':
                                    SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::AAN);
                                'ZZZ':
                                    SalesHeader.Validate("EDI - Additional ref type", SalesHeader."edi - additional ref type"::ZZZ);
                            //    else
                            //        Error('Calificador de referencia adicional no contemplado ' + TempOrder."ERE1C CalificadorReferenciaAdi");
                            end;
                            if TempOrder."ERE1C NumeroReferenciaAdi" <> '' then SalesHeader.Validate("EDI - Additional ref No.", CopyStr(TempOrder."ERE1C NumeroReferenciaAdi", 1, MaxStrLen(SalesHeader."EDI - Additional ref No.")));
                            if TempOrder."ERE1C CodigoMoneda" <> '' then SalesHeader.Validate("EDI - Currency Code", TempOrder."ERE1C CodigoMoneda");
                            if TempOrder."ERE1C FechaVencimientoUnico" <> 0D then SalesHeader.Validate("EDI - Unique due date", TempOrder."ERE1C FechaVencimientoUnico");
                            case TempOrder."ERE1C MetodoPagoCostesTransp" of
                                '', ' ':
                                    SalesHeader.Validate("EDI - Shipment cost payment", SalesHeader."edi - shipment cost payment"::" ");
                                'DF':
                                    SalesHeader.Validate("EDI - Shipment cost payment", SalesHeader."edi - shipment cost payment"::DF);
                                'PC':
                                    SalesHeader.Validate("EDI - Shipment cost payment", SalesHeader."edi - shipment cost payment"::PC);
                                'PP':
                                    SalesHeader.Validate("EDI - Shipment cost payment", SalesHeader."edi - shipment cost payment"::PP);
                            //    else
                            //        Error('Método pago de costes de transportes no contemplado ' + TempOrder."ERE1C MetodoPagoCostesTransp");
                            end;
                            case TempOrder."ERE1C CondicionesEntrega" of
                                '', ' ':
                                    SalesHeader.Validate("EDI - Delivery condition", SalesHeader."edi - delivery condition"::" ");
                                'PD':
                                    SalesHeader.Validate("EDI - Delivery condition", SalesHeader."edi - delivery condition"::PD);
                                'EP':
                                    SalesHeader.Validate("EDI - Delivery condition", SalesHeader."edi - delivery condition"::EP);
                                'DDP':
                                    SalesHeader.Validate("EDI - Delivery condition", SalesHeader."edi - delivery condition"::DDP);
                            //    else
                            //        Error('Condición de entrega no contemplada ' + TempOrder."ERE1C CondicionesEntrega");
                            end;
                            SalesHeader.Validate("EDI - Total Amount", TempOrder."ERE1C ImporteTotalNeto");
                            SalesHeader.Validate("EDI - Total discount/charges", TempOrder."ERE1C ImporteTotalDtosCargos");
                            SalesHeader.Validate("EDI - Amount Base", TempOrder."ERE1C BaseImponible");
                            SalesHeader.Validate("EDI - Taxes amt.", TempOrder."ERE1C ImporteTotalImpuestos");
                            SalesHeader.Validate("EDI - Paying amt.", TempOrder."ERE1C ImporteAPagar");
                            SalesHeader.Validate("EDI - Gross amt.", TempOrder."ERE1C ImporteTotalBruto");
                            SalesHeader.Validate("EDI - EDI Order", true);
                            if SalesHeader."Document Type" = SalesHeader."document type"::"Credit Memo" then
                                SalesHeader.Validate(SalesHeader."Invoice Disc. Code", '');
                            SalesHeader.Modify(true);
                        end
                        else begin
                            PurchaseHeader.TestField("No.");
                            PurchaseHeader.Validate("EDI - Delivery datetime", TempOrder."ERE1C FechaHora1");
                            case TempOrder."ERE1C TipoDocumento" of
                                ' ', '':
                                    PurchaseHeader.Validate("EDI - Order Type", SalesHeader."edi - order type"::" ");
                                '220':
                                    PurchaseHeader.Validate("EDI - Order Type", PurchaseHeader."edi - order type"::"220");
                                '221':
                                    PurchaseHeader.Validate("EDI - Order Type", PurchaseHeader."edi - order type"::"221");
                                '224':
                                    PurchaseHeader.Validate("EDI - Order Type", PurchaseHeader."edi - order type"::"224");
                                '226':
                                    PurchaseHeader.Validate("EDI - Order Type", PurchaseHeader."edi - order type"::"226");
                                '227':
                                    PurchaseHeader.Validate("EDI - Order Type", PurchaseHeader."edi - order type"::"227");
                                '22E':
                                    PurchaseHeader.Validate("EDI - Order Type", PurchaseHeader."edi - order type"::"22E");
                                '381', '383', '325', '380': // Ver si es necesario el tipo de abono
                                    begin
                                    end;
                                else
                                    Error('Tipo de documento no reconocido ' + TempOrder."ERE1C TipoDocumento");
                            end;
                            PurchaseHeader.Validate("Your Reference", CopyStr(TempOrder."ERE1C NumeroPedido", 1, MaxStrLen(PurchaseHeader."Your Reference")));
                            case TempOrder."ERE1C FuncionMensaje" of
                                '', ' ':
                                    PurchaseHeader.Validate("EDI - Message function", PurchaseHeader."edi - message function"::" ");
                                '6':
                                    PurchaseHeader.Validate("EDI - Message function", PurchaseHeader."edi - message function"::"6");
                                '7':
                                    PurchaseHeader.Validate("EDI - Message function", PurchaseHeader."edi - message function"::"7");
                                '9':
                                    PurchaseHeader.Validate("EDI - Message function", PurchaseHeader."edi - message function"::"9");
                                '16':
                                    PurchaseHeader.Validate("EDI - Message function", PurchaseHeader."edi - message function"::"16");
                                '31':
                                    PurchaseHeader.Validate("EDI - Message function", PurchaseHeader."edi - message function"::"31");
                                '42':
                                    PurchaseHeader.Validate("EDI - Message function", PurchaseHeader."edi - message function"::"42");
                                '46':
                                    PurchaseHeader.Validate("EDI - Message function", PurchaseHeader."edi - message function"::"46");
                            //ELSE
                            //  ERROR('Función del mensaje no reconocida - '+"ERE1C FuncionMensaje");
                            end;
                            case TempOrder."ERE1C InformacionAdicional" of
                                '', ' ':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::" ");
                                '71E':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::"71E");
                                '72E':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::"72E");
                                '73E':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::"73E");
                                '81E':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::"81E");
                                '82E':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::"82E");
                                '83E':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::"83E");
                                'X42':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::X42);
                                'X41':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::X41);
                                'X44':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::X44);
                                'X45':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::X45);
                                'X46':
                                    PurchaseHeader.Validate("EDI - Additional info", PurchaseHeader."edi - additional info"::X46);
                            //    else
                            //        Error('Información adicional no contemplada ' + TempOrder."ERE1C InformacionAdicional");
                            end;
                            case TempOrder."ERE1C CalificadorReferenciaAdi" of
                                '', ' ':
                                    PurchaseHeader.Validate("EDI - Additional ref type", PurchaseHeader."edi - additional ref type"::" ");
                                'ATZ':
                                    PurchaseHeader.Validate("EDI - Additional ref type", PurchaseHeader."edi - additional ref type"::ATZ);
                                'CR':
                                    PurchaseHeader.Validate("EDI - Additional ref type", PurchaseHeader."edi - additional ref type"::CR);
                                'CT':
                                    PurchaseHeader.Validate("EDI - Additional ref type", PurchaseHeader."edi - additional ref type"::CT);
                                'IP':
                                    PurchaseHeader.Validate("EDI - Additional ref type", PurchaseHeader."edi - additional ref type"::IP);
                                'PD':
                                    PurchaseHeader.Validate("EDI - Additional ref type", PurchaseHeader."edi - additional ref type"::PD);
                                'UC':
                                    PurchaseHeader.Validate("EDI - Additional ref type", PurchaseHeader."edi - additional ref type"::UC);
                                'AAN':
                                    PurchaseHeader.Validate("EDI - Additional ref type", PurchaseHeader."edi - additional ref type"::AAN);
                                'ZZZ':
                                    PurchaseHeader.Validate("EDI - Additional ref type", PurchaseHeader."edi - additional ref type"::ZZZ);
                            //    else
                            //        Error('Calificador de referencia adicional no contemplado ' + TempOrder."ERE1C CalificadorReferenciaAdi");
                            end;
                            if TempOrder."ERE1C NumeroReferenciaAdi" <> '' then
                                PurchaseHeader.Validate("EDI - Additional ref No.", CopyStr(TempOrder."ERE1C NumeroReferenciaAdi", 1, MaxStrLen(PurchaseHeader."EDI - Additional ref No.")));
                            if TempOrder."ERE1C CodigoMoneda" <> '' then
                                PurchaseHeader.Validate("EDI - Currency Code", TempOrder."ERE1C CodigoMoneda");
                            if TempOrder."ERE1C FechaVencimientoUnico" <> 0D then
                                PurchaseHeader.Validate("EDI - Unique due date", TempOrder."ERE1C FechaVencimientoUnico");
                            case TempOrder."ERE1C MetodoPagoCostesTransp" of
                                '', ' ':
                                    PurchaseHeader.Validate("EDI - Shipment cost payment", PurchaseHeader."edi - shipment cost payment"::" ");
                                'DF':
                                    PurchaseHeader.Validate("EDI - Shipment cost payment", PurchaseHeader."edi - shipment cost payment"::DF);
                                'PC':
                                    PurchaseHeader.Validate("EDI - Shipment cost payment", PurchaseHeader."edi - shipment cost payment"::PC);
                                'PP':
                                    PurchaseHeader.Validate("EDI - Shipment cost payment", PurchaseHeader."edi - shipment cost payment"::PP);
                            //    else
                            //        Error('Método pago de costes de transportes no contemplado ' + TempOrder."ERE1C MetodoPagoCostesTransp");
                            end;
                            case TempOrder."ERE1C CondicionesEntrega" of
                                '', ' ':
                                    PurchaseHeader.Validate("EDI - Delivery condition", PurchaseHeader."edi - delivery condition"::" ");
                                'PD':
                                    PurchaseHeader.Validate("EDI - Delivery condition", PurchaseHeader."edi - delivery condition"::PD);
                                'EP':
                                    PurchaseHeader.Validate("EDI - Delivery condition", PurchaseHeader."edi - delivery condition"::EP);
                                'DDP':
                                    PurchaseHeader.Validate("EDI - Delivery condition", PurchaseHeader."edi - delivery condition"::DDP);
                            //    else
                            //        Error('Condición de entrega no contemplada ' + TempOrder."ERE1C CondicionesEntrega");
                            end;
                            PurchaseHeader.Validate("EDI - Total Amount", TempOrder."ERE1C ImporteTotalNeto");
                            PurchaseHeader.Validate("EDI - Total discount/charges", TempOrder."ERE1C ImporteTotalDtosCargos");
                            PurchaseHeader.Validate("EDI - Amount Base", TempOrder."ERE1C BaseImponible");
                            PurchaseHeader.Validate("EDI - Taxes amt.", TempOrder."ERE1C ImporteTotalImpuestos");
                            PurchaseHeader.Validate("EDI - Paying amt.", TempOrder."ERE1C ImporteAPagar");
                            PurchaseHeader.Validate("EDI - Gross amt.", TempOrder."ERE1C ImporteTotalBruto");
                            PurchaseHeader.Validate("EDI - EDI Order", true);
                            PurchaseHeader.Modify(true);
                        end;
                    end;
                end;
                //REFERENCIAS DEVOLUCION
                //SINCC CALIFICADOR 383
                if SalesHeader."No." <> '' then begin
                    case SalesHeader."Document Type" of
                        SalesHeader."document type"::"Order":
                            begin
                            end;
                        SalesHeader."document type"::"Credit Memo":
                            begin
                            end;
                        SalesHeader."document type"::"Return Order":
                            begin
                                TempOrder.Reset;
                                TempOrder.SetRange("Type", 'SINCC');
                                TempOrder.SetRange(TempOrder."ERE1C TipoDocumento", '383');
                                TempOrder.SetRange("RECTL IdentificacionMensaje", rEDITemporaryOrdersHeader."RECTL IdentificacionMensaje");
                                if not TempOrder.FindFirst then
                                    Error('No existe el tipo Documento 383 para la Devolución');

                                SalesHeader.Validate("External Document No.", TempOrder."SINCC NumeroDePedido");
                                SalesHeader.Validate("Your Reference", TempOrder."ERE1C NumeroPedido");

                                if SalesHeader."Sell-to Customer No." = 'C00594' then begin     // DEVOLUCIONES CARREFOUR
                                    TempOrder.Reset;
                                    TempOrder.SetRange(Type, 'SINCT');
                                    TempOrder.SetRange(TempOrder."ERE1T CalificadorTemaTexto", 'ACE');
                                    TempOrder.SetRange("RECTL IdentificacionMensaje", rEDITemporaryOrdersHeader."RECTL IdentificacionMensaje");
                                    if TempOrder.FindFirst() then
                                        SalesHeader.Validate("External Document No.", CopyStr(TempOrder."ERE1T Texto1", 1, 10));
                                end;
                            end;
                        else
                            Error('Tipo de documento no soportado ' + Format(SalesHeader."Document Type"));
                    end;
                end;
                //
                //
                TempOrder.Reset;
                TempOrder.SetRange("RECTL IdentificacionMensaje", rEDITemporaryOrdersHeader."RECTL IdentificacionMensaje");
                TempOrder.SetFilter(TempOrder."ERE1T CalificadorTemaTexto", '<>%1', '');
                if TempOrder.FindFirst then
                    repeat begin
                        if SalesHeader."No." <> '' then begin
                            SalesHeader.CalcFields("EDI - Comments");
                            SalesHeader."EDI - Comments".CreateInstream(IStream); // Primero leemos todos los datos, para no reemplazar
                            while not IStream.eos do begin
                                IStream.Read(DummyTxt);
                                PreviousTxt := PreviousTxt + DummyTxt;
                            end;
                            SalesHeader."EDI - Comments".CreateOutstream(OStream);
                            //OStream.WRITE(PreviousTxt+CalificadorTemaTxt+' '+"ERE1T Texto1"+"ERE1T Texto2"+"ERE1T Texto3"+"ERE1T Texto4"+"ERE1T Texto5"); // Actualizamos la info
                            OStream.Write(DummyTxt + CalificadorTemaTxt + ' ' + TempOrder."ERE1T Texto1" + TempOrder."ERE1T Texto2" + TempOrder."ERE1T Texto3" + TempOrder."ERE1T Texto4" + TempOrder."ERE1T Texto5"); // Actualizamos la info
                            if SalesHeader."Document Type" = SalesHeader."document type"::"Credit Memo" then
                                SalesHeader."Invoice Disc. Code" := '';
                            SalesHeader.Modify(true);
                        end
                        else begin
                            PurchaseHeader.TestField("No.");
                            PurchaseHeader.CalcFields("EDI - Comments");
                            PurchaseHeader."EDI - Comments".CreateInstream(IStream); // Primero leemos todos los datos, para no reemplazar
                            while not IStream.eos do begin
                                IStream.Read(DummyTxt);
                                PreviousTxt := PreviousTxt + DummyTxt;
                            end;
                            PurchaseHeader."EDI - Comments".CreateOutstream(OStream);
                            //OStream.WRITE(PreviousTxt+CalificadorTemaTxt+' '+"ERE1T Texto1"+"ERE1T Texto2"+"ERE1T Texto3"+"ERE1T Texto4"+"ERE1T Texto5"); // Actualizamos la info
                            OStream.Write(DummyTxt + CalificadorTemaTxt + ' ' + TempOrder."ERE1T Texto1" + TempOrder."ERE1T Texto2" + TempOrder."ERE1T Texto3" + TempOrder."ERE1T Texto4" + TempOrder."ERE1T Texto5"); // Actualizamos la info
                            if PurchaseHeader."Document Type" = PurchaseHeader."document type"::"Credit Memo" then
                                PurchaseHeader."Invoice Disc. Code" := '';
                            PurchaseHeader.Modify(true);
                        end;
                    end;
                    until TempOrder.Next = 0;
                //
                // VTOS
                //
                /********* NO HAY VENCIMIENTOS EN ABONS y/o DEVOLUCIONES *******************
                TempOrder.Reset;
                TempOrder.SetRange("RECTL IdentificacionMensaje", rEDITemporaryOrdersHeader."RECTL IdentificacionMensaje");
                TempOrder.SetFilter(TempOrder."ERE1V ContadorVencimiento", '>%1', 0);
                if TempOrder.FindFirst then begin
                    begin
                        rEDIDocumentinstallment.Init;
                        if SalesHeader."No." <> '' then begin
                            case SalesHeader."Document Type" of
                                SalesHeader."document type"::Order:
                                    rEDIDocumentinstallment.Validate("Document Type", rEDIDocumentinstallment."document type"::Order);
                                else
                                    Error('Tipo de documento no contemplado');
                            end;
                            rEDIDocumentinstallment.Validate("Document No.", SalesHeader."No.");
                        end
                        else begin
                            PurchaseHeader.TestField("No.");
                            case PurchaseHeader."Document Type" of
                                PurchaseHeader."document type"::Invoice:
                                    rEDIDocumentinstallment.Validate("Document Type", rEDIDocumentinstallment."document type"::Invoice);
                                else
                                    Error('Tipo de documento no contemplado');
                            end;
                            rEDIDocumentinstallment.Validate("Document No.", PurchaseHeader."No.");
                        end;
                        rEDIDocumentinstallment.Validate("Line No.", TempOrder."ERE1V ContadorVencimiento");
                        case TempOrder."ERE1V ReferenciaTiempoPagoCod" of
                            '', ' ':
                                rEDIDocumentinstallment.Validate("Payment time ref. type", rEDIDocumentinstallment."payment time ref. type"::" ");
                            '5':
                                rEDIDocumentinstallment.Validate("Payment time ref. type", rEDIDocumentinstallment."payment time ref. type"::"5");
                            '29':
                                rEDIDocumentinstallment.Validate("Payment time ref. type", rEDIDocumentinstallment."payment time ref. type"::"29");
                            '66':
                                rEDIDocumentinstallment.Validate("Payment time ref. type", rEDIDocumentinstallment."payment time ref. type"::"66");
                            '68':       // No tenemos el tipo 68 - Asignamos el 29 por defecto.
                                rEDIDocumentinstallment.Validate("Payment time ref. type", rEDIDocumentinstallment."payment time ref. type"::"29");
                            '69':
                                rEDIDocumentinstallment.Validate("Payment time ref. type", rEDIDocumentinstallment."payment time ref. type"::"69");
                            '81':
                                rEDIDocumentinstallment.Validate("Payment time ref. type", rEDIDocumentinstallment."payment time ref. type"::"81");
                            else
                                Error('Referencia tiempo pago no contemplada ' + TempOrder."ERE1V ReferenciaTiempoPagoCod");
                        end;
                        case TempOrder."ERE1V RelacionTiempoCodificado" of
                            '', ' ':
                                rEDIDocumentinstallment.Validate("Time relation type", rEDIDocumentinstallment."time relation type"::" ");
                            '1':
                                rEDIDocumentinstallment.Validate("Time relation type", rEDIDocumentinstallment."time relation type"::"1");
                            '3':
                                rEDIDocumentinstallment.Validate("Time relation type", rEDIDocumentinstallment."time relation type"::"3");
                            else
                                Error('Relación de tiempo sin contemplar');
                        end;
                        case TempOrder."ERE1V TipoPeriodoCodificado" of
                            '', ' ':
                                rEDIDocumentinstallment.Validate("Period type", rEDIDocumentinstallment."period type"::" ");
                            'D':
                                rEDIDocumentinstallment.Validate("Period type", rEDIDocumentinstallment."period type"::D);
                            'M':
                                rEDIDocumentinstallment.Validate("Period type", rEDIDocumentinstallment."period type"::M);
                            'WD':
                                rEDIDocumentinstallment.Validate("Period type", rEDIDocumentinstallment."period type"::WD);
                            'Y':
                                rEDIDocumentinstallment.Validate("Period type", rEDIDocumentinstallment."period type"::Y);
                            else
                                Error('Tipo de período no contemplado ' + TempOrder."ERE1V TipoPeriodoCodificado");
                        end;
                        rEDIDocumentinstallment.Validate("Period number", TempOrder."ERE1V NumeroPeriodos");
                        rEDIDocumentinstallment.Validate("Due date", TempOrder."ERE1V FechaVencimiento");
                        rEDIDocumentinstallment.Validate(Amount, TempOrder."ERE1V ImporteVencimiento");
                        rEDIDocumentinstallment.Insert(true);
                    end;
                end;
                ********* NO HAY VENCIMIENTOS EN ABONOS y/o DEVOLUCIONES *******************/

                // Creamos las lineas del documento
                CreateLinesOrderv3(rEDITemporaryOrdersHeader);
            until rEDITemporaryOrdersHeader.Next = 0;
    end;

    local procedure CreateLinesOrderv3(rEDITemporaryOrdersHeader: Record "EDI - Temporary Orders")
    var
        rWarehouseSetup: Record "Warehouse Setup";
        rItemIdentifier: Record "Item Identifier";
        rItemReference: Record "Item Reference";
        rSalesReceivablesSetup: Record "Sales & Receivables Setup";
        rUnitofMeasure: Record "Unit of Measure";
        rVATPostingSetup: Record "VAT Posting Setup";
        Cuenta: Boolean;
        rAbonosEDI: Record "Abonos EDI";
        CrMemoGLAccount: Code[20];
        TempOrderACE: Record "EDI - Temporary Orders";
    begin
        rWarehouseSetup.Reset();
        rWarehouseSetup.Get();

        TempOrderAux.Reset;
        TempOrderAux.SetRange("RECTL IdentificacionMensaje", rEDITemporaryOrdersHeader."RECTL IdentificacionMensaje");
        TempOrderAux.SetFilter("ERE1L NumeroLineaArticulo", '<>%1', 0);
        if TempOrderAux.FindSet then begin
            repeat begin
                if SalesHeader."No." <> '' then begin
                    rSalesReceivablesSetup.Get;
                    Cuenta := false;
                    //>> BBT 27/01/2024
                    //if (TempOrderAux."ERE1L CodigoEAN13DUN14Articulo" <> '') and
                    //    (TempOrderAux."ERE1L CodigoEAN13DUN14Articulo" <> '8431876084016') then begin
                    //    SalesLine.Validate("EDI - EAN13/DUN14", TempOrderAux."ERE1L CodigoEAN13DUN14Articulo");
                    //
                    //    rItemCrossReference.Reset;
                    //    rItemCrossReference.SetFilter("Reference No.", TempOrderAux."ERE1L CodigoEAN13DUN14Articulo");
                    //    if not rItemCrossReference.FindSet then
                    //        Error('No se ha podido encontrar el producto con EAN13/DUN14 ' + TempOrderAux."ERE1L CodigoEAN13DUN14Articulo");
                    //end
                    //<<
                    if (TempOrderAux."ERE1L CodigoEAN13DUN14Articulo" <> '') and                        // EXISTE EAN13
                        (TempOrderAux."ERE1L CodigoEAN13DUN14Articulo" <> '8431876084016') Then begin   // EAN13 NOTA CARGO ( CENTROS COMERC.CARREFOUR?? )
                        rItemIdentifier.Reset;
                        rItemIdentifier.SetFilter(Code, TempOrderAux."ERE1L CodigoEAN13DUN14Articulo");
                        if not rItemIdentifier.FindSet then
                            Error('No se ha podido encontrar el producto con EAN13/DUN14 ' + TempOrderAux."ERE1L CodigoEAN13DUN14Articulo");
                    end
                    else begin
                        CrMemoGLAccount := '';
                        rAbonosEDI.Reset;
                        rAbonosEDI.SetRange("ERE1L Descripcion1Articulo", TempOrderAux."ERE1L Descripcion1Articulo");
                        if rAbonosEDI.FindFirst then
                            CrMemoGLAccount := rAbonosEDI."G/L Account No."
                        else
                            CrMemoGLAccount := rSalesReceivablesSetup."EDI - G/L Account No.";
                        Cuenta := true;
                    end;
                    SalesLine.Init;
                    SalesLine.Validate("Document Type", SalesHeader."Document Type");
                    SalesLine.Validate("Document No.", SalesHeader."No.");
                    SalesLine.Validate("Line No.", TempOrderAux."ERE1L NumeroLineaArticulo");
                    SalesLine.Insert(true);
                    if Cuenta then begin
                        SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
                        SalesLine.Validate("No.", CrMemoGLAccount);
                    end
                    else begin
                        SalesLine.Validate(Type, SalesLine.Type::Item);
                        SalesLine.Validate("EDI - EAN13/DUN14", TempOrderAux."ERE1L CodigoEAN13DUN14Articulo");
                        SalesLine.Validate("No.", rItemIdentifier."Item No.");
                        SalesLine.Validate("EDI - Item code type", TempOrderAux."ERE1L TipoCodigoArticulo");
                    end;

                    SalesLine.Validate("EDI - Promotion variable", TempOrderAux."ERE1L VariablePromocional");
                    SalesLine.Validate("EDI - Extra item EAN", TempOrderAux."ERE1L CodigoEANDelArticuloAdic");

                    SalesLine.Validate(Quantity, 1);
                    case SalesLine."Document Type" of
                        SalesLine."Document Type"::Order:
                            begin
                                if TempOrderAux."ERE1L CantidadPedida" <> 0 then
                                    SalesLine.Validate(Quantity, TempOrderAux."ERE1L CantidadPedida");
                            end;
                        SalesLine."document type"::"Return Order":
                            begin
                                if TempOrderAux."ERE1L CantidadDevuelta" <> 0 then
                                    SalesLine.Validate(Quantity, TempOrderAux."ERE1L CantidadDevuelta");
                            end;
                        else
                            SalesLine.Validate(Quantity, 1);
                    end;
                    SalesLine.Validate("EDI - Reimbursed Qty.", TempOrderAux."ERE1L CantidadBonificada");
                    if not Cuenta then
                        SalesLine.Validate("Unit of Measure Code", 'UNID');
                    SalesLine.Validate("EDI - Line Amount", Abs(TempOrderAux."ERE1L ImporteNetoLinea"));
                    if TempOrderAux."ERE1L PrecioBrutoUnitario" <> 0 then
                        SalesLine.Validate("EDI - Gross unit price", TempOrderAux."ERE1L PrecioBrutoUnitario")
                    else
                        if TempOrderAux."ERE1L PrecioNetoUnitario" <> 0 then
                            SalesLine.Validate("EDI - Gross unit price", TempOrderAux."ERE1L PrecioNetoUnitario")
                        else
                            SalesLine.Validate("EDI - Gross unit price", TempOrderAux."ERE1L PrecioATituloInformativo");

                    SalesLine.Validate("EDI - Price UOM", TempOrderAux."ERE1L CalifiUDeMedidaPrecio");
                    SalesLine.Validate("EDI - Tax type", TempOrderAux."ERE1L CalificadorIVAIGIC");
                    SalesLine.Validate("EDI - Tax %", TempOrderAux."ERE1L PorcentajeIVAIGIC");
                    SalesLine.Validate("EDI - Tax Amt.", TempOrderAux."ERE1L ImporteIVAIGIC");
                    SalesLine.Validate("EDI - RE %", TempOrderAux."ERE1L PorRecargoEquivalencia");
                    SalesLine.Validate("EDI - RE Amt.", TempOrderAux."ERE1L ImporteRecargoEquiv");
                    SalesLine.Validate("EDI - Other tax type", TempOrderAux."ERE1L CalificadorOtroTipoDeImp");
                    SalesLine.Validate("EDI - Other tax %", TempOrderAux."ERE1L PorOtroTipoDeImpuesto");
                    SalesLine.Validate("EDI - Other tax amt.", TempOrderAux."ERE1L ImporteOtroTipoDeImp");
                    SalesLine.Validate("EDI - Net weight", TempOrderAux."ERE1L PesoNeto");
                    if TempOrderAux."ERE1L CalificadorUDeMedidaPeso" <> '' then begin
                        rUnitofMeasure.Reset;
                        rUnitofMeasure.SetRange("EDI - Unit of measure code", TempOrderAux."ERE1L CalificadorUDeMedidaPeso");
                        if rUnitofMeasure.FindSet then
                            SalesLine.Validate("EDI - Weight UOM", TempOrderAux."ERE1L CalificadorUDeMedidaPeso")
                        else
                            Error('No se encuentra traducción para el cód. Ud. Medida ' + TempOrderAux."ERE1L CalificadorUDeMedidaPeso");
                    end;
                    SalesLine.Validate("EDI - Model description", TempOrderAux."ERE1L DescripcionDelModelo");
                    SalesLine.Validate("EDI - Color", TempOrderAux."ERE1L Color");
                    SalesLine.Validate("EDI - Width or size", TempOrderAux."ERE1L AnchuraOTalla");
                    SalesLine.Validate("EDI - Item SN", TempOrderAux."ERE1L NumeroSerieArticulo");
                    SalesLine.Validate("EDI - Item Lot", TempOrderAux."ERE1L NumeroLote");
                    SalesLine.Validate("EDI - Manufacturer Item No.", TempOrderAux."ERE1L NumeroArticuloFabricante");
                    SalesLine.Validate("EDI - Line Amt. Tax incl.", TempOrderAux."ERE1L ImporteLíneaConImpuestos");
                    SalesLine.Validate("EDI - Net unit price base", TempOrderAux."ERE1L BasePrecioNetoUnitario");
                    SalesLine.Validate("EDI - Item price taxes incl.", TempOrderAux."ERE1L PrecioArticuloConImp");
                    SalesLine.Validate("EDI - Shipment No.", TempOrderAux."ERE1L NumeroAlbaran");
                    SalesLine.Validate("EDI - Shipment date", TempOrderAux."ERE1L FechaAlbaran");
                    SalesLine.Validate("EDI - End customer code", TempOrderAux."ERE1L CodigoClienteFinal");
                    SalesLine.Validate("EDI - End customer name", TempOrderAux."ERE1L NombreClienteFinal");
                    SalesLine.Validate("EDI - End customer address", TempOrderAux."ERE1L DireccionClienteFinal");
                    SalesLine.Validate("EDI - End customer city", TempOrderAux."ERE1L PoblacionClienteFinal");
                    SalesLine.Validate("EDI - End customer post code", TempOrderAux."ERE1L CodigoPostalClienteFinal");
                    SalesLine.Validate("EDI - Item ID/Order Line", TempOrderAux."ERE1L IdentificadorProdLinPed");
                    SalesLine.Validate("Ship-to Code", SalesHeader."Ship-to Code");

                    // El precio solo se sube para los abonos o las devoluciones.
                    if not Cuenta then
                        if (SalesLine."Document Type" = SalesLine."document type"::"Return Order") or
                            (SalesLine."Document Type" = SalesLine."document type"::"Credit Memo") then begin
                            if TempOrderAux."ERE1L PrecioNetoUnitario" <> 0 then
                                SalesLine.Validate("Unit Price", TempOrderAux."ERE1L PrecioNetoUnitario")
                            else
                                SalesLine.Validate("Unit Price", TempOrderAux."ERE1L ImporteNetoLinea" / SalesLine.Quantity);
                        end;

                    Salesline."Location Code" := '';
                    // Almacen por defecto en las devoluciones (DEVOL-2)
                    if SalesLine."Document Type" = SalesLine."document type"::"Return Order" then begin
                        rWarehouseSetup.TestField("Default Return Location");
                        SalesLine.Validate("Location Code", rWarehouseSetup."Default Return Location");
                    end;
                    // Almacen por defecto en los abonos (ABONOS)
                    if SalesLine."Document Type" = SalesLine."document type"::"Credit Memo" then begin
                        rWarehouseSetup.TestField("Default Sales CR Memo Location");
                        SalesLine.Validate("Location Code", rWarehouseSetup."Default Sales CR Memo Location");
                    end;

                    SalesLine.Modify();
                end
                else begin
                    PurchaseHeader.TestField("No.");
                    Cuenta := true;
                    //>> BBT 27/01/2024
                    //if TempOrderAux."ERE1L CodigoEAN13DUN14Articulo" <> '' then begin
                    //    PurchaseLine.Validate("EDI - EAN13/DUN14", TempOrderAux."ERE1L CodigoEAN13DUN14Articulo");
                    //    rItemReference.Reset;
                    //    rItemReference.SetFilter("Reference No.", TempOrderAux."ERE1L CodigoEAN13DUN14Articulo");
                    //    if not rItemReference.FindSet then
                    //        Error('No se ha podido encontrar el producto con EAN13/DUN14 ' + TempOrderAux."ERE1L CodigoEAN13DUN14Articulo");
                    //end
                    if TempOrderAux."ERE1L CodigoEAN13DUN14Articulo" <> '' then begin
                        rItemIdentifier.Reset;
                        rItemIdentifier.SetFilter(Code, TempOrderAux."ERE1L CodigoEAN13DUN14Articulo");
                        if rItemIdentifier.FindSet then
                            Cuenta := false;
                    end;

                    CrMemoGLAccount := '';
                    if Cuenta = true then begin
                        rAbonosEDI.Reset;
                        rAbonosEDI.SetRange("ERE1L Descripcion1Articulo", TempOrderAux."ERE1L Descripcion1Articulo");
                        if rAbonosEDI.FindFirst then
                            CrMemoGLAccount := rAbonosEDI."G/L Account No."
                        else
                            //CrMemoGLAccount := SalesReceivablesSetup."EDI - G/L Account No."; //ESTA CUENTA ES PARA ABONOS DE VENTAS
                            CrMemoGLAccount := '709001'                                         //ESTA CUENTA ES PARA LAS FACTURAS DE COMPRAS
                    end;
                    //<<
                    PurchaseLine.Init;
                    PurchaseLine.Validate("Document Type", PurchaseHeader."Document Type");
                    PurchaseLine.Validate("Document No.", PurchaseHeader."No.");
                    PurchaseLine.Validate("Line No.", TempOrderAux."ERE1L NumeroLineaArticulo");
                    PurchaseLine.Insert(true);
                    if Cuenta then begin
                        PurchaseLine.Validate(Type, PurchaseLine.Type::"G/L Account");
                        PurchaseLine.Validate("No.", CrMemoGLAccount);
                    end
                    else begin
                        PurchaseLine.Validate(Type, PurchaseLine.Type::Item);
                        PurchaseLine.Validate("EDI - EAN13/DUN14", TempOrderAux."ERE1L CodigoEAN13DUN14Articulo");
                        PurchaseLine.Validate("No.", rItemIdentifier."Item No.");
                        PurchaseLine.Validate("EDI - Item code type", TempOrderAux."ERE1L TipoCodigoArticulo");
                    end;
                    PurchaseLine.Validate("EDI - Item code type", TempOrderAux."ERE1L TipoCodigoArticulo");
                    PurchaseLine.Validate("Direct Unit Cost", TempOrderAux."ERE1L ImporteNetoLinea");
                    PurchaseLine.Validate("EDI - Promotion variable", TempOrderAux."ERE1L VariablePromocional");
                    PurchaseLine.Validate("EDI - Extra item EAN", TempOrderAux."ERE1L CodigoEANDelArticuloAdic");
                    PurchaseLine.Validate(Quantity, TempOrderAux."ERE1L CantidadPedida");
                    PurchaseLine.Validate("EDI - Reimbursed Qty.", TempOrderAux."ERE1L CantidadBonificada");
                    PurchaseLine.Validate("Unit of Measure Code", 'UNID');
                    PurchaseLine.Validate("EDI - Line Amount", TempOrderAux."ERE1L ImporteNetoLinea");
                    if TempOrderAux."ERE1L PrecioBrutoUnitario" <> 0 then
                        PurchaseLine.Validate("EDI - Gross unit price", TempOrderAux."ERE1L PrecioBrutoUnitario")
                    else
                        if TempOrderAux."ERE1L PrecioNetoUnitario" <> 0 then
                            SalesLine.Validate("EDI - Gross unit price", TempOrderAux."ERE1L PrecioNetoUnitario")
                        else
                            SalesLine.Validate("EDI - Gross unit price", TempOrderAux."ERE1L PrecioATituloInformativo");
                    PurchaseLine.Validate("EDI - Price UOM", TempOrderAux."ERE1L CalifiUDeMedidaPrecio");
                    PurchaseLine.Validate("EDI - Tax type", TempOrderAux."ERE1L CalificadorIVAIGIC");
                    PurchaseLine.Validate("EDI - Tax %", TempOrderAux."ERE1L PorcentajeIVAIGIC");
                    PurchaseLine.Validate("EDI - Tax Amt.", TempOrderAux."ERE1L ImporteIVAIGIC");
                    PurchaseLine.Validate("EDI - RE %", TempOrderAux."ERE1L PorRecargoEquivalencia");
                    PurchaseLine.Validate("EDI - RE Amt.", TempOrderAux."ERE1L ImporteRecargoEquiv");
                    PurchaseLine.Validate("EDI - Other tax type", TempOrderAux."ERE1L CalificadorOtroTipoDeImp");
                    PurchaseLine.Validate("EDI - Other tax %", TempOrderAux."ERE1L PorOtroTipoDeImpuesto");
                    PurchaseLine.Validate("EDI - Other tax amt.", TempOrderAux."ERE1L ImporteOtroTipoDeImp");
                    PurchaseLine.Validate("EDI - Net weight", TempOrderAux."ERE1L PesoNeto");
                    if TempOrderAux."ERE1L CalificadorUDeMedidaPeso" <> '' then begin
                        rUnitofMeasure.Reset;
                        rUnitofMeasure.SetRange("EDI - Unit of measure code", TempOrderAux."ERE1L CalificadorUDeMedidaPeso");
                        if rUnitofMeasure.FindSet then
                            PurchaseLine.Validate("EDI - Weight UOM", TempOrderAux."ERE1L CalificadorUDeMedidaPeso")
                        else
                            Error('No se encuentra traducción para el cód. Ud. Medida ' + TempOrderAux."ERE1L CalificadorUDeMedidaPeso");
                    end;
                    PurchaseLine.Validate("EDI - Model description", TempOrderAux."ERE1L DescripcionDelModelo");
                    PurchaseLine.Validate("EDI - Color", TempOrderAux."ERE1L Color");
                    PurchaseLine.Validate("EDI - Width or size", TempOrderAux."ERE1L AnchuraOTalla");
                    PurchaseLine.Validate("EDI - Item SN", TempOrderAux."ERE1L NumeroSerieArticulo");
                    PurchaseLine.Validate("EDI - Item Lot", TempOrderAux."ERE1L NumeroLote");
                    PurchaseLine.Validate("EDI - Manufacturer Item No.", TempOrderAux."ERE1L NumeroArticuloFabricante");
                    PurchaseLine.Validate("EDI - Line Amt. Tax incl.", TempOrderAux."ERE1L ImporteLíneaConImpuestos");
                    PurchaseLine.Validate("EDI - Net unit price base", TempOrderAux."ERE1L BasePrecioNetoUnitario");
                    PurchaseLine.Validate("EDI - Item price taxes incl.", TempOrderAux."ERE1L PrecioArticuloConImp");
                    PurchaseLine.Validate("EDI - Shipment No.", TempOrderAux."ERE1L NumeroAlbaran");
                    PurchaseLine.Validate("EDI - Shipment date", TempOrderAux."ERE1L FechaAlbaran");
                    PurchaseLine.Validate("EDI - End customer code", TempOrderAux."ERE1L CodigoClienteFinal");
                    PurchaseLine.Validate("EDI - End customer name", TempOrderAux."ERE1L NombreClienteFinal");
                    PurchaseLine.Validate("EDI - End customer address", TempOrderAux."ERE1L DireccionClienteFinal");
                    PurchaseLine.Validate("EDI - End customer city", TempOrderAux."ERE1L PoblacionClienteFinal");
                    PurchaseLine.Validate("EDI - End customer post code", TempOrderAux."ERE1L CodigoPostalClienteFinal");
                    PurchaseLine.Validate("EDI - Item ID/Order Line", TempOrderAux."ERE1L IdentificadorProdLinPed");
                    if PurchaseLine."Document Type" = PurchaseLine."document type"::Invoice then
                        PurchaseLine.Validate("Direct Unit Cost", TempOrderAux."ERE1L ImporteNetoLinea");
                    PurchaseLine."Location Code" := '';
                    IF not Cuenta then begin    //almacen por defecto (DEVOL-2) 
                        rWarehouseSetup.TestField("Default Return Location");
                        PurchaseLine.Validate("Location Code", rWarehouseSetup."Default Return Location");
                    end;

                    PurchaseLine.Modify(true);
                end;
            end;
            // Hacemos comentarios de líneas?? El día que ocurra, de momento no hay casos aparentes
            until TempOrderAux.Next = 0;
        end
        else begin
            if SalesHeader."No." <> '' then begin
                rSalesReceivablesSetup.Reset;
                rSalesReceivablesSetup.Get;
                rSalesReceivablesSetup.TestField("EDI - G/L Account No.");
                TempOrderAux.Reset;
                TempOrderAux.SetRange("RECTL IdentificacionMensaje", rEDITemporaryOrdersHeader."RECTL IdentificacionMensaje");
                TempOrderAux.SetRange(Type, 'SINCI');
                if TempOrderAux.FindSet then
                    repeat
                        rVATPostingSetup.Reset;
                        rVATPostingSetup.SetRange("VAT Bus. Posting Group", SalesHeader."VAT Bus. Posting Group");
                        rVATPostingSetup.SetRange("VAT %", TempOrderAux."ERE1I PorImpuesto");
                        rVATPostingSetup.FindSet;
                        SalesHeader.TestField("No."); // De momento no soportamos abonos de cargo para circuito de compras. Se nos avisará si hace falta
                        SalesLine.Init;
                        SalesLine.Validate("Document Type", SalesHeader."Document Type");
                        SalesLine.Validate("Document No.", SalesHeader."No.");
                        SalesLine.Validate("Line No.", TempOrderAux."ERE1I NumeroLineaImpuesto");
                        SalesLine.Insert(true);
                        SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
                        SalesLine.Validate("No.", rSalesReceivablesSetup."EDI - G/L Account No.");
                        SalesLine.Validate(Quantity, 1);
                        if TempOrderAux."ERE1I BaseImponible" <> 0 then
                            SalesLine.Validate("Unit Price", TempOrderAux."ERE1I BaseImponible")
                        else
                            SalesLine.Validate("Unit Price", 100 * TempOrderAux."ERE1I ImporteImpuesto" / TempOrderAux."ERE1I PorImpuesto");
                        if SalesLine."VAT Prod. Posting Group" <> rVATPostingSetup."VAT Prod. Posting Group" then
                            SalesLine.Validate("VAT Prod. Posting Group", rVATPostingSetup."VAT Prod. Posting Group");
                        //>> Descripcion Cargo/abono
                        TempOrderACE.Reset();
                        TempOrderACE.SetRange("ERE1T CalificadorTemaTexto", 'ACE');
                        if TempOrderACE.Findfirst then
                            SalesLine.Description := TempOrderACE."ERE1T Texto1";
                        //<<
                        SalesLine.Modify(true);
                        SalesLine.TestField("VAT %", TempOrderAux."ERE1I PorImpuesto"); // Verificamos que el % IVA sea válido
                    until TempOrder.Next = 0;
            end;
            // NO SE REPROCESAN LINEAS PARA FACTURAS DE COMPRAS
            // else begin                  
            //PurchaseHeader.TestField("No.");
            //end
        end;
    end;

    /**********************************************************************/
    /*************** EDI - DESADV - DEVOLUCIONES **************************/
    /**********************************************************************/
    /*
    Tipo   Nombre registro                             Repeticiones
    _____  ________________________________________    _____________
    RECTL Registro de control           Obligatorio           1
    SEH1C Cabecera                      Obligatorio           1
    SEH1D Información partes cabecera   Obligatorio           N
    SEH1P Embalajes                     Obligatorio           N
    SEH1L Detalle Línea de artículos    Obligatorio           N
    SEH1U Observaciones línea detalle   Opcional              N
    SEH1G Desgl. Cantd./Localizaciones  Opcional              N
    SEH1B Lotes                         Opcional              N
    */
    local procedure ProcessIncomingReturns(var EDIEntry: record "EDI - EDI Entry")
    var
        IStream: InStream;
        StreamText: Text;
    begin
        Clear(RECTLIdentificacionMensaje);
        EDIEntry.CalcFields("File Blob");
        EDIEntry."File Blob".CreateInstream(IStream);
        while not IStream.eos do begin
            StreamText := '';
            IStream.ReadText(StreamText);
            // Dependiendo del tipo de línea que venga, la procesamos a su modo
            if StreamText <> '' then
                case CopyStr(StreamText, 1, 5) of // Info de cabecera
                    'RECTL':
                        ProcessRECTLV2(EDIEntry."Entry No.", StreamText);  // Registro control
                    'SEH1C':
                        ProcessSEH1C(EDIEntry."Entry No.", StreamText);    // Cabecera devolución
                    'SEH1D':
                        ProcessSEH1D(EDIEntry."Entry No.", StreamText);    // Información partes cabecera
                    'SEH1P':
                        ProcessSEH1P(EDIEntry."Entry No.", StreamText);     // Embalajes devolución
                    'SEH1L':
                        ProcessSEH1L(EDIEntry."Entry No.", StreamText);     // Detalle de devolución Productos - Unidades

                    //'SEH1U':                                              // Observaciones de línea de detalle
                    //'SEH1G':                                              // Desglose cantidad/Localizaciones  
                    //'SEH1B':                                              // Información de lotes
                    else
                        Error('Se está utilizando un tipo de línea no contemplado: ' + CopyStr(StreamText, 1, 5));
                end;
        end;
        Commit;
        //Cabecera de la Devolución
        CreateHeaderSalesReturn(EDIEntry);
    end;

    local procedure ProcessRECTLV2(PEntryNo: Integer; StreamText: Text)
    var
        rParentLine: integer;
    begin
        Clear(rParentLine);
        TempDoc.Init;
        RECTLIdentificacionMensaje := CopyStr(StreamText, 83, 40);          // Identificación única del mensaje asignada por el emisor (Nº Doc Externo?)

        // Primero los campos clave
        TempDoc.Validate("Entry No.", PEntryNo);                            // Número registro EDI
        TempDoc.Validate("Document Type", 'DESADV');                        // DESADV
        TempDoc.Validate("Record Type", 'RECTL');                           // RECTL
        Tempdoc.Validate("Identificador", RECTLIdentificacionMensaje);      // Idenfificador Único.
        // Resto de campos
        TempDoc.InsertValue(TempDoc, 'TipoRegistro', 'Text', StreamText, 1, 6, rParentLine);            // Tipo Registro
        TempDoc.InsertValue(TempDoc, 'TipoMensaje', 'Text', StreamText, 7, 6, rParentLine);             //Tipo Mensaje
        TempDoc.InsertValue(TempDoc, 'CodigoEmisor', 'Text', StreamText, 13, 35, rParentLine);          //Código del emisor
        TempDoc.InsertValue(TempDoc, 'CodigoReceptor', 'Text', StreamText, 48, 35, rParentLine);        //Codigo del Receptor
        TempDoc.InsertValue(TempDoc, 'IdentificacionMensaje', 'Text', StreamText, 83, 40, rParentLine); // Identificación Mensaje
        TempDoc.InsertValue(TempDoc, 'FechaHoraMensaje', 'DateTime', StreamText, 123, 12, rParentLine); // Fecha/hora del mens

    end;

    local procedure ProcessSEH1C(PEntryNo: Integer; StreamText: Text)
    var
        rParentLine: integer;
    begin
        Clear(rParentLine);
        TempDoc.Init;
        // Primero los campos clave
        TempDoc.Validate("Entry No.", PEntryNo);                            // Número registro EDI
        TempDoc.Validate("Document Type", 'DESADV');                        // DESADV
        TempDoc.Validate("Record Type", 'SEH1C');                           // SEH1C
        Tempdoc.Validate("Identificador", RECTLIdentificacionMensaje);      // Idenfificador Único

        // Resto de campos
        TempDoc.InsertValue(TempDoc, 'TipoRegistro', 'Text', StreamText, 1, 6, rParentLine);                        // Tipo Registro
        TempDoc.InsertValue(TempDoc, 'TipoDocumento', 'Text', StreamText, 7, 6, rParentLine);                       // Tipo Documento
        TempDoc.InsertValue(TempDoc, 'NumeroDocumento', 'Text', StreamText, 13, 17, rParentLine);                   // Número Documento
        TempDoc.InsertValue(TempDoc, 'FuncionMensaje', 'Text', StreamText, 30, 6, rParentLine);                     // Función Mensaje
        TempDoc.InsertValue(TempDoc, 'FechaHoraDocumento', 'DateTime', StreamText, 36, 12, rParentLine);            // Fecha/Hora Documento

        /* NO SE USAN EN AMAZON 
        TempDoc.InsertValue(TempDoc, 'FechaHoraEstimadaEntrega', 'DateTime', StreamText, 48, 12, rParentLine);      // Fecha/hora estimada de entrega
        TempDoc.InsertValue(TempDoc, 'CalificadorFechaHora1', 'Text', StreamText, 60, 3, rParentLine);              // Calificador Fecha/Hora 1
        TempDoc.InsertValue(TempDoc, 'FechaHora1', 'DateTime', StreamText, 63, 12, rParentLine);                    // Fecha/Hora 1
        TempDoc.InsertValue(TempDoc, 'CalificadorFechaHora2', 'Text', StreamText, 75, 3, rParentLine);              // Calificador Fecha/Hora 2
        TempDoc.InsertValue(TempDoc, 'FechaHora2', 'DateTime', StreamText, 78, 12, rParentLine);                    // Fecha/Hora 2
        TempDoc.InsertValue(TempDoc, 'InformacionAdicional', 'Text', StreamText, 90, 6, rParentLine);               // Información adicional
        TempDoc.InsertValue(TempDoc, 'NumeroPedidoComprador', 'Text', StreamText, 96, 17, rParentLine);             // Número pedido (comprador)
        TempDoc.InsertValue(TempDoc, 'FechaHoraNumeroPedido', 'DateTime', StreamText, 113, 12, rParentLine);        // Fecha/hora número pedido
        TempDoc.InsertValue(TempDoc, 'NumeroAlbaran', 'Text', StreamText, 125, 17, rParentLine);                    // Número albarán
        TempDoc.InsertValue(TempDoc, 'FechaHoraNumeroAlbaran', 'DateTime', StreamText, 142, 12, rParentLine);       // Fecha/Hora Documento
        */

        TempDoc.InsertValue(TempDoc, 'CalificadorReferencia1', 'Text', StreamText, 154, 3, rParentLine);            // Calificador Referencia 1
        TempDoc.InsertValue(TempDoc, 'NumeroReferencia1', 'Text', StreamText, 157, 17, rParentLine);                // Numero Referencia 1
        TempDoc.InsertValue(TempDoc, 'FechaHoraReferencia1', 'DateTime', StreamText, 174, 12, rParentLine);         // Fecha/Hora Referencia 1
        TempDoc.InsertValue(TempDoc, 'CalificadorReferencia2', 'Text', StreamText, 186, 3, rParentLine);            // Calificador Referencia 2
        TempDoc.InsertValue(TempDoc, 'NumeroReferencia2', 'Text', StreamText, 189, 17, rParentLine);                // Numero Referencia 2
        TempDoc.InsertValue(TempDoc, 'FechaHoraReferencia2', 'DateTime', StreamText, 206, 12, rParentLine);         // Fecha/Hora Referencia 2

        /* NO SE USAN EN AMAZON 
        TempDoc.InsertValue(TempDoc, 'MetodoPagoCostesTransporte', 'Text', StreamText, 218, 3, rParentLine);        // Método pago de costes de transporte
        TempDoc.InsertValue(TempDoc, 'CondicionesEntregaCodificada', 'Text', StreamText, 221, 3, rParentLine);      // Condiciones de entrega o transporte, codificada
        TempDoc.InsertValue(TempDoc, 'CondicionesEntrega', 'DateTime', StreamText, 224, 70, rParentLine);           // Condiciones de entrega o transporte, texto libre
        TempDoc.InsertValue(TempDoc, 'ModoTransporte', 'Text', StreamText, 294, 3, rParentLine);                    // Modo de transporte , codificado
        TempDoc.InsertValue(TempDoc, 'IdentificacionTransportista', 'Text', StreamText, 297, 13, rParentLine);      // Identificación de transportista
        TempDoc.InsertValue(TempDoc, 'NombreTransportista', 'Text', StreamText, 310, 35, rParentLine);              // Nombre del transportista
        TempDoc.InsertValue(TempDoc, 'MatriculaVehiculo', 'Text', StreamText, 345, 17, rParentLine);                // Matricula del vehículo
        TempDoc.InsertValue(TempDoc, 'LugarEntregaCodificado', 'Text', StreamText, 362, 17, rParentLine);           // Lugar de entrega, codificado (8)
        TempDoc.InsertValue(TempDoc, 'LugarEntrega,', 'Text', StreamText, 379, 70, rParentLine);                    // Lugar de entrega, texto libre
        */

        TempDoc.InsertValue(TempDoc, 'CalificadorReferencia3', 'Text', StreamText, 449, 3, rParentLine);            // Calificador Referencia 3
        TempDoc.InsertValue(TempDoc, 'NumeroReferencia3', 'Text', StreamText, 452, 35, rParentLine);                // Numero Referencia 3

    end;

    local procedure ProcessSEH1D(PEntryNo: Integer; StreamText: Text)
    var
        rParentLine: integer;
    begin
        Clear(rParentLine);
        TempDoc.Init;
        // Primero los campos clave
        TempDoc.Validate("Entry No.", PEntryNo);                            // Número registro EDI
        TempDoc.Validate("Document Type", 'DESADV');                        // DESADV
        TempDoc.Validate("Record Type", 'SEH1D');                           // SEH1D
        Tempdoc.Validate("Identificador", RECTLIdentificacionMensaje);      // Idenfificador Único

        // Resto de campos
        TempDoc.InsertValue(TempDoc, 'TipoRegistro', 'Text', StreamText, 1, 6, rParentLine);                        // Tipo Registro
        TempDoc.InsertValue(TempDoc, 'CalificadorInterlocutor', 'Text', StreamText, 7, 3, rParentLine);             // Calificador Interlocutor
        TempDoc.InsertValue(TempDoc, 'CodigoInterlocutor', 'Text', StreamText, 10, 17, rParentLine);                // Código Interlocutor

        /* NO SE USAN EN AMAZON
        TempDoc.InsertValue(TempDoc, 'AgenciaResponsablelistaCodigos', 'Text', StreamText, 27, 3, rParentLine);     //Agencia responsable de la lista de códigos
        TempDoc.InsertValue(TempDoc, 'Nombre1', 'Text', StreamText, 30, 35, rParentLine);                           // Nombre 1
        TempDoc.InsertValue(TempDoc, 'Nombre2', 'Text', StreamText, 65, 35, rParentLine);                           // Nombre 2
        TempDoc.InsertValue(TempDoc, 'Nombre3', 'Text', StreamText, 100, 35, rParentLine);                          // Nombre 3
        TempDoc.InsertValue(TempDoc, 'Nombre4', 'Text', StreamText, 135, 35, rParentLine);                          // Nombre 4
        TempDoc.InsertValue(TempDoc, 'Nombre5', 'Text', StreamText, 170, 35, rParentLine);                          // Nombre 5
        TempDoc.InsertValue(TempDoc, 'CalleNumero1', 'Text', StreamText, 205, 35, rParentLine);                     // Calle y numero 1
        TempDoc.InsertValue(TempDoc, 'CalleNumero2', 'Text', StreamText, 240, 35, rParentLine);                     // Calle y numero 2
        TempDoc.InsertValue(TempDoc, 'CalleNumero3', 'Text', StreamText, 275, 35, rParentLine);                     // Calle y numero 3
        TempDoc.InsertValue(TempDoc, 'CalleNumero4', 'Text', StreamText, 310, 35, rParentLine);                     // Calle y numero 4
        TempDoc.InsertValue(TempDoc, 'Poblacion', 'Text', StreamText, 345, 35, rParentLine);                        // Población
        TempDoc.InsertValue(TempDoc, 'Provincia', 'Text', StreamText, 380, 9, rParentLine);                         // Provincia
        TempDoc.InsertValue(TempDoc, 'CodigoPostal', 'Text', StreamText, 389, 9, rParentLine);                      // Codigo postal
        TempDoc.InsertValue(TempDoc, 'CodigoPais', 'Text', StreamText, 398, 3, rParentLine);                        // Codigo país
        TempDoc.InsertValue(TempDoc, 'CalificadorReferencia1', 'Text', StreamText, 401, 3, rParentLine);            // Calificador referencia 1
        TempDoc.InsertValue(TempDoc, 'Referencia1', 'Text', StreamText, 404, 35, rParentLine);                      // Referencia 1
        TempDoc.InsertValue(TempDoc, 'FuncionDeContacto', 'Text', StreamText, 439, 3, rParentLine);                 // Función de contacto
        TempDoc.InsertValue(TempDoc, 'DptoIdentificacionEmpleado', 'Text', StreamText, 442, 17, rParentLine);       // Departamento o identificación del empleado
        TempDoc.InsertValue(TempDoc, 'DepartamentoEmpleado', 'Text', StreamText, 459, 35, rParentLine);             // Departamento o empleado
        TempDoc.InsertValue(TempDoc, 'CalificadorReferencia2', 'Text', StreamText, 494, 3, rParentLine);            // Calificador referencia 2
        TempDoc.InsertValue(TempDoc, 'Referencia2', 'Text', StreamText, 497, 17, rParentLine);                      // Referencia 2
        */

    end;

    local procedure ProcessSEH1P(PEntryNo: Integer; StreamText: Text)
    var
        rParentLine: integer;
    begin
        Clear(rParentLine);
        TempDoc.Init;
        // Primero los campos clave
        TempDoc.Validate("Entry No.", PEntryNo);                            // Número registro EDI
        TempDoc.Validate("Document Type", 'DESADV');                        // DESADV
        TempDoc.Validate("Record Type", 'SEH1P');                           // SEH1P
        Tempdoc.Validate("Identificador", RECTLIdentificacionMensaje);      // Idenfificador Único

        // Resto de campos
        TempDoc.InsertValue(TempDoc, 'TipoRegistro', 'Text', StreamText, 1, 6, rParentLine);                            // Tipo Registro
        TempDoc.InsertValue(TempDoc, 'NumeroJerarquiaEmbalaje', 'Text', StreamText, 7, 12, rParentLine);                // Número de jerarquía de embalaje
        TempDoc.InsertValue(TempDoc, 'NumeroJerarquiaPadreEmbalaje', 'Text', StreamText, 19, 12, rParentLine);          // Número de jerarquía padre de embalaje
        TempDoc.InsertValue(TempDoc, 'NumeroPaquetes', 'Integer', StreamText, 31, 8, rParentLine);                      // Número de paquetes
        TempDoc.InsertValue(TempDoc, 'InformacionEmbalajeCodificado', 'Text', StreamText, 39, 6, rParentLine);          // Información sobre el embalaje, codificado
        TempDoc.InsertValue(TempDoc, 'TerminosCondicionesEmbalajeCodificado', 'Text', StreamText, 45, 6, rParentLine);  // Términos y Condiciones del embalaje, codificado
        TempDoc.InsertValue(TempDoc, 'TipoEmbalajeCodificado', 'Text', StreamText, 51, 6, rParentLine);                 // Tipo de embalaje, codificado
        TempDoc.InsertValue(TempDoc, 'TipoEmbalaje', 'Text', StreamText, 57, 38, rParentLine);                          // Tipo de embalaje, texto libre

        /* NO SE USAN EN AMAZON
        TempDoc.InsertValue(TempDoc, 'ResponsabilidadPagoTransporte', 'Text', StreamText, 92, 6, rParentLine);          // Responsabilidad Pago Transporte de Embalaje
        TempDoc.InsertValue(TempDoc, 'PesoNeto1AAC', 'Decimal', StreamText, 98, 18, rParentLine);                       // Peso neto1 (AAC)
        TempDoc.InsertValue(TempDoc, 'PesoNeto2', 'Decimal', StreamText, 116, 18, rParentLine);                         // Peso neto 2
        TempDoc.InsertValue(TempDoc, 'CodigoSignificacionMedidaPesoNeto', 'Text', StreamText, 134, 6, rParentLine);     // Código significación de la medida peso neto
        TempDoc.InsertValue(TempDoc, 'UnidadMedidaPesoNeto', 'Text', StreamText, 140, 6, rParentLine);                  // Unidad de medida para el peso neto
        TempDoc.InsertValue(TempDoc, 'PesoBruto1ADD', 'Decimal', StreamText, 146, 18, rParentLine);                     // Peso bruto 1 (AAD)
        TempDoc.InsertValue(TempDoc, 'PesoBruto2', 'Decimal', StreamText, 164, 18, rParentLine);                        // Peso bruto 2
        TempDoc.InsertValue(TempDoc, 'CodigoSignificacionMedidaPesoBruto', 'Text', StreamText, 182, 6, rParentLine);    // Código significación de la medida peso bruto
        TempDoc.InsertValue(TempDoc, 'UnidadMedidaPesoBruto', 'Text', StreamText, 188, 6, rParentLine);                 // Unidad de medida para el peso neto
        TempDoc.InsertValue(TempDoc, 'DimensionAltura1HT', 'Decimal', StreamText, 194, 18, rParentLine);                // Dimensión de altura 1 (HT)
        TempDoc.InsertValue(TempDoc, 'DimensionAltura2', 'Decimal', StreamText, 212, 18, rParentLine);                  // Dimensión de altura 2
        TempDoc.InsertValue(TempDoc, 'CodigoSignificacionMedidaAltura', 'Text', StreamText, 230, 6, rParentLine);       // Código significación de la medida altura
        TempDoc.InsertValue(TempDoc, 'UnidadMedidaAltura', 'Text', StreamText, 236, 6, rParentLine);                    // Unidad de medida para la altura
        TempDoc.InsertValue(TempDoc, 'DimensionAncho1WD', 'Decimal', StreamText, 242, 18, rParentLine);                 // Dimensión de ancho 1 (WD)
        TempDoc.InsertValue(TempDoc, 'DimensionAncho2', 'Decimal', StreamText, 260, 18, rParentLine);                   // Peso bruto 2
        TempDoc.InsertValue(TempDoc, 'CodigoSignificacionMedidaAncho', 'Text', StreamText, 278, 6, rParentLine);        // Código significación de la medida ancho
        TempDoc.InsertValue(TempDoc, 'UnidadMedidaAncho', 'Text', StreamText, 284, 6, rParentLine);                     // Unidad de medida para el ancho
        TempDoc.InsertValue(TempDoc, 'DimensionLongitud1LN', 'Decimal', StreamText, 290, 18, rParentLine);              // Dimensión de longitud 1 (LN)
        TempDoc.InsertValue(TempDoc, 'DimensionLongitud2', 'Decimal', StreamText, 308, 18, rParentLine);                // Dimensión de longitud 2
        TempDoc.InsertValue(TempDoc, 'CodigoSignificacionMedidaLongitud', 'Text', StreamText, 326, 6, rParentLine);     // Código significación de la medida longitud
        TempDoc.InsertValue(TempDoc, 'UnidadMedidaLongitud', 'Text', StreamText, 332, 6, rParentLine);                  // Unidad de medida para la longitud
        TempDoc.InsertValue(TempDoc, 'DimensionTemperatura1TC', 'Decimal', StreamText, 338, 18, rParentLine);           // Dimensión de temperatura 1 (TC)
        TempDoc.InsertValue(TempDoc, 'DimensionTemperatura2', 'Decimal', StreamText, 356, 18, rParentLine);             // Dimensión de temperatura 2
        TempDoc.InsertValue(TempDoc, 'CodigoSignificacionMedidaTemperatura', 'Text', StreamText, 374, 6, rParentLine);  // Código significación de la medida temperatura
        TempDoc.InsertValue(TempDoc, 'UnidadMedidaTemperatura', 'Text', StreamText, 380, 6, rParentLine);               // Unidad de medida para la temperatura
        TempDoc.InsertValue(TempDoc, 'CantidadPorEmbalaje', 'Decimal', StreamText, 386, 16, rParentLine);               // Cantidad por embalaje
        TempDoc.InsertValue(TempDoc, 'InstruccionesManejoCodificado', 'Text', StreamText, 402, 6, rParentLine);         // Instrucciones de manejo, codificado
        TempDoc.InsertValue(TempDoc, 'InstruccionesManejo', 'Text', StreamText, 408, 70, rParentLine);                  // Instrucciones de manejo, texto libre
        TempDoc.InsertValue(TempDoc, 'MarcaEnvio1', 'Text', StreamText, 478, 35, rParentLine);                          // Marca de envió 1
        TempDoc.InsertValue(TempDoc, 'MarcaEnvio2', 'Text', StreamText, 513, 35, rParentLine);                          // Marca de envió 2
        TempDoc.InsertValue(TempDoc, 'MarcaEnvio3', 'Text', StreamText, 548, 35, rParentLine);                          // Marca de envió 3
        TempDoc.InsertValue(TempDoc, 'MarcaEnvio4', 'Text', StreamText, 583, 35, rParentLine);                          // Marca de envió 4
        TempDoc.InsertValue(TempDoc, 'NumeroSerialIdentificacionInferior1', 'Text', StreamText, 618, 35, rParentLine);  // Número Serial 1 o número de identificación inferior 
        TempDoc.InsertValue(TempDoc, 'NumeroSerialIdentificacionSuperior1', 'Text', StreamText, 653, 35, rParentLine);  // Número Serial 1 o número de identificación superior
        TempDoc.InsertValue(TempDoc, 'NumeroSerialIdentificacionInferior2', 'Text', StreamText, 688, 35, rParentLine);  // Número Serial 2 o número de identificación inferior
        TempDoc.InsertValue(TempDoc, 'NumeroSerialIdentificacionSuperior2', 'Text', StreamText, 723, 35, rParentLine);  // Número Serial 2 o número de identificación superior
        TempDoc.InsertValue(TempDoc, 'NumeroSerialIdentificacionInferior3', 'Text', StreamText, 758, 35, rParentLine);  // Número Serial 3 o número de identificación inferior
        TempDoc.InsertValue(TempDoc, 'NumeroSerialIdentificacionSuperior4', 'Text', StreamText, 793, 35, rParentLine);  // Número Serial 3 o número de identificación superior   
        */

        if (CopyStr(StreamText, 7, 1) <> ' ') and (CopyStr(StreamText, 13, 1) = ' ') then begin
            TempDoc.InsertValue(TempDoc, 'ReferenciaTracking', 'Text', StreamText, 828, 3, rParentLine);
            TempDoc.InsertValue(TempDoc, 'NumeroTracking', 'Text', StreamText, 831, 35, rParentLine);
        end;

    end;

    local procedure ProcessSEH1L(PEntryNo: Integer; StreamText: Text)
        rParentLine: integer;
    begin
        Clear(rParentLine);
        TempDoc.Init;
        // Primero los campos clave
        TempDoc.Validate("Entry No.", PEntryNo);                            // Número registro EDI
        TempDoc.Validate("Document Type", 'DESADV');                        // DESADV
        TempDoc.Validate("Record Type", 'SEH1L');                           // SEH1L
        Tempdoc.Validate("Identificador", RECTLIdentificacionMensaje);      // Idenfificador Único

        // Resto de campos
        TempDoc.InsertValue(TempDoc, 'TipoRegistro', 'Text', StreamText, 1, 6, rParentLine);                         // Tipo Registro
        TempDoc.InsertValue(TempDoc, 'NumeroLineaArticulo', 'Integer', StreamText, 7, 6, rParentLine);               // Número de línea del articulo
        TempDoc.InsertValue(TempDoc, 'CodigoEANArticulo', 'Text', StreamText, 13, 15, rParentLine);                  // Código EAN del articulo
        TempDoc.InsertValue(TempDoc, 'DescripcionArticulo', 'Text', StreamText, 28, 70, rParentLine);                // Descripción del articulo

        /* NO SE USAN EN AMAZON
        TempDoc.InsertValue(TempDoc, 'TipoIdentificacionArticuloCU/DU', 'Text', StreamText, 98, 7, rParentLine);     // Tipo de identificación del articulo (CU/DU)
        TempDoc.InsertValue(TempDoc, 'NumeroArticuloProveedorSA', 'Text', StreamText, 105, 15, rParentLine);         // Número de articulo del proveedor (SA)
        TempDoc.InsertValue(TempDoc, 'NumeroVariablePromocionalPV', 'Text', StreamText, 120, 15, rParentLine);       // Número variable promocional (PV)
        TempDoc.InsertValue(TempDoc, 'CodigoDUN14', 'Text', StreamText, 135, 15, rParentLine);                       // Código DUN-14 (ADU)
        TempDoc.InsertValue(TempDoc, 'CodigoACU', 'Text', StreamText, 150, 15, rParentLine);                         // Código ACU (ACU)
        TempDoc.InsertValue(TempDoc, 'NumeroLoteNB', 'Text', StreamText, 165, 35, rParentLine);                      // Número de lote (NB)
        */

        TempDoc.InsertValue(TempDoc, 'NumeroArticuloComprador', 'Text', StreamText, 200, 15, rParentLine);           // Número de articulo del comprador (IN)
        TempDoc.InsertValue(TempDoc, 'CantidadEnviada', 'Decimal', StreamText, 215, 16, rParentLine);                // Cantidad enviada
        TempDoc.InsertValue(TempDoc, 'UnidadMedidaCantidadEnviada', 'Text', StreamText, 231, 6, rParentLine);        // Unidad de medida cantidad enviada

        /* NO SE USAN EN AMAZON
        TempDoc.InsertValue(TempDoc, 'UnidadesConsumoUnidadExpedición', 'Decimal', StreamText, 237, 16, rParentLine);// Unidades de consumo en unidad de expedición
        TempDoc.InsertValue(TempDoc, 'FechaCaducidad', 'DateTime', StreamText, 253, 12, rParentLine);                // Fecha de caducidad
        TempDoc.InsertValue(TempDoc, 'CalificadorReferencia1', 'Text', StreamText, 265, 6, rParentLine);             // Calificador Referencia 1
        TempDoc.InsertValue(TempDoc, 'NumeroReferencia1', 'Text', StreamText, 271, 17, rParentLine);                 // Numero Referencia 1
        TempDoc.InsertValue(TempDoc, 'FechaHoraReferencia1', 'DateTime', StreamText, 288, 12, rParentLine);          // Fecha/Hora Referencia 1
        TempDoc.InsertValue(TempDoc, 'CalificadorReferencia2', 'Text', StreamText, 300, 6, rParentLine);             // Calificador Referencia 2
        TempDoc.InsertValue(TempDoc, 'NumeroReferencia2', 'Text', StreamText, 306, 17, rParentLine);                 // Numero Referencia 2
        TempDoc.InsertValue(TempDoc, 'FechaHoraReferencia2', 'DateTime', StreamText, 323, 12, rParentLine);          // Fecha/Hora Referencia 2
        TempDoc.InsertValue(TempDoc, 'CalificadorReferencia3', 'Text', StreamText, 335, 6, rParentLine);             // Calificador Referencia 3
        TempDoc.InsertValue(TempDoc, 'NumeroReferencia3', 'Text', StreamText, 341, 17, rParentLine);                 // Numero Referencia 3
        TempDoc.InsertValue(TempDoc, 'FechaHoraReferencia3', 'DateTime', StreamText, 358, 12, rParentLine);          // Fecha/Hora Referencia 3
        TempDoc.InsertValue(TempDoc, 'UnidadesAgrupacionSuperior', 'Text', StreamText, 370, 16, rParentLine);        // Unidades en Agrupación Superior (45E)
        TempDoc.InsertValue(TempDoc, 'CodigoEANAdicional', 'Text', StreamText, 386, 15, rParentLine);                // Código EAN adicional
        TempDoc.InsertValue(TempDoc, 'CantidadSinCargo', 'Text', StreamText, 401, 16, rParentLine);                  // Cantidad sin cargo (192)
        TempDoc.InsertValue(TempDoc, 'CalificadorCantidadAdicional', 'Text', StreamText, 417, 3, rParentLine);       // Calificador cantidad adicional
        TempDoc.InsertValue(TempDoc, 'Cantidad adicional', 'Decimal', StreamText, 420, 16, rParentLine);             // Cantidad adicional
        TempDoc.InsertValue(TempDoc, 'UnidadMedidaCantidadAdicional', 'Text', StreamText, 436, 6, rParentLine);      // Unidad de medida cantidad adicional
        TempDoc.InsertValue(TempDoc, 'NumeroSerieArticulo', 'Text', StreamText, 442, 35, rParentLine);               // Número de serie del artículo (SN)
        TempDoc.InsertValue(TempDoc, 'NumeroArticuloFabricante', 'Text', StreamText, 477, 35, rParentLine);          // Número artículo fabricante (MF)
        TempDoc.InsertValue(TempDoc, 'NumeroLineaReferencia1', 'Integer', StreamText, 512, 6, rParentLine);          // Número de línea referencia 1
        TempDoc.InsertValue(TempDoc, 'NumeroLineaReferencia2', 'Integer', StreamText, 518, 6, rParentLine);          // Número de línea referencia 2
        TempDoc.InsertValue(TempDoc, 'NumeroLineaReferencia3', 'Integer', StreamText, 524, 6, rParentLine);          // Número de línea referencia 3
        TempDoc.InsertValue(TempDoc, 'DiferenciaEnCantidadPedida', 'Decimal', StreamText, 530, 16, rParentLine);     // Diferencia en cantidad pedida (21)
        TempDoc.InsertValue(TempDoc, 'CodigoDiscrepancia', 'Text', StreamText, 546, 3, rParentLine);                 // Código Discrepancia
        TempDoc.InsertValue(TempDoc, 'PesoTotalNetoLinea', 'Decimal', StreamText, 549, 18, rParentLine);             // Peso total neto de la línea (AAI/AAF)
        TempDoc.InsertValue(TempDoc, 'PesoTotalBrutoLinea', 'Decimal', StreamText, 567, 18, rParentLine);            // Peso total bruto de la línea (AAI/AAB)
        TempDoc.InsertValue(TempDoc, 'UnidadMedidaPeso', 'Text', StreamText, 585, 3, rParentLine);                   // Unidad de medida peso
        TempDoc.InsertValue(TempDoc, 'DimensionTemperatura1', 'Decimal', StreamText, 588, 18, rParentLine);          // Dimensión de temperatura 1 (TC)
        TempDoc.InsertValue(TempDoc, 'DimensionTemperatura2', 'Decimal', StreamText, 606, 18, rParentLine);          // Dimensión de temperatura 2
        TempDoc.InsertValue(TempDoc, 'UnidadMedidaTemperatura', 'Text', StreamText, 624, 3, rParentLine);            // Unidad de medida para la temperatura
        */

        TempDoc.InsertValue(TempDoc, 'DenominacionComercial', 'Text', StreamText, 627, 70, rParentLine);             // Denominación comercial

        /* NO SE USAN EN AMAZON
        TempDoc.InsertValue(TempDoc, 'DenominacionCientifica', 'Text', StreamText, 697, 70, rParentLine);            // Denominación científica
        TempDoc.InsertValue(TempDoc, 'PaisCapturaProduccion', 'Text', StreamText, 767, 17, rParentLine);             // País de captura/producción/cosecha/cría
        TempDoc.InsertValue(TempDoc, 'ZonaFAOCaptura', 'Text', StreamText, 784, 17, rParentLine);                    // Zona FAO de captura
        TempDoc.InsertValue(TempDoc, 'MetodoProduccion', 'Text', StreamText, 801, 17, rParentLine);                  // Método de producción
        TempDoc.InsertValue(TempDoc, 'CodigoPresentacion', 'Text', StreamText, 818, 17, rParentLine);                // Código de presentación
        TempDoc.InsertValue(TempDoc, 'CodigoFAOEspecie', 'Text', StreamText, 835, 35, rParentLine);                  // Código FAO de la especie
        TempDoc.InsertValue(TempDoc, 'FechaPeriodoCaptura', 'Text', StreamText, 870, 16, rParentLine);               // Fecha o periodo de captura
        TempDoc.InsertValue(TempDoc, 'FechaProducción', 'Date', StreamText, 886, 12, rParentLine);                   // Fecha de producción
        TempDoc.InsertValue(TempDoc, 'ArtePesca', 'Text', StreamText, 898, 17, rParentLine);                         // Arte de pesca
        TempDoc.InsertValue(TempDoc, 'InformacionCongelado', 'Text', StreamText, 915, 17, rParentLine);              // Información de congelado
        TempDoc.InsertValue(TempDoc, 'FechaCongelacion', 'DateTime', StreamText, 932, 12, rParentLine);              // Dimensión de temperatura 1 (TC)
        TempDoc.InsertValue(TempDoc, 'IMD', 'Text', StreamText,  944, 70, rParentLine);                              // IMD (FTG)
        TempDoc.InsertValue(TempDoc, 'ImporteNetoLineaConDtosCargos', 'Text', StreamText, 1014, 19, rParentLine);    // importe neto línea (203) con descuentos/cargos
        */

    end;

    local procedure CreateHeaderSalesReturn(var pEDIEntry: record "EDI - EDI Entry")
    var
        rEDITempDocHeader: Record "EDI - Temporary Documents";
        rEDITempDocHeaderAux: Record "EDI - Temporary Documents";
        ParentLine: Integer;
        //IStream: InStream;
        //OStream: OutStream;
        CurrentOrderFromEntryNo: Integer;
        rCustomer: Record Customer;
        TextAux: Text;
        IsAmazon: Boolean;
    begin
        CurrentOrderFromEntryNo := pEDIEntry."Entry No.";
        rEDITempDocHeader.Reset();
        rEDITempDocHeaderAux.SetRange("Entry No.", CurrentOrderFromEntryNo);
        rEDITempDocHeader.SetRange("Record Type", 'RECTL');
        rEDITempDocHeader.SetRange("Identificador", RECTLIdentificacionMensaje);
        rEDITempDocHeader.SetRange("Record Name", 'TipoMensaje');
        rEDITempDocHeader.SetRange("Text Value", 'DESADV');
        if rEDITempDocHeader.FindSet then
            repeat
                // Creación cabecera
                Clear(SalesHeader);
                SalesHeader.TestField("No.", ''); // Que no haya pasado por aquí más veces

                SalesHeader.Init;
                SalesHeader.Validate("Document Type", SalesHeader."document type"::"Return Order");
                SalesHeader.Validate("No.", '');
                SalesHeader.validate("EDI - EDI Order", true);
                SalesHeader.Validate("Reason Code", '1-DEVOL');
                SalesHeader.Insert(true);
                SalesHeader.TestField("No."); // Debe tener número asignado ya
                if CreateDocsNo <> '' then
                    CreateDocsNo += '|' + SalesHeader."No."
                else
                    CreateDocsNo := SalesHeader."No.";
                // Preparo filtros
                rEDITempDocHeaderAux.Reset();
                rEDITempDocHeaderAux.SetRange("Record Type", 'RECTL');
                rEDITempDocHeaderAux.SetRange("Entry No.", CurrentOrderFromEntryNo);
                rEDITempDocHeaderAux.SetRange("Identificador", RECTLIdentificacionMensaje);
                //
                rEDITempDocHeaderAux.SetRange("Record Name", 'CodigoEmisor');
                if not rEDITempDocHeaderAux.FindFirst() then
                    Error('No se ha podido localizar el registro con el código del emisor');

                // Buscamos el cliente
                IsAmazon := false;
                rCustomer.Reset;
                rCustomer.SetRange("EDI ID", rEDITempDocHeaderAux.MoveText(rEDITempDocHeaderAux));
                if rCustomer.FindSet then begin
                    if rCustomer.Count > 1 then
                        Error('Se han encontrado múltiples clientes con el código ' + rCustomer.GetFilter("EDI ID"));
                    if rCustomer.Blocked <> rCustomer.Blocked::" " then
                        Error('El cliente %1 está bloqueado', rCustomer."No.");
                    if rCustomer."No EDI" = true then
                        Error('El cliente %1 no tiene activa la gestión EDI', rCustomer."No.");
                end
                else begin
                    // Para AMAZON localizamos la raiz del código emisor. No viene el código del Emisor ¿?
                    rCustomer.Reset;
                    rCustomer.SetFilter("EDI ID", '%1', CopyStr(rEDITempDocHeaderAux.MoveText(rEDITempDocHeaderAux), 1, 8) + '*');
                    if not rCustomer.FindFirst() then
                        Error('No se ha podido localizar el cliente con código ' + rCustomer.GetFilter("EDI ID"));
                    // Buscamos el registro SEH1D - calificador: SU, para localizar la 'tienda' AMAZON
                    rEDITempDocHeaderAux.Reset();
                    rEDITempDocHeaderAux.SetRange("Record Type", 'SEH1D');
                    rEDITempDocHeaderAux.SetRange("Entry No.", CurrentOrderFromEntryNo);
                    rEDITempDocHeaderAux.SetRange("Identificador", RECTLIdentificacionMensaje);
                    rEDITempDocHeaderAux.SetRange("Record Name", 'CalificadorInterlocutor');
                    rEDITempDocHeaderAux.SetRange("Text Value", 'SU');
                    if not rEDITempDocHeaderAux.FindFirst() then
                        Error('No se ha podido localizar el registro SEH1D con el calificador del interlocutor SU');

                    ParentLine := rEDITempDocHeaderAux."Parent Line";
                    rEDITempDocHeaderAux.Reset();
                    rEDITempDocHeaderAux.SetRange("Record Type", 'SEH1D');
                    rEDITempDocHeaderAux.SetRange("Entry No.", CurrentOrderFromEntryNo);
                    rEDITempDocHeaderAux.SetRange("Identificador", RECTLIdentificacionMensaje);
                    rEDITempDocHeaderAux.SetRange("Parent Line", ParentLine);
                    rEDITempDocHeaderAux.SetRange("Record Name", 'CodigoInterlocutor');
                    if not rEDITempDocHeaderAux.FindFirst() then
                        Error('No se ha podido localizar el registro SEH1D - SU : CodigoInterlocutor');

                    rCustomer.SetRange("Our Account No.", rEDITempDocHeaderAux.MoveText(rEDITempDocHeaderAux));
                    if not rCustomer.FindFirst() then
                        Error('No se ha podido localizar en AMAZON el interlocutor:', rEDITempDocHeaderAux.MoveText(rEDITempDocHeaderAux))

                    else
                        IsAmazon := true;
                end;

                SalesHeader.Validate(SalesHeader."Sell-to Customer No.", rCustomer."No.");

                // Recuperamos datos de la devolución
                rEDITempDocHeaderAux.Reset();
                rEDITempDocHeaderAux.SetRange("Record Type", 'SEH1C');
                rEDITempDocHeaderAux.SetRange("Entry No.", CurrentOrderFromEntryNo);
                rEDITempDocHeaderAux.SetRange("Identificador", RECTLIdentificacionMensaje);
                rEDITempDocHeaderAux.SetRange("Record Name", 'TipoRegistro');
                if rEDITempDocHeaderAux.FindFirst() then begin
                    // Linea de referencia del registro.
                    rEDITempDocHeaderAux.SetRange("Parent Line", rEDITempDocHeaderAux."Parent Line");

                    // Numero de documento
                    rEDITempDocHeaderAux.SetRange("Record Name", 'NumeroDocumento');
                    if rEDITempDocHeaderAux.FindFirst() then
                        SalesHeader.Validate("External Document No.", rEDITempDocHeaderAux.MoveText(rEDITempDocHeaderAux));
                    // Referencias
                    rEDITempDocHeaderAux.SetRange("Record Name", 'CalificadorReferencia1');
                    if rEDITempDocHeaderAux.FindFirst() then
                        SalesHeader.Validate("EDI - Calificador Referencia 1", rEDITempDocHeaderAux.MoveText(rEDITempDocHeaderAux));
                    rEDITempDocHeaderAux.SetRange("Record Name", 'NumeroReferencia1');
                    if rEDITempDocHeaderAux.FindFirst() then
                        SalesHeader.Validate("EDI - Referencia 1", rEDITempDocHeaderAux.MoveText(rEDITempDocHeaderAux));
                    rEDITempDocHeaderAux.SetRange("Record Name", 'CalificadorReferencia2');
                    if rEDITempDocHeaderAux.FindFirst() then
                        SalesHeader.Validate("EDI - Calificador Referencia 2", rEDITempDocHeaderAux.MoveText(rEDITempDocHeaderAux));
                    rEDITempDocHeaderAux.SetRange("Record Name", 'NumeroReferencia2');
                    if rEDITempDocHeaderAux.FindFirst() then
                        SalesHeader.Validate("EDI - Referencia 2", rEDITempDocHeaderAux.MoveText(rEDITempDocHeaderAux));
                    if IsAmazon then begin
                        //rEDITempDocHeaderAux.SetRange("Record Name", 'CalificadorReferencia3');
                        //if rEDITempDocHeaderAux.FindFirst() then
                        //    SalesHeader.Validate("EDI - Calificador Referencia 2", rEDITempDocHeaderAux.MoveText(rEDITempDocHeaderAux));

                        // Marcar la devolucion con AMZN
                        SalesHeader.validate("Your Reference", 'AMZN');
                        rEDITempDocHeaderAux.SetRange("Record Name", 'NumeroReferencia3');
                        if rEDITempDocHeaderAux.FindFirst() then
                            SalesHeader.Validate("Your Reference", rEDITempDocHeaderAux.MoveText(rEDITempDocHeaderAux));
                    end;

                    if IsAmazon then begin
                        // Localizar el trasporte 
                        rEDITempDocHeaderAux.Reset();
                        rEDITempDocHeaderAux.SetRange("Record Type", 'SEH1D');
                        rEDITempDocHeaderAux.SetRange("Entry No.", CurrentOrderFromEntryNo);
                        rEDITempDocHeaderAux.SetRange("Identificador", RECTLIdentificacionMensaje);
                        rEDITempDocHeaderAux.SetRange("Record Name", 'CalificadorInterlocutor');
                        rEDITempDocHeaderAux.SetRange("Text Value", 'CA');
                        if rEDITempDocHeaderAux.FindFirst() then begin
                            ParentLine := rEDITempDocHeaderAux."Parent Line";
                            rEDITempDocHeaderAux.Reset();
                            rEDITempDocHeaderAux.SetRange("Record Type", 'SEH1D');
                            rEDITempDocHeaderAux.SetRange("Entry No.", CurrentOrderFromEntryNo);
                            rEDITempDocHeaderAux.SetRange("Identificador", RECTLIdentificacionMensaje);
                            rEDITempDocHeaderAux.SetRange("Parent Line", ParentLine);
                            rEDITempDocHeaderAux.SetRange("Record Name", 'CodigoInterlocutor');
                            if rEDITempDocHeaderAux.FindFirst() then
                                SalesHeader."Shipping Agent Code" := CopyStr(rEDITempDocHeaderAux.MoveText(rEDITempDocHeaderAux), 1, 10);
                        end;
                        // Concatenar referencia2 + referencia1
                        TextAux := SalesHeader."EDI - Referencia 2" + '-' + SalesHeader."EDI - Referencia 1";
                        SalesHeader.Validate("External Document No.", CopyStr(TextAux, 1, 35));

                        // Localizar el tracking de Amazon
                        rEDITempDocHeaderAux.Reset();
                        rEDITempDocHeaderAux.SetRange("Record Type", 'SEH1P');
                        rEDITempDocHeaderAux.SetRange("Entry No.", CurrentOrderFromEntryNo);
                        rEDITempDocHeaderAux.SetRange("Identificador", RECTLIdentificacionMensaje);
                        rEDITempDocHeaderAux.SetRange("Record Name", 'ReferenciaTracking');
                        rEDITempDocHeaderAux.SetRange("Text Value", 'CN');
                        if rEDITempDocHeaderAux.FindFirst() then begin
                            ParentLine := rEDITempDocHeaderAux."Parent Line";
                            rEDITempDocHeaderAux.Reset();
                            rEDITempDocHeaderAux.SetRange("Record Type", 'SEH1P');
                            rEDITempDocHeaderAux.SetRange("Entry No.", CurrentOrderFromEntryNo);
                            rEDITempDocHeaderAux.SetRange("Identificador", RECTLIdentificacionMensaje);
                            rEDITempDocHeaderAux.SetRange("Parent Line", ParentLine);
                            rEDITempDocHeaderAux.SetRange("Record Name", 'NumeroTracking');
                            if rEDITempDocHeaderAux.FindFirst() then
                                SalesHeader."Package Tracking No." := CopyStr(rEDITempDocHeaderAux.MoveText(rEDITempDocHeaderAux), 1, 35);
                        end;
                    end;
                end;

                SalesHeader.Modify;

                //>> Marcamos el registro NAC/PL y actualizamos el código del cliente
                pEDIEntry.Validate("Source Type", pEDIEntry."Source Type"::Customer);
                pEDIEntry.Validate("Sourde Id", rCustomer."No.");
                pEDIEntry.Validate("Source Name", rCustomer."Name");
                pEDIEntry.Validate("PL Entry", false);
                if rCustomer."VAT PL" then
                    pEDIEntry.Validate("PL Entry", true);
                pEDIEntry.Modify();

                // Lineas de la devolución
                CreateLinesSalesReturn(rEDITempDocHeader);

            until rEDITempDocHeader.Next = 0;
    end;

    local procedure CreateLinesSalesReturn(pEDITempDocHeader: Record "EDI - Temporary Documents")
    var
        rEDITempDocLines: Record "EDI - Temporary Documents";
        rEDITempDocLinesAux: Record "EDI - Temporary Documents";
        rWarehouseSetup: Record "Warehouse Setup";
        CurrentOrderFromEntryNo: integer;
        CodigoEANArticulo: Code[20];
        ArticuloComprador: Code[50];
        rItemIdentifier: Record "Item Identifier";
        rItem: Record Item;
        rItemReference: Record "Item Reference";
        rItemUnitofMeasure: Record "Item Unit of Measure";
    begin
        Clear(CodigoEANArticulo);
        Clear(ArticuloComprador);
        rWarehouseSetup.Get();
        CurrentOrderFromEntryNo := pEDITempDocHeader."Entry No.";
        rEDITempDocLines.Reset();
        rEDITempDocLines.SetRange("Entry No.", CurrentOrderFromEntryNo);
        rEDITempDocLines.SetRange("Record Type", 'SEH1L');
        rEDITempDocLines.SetRange("Identificador", RECTLIdentificacionMensaje);
        rEDITempDocLines.SetRange("Record Name", 'TipoRegistro');
        rEDITempDocLines.SetRange("Text Value", 'SEH1L');
        if rEDITempDocLines.FindSet() then
            repeat begin
                if SalesHeader."No." <> '' then begin

                    rEDITempDocLinesAux.Reset();
                    rEDITempDocLinesAux.SetRange("Entry No.", CurrentOrderFromEntryNo);
                    rEDITempDocLinesAux.SetRange("Record Type", 'SEH1L');
                    rEDITempDocLinesAux.SetRange("Identificador", RECTLIdentificacionMensaje);
                    rEDITempDocLinesAux.SetRange("Parent Line", rEDITempDocLines."Parent Line");
                    rEDITempDocLinesAux.SetRange("Record Name", 'NumeroLineaArticulo');
                    if rEDITempDocLinesAux.FindFirst() then begin
                        SalesLine.Init;
                        SalesLine.Validate("Document Type", SalesHeader."Document Type");
                        SalesLine.Validate("Document No.", SalesHeader."No.");
                        SalesLine.Validate("Line No.", rEDITempDocLinesAux.MoveInteger(rEDITempDocLinesAux));
                        SalesLine.Validate(Type, SalesLine.Type::Item);
                        SalesLine.Insert(true);

                        rEDITempDocLinesAux.SetRange("Record Name", 'CodigoEANArticulo');
                        if rEDITempDocLinesAux.FindFirst() then
                            CodigoEANArticulo := format(rEDITempDocLinesAux.MoveText(rEDITempDocLinesAux));
                        rItemIdentifier.Reset;
                        rItemIdentifier.SetRange(Code, CodigoEANArticulo);
                        if rItemIdentifier.FindFirst then begin
                            SalesLine.Validate("No.", rItemIdentifier."Item No.");
                            SalesLine.Validate("EDI - EAN13/DUN14", rItemIdentifier."Code");
                        end
                        else begin
                            rEDITempDocLinesAux.SetRange("Record Name", 'NumeroArticuloComprador');
                            if rEDITempDocLinesAux.FindFirst() then
                                ArticuloComprador := format(rEDITempDocLinesAux.MoveText(rEDITempDocLinesAux));
                            if ArticuloComprador = '' then begin
                                rEDITempDocLinesAux.SetRange("Record Name", 'DenominacionComercial');
                                if rEDITempDocLinesAux.FindFirst() then
                                    ArticuloComprador := format(rEDITempDocLinesAux.MoveText(rEDITempDocLinesAux));
                            end;
                            if ArticuloComprador <> '' then begin
                                rItemReference.Reset;
                                rItemReference.SetRange("Reference Type", rItemReference."Reference Type"::Customer);
                                rItemReference.SetRange("Reference Type No.", SalesHeader."Sell-to Customer No.");
                                rItemReference.SetRange("Reference No.", ArticuloComprador);
                                if rItemReference.FindFirst() then
                                    SalesLine.Validate("No.", rItemReference."Item No.");
                            end
                            else
                                Error('No se ha podido encontrar producto para la linea: %1' + Format(SalesLine."Line No."));
                        end;

                        rItem.Reset;
                        rItem.Get(SalesLine."No.");
                        rItem.TestField("Base Unit of Measure");
                        SalesLine.Validate("Unit of Measure Code", rItem."Base Unit of Measure");

                        rItemUnitofMeasure.Reset;
                        rItemUnitofMeasure.SetRange("Item No.", rItem."No.");
                        rItemUnitofMeasure.SetRange(Code, rItem."Base Unit of Measure");
                        if not rItemUnitofMeasure.FindFirst then
                            Error('Falta Cdad. por Unidad Medida %1 del producto %2', rItemIdentifier."Unit of Measure Code", rItem."No.");

                        rEDITempDocLinesAux.SetRange("Record Name", 'CantidadEnviada');
                        if rEDITempDocLinesAux.FindFirst() then
                            SalesLine.Validate(Quantity, rEDITempDocLinesAux.MoveDecimal(rEDITempDocLinesAux));

                        // Almacén por defecto de devoluciones DEVOL-2
                        SalesLine."Location Code" := rWarehouseSetup."Default Return Location";

                        SalesLine.Modify(true);
                    end;
                end
            end;
            until rEDITempDocLines.Next = 0;
    end;

    /******************************************************************/
    /************************* EDI - UTILITIES ************************/
    /******************************************************************/
    local procedure ConvertText(StringIni: Text): Text
    var
        Char160: Text[1];
        NewString: Text;
        BaseText: label 'áàéèíìòóùúÁÀÉÈÍÌÓÒÚÙäëïöüÄËÏÖÜâêîôûÂÊÎÔÛºªçÇñÑ';
        CorrectedText: label 'aaeeiioouuAAEEIIOOUUaeiouAEIOUaeiouAEIOUoacCnN';
    begin
        Clear(Char160);
        Char160[1] := 160;
        Clear(NewString);

        StringIni := ConvertStr(StringIni, Format(Char160), ' ');       // Primero limpiamos el texto del caracter ansii Char160
        NewString := ConvertStr(StringIni, BaseText, CorrectedText);    // Sustituimos los caracteres 'raros'

        exit(NewString);
    end;

    local procedure ReadTextField(var WriteToThisVar: Text; StreamText: Text; StartingPosition: Integer; Length: Integer)
    begin
        if (StartingPosition = 0) or (Length = 0) or (StreamText = '') then Error('Debe especificar variables válidas');
        WriteToThisVar := '';
        WriteToThisVar := CopyStr(StreamText, StartingPosition, Length);
        WriteToThisVar := DelChr(WriteToThisVar, '<', ' ');
        WriteToThisVar := DelChr(WriteToThisVar, '>', ' ');
    end;

    local procedure ReadDatetimeField(var WriteToThisVar: DateTime; StreamText: Text; StartingPosition: Integer; Length: Integer)
    var
        Year: Integer;
        Month: Integer;
        Day: Integer;
        Hour: Integer;
        Minute: Integer;
        DummyDate: Date;
        DummyTime: Time;
    begin
        // El único formato aceptado hasta ahora es: CCYYMMDDHHMM
        if (StartingPosition = 0) or (Length = 0) or (StreamText = '') then Error('Debe especificar variables válidas');
        WriteToThisVar := 0DT;
        Year := 0;
        Month := 0;
        Day := 0;
        Hour := 0;
        Minute := 0;
        if Evaluate(Year, CopyStr(StreamText, StartingPosition, 4)) then;
        if Evaluate(Month, CopyStr(StreamText, StartingPosition + 4, 2)) then;
        if Evaluate(Day, CopyStr(StreamText, StartingPosition + 6, 2)) then;
        if Evaluate(Hour, CopyStr(StreamText, StartingPosition + 8, 2)) then;
        if Evaluate(Minute, CopyStr(StreamText, StartingPosition + 10, 2)) then;
        if (Year <> 0) and (Month <> 0) and (Day <> 0) then begin
            DummyDate := Dmy2date(Day, Month, Year); // Creamos fecha
            Evaluate(DummyTime, Format(Hour) + ':' + Format(Minute) + ':00'); // Creamos hora
            WriteToThisVar := CreateDatetime(DummyDate, DummyTime); // Creamos fecha/hora
        end
        else
            WriteToThisVar := 0DT;
    end;

    local procedure ReadDateField(var WriteToThisVar: Date; StreamText: Text; StartingPosition: Integer; Length: Integer)
    var
        Year: Integer;
        Month: Integer;
        Day: Integer;
    begin
        // El único formato aceptado hasta ahora es: CCYYMMDDHHMM
        if (StartingPosition = 0) or (Length = 0) or (StreamText = '') then Error('Debe especificar variables válidas');
        WriteToThisVar := 0D;
        Year := 0;
        Month := 0;
        Day := 0;
        if Evaluate(Year, CopyStr(StreamText, 1, 4)) then;
        if Evaluate(Month, CopyStr(StreamText, 5, 2)) then;
        if Evaluate(Day, CopyStr(StreamText, 7, 2)) then;
        if (Year <> 0) and (Month <> 0) and (Day <> 0) then WriteToThisVar := Dmy2date(Day, Month, Year); // Creamos fecha
    end;

    local procedure ReadDecimalField(var WriteToThisVar: Decimal; StreamText: Text; StartingPosition: Integer; Length: Integer)
    var
        DecTxt: Text[50];
    begin
        // Aceptamos 14 enteros y 3 decimales
        //IF Length<14+1+3 THEN ERROR('La longitud solicitada no concuerda con el formato decimal especificado'); //Entero+punto+decimales
        if (StartingPosition = 0) or (Length = 0) or (StreamText = '') then Error('Debe especificar variables válidas');
        WriteToThisVar := 0;
        DecTxt := CopyStr(StreamText, StartingPosition, Length);
        DecTxt := ConvertStr(DecTxt, '.', ',');
        Evaluate(WriteToThisVar, DecTxt);
    end;

    local procedure ReadIntegerField(var WriteToThisVar: Integer; StreamText: Text; StartingPosition: Integer; Length: Integer)
    begin
        // Aceptamos 14 enteros y 3 decimales
        //IF Length<14+1+3 THEN ERROR('La longitud solicitada no concuerda con el formato decimal especificado'); //Entero+punto+decimales
        if (StartingPosition = 0) or (Length = 0) or (StreamText = '') then Error('Debe especificar variables válidas');
        WriteToThisVar := 0;
        Evaluate(WriteToThisVar, CopyStr(StreamText, StartingPosition, Length));
    end;

    local procedure WriteTextField(WriteToThisVar: Text; var StreamText: Text; Length: Integer)
    begin
        //>> BBT 03/12/2021
        WriteToThisVar := CopyStr(WriteToThisVar, 1, Length);
        //<<
        WriteToThisVar := DelChr(WriteToThisVar, '<', ' ');
        WriteToThisVar := DelChr(WriteToThisVar, '>', ' ');
        WriteToThisVar := WriteToThisVar + PadStr('', Length - StrLen(WriteToThisVar));

        WriteToThisVar := ConvertText(WriteToThisVar);

        StreamText := StreamText + WriteToThisVar;
    end;

    local procedure WriteDatetimeField(WriteToThisVar: DateTime; var StreamText: Text; Length: Integer)
    var
        Year: Text[4];
        Month: Text[2];
        Day: Text[2];
        Hour: Text[2];
        Minute: Text[2];
        TextDateTime: Text[250];
    begin
        // El único formato aceptado hasta ahora es: CCYYMMDDHHMM
        TextDateTime := '';
        Year := Format(WriteToThisVar, 0, '<Year4>');
        Month := Format(WriteToThisVar, 0, '<Month>');
        if StrLen(Month) = 1 then Month := '0' + Month;
        Day := Format(WriteToThisVar, 0, '<Day>');
        if StrLen(Day) = 1 then Day := '0' + Day;
        Hour := Format(WriteToThisVar, 0, '<Hours24>');
        if StrLen(Hour) = 1 then Hour := '0' + Hour;
        Minute := Format(WriteToThisVar, 0, '<Minutes>');
        if StrLen(Minute) = 1 then Minute := '0' + Minute;
        TextDateTime := Year + Month + Day + Hour + Minute;
        TextDateTime := TextDateTime + PadStr('', Length - StrLen(TextDateTime));
        StreamText := StreamText + TextDateTime;
    end;

    local procedure WriteDateField(WriteToThisVar: Date; var StreamText: Text; Length: Integer)
    var
        Year: Text[4];
        Month: Text[2];
        Day: Text[2];
        TextDate: Text[250];
    begin
        // El único formato aceptado hasta ahora es: CCYYMMDD
        TextDate := '';
        Year := Format(WriteToThisVar, 0, '<Year4>');
        Month := Format(WriteToThisVar, 0, '<Month>');
        if StrLen(Month) = 1 then Month := '0' + Month;
        Day := Format(WriteToThisVar, 0, '<Day>');
        if StrLen(Day) = 1 then Day := '0' + Day;
        // Hour := FORMAT(WriteToThisVar,0,'<Hours24>');
        // IF STRLEN(Hour)=1 THEN Hour := '0'+Hour;
        // Minute := FORMAT(WriteToThisVar,0,'<Minutes>');
        // IF STRLEN(Minute)=1 THEN Minute := '0'+Minute;
        TextDate := Year + Month + Day; //+Hour+Minute;
        TextDate := TextDate + PadStr('', Length - StrLen(TextDate));
        StreamText := StreamText + TextDate;
    end;

    local procedure WritePeriodField(WriteToThisVar: Date; var StreamText: Text; Length: Integer)
    var
        Year: Text[4];
        Month: Text[2];
        FromDay: Text[2];
        ToDay: Text;
        TextDate: Text[250];
    begin
        // El único formato aceptado hasta ahora es: CCYYMMDDCCYYMMDD
        TextDate := '';
        Year := Format(WriteToThisVar, 0, '<Year4>');
        Month := Format(WriteToThisVar, 0, '<Month>');
        if StrLen(Month) = 1 then Month := '0' + Month;
        FromDay := Format(CalcDate('<-CM>', WriteToThisVar), 0, '<Day>');
        if StrLen(FromDay) = 1 then FromDay := '0' + FromDay;
        ToDay := Format(CalcDate('<CM>', WriteToThisVar), 0, '<Day>');
        if StrLen(ToDay) = 1 then ToDay := '0' + ToDay;
        TextDate := Year + Month + FromDay + Year + Month + ToDay;
        TextDate := TextDate + PadStr('', Length - StrLen(TextDate));
        StreamText := StreamText + TextDate;
    end;
    /*  Conversion decimal *** OBSOLETA ***

        local procedure WriteDecimalField(WriteToThisVar: Decimal; var StreamText: Text; Length: Integer)
        var
            DecTxt: Text[50];
        begin
            DecTxt := Format(WriteToThisVar);
            DecTxt := ConvertStr(DecTxt, ',', '.');
            DecTxt := CopyStr(DecTxt, 1, Length);
            DecTxt := PadStr('', Length - StrLen(DecTxt), '0') + DecTxt;
            StreamText := StreamText + DecTxt;
        end;
    */
    local procedure WriteDecimalVarField(WriteToThisVar: Decimal; var StreamText: Text; Length: Integer; Decimals: Integer)
    var
        DecTxt: Text[50];
    begin
        //>>BBT  28/03/2025. Cambio en el formateo de importes decimales(3:3)
        //DecTxt := Format(WriteToThisVar) 
        //DecTxt := DelChr(DecTxt, '=', '.');
        //DecTxt := ConvertStr(DecTxt, ',', '.');
        case Decimals of
            2:
                DecTxt := Format(WriteToThisVar, 0, '<Precision,2:2><Standard Format,2>');
            3:
                DecTxt := Format(WriteToThisVar, 0, '<Precision,3:3><Standard Format,2>');
            4:
                DecTxt := Format(WriteToThisVar, 0, '<Precision,4:4><Standard Format,2>');
            5:
                DecTxt := Format(WriteToThisVar, 0, '<Precision,5:5><Standard Format,2>');
            else
                Error('El cantidad de decimals %1 no tiene formateo', Decimals);
        end;
        //<<
        DecTxt := CopyStr(DecTxt, 1, Length);
        DecTxt := PadStr('', Length - StrLen(DecTxt), '0') + DecTxt;
        StreamText := StreamText + DecTxt;
    end;

    local procedure WriteIntegerField(WriteToThisVar: Integer; var StreamText: Text; Length: Integer)
    var
        IntTxt: Text[150];
    begin
        IntTxt := Format(WriteToThisVar);
        IntTxt := CopyStr(IntTxt, 1, Length);
        IntTxt := PadStr('', Length - StrLen(IntTxt), '0') + IntTxt;
        StreamText := StreamText + IntTxt;
    end;
    /*
        procedure CleanUp()
        var
            EDIEDIEntry: Record "EDI - EDI Entry";
        begin
            if not GuiAllowed then exit;
            if not Confirm('Está seguro de que desea eliminar la info de EDI anterior?') then Error('');
            EDIEDIEntry.Reset;
            EDIEDIEntry.DeleteAll(true);
            SalesHeader.Reset;
            SalesHeader.SetRange("EDI - EDI Order", true);
            SalesHeader.DeleteAll(true);
        end;
    */
    local procedure ClearGlobals()
    begin
        Clear(SalesHeader);
        Clear(SalesLine);
        Clear(PurchaseHeader);
        Clear(PurchaseLine);
        Clear(TempOrder);
        Clear(TempOrderAux);

        Clear(HasError);
        Clear(cont);
        Clear(CreateDocsNo);
    end;

    procedure ReadRMANo(StreamText: Text) RMANo: Code[50]
    var
        RMAKey: label 'RMA';
        StartingCharacters: array[10] of Char;
        EndingCharacters: array[10] of Char;
        i: Integer;
        i2: Integer;
        StartingPosition: Integer;
        FoundMatchingChar: Boolean;
        KeepLooping: Boolean;
        txtCharsToKeep: Code[100];
    begin
        if StrPos(StreamText, RMAKey) = 0 then exit('');
        RMANo := '';
        PrepareRMAArrays(StartingCharacters, EndingCharacters);
        StreamText := CopyStr(StreamText, StrPos(StreamText, RMAKey) + StrLen(RMAKey));
        StreamText := UpperCase(StreamText);
        txtCharsToKeep := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789;: -';
        StreamText := DelChr(StreamText, '=', DelChr(StreamText, '=', txtCharsToKeep));
        KeepLooping := true;
        for i := 1 to StrLen(StreamText) do begin
            if KeepLooping then begin
                FoundMatchingChar := false;
                for i2 := 1 to ArrayLen(StartingCharacters) do begin
                    //IF COPYSTR(StreamText,1,1)=StartingCharacters[i] THEN
                    if StreamText[i] = StartingCharacters[i2] then FoundMatchingChar := true;
                    //StreamText := COPYSTR(StreamText,2);
                end;
                if not FoundMatchingChar then begin
                    KeepLooping := false;
                    StartingPosition := i;
                end;
            end;
        end;
        //IF NOT FoundMatchingChar THEN
        if StartingPosition >= StrLen(StreamText) then
            Error('No se ha podido detectar el nº de RMA correctamente. Póngase en contacto con el administrador del sistema');
        StreamText := CopyStr(StreamText, StartingPosition);
        FoundMatchingChar := false;
        for i := 1 to StrLen(StreamText) do begin
            if not FoundMatchingChar then begin
                for i2 := 1 to ArrayLen(EndingCharacters) do begin
                    if not FoundMatchingChar then FoundMatchingChar := StreamText[i] = EndingCharacters[i2]
                end;
                if not FoundMatchingChar then RMANo += CopyStr(StreamText, i, 1);
            end;
        end;
    end;

    local procedure PrepareRMAArrays(var StartingCharacters: array[10] of Char; var EndingCharacters: array[10] of Char)
    begin
        Clear(StartingCharacters);
        Clear(EndingCharacters);
        StartingCharacters[1] := ' ';
        StartingCharacters[2] := ';';
        StartingCharacters[3] := ':';
        StartingCharacters[4] := 'N';
        StartingCharacters[5] := '_';
        EndingCharacters[1] := ' ';
        EndingCharacters[2] := ';';
        EndingCharacters[3] := ':';
    end;

    procedure GetDocumentNo(): Code[250]
    begin
        if CreateDocsNo <> '' then
            exit(CreateDocsNo)
        else if SalesHeader."No." <> '' then
            exit(SalesHeader."No.")
        else
            exit(PurchaseHeader."No.")
    end;

    procedure SetRetry()
    begin
        Retry := true;
    end;

}
