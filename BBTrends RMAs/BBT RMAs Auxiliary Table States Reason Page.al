page 51205 "RMAs Auxiliary Table Reason"
{
    ApplicationArea = All;
    Caption = 'Sales Return Reason', comment = 'ESP="RMA Motivo Devolución"';
    PageType = List;
    SourceTable = "RMAS Auxiliary Table States";
    SourceTableView = sorting("Auxiliary Name");
    UsageCategory = Administration;
    DeleteAllowed = false;
    ModifyAllowed = true;
    InsertAllowed = true;

    layout
    {
        area(content)
        {
            repeater(States)
            {
                ShowCaption = false;
                field("Auxiliary Name"; Rec."Auxiliary Name")
                {
                    Caption = 'Return Reason', Comment = 'ESP="Motivo Devolución"';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec."Auxiliary Type" := rec."Auxiliary Type"::Reason;
                    end;
                }
            }
        }
    }

    actions
    { }


    trigger OnOpenPage()
    begin
        rec.Reset();
        rec.SetRange("Auxiliary Type", rec."Auxiliary Type"::Reason);
    end;
}