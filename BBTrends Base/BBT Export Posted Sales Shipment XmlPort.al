XmlPort 50019 "Export Posted Sales Shipment"
{
    Caption = 'Export Posted Sales Shipment';
    Direction = Export;
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement("Sales Shipment Palet"; 50009)
            {
                XmlName = 'Sales_Shipment_Palet';
                UseTemporary = true;

                textelement(Nombre_Empresa)
                { }
                textelement(Direccion_Empresa)
                { }
                textelement(Provincia_Empresa)
                { }
                textelement(Pais_Empresa)
                { }
                textelement(Nombre_Cliente)
                { }
                textelement(Direccion_Cliente)
                { }
                textelement(Provincia_CLiente)
                { }
                textelement(CIF_Cliente)
                { }
                fieldelement(No_Albaran; "Sales Shipment Palet"."Sales Shipment No.")
                { }
                textelement(Fecha)
                { }
                textelement(Pedido)
                { }
                textelement(Pedido_cliente)
                { }
                textelement(Cod_articulo)
                { }
                textelement(Ean13)
                { }
                fieldelement(Cantidad; "Sales Shipment Palet".Boxes)
                { }
                fieldelement(SSCC; "Sales Shipment Palet"."Palet No.")
                { }
                fieldelement(Peso; "Sales Shipment Palet"."Gross Weight")
                { }
                fieldelement(Volumen; "Sales Shipment Palet".Volume)
                { }
                trigger OnAfterGetRecord()
                begin
                    CabAlbaran.Get("Sales Shipment Palet"."Sales Shipment No.");
                    LinAlbaran.Get("Sales Shipment Palet"."Sales Shipment No.", "Sales Shipment Palet"."Sales Shipment Line Number");
                    if not CabPedidoVenta.Get(CabPedidoVenta."document type"::Order, CabAlbaran."Order No.") then Clear(CabPedidoVenta);
                    Nombre_Cliente := CabAlbaran."Ship-to Name" + ' ' + CabAlbaran."Ship-to Name 2";
                    Direccion_Cliente := CabAlbaran."Ship-to Address" + ' ' + CabAlbaran."Ship-to Address 2";
                    Provincia_CLiente := CabAlbaran."Ship-to Post Code" + ' ' + CabAlbaran."Ship-to City";
                    CIF_Cliente := 'CIF ' + CabAlbaran."VAT Registration No.";
                    Pedido_cliente := CabAlbaran."External Document No.";
                    Cod_articulo := LinAlbaran."No.";
                    if Item.Get(LinAlbaran."No.") then Ean13 := Item."EAN Code";
                    // Fecha_Fabricacion := FORMAT(CabAlbaran."Posting Date");
                    Pedido := CabAlbaran."Order No.";
                    Fecha := Format(CabAlbaran."Posting Date");
                end;
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
        "Sales Shipment Palet".Reset;
        "Sales Shipment Palet".DeleteAll;
        LinAlbaran.SetRange("Document No.", "SalesShipNo.");
        LinAlbaran.SetFilter(Quantity, '>0');
        if LinAlbaran.FindSet then
            repeat
                RecShipPalet.SetRange("Sales Shipment No.", LinAlbaran."Document No.");
                RecShipPalet.SetRange("Sales Shipment Line Number", LinAlbaran."Line No.");
                if RecShipPalet.FindSet then
                    repeat
                        "Sales Shipment Palet".Init;
                        "Sales Shipment Palet" := RecShipPalet;
                        "Sales Shipment Palet".Insert;
                    until RecShipPalet.Next = 0;
            until LinAlbaran.Next = 0;
        InfoEmpresa.Get;
        Nombre_Empresa := InfoEmpresa.Name + ' ' + InfoEmpresa."Name 2";
        Direccion_Empresa := InfoEmpresa.Address + ' ' + InfoEmpresa."Address 2";
        Provincia_Empresa := InfoEmpresa."Post Code" + ' ' + InfoEmpresa.City + ', ' + InfoEmpresa.County;
        Pais_Empresa := InfoEmpresa."Country/Region Code";
        Slap := '';
        ConfigAlmacen.Get;
        ConfigAlmacen.TestField("File directory export");
        Slap := CopyStr(ConfigAlmacen."File directory export", StrLen(ConfigAlmacen."File directory export"), 1);
        if Slap <> '\' then ConfigAlmacen."File directory export" := ConfigAlmacen."File directory export" + '\';
        currXMLport.Filename(ConfigAlmacen."File directory export" + "SalesShipNo." + '.txt');
    end;

    var
        InfoEmpresa: Record "Company Information";
        CabAlbaran: Record "Sales Shipment Header";
        LinAlbaran: Record "Sales Shipment Line";
        CabPedidoVenta: Record "Sales Header";
        ConfigAlmacen: Record "Warehouse Setup";
        Item: Record Item;
        Slap: Text[1];
        "SalesShipNo.": Code[20];
        RecShipPalet: Record 50009;

    procedure Parametros("_SalesShipNo.": Code[20])
    begin
        "SalesShipNo." := "_SalesShipNo.";
    end;
}
