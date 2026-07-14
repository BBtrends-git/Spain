page 51305 "SMG COLS Conditions List"
{
    Caption = 'COLS Conditions List', Comment = 'ESP="Condiciones COLS"';

    //CardPageID = "Customer Card";
    DataCaptionFields = "Customer No.";
    Editable = true;
    PageType = List;
    SourceTable = "SMG COLS Conditions";

    DelayedInsert = true;
    SaveValues = true;
    ModifyAllowed = true;
    DeleteAllowed = true;
    InsertAllowed = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("CustomerNo."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    //Visible = false;
                    Editable = false;
                }
                field("%_ACOLExcludedfromInvoice"; Rec."% COLS Excluded from Invoice")
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

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Starting Date", "Ending Date");
        Rec.Ascending(true);
    end;
}

