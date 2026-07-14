table 50064 "BBT Item Residues"
{
    Caption = 'BBT Item Residues', Comment = 'ESP="Relación residuos producto"';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.', Comment = 'ESP="Nº producto"';
            TableRelation = Item;
        }
        field(2; "Residue No."; Code[20])
        {
            Caption = 'Residue No.', Comment = 'ESP="Nº residuo"';
            TableRelation = "BBT Residues";

            trigger OnValidate()
            var
                rlResidue: Record "BBT Residues";
            begin
                if rlResidue.Get(Rec."Residue No.") then Rec."Residue Name" := rlResidue.Name;
                if Rec."Residue No." <> xRec."Residue No." then begin
                    Rec."Numeric Value" := 0;
                    Rec."Unit of Measure" := '';
                    Rec."Option Value" := '';
                end;
                if Rec."Residue No." = '' then begin
                    Rec."Residue Name" := '';
                    Rec."Numeric Value" := 0;
                    Rec."Unit of Measure" := '';
                    Rec."Option Value" := '';
                end;
            end;
        }
        field(3; "Numeric Value"; Decimal)
        {
            Caption = 'Numeric Value', Comment = 'ESP="Valor numérico"';

            trigger OnValidate()
            var
                rlResidue: Record "BBT Residues";
            begin
                if rlResidue.Get(Rec."Residue No.") then Rec."Unit of Measure" := rlResidue."Unit of Measure";
            end;
        }
        field(4; "Option Value"; Text[20])
        {
            Caption = 'Option Value', Comment = 'ESP="Valor opción"';
            TableRelation = "BBT Residues Type Value".Value where(Code = field("Residue No."));
        }
        field(5; "Residue Name"; Text[50])
        {
            Caption = 'Name', Comment = 'ESP="Nombre residuo"';
        }
        field(6; "Unit of Measure"; Code[10])
        {
            Caption = 'Unit', Comment = 'ESP="Unidad"';
        }
        field(7; Scrap; Boolean)
        {
            Caption = 'Scrap', Comment = 'ESP="Scrap"';
        }
        field(8; "Country/Region"; Code[10])
        {
            Caption = 'Country/Region', Comment = 'ESP="Código país"';
            TableRelation = "Country/Region";
        }
        field(9; "Scrap Cost"; Decimal)
        {
            Caption = 'Scrap Cost', Comment = 'ESP="Coste scrap"';
            Editable = false;
        }
        field(10; Currency; Code[10])
        {
            Caption = 'Currency', Comment = 'ESP="Divisa"';
            TableRelation = Currency;
        }
    }
    keys
    {
        key(PK; "Item No.", "Residue No.")
        {
            Clustered = true;
        }
    }
}
