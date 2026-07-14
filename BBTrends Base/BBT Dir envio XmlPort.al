XmlPort 50004 "Dir envio"
{
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Ship-to Address";
            "Ship-to Address")
            {
                AutoSave = false;
                XmlName = 'DirEnvio';

                fieldelement(CodCliente;
                "Ship-to Address"."Customer No.")
                {
                    trigger OnAfterAssignField()
                    begin
                        // "Ship-to Address"."Customer No." := PADSTR('',6 - STRLEN("Ship-to Address"."Customer No."),'0') + "Ship-to Address"."Customer No.";
                        /*DirEnvio.SETRANGE("Customer No.","Ship-to Address"."Customer No.");
                                            IF DirEnvio.FINDLAST THEN
                                              "Ship-to Address".Code  := INCSTR(DirEnvio.Code)
                                            ELSE
                                            "Ship-to Address".Code  := '1';
                                            */
                    end;
                }
                textelement(NombreLocalizacion)
                { }
                textelement(Codigo)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        CodeTabla.Reset;
                        CodeTabla."Dimension Code" := "Ship-to Address"."Customer No.";
                        if not CodeTabla.Find then begin
                            CodeTabla."Dimension Value Code" := '1';
                            CodeTabla.Insert;
                        end
                        else begin
                            CodeTabla."Dimension Value Code" := IncStr(CodeTabla."Dimension Value Code");
                            CodeTabla.Modify;
                        end;
                        "Ship-to Address".Code := CodeTabla."Dimension Value Code";
                    end;
                }
                textelement(Direccion)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        "Ship-to Address".Name := NombreLocalizacion;
                        Clear(Lineas);
                        /*PartirLinea(Lineas,50,Direccion,NumLineas);
                                        "Ship-to Address".Address := Lineas[1];
                                        "Ship-to Address"."Address 2" := Lineas[2];*/
                        LineaDireccion1 := '';
                        LineaDireccion2 := '';
                        Posicion := StrPos(Direccion, '|');
                        if Posicion <> 0 then begin
                            LineaDireccion1 := DelChr(CopyStr(Direccion, 1, Posicion - 1), '=', '|');
                            LineaDireccion2 := DelChr(CopyStr(Direccion, Posicion + 1, StrLen(Direccion)), '=', '|');
                        end
                        else begin
                            Clear(Lineas);
                            NumLineas := 0;
                            PartirLinea(Lineas, 50, Direccion, NumLineas);
                            LineaDireccion1 := Lineas[1];
                            LineaDireccion2 := Lineas[2];
                        end;
                        "Ship-to Address".Address := LineaDireccion1;
                        "Ship-to Address"."Address 2" := LineaDireccion2;
                    end;
                }
                textelement(CP)
                {
                    MinOccurs = Zero;

                    trigger OnAfterAssignVariable()
                    begin
                        //IF STRLEN(CP) < 5 THEN
                        // CP := PADSTR('',5- STRLEN(CP),'0') + CP;
                        "Ship-to Address"."Post Code" := CP;
                    end;
                }
                textelement(Poblacion)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        "Ship-to Address".City := CopyStr(Poblacion, 1, 30);
                    end;
                }
                fieldelement(Provincia;
                "Ship-to Address".County)
                { }
                textelement(Pais)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        Paises.SetFilter(Name, '@' + Pais);
                        if Paises.FindFirst then "Ship-to Address".Validate("Country/Region Code", Paises.Code);
                    end;
                }
                textelement(Tlf)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        "Ship-to Address"."Phone No." := CopyStr(Tlf, 1, 30);
                    end;
                }
                textelement(mail)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        "Ship-to Address"."E-Mail" := CopyStr(mail, 1, 80);
                    end;
                }
                textelement(Horario)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        "Ship-to Address".Insert;
                    end;
                }
                textelement(CodTransporte)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        /*IF CodTransporte <> '0' THEN
                                               BEGIN
                                                shippingAgent.INIT;
                                                shippingAgent.Code := CodTransporte;
                                                IF NOT shippingAgent.FIND THEN
                                                  BEGIN
                                                    //shippingAgent.Name := Transporte;
                                                    shippingAgent.INSERT;
                                                  END;
                                                  "Ship-to Address"."Shipping Agent Code" := CodTransporte;
                                                END;
                                                */
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
    var
        Lineas: array[4] of Text[250];
        NumLineas: Integer;
        shippingAgent: Record "Shipping Agent";
        DirEnvio: Record "Ship-to Address";
        Paises: Record "Country/Region";
        LineaDireccion1: Text[50];
        LineaDireccion2: Text[50];
        Posicion: Integer;
        CodeTabla: Record "Dimension Buffer" temporary;

    procedure PartirLinea(var Linea: array[4] of Text[250]; Longitud: Integer; Texto: Text[250]; var NumeroLineas: Integer)
    var
        Pos: Integer;
        i: Integer;
        Inicio: Integer;
        Caracter: Text[250];
    begin
        i := i + 1;
        Inicio := 1;
        repeat
            Linea[i] := CopyStr(Texto, Inicio, Longitud);
            if (Inicio + Longitud - 1) <= StrLen(Texto) then begin
                if (CopyStr(Linea[i], Longitud, 1) <> ' ') or (CopyStr(Linea[i], Longitud, 1) <> ',') then begin
                    Pos := Longitud;
                    repeat
                        Pos := Pos - 1;
                    until (CopyStr(Linea[i], Pos, 1) = ' ') or (Pos = 1) or (CopyStr(Linea[i], Pos, 1) = ',');
                    if Pos = 1 then Pos := Longitud;
                end
                else
                    Pos := Longitud;
            end
            else
                Pos := Longitud;
            Linea[i] := CopyStr(Texto, Inicio, Pos);
            i := i + 1;
            Inicio := Inicio + Pos;
        until (Inicio > StrLen(Texto)) or (i = 5);
        NumeroLineas := i - 1;
    end;
}
