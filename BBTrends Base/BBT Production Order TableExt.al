TableExtension 50155 "BBT Production Order" extends "Production Order"
{
    fields
    {
        modify("Location Code")
        {
            Caption = 'Location Code', comment = 'ESP="Cód. almacén entrega"';
        }
        field(50002; "Cantidad terminada"; Decimal)
        {
            Caption = 'Cantidad terminada';
            Description = 'SDA';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Prod. Order Line"."Finished Quantity" WHERE(Status = FIELD(Status), "Prod. Order No." = FIELD("No.")));
        }
        field(50003; "Location Components Code"; Code[10])
        {
            Caption = 'Location Components Code', comment = 'ESP="Cód. almacén consumo"';
            Description = 'SDA';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(50004; "Scrap Quantity"; Decimal)
        {
            Caption = 'Scrap Quantity', comment = 'ESP="Cantidad Rechazada"';
            Description = 'SDA';
            FieldClass = FlowField;
            CalcFormula = Sum("Capacity Ledger Entry"."Scrap Quantity" WHERE("Order Type" = CONST(Production), "Order No." = FIELD("No.")));
        }
        field(50005; "Cód. Pedido"; Code[20])
        {
            Caption = 'Cód. Pedido';
            Description = 'SDA';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Order));
        }
        field(50006; "Item Tracking Code"; Code[20])
        {
            Caption = 'Item Tracking Code', comment = 'ESP="Cód. Seguimiento Prod."';
            Description = 'SDA';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Item Tracking Code" WHERE("No." = FIELD("Source No.")));
        }
        field(50007; "Documento de disenyo"; Boolean)
        {
            Caption = 'Documento de disenyo';
            Description = 'SDA';
        }
        field(50008; "No. Linea Pedido"; Integer)
        {
            Caption = 'No. Linea Pedido';
            Description = 'SDA';
        }
    }
    var
        InvSetup: Record "Inventory Setup";
        Company: Record Company;
        rItem: Record Item;
}
