table 51210 "RMAs Posted Package Line"
{
    Caption = 'Posted Package Lines', Comment = 'ESP="Lineas Bultos Registrados Devolucion"';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Posted Package No."; Code[50])
        {
            Caption = 'Posted Package No.', Comment = 'ESP="No. Bulto Registrado"';
        }
        field(2; "Posted No."; Integer)
        {
            Caption = 'Posted No.', Comment = 'ESP="No. Registro"';
        }
        field(3; "Posted Package Line"; Integer)
        {
            Caption = 'Posted Package Line', Comment = 'ESP="No. Linea Registrada"';
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.', Comment = 'ESP="No. Producto"';
            TableRelation = Item;
        }
        field(5; "EAN of Unit"; Code[20])
        {
            Caption = 'EAN of Unit', Comment = 'ESP="EAN Unidad"';
            TableRelation = "Item Identifier".Code;
        }
        field(6; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(7; Quantity; Integer)
        {
            Caption = 'Quantity', Comment = 'ESP="Cantidad"';
        }
        field(8; "Lot Number"; Code[50])
        {
            Caption = 'Lot Number', Comment = 'ESP="Número Lote"';
        }
        field(9; Quality; Enum "RMAs Package Quality")
        {
            Caption = 'Quality', Comment = 'ESP="Calidad"';
        }
        field(10; Condition; Enum "RMAs Package Condition")
        {
            Caption = 'Condition', Comment = 'ESP="Estado"';
        }
        field(11; "Return Order No."; Code[20])
        {
            Caption = 'Return Order No.', Comment = 'ESP="No. Devolución"';
            TableRelation = "Sales Header"."No." where("Document Type" = filter("Return Order"));
        }
        field(12; "Return Reason"; Text[50])
        {
            Caption = 'Return Reason', Comment = 'ESP="Motivo Devolución"';
            TableRelation = "RMAS Auxiliary Table States"."Auxiliary Name" where("Auxiliary Type" = filter("Reason"));
        }
        field(13; Incident; Boolean)
        {
            Caption = 'Incident', Comment = 'ESP="Incidencia"';
        }
        field(14; "Incident Reason"; Text[100])
        {
            Caption = 'Incident Reason', Comment = 'ESP="Notas Incidencia"';
        }
        field(15; "Analysis Date"; date)
        {
            Caption = 'Analysis Date', Comment = 'ESP="Fecha Analisis"';
        }
        field(16; "Return Resource"; Text[50])
        {
            Caption = 'Return Operator', Comment = 'ESP="Operador Devolución"';
            TableRelation = "Resource"."No.";
        }
        field(17; "Transferred Quantity"; Integer)
        {
            Caption = 'Transferred Quantity', Comment = 'ESP="Cantidad Transferida"';
            CalcFormula = sum("RMAs Stock Package Line".Quantity
                            where("Original Posted Package No." = field("Posted Package No."),
                                "Original Posted No." = field("Posted No."),
                                "Original Posted Package Line" = field("Posted Package Line"),
                                "Item No." = field("Item No."),
                                "Line transferred" = const(true)));
            FieldClass = FlowField;
            Editable = false;
        }
        field(18; "Fully Transferred"; Boolean)
        {
            Caption = 'Line Transferred', Comment = 'ESP="Línea Transferida"';
            Editable = false;
        }
        field(19; "Adjusted Quantity"; Integer)
        {
            Caption = 'Adjusted Quantity', Comment = 'ESP="Cantidad Ajustada"';
            Editable = false;
        }
    }
    keys
    {
        key(Key1; "Posted Package No.", "Posted No.", "Posted Package Line")
        {
            Clustered = true;
        }
    }
    procedure ManageRMAPostedPackageLine(var pRMAPostedPackage: Record "RMAs Posted Package"; var pRMAPostedPackageLine: Record "RMAs Posted Package Line";
                                         pRMAPackage: Record "RMAs Package"; pRMAPackageLine: Record "RMAs Package Line"; pQuantity: Integer): Boolean
    var
        rRMAPostedPackageAux: Record "RMAs Posted Package";
        Error01: Label 'The registered line package  %1 - %2 - %3 could not be inserted',
                Comment = 'ESP="No se ha podido dar de alta la linea bulto registrado %1 - %2 - %3"';
    begin
        // Si no existe la cabecera del bulto registrado se da de alta
        rRMAPostedPackageAux.Reset();
        rRMAPostedPackageAux.SetRange("Posted Package No.", pRMAPostedPackageLine."Posted Package No.");
        rRMAPostedPackageAux.SetRange("Posted No.", pRMAPostedPackageLine."Posted No.");
        if not rRMAPostedPackageAux.FindFirst() then
            pRMAPostedPackage.ManageRMAPostedPackage(pRMAPostedPackage, pRMAPackage);

        pRMAPostedPackageLine.Init();
        pRMAPostedPackageLine."Posted Package No." := pRMAPostedPackage."Posted Package No.";
        pRMAPostedPackageLine."Posted No." := pRMAPostedPackage."Posted No.";
        pRMAPostedPackageLine."Posted Package Line" := pRMAPackageLine."Package Line";
        pRMAPostedPackageLine."Item No." := pRMAPackageLine."Item No.";
        pRMAPostedPackageLine."EAN of Unit" := pRMAPackageLine."EAN of Unit";
        pRMAPostedPackageLine.Description := pRMAPackageLine.Description;
        pRMAPostedPackageLine.Quality := pRMAPackageLine.Quality;
        pRMAPostedPackageLine."Lot Number" := pRMAPackageLine."Lot Number";
        pRMAPostedPackageLine.Condition := pRMAPackageLine.Condition;
        pRMAPostedPackageLine."Return Order No." := pRMAPackageLine."Return Order No.";
        pRMAPostedPackageLine."Return Reason" := pRMAPackageLine."Return Reason";
        pRMAPostedPackageLine.Incident := pRMAPackageLine."Incident";
        pRMAPostedPackageLine."Incident Reason" := pRMAPackageLine."Incident Reason";
        pRMAPostedPackageLine."Analysis Date" := pRMAPackageLine."Analysis Date";
        pRMAPostedPackageLine."Return Resource" := pRMAPackageLine."Return Resource";
        pRMAPostedPackageLine."Transferred Quantity" := 0;
        pRMAPostedPackageLine."Fully Transferred" := false;
        pRMAPostedPackageLine.Quantity := pQuantity;
        if not pRMAPostedPackageLine.Insert() then
            Error(Error01, pRMAPostedPackage."Posted Package No.", pRMAPostedPackage."Posted No.", pRMAPAckageLine."Package Line");
    end;
    /*
    local procedure GetLastStockPackageLine(pRMAPostedPackage: Record "RMAs Posted Package"): Integer;
    var
        rRMAPostedPackageLine: Record "RMAs Posted Package Line";
    begin
        rRMAPostedPackageLine.Reset();
        rRMAPostedPackageLine.SetRange("Posted Package No.", pRMAPostedPackage."Posted Package No.");
        rRMAPostedPackageLine.SetRange("Posted No.", pRMAPostedPackage."Posted No.");
        IF rRMAPostedPackageLine.FindLast() then
            exit(rRMAPostedPackageLine."Posted Package Line" + 10000)
        else
            exit(10000);
    end;
    */
}