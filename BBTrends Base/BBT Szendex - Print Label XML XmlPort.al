XmlPort 50036 "Szendex - Print Label XML"
{
    Direction = Export;
    Encoding = UTF8;
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

                textelement(ImprimirEtiqueta)
                {
                    NamespacePrefix = 'dir';

                    textelement(GUID)
                    {
                        NamespacePrefix = 'dir';
                        XmlName = 'GUID';

                        trigger OnBeforePassVariable()
                        begin
                            Guid := GlobalGUID;
                        end;
                    }
                    textelement(numero)
                    {
                        NamespacePrefix = 'dir';
                        XmlName = 'Numero';

                        trigger OnBeforePassVariable()
                        begin
                            Numero := GlobalNumero;
                        end;
                    }
                }
            }
        }
    }
    requestpage
    {
        layout
        {
        }
        actions
        {
        }
    }
    var
        GlobalGUID: Text;
        GlobalNumero: Text;

    procedure SetParameters(parGUID: Text; parNumero: Text)
    begin
        GlobalGUID := parGUID;
        GlobalNumero := parNumero;
    end;
}
