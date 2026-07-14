TableExtension 50148 "BBT Entry Summary" extends "Entry Summary"
{
    fields
    {
        field(50000; "Cód. OF"; Code[20])
        {
            //>> BBT. PRECINTIA. Obsoleto
            //CalcFormula = lookup("Lot No. Information"."Cód. OF" where("Lot No." = field("Lot No.")));
            //FieldClass = FlowField;
            //<<
        }
    }
}
