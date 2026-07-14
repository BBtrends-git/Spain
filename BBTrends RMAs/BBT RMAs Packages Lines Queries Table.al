table 51211 "RMAs Package Lines Queries"
{
    Caption = 'RMAs Sales Packages Lines Queries', Comment = 'ESP="Consulta Lineas Bultos Devolucion Ventas"';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Package No."; Code[50])
        {
            Caption = 'Package No.', Comment = 'ESP="No. Bulto"';
        }
        field(2; "Posted No."; Integer)
        {
            Caption = 'Posted No.', Comment = 'ESP="No. Registro"';
            NotBlank = true;
        }
        field(3; "Package Line"; Integer)
        {
            Caption = 'Package Line', Comment = 'ESP="No. Linea"';
        }
        field(4; "Creation Date"; date)
        {
            Caption = 'Creation Date', Comment = 'ESP="Fecha Alta"';
        }
        field(5; "Package Type"; Enum "RMAs Package Type")
        {
            Caption = 'Package Type', Comment = 'ESP="Tipo de Bulto"';
        }
        field(6; "Numbers Packages"; Integer)
        {
            Caption = 'Numbers of Packages', Comment = 'ESP="Numero de Bultos"';
        }
        field(7; "Package Status"; Enum "RMAs Package Status")
        {
            Caption = 'Package Status', Comment = 'ESP="Estado Bulto"';
        }
        field(8; "Registered Package"; Boolean)
        {
            Caption = 'Registered Package', Comment = 'ESP="Bulto Registrado"';
        }

        field(9; "Return Order No."; Code[20])
        {
            Caption = 'Return Order No.', Comment = 'ESP="No. Devolución"';
            TableRelation = "Sales Header"."No." where("Document Type" = filter("Return Order"));
        }
        field(10; "Return Customer"; Code[20])
        {
            Caption = 'Return Customer', Comment = 'ESP="Cliente Devolución"';
            TableRelation = Customer."No." where("No." = field("Return Customer"));
        }
        field(11; "Return Customer Name"; Text[100])
        {
            Caption = 'Return Customer Name', Comment = 'ESP="Nombre Cliente Devolución"';
        }
        field(12; "Return Category"; Text[50])
        {
            Caption = 'Return Category', Comment = 'ESP="Categoria Devolución"';
            TableRelation = "RMAS Auxiliary Table States"."Auxiliary Name" where("Auxiliary Type" = filter("Category"));
        }
        field(13; "Item No."; Code[20])
        {
            Caption = 'Item No.', Comment = 'ESP="No. Producto"';
            TableRelation = Item;
        }
        field(14; "EAN of Unit"; Code[20])
        {
            Caption = 'EAN of Unit', Comment = 'ESP="EAN Unidad"';
            TableRelation = "Item Identifier".Code;
        }
        field(15; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(16; Quantity; Integer)
        {
            Caption = 'Quantity', Comment = 'ESP="Cantidad en Bulto"';
        }
        field(17; "Qty. Quality A"; Integer)
        {
            ObsoleteState = Removed;
            Caption = 'Qty. Quality A', Comment = 'ESP="Cantidad Calidad A"';
        }
        field(18; "Qty. Quality B"; Integer)
        {
            ObsoleteState = Removed;
            Caption = 'Qty. Quality B', Comment = 'ESP="Cantidad Calidad B"';
        }
        field(19; "Qty. Quality C"; Integer)
        {
            ObsoleteState = Removed;
            Caption = 'Qty. Quality A', Comment = 'ESP="Cantidad Calidad C"';
        }
        field(20; "Qty. to Return"; Integer)
        {
            Caption = 'Qty. to Return', Comment = 'ESP="Cantidad Devolución"';
        }
        field(21; "Qty. to Returned"; Integer)
        {
            Caption = 'Qty. to Returned', Comment = 'ESP="Cantidad a Devolver"';
        }
        field(22; "Qty. Returned"; Integer)
        {
            Caption = 'Qty. Returned', Comment = 'ESP="Cantidad Devuelta"';
        }
        field(23; "Qty. to Invoiced"; Integer)
        {
            Caption = 'Qty. to Invoiced', Comment = 'ESP="Cantidad a Facturar"';
        }
        field(24; "Qty. Invoiced"; Integer)
        {
            Caption = 'Qty. Invoiced', Comment = 'ESP="Cantidad Facturada"';
        }
        field(25; "Return Reason Code"; Code[10])
        {
            Caption = 'Return Reason Code', Comment = 'ESP="Motivo Devolución"';
        }
        field(26; Quality; Enum "RMAs Package Quality")
        {
            Caption = 'Quality', Comment = 'ESP="Calidad"';
        }
        field(27; "Return Reason"; Text[50])
        {
            Caption = 'Return Reason', Comment = 'ESP="Motivo Retorno"';
        }
        field(28; "Return Resource"; Text[50])
        {
            Caption = 'Return Operator', Comment = 'ESP="Operador Devolución"';
        }
        field(29; "Incident Reason"; Text[100])
        {
            Caption = 'Incident Reason', Comment = 'ESP="Notas Incidencia"';
        }
        field(30; "Transferred Qty."; Integer)
        {
            Caption = 'Transferred Qty.', Comment = 'ESP="Cantidad Transferida"';
        }
        field(31; "Adjusted Qty."; Integer)
        {
            Caption = 'Adjusted Qty.', Comment = 'ESP="Cantidad Adjustada"';
        }
        field(32; "Qty. to Transfer"; Integer)
        {
            Caption = 'Qty. to Transfer', Comment = 'ESP="Cantidad a Transferir"';
        }
    }
    keys
    {
        key(Key1; "Package No.", "Posted No.", "Package Line")
        {
            Clustered = true;
        }
    }
}