page 51253 "SCM API Vendor"
{
    PageType = API;
    Caption = 'SCM Vendor';
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtscm';
    APIVersion = 'v2.0';
    EntityName = 'scmvendor';
    EntitySetName = 'scmvendors';
    SourceTable = Vendor;
    Editable = false;
    DelayedInsert = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Codigo"; Rec."No.")
                { }
                field("Nombre"; Rec.Name)
                { }
            }
        }
    }
    trigger OnInit()
    begin
    end;

    trigger OnAfterGetRecord()
    begin
    end;

}