Table 50011 "EDI - Document interlocutor"
{
    Caption = 'EDI - Interlocutor';

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Tipo documento';
            OptionCaption = ' ,Pedido,Albarán,Factura';
            OptionMembers = " ","Order",Shipment,Invoice;
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Nº Documento';
        }
        field(3; "Interlocutor type"; Code[10])
        {
            Caption = 'Tipo interlocutor';
        }
        field(4; "Interlocutor No."; Code[20])
        {
            Caption = 'Nº interlocutor';
        }
        field(5; "Code responsible agency"; Text[3])
        {
            Caption = 'Agencia responsable códigos';
        }
        field(6; "Name 1"; Text[35])
        {
            Caption = 'Nombre 1';
        }
        field(7; "Name 2"; Text[35])
        {
            Caption = 'Nombre 2';
        }
        field(8; "Name 3"; Text[35])
        {
            Caption = 'Nombre 3';
        }
        field(9; "Name 4"; Text[35])
        {
            Caption = 'Nombre 4';
        }
        field(10; "Name 5"; Text[35])
        {
            Caption = 'Nombre 5';
        }
        field(11; "Street and number 1"; Text[35])
        {
            Caption = 'Calle y número 1';
        }
        field(12; "Street and number 2"; Text[35])
        {
            Caption = 'Calle y número 2';
        }
        field(13; "Street and number 3"; Text[35])
        {
            Caption = 'Calle y número 3';
        }
        field(14; "Street and number 4"; Text[35])
        {
            Caption = 'Calle y número 4';
        }
        field(15; City; Text[30])
        {
            Caption = 'Población';
        }
        field(16; County; Text[9])
        {
            Caption = 'Provincia';
        }
        field(17; "Post Code"; Text[9])
        {
            Caption = 'Código postal';
        }
        field(18; "Country/Region Code"; Text[3])
        {
            Caption = 'Cód. País';
        }
        field(19; "Reference type 1"; Text[3])
        {
            Caption = 'Calificador referencia 1';
        }
        field(20; "Reference 1"; Text[35])
        {
            Caption = 'Referencia 1';
        }
        field(21; "Contact function"; Text[3])
        {
            Caption = 'Función de contacto';
        }
        field(22; "Dept. or employee ID"; Text[17])
        {
            Caption = 'Dept. o identificación empleado';
        }
        field(23; "Dept. or employee"; Text[35])
        {
            Caption = 'Dpto. o empleado';
        }
        field(24; "Reference type 2"; Text[3])
        {
            Caption = 'Calificador referencia 2';
        }
        field(25; "Reference 2"; Text[17])
        {
            Caption = 'Referencia 2';
        }
        field(26; "VAT Registration No."; Text[35])
        {
            Caption = 'VAT Registration No.', comment = 'ESP="CIF/NIF"';

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
                //VATRegNoFormat.Test("VAT Registration No.","Country/Region Code",'',DATABASE::"Company Information");
            end;
        }
        field(27; "Fax No."; Text[35])
        {
            Caption = 'Fax No.';
        }
        field(28; "Phone No."; Text[35])
        {
            Caption = 'Phone No.', comment = 'ESP="Nº teléfono"';
            ExtendedDatatype = PhoneNo;
        }
        field(29; Iban; Code[35])
        {
            Caption = 'IBAN';

            trigger OnValidate()
            var
                CompanyInfo: Record "Company Information";
            begin
                //CompanyInfo.CheckIBAN(IBAN);
            end;
        }
        field(30; "Issuer Commercial Register"; Text[70])
        {
            Caption = 'Registro Mercantil del emisor';
        }
        field(31; "Social Capital"; Text[35])
        {
            Caption = 'Capital social';
        }
        field(32; "Swift"; Code[20])
        {
            Caption = 'SWIFT';
        }
    }
    keys
    {
        key(Key1; "Document Type", "Document No.", "Interlocutor type", "Interlocutor No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }
}
