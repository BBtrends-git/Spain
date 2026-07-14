page 51307 "SMG APOS Platform Cond. List"
{
    Caption = 'APOS Platform List', Comment = 'ESP="Condiciones APOS Plataformas"';

    DataCaptionFields = "Condition Code";
    PageType = List;
    SourceTable = "SMG APOS Conditions";

    DelayedInsert = true;
    SaveValues = true;
    ModifyAllowed = true;
    DeleteAllowed = true;
    InsertAllowed = true;

    SourceTableView = sorting("Condition Classification", "Condition Code") order(ascending);

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("ConditionClassification"; Rec."Condition Classification")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("ConditionCode"; Rec."Condition Code")
                {
                    ApplicationArea = All;
                    Visible = true;
                    Editable = true;
                    TableRelation = "SMG Customer Classification" where(Type = filter("Platform"));
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("%APOSExcludedfromInvoice"; Rec."% APOS Excluded from Invoice")
                {
                    ApplicationArea = All;
                }
                field("StartingDate"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                }

                field("EndingDate"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    { }

    var
        rSMGSetUp: Record "SMG Setup";
        rDimesionValue: Record "Dimension Value";
        cuSMGManagement: Codeunit "SMG Management";
        WithDiscounts: Boolean;
        BrandEnabled: Boolean;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        rec."Condition Classification" := rec."Condition Classification"::Platform;
    end;
}