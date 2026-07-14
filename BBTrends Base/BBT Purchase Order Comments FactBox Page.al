page 51108 "BBT Purchase Order Com FactBox"
{
    Caption = 'Purchase Order Comments', Comment = 'ESP="Comentarios Pedido Compras"';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Purch. Comment Line";
    UsageCategory = None;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("DocumentType"; rec."Document Type")
                {
                    ApplicationArea = Comments;
                    ToolTip = 'Specifies a type of document', Comment = 'ESP="Especifica el tipo de documento"';
                    Visible = false;
                }
                field("No"; rec."No.")
                {
                    ApplicationArea = Comments;
                    ToolTip = 'Specifies a code for teh document', Comment = 'ESP="Especifica el código del documento"';
                    Visible = false;
                }
                field("LineNo."; rec."Line No.")
                {
                    ApplicationArea = Comments;
                    ToolTip = 'Specifies a line for a comment', Comment = 'ESP="Especifica la linea del comentario"';
                    Visible = false;
                }
                field(Date; rec.Date)
                {
                    ApplicationArea = Comments;
                    ToolTip = 'Specifies the date when you created a comment', Comment = 'ESP="Especifica la fecha del comentario"';
                    Visible = false;
                }
                field(Comment; rec.Comment)
                {
                    ApplicationArea = Comments;
                    ToolTip = 'Specifies the comment that relates to a purchase order', Comment = 'ESP="Especifica el comentario relacionado con el pedido de compras"';
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Comments")
            {
                ApplicationArea = Comments;
                Caption = 'Comments', Comment = 'ESP="Comentarios"';
                Image = ViewComments;
                RunObject = Page "Purch. Comment Sheet";
                RunPageLink = "Document Type" = field("Document Type"),
                                  "No." = field("No."),
                                  "Document Line No." = const(0);
                ToolTip = 'View or add comments for the record', Comment = 'ESP="Enseña o añade comentarios al registro"';
            }
        }
    }
}