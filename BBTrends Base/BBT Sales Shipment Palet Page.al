Page 50019 "Sales Shipment Palet"
{
    DelayedInsert = false;
    PageType = List;
    SourceTable = 50009;
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sales Shipment No."; Rec."Sales Shipment No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Palet No."; Rec."Palet No.")
                {
                    ApplicationArea = Basic;
                }
                field("Gross Weight"; Rec."Gross Weight")
                {
                    ApplicationArea = Basic;
                }
                field("Net Weight"; Rec."Net Weight")
                {
                    ApplicationArea = Basic;
                }
                field(Boxes; Rec.Boxes)
                {
                    ApplicationArea = Basic;
                }
                field(Volume; Rec.Volume)
                {
                    ApplicationArea = Basic;
                }
                field("Pallet Weight"; Rec."Pallet Weight")
                {
                    ApplicationArea = Basic;
                    Visible = verCampo;
                }
                field("PB with Pallet"; Rec."PB with Pallet")
                {
                    ApplicationArea = Basic;
                    Visible = VerCampo;
                }
            }
        }
    }
    actions
    {
    }
    trigger OnClosePage()
    var
        _LinPalet: Record 50009;
        _numpalets: Integer;
        _SalesShipLine: Record "Sales Shipment Line";
        _CabAlbaran: Record "Sales Shipment Header";
    begin
    end;
    trigger OnInit()
    var
        rConfAlm: Record "Warehouse Setup";
    begin
        verCampo:=false;
        rConfAlm.Reset();
        if rConfAlm.Get()then if rConfAlm."Pallet Weight" <> 0 then verCampo:=true;
    end;
    trigger OnQueryClosePage(CloseAction: action): Boolean begin
        if SalesShipLine.Get(Rec."Sales Shipment No.", Rec."Sales Shipment Line Number")then begin
            Rec.CalcSums(Boxes);
            if SalesShipLine.Quantity <> Rec.Boxes then if not Confirm('La cantidad en la linea de albarán %1 es distinta de la cantidad en los palets %2.\¿Desea continuar?', true, SalesShipLine.Quantity, Rec.Boxes)then exit(false);
        end;
    end;
    var SalesShipLine: Record "Sales Shipment Line";
    verCampo: Boolean;
}
