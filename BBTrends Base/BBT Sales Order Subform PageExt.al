PageExtension 50119 "BBT Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        modify("Bin Code")
        {
            Visible = true;
        }
        modify(Quantity)
        {
            StyleExpr = ColorTxt;

            trigger OnAfterValidate()
            begin
                UpdateDataMasterBox;
            end;
        }
        modify("Blanket Order No.")
        {
            Caption = 'Blanket Order No.';
        }
        modify("Blanket Order Line No.")
        {
            Caption = 'Blanket Order Line No.';
        }
        modify("Appl.-to Item Entry")
        {
            Caption = 'Appl.-to Item Entry';
        }
        modify("Document No.")
        {
            Caption = 'Document No.';
        }
        modify("Line No.")
        {
            Caption = 'Line No.';
        }
        modify("Requested Delivery Date")
        {
            Visible = false;
        }
        modify("Promised Delivery Date")
        {
            Visible = false;
        }
        modify("Planned Delivery Date")
        {
            Visible = false;
        }
        modify("Planned Shipment Date")
        {
            Visible = false;
        }
        modify("Unit Cost (LCY)")
        {
            Visible = false;
        }
        addafter(Quantity)
        {
            field("Qty cartns "; QtyCartons)
            {
                ApplicationArea = all;
                Caption = 'QtyCartons', Comment = 'ESP="Cajas Master"';
                DecimalPlaces = 0 : 2;
                Editable = false;
                StyleExpr = CartonDec;
            }
        }
        addafter("TotalSalesLine.""Line Amount""")
        {
        }
        addafter("Unit Price")
        {
            field("EDI - Gross unit price"; Rec."EDI - Gross unit price")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("EDI - Line Amount"; Rec."EDI - Line Amount")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("Line No.")
        {
            field("Pallet No."; Rec."Pallet No.")
            {
                ApplicationArea = all;
                Caption = 'Pallet No.';
            }
            field("Packing Unit of Measure"; Rec."Packing Unit of Measure")
            {
                ApplicationArea = all;
            }
            field("Packing Quantity"; Rec."Packing Quantity")
            {
                ApplicationArea = all;
            }
            field("Unit Gross Weight"; Rec."Unit Gross Weight")
            {
                ApplicationArea = all;
            }
            field("Unit Net Weight"; Rec."Unit Net Weight")
            {
                ApplicationArea = all;
            }
        }
    }

    var
        QtyCartons: Decimal;
        CartonDec: Text[30];
        SalesInfoPaneManagement: Codeunit "Sales Info-Pane Management";
        InvNeto: Decimal;
        ColorTxt: Text;

        totalMargin: Decimal;
        SumMarginAmount: Decimal;
        SumCalculatedPrice: Decimal;
        SumQuantity: Decimal;

    trigger OnAfterGetRecord()
    var
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        vTotalAmount: Decimal;
    begin
        rec.ShowShortcutDimCode(ShortcutDimCode);
        UpdateDataMasterBox;

        //>> BBT 29/12/2021. Calculo de la existencia neta en el almacen de la linea del pedido.
        ColorTxt := 'Standard';
        InvNeto := 0;
        IF rec.Type = rec.Type::Item THEN BEGIN
            //   Primero. El cálculo estandard del sistema
            InvNeto := SalesInfoPaneManagement.CalcAvailableInventory(Rec) - SalesInfoPaneManagement.CalcGrossRequirements(Rec);
            //   Segundo. Probamos a calcular la existencia solo con los filtros de almacén y cantidad en pedidos de venta (sin fecha de entrega).
            //  IF (Type = Type::Item) AND rItem.GET("No.") THEN BEGIN
            //    rItem.RESET;
            //    rItem.SETRANGE("Location Filter","Location Code");
            //    rItem.CALCFIELDS(Inventory,"Qty. on Sales Order");
            //
            //    InvNeto := rItem.Inventory - rItem."Qty. on Sales Order";
            //    IF "Qty. per Unit of Measure" <> 0 THEN
            //      InvNeto := ROUND( InvNeto / "Qty. per Unit of Measure" ,0.00001);
            //  END;
        END;
        //<< BBT 29/12/2021
    end;

    local procedure UpdateDataMasterBox()
    var
        ItemUnitofMeasure: Record "Item Unit of Measure";
    begin
        QtyCartons := 0;
        ItemUnitofMeasure.Reset;
        ItemUnitofMeasure.SetRange("Item No.", Rec."No.");
        ItemUnitofMeasure.SetRange(Code, 'CAJA');
        if ItemUnitofMeasure.FindFirst then
            QtyCartons := ROUND(Rec.Quantity / ItemUnitofMeasure."Qty. per Unit of Measure", 0.01)
        else
            QtyCartons := 0;
        CartonDec := 'Standard';
        if QtyCartons <> ROUND(QtyCartons, 1) then CartonDec := 'Ambiguous';
    end;

}
