TableExtension 50137 "BBT Requisition Line" extends "Requisition Line"
{
    fields
    {
        modify("Demand Type")
        {
            TableRelation = AllObj."Object ID" where("Object Type" = const(Table));
        }
        field(50000; "Components at location"; Code[10])
        {
            Caption = 'Componentes en almacen';
            Description = 'SDA.20190207';
            TableRelation = Location where("Use As In-Transit" = const(false));
            ObsoleteState = Pending;    // BBT 01/07/2025
        }
    }
}
