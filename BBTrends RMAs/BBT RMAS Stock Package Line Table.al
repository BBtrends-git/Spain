table 51206 "RMAs Stock Package Line"
{
    Caption = 'Stock Package Lines', Comment = 'ESP="Lineas Bultos a Existencia"';
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
        field(3; "Original Posted Package No."; Code[50])
        {
            Caption = 'Original Package No.', Comment = 'ESP="Bulto Original"';
        }
        field(4; "Original Posted No."; Integer)
        {
            Caption = 'Original Package No.', Comment = 'ESP="Bulto Original"';
        }
        field(5; "Original Posted Package Line"; Integer)
        {
            Caption = 'Original Package Line', Comment = 'ESP="Linea Bulto Original"';
        }
        field(6; "Item No."; Code[20])
        {
            Caption = 'Item No.', Comment = 'ESP="No. Producto"';
            TableRelation = Item;
        }
        field(7; "EAN of Unit"; Code[20])
        {
            Caption = 'EAN of Unit', Comment = 'ESP="EAN Unidad"';
            TableRelation = "Item Identifier".Code;
        }
        field(8; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(9; Quantity; Integer)
        {
            Caption = 'Quantity', Comment = 'ESP="Cantidad"';
        }
        field(10; "Line transferred"; Boolean)
        {
            Caption = 'Package Line Transferred', Comment = 'ESP="Línea Bulto Transferida"';
        }
    }
    keys
    {
        key(Key1; "Package No.", "Package Line")
        {
            Clustered = true;
        }
    }

    procedure RenamePackageNo(OldPackageNo: Code[50]; NewPackageNo: Code[50])
    var
        rOldRMAStockPackageLine: Record "RMAs Stock Package Line";
        rNewRMAStockPackageLine: Record "RMAs Stock Package Line";
    begin
        rOldRMAStockPackageLine.Reset();
        rOldRMAStockPackageLine.SetRange("Package No.", OldPackageNo);
        if rOldRMAStockPackageLine.FindSet() then
            repeat begin
                rNewRMAStockPackageLine.Init();
                rNewRMAStockPackageLine := rOldRMAStockPackageLine;
                rNewRMAStockPackageLine."Package No." := NewPackageNo;
                rNewRMAStockPackageLine.Insert();

                rOldRMAStockPackageLine.Delete();
            end;
            until rOldRMAStockPackageLine.Next() = 0;
    end;

    procedure ManageRMAStockPackageLine(pRMAsPackageTransferMatrix: Record "RMAs Package Transfer Matrix"; pDestinationPackageNo: Code[50]; pQuantity: Integer)
    var
        rRMAStockPackageLine: Record "RMAs Stock Package Line";

    begin
        rRMAStockPackageLine.Reset();
        rRMAStockPackageLine.SetRange("Package No.", pDestinationPackageNo);
        rRMAStockPackageLine.SetRange("Original Posted Package No.", pRMAsPackageTransferMatrix."Original Posted Package No.");
        rRMAStockPackageLine.SetRange("Original Posted No.", pRMAsPackageTransferMatrix."Original Posted No.");
        rRMAStockPackageLine.SetRange("Original Posted Package Line", pRMAsPackageTransferMatrix."Original Posted Package Line");
        rRMAStockPackageLine.SetRange("Item No.", pRMAsPackageTransferMatrix."Item No.");
        if rRMAStockPackageLine.FindFirst() then begin
            if pQuantity > 0 then begin
                rRMAStockPackageLine.Quantity := pQuantity;
                rRMAStockPackageLine.Modify();
            end else
                rRMAStockPackageLine.Delete();
        end
        else begin
            rRMAStockPackageLine.Init();
            rRMAStockPackageLine."Package No." := pDestinationPackageNo;
            rRMAStockPackageLine."Package Line" := GetLastStockPackageLine(rRMAStockPackageLine."Package No.");
            rRMAStockPackageLine."Original Posted Package No." := pRMAsPackageTransferMatrix."Original Posted Package No.";
            rRMAStockPackageLine."Original Posted No." := pRMAsPackageTransferMatrix."Original Posted No.";
            rRMAStockPackageLine."Original Posted Package Line" := pRMAsPackageTransferMatrix."Original Posted Package Line";
            rRMAStockPackageLine."Item No." := pRMAsPackageTransferMatrix."Item No.";
            rRMAStockPackageLine."EAN of Unit" := pRMAsPackageTransferMatrix."EAN of Unit";
            rRMAStockPackageLine.Description := pRMAsPackageTransferMatrix."Description";
            rRMAStockPackageLine.Quantity := pQuantity;
            rRMAStockPackageLine.Insert();
        end;
    end;

    local procedure GetLastStockPackageLine(pDestinationPackageNo: Code[50]): Integer;
    var
        rRMAStockPackageLine: Record "RMAs Stock Package Line";
    begin
        rRMAStockPackageLine.Reset();
        rRMAStockPackageLine.SetRange("Package No.", pDestinationPackageNo);
        IF rRMAStockPackageLine.FindLast() then
            exit(rRMAStockPackageLine."Package Line" + 10000)
        else
            exit(10000);
    end;
}