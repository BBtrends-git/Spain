page 50028 "EDI Entries API"
{
    PageType = API;
    Caption = 'EDI Entries';
    APIPublisher = 'intelekta';
    APIGroup = 'itk';
    APIVersion = 'v2.0';
    EntityName = 'edientry';
    EntitySetName = 'edientry';
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
    var Filecontent: text;
    TempBlob: codeunit "Temp Blob";
    Ostream: OutStream;
    Base64: Codeunit "Base64 Convert";
    trigger OnInsertRecord(BelowxRec: boolean): Boolean begin
        IF Rec."File name".Contains('INV')then rec."Document type":=rec."Document type"::Invoice
        else
            rec."Document type":=rec."Document type"::Order;
        rec."Received/Sent at":=CurrentDateTime;
        rec."Inbound/Outbound":=rec."Inbound/Outbound"::Inbound;
        rec."File Blob".CreateOutStream(Ostream);
        Ostream.WriteText(Filecontent);
    end;
    [ServiceEnabled]
    procedure UploadOK()
    begin
        rec.Uploaded:=true;
        rec."Processed at":=CurrentDateTime;
        Rec.Modify();
    end;
    [ServiceEnabled]
    procedure UnMarkLoad()
    begin
        rec."Upload in progress":=false;
        Rec.Modify();
    end;
}
