XmlPort 50034 "Szendex - Logout XML"
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

                textelement(DesconectarUsuarioBPoint)
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
