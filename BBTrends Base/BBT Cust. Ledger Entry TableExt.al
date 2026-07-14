TableExtension 50108 "BBT Cust. Ledger Entry" extends "Cust. Ledger Entry"
{
    fields
    {
        field(50000; Deduction; Boolean)
        {
            Caption = 'Deduction';
            Description = '001';
        }
        field(50001; "Customer Name BBT"; Text[250])
        {
            Caption = 'Customer Name BBT';
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No.")));
        }
        field(50002; Comment; Text[250])
        {
            Caption = 'Comentarios';
        }
        field(50003; "Doc. Relation"; Code[12])
        {
            Caption = 'Documento Relación';
        }
        field(50004; "BBT Settlement From CSV"; Boolean)
        {
            Caption = 'Settlement From CSV', comment = 'ESP="Liquidación desde CSV"';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50005; "BBT Amount To Apply From CSV"; Decimal)
        {
            Caption = 'Amount To Apply From CSV', comment = 'ESP="Importe a liquidar desde CSV"';
            Editable = false;
            DataClassification = ToBeClassified;
        }
    }
}
