table 51202 "RMAs Package Line"
{
    Caption = 'Sales Return Package Lines', Comment = 'ESP="Lineas Bultos Devolucion Ventas"';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Package No."; Code[50])
        {
            Caption = 'Package No.', Comment = 'ESP="No. Bulto"';
        }
        field(2; "Package Line"; Integer)
        {
            Caption = 'Package Line', Comment = 'ESP="No. Linea"';
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.', Comment = 'ESP="No. Producto"';
            TableRelation = Item;
        }
        field(4; "EAN of Unit"; Code[20])
        {
            Caption = 'EAN of Unit', Comment = 'ESP="EAN Unidad"';
            TableRelation = "Item Identifier".Code;
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(6; Quantity; Integer)
        {
            Caption = 'Quantity', Comment = 'ESP="Cantidad"';
        }
        field(7; "Lot Number"; Code[50])
        {
            Caption = 'Lot Number', Comment = 'ESP="Número Lote"';
        }
        field(8; Quality; Enum "RMAs Package Quality")
        {
            Caption = 'Quality', Comment = 'ESP="Calidad"';
            NotBlank = true;
        }
        field(9; Condition; Enum "RMAs Package Condition")
        {
            Caption = 'Condition', Comment = 'ESP="Estado"';
        }
        field(10; "Return Order No."; Code[20])
        {
            Caption = 'Return Order No.', Comment = 'ESP="No. Devolución"';
            TableRelation = "Sales Header"."No." where("Document Type" = filter("Return Order"));
        }
        field(11; "Return Reason"; Text[50])
        {
            Caption = 'Return Reason', Comment = 'ESP="Motivo Devolución"';
            TableRelation = "RMAS Auxiliary Table States"."Auxiliary Name" where("Auxiliary Type" = filter("Reason"));
        }
        field(12; Incident; Boolean)
        {
            Caption = 'Incident', Comment = 'ESP="Incidencia"';
        }
        field(13; "Incident Reason"; Text[100])
        {
            Caption = 'Incident Reason', Comment = 'ESP="Notas Incidencia"';
        }
        field(14; "Analysis Date"; date)
        {
            Caption = 'Analysis Date', Comment = 'ESP="Fecha Analisis"';
        }
        field(15; "Return Resource"; Text[50])
        {
            Caption = 'Return Operator', Comment = 'ESP="Operador Devolución"';
            //>> SI CAMBIAN EL GRUPO DEL RECURSO EN LA CONFIGURACION ESTO NO FUNCIONARÁ.
            TableRelation = "Resource"."No." where("Resource Group No." = const('DEVOLUCIONES'));
            //<< 
        }
        field(16; "Posted Quantity"; Integer)
        {
            Caption = 'Posted Quantity', Comment = 'ESP="Cantidad Registrada"';
            FieldClass = FlowField;
            CalcFormula = sum("RMAs Posted Package Line".Quantity
                            where("Posted Package No." = field("Package No."),
                                "Posted Package Line" = field("Package Line"),
                                "Item No." = field("Item No.")));
            Editable = false;
        }
        field(17; "Remaining Quantity"; Integer)
        {
            Caption = 'Remaining Quantity', Comment = 'ESP="Cantidad Restante"';
            Editable = false;
        }
        field(18; "Registered Package"; Boolean)
        {
            Caption = 'Registered Package', Comment = 'ESP="Bulto Registrado"';
            FieldClass = FlowField;
            CalcFormula = lookup("RMAs Package"."Registered Package"
                            where("Package No." = field("Package No.")));
        }
    }
    keys
    {
        key(Key1; "Package No.", "Package Line")
        {
            Clustered = true;
        }
    }

    var
        PRUEBA: Code[20];

    procedure RenamePackageNo(OldPackageNo: Code[50]; NewPackageNo: Code[50])
    var
        rOldRMAPackageLine: Record "RMAs Package Line";
        rNewRMAPackageLine: Record "RMAs Package Line";
    begin
        rOldRMAPackageLine.Reset();
        rOldRMAPackageLine.SetRange("Package No.", OldPackageNo);
        if rOldRMAPackageLine.FindSet() then
            repeat begin
                rNewRMAPackageLine.Init();
                rNewRMAPackageLine := rOldRMAPackageLine;
                rNewRMAPackageLine."Package No." := NewPackageNo;
                rNewRMAPackageLine.Insert();

                rOldRMAPackageLine.Delete();
            end;
            until rOldRMAPackageLine.Next() = 0;
    end;

    procedure GetRemainingQuantity(pRMAPackageLine: Record "RMAs Package Line")
    begin
        pRMAPackageLine.CalcFields("Posted Quantity");
        pRMAPackageLine."Remaining Quantity" := 0;
        if pRMAPackageLine.Quantity > pRMAPackageLine."Posted Quantity" then
            pRMAPackageLine."Remaining Quantity" := pRMAPackageLine.Quantity - pRMAPackageLine."Posted Quantity";
        pRMAPackageLine.Modify()
    end;
}