page 51237 "RMAs Item Comment Lines Faxbox"
{
    Caption = 'Item Comments', Comment = 'ESP="Comentarios del Producto"';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Comment Line";
    UsageCategory = None;
    ApplicationArea = all;
    SourceTableView = where("Table Name" = const(Item));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No"; rec."No.")
                {
                    ApplicationArea = Comments;
                    Visible = false;
                    StyleExpr = 'StandardAccent';
                }
                field("LineNo."; rec."Line No.")
                {
                    ApplicationArea = Comments;
                    Visible = false;
                    StyleExpr = 'StandardAccent';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Comments;
                    StyleExpr = 'StandardAccent';
                }
                field(Comment; rec.Comment)
                {
                    ApplicationArea = Comments;
                    StyleExpr = 'StandardAccent';
                }
            }
        }
    }
}