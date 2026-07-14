table 50060 "BBT Depreciation Buffer"
{
    Caption = 'BBT Depreciation Buffer';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.', Comment = 'ESP="Nº producto"';
            TableRelation = Item;
        }
        field(2; "% Depreciation"; Decimal)
        {
            Caption = '% Depreciation', Comment = 'ESP="% depreciación"';
        }
        field(3; "Inventory Value Amount"; Decimal)
        {
            Caption = 'Inventory Value Amount', Comment = 'ESP="Importe valor inventario"';
        }
        field(4; "Depreciated Amount"; Decimal)
        {
            Caption = 'Depreciated Amount', Comment = 'ESP="Importe a depreciar"';
        }
        field(5; Quantity; Decimal)
        {
            Caption = 'Quantity', Comment = 'ESP="Cantidad"';
        }
        field(6; "Standard Cost"; Decimal)
        {
            Caption = 'Standard Cost', Comment = 'ESP="Coste estándar"';
        }
        field(7; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code', Comment = 'ESP="Cód. categoría producto"';
        }
    }
    keys
    {
        key(PK; "Item No.")
        {
            Clustered = true;
        }
    }
}
