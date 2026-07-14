table 51204 "RMAs Package Lines Querys"
{
    Caption = 'RMAs Sales Packages Lines Querys';
    DataClassification = ToBeClassified;
    //>> Se pasa a obsoleta porque no se puede añadir un campo nuevo a la Key1
    ObsoleteState = Removed;
    //<<
    fields
    {
        field(1; "Package No."; Code[50])
        {
            Caption = 'Package No.', Comment = 'ESP="No. Bulto"';
            Description = 'Package Header';
        }
        field(2; "Package Line"; Integer)
        {
            Caption = 'Package Line', Comment = 'ESP="No. Linea"';
            Description = 'Package Line';
        }
        field(3; "Creation Date"; date)
        {
            Caption = 'Creation Date', Comment = 'ESP="Fecha Alta"';
        }
        field(4; "Package Type"; Enum "RMAs Package Type")
        {
            Caption = 'Package Type', Comment = 'ESP="Tipo de Bulto"';
        }
        field(5; "Numbers Packages"; Integer)
        {
            Caption = 'Numbers of Packages', Comment = 'ESP="Numero de Bultos"';
        }
        field(6; "Package Status"; Enum "RMAs Package Status")
        {
            Caption = 'Package Status', Comment = 'ESP="Estado Bulto"';
            Description = 'Package Header';
        }
        field(7; "Registered Package"; Boolean)
        {
            Caption = 'Registered Package', Comment = 'ESP="Bulto Registrado"';
            Description = 'Package Header';
        }
        field(8; "Return Order No."; Code[20])
        {
            Caption = 'Return Order No.', Comment = 'ESP="No. Devolución"';
            TableRelation = "Sales Header"."No." where("Document Type" = filter("Return Order"));
            Description = 'Package Line';
        }
        field(9; "Return Customer"; Code[20])
        {
            Caption = 'Return Customer', Comment = 'ESP="Cliente Devolución"';
            TableRelation = Customer."No." where("No." = field("Return Customer"));
            Description = 'Package Line';
        }
        field(10; "Return Customer Name"; Text[100])
        {
            Caption = 'Return Customer Name', Comment = 'ESP="Nombre Cliente Devolución"';
            Description = 'Package Line';
        }
        field(11; "Return Category"; Text[50])
        {
            Caption = 'Return Category', Comment = 'ESP="Categoria Devolución"';
            TableRelation = "RMAS Auxiliary Table States"."Auxiliary Name" where("Auxiliary Type" = filter("Category"));
        }
        field(12; "Item No."; Code[20])
        {
            Caption = 'Item No.', Comment = 'ESP="No. Producto"';
            TableRelation = Item;
            Description = 'Package Line';
        }
        field(13; "EAN of Unit"; Code[20])
        {
            Caption = 'EAN of Unit', Comment = 'ESP="EAN Unidad"';
            TableRelation = "Item Identifier".Code;
            Description = 'Package Line';
        }
        field(14; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
            Description = 'Package Line';
        }
        field(15; Quantity; Integer)
        {
            Caption = 'Quantity', Comment = 'ESP="Cantidad en Bulto"';
            Description = 'Package Line';
        }
        field(16; "Qty. Quality A"; Integer)
        {
            Caption = 'Qty. Quality A', Comment = 'ESP="Cantidad Calidad A"';
            Description = 'Package Line';
        }
        field(17; "Qty. Quality B"; Integer)
        {
            Caption = 'Qty. Quality B', Comment = 'ESP="Cantidad Calidad B"';
            Description = 'Package Line';
        }
        field(18; "Qty. Quality C"; Integer)
        {
            Caption = 'Qty. Quality A', Comment = 'ESP="Cantidad Calidad C"';
            Description = 'Package Line';
        }
        field(19; "Qty. to Return"; Integer)
        {
            Caption = 'Qty. to Return', Comment = 'ESP="Cantidad Devolución"';
            Description = 'Package Line';
        }
        field(20; "Qty. to Returned"; Integer)
        {
            Caption = 'Qty. to Returned', Comment = 'ESP="Cantidad a Devolver"';
            Description = 'Package Line';
        }
        field(21; "Qty. Returned"; Integer)
        {
            Caption = 'Qty. Returned', Comment = 'ESP="Cantidad Devuelta"';
            Description = 'Package Line';
        }
        field(22; "Qty. to Invoiced"; Integer)
        {
            Caption = 'Qty. to Invoiced', Comment = 'ESP="Cantidad a Facturar"';
            Description = 'Package Line';
        }
        field(23; "Qty. Invoiced"; Integer)
        {
            Caption = 'Qty. Invoiced', Comment = 'ESP="Cantidad Facturada"';
            Description = 'Package Line';
        }
        field(24; "Posted No."; Integer)
        {
            Caption = 'Posted No.', Comment = 'ESP="No. Registro"';
            NotBlank = true;
        }
    }
    keys
    {
        key(Key1; "Package No.", "Package Line")
        {
            Clustered = true;
        }
    }
}