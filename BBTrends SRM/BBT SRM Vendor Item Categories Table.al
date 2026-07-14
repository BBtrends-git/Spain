table 51354 "SRM Vendor Item Categories"

{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.', Comment = 'ESP="No. Proveedor"';
            TableRelation = Vendor;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Category', Comment = 'ESP="Categoria"';
            TableRelation = "Item Category" where("Parent Category" = FILTER('<>'''''), "Indentation" = FILTER('<>0'));
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
    }

    keys
    {
        key(Key1; "Vendor No.", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    { }
}