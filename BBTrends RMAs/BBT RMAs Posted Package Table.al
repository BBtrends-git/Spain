table 51209 "RMAs Posted Package"
{
    Caption = 'Posted Packages', Comment = 'ESP="Bultos Registrados Devolucion"';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Posted Package No."; Code[50])
        {
            Caption = 'Posted Package No.', Comment = 'ESP="No. Bulto Registrado"';
            NotBlank = true;
        }
        field(2; "Posted No."; Integer)
        {
            Caption = 'Posted No.', Comment = 'ESP="No. Registro"';
            NotBlank = true;
        }
        field(3; "Posted Date"; date)
        {
            Caption = 'Posted Date', Comment = 'ESP="Fecha Registro"';
        }
        field(4; "Package Type"; Enum "RMAs Package Type")
        {
            Caption = 'Package Type', Comment = 'ESP="Tipo de Bulto"';
        }
        field(5; "Numbers Packages"; Integer)
        {
            Caption = 'Numbers of Packages', Comment = 'ESP="Numero de Bultos"';
        }
        field(6; "Return Category"; Text[50])
        {
            Caption = 'Return Category', Comment = 'ESP="Categoria Devolución"';
            TableRelation = "RMAS Auxiliary Table States"."Auxiliary Name" where("Auxiliary Type" = filter("Category"));
        }
        field(7; "Fully Transferred"; Boolean)
        {
            Caption = 'Fully Transferred', Comment = 'ESP="Totalmente Transferido"';
        }
    }
    keys
    {
        key(Key1; "Posted Package No.", "Posted No.")
        {
            Clustered = true;
        }
    }
    procedure ManageRMAPostedPackage(VAR pRMAPostedPackage: Record "RMAs Posted Package"; pRMAPackage: Record "RMAs Package"): Boolean
    var
        Error01: Label 'The registered package  %1 could not be inserted',
                Comment = 'ESP="No se ha podido dar de alta el bulto registrado %1"';
    begin
        pRMAPostedPackage.Init();
        pRMAPostedPackage."Posted Package No." := pRMAPackage."Package No.";
        pRMAPostedPackage."Posted No." := GetLastPostedPackage(pRMAPostedPackage."Posted Package No.");
        pRMAPostedPackage."Posted Date" := Today;
        pRMAPostedPackage."Package Type" := pRMAPackage."Package Type";
        pRMAPostedPackage."Numbers Packages" := pRMAPackage."Numbers Packages";
        pRMAPostedPackage."Return Category" := pRMAPackage."Return Category";
        pRMAPostedPackage."Fully Transferred" := false;
        if not pRMAPostedPackage.Insert() then
            Error(Error01, pRMAPackage."Package No.");
    end;

    local procedure GetLastPostedPackage(pPostedPackageNo: Code[50]): Integer;
    var
        rRMAPostedPackageAux: Record "RMAs Posted Package";
    begin
        rRMAPostedPackageAux.Reset();
        rRMAPostedPackageAux.SetRange(rRMAPostedPackageAux."Posted Package No.", pPostedPackageNo);
        IF rRMAPostedPackageAux.FindLast() then
            exit(rRMAPostedPackageAux."Posted No." + 1)
        else
            exit(1);
    end;
}