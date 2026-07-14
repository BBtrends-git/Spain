XmlPort 50052 "Szendex - Login Tracking XML"
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

                textelement(ValidarUsuarioBPoint)
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
        SalesReceivablesSetup.TestField("SZE - User Tracking");
        SalesReceivablesSetup.TestField("SZE - Pass Tracking");
    end;

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
}
