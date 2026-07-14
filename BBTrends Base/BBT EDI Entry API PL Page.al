page 51106 "BBT EDI Entry API PL"
{
    PageType = API;
    Caption = 'BBT EDI Entries';
    APIPublisher = 'bbtrends';
    APIGroup = 'bbt';
    APIVersion = 'v2.0';
    EntityName = 'edientrypl';
    EntitySetName = 'edientrypl';
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
        IF Rec."File name".Contains('INV') then
            rec."Document type" := rec."Document type"::Invoice
        else
            rec."Document type" := rec."Document type"::Order;

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