XmlPort 51101 "BBT SZX Login Tracking V3"
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
                            Nombre := SalesReceivablesSetup."SZE - User Tracking"
                        end;
                    }
                    textelement(Password)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            Password := SalesReceivablesSetup."SZE - Pass Tracking"
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

        SalesReceivablesSetup.TestField("SZE - User Tracking");
        SalesReceivablesSetup.TestField("SZE - Pass Tracking");
    end;

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
}
