XmlPort 51103 "BBT Szendex Shipment XML"
//XmlPort 51103 "BBT-IT Szendex Shipment XML"
{
    Direction = Export;
    //Encoding = ISO"-";
    Encoding = ISO88592;
    Namespaces = soapenv = 'http://schemas.xmlsoap.org/soap/envelope/', dir = 'http://www.direcline.com/';

    schema
    {
        textelement(Envelope)
        {
            NamespacePrefix = 'soapenv';

            textelement(Header)
            {
                NamespacePrefix = 'soapenv';
            }
            textelement(Body)
            {
                NamespacePrefix = 'soapenv';

                tableelement("Sales Shipment Header"; "Sales Shipment Header")
                {
                    NamespacePrefix = 'dir';
                    XmlName = 'GrabarExpedicionExpresOS';

                    textelement(GUID)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            Guid := GlobalGUID;
                        end;
                    }
                    textelement(Remitente)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            Remitente := ConvertText(CompanyInformation.Name);
                        end;
                    }
                    textelement(RecogidaReferencia)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            RecogidaReferencia := "Sales Shipment Header"."No.";
                        end;
                    }
                    textelement(RecogidaCodigoDomicilioMemorizado)
                    {
                        NamespacePrefix = 'dir';
                    }
                    textelement(RecogidaDireccion)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            RecogidaDireccion := ConvertText(CompanyInformation.Address + ' ' + CompanyInformation."Address 2");
                        end;
                    }
                    textelement(RecogidaTipoDireccion)
                    {
                        NamespacePrefix = 'dir';
                    }
                    textelement(RecogidaNumeroDireccion)
                    {
                        NamespacePrefix = 'dir';
                    }
                    textelement(RecogidaCodigoPostal)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            RecogidaCodigoPostal := ConvertText(CompanyInformation."Post Code");
                        end;
                    }
                    textelement(RecogidaPais)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            RecogidaPais := ConvertText(GetCountryName(CompanyInformation."Country/Region Code"));
                        end;
                    }
                    textelement(RecogidaPoblacion)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            RecogidaPoblacion := ConvertText(CompanyInformation.City);
                        end;
                    }
                    textelement(RecogidaPisoDireccion)
                    {
                        NamespacePrefix = 'dir';
                    }
                    textelement(RecogidaNombre2)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            RecogidaNombre2 := ConvertText(CompanyInformation."Name 2");
                        end;
                    }
                    textelement(RecogidaMasDatos)
                    {
                        NamespacePrefix = 'dir';
                    }
                    textelement(RecogidaTelefono)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            RecogidaTelefono := ConvertText(CopyStr(CompanyInformation."Phone No.", 1, 20));
                        end;
                    }
                    textelement(RecogidaEmail)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            RecogidaEmail := CompanyInformation."E-Mail";
                        end;
                    }
                    textelement(RecogidaObservacion)
                    {
                        NamespacePrefix = 'dir';
                    }
                    textelement(RecogidaMovil)
                    {
                        NamespacePrefix = 'dir';
                    }
                    textelement(RecogidaNif)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            RecogidaNif := CompanyInformation."VAT Registration No.";
                        end;
                    }
                    textelement(RecogidaPointer)
                    {
                        NamespacePrefix = 'dir';
                    }
                    textelement(RecogidaAvisoEmail)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            RecogidaAvisoEmail := Format(0);
                        end;
                    }
                    textelement(RecogidaAvisoSms)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            RecogidaAvisoSms := Format(0);
                        end;
                    }
                    textelement(RecogidaCodigoTipoServicio)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            // PDTE VER LOS TIPOS DE SERVICIO
                        end;
                    }
                    textelement(RecogidaGestion)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            // PDTE VER LOS TIPOS DE GESTIÓN
                            RecogidaGestion := Format(0);
                        end;
                    }
                    textelement(RecogidaFecha)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            // COMENTAR CÓMO TRATAR LA HORA DE RECOGIDA
                            //RecogidaFecha := '2019-02-11T10:37:00';
                            RecogidaFecha := Format(Today, 0, '<Year4>-<Month,2>-<Day,2>') + 'T00:00:00';
                        end;
                    }
                    textelement(RecogidaHoraInicial)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            // COMENTAR CÓMO TRATAR LA HORA DE RECOGIDA
                            //RecogidaHoraInicial := '14:00:00';
                            RecogidaHoraInicial := '00:00:00';
                        end;
                    }
                    textelement(RecogidaHoraFinal)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            // COMENTAR CÓMO TRATAR LA HORA DE RECOGIDA
                            RecogidaHoraFinal := '23:59:00';
                        end;
                    }
                    textelement(RecogerCliente)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            RecogerCliente := Format(0);
                        end;
                    }
                    textelement(Destinatario)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            //>> BBT 23/01/2023. Destinatario = nombre de la dirección de entrega
                            //Destinatario := ConvertText("Sales Shipment Header"."Ship-to Name"+' '+"Sales Shipment Header"."Ship-to Name 2");
                            SalesHeader.Reset;
                            SalesHeader.SetRange("Document Type", SalesHeader."document type"::Order);
                            SalesHeader.SetRange("No.", "Sales Shipment Header"."Order No.");
                            if SalesHeader.FindFirst() then
                                Destinatario := ConvertText(SalesHeader."Ship-to Name")
                            else
                                Destinatario := ConvertText("Sales Shipment Header"."Ship-to Name" + ' ' + "Sales Shipment Header"."Ship-to Name 2");
                            //<<
                        end;
                    }
                    textelement(EntregaCodigoDomicilioMemorizado)
                    {
                        NamespacePrefix = 'dir';
                    }
                    textelement(EntregaDireccion)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            EntregaDireccion := ConvertText("Sales Shipment Header"."Ship-to Address" + ' ' + "Sales Shipment Header"."Ship-to Address 2");
                            EntregaDireccion := CopyStr(EntregaDireccion, 1, 100);
                        end;
                    }
                    textelement(EntregaTipoDireccion)
                    {
                        NamespacePrefix = 'dir';
                    }
                    textelement(EntregaNumeroDireccion)
                    {
                        NamespacePrefix = 'dir';
                    }
                    textelement(EntregaCodigoPostal)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            EntregaCodigoPostal := ConvertText("Sales Shipment Header"."Ship-to Post Code");
                            //BBT 18/02/2026. Tratamiento especial para el CP de Portugal. Solo las 4 primeras posiciones.
                            if "Sales Shipment Header"."Ship-to Country/Region Code" = 'PT' then
                                EntregaCodigoPostal := ConvertText(COPYSTR("Sales Shipment Header"."Ship-to Post Code", 1, 4));
                        end;
                    }
                    textelement(EntregaPais)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            EntregaPais := ConvertText(GetCountryName("Sales Shipment Header"."Ship-to Country/Region Code"));
                        end;
                    }
                    textelement(EntregaPoblacion)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            EntregaPoblacion := ConvertText("Sales Shipment Header"."Ship-to City");
                        end;
                    }
                    textelement(EntregaPisoDireccion)
                    {
                        NamespacePrefix = 'dir';
                    }
                    textelement(EntregaNombre2)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            EntregaNombre2 := ConvertText("Sales Shipment Header"."Ship-to Name 2");
                        end;
                    }
                    textelement(EntregaMasDatos)
                    {
                        NamespacePrefix = 'dir';
                    }
                    textelement(EntregaTelefono)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        var
                            Contact: Record Contact;
                            Customer: Record Customer;
                        begin
                            if "Sales Shipment Header"."Sell-to Contact No." <> '' then begin
                                Contact.Reset;
                                Contact.Get("Sales Shipment Header"."Sell-to Contact No.");
                                EntregaTelefono := ConvertText(CopyStr(Contact."Phone No.", 1, 20));
                            end
                            else begin
                                Customer.Reset;
                                Customer.Get("Sales Shipment Header"."Sell-to Customer No.");
                                EntregaTelefono := ConvertText(CopyStr(Customer."Phone No.", 1, 20));
                            end;
                            IF EntregaTelefono = '' then EntregaTelefono := "Sales Shipment Header"."Sell-to Phone No.";
                            IF "Sales Shipment Header"."Shpfy order No." <> '' THEN EntregaTelefono := ConvertText(CopyStr("Sales Shipment Header"."Sell-to Phone No.", 1, 20));
                            //BBT 02/02/2026 Quitar prefijo internacional del teléfono.
                            EntregaTelefono := QuitarPrefijoPais(EntregaTelefono)
                        end;
                    }
                    textelement(EntregaEmail)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        var
                            Contact: Record Contact;
                            Customer: Record Customer;
                        begin
                            Clear(EntregaEmail);
                            if "Sales Shipment Header"."Sell-to Contact No." <> '' then begin
                                Contact.Reset;
                                Contact.Get("Sales Shipment Header"."Sell-to Contact No.");
                                EntregaEmail := Contact."E-Mail";
                            end
                            else begin
                                Customer.Reset;
                                Customer.Get("Sales Shipment Header"."Sell-to Customer No.");
                                EntregaEmail := Customer."E-Mail";
                            end;

                            //Albarán Ecommerce. Solo se añade el Email para nuestras propias webs
                            //>>
                            //if "Sales Shipment Header"."Shpfy order No." <> '' then
                            //    EntregaEmail := "Sales Shipment Header"."Sell-to E-mail";
                            CtrlOurWebsite("Sales Shipment Header", EntregaEmail);
                            //<<
                        end;
                    }
                    textelement(EntregaObservacion)
                    {
                        NamespacePrefix = 'dir';
                    }
                    textelement(EntregaMovil)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        var
                            Contact: Record Contact;
                            Customer: Record Customer;
                        begin
                            Clear(EntregaMovil);
                            if "Sales Shipment Header"."Sell-to Contact No." <> '' then begin
                                Contact.Reset;
                                Contact.Get("Sales Shipment Header"."Sell-to Contact No.");
                                EntregaMovil := ConvertText(CopyStr(Contact."Phone No.", 1, 20));
                            end
                            else begin
                                Customer.Reset;
                                Customer.Get("Sales Shipment Header"."Sell-to Customer No.");
                                EntregaMovil := ConvertText(CopyStr(Customer."Phone No.", 1, 20));
                            end;
                            if EntregaMovil = '' then EntregaMovil := "Sales Shipment Header"."Sell-to Phone No.";
                            IF "Sales Shipment Header"."Shpfy order No." <> '' THEN EntregaMovil := ConvertText(CopyStr("Sales Shipment Header"."Sell-to Phone No.", 1, 20));
                            //BBT 02/02/2026 Quitar prefijo internacional del teléfono.
                            EntregaTelefono := QuitarPrefijoPais(EntregaTelefono);
                        end;
                    }
                    textelement(EntregaNif)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            EntregaNif := "Sales Shipment Header"."VAT Registration No.";
                        end;
                    }
                    textelement(EntregaPointer)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            EntregaPointer := Format(0);
                        end;
                    }
                    textelement(EntregaAvisoEmail)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            EntregaAvisoEmail := Format(0); // pendiente decidir
                        end;
                    }
                    textelement(EntregaAvisoSms)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            EntregaAvisoSms := Format(1); // pendiente decidir
                        end;
                    }
                    textelement(EntregaCodigoTipoServicio)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            EntregaCodigoTipoServicio := '0050';
                            if CopyStr("Sales Shipment Header"."Ship-to Post Code", 1, 2) = '07' then // ISLAS BALEARES
                                EntregaCodigoTipoServicio := '0079';
                            if "Sales Shipment Header"."Ship-to Country/Region Code" = 'PT' then // PORTUGAL
                                EntregaCodigoTipoServicio := '0004';
                        end;
                    }
                    textelement(EntregaGestion)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            EntregaGestion := Format(0);
                        end;
                    }
                    textelement(EntregaFecha)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            // pendiente decidir
                            EntregaFecha := Format(Today, 0, '<Year4>-<Month,2>-<Day,2>') + 'T00:00:00';
                            //EntregaFecha := '2019-02-11T10:37:00';
                        end;
                    }
                    textelement(Retorno)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            // pendiente aclarar y decidir
                            Retorno := Format(0);
                        end;
                    }
                    textelement(AcuseRecibo)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            AcuseRecibo := Format(0);
                        end;
                    }
                    textelement(ImporteValor)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            // pendiente aclarar decidir
                            ImporteValor := Format(0);
                        end;
                    }
                    textelement(ImporteReembolso)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            // pendiente aclarar y decidir
                            ImporteReembolso := Format(0);
                        end;
                    }
                    textelement(ImporteCobroACuenta)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            // pendiente aclarar y decidir
                            ImporteCobroACuenta := Format(0);
                        end;
                    }
                    textelement(ImporteDebido)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            ImporteDebido := Format(0);
                        end;
                    }
                    textelement(BultoTotal)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        var
                            Packaging: Record Packaging;
                        begin
                            Packaging.Reset;
                            Packaging.SetRange("Posted Source No.", "Sales Shipment Header"."No.");
                            Packaging.FindSet;
                            BultoTotal := Format(Packaging.Count);
                        end;
                    }
                    tableelement(bultonumero; Packaging)
                    {
                        LinkFields = "Posted Source No." = field("No.");
                        LinkTable = "Sales Shipment Header";
                        NamespacePrefix = 'dir';
                        XmlName = 'BultoNumero';

                        textelement(bultonumeroshort)
                        {
                            NamespacePrefix = 'dir';
                            XmlName = 'short';

                            trigger OnBeforePassVariable()
                            begin
                                PackagingCount += 1;
                                BultoNumeroShort := Format(PackagingCount);
                            end;
                        }
                    }
                    tableelement(bultoalto; Packaging)
                    {
                        LinkFields = "Posted Source No." = field("No.");
                        LinkTable = "Sales Shipment Header";
                        NamespacePrefix = 'dir';
                        XmlName = 'BultoAlto';

                        textelement(bultoaltofloat)
                        {
                            NamespacePrefix = 'dir';
                            XmlName = 'float';

                            trigger OnBeforePassVariable()
                            begin
                                //>>BBT 25/06/20205. Pasar la medida a centimetros (está en metros)
                                //BultoAltoFloat := FormatDecValue(BultoAlto."Height Dimension 1 (HT)");
                                BultoAltoFloat := FormatDecValue(BultoAlto."Height Dimension 1 (HT)" * 100);
                                //<<
                            end;
                        }
                    }
                    tableelement(bultoancho; Packaging)
                    {
                        LinkFields = "Posted Source No." = field("No.");
                        LinkTable = "Sales Shipment Header";
                        NamespacePrefix = 'dir';
                        XmlName = 'BultoAncho';

                        textelement(bultoanchofloat)
                        {
                            NamespacePrefix = 'dir';
                            XmlName = 'float';

                            trigger OnBeforePassVariable()
                            begin
                                //>>BBT 25/06/20205. Pasar la medida a centimetros (está en metros)
                                //BultoAnchoFloat := FormatDecValue(BultoAncho."Width Dimension 1 (WD)");
                                BultoAnchoFloat := FormatDecValue(BultoAncho."Width Dimension 1 (WD)" * 100);
                                //<<
                            end;
                        }
                    }
                    tableelement(bultolargo; Packaging)
                    {
                        LinkFields = "Posted Source No." = field("No.");
                        LinkTable = "Sales Shipment Header";
                        NamespacePrefix = 'dir';
                        XmlName = 'BultoLargo';

                        textelement(bultolargofloat)
                        {
                            NamespacePrefix = 'dir';
                            XmlName = 'float';

                            trigger OnBeforePassVariable()
                            begin
                                //>>BBT 25/06/20205. Pasar la medida a centimetros (está en metros)
                                //BultoLargoFloat := FormatDecValue(BultoLargo."Length Dimension 1 (LN)");
                                BultoLargoFloat := FormatDecValue(BultoLargo."Length Dimension 1 (LN)" * 100);
                                //<<
                            end;
                        }
                    }
                    tableelement(bultopeso; Packaging)
                    {
                        LinkFields = "Posted Source No." = field("No.");
                        LinkTable = "Sales Shipment Header";
                        NamespacePrefix = 'dir';
                        XmlName = 'BultoPeso';

                        textelement(bultopesofloat)
                        {
                            NamespacePrefix = 'dir';
                            XmlName = 'float';

                            trigger OnBeforePassVariable()
                            begin
                                BultoPesoFloat := FormatDecValue(BultoPeso."Gross Weight 1 (AAD)");
                            end;
                        }
                    }
                    tableelement(bultocodigocontenido; Packaging)
                    {
                        LinkFields = "Posted Source No." = field("No.");
                        LinkTable = "Sales Shipment Header";
                        NamespacePrefix = 'dir';
                        XmlName = 'BultoCodigoContenido';

                        textelement(bultocodigocontenidostring)
                        {
                            NamespacePrefix = 'dir';
                            XmlName = 'string';

                            trigger OnBeforePassVariable()
                            begin
                                // pendiente aclarar
                                BultoCodigoContenidoString := 'PAQ';
                            end;
                        }
                    }
                    tableelement(bultoobservacion; Packaging)
                    {
                        LinkFields = "Posted Source No." = field("No.");
                        LinkTable = "Sales Shipment Header";
                        NamespacePrefix = 'dir';
                        XmlName = 'BultoObservacion';

                        textelement(bultoobservacionstring)
                        {
                            NamespacePrefix = 'dir';
                            XmlName = 'string';

                            trigger OnBeforePassVariable()
                            begin
                                //BultoObservacionString := BultoObservacion."Handling Instructions Text";
                                BultoObservacionString := ConvertText(GetSSCC);
                            end;
                        }
                    }
                    tableelement(bultoreferencia; Packaging)
                    {
                        LinkFields = "Posted Source No." = field("No.");
                        LinkTable = "Sales Shipment Header";
                        NamespacePrefix = 'dir';
                        XmlName = 'BultoReferencia';

                        textelement(bultoreferenciastring)
                        {
                            NamespacePrefix = 'dir';
                            XmlName = 'string';

                            trigger OnBeforePassVariable()
                            begin
                                BultoReferenciaString := BultoReferencia."No.";
                            end;
                        }
                    }
                    textelement(Referencia)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            Referencia := "Sales Shipment Header"."No.";
                        end;
                    }
                    trigger OnAfterGetRecord()
                    begin
                        PackagingCount := 0;
                    end;
                }
            }
        }
    }
    requestpage
    {
        layout
        { }
        actions
        { }
    }
    trigger OnPreXmlPort()
    begin
        CompanyInformation.Reset;
        CompanyInformation.Get;
    end;

    var
        CompanyInformation: Record "Company Information";
        PackagingCount: Integer;
        GlobalGUID: Text;
        Packaging: Record Packaging;
        SalesHeader: Record "Sales Header";

    procedure SetGUID(parGUID: Text)
    begin
        GlobalGUID := parGUID;
    end;

    local procedure GetCountryName(CountryRegionCode: Code[20]): Text
    var
        CountryRegion: Record "Country/Region";
    begin
        CountryRegion.Reset;
        if CountryRegion.Get(CountryRegionCode) then
            exit(ConvertText(CountryRegion.Name))
        else
            exit(CountryRegionCode);
    end;

    local procedure FormatDecValue(DummyDec: Decimal): Text
    var
        IntegerPart: Text;
        DecimalPart: Text;
    begin
        if DummyDec = 0 then
            exit('0')
        else begin
            IntegerPart := Format(DummyDec, 0, '<Integer>');
            DecimalPart := Format(DummyDec, 0, '<Decimals>');
            if DecimalPart <> '' then
                exit(IntegerPart + '.' + CopyStr(DecimalPart, 2))
            else
                exit(IntegerPart);
        end;
    end;

    local procedure GetSSCC() PackageDescription: Text
    var
        CONT: Integer;
    begin
        CONT := 0;
        PackageDescription := '';
        Packaging.Reset;
        Packaging.SetRange(Packaging."Posted Source Type", 110);
        Packaging.SetRange(Packaging."Posted Source No.", "Sales Shipment Header"."No.");
        if Packaging.FindSet then
            repeat
                PackageDescription := PackageDescription + ' ' + Packaging."No.";
                CONT := CONT + 1;
            until (Packaging.Next = 0) or (CONT = 2);
    end;

    local procedure ConvertText(StringIni: Text): Text
    var
        Char160: Text[1];
        NewString: Text;
        BaseText: label 'áàéèíiòóùúÁÀÉÈÍÌÓÒÚÙäëïöüÄËÏÖÜºªçÇ'; //'áàéèíiòóùúÁÀÉÈÍÌÓÒÚÙäëïöüÄËÏÖÜºª''çÇ';
        CorrectedText: label 'aaeeiioouuAAEEIIOOUUaeiouAEIOUoacC'; //'aaeeiioouuAAEEIIOOUUaeiouAEIOUoa,cC';
    begin
        Clear(Char160);
        Char160[1] := 160;
        Clear(NewString);

        StringIni := ConvertStr(StringIni, Format(Char160), ' ');       // Primero limpiamos del texto el caracter ansii Char160
        NewString := ConvertStr(StringIni, BaseText, CorrectedText);    // Sustituimos los caracteres 'raros'

        exit(NewString);
    end;

    local procedure CtrlOurWebsite(pShpyOderHeader: Record "Sales Shipment Header"; var pEntregaEmail: text)
    var
        rShpyOderHeader: Record "Shpfy Order Header";
        rShpyShop: Record "Shpfy Shop";
    begin
        rShpyOderHeader.Reset();
        rShpyOderHeader.SetRange("Shopify Order Id", pShpyOderHeader."Shpfy Order Id");
        if rShpyOderHeader.FindFirst() then begin
            rShpyShop.Reset();
            rShpyShop.SetRange(rShpyShop.Code, rShpyOderHeader."Shop Code");
            rShpyShop.SetRange(Enabled, true);   // Solo están activadas las tiendas NO MARKETPLACE
            if rShpyShop.FindFirst() then
                pEntregaEmail := "Sales Shipment Header"."Sell-to E-mail"
            else
                pEntregaEmail := '';
        end;
    end;

    local procedure QuitarPrefijoPais(TelefonoOriginal: Text): Text
    var
        TelefonoAux: Text;
    begin
        TelefonoAux := TelefonoOriginal.Replace(' ', '');
        TelefonoAux := TelefonoAux.Replace('+', '');
        TelefonoAux := TelefonoAux.Replace('-', '');
        TelefonoAux := TelefonoAux.Replace('.', '');
        TelefonoAux := TelefonoAux.Replace('(', '');
        TelefonoAux := TelefonoAux.Replace(')', '');
        TelefonoAux := TelefonoAux.Replace('T', '');

        case "Sales Shipment Header"."Ship-to Country/Region Code" of
            (''), ('ES'):   //España (+34)
                begin
                    if TelefonoAux.Substring(1, 2) = '34' then
                        TelefonoAux := TelefonoAux.Replace('34', '')
                end;
            ('PT'):         //Portugal (+351)
                begin
                    if TelefonoAux.Substring(1, 3) = '351' then
                        TelefonoAux := TelefonoAux.Replace('351', '');

                    TelefonoAux := StrSubstNo('00351%1', TelefonoAux)
                end;
        end;

        exit(TelefonoAux);
    end;
}
