TableExtension 50185 "BBT Posted Cartera Doc." extends "Posted Cartera Doc."
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
