TableExtension 50184 "BBT Cartera Doc." extends "Cartera Doc."
{
    fields
    {
        field(50000; "Nombre Cliente"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Account No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "Nombre Proveedor"; Text[100])
        {
            CalcFormula = lookup(Vendor.Name where("No." = field("Account No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
