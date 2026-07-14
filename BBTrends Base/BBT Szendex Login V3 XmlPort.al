XmlPort 51100 "BBT Szendex Login V3"
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
                textelement(ValidarUsuarioBPointV3)
                {
                    NamespacePrefix = 'dir';
                    textelement(Nombre)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            Nombre := SalesReceivablesSetup."SZE - Username";
                        end;
                    }
                    textelement(Password)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            Password := SalesReceivablesSetup."SZE - Password";
                        end;
                    }
                    textelement(Cultura)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            Cultura := 'ES-es'
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
        SalesReceivablesSetup.Reset;
        SalesReceivablesSetup.Get;

        SalesReceivablesSetup.TestField("SZE - Username");
        SalesReceivablesSetup.TestField("SZE - Password");
    end;

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
}
