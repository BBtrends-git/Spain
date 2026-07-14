TableExtension 50123 "BBT General Ledger Setup" extends "General Ledger Setup"
{
    fields
    {
        field(50000; "PolishVAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.', comment = 'ESP="CIF/NIF"';

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
            end;
        }
        field(50001; "BBT Jnl. Templ. Name Paym. Fee"; Code[10])
        {
            Caption = 'Journal Template Name Payment Fee', comment = 'ESP="Libro diario pago cuota"';
            TableRelation = "Gen. Journal Template" where(Type = const(General), Recurring = const(false));
            DataClassification = ToBeClassified;
        }
        field(50002; "BBT Jnl. Batch Name Paym. Fee"; Code[10])
        {
            Caption = 'Journal Batch Name Payment Fee', comment = 'ESP="Sección pago cuota"';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("BBT Jnl. Templ. Name Paym. Fee"), Recurring = const(false));
            DataClassification = ToBeClassified;
        }
        field(50003; "BBT Jnl. Templ. Name Loan Recl"; Code[10])
        {
            Caption = 'Journal Template Name Loan Reclassification', comment = 'ESP="Libro diario reclasificación préstamo"';
            TableRelation = "Gen. Journal Template" where(Type = const(General), Recurring = const(false));
            DataClassification = ToBeClassified;
        }
        field(50004; "BBT Jnl. Batch Name Loan Recl."; Code[10])
        {
            Caption = 'Journal Batch Name Loan Reclassification', comment = 'ESP="Sección reclasificación préstamo"';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("BBT Jnl. Templ. Name Loan Recl"), Recurring = const(false));
            DataClassification = ToBeClassified;
        }
    }
}
