TableExtension 50110 "BBT Vendor Ledger Entry" extends "Vendor Ledger Entry"
{
    fields
    {
        field(50001; "Vendor Name BBT"; Text[250])
        {
            Caption = 'Vendor Name BBT';
            FieldClass = FlowField;
            CalcFormula = Lookup(Vendor.Name WHERE("No."=FIELD("Vendor No.")));
        }
        field(50002; Comment; Text[250])
        {
            Caption = 'Comentarios';
        }
        field(50003; "BBT Settlement From CSV"; Boolean)
        {
            Caption = 'Settlement From CSV', comment = 'ESP="Liquidación desde CSV"';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50004; "BBT Amount To Apply From CSV"; Decimal)
        {
            Caption = 'Amount To Apply From CSV', comment = 'ESP="Importe a liquidar desde CSV"';
            Editable = false;
            DataClassification = ToBeClassified;
        }
    }
}
