table 50062 "BBT Residues"
{
    Caption = 'Residues', Comment = 'ESP="Residuos"';
    DataClassification = ToBeClassified;
    LookupPageID = "BBT Residues";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Cód. residuo"';
            NotBlank = true;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name', Comment = 'ESP="Nombre"';
        }
        field(3; Type;Enum "BBT Residues Type")
        {
            Caption = 'Type', Comment = 'ESP="Tipo"';

            trigger OnValidate()
            var
                ItemAttributeValue: Record "BBT Residues Type Value";
                ChangingAttributeTypeErr: Label 'You cannot change the type of residue value ''%1'', because it is either in use or it has predefined values.', Comment = '%1 - arbirtrary text';
            begin
                if xRec.Type <> Type then begin
                    ItemAttributeValue.SetRange(Code, "No.");
                    if not ItemAttributeValue.IsEmpty()then Error(ChangingAttributeTypeErr, "No.");
                end;
            end;
        }
        field(4; "Unit of Measure"; Code[10])
        {
            Caption = 'Unit', Comment = 'ESP="Unidad"';
        }
        field(5; Order; Integer)
        {
            Caption = 'Order', Comment = 'ESP="Orden"';
        }
        field(6; "Show in Declaration"; Boolean)
        {
            Caption = 'Show in Declaration', Comment = 'ESP="Mostrar en declaración residuos"';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        ItemAttributeValue: Record "BBT Residues Type Value";
        ItemResidues: Record "BBT Item Residues";
        CountryResidualCost: Record "BBT Country Residual Cost";
        Text001Err: Label 'You cannot delete residue because it is in use.', Comment = 'ESP="No se puede eliminar el residuo porque está en uso."';
    begin
        ItemResidues.Reset();
        ItemResidues.SetRange("Residue No.", Rec."No.");
        if ItemResidues.FindFirst()then Error(Text001Err);
        ItemAttributeValue.Reset();
        ItemAttributeValue.SetRange("Code", Rec."No.");
        if ItemAttributeValue.FindSet()then ItemAttributeValue.DeleteAll();
        CountryResidualCost.Reset();
        CountryResidualCost.SetRange("Residue Code", Rec."No.");
        if CountryResidualCost.FindSet()then CountryResidualCost.DeleteAll();
    end;
    trigger OnRename()
    var
        ItemAttributeValue: Record "BBT Residues Type Value";
        CountryResidualCost: Record "BBT Country Residual Cost";
    begin
        ItemAttributeValue.SetRange("Code", xRec."No.");
        if ItemAttributeValue.FindSet()then repeat ItemAttributeValue.Rename("No.", ItemAttributeValue.Code);
            until ItemAttributeValue.Next() = 0;
        CountryResidualCost.SetRange("Residue Code", xRec."No.");
        if CountryResidualCost.FindSet()then repeat CountryResidualCost.Rename("No.", CountryResidualCost."Residue Code");
            until CountryResidualCost.Next() = 0;
    end;
}
