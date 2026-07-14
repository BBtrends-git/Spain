PageExtension 50165 "BBT Sales & Receivable Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field("BBT Excl. Notice Zero Price"; Rec."BBT Excl. Notice Zero Price")
            {
                ApplicationArea = All;
            }
            field("Rappel Account"; Rec."Rappel Account")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Rappel Account field.', Comment = 'ESP="Cuenta ajuste Rappel"';
            }
        }
        addafter("Prepmt. Auto Update Frequency")
        {
            field("Transfer Payment Method"; Rec."Transfer Payment Method")
            {
                ApplicationArea = ALL;
            }
            field("Minimum Margin %"; Rec."Minimum Margin %")
            {
                ApplicationArea = ALL;
            }
            field("Customer Service Freight G/L A"; Rec."Customer Service Freight G/L A")
            {
                ApplicationArea = ALL;
            }
        }
        addafter("Direct Debit Mandate Nos.")
        {
            field("Transport Shipment Nos."; Rec."Transport Shipment Nos.")
            {
                ApplicationArea = ALL;
            }
            field("Palets Nos."; Rec."Palets Nos.")
            {
                ApplicationArea = ALL;
            }
            field("Warranties Nos"; Rec."Warranties Nos")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Warranties Nos. field.', Comment = 'ESP="Nº serie garantías"';
            }
            field("Customer Service Nos."; Rec."Customer Service Nos.")
            {
                ApplicationArea = ALL;
            }
        }
        addafter("Background Posting")
        {
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            /*
            group(Discounts)
            {
                Caption = 'Discounts';

                field("Disc. 1 % Caption"; Rec."Disc. 1 % Caption")
                {
                    ApplicationArea = ALL;
                }
                field("Disc. 2 % Caption"; Rec."Disc. 2 % Caption")
                {
                    ApplicationArea = ALL;
                }
                field("Disc. 3 % Caption"; Rec."Disc. 3 % Caption")
                {
                    ApplicationArea = ALL;
                }
                field("Disc. 4 % Caption"; Rec."Disc. 4 % Caption")
                {
                    ApplicationArea = ALL;
                }
                field("Disc. 5 % Caption"; Rec."Disc. 5 % Caption")
                {
                    ApplicationArea = ALL;
                }
            }
            */
            //<<
            group("Shipping Agent File")
            {
                Caption = 'Shipping Agent File';

                field("Agent File Company Name"; Rec."Agent File Company Name")
                {
                    ApplicationArea = ALL;
                }
                field("Agent File Path"; Rec."Agent File Path")
                {
                    ApplicationArea = ALL;

                    trigger OnAssistEdit()
                    begin
                        // - 002
                        if CurrPage.Editable then;
                        //Rec.GetFileAgentPath();
                        // + 002
                    end;
                }
            }
            group(EDI)
            {
                field("EDI - FTP Username"; Rec."EDI - FTP Username")
                {
                    ApplicationArea = ALL;
                }
                field("EDI - FTP Password"; Rec."EDI - FTP Password")
                {
                    ApplicationArea = ALL;
                }
                field("EDI - FTP Root"; Rec."EDI - FTP Root")
                {
                    ApplicationArea = ALL;
                }
                field("EDI Ordersp PA Endpoint"; Rec."EDI Download PA Endpoint")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI Ordersp PA Endpoint field.', Comment = 'ESP="PA EndPoint EDI Ordersp"';
                }
                field("EDI Invoice PA Endpoint"; Rec."EDI Upload PA Endpoint")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI Invoice PA Endpoint field.', Comment = 'ESP="PA EndPoint EDI facturas"';
                }
                field("EDI Upload PDF PA Endpoint"; Rec."EDI Upload PDF PA Endpoint")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI Upload PDF PA Endpoint field.', Comment = 'ESP="PA EndPoint EDI carga PDF"';
                }
                group(EDISchedule)
                {
                    Caption = 'EDI Schedule', comment = 'ESP="Parámetros EDI"';

                    field("EDI Download Orders Parameter"; rec."EDI Download Orders Parameter")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the EDI Orders Parameter field.', Comment = 'ESP="EDI parámetro pedidos"';
                    }
                    field("EDI Download Invs. Parameter"; Rec."EDI Download Invs. Parameter")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the EDI Download Invs. Parameter field.', Comment = 'ESP="EDI parámetro descarga facturas"';
                    }
                    field("EDI Download Returns Parameter"; Rec."EDI Download Returns Parameter")
                    {
                        Caption = 'EDI Download Returns Parameter', Comment = 'ESP="EDI parámetro descarga devoluciones"';
                        ApplicationArea = All;
                    }
                    field("EDI Upload Invoice Parameter"; rec."EDI Upload Invoice Parameter")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the EDI Invoice Parameter field.', Comment = 'ESP="EDI parámetro facturas"';
                    }
                    field("EDI Upload Shipment Parameter"; rec."EDI Upload Shipment Parameter")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the EDI Deasv Parameter field.', Comment = 'ESP="EDI parámetro albaranes"';
                    }
                    field("EDI Process Orders Parameter"; Rec."EDI Process Orders Parameter")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the EDI Process Orders Parameter field.', Comment = 'ESP="EDI parámetro proceso pedidos"';
                    }
                    field("EDI Process PDF Parameter"; rec."EDI Upload PDF Parameter")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the EDI Process PDF Parameter field.', Comment = 'ESP="EDI parámetro proceso PDFs"';
                    }
                }
                group(Pedidos)
                {
                    Caption = 'Pedidos';

                    field("EDI - Orders d96a FTP folder"; Rec."EDI - Orders d96a FTP folder")
                    {
                        ApplicationArea = ALL;
                    }
                    field("EDI - Orders d01b FTP folder"; Rec."EDI - Orders d01b FTP folder")
                    {
                        ApplicationArea = ALL;
                    }
                    field("EDI - Orders d93a FTP folder"; Rec."EDI - Orders d93a FTP folder")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the EDI - Carpeta FTP Pedidos d93a field.';
                    }
                }
                group(Albaranes)
                {
                    Caption = 'Albaranes';

                    field("EDI - Sales Shpt. Prefix"; Rec."EDI - Sales Shpt. Prefix")
                    {
                        ApplicationArea = ALL;
                    }
                    field("EDI - Sales Shpt. FTP ECI"; Rec."EDI - Sales Shpt. FTP ECI")
                    {
                        ApplicationArea = ALL;
                    }
                    field("EDI - Sales Shpt. FTP MM"; Rec."EDI - Sales Shpt. FTP MM")
                    {
                        ApplicationArea = ALL;
                        Visible = false;
                    }
                    field("EDI - Sales Shpt. FTP Carrefou"; Rec."EDI - Sales Shpt. FTP Carrefou")
                    {
                        ApplicationArea = ALL;
                        Visible = false;
                    }
                    field("EDI - Sales Shpt. Auto Send"; Rec."EDI - Sales Shpt. Auto Send")
                    {
                        ApplicationArea = ALL;
                    }
                }
                group(Abonos)
                {
                    Caption = 'Abonos';

                    field("EDI - Invoices d01b FTP folder"; Rec."EDI - Invoices d01b FTP folder")
                    {
                        ApplicationArea = ALL;
                    }
                    field("EDI - Invoices d93a FTP folder"; Rec."EDI - Invoices d93a FTP folder")
                    {
                        ApplicationArea = ALL;
                    }
                    field("EDI - G/L Account No."; Rec."EDI - G/L Account No.")
                    {
                        ApplicationArea = ALL;
                    }
                }
                group(Facturas)
                {
                    Caption = 'Facturas';

                    field("EDI - Sales Invoice Prefix"; Rec."EDI - Sales Invoice Prefix")
                    {
                        ApplicationArea = ALL;
                    }
                    field("EDI - Sales Invoice FTP d93a"; Rec."EDI - Sales Invoice FTP d93a")
                    {
                        ApplicationArea = ALL;
                    }
                    field("EDI - Sales Invoice FTP d01b"; Rec."EDI - Sales Invoice FTP d01b")
                    {
                        ApplicationArea = ALL;
                        Visible = true;
                    }
                    field("EDI - Sales Invoice FTP d96a"; Rec."EDI - Sales Invoice FTP d96a")
                    {
                        ApplicationArea = ALL;
                    }
                    field("EDI - Sales Invoice Auto Send"; Rec."EDI - Sales Invoice Auto Send")
                    {
                        ApplicationArea = ALL;
                    }
                }
                group("Devoluciones")
                {
                    field("EDI - Returns d01b FTP Folder"; Rec."EDI - Returns d01b FTP Folder")
                    {
                        Caption = 'EDI FTP Return Orders folder d01b', Comment = 'ESP="EDI - Carpeta FTP Devoluciones d01b"';
                        ApplicationArea = ALL;
                    }
                    field("EDI - Returns d96a FTP Folder"; Rec."EDI - Returns d96a FTP Folder")
                    {
                        Caption = 'EDI FTP Return Orders folder d96a', Comment = 'ESP="EDI - Carpeta FTP Devoluciones d96a"';
                        ApplicationArea = ALL;
                    }
                }
                group(Pdf)
                {
                    Caption = 'PDF';

                    field("PDF - FTP Root"; Rec."PDF - FTP Root")
                    {
                        ApplicationArea = ALL;
                    }
                    field("PDF - FTP Username"; Rec."PDF - FTP Username")
                    {
                        ApplicationArea = ALL;
                    }
                    field("PDF - FTP Password"; Rec."PDF - FTP Password")
                    {
                        ApplicationArea = ALL;
                    }
                    field("PDF - Sales Shpt. FTP ECI"; Rec."PDF - Sales Shpt. FTP ECI")
                    {
                        ApplicationArea = ALL;
                        Visible = false;
                    }
                }
                group("EDI PL")
                {
                    Caption = 'FTP EDI Poland', Comment = 'ESP="FTP EDI Polonia"';

                    field("EDI PL - FTP Username"; Rec."EDI PL - FTP Username")
                    {
                        ApplicationArea = ALL;
                        ToolTip = 'User for SFTP EDI Poland connection', Comment =
                                'ESP="Usuario para la conexión SFTP EDI Polonia"';
                    }
                    field("EDI PL - FTP Password"; Rec."EDI PL - FTP Password")
                    {
                        ApplicationArea = ALL;
                        ToolTip = 'Password for SFTP EDI Poland connection', Comment =
                                'ESP="Contraseña para la conexión SFTP EDI Polonia"';
                    }
                    field("EDI PL - Download PA Endpoint"; Rec."EDI PL - Download PA Endpoint")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the EDI Poland Download PA Endpoint field.', Comment =
                                'ESP="Especifica el valor del campo EndPoint de descarga del EDI Polonia"';
                    }
                    field("EDI PL - Upload PA Endpoint"; Rec."EDI PL - Upload PA Endpoint")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the EDI Poland Upload PA Endpoint field.', Comment =
                                'ESP="Especifica el valor del campo EndPoint de subida del EDI Polonia"';
                    }
                }
            }
            group(Szendex)
            {
                Caption = 'Szendex';

                field("SZE - Endpoint"; Rec."SZE - Endpoint")
                {
                    ApplicationArea = ALL;
                }
                field("SZE - URL"; Rec."SZE - URL")
                {
                    ApplicationArea = ALL;
                }
                field("SZE - Username"; Rec."SZE - Username")
                {
                    ApplicationArea = ALL;
                }
                field("SZE - Password"; Rec."SZE - Password")
                {
                    ApplicationArea = ALL;
                }
                field("SZE - User Tracking"; Rec."SZE - User Tracking")
                {
                    ApplicationArea = ALL;
                }
                field("SZE - Pass Tracking"; Rec."SZE - Pass Tracking")
                {
                    ApplicationArea = ALL;
                    ExtendedDatatype = Masked;
                }
                field("Sze - Last Tracking Datetime"; Rec."Sze - Last Tracking Datetime")
                {
                    ApplicationArea = ALL;
                }
            }
            group(SGA)
            {
                Caption = 'SGA - Endpoints';

                field("SGA - Document Block Endpoint"; Rec."SGA - Document Block Endpoint")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA - Document Block Endpoint field.', Comment = 'ESP="SGA - Bloqueo documentos Endpoint"';
                    Visible = SGAEnable;
                    Enabled = SGAEnable;
                }
                field("SGA-Insert Transfer Order Endp"; Rec."SGA-Insert Transfer Order Endp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA-Insert Transfer Order Endp field.', Comment = 'ESP="SGA - Insert pedido transferencia Endpoint"';
                    Visible = SGAEnable;
                    Enabled = SGAEnable;
                }
                field("SGA - Insert Item Endpoint"; Rec."SGA - Insert Item Endpoint")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA - Insert Item Endpoint field.', Comment = 'ESP="SGA - Insertar producto Endpoint"';
                    Visible = SGAEnable;
                    Enabled = SGAEnable;
                }
                field("SGA - Purch Order Mngmnt. Endp"; Rec."SGA - Purch Order Mngmnt. Endp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA - Purchase Order Mangmnt. Endpoint field.', Comment = 'ESP="SGA - Ges. Ped Compra Endpoint"';
                    Visible = SGAEnable;
                    Enabled = SGAEnable;
                }
                field("SGA-Insert p.return order Endp"; Rec."SGA-Insert p.return order Endp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA-Insert p.return order Endp field.', Comment = 'ESP="SGA - Insertar devolucion compra Endpoint"';
                    Visible = SGAEnable;
                    Enabled = SGAEnable;
                }
                field("SGA-Insert S.Credit Memo. Endp"; Rec."SGA-Insert S.Credit Memo. Endp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA-Insert S.Credit Memo. Endp field.', Comment = 'ESP="SGA - Insertar devolucion venta Endpoint"';
                    Visible = SGAEnable;
                    Enabled = SGAEnable;
                }
                field("SGA-Insert shipm. confirm Endp"; Rec."SGA-Insert shipm. confirm Endp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA-Insert shipm. confirm. Endp field.', Comment = 'ESP="SGA - Insertar confirmacion albaran Endpoint"';
                    Visible = SGAEnable;
                    Enabled = SGAEnable;
                }
                field("SGA-Purchase Order Recep. Endp"; Rec."SGA-Purchase Order Recep. Endp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA - Purchase Order Recep. Endpoint field.', Comment = 'ESP="SGA - Recep. ped. compra Endpoint"';
                    Visible = SGAEnable;
                    Enabled = SGAEnable;
                }
                field("SGA-Read error fields Endp"; Rec."SGA-Read error fields Endp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA-Read error fields Endp field.', Comment = 'ESP="SGA - Leer campos error Endpoint"';
                    Visible = SGAEnable;
                    Enabled = SGAEnable;
                }
                field("SGA-Read error fields stock"; Rec."SGA-Read error fields stock")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA-Read error fields stock Endp field.', Comment = 'ESP="SGA - Leer campos error stock Endpoint"';
                    Visible = SGAEnable;
                    Enabled = SGAEnable;
                }
                field("SGA-Read exped. shipment Endp"; Rec."SGA-Read exped. shipment Endp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA-Read exped. shipment Endp field.', Comment = 'ESP="SGA - Leer entregas expedidas Endpoint"';
                    Visible = SGAEnable;
                    Enabled = SGAEnable;
                }
                field("SGA-Read p.return order Endp"; Rec."SGA-Read p.return order Endp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA-Read p.return order Endp field.', Comment = 'ESP="SGA - Leer devolucion compra Endpoint"';
                    Visible = SGAEnable;
                    Enabled = SGAEnable;
                }
                field("SGA-Read location entry Endp"; Rec."SGA-Read location entry Endp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA-Read location entry Endp field.', Comment = 'ESP="SGA - Leer entrega almacen Endpoint"';
                    Visible = true;
                    Enabled = true;
                }
                field("SGA-Read packing list Endp"; Rec."SGA-Read packing list Endp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA-Read packing list Endp field.', Comment = 'ESP="SGA - Leer packing list Endpoint"';
                    Visible = true;
                    Enabled = true;
                }
                field("SGA-Read Recep. S.Credit Memo."; Rec."SGA-Read Recep. S.Credit Memo.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA-Read Recep S.Credit Memo. Endp field.', Comment = 'ESP="SGA - Leer recepcion devolucion venta Endpoint"';
                    Visible = SGAEnable;
                    Enabled = SGAEnable;
                }
                field("SGA-Read shipm. confirm. Endp"; Rec."SGA-Read shipm. confirm. Endp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA-Read shipm. confirm. Endp field.', Comment = 'ESP="SGA - Leer confirmacion albaran Endpoint"';
                    Visible = SGAEnable;
                    Enabled = SGAEnable;
                }
                field("SGA-Read Stock Adjust. Endp"; Rec."SGA-Read Stock Adjust. Endp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA-Read Stock Adjust. Endp field.', Comment = 'ESP="SGA - Leer ajustes stock Endpoint"';
                    Visible = SGAEnable;
                    Enabled = SGAEnable;
                }
                field("SGA-Read Transfer Order Endp"; Rec."SGA-Read Transfer Order Endp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA-Read Transfer Order Endp field.', Comment = 'ESP="SGA - Leer pedido transferencia Endpoint"';
                    Visible = SGAEnable;
                    Enabled = SGAEnable;
                }
                field("SGA-Shipment Document Endpoint"; Rec."SGA-Shipment Document Endpoint")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA-Shipment Document Endpoint field.', Comment = 'ESP="SGA - Documento envio Endpoint"';
                    Visible = SGAEnable;
                    Enabled = SGAEnable;
                }
                field("SGA-Shipment S.Order Endpoint"; Rec."SGA-Shipment S.Order Endpoint")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA-Shipment S.Order Endpoint field.', Comment = 'ESP="SGA - Albaran pedido venta Endpoint"';
                    Visible = SGAEnable;
                    Enabled = SGAEnable;
                }
                field("SGA-Update Document Endpoint"; Rec."SGA-Update Document Endpoint")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA-Update Document Endpoint field.', Comment = 'ESP="SGA - Actualizar Documento Endpoint"';
                    Visible = SGAEnable;
                    Enabled = SGAEnable;
                }
                field("SGA-Update exped. ship. Endp"; Rec."SGA-Update exped. ship. Endp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA-Update exped. ship. Endp field.', Comment = 'ESP="SGA - Actualizar entregas expedidas Endpoint"';
                    Visible = SGAEnable;
                    Enabled = SGAEnable;
                }
                field("SGA-Update Stock Adjust. Endp"; Rec."SGA-Update Stock Adjust. Endp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SGA-Update Stock Adjust. Endp field.', Comment = 'ESP="SGA - Actualizar ajustes stock Endpoint"';
                    Visible = SGAEnable;
                    Enabled = SGAEnable;
                }
            }
            group(Suus)
            {
                Caption = 'Suus';

                field("Suus FTP Username"; Rec."Suus FTP Username")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Usuario FTP Suus field.';
                }
                field("Suus FTP Password"; Rec."Suus FTP Password")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contraseõa FTP Suus field.';
                }
                field("Suus FTP Server Address"; Rec."Suus FTP Server Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dirección FTP Suus field.';
                }
                field("Suus FTP Folder"; Rec."Suus FTP Folder")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Carpeta FTP Suus field.';
                }
                field("Warehouse Sales Shipment Nos."; Rec."Warehouse Sales Shipment Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Warehouse Sales Shipment Nos. field.';
                }
                field("Warehouse Sales Receipt Nos."; Rec."Warehouse Sales Receipt Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Warehouse Sales Receipt Nos. field.';
                }
                field("Warehouse Purh Receipt Nos."; Rec."Warehouse Purh Receipt Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Warehouse Purh Receipt Nos. field.';
                }
            }
            group("Orders Minimum Matters")
            {
                Caption = 'Orders Minimum Matters', comment = 'ESP="Importes mínimos pedidos"';

                field("BBT Minimum Matter"; Rec."BBT Minimum Matter")
                {
                    ApplicationArea = All;
                }
                field("BBT Item Shipping Charge"; Rec."BBT Item Shipping Charge")
                {
                    ApplicationArea = All;
                }
                field("BBT Text Item Shipping Charge"; Rec."BBT Text Item Shipping Charge")
                {
                    ApplicationArea = All;
                }
                field("BBT Shipping Charge"; Rec."BBT Shipping Charge")
                {
                    ApplicationArea = All;
                }
                field("Shipping Exclusion"; Rec."Shipping Exclusion")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shipping Exclusion field.', Comment = 'ESP="Exclusion Portes"';
                }
            }
        }
    }

    var
        _InfoCompany: Record "Company Information";
        SGAEnable: Boolean;

    trigger OnAfterGetRecord()
    begin
        SetEnabledSGA();
    end;

    local procedure SetEnabledSGA()
    begin
        // SGA
        SGAEnable := false;
        if _InfoCompany.Get then
            SGAEnable := _InfoCompany.SGA;
    end;
}
