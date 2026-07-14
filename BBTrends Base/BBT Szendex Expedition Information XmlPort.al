XmlPort 51102 "BBT Szendex Exped Info XML"
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
                    XmlName = 'ObtenerExpedicionPorNumero';
                    textelement(GUID)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            Guid := GlobalGUID;
                        end;
                    }
                    textelement(Numero)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            Numero := "Sales Shipment Header"."Package Tracking No.";
                        end;
                    }
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

    end;

    var
        GlobalGUID: Text;

    procedure SetGUID(parGUID: Text)
    begin
        GlobalGUID := parGUID;
    end;

}

