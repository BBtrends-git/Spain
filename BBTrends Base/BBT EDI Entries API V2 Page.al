page 51105 "BBT EDI Entries API"
{
    PageType = API;
    Caption = 'BBT EDI Entries';
    APIPublisher = 'bbtrends';
    APIGroup = 'bbt';
    APIVersion = 'v2.0';
    EntityName = 'bbtedientry';
    EntitySetName = 'bbtedientry';
    SourceTable = "EDI - EDI Entry";
    DelayedInsert = true;
    //ODataKeyFields = SystemId,"Entry No.";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("EntryNo"; Rec."Entry No.")
                { }
                field("DocumentType"; Rec."Document type")
                { }
                field("InboundOutbound"; Rec."Inbound/Outbound")
                { }
                field("FileName"; Rec."File name")
                { }
                field("DocumentNos"; Rec."Document Nos.")
                { }
                field("ReceivedSentAt"; Rec."Received/Sent at")
                { }
                field("ProcessedAt"; Rec."Processed at")
                { }
                field("HasError"; Rec."Has error")
                { }
                field("LastErrorText"; Rec."Last error text")
                { }
                field("ManuallyProcessed"; Rec."Manually processed")
                { }
                field(Uploaded; Rec.Uploaded)
                { }
                field("UploadInProgress"; Rec."Upload in progress")
                { }
            }
        }
    }
}