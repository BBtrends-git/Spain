TableExtension 50149 "BBT Item Application Entry" extends "Item Application Entry"
{
    fields
    {
        field(50000; "Existe mov entrada"; Boolean)
        {
            CalcFormula = exist("Item Ledger Entry" where("Entry No." = field("Inbound Item Entry No.")));
            FieldClass = FlowField;
        }
    }
}
