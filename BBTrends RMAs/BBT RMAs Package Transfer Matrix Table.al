table 51207 "RMAs Package Transfer Matrix"
{
    Caption = 'Package Transfer Matrix', Comment = 'ESP="Matriz de Transferencia de Bultos"';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Package No."; Code[50])
        {
            Caption = 'Destination Package No.', Comment = 'ESP="Bulto Destino"';
        }
        field(2; "Package Line"; Integer)
        {
            Caption = 'Destination Package Line', Comment = 'ESP="Linea Bulto Destino"';
        }
        field(3; "Package Quality"; Enum "RMAs Package Quality")
        {
            Caption = 'Quality', Comment = 'ESP="Calidad"';
        }
        field(4; "Original Posted Package No."; Code[50])
        {
            Caption = 'Original Posted Package No.', Comment = 'ESP="Bulto Registrado Original"';
        }
        field(5; "Original Posted No."; Integer)
        {
            Caption = 'Original Posted No.', Comment = 'ESP="Registro Original"';
        }
        field(6; "Original Posted Package Line"; Integer)
        {
            Caption = 'Original Posted Package Line', Comment = 'ESP="Linea Bulto Registrado Original"';
        }
        field(7; "EAN of Unit"; Code[20])
        {
            Caption = 'EAN of Unit', Comment = 'ESP="EAN Unidad"';
        }
        field(8; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(9; "Item No."; Code[20])
        {
            Caption = 'Item No.', Comment = 'ESP="Producto"';
        }
        field(10; Quantity; Integer)
        {
            Caption = 'Quantity', Comment = 'ESP="Cantidad"';
        }
        field(11; "Quantity to Transfer"; Integer)
        {
            Caption = 'Quantity to Transfer', Comment = 'ESP="Cantidad a Transferir"';
        }
        field(12; Transferred; Boolean)
        {
            Caption = 'Transferred', Comment = 'ESP="Transferido"';
        }
    }
    keys
    {
        key(Key1; "Package No.", "Package Line")
        {
            Clustered = true;
        }
        key(Key2; "Original Posted Package No.", "Original Posted No.", "Original Posted Package Line")
        { }
    }

    procedure ManageRMATransferMatrix(pRMAsPostedPackageLine: Record "RMAs Posted Package Line"; pDestinationPackageNo: Code[50])
    var
        rRMATransferMatrix: Record "RMAs Package Transfer Matrix";

    begin
        //pRMAsPostedPackageLine.CalcFields("Transferred Quantity");

        rRMATransferMatrix.Init();
        rRMATransferMatrix."Package No." := pDestinationPackageNo;
        rRMATransferMatrix."Package Line" := GetLastPackageLine(rRMATransferMatrix."Package No.");
        rRMATransferMatrix."Package Quality" := pRMAsPostedPackageLine.Quality;
        rRMATransferMatrix."Original Posted Package No." := pRMAsPostedPackageLine."Posted Package No.";
        rRMATransferMatrix."Original Posted No." := pRMAsPostedPackageLine."Posted No.";
        rRMATransferMatrix."Original Posted Package Line" := pRMAsPostedPackageLine."Posted Package Line";
        rRMATransferMatrix."Item No." := pRMAsPostedPackageLine."Item No.";
        rRMATransferMatrix.Description := pRMAsPostedPackageLine.Description;
        rRMATransferMatrix."EAN of Unit" := pRMAsPostedPackageLine."EAN of Unit";
        rRMATransferMatrix."Quantity" := pRMAsPostedPackageLine.Quantity; //- pRMAsPostedPackageLine."Transferred Quantity";
        rRMATransferMatrix.Insert;
    end;

    local procedure GetLastPackageLine(pDestinationPackageNo: Code[50]): Integer;
    var
        rRMATransferMatrix: Record "RMAs Package Transfer Matrix";
    begin
        rRMATransferMatrix.Reset();
        rRMATransferMatrix.SetRange("Package No.", pDestinationPackageNo);
        IF rRMATransferMatrix.FindLast() then
            exit(rRMATransferMatrix."Package Line" + 10000)
        else
            exit(10000);
    end;
}