TableExtension 50143 "BBT Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Disc. 1 % Caption"; Text[30])
        {
            ObsoleteState = Pending;            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            Caption = 'Disc. 1 %';
            Description = '001';
        }
        field(50001; "Disc. 2 % Caption"; Text[30])
        {
            ObsoleteState = Pending;            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            Caption = 'Disc. 2 %';
            Description = '001';
        }
        field(50002; "Disc. 3 % Caption"; Text[30])
        {
            ObsoleteState = Pending;            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            Caption = 'Disc. 3 %';
            Description = '001';
        }
        field(50003; "Disc. 4 % Caption"; Text[30])
        {
            ObsoleteState = Pending;            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            Caption = 'Disc. 4 %';
            Description = '001';
        }
        field(50004; "Disc. 5 % Caption"; Text[30])
        {
            ObsoleteState = Pending;            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            Caption = 'Disc. 5 %';
            Description = '001';
        }
        field(50005; "Agent File Company Name"; Text[20])
        {
            Caption = 'Company Name';
            Description = '002';
        }
        field(50006; "Agent File Path"; Text[250])
        {
            Caption = 'Save in path';
            Description = '002';
        }
        field(50007; "Transfer Payment Method"; Code[10])
        {
            Caption = 'Transfer Payment Method';
            Description = '003';
            TableRelation = "Payment Method";
        }
        field(50008; "Transport Shipment Nos."; Code[10])
        {
            Caption = 'Transport Shipment Nos.';
            TableRelation = "No. Series";
        }
        field(50009; "Palets Nos."; Code[10])
        {
            Caption = 'Palets Nos.';
            Description = 'RND-105';
            TableRelation = "No. Series";
        }
        field(50010; "EDI - FTP Username"; Text[50])
        {
            Caption = 'EDI - Usuario FTP';
            Description = 'EDI';
        }
        field(50011; "EDI - FTP Password"; Text[50])
        {
            Caption = 'EDI - Contraseña FTP';
            Description = 'EDI';
            ExtendedDatatype = Masked;
        }
        field(50012; "EDI - Orders d96a FTP folder"; Text[150])
        {
            Caption = 'EDI - Carpeta FTP Pedidos d96a';
            Description = 'EDI';
        }
        field(50013; "EDI - Orders d01b FTP folder"; Text[150])
        {
            Caption = 'EDI - Carpeta FTP Pedidos d01b';
            Description = 'EDI';
        }
        field(50014; "EDI - FTP Root"; Text[150])
        {
            Caption = 'EDI - Raíz FTP';
            Description = 'EDI';
        }
        field(50015; "EDI - Sales Shpt. Prefix"; Code[10])
        {
            Caption = 'EDI - Prefijo alb. Venta';
            Description = 'EDI';
        }
        field(50016; "EDI - Sales Shpt. FTP ECI"; Text[150])
        {
            Caption = 'EDI - Carpeta FTP Albaranes';
            Description = 'EDI';
        }
        field(50017; "EDI - Sales Invoice Prefix"; Code[10])
        {
            Caption = 'EDI - Prefijo fra. Venta';
            Description = 'EDI';
        }
        field(50018; "EDI - Sales Invoice FTP d93a"; Text[150])
        {
            Caption = 'EDI - Carpeta FTP Facturas d93a';
            Description = 'EDI';
        }
        field(50019; "EDI - Sales Shpt. FTP MM"; Text[150])
        {
            Caption = 'EDI - Carpeta FTP Albaranes MM';
            Description = 'EDI';
        }
        field(50020; "EDI - Sales Invoice FTP d96a"; Text[150])
        {
            Caption = 'EDI - Carpeta FTP Facturas d96a';
            Description = 'EDI';
        }
        field(50021; "EDI - Sales Shpt. Auto Send"; Boolean)
        {
            Caption = 'EDI - Envío automático albaranes venta';
            Description = 'EDI';
        }
        field(50022; "EDI - Sales Invoice Auto Send"; Boolean)
        {
            Caption = 'EDI - Envío automático facturas venta';
            Description = 'EDI';
        }
        field(50023; "EDI - Sales Shpt. FTP Carrefou"; Text[150])
        {
            Caption = 'EDI - Carpeta FTP Albaranes Carrefour';
            Description = 'EDI';
        }
        field(50024; "EDI - Sales Invoice FTP d01b"; Text[150])
        {
            Caption = 'EDI - Carpeta FTP Facturas d01b';
            Description = 'EDI';
        }
        field(50025; "PDF - FTP Root"; Text[150])
        {
            Caption = 'PDF - Raíz FTP';
            Description = 'EDI';
        }
        field(50026; "PDF - FTP Username"; Text[50])
        {
            Caption = 'PDF - Usuario FTP';
            Description = 'EDI';
        }
        field(50027; "PDF - FTP Password"; Text[50])
        {
            Caption = 'PDF - Contraseña FTP';
            Description = 'EDI';
            ExtendedDatatype = Masked;
        }
        field(50028; "PDF - Sales Shpt. FTP ECI"; Text[150])
        {
            Caption = 'PDF - Carpeta FTP Albaranes ECI';
            Description = 'EDI';
        }
        field(50029; "EDI - Orders d93a FTP folder"; Text[150])
        {
            Caption = 'EDI - Carpeta FTP Pedidos d93a';
            Description = 'EDI';
        }
        field(50030; "SZE - Username"; Text[30])
        {
            Caption = 'Szendex - Usuario';
        }
        field(50031; "SZE - Password"; Text[30])
        {
            Caption = 'Szendex - Contraseña';
            ExtendedDatatype = Masked;
        }
        field(50032; "SZE - URL"; Text[100])
        {
            Caption = 'Szendex - URL';
        }
        field(50033; "Sze - Last Tracking Datetime"; DateTime)
        {
            Caption = 'Szendex - Fecha/hora últ. tracking';
        }
        field(50034; "Sze - Label Folder"; Text[80])
        {
            Caption = 'Szendex - Carpeta etiqueta';

            trigger OnValidate()
            begin
                if Rec."Sze - Label Folder" <> '' then begin
                    if CopyStr(Rec."Sze - Label Folder", StrLen(Rec."Sze - Label Folder")) <> '\' then Rec."Sze - Label Folder" := Rec."Sze - Label Folder" + '\';
                end;
            end;
        }
        field(50035; "CBL - FTP Site"; Text[50])
        {
            Caption = 'CBL - Dirección FTP';
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
        field(50036; "CBL - Tracking Folder"; Text[30])
        {
            Caption = 'CBL - carpeta FTP tracking';
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
        field(50037; "CBL - User"; Text[30])
        {
            Caption = 'CBL - Usuario FTP';
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
        field(50038; "CBL - Password"; Text[30])
        {
            Caption = 'CBL - Contraseña';
            ExtendedDatatype = Masked;
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
        field(50039; "Own Packaging Nos."; Code[20])
        {
            Caption = 'No serie embalajes propios';
            TableRelation = "No. Series".Code;
        }
        field(50040; "Minimum Margin %"; Decimal)
        {
            Caption = '% Margen mínimo';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50041; "Customer Service Nos."; Code[20])
        {
            Caption = 'Nº serie servicio cliente';
            TableRelation = "No. Series";
        }
        field(50042; "Customer Service Freight G/L A"; Code[20])
        {
            Caption = 'Nº cuenta abono transporte';
            TableRelation = "G/L Account";
        }
        field(50043; "Warehouse Sales Shipment Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50044; "Warehouse Purh Receipt Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50045; "Warehouse Sales Receipt Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50046; "Suus FTP Server Address"; Text[50])
        {
            Caption = 'Dirección FTP Suus';
        }
        field(50047; "Suus FTP Folder"; Text[30])
        {
            Caption = 'Carpeta FTP Suus';
        }
        field(50048; "Suus FTP Username"; Text[30])
        {
            Caption = 'Usuario FTP Suus';
        }
        field(50049; "Suus FTP Password"; Text[30])
        {
            Caption = 'Contraseõa FTP Suus';
            ExtendedDatatype = Masked;
        }
        field(50050; "EDI - Invoices d01b FTP folder"; Text[150])
        {
            Caption = 'EDI - Carpeta FTP Facturas/abonos d01b';
        }
        field(50051; "EDI - Invoices d93a FTP folder"; Text[150])
        {
            Caption = 'EDI - Carpeta FTP Facturas/abonos d93a';
        }
        field(50052; "EDI - G/L Account No."; Code[20])
        {
            Caption = 'EDI - Nº cuenta fras./abonos sin líneas';
            TableRelation = "G/L Account"."No.";
        }
        field(50053; "Sales Precintia"; Boolean)
        {
            Caption = 'Sales Precintia';
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
        field(50054; "SZE - User Tracking"; Text[30])
        {
            Caption = 'Szendex - Usuario Tracking';
        }
        field(50055; "SZE - Pass Tracking"; Text[30])
        {
            Caption = 'Szendex - Contraseõa Tracking';
        }
        field(50056; "EDI Download PA Endpoint"; text[1024])
        {
            Caption = 'EDI Download PA Endpoint', comment = 'ESP="PA EndPoint EDI descargas"';
            DataClassification = ToBeClassified;
        }
        field(50057; "EDI Upload PA Endpoint"; Text[1024])
        {
            Caption = 'EDI Upload PA Endpoint', comment = 'ESP="PA EndPoint EDI Subidas"';
            DataClassification = ToBeClassified;
        }
        field(50058; "EDI Download Orders Parameter"; code[20])
        {
            Caption = 'EDI Download Orders Parameter', comment = 'ESP="EDI parámetro descarga pedidos"';
            DataClassification = ToBeClassified;
        }
        field(50059; "EDI Upload Invoice Parameter"; Code[20])
        {
            Caption = 'EDI Upload Invoice Parameter', comment = 'ESP="EDI parámetro subida facturas"';
            DataClassification = ToBeClassified;
        }
        field(50060; "EDI Upload Shipment Parameter"; Code[20])
        {
            Caption = 'EDI Upload Shipment Parameter', comment = 'ESP="EDI parámetro subida albaranes"';
            DataClassification = ToBeClassified;
        }
        field(50061; "EDI Process Orders Parameter"; Code[20])
        {
            Caption = 'EDI Process Orders Parameter', comment = 'ESP="EDI parámetro procesamiento pedidos"';
            DataClassification = ToBeClassified;
        }
        field(50062; "EDI Download Invs. Parameter"; Code[20])
        {
            Caption = 'EDI Download Invs. Parameter', comment = 'ESP="EDI parámetro descarga facturas"';
            DataClassification = ToBeClassified;
        }
        field(50063; "EDI Upload PDF Parameter"; Code[20])
        {
            Caption = 'EDI Upload PDF Parameter', comment = 'ESP="EDI parámetro proceso subida PDF"';
            DataClassification = ToBeClassified;
        }
        field(50064; "EDI Upload PDF PA Endpoint"; text[1024])
        {
            Caption = 'EDI Upload PDF PA Endpoint', comment = 'ESP="PA EndPoint EDI carga PDF"';
            DataClassification = ToBeClassified;
        }
        field(50065; "BBT Excl. Notice Zero Price"; Code[10])
        {
            Caption = 'Exclusion Notice Zero Price', comment = 'ESP="Exclusión aviso precio cero"';
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            //TableRelation = "Customer Classification".code where(Type = const(Platform));
            TableRelation = "SMG Customer Classification".Code where(Type = const(Platform));
            //<<
            DataClassification = ToBeClassified;
        }
        field(50066; "BBT Minimum Matter"; Decimal)
        {
            Caption = ' Minimum Matters', comment = 'ESP="Importe mínimo"';
            DataClassification = ToBeClassified;
        }
        field(50067; "BBT Item Shipping Charge"; Code[20])
        {
            Caption = 'Item Shipping Charge', comment = 'ESP="Cód. producto cargo porte"';
            TableRelation = Item where(Type = const(Service));
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                if "BBT Item Shipping Charge" <> '' then begin
                    if Item.Get("BBT Item Shipping Charge") then "BBT Text Item Shipping Charge" := Item.Description
                end
                else
                    Clear("BBT Text Item Shipping Charge");
            end;
        }
        field(50068; "BBT Text Item Shipping Charge"; Text[100])
        {
            Caption = 'Text Item Shipping Charge', comment = 'ESP="Texto cargo porte"';
            DataClassification = ToBeClassified;
        }
        field(50069; "BBT Shipping Charge"; Decimal)
        {
            Caption = 'Shipping Charge', comment = 'ESP="Cargo portes"';
            DataClassification = ToBeClassified;
        }
        field(50100; "SZE - Endpoint"; Text[1024])
        {
            Caption = 'Szendex - Endpoint powerautomate';
        }
        field(50500; "Warranties Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Warranties Nos.', comment = 'ESP="Nº serie garantías"';
            TableRelation = "No. Series";
        }
        field(50101; "SGA - Document Block Endpoint"; Text[1024])
        {
            ObsoleteState = Pending;    // BBT. 01/07/2026. New SGA Extension
            Caption = 'SGA - Document Block Endpoint', comment = 'ESP="SGA - Bloqueo documentos Endpoint"';
        }
        field(50102; "SGA - Insert Item Endpoint"; Text[1024])
        {
            ObsoleteState = Pending;    // BBT. 01/07/2026. New SGA Extension
            Caption = 'SGA - Insert Item Endpoint', comment = 'ESP="SGA - Insertar producto Endpoint"';
        }
        field(50103; "SGA - Purch Order Mngmnt. Endp"; Text[1024])
        {
            ObsoleteState = Pending;    // BBT. 01/07/2026. New SGA Extension
            Caption = 'SGA - Purchase Order Mangmnt. Endpoint', comment = 'ESP="SGA - Ges. Ped Compra Endpoint"';
        }
        field(50104; "SGA-Purchase Order Recep. Endp"; Text[1024])
        {
            ObsoleteState = Pending;    // BBT. 01/07/2026. New SGA Extension
            Caption = 'SGA - Purchase Order Recep. Endpoint', comment = 'ESP="SGA - Recep. ped. compra Endpoint"';
        }
        field(50105; "SGA-Update Document Endpoint"; Text[1024])
        {
            ObsoleteState = Pending;    // BBT. 01/07/2026. New SGA Extension
            Caption = 'SGA-Update Document Endpoint', comment = 'ESP="SGA - Actualizar Documento Endpoint"';
        }
        field(50106; "SGA-Shipment Document Endpoint"; Text[1024])
        {
            ObsoleteState = Pending;    // BBT. 01/07/2026. New SGA Extension
            Caption = 'SGA-Shipment Document Endpoint', comment = 'ESP="SGA - Documento envio Endpoint"';
        }
        field(50107; "SGA-Shipment S.Order Endpoint"; Text[1024])
        {
            ObsoleteState = Pending;    // BBT. 01/07/2026. New SGA Extension
            Caption = 'SGA-Shipment S.Order Endpoint', comment = 'ESP="SGA - Albaran pedido venta Endpoint"';
        }
        field(50108; "SGA-Read exped. shipment Endp"; Text[1024])
        {
            ObsoleteState = Pending;    // BBT. 01/07/2026. New SGA Extension
            Caption = 'SGA-Read exped. shipment Endp', comment = 'ESP="SGA - Leer entregas expedidas Endpoint"';
        }
        field(50109; "SGA-Update exped. ship. Endp"; Text[1024])
        {
            ObsoleteState = Pending;    // BBT. 01/07/2026. New SGA Extension
            Caption = 'SGA-Update exped. ship. Endp', comment = 'ESP="SGA - Actualizar entregas expedidas Endpoint"';
        }
        field(50110; "SGA-Insert S.Credit Memo. Endp"; Text[1024])
        {
            ObsoleteState = Pending;    // BBT. 01/07/2026. New SGA Extension
            Caption = 'SGA-Insert S.Credit Memo. Endp', comment = 'ESP="SGA - Insertar devolucion venta Endpoint"';
        }
        field(50111; "SGA-Read Recep. S.Credit Memo."; Text[1024])
        {
            ObsoleteState = Pending;    // BBT. 01/07/2026. New SGA Extension
            Caption = 'SGA-Read Recep S.Credit Memo. Endp', comment = 'ESP="SGA - Leer recepcion devolucion venta Endpoint"';
        }
        field(50112; "SGA-Read Transfer Order Endp"; Text[1024])
        {
            ObsoleteState = Pending;    // BBT. 01/07/2026. New SGA Extension
            Caption = 'SGA-Read Transfer Order Endp', comment = 'ESP="SGA - Leer pedido transferencia Endpoint"';
        }
        field(50113; "SGA-Read Stock Adjust. Endp"; Text[1024])
        {
            ObsoleteState = Pending;    // BBT. 01/07/2026. New SGA Extension
            Caption = 'SGA-Read Stock Adjust. Endp', comment = 'ESP="SGA - Leer ajustes stock Endpoint"';
        }
        field(50114; "SGA-Update Stock Adjust. Endp"; Text[1024])
        {
            ObsoleteState = Pending;    // BBT. 01/07/2026. New SGA Extension
            Caption = 'SGA-Update Stock Adjust. Endp', comment = 'ESP="SGA - Actualizar ajustes stock Endpoint"';
        }
        field(50115; "SGA-Read shipm. confirm. Endp"; Text[1024])
        {
            ObsoleteState = Pending;    // BBT. 01/07/2026. New SGA Extension
            Caption = 'SGA-Read shipm. confirm. Endp', comment = 'ESP="SGA - Leer confirmacion albaran Endpoint"';
        }
        field(50116; "SGA-Insert shipm. confirm Endp"; Text[1024])
        {
            ObsoleteState = Pending;    // BBT. 01/07/2026. New SGA Extension
            Caption = 'SGA-Insert shipm. confirm. Endp', comment = 'ESP="SGA - Insertar confirmacion albaran Endpoint"';
        }
        field(50117; "SGA-Insert p.return order Endp"; Text[1024])
        {
            ObsoleteState = Pending;    // BBT. 01/07/2026. New SGA Extension
            Caption = 'SGA-Insert p.return order Endp', comment = 'ESP="SGA - Insertar devolucion compra Endpoint"';
        }
        field(50118; "SGA-Read p.return order Endp"; Text[1024])
        {
            ObsoleteState = Pending;    // BBT. 01/07/2026. New SGA Extension
            Caption = 'SGA-Read p.return order Endp', comment = 'ESP="SGA - Leer devolucion compra Endpoint"';
        }
        field(50119; "SGA-Read location entry Endp"; Text[1024])
        {
            Caption = 'SGA-Read location entry Endp', comment = 'ESP="SGA - Leer entrega almacen Endpoint"';
        }
        field(50120; "SGA-Read packing list Endp"; Text[1024])
        {
            Caption = 'SGA-Read packing list Endp', comment = 'ESP="SGA - Leer packing list Endpoint"';
        }
        field(50121; "SGA-Read error fields Endp"; Text[1024])
        {
            ObsoleteState = Pending;    // BBT. 01/07/2026. New SGA Extension
            Caption = 'SGA-Read error fields Endp', comment = 'ESP="SGA - Leer campos error Endpoint"';
        }
        field(50122; "SGA-Read error fields stock"; Text[1024])
        {
            ObsoleteState = Pending;    // BBT. 01/07/2026. New SGA Extension
            Caption = 'SGA-Read error fields stock Endp', comment = 'ESP="SGA - Leer campos error stock Endpoint"';
        }
        field(50123; "SGA-Insert Transfer Order Endp"; Text[1024])
        {
            ObsoleteState = Pending;    // BBT. 01/07/2026. New SGA Extension
            Caption = 'SGA-Insert Transfer Order Endp', comment = 'ESP="SGA - Insert pedido transferencia Endpoint"';
        }
        field(50124; "Shipping Exclusion"; Code[10])
        {
            Caption = 'Shipping Exclusion', comment = 'ESP="Exclusion Portes"';
            //>> BBT. 16/03/2026. Implantación de la extensión SMG.
            //TableRelation = "Customer Classification".code where(Type = const(Platform));
            TableRelation = "SMG Customer Classification".Code where(Type = const(Platform));
            //<<
        }
        field(50125; "Rappel Account"; Code[20])
        {
            Caption = 'Rappel Account', comment = 'ESP="Cuenta ajuste Rappel"';
            Description = 'Valida con el plan de cuentas';
            TableRelation = "G/L Account";
        }
        field(51112; "EDI PL - FTP Username"; Text[50])
        {
            Description = 'Usuario FTP EDI Polonia';
            Caption = 'EDI PL - Username FTP', Comment = 'ESP="EDI PL- Usuario FTP"';
            Enabled = true;
            Editable = true;
        }
        field(51113; "EDI PL - FTP Password"; Text[50])
        {
            Description = 'Contraseña FTP EDI Polonia';
            Caption = 'EDI PL - FTP Password', Comment = 'ESP="EDI PL - Contraseña FTP"';
            Enabled = true;
            Editable = true;
            ExtendedDatatype = Masked;
        }
        field(51114; "EDI PL - Download PA Endpoint"; text[1024])
        {
            Description = 'EndPoint Descargas EDI Polonia';
            Caption = 'EDI-PL Download PA Endpoint', Comment = 'ESP="PA EndPoint EDI-PL Descargas"';
            DataClassification = ToBeClassified;
            Enabled = true;
            Editable = true;
        }
        field(51115; "EDI PL - Upload PA Endpoint"; Text[1024])
        {
            Description = 'EndPoint Subidas EDI Polonia';
            Caption = 'EDI-PL Upload PA Endpoint', Comment = 'ESP="PA EndPoint EDI-PL Subidas"';
            DataClassification = ToBeClassified;
            Enabled = true;
            Editable = true;
        }
        field(51147; "EDI - Returns d01b FTP Folder"; Text[150])
        {
            Description = 'EDI Carpeta Devoluciones d01b';
            Caption = 'EDI FTP Return Orders folder d01b', Comment = 'ESP="EDI - Carpeta FTP Devoluciones d01b"';
            Enabled = true;
            Editable = true;
        }
        field(51148; "EDI - Returns d96a FTP Folder"; Text[150])
        {
            Description = 'EDI Carpeta Devoluciones d96a';
            Caption = 'EDI FTP Return Orders folder d96a', Comment = 'ESP="EDI - Carpeta FTP Devoluciones d96a"';
            Enabled = true;
            Editable = true;
        }
        field(51149; "EDI Download Returns Parameter"; code[20])
        {
            Description = 'EDI Parametro descarga devoluciones';
            Caption = 'EDI Download Returns Parameter', Comment = 'ESP="EDI parámetro descarga devoluciones"';
            Enabled = true;
            Editable = true;
        }
    }
    var
        WindowTitleLbl: label 'Select folder';
}
