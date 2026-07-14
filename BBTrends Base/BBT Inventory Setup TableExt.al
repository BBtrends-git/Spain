TableExtension 50145 "BBT Inventory Setup" extends "Inventory Setup"
{
    fields
    {
        field(50000; "Almacén último inventario"; Text[250])
        {
        }
        field(50001; "Raw Materials Location Code"; Code[10])
        {
            Caption = 'Raw Materials Location Code';
            Description = 'RFB-002';
            TableRelation = Location;
        }
        field(50002; "Factory Location Code"; Code[10])
        {
            Caption = 'Factory Location Code';
            Description = 'RFB-002';
            TableRelation = Location;
        }
        field(50003; "Logistic Location Code"; Code[10])
        {
            Caption = 'Logistic Location Code';
            Description = 'RFB-003';
            TableRelation = Location;
        }
        field(50004; "Logistic Whse. Profile ID"; Code[30])
        {
            Caption = 'Logistic Whse. User Profile ID';
            Description = 'RLG-001';
            TableRelation = "All Profile";
        }
        field(50005; "Item Depreciation No."; Code[20])
        {
            Caption = 'Item Depreciation No.', Comment = 'ESP="Nº cuenta depreciación producto (debe)"';
            TableRelation = "G/L Account";
        }
        field(50006; "Inventory Depreciation No."; Code[20])
        {
            Caption = 'Inventory Depreciation No.', Comment = 'ESP="Nº cuenta depreciación inventario (haber)"';
            TableRelation = "G/L Account";
        }
        field(50007; "Depreciation Nos."; Code[20])
        {
            Caption = 'Depreciation Nos.', Comment = 'ESP="Nº serie depreciación"';
            TableRelation = "No. Series";
        }
    }
}
