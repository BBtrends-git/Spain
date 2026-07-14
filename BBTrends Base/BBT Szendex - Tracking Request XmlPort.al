XmlPort 50037 "Szendex - Tracking Request XML"
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

                textelement(ObtenerTracking)
                {
                    NamespacePrefix = 'dir';

                    textelement(GUID)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            Guid := GlobalGUID;
                        end;
                    }
                    textelement(FechaExpedicionInicial)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            FechaExpedicionInicial := Format(GlobalDeliveryStartingDate, 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>')
                        end;
                    }
                    textelement(FechaExpedicionFinal)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            FechaExpedicionFinal := Format(GlobalDeliveryEndingDate, 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>');
                        end;
                    }
                    textelement(FechaEstadoInicial)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            FechaEstadoInicial := Format(GlobalStatusStartingDate, 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>');
                        end;
                    }
                    textelement(FechaEstadoFinal)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            FechaEstadoFinal := Format(GlobalStatusEndingDate, 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>');
                        end;
                    }
                    textelement(ReferenciaEntregaInicial)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            ReferenciaEntregaInicial := GlobalStartingReference;
                        end;
                    }
                    textelement(ReferenciaEntregaFinal)
                    {
                        NamespacePrefix = 'dir';

                        trigger OnBeforePassVariable()
                        begin
                            ReferenciaEntregaFinal := GlobalEndingReference;
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
        GlobalDeliveryStartingDate: DateTime;
        GlobalDeliveryEndingDate: DateTime;
        GlobalStatusStartingDate: DateTime;
        GlobalStatusEndingDate: DateTime;
        GlobalStartingReference: Text;
        GlobalEndingReference: Text;

    procedure SetParameters(parGUID: Text; DeliveryStartingDate: DateTime; DeliveryEndingDate: DateTime; StatusStartingDate: DateTime; StatusEndingDate: DateTime; StartingReference: Text; EndingReference: Text)
    begin
        GlobalGUID := parGUID;
        GlobalDeliveryStartingDate := DeliveryStartingDate;
        GlobalDeliveryEndingDate := DeliveryEndingDate;
        GlobalStatusStartingDate := StatusStartingDate;
        GlobalStatusEndingDate := StatusEndingDate;
        GlobalStartingReference := StartingReference;
        GlobalEndingReference := EndingReference;
    end;
}
