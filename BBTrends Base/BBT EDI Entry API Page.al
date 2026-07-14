page 51112 "BBT EDI Entry API"
{
    PageType = API;
    Caption = 'BBT EDI Entries API';
    APIPublisher = 'bbtrends';
    APIGroup = 'bbt';
    APIVersion = 'v2.0';
    EntityName = 'edientryapi';
    EntitySetName = 'edientryapi';
    SourceTable = "EDI - EDI Entry";
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(fileName; Rec."File name")
                {
                    Caption = 'Nombre fichero';
                }
                field(fileContent; fileContent)
                {
                    Caption = 'Contenido fichero';
                }
            }
        }
    }
    var
        Filecontent: text;
        TempBlob: codeunit "Temp Blob";
        Ostream: OutStream;
        Base64: Codeunit "Base64 Convert";

    trigger OnInsertRecord(BelowxRec: boolean): Boolean
    begin
        case true of
            Rec."File name".Contains('INV'):
                rec."Document type" := rec."Document type"::Invoice;
            Rec."File name".Contains('ORD'):
                rec."Document type" := rec."Document type"::Order;
            Rec."File name".Contains('ADV'):
                rec."Document type" := rec."Document type"::Shipment;
            else
                Error('Tipo documento no valido');
        end;
        rec."Received/Sent at" := CurrentDateTime;
        rec."Inbound/Outbound" := rec."Inbound/Outbound"::Inbound;
        rec."PL Entry" := true;
        rec."File Blob".CreateOutStream(Ostream);
        Ostream.WriteText(Filecontent);
    end;

    [ServiceEnabled]
    procedure UploadOK()
    begin
        rec.Uploaded := true;
        rec."Processed at" := CurrentDateTime;
        Rec.Modify();
    end;

    [ServiceEnabled]
    procedure UnMarkLoad()
    begin
        rec."Upload in progress" := false;
        Rec.Modify();
    end;
}