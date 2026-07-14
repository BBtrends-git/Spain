codeunit 50033 "Combine Shipments Events"
{
    [EventSubscriber(ObjectType::Report, Report::"Combine Shipments", 'OnAfterShouldFinalizeSalesInvHeader', '', true, true)]
    local procedure "Combine Shipments_OnAfterShouldFinalizeSalesInvHeader"(var SalesOrderHeader: Record "Sales Header"; SalesHeader: Record "Sales Header"; var Finalize: Boolean; SalesShipmentLine: Record "Sales Shipment Line")
    var
        SalesLine: Record "Sales Line";
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        Clear(SalesShipmentHeader);
        SalesShipmentHeader.SetRange("No.", SalesShipmentLine."Document No.");
        IF SalesShipmentLine.FindFirst() then begin
            SalesLine.Reset();
            SalesLine.SetRange("Document Type", SalesLine."Document Type"::Invoice);
            SalesLine.SetRange("Shipment No.", SalesShipmentHeader."No.");
            Finalize := (SalesOrderHeader."Sell-to Customer No." <> SalesHeader."Sell-to Customer No.") or
                    (SalesOrderHeader."Bill-to Customer No." <> SalesHeader."Bill-to Customer No.") or
                    (SalesOrderHeader."Currency Code" <> SalesHeader."Currency Code") or
                    (SalesOrderHeader."EU 3-Party Trade" <> SalesHeader."EU 3-Party Trade") or
                    (SalesOrderHeader."Dimension Set ID" <> SalesHeader."Dimension Set ID") or
                    //(SalesOrderHeader."Journal Templ. Name" <> SalesHeader."Journal Templ. Name") or
                    (not SalesLine.FindFirst());
        end;
    end;
}
