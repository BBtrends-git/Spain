XmlPort 50032 "Szendex - Login XML"
{
    Direction = Export;
    Encoding = UTF8;
    Namespaces = soapenv = 'http://schemas.xmlsoap.org/soap/envelope/', dir = 'http://www.direcline.com/';
    //>> BBT 19/12/2024 Nueva version Szendex - Login V3
    ObsoleteState = Pending;
    //<<

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

                textelement(ValidarUsuarioBPoint)
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
