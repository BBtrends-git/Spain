page 51256 "SCM API Requisition WorkSheet"
{
    PageType = API;
    Caption = 'SCM Requisition WorkSheet';
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtscm';
    APIVersion = 'v2.0';
    EntityName = 'scmrequisition';
    EntitySetName = 'scmrequisitions';
    SourceTable = "Requisition Line";
    DelayedInsert = true;
    InsertAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Tipo"; Rec.Type)
                { }
                field("Codigo"; Rec."No.")
                { }
                field("Cantidad"; Rec.Quantity)
                { }
                field("Fecha"; Rec."Due Date")
                { }
            }
        }
    }

    var
        MaxLine: Integer;
        rRequisitionLineAux: record "Requisition Line";

    trigger OnInit()
    begin
        Rec.Reset();
        Rec.SetRange("Worksheet Template Name", 'REQ.');
        Rec.SetRange("Journal Batch Name", 'SCM');
    end;


    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(MaxLine);
        Maxline := 10000;

        rRequisitionLineAux.Reset();
        rRequisitionLineAux.SetRange("Worksheet Template Name", 'REQ.');
        rRequisitionLineAux.SetRange("Journal Batch Name", 'SCM');
        IF rRequisitionLineAux.FindLast() then
            MaxLine := rRequisitionLineAux."Line No." + 10000;

        Rec."Worksheet Template Name" := 'REQ.';
        Rec."Journal Batch Name" := 'SCM';
        Rec.Type := Rec.type::Item;
        Rec."Line No." := Maxline;
        Rec."Location Code" := 'MARGA-Q';
    end;
}