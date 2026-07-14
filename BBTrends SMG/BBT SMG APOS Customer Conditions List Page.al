page 51306 "SMG APOS Customer Cond. List"
{
    Caption = 'APOS Customer List', Comment = 'ESP="Condiciones APOS Clientes"';

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
                    TableRelation = Customer;
                    ApplicationArea = All;
                    Visible = true;
                    Editable = true;
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
        rDimesionValue: Record "Dimension Value";
        cuSMGManagement: Codeunit "SMG Management";
        WithDiscounts: Boolean;
        BrandEnabled: Boolean;

    trigger OnOpenPage()
    begin
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        rec."Condition Classification" := rec."Condition Classification"::Customer;
    end;
}