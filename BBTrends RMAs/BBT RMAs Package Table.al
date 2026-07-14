table 51201 "RMAs Package"
{
    Caption = 'Sales Return Packages', Comment = 'ESP="Bultos Devolucion Ventas"';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Package No."; Code[50])
        {
            Caption = 'Package No.', Comment = 'ESP="No. Bulto"';
            NotBlank = true;
        }
        field(2; "Creation Date"; date)
        {
            Caption = 'Creation Date', Comment = 'ESP="Fecha Alta"';
        }
        field(3; "Package Type"; Enum "RMAs Package Type")
        {
            Caption = 'Package Type', Comment = 'ESP="Tipo de Bulto"';
        }
        field(4; "Numbers Packages"; Integer)
        {
            Caption = 'Numbers of Packages', Comment = 'ESP="Numero de Bultos"';
        }
        field(5; "Return Category"; Text[50])
        {
            Caption = 'Return Category', Comment = 'ESP="Categoria Devolución"';
            TableRelation = "RMAS Auxiliary Table States"."Auxiliary Name" where("Auxiliary Type" = filter("Category"));
        }
        field(6; "Package Status"; Enum "RMAs Package Status")
        {
            Caption = 'Package Status', Comment = 'ESP="Estado Bulto"';
        }
        field(7; "Registered Package"; Boolean)
        {
            Caption = 'Registered Package', Comment = 'ESP="Bulto Registrado"';
        }
    }
    keys
    {
        key(Key1; "Package No.")
        {
            Clustered = true;
        }
    }

    trigger OnRename()
    var
        rRMAPackageLine: Record "RMAs Package Line";
    begin
        rRMAPackageLine.RenamePackageNo(xRec."Package No.", Rec."Package No.");
    end;
}