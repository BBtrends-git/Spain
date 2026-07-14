TableExtension 50172 "BBT Lot No. Information" extends "Lot No. Information"
{
    // BBT 01/07/2025
    // Campos Creados para PRECINTIA en NAV. Uso OBSOLETO en BC
    fields
    {
        field(50000; "Lote Producido"; Boolean)
        {
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
        field(50001; "Cdad. Producida"; Decimal)
        {
            Caption = 'Cdad. a fabricar';
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
        field(50002; "Número Inicial"; Code[20])
        {
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
        field(50003; "Número Final"; Code[20])
        {
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
        field(50004; "Cód. OF"; Code[20])
        {
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
        field(50005; "Cdad. Fabricada"; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Source No." = field("Cód. OF"), "Item No." = field("Item No."), "Lot No." = field("Lot No."), "Entry Type" = const(Output)));
            FieldClass = FlowField;
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
        field(50006; "UDM Basica"; Decimal)
        {
            Caption = 'UDM Basica';
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
        field(50007; "Lote Repetido"; Boolean)
        {
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
        field(50008; "Num. Repetición"; Integer)
        {
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
        field(50009; "Fecha Modificación"; Date)
        {
            Editable = false;
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
    }
}
