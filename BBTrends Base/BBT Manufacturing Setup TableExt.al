TableExtension 50188 "BBT Manufacturing Setup" extends "Manufacturing Setup"
{
    fields
    {
        field(50000; "Automatic Consumptions"; Boolean)
        {
            Caption = 'Automatic Consumptions';
            Description = 'RFB-001';
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
        field(50001; "Auto. Cons. Jnl. Tmpl. Name"; Code[10])
        {
            Caption = 'Auto. Cons. Jnl. Tmpl. Name';
            Description = 'RFB-001';
            TableRelation = "Item Journal Template".Name where(Recurring = filter(false));
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
        field(50002; "Auto. Cons. Jnl. Batch Name"; Code[10])
        {
            Caption = 'Auto. Cons. Jnl. Batch Name';
            Description = 'RFB-001';
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("Auto. Cons. Jnl. Tmpl. Name"));
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
        field(50003; "Date-Time PedTransfer"; DateTime)
        {
            Description = 'RFB-002';
            Editable = false;
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
        field(50004; "Last MRP Calculation"; DateTime)
        {
            Caption = 'Hora Último Cálculo MRP';
        }
        field(50005; "Lote Producto Auto."; Boolean)
        {
        }
        field(50006; "Req. calculate forecast"; Code[10])
        {
            Caption = 'Previsión prod. cálculo demanda';
            Description = 'TC140521';
            TableRelation = "Production Forecast Name";
        }
        field(50007; "Active sales budget"; Code[10])
        {
            Caption = 'Presupuesto venta activo';
            Description = 'TC150521';
            TableRelation = "Item Budget Name".Name where("Analysis Area" = filter(Sales));
        }
        field(50008; "Ruta PDF disenyo"; Text[250])
        {
        }
    }
}
