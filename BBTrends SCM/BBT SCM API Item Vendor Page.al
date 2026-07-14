page 51255 "SCM API Item Vendor"
{
    Caption = 'SCM Item Vendor';
    //PageType = Card;
    //ApplicationArea = All;
    //UsageCategory = Lists;
    PageType = API;
    APIPublisher = 'bbtrends';
    APIGroup = 'bbtscm';
    APIVersion = 'v2.0';
    EntityName = 'scmitemvendor';
    EntitySetName = 'scmitemvendors';
    SourceTable = Item;
    Editable = false;
    DelayedInsert = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Item"; Rec."No.")
                { }
                field("Vendor"; Rec."Vendor No.")
                { }
                field("Location"; Location)
                { }
                field("LeadTime"; Leadtime)
                { }
                field("AcumulationPeriod"; Rec."Lot Accumulation Period")
                { }
                field("MinimumCoverage"; MinimumCoverage)
                { }
                field("MaximunCoverage"; MaximunCoverage)
                { }
                field("SafetyStock"; Rec."Safety Stock Quantity")
                { }
                field("MaximunInventory"; rec."Maximum Inventory")
                { }
                field("MinimumQuantity"; Rec."Minimum Order Quantity")
                { }
                field("PurchasePrice"; PurchasePrice)
                { }
                field("LotIncrement"; Rec."Order Multiple")
                { }
            }
        }
    }

    Var
        rVendor: Record Vendor;
        rPurchasePrice: Record "Purchase Price";
        cuPurchPrice: Codeunit "Purch. Price Calc. Mgt.";
        rCurrencyRate: Record "Currency Exchange Rate";
        Location: Text[10];
        PurchasePrice: Decimal;
        MinimumCoverage: Text[10];
        MaximunCoverage: Text[10];
        LeadTime: DateFormula;
    //DateFormulaAux: DateFormula;

    trigger OnInit()
    begin
        Rec.SetFilter("Vendor No.", '<>%1', '');
    end;

    trigger OnAfterGetRecord()
    begin
        // Almacen de entrega por defecto del Proveedor
        Clear(Location);
        rVendor.Reset();
        rVendor.SetRange("No.", Rec."Vendor No.");
        if rVendor.FindFirst() then
            Location := Format(rVendor."Location Code");

        // LeadTime
        //clear(DateFormulaAux);
        LeadTime := Rec."Lead Time Calculation";
        //if LeadTime = DateFormulaAux then
        //    LeadTime := rVendor."Lead Time Calculation";

        // Mínima cobertura deseable en ¿ dias ?
        MinimumCoverage := '0D';

        //Máxima cobertura deseable de existencias en ¿ dias ?
        MaximunCoverage := '0D';

        // Precio Compra
        Clear(PurchasePrice);
        rPurchasePrice.Reset();
        rPurchasePrice.SetRange("Item No.", Rec."No.");
        rPurchasePrice.SetRange("Vendor No.", Rec."Vendor No.");
        rPurchasePrice.SetRange("Unit of Measure Code", Rec."Base Unit of Measure");
        rPurchasePrice.SetRange("Currency Code", rVendor."Currency Code");
        if rPurchasePrice.FindFirst() then begin
            cuPurchPrice.CalcBestDirectUnitCost(rPurchasePrice);
            PurchasePrice := rPurchasePrice."Direct Unit Cost";
        end;
        If (rVendor."Currency Code" <> 'EUR') and (rVendor."Currency Code" <> '') then
            PurchasePrice := rCurrencyRate.ExchangeAmount(rPurchasePrice."Direct Unit Cost", rvendor."Currency Code", '', Today);

    end;
}