TableExtension 50166 "BBT Warehouse Setup" extends "Warehouse Setup"
{
    fields
    {
        field(50000; "Nombre servidor SQL"; Text[50])
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Caption = 'SQL server name';
            Description = 'SGA';
        }
        field(50001; "Base de datos"; Text[50])
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Caption = 'Database';
            Description = 'SGA';
        }
        field(50002; "Usuario conex."; Text[30])
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Caption = 'User ID';
            Description = 'SGA';
        }
        field(50003; "Contraseña conex."; Text[30])
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Caption = 'Password';
            Description = 'SGA';
        }
        field(50004; "Box Unit"; Code[10])
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Caption = 'Box unit';
            Description = 'SGA';
            TableRelation = "Unit of Measure";
        }
        field(50005; "Journal Template Name"; Code[10])
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Caption = 'Journal Template Name';
            Description = 'SGA';
            TableRelation = "Item Journal Template" where("Page ID" = const(40), Recurring = const(false), Type = const(Item));
        }
        field(50006; "Journal Batch Name"; Code[10])
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Caption = 'Journal Batch Name';
            Description = 'SGA';
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
        field(50007; "Inv Journal Template Name"; Code[10])
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Caption = 'Journal Template Name';
            Description = 'SGA';
            TableRelation = "Item Journal Template" where("Page ID" = const(392), Recurring = const(false), Type = const("Phys. Inventory"));
        }
        field(50008; "Inv Journal Batch Name"; Code[10])
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Caption = 'Journal Batch Name';
            Description = 'SGA';
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
        field(50009; "Palet Unit"; Code[10])
        {
            //>> BBT SGA Extension
            ObsoleteState = Pending;
            //<<
            Caption = 'Palet Unit';
            Description = 'SGA';
            TableRelation = "Unit of Measure";
        }
        field(50010; "Return Day"; Integer)
        {
            Caption = 'Return Day';
            Description = 'RLG-003';
        }
        field(50011; "File directory export"; Text[250])
        {
            Caption = 'File directory export';
        }
        field(50012; "Packing report"; Integer)
        {
            BlankZero = true;
            Caption = 'Packing report';
            TableRelation = AllObj."Object ID" where("Object Type" = const(Report));
        }
        field(50013; "Pallet Weight"; Decimal)
        {
            Caption = 'Pallet Weight';
        }
        field(50014; "Alm. inicio propuesta"; Code[10])
        {
            TableRelation = Location;
            ObsoleteState = Removed;    // Precintia
        }
        field(50015; "Alm. fin propuesta"; Code[10])
        {
            TableRelation = Location;
            ObsoleteState = Removed;    // Precintia
        }
        field(51109; "Default Return Location"; Code[10])
        {
            Caption = 'Default Return Location', Comment = 'ESP="Almacén Devolución"';
            TableRelation = Location;
        }
        field(51163; "Default Sales CR Memo Location"; Code[10])
        {
            Caption = 'Default Sales Cr Memo Location', Comment = 'ESP="Almacén Abonos"';
            TableRelation = Location;
        }
    }
}
