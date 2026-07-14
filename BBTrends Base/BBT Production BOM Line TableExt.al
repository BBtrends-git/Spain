TableExtension 50189 "BBT Production BOM Line" extends "Production BOM Line"
{
    fields
    {
        field(50000; "Last Direct Cost"; Decimal)
        {
            AutoFormatType = 2;
            CalcFormula = lookup(Item."Last Direct Cost" where("No."=field("No.")));
            Caption = 'Last Direct Cost';
            Description = '001';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
