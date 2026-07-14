TableExtension 51451 "SGA Item" extends Item
{
    fields
    {
        field(51450; "SGA Item Management"; Boolean)
        {
            Caption = 'SGA Enabled', Comment = 'ESP="SGA Activado"';
            InitValue = true;
        }
        field(51451; "SGA Batch Management"; Boolean)
        {
            Caption = 'SGA Batch Management', Comment = 'ESP="Gestión Lote Activada"';
            InitValue = false;
        }
        field(51452; "SGA Forced Batch Sales"; Boolean)
        {
            Caption = 'SGA Forced Batch Sales', Comment = 'ESP="Venta Obligatoria en Lote"';
            InitValue = false;
        }
        field(51453; "SGA Forced Batch Purchases"; Boolean)
        {
            Caption = 'SGA Forced Batch Purchases', Comment = 'ESP="Compra Obligatoria en Lote"';
            InitValue = false;
        }
        field(51454; "SGA Requires Modification"; Boolean)
        {
            Caption = 'SGA Requires Modification', Comment = 'ESP="Modificar en SGA"';
            InitValue = false;
        }
    }

    procedure SGAItemModification(): Boolean;
    begin
        if Rec."SGA Item Management" then
            exit(
                (rec."No." <> xRec."No.") or
                (rec.Description <> xRec.Description) or
                (rec."Base Unit of Measure" <> xRec."Base Unit of Measure") or
                (Rec."Item Category Code" <> xRec."Item Category Code") or
                (Rec."SGA Item Management" <> xRec."SGA Item Management") or
                (Rec."SGA Batch Management" <> xRec."SGA Batch Management") or
                (Rec."SGA Forced Batch Purchases" <> xRec."SGA Forced Batch Purchases") or
                (Rec."SGA Forced Batch Sales" <> xRec."SGA Forced Batch Sales") or
                (Rec."Search Description" <> xRec."Search Description") or
                (Rec."Net Weight" <> xRec."Net Weight") or
                (Rec."Gross Weight" <> xRec."Gross Weight") or
                (Rec."Unit Volume" <> xRec."Unit Volume") or
                (Rec."Gen. Prod. Posting Group" <> xRec."Gen. Prod. Posting Group")
                )
        else
            exit(false);
    end;
}