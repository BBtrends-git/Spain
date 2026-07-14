table 51205 "RMAs Stock Package"
{
    Caption = 'Stock Packages', Comment = 'ESP="Bultos a Existencia"';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Package No."; Code[50])
        {
            Caption = 'Package No.', Comment = 'ESP="No. Bulto"';
            NotBlank = true;
        }
        field(2; Quality; Enum "RMAs Package Quality")
        {
            Caption = 'Quality', Comment = 'ESP="Calidad"';
        }
        field(3; Location; Code[10])
        {
            Caption = 'Location', Comment = 'ESP="Almacén"';
        }
        field(4; "Package transferred"; Boolean)
        {
            Caption = 'Package transferred', Comment = 'ESP="Bulto Transferido"';
        }
        field(5; "Transfer Order"; Code[20])
        {
            Caption = 'Transfer Order', Comment = 'ESP="Pedido Tranferencia"';
        }
        field(6; "Return Resource"; Code[20])
        {
            Caption = 'Return Operator', Comment = 'ESP="Operador Devolución"';
            TableRelation = "Resource"."No.";
        }
    }
    keys
    {
        key(Key1; "Package No.")
        {
            Clustered = true;
        }
    }

    var
        rRMASetup: Record "RMAs Setup";
        rRMAStockPackage: Record "RMAs Stock Package";

    trigger OnRename()
    var
        rRMAStockPackageLine: Record "RMAs Stock Package Line";
    begin
        rRMAStockPackageLine.RenamePackageNo(xRec."Package No.", Rec."Package No.");
    end;

    procedure GetLocation(pQuality: Enum "RMAs Package Quality"): Code[10]
    Var
        Location: code[10];
    begin
        rRMASetup.Reset();
        rRMASetup.Get();

        case pQuality of
            rRMAStockPackage.Quality::A:
                begin
                    rRMASetup.TestField("Warehouse Quality A");
                    Location := rRMASetup."Warehouse Quality A";
                end;

            rRMAStockPackage.Quality::B:
                begin
                    rRMASetup.TestField("Warehouse Quality B");
                    Location := rRMASetup."Warehouse Quality B";
                end;
            rRMAStockPackage.Quality::C:
                begin
                    if rRMASetup."Scrap Adjust" = false then begin
                        rRMASetup.TestField("Warehouse Quality C");
                        Location := rRMASetup."Warehouse Quality B";
                    end
                    else
                        clear(Location);
                end;
        end;
        exit(Location);
    end;
}