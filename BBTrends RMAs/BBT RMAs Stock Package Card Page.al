Page 51214 "RMAs Stock Package Card"
{
    Caption = 'Stock Package Card', Comment = 'ESP="Bulto a Existencia"';
    PageType = Document;
    SourceTable = "RMAs Stock Package";
    ApplicationArea = All;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ESP="General"';

                field("Package No."; Rec."Package No.")
                {
                    ApplicationArea = All;
                    Editable = SetEditable;
                    Importance = Promoted;
                    ShowMandatory = true;
                    trigger OnValidate()
                    begin
                        Rec.Validate(Quality, Rec.Quality::A);
                        Rec.Location := Rec.GetLocation(Rec.Quality);
                        CurrPage.Update();
                    end;
                }
                field(Quality; Rec.Quality)
                {
                    ApplicationArea = All;
                    Editable = SetEditable;
                    ShowMandatory = true;
                    trigger OnValidate()
                    begin
                        if rRMASetup."Scrap Adjust" and (Rec.Quality = Rec.Quality::C) then
                            Error(Error02)
                        else begin
                            Location := Rec.GetLocation(Rec.Quality);
                            if Location <> '' then begin
                                Rec.Location := Location;
                            end else
                                Error(Error01);
                            CurrPage.Update();
                        end;
                    end;
                }
                field("Return Resource"; Rec."Return Resource")
                {
                    ApplicationArea = All;
                    Editable = SetEditable;
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field(Location; rec.Location)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = false;
                }
                field("Package transferred"; Rec."Package transferred")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part(PackageSelection; "RMAs Stock Package Selection")
            {
                ApplicationArea = All;
                Editable = true;
                Enabled = true;
                SubPageLink = "Package No." = field("Package No.");
                UpdatePropagation = Both;
            }
            part(PackageSubform; "RMAs Stock Package Subform")
            {
                ApplicationArea = All;
                Editable = false;
                Enabled = true;
                SubPageLink = "Package No." = field("Package No.");
                UpdatePropagation = Both;
            }
        }
    }
    actions
    {
        area(navigation)
        {
            action(transfer)
            {
                ApplicationArea = All;
                Caption = 'Generate Transfer', comment = 'ESP="Generar Transferencia"';
                Image = TransferOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = not Rec."Package transferred";

                trigger OnAction()
                var
                    cuRMASManagement: Codeunit "RMAs Management";
                    Text01: Label 'Do you want to create the transfer order?', Comment = 'ESP="¿Desea crear el pedido de transferencia?"';
                    Text02: Label 'Transfer order has been created', Comment = 'ESP="Se ha creado el pedido de transferencia"';
                begin
                    if not Confirm(Text01, false) then exit;
                    cuRMASManagement.TransferStockPackage(Rec);
                    Message(Text02);
                    CurrPage.Update();
                end;
            }
        }
    }

    var
        Location: code[10];
        SetEditable: Boolean;
        rRMASetup: Record "RMAs Setup";
        rRMAStockPackage: Record "RMAs Stock Package";
        rRMAStockPackageLine: Record "RMAs Stock Package Line";
        //rRMAsPackage: Record "RMAs Package";
        //rRMAsPackageLine: Record "RMAs Package Line";
        rRMAsPostedPackage: Record "RMAs Posted Package";
        rRMAsPostedPackageLine: Record "RMAs Posted Package Line";
        rRMAsTransferMatrix: Record "RMAs Package Transfer Matrix";

        Error01: Label 'Quality is a required field', Comment = 'ESP="La calidad es un campo obligatorio"';
        Error02: Label 'Quality C is not permitted', Comment = 'ESP="La calidad C no está permitida"';

    trigger OnDeleteRecord(): Boolean
    begin
        // Líneas detalle
        rRMAStockPackageLine.Reset();
        rRMAStockPackageLine.SetRange("Package No.", Rec."Package No.");
        if rRMAStockPackageLine.FindSet() then
            repeat
                rRMAStockPackageLine.Delete();
            until rRMAStockPackageLine.Next() = 0;

        // Líneas matriz transferencia
        rRMAsTransferMatrix.Reset();
        rRMAsTransferMatrix.SetRange("Package No.", Rec."Package No.");
        if rRMAsTransferMatrix.FindSet() then
            repeat
                rRMAsTransferMatrix.Delete();
            until rRMAsTransferMatrix.Next() = 0;
    end;

    trigger OnOpenPage()
    begin
        SetEditable := false;
    end;

    trigger OnInit()
    begin
        rRMASetup.Reset();
        rRMASetup.Get();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetEditable := true;
    end;

    trigger OnAfterGetRecord()
    begin
        // Reinicializamos la matriz de transferencias.
        EmptyMatrixTable();
        FillMatrixTable();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin

    end;

    local procedure EmptyMatrixTable()
    begin
        rRMAsTransferMatrix.Reset;
        rRMAsTransferMatrix.SetRange("Package No.", rec."Package No.");
        if rRMAsTransferMatrix.FindSet() then begin
            repeat
                rRMAsTransferMatrix.Delete();
            until rRMAsTransferMatrix.Next() = 0;
        end;
    end;

    local procedure FillMatrixTable()
    begin

        rRMAsPostedPackage.Reset();
        if rRMAsPostedPackage.FindSet() then begin
            repeat
            begin
                rRMAsPostedPackageLine.Reset();
                rRMAsPostedPackageLine.SetRange("Posted Package No.", rRMAsPostedPackage."Posted Package No.");
                rRMAsPostedPackageLine.SetRange("Posted No.", rRMAsPostedPackage."Posted No.");
                rRMAsPostedPackageLine.setrange(Quality, Rec.Quality);
                if rRMAsPostedPackageLine.FindSet() then
                    repeat begin
                        rRMAsPostedPackageLine.CalcFields("Transferred Quantity");
                        if (rRMAsPostedPackageLine.Quantity - rRMAsPostedPackageLine."Transferred Quantity") > 0 then
                            rRMAsTransferMatrix.ManageRMATransferMatrix(rRMAsPostedPackageLine, Rec."Package No.");
                    end;
                    until rRMAsPostedPackageLine.Next() = 0;
            end;
            until rRMAsPostedPackage.Next() = 0;
        end;

        rRMAStockPackageLine.Reset();
        rRMAStockPackageLine.SetRange("Package No.", Rec."Package No.");
        if rRMAStockPackageLine.FindSet() then
            repeat begin
                rRMAsTransferMatrix.Reset();
                rRMAsTransferMatrix.SetRange("Package No.", rRMAStockPackageLine."Package No.");
                rRMAsTransferMatrix.SetRange("Original Posted Package No.", rRMAStockPackageLine."Original Posted Package No.");
                rRMAsTransferMatrix.SetRange("Original Posted No.", rRMAStockPackageLine."Original Posted No.");
                rRMAsTransferMatrix.SetRange("Original Posted Package Line", rRMAStockPackageLine."Original Posted Package Line");
                rRMAsTransferMatrix.SetRange("Item No.", rRMAStockPackageLine."Item No.");
                if rRMAsTransferMatrix.FindFirst() then begin
                    rRMAsTransferMatrix."Quantity to Transfer" := rRMAStockPackageLine.Quantity;
                    rRMAsTransferMatrix.Modify();
                end;
            end;
            until rRMAStockPackageLine.Next() = 0;

        rRMAStockPackage.Reset();
        rRMAStockPackage.SetFilter("Package No.", '<>%1', Rec."Package No.");
        rRMAStockPackage.SetRange(Quality, Rec.Quality);
        if rRMAStockPackage.FindSet() then
            repeat begin
                rRMAStockPackageLine.Reset();
                rRMAStockPackageLine.SetRange("Package No.", rRMAStockPackage."Package No.");
                if rRMAStockPackageLine.FindSet() then
                    repeat begin
                        rRMAsTransferMatrix.Reset();
                        rRMAsTransferMatrix.SetRange("Package No.", Rec."Package No.");
                        rRMAsTransferMatrix.SetRange("Original Posted Package No.", rRMAStockPackageLine."Original Posted Package No.");
                        rRMAsTransferMatrix.SetRange("Original Posted No.", rRMAStockPackageLine."Original Posted No.");
                        rRMAsTransferMatrix.SetRange("Original Posted Package Line", rRMAStockPackageLine."Original Posted Package Line");
                        rRMAsTransferMatrix.SetRange("Item No.", rRMAStockPackageLine."Item No.");
                        if rRMAsTransferMatrix.FindFirst() then begin
                            if (rRMAsTransferMatrix.Quantity - rRMAStockPackageLine.Quantity) > 0 then begin
                                rRMAsTransferMatrix.Quantity := rRMAsTransferMatrix.Quantity - rRMAStockPackageLine.Quantity;
                                rRMAsTransferMatrix.Modify();
                            end
                            else // (rRMAsTransferMatrix.Quantity - rRMAStockPackageLine.Quantity) <= 0
                                rRMAsTransferMatrix.Delete();
                        end;
                    end;
                    until rRMAStockPackageLine.Next() = 0;
            end;
            until rRMAStockPackage.Next() = 0;
    end;
}