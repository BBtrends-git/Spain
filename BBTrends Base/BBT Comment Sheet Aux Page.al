Page 50103 "Comment Sheet Aux"
{
    AutoSplitKey = true;
    Caption = 'Comment Sheet';
    DataCaptionFields = "No.";
    DelayedInsert = true;
    Editable = false;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "Comment Line";
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }
    actions
    { }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine;
        // SGA
        FiltroTipo := Rec.GetFilter("Comment type");
        if FiltroTipo in ['Ship', 'Envío'] then rec."Comment type" := rec."comment type"::Ship;
    end;

    var
        FiltroTipo: Text;

    local procedure GetEditable(): Boolean
    begin
    end;
}
