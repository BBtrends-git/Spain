PageExtension 50160 "BBT Sales Shipment Statistics" extends "Sales Shipment Statistics"
{
    layout
    {
        modify(LineQty)
        {
            Visible = false;
        }
        modify(TotalParcels)
        {
            Visible = false;
        }
        modify(TotalNetWeight)
        {
            Visible = false;
        }
        modify(TotalGrossWeight)
        {
            Visible = false;
        }

        modify(TotalVolume)
        {
            Visible = false;
        }
        addbefore(LineQty)
        {
            field(TotalLineQtyNw; TotalLineQtyNw)
            {
                Caption = 'Total Quantity', Comment = 'ESP="Cantidad Total"';
                ApplicationArea = Basic;
                Visible = true;
            }
            field(TotalParcelsNw; TotalParcelsNw)
            {
                Caption = 'Total Cartons', Comment = 'ESP="Total Cajas"';
                ApplicationArea = Basic;
                Visible = true;
            }
            field(TotalVolumeNw; TotalVolumeNw)
            {
                Caption = 'Total Volume', Comment = 'ESP="Volumen Total"';
                ApplicationArea = Basic;
                Visible = true;
            }
            field(TotalGrossWeightNw; TotalGrossWeightNw)
            {
                Caption = 'Total Gross Weigth', Comment = 'ESP="Total Peso Bruto"';
                ApplicationArea = Basic;
                Visible = true;
            }
            field(TotalNetWeightNw; TotalNetWeightNw)
            {
                Caption = 'Total Net Weigth', Comment = 'ESP="Total Peso Neto"';
                ApplicationArea = Basic;
                Visible = true;
            }
        }
    }
    var
        TotalNetWeightNw: Decimal;
        TotalGrossWeightNw: Decimal;
        TotalVolumeNw: Decimal;
        TotalParcelsNw: Decimal;
        TotalLineQtyNw: Decimal;
        rSalesShptLine: Record "Sales Shipment Line";

    trigger OnAfterGetRecord()
    begin

        CalcWeight_New;

    end;

    local procedure CalcWeight_New()
    var
        NW: Decimal;
        GW: Decimal;
        CBM: Decimal;
        TLQ: decimal;
        TP: decimal;
        UnitNr: Decimal;
        UnitBase: Decimal;
        BoxDec: Decimal;
        BoxNr: Decimal;

        rItem: record "Item";
        rItemUnitofMeasure: Record "Item Unit of Measure";
        rItemUnitofMeasureCJ: Record "Item Unit of Measure";

    begin

        clear(NW);
        clear(GW);
        clear(CBM);
        clear(TLQ);
        clear(TP);
        clear(UnitNr);
        clear(UnitBase);

        rSalesShptLine.Reset;
        rSalesShptLine.SetRange("Document No.", Rec."No.");
        rSalesShptLine.SetRange(Type, rSalesShptLine.Type::Item);
        if rSalesShptLine.FindSet then
            repeat
                TLQ := TLQ + rSalesShptLine.Quantity;

                BoxDec := 0;
                UnitNr := 0;
                rItem.Reset();
                rItem.SetRange("No.", rSalesShptLine."No.");
                if rItem.findfirst() then;
                rItemUnitofMeasure.Reset();
                rItemUnitofMeasure.Setrange("Item No.", rSalesShptLine."No.");
                rItemUnitofMeasure.SETRANGE(Code, rItem."Base Unit of Measure");
                IF rItemUnitofMeasure.FINDFIRST THEN BEGIN
                    UnitBase := rSalesShptLine."Quantity (Base)";
                    rItemUnitofMeasureCJ.RESET;
                    rItemUnitofMeasureCJ.SETRANGE("Item No.", rSalesShptLine."No.");
                    rItemUnitofMeasureCJ.SETRANGE(Code, 'CAJA');    // Caja Master de Producto
                    IF rItemUnitofMeasureCJ.FINDFIRST THEN BEGIN
                        BoxDec := rSalesShptLine."Quantity (Base)" / rItemUnitofMeasureCJ."Qty. per Unit of Measure";
                        BoxNr := ROUND(BoxDec, 1, '<');
                        UnitNr := rSalesShptLine."Quantity (Base)" - (rItemUnitofMeasureCJ."Qty. per Unit of Measure" * BoxNr);
                        //>> Si no tiene valores la CAJA usamos los de la UNID * cantidad por caja.
                        IF rItemUnitofMeasureCJ.Weight > 0 THEN
                            NW := NW + ROUND(rItemUnitofMeasureCJ.Weight * BoxNr + rItemUnitofMeasure.Weight * UnitNr, 0.01)
                        ELSE
                            NW := NW + ROUND(rItemUnitofMeasure.Weight * UnitBase, 0.01);
                        IF rItemUnitofMeasureCJ."Gross weight" > 0 THEN
                            GW := GW + ROUND(rItemUnitofMeasureCJ."Gross weight" * BoxNr + rItemUnitofMeasure."Gross weight" * UnitNr, 0.01)
                        ELSE
                            GW := GW + ROUND(rItemUnitofMeasure."Gross weight" * UnitBase, 0.01);
                        IF rItemUnitofMeasureCJ.Cubage > 0 THEN
                            CBM := CBM + ROUND(rItemUnitofMeasureCJ.Cubage * BoxNr + rItemUnitofMeasure.Cubage * UnitNr, 0.01)
                        ELSE
                            CBM := CBM + ROUND(rItemUnitofMeasure.Cubage * UnitBase, 0.01);
                    END ELSE BEGIN
                        BoxNr := rSalesShptLine.Quantity;
                        NW := NW + ROUND(rItemUnitofMeasure.Weight * UnitBase, 0.01);
                        GW := GW + ROUND(rItemUnitofMeasure."Gross weight" * UnitBase, 0.01);
                        CBM := CBM + ROUND(rItemUnitofMeasure.Cubage * UnitBase, 0.01);
                    END;
                END;
                TP := TP + BoxNr
            until rSalesShptLine.Next = 0;

        TotalVolumeNw := CBM;
        TotalLineQtyNw := TLQ;
        TotalParcelsNw := TP;
        TotalNetWeightNw := NW;
        TotalGrossWeightNw := GW;
    end;
}
