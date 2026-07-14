Table 50013 "EDI - EDI Entry"
{
    Caption = 'EDI - Movs. EDI', Comment = 'ESP="EDI - Movimientods EDI"';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.', Comment = 'ESP="Nº Mov."';
        }
        field(2; "Document type"; enum "EDI Document Type")
        {
            Caption = 'Document type', Comment = 'ESP="Tipo documento"';
        }
        field(3; "Inbound/Outbound"; Option)
        {
            Caption = 'Inbound/Outbound', Comment = 'ESP="Entrada/Salida"';
            OptionCaption = ' ,Entrada,Salida';
            OptionMembers = " ",Inbound,Outbound;
        }
        field(4; "File name"; Text[150])
        {
            Caption = 'File name', Comment = 'ESP="Nombre fichero"';
        }
        field(5; "File Blob"; Blob)
        {
            Caption = 'File Blob', Comment = 'ESP="Blob fichero"';
        }
        field(6; "Document Nos."; Code[250])
        {
            Caption = 'Document Nos.', Comment = 'ESP="Nº Documentos"';
        }
        field(10; "Received/Sent at"; DateTime)
        {
            Caption = 'Received/Sent at', Comment = 'ESP="Recibido/enviado a"';
        }
        field(11; "Processed at"; DateTime)
        {
            Caption = 'Processed at', Comment = 'ESP="Procesado a"';
        }
        field(12; "Has error"; Boolean)
        {
            Caption = 'Has error', Comment = 'ESP="Con error"';
        }
        field(13; "Last error text"; Text[250])
        {
            Caption = 'Last error text', Comment = 'ESP="Últ. Texto error"';
        }
        field(14; "Manually processed"; Boolean)
        {
            Caption = 'Manually processed', Comment = 'ESP="Procesado manualmente"';
        }
        field(15; Uploaded; Boolean)
        {
            Caption = 'Uploaded', comment = 'ESP="Cargado"';
            DataClassification = ToBeClassified;
        }
        field(16; "Upload in progress"; Boolean)
        {
            Caption = 'Upload in progress', comment = 'ESP="Carga en curso"';
            DataClassification = ToBeClassified;
        }
        field(51120; "Source Type"; Option)
        {
            Caption = 'Source Type', Comment = 'ESP="Tipo Procedencia"';

            OptionMembers = " ","Customer","Vendor";
            OptionCaption = ' ,Customer,Vendor', Comment = 'ESP=" ,Cliente,Proveedor"';
        }
        field(51121; "Sourde Id"; Code[20])
        {
            Caption = 'Source Id.', Comment = 'ESP="Cod. Procedencia"';
        }
        field(51122; "PL Entry"; Boolean)
        {
            Caption = 'PL Entry', Comment = 'ESP="Registro PL"';
        }
        field(51149; "Source Name"; Text[100])
        {
            Caption = 'Source Name', Comment = 'ESP="Nombre Procedencia"';
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
    trigger OnInsert()
    begin
        EDIEDIEntry.Reset;
        if EDIEDIEntry.FindLast then;
        "Entry No." := EDIEDIEntry."Entry No." + 1;
    end;

    procedure CheckLoadfile()
    begin
        rec.TestField("Inbound/Outbound", "Inbound/Outbound"::Outbound);
        rec.TestField("Upload in progress", false);
    end;

    var
        EDIEDIEntry: Record "EDI - EDI Entry";
}
