page 51206 "RMAs Auxiliary Table Category"
{
    ApplicationArea = All;
    Caption = 'Sales Return Category', comment = 'ESP="RMA Categoria Devolución"';
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
                    Caption = 'Return Category', Comment = 'ESP="Categoria Devolución"';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec."Auxiliary Type" := rec."Auxiliary Type"::Category;
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
        rec.SetRange("Auxiliary Type", rec."Auxiliary Type"::Category);
    end;
}