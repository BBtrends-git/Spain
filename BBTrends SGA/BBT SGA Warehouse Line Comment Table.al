Table 51454 "SGA Warehouse Line Comment"
{

    Caption = 'SGA Warehouse Line Comment', Comment = 'ESP="Comentarios Almacén SGA"';
    DrillDownPageID = "SGA Warehouse Line Comment";
    LookupPageID = "SGA Warehouse Line Comment";

    fields
    {
        field(1; "Document Type"; Enum "SGA Warehouse Type Comment")
        {
            Caption = 'Document Type', Comment = 'ESP="Tipo Comentario"';
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="No. Comentario"';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.', Comment = 'ESP="Linea Comentario"';
        }
        field(4; "Date"; date)
        {
            Caption = 'Date', Comment = 'ESP="Fecha Comentario"';
        }
        field(5; "Code"; Code[10])
        {
            Caption = 'Code', Comment = 'ESP="Codigo Comentario"';
        }
        field(6; Comment; Text[80])
        {
            Caption = 'Comment', Comment = 'ESP="Commentario"';
        }
        field(7; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.', Comment = 'ESP="Número Línea Documento"';
        }
    }
    keys
    {
        key(Key1; "Document Type", "No.", "Document Line No.", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    { }

    procedure SGASetUpNewLine()
    var
        rSalesCommentLine: Record "Sales Comment Line";
    begin
        rSalesCommentLine.SetRange("Document Type", "Document Type");
        rSalesCommentLine.SetRange("No.", "No.");
        rSalesCommentLine.SetRange("Document Line No.", "Document Line No.");
        rSalesCommentLine.SetRange(Date, WorkDate);
        if not rSalesCommentLine.FindFirst then Date := WorkDate;
    end;
}
