page 51211 "RMAs Return Item Faxbox"
{
    Caption = 'Sales Return Product', Comment = 'ESP="Producto"';
    Editable = false;
    PageType = CardPart;
    SourceTable = "RMAs Package Line";
    UsageCategory = None;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;

                field("No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; rItem.Description)
                {
                    ApplicationArea = All;
                }
                field(Item_A; ItemQtyA)
                {
                    Caption = 'Quality A', Comment = 'ESP="Calidad A"';
                    ApplicationArea = All;
                }
                field(Item_B; ItemQtyB)
                {
                    Caption = 'Quality B', Comment = 'ESP="Calidad B"';
                    ApplicationArea = All;
                }
                field(Item_C; ItemQtyC)
                {
                    Caption = 'Quality C', Comment = 'ESP="Calidad C"';
                    ApplicationArea = All;
                }
                field(QtyInPackage; QtyInPackage)
                {
                    ApplicationArea = All;
                    Caption = 'Qty in Package', Comment = 'ESP="Cantidad en Bulto"';
                    StyleExpr = ColorTxt;
                }
                field(QtyInReturnOrders; QtyInReturnOrders)
                {
                    ApplicationArea = All;
                    Caption = 'Qty Return Orders', Comment = 'ESP="Cantidad en DVs"';
                    StyleExpr = ColorTxt;
                }
            }
        }
    }
    var
        rItem: Record Item;
        rRMAPackage: Record "RMAs Package";
        rRMAPackageLine: Record "RMAs Package Line";
        rSalesReturnLine: Record "Sales Line";
        rSalesReturnTmp: Record "Sales Header" temporary;

        ItemQtyA: Integer;
        ItemQtyB: Integer;
        ItemQtyC: Integer;
        QtyInReturnOrders: Integer;
        QtyInPackage: Integer;
        ColorTxt: Text;

    trigger OnAfterGetRecord()
    begin
        Clear(ItemQtyA);
        Clear(ItemQtyB);
        Clear(ItemQtyC);
        Clear(QtyInPackage);
        Clear(QtyInReturnOrders);

        rItem.Reset();
        if ritem.get(Rec."Item No.") then;

        // Lineas del bulto con el mismo producto
        rRMAPackageLine.Reset();
        rRMAPackageLine.SetRange("Package No.", Rec."Package No.");
        rRMAPackageLine.SetRange("Item No.", rItem."No.");
        if rRMAPackageLine.FindSet() then
            repeat begin
                QtyInPackage += rRMAPackageLine.Quantity;
                case rRMAPackageLine.Quality of
                    rRMAPackageLine.Quality::A:
                        ItemQtyA += rRMAPackageLine.Quantity;
                    rRMAPackageLine.Quality::B:
                        ItemQtyB += rRMAPackageLine.Quantity;
                    rRMAPackageLine.Quality::C:
                        ItemQtyC += rRMAPackageLine.Quantity;
                end;
            end;
            until rRMAPackageLine.Next() = 0;

        // Lineas de las devoluciónes con el mismo producto
        //>>
        // Guardamos en una temporal las devoluciones del bulto con este artículo.        
        rSalesReturnTmp.Reset();
        rSalesReturnTmp.DeleteAll();

        rRMAPackage.Reset();
        rRMAPackage.SetRange("Package No.", Rec."Package No.");
        if rRMAPackage.FindFirst() then begin
            rRMAPackageLine.Reset();
            rRMAPackageLine.SetRange("Package No.", rRMAPackage."Package No.");
            rRMAPackageLine.SetRange("Item No.", rItem."No.");
            rRMAPackageLine.SetFilter("Return Order No.", '<>%1', '');
            rRMAPackageLine.SetFilter(Quantity, '>%1', 0);
            if rRMAPackageLine.FindSet() then
                repeat
                    rSalesReturnTmp.Reset();
                    rSalesReturnTmp.SetRange("Document Type", rSalesReturnTmp."Document Type"::"Return Order");
                    rSalesReturnTmp.SetRange("No.", rRMAPackageLine."Return Order No.");
                    if not rSalesReturnTmp.FindFirst() then begin
                        rSalesReturnTmp.Init();
                        rSalesReturnTmp."Document Type" := rSalesReturnTmp."Document Type"::"Return Order";
                        rSalesReturnTmp."No." := rRMAPackageLine."Return Order No.";
                        rSalesReturnTmp.Insert();
                    end;
                until rRMAPackageLine.Next() = 0;

            rSalesReturnTmp.Reset();
            if rSalesReturnTmp.FindSet() then
                repeat begin
                    rSalesReturnLine.Reset();
                    rSalesReturnLine.SetRange("Document Type", rSalesReturnLine."Document Type"::"Return Order");
                    rSalesReturnLine.SetRange("Document No.", rSalesReturnTmp."No.");
                    rSalesReturnLine.SetRange(Type, rSalesReturnLine.Type::Item);
                    rSalesReturnLine.SetRange("No.", Rec."Item No.");
                    if rSalesReturnLine.FindSet() then
                        repeat
                            QtyInReturnOrders += (rSalesReturnLine.Quantity - rSalesReturnLine."Return Qty. Received");
                        until rSalesReturnLine.Next() = 0;
                end;
                until rSalesReturnTmp.Next() = 0;
        end;
        //<<
        //>> Color
        ColorTxt := 'Standard';
        if QtyInReturnOrders <> QtyInPackage then
            ColorTxt := 'Unfavorable';
        //<<
    end;
}
