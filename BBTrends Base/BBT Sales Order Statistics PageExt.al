PageExtension 50161 "Sales Order Statistics" extends "Sales Order Statistics"
{
    layout
    {
        addafter("TotalSalesLine[1].""Net Weight""")
        {
            field(Netweight; Netweight)
            {
                ApplicationArea = Basic;
                Caption = 'Peso neto';
                Editable = false;
                Visible = true;
            }
            field(GrossWeight; GrossWeight)
            {
                ApplicationArea = Basic;
                Caption = 'Peso bruto';
                Editable = false;
            }
            field(Volume; Volume)
            {
                ApplicationArea = Basic;
                Caption = 'Volumen';
                Editable = false;
            }
        }
    }
    var
        Netweight: Decimal;
        GrossWeight: Decimal;
        Volume: Decimal;

    trigger OnAfterGetRecord()
    begin
        CalcWeight;
    end;

    local procedure CalcWeight()
    var
        RecSalesLine: Record "Sales Line";
        RecItem: Record Item;
        RecItemUnitofMeasure: Record "Item Unit of Measure";
        RecItemUnitofMeasure2: Record "Item Unit of Measure";
        UnitNr: Decimal;
        BoxNr: Integer;
        BoxDec: Decimal;
    begin
        Netweight := 0;
        GrossWeight := 0;
        Volume := 0;
        RecSalesLine.Reset;
        RecSalesLine.SetRange("Document No.", Rec."No.");
        RecSalesLine.SetRange(Type, RecSalesLine.Type::Item);
        if RecSalesLine.FindSet then
            repeat
                UnitNr := RecSalesLine."Quantity (Base)";
                RecItemUnitofMeasure.Reset;
                RecItemUnitofMeasure.SetRange("Item No.", RecSalesLine."No.");
                RecItemUnitofMeasure.SetRange(Code, 'UNID');
                if RecItemUnitofMeasure.FindFirst then begin
                    RecItemUnitofMeasure2.Reset;
                    RecItemUnitofMeasure2.SetRange("Item No.", RecSalesLine."No.");
                    RecItemUnitofMeasure2.SetRange(Code, 'CAJA');
                    if RecItemUnitofMeasure2.FindFirst then begin
                        BoxDec := RecSalesLine."Quantity (Base)" / RecItemUnitofMeasure2."Qty. per Unit of Measure";
                        BoxNr := ROUND(BoxDec, 1, '<');
                        UnitNr := RecSalesLine."Quantity (Base)" - (RecItemUnitofMeasure2."Qty. per Unit of Measure" * BoxNr);
                        Netweight := Netweight + RecItemUnitofMeasure2.Weight * BoxNr + RecItemUnitofMeasure.Weight * UnitNr;
                        GrossWeight := GrossWeight + RecItemUnitofMeasure2."Gross weight" * BoxNr + RecItemUnitofMeasure."Gross weight" * UnitNr;
                        Volume := Volume + RecItemUnitofMeasure2.Cubage * BoxNr + RecItemUnitofMeasure.Cubage * UnitNr;
                    end
                    else begin
                        Netweight := Netweight + RecItemUnitofMeasure.Weight * UnitNr;
                        GrossWeight := GrossWeight + RecItemUnitofMeasure."Gross weight" * UnitNr;
                        Volume := Volume + RecItemUnitofMeasure.Cubage * UnitNr;
                    end;
                end;
            until RecSalesLine.Next = 0;
    end;
}
