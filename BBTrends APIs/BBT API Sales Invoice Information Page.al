page 51421 "API Sales Invoice Information"
{
    Editable = false;
    PageType = List;
    SourceTable = "Sales Invoice Line";
    SourceTableTemporary = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Document No."; Rec."Document No.")
                {
                    Caption = 'DocumentNo', Comment = 'ESP="NumeroFactura"';
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
                field(FechaFactura; rec."Posting Date")
                {
                    Caption = 'PostingDate', Comment = 'ESP="FechaFactura"';
                }
                field(NumeroPedido; NumeroPedido)
                {
                    Caption = 'OrderNo', Comment = 'ESP="NumeroPedido"';
                }
                field(FechaPedido; FechaPedido)
                {
                    Caption = 'OrderDate', Comment = 'ESP="FechaPedido"';
                }
                field(NumeroEnvio; NumeroEnvio)
                {
                    Caption = 'ShippingNumber', Comment = 'ESP="NumeroEnvio"';
                }
                field(FechaEnvio; FechaEnvio)
                {
                    Caption = 'ShippingDate', Comment = 'ESP="FechaEnvio"';
                }
                field(NumeroAlbaran; NumeroAlbaran)
                {
                    Caption = 'DeliveryNoteNumber', Comment = 'ESP="NumeroAlbaran"';
                }
                field(FechaAlbaran; FechaAlbaran)
                {
                    Caption = 'DeliveryNoteDate', Comment = 'ESP="FechaAlbaran"';
                }
            }
        }
    }
    var
        FechaFactura: Date;
        NumeroPedido: Code[20];
        FechaPedido: Date;
        NumeroEnvio: Code[20];
        FechaEnvio: Date;
        NumeroAlbaran: Code[20];
        FechaAlbaran: Date;


    trigger OnOpenPage()
    var
        rSalesInvoice: Record "Sales Invoice Header";
        rValueEntry: Record "Value Entry";
        rValueEntryAux: Record "Value Entry";
        rCustomer: Record Customer;
        Line: Integer;
        FraAnt: Code[20];
        AlbAnt: Code[20];

    begin
        Clear(Line);
        rec.Init();
        rSalesInvoice.Reset();
        //rSalesInvoice.SetFilter("Posting Date", '%1..%2', DMY2Date(01, 01, 2025), DMY2Date(31, 12, 2025));
        rSalesInvoice.SetFilter("Posting Date", '>%1', CalcDate('-1M', Today));
        if rSalesInvoice.FindSet() then
            repeat
            begin
                //rCustomer.Reset();
                //if rCustomer.get(rSalesInvoice."Bill-to Customer No.") then
                //if rCustomer."National Group" = 'MM' then begin
                Clear(Line);
                Clear(FraAnt);
                Clear(AlbAnt);
                rValueEntry.Reset();
                rValueEntry.SetCurrentKey("Document No.");
                rValueEntry.SetRange("Item Ledger Entry Type", rValueEntry."Item Ledger Entry Type"::Sale);
                rValueEntry.SetRange("Document Type", rValueEntry."Document Type"::"Sales Invoice");
                rValueEntry.SetRange("Document No.", rSalesInvoice."No.");
                if rValueEntry.FindSet() then
                    repeat
                    begin
                        rValueEntryAux.Reset();
                        rValueEntryAux.SetRange("Item Ledger Entry No.", rValueEntry."Item Ledger Entry No.");
                        rValueEntryAux.SetRange("Item Ledger Entry Type", rValueEntryAux."Item Ledger Entry Type"::Sale);
                        rValueEntryAux.SetRange("Document Type", rValueEntryAux."Document Type"::"Sales Shipment");
                        if rValueEntryAux.FindFirst() then begin
                            if (rValueEntry."Document No." <> FraAnt) and
                                (rValueEntryAux."Document No." <> AlbAnt) then begin
                                Line += 1;
                                rec.Init();
                                rec.Validate("Document No.", rValueEntry."Document No.");
                                rec.Validate("Posting Date", rValueEntry."Document Date");
                                rec.Validate("Line No.", Line);
                                rec.Validate("Shipment No.", rValueEntryAux."Document No.");
                                rec.Insert();

                                AlbAnt := rValueEntryAux."Document No.";
                                FraAnt := rValueEntry."Document No.";
                            end;
                        end;
                    end;
                    until rValueEntry.Next = 0;
                //end;
            end;
            until rSalesInvoice.Next = 0;
    end;

    trigger OnAfterGetRecord()
    var
        rSalesShipment: Record "Sales Shipment Header";
        rSalesHeader: Record "Sales Header";
        rPostedWhseShipment: Record "Posted Whse. Shipment Header";
    begin
        Clear(FechaFactura);
        Clear(NumeroPedido);
        Clear(FechaPedido);
        Clear(NumeroEnvio);
        Clear(FechaEnvio);
        Clear(NumeroAlbaran);
        clear(FechaAlbaran);

        rSalesShipment.Reset();
        rSalesShipment.SetRange("No.", rec."Shipment No.");
        if rSalesShipment.FindFirst() then begin
            rSalesShipment.CalcFields("Warehose Ship No.");
            NumeroAlbaran := rSalesShipment."No.";
            FechaAlbaran := rSalesShipment."Posting Date";
            if rSalesShipment."Order No." <> '' then begin
                rSalesHeader.Reset();
                rSalesHeader.SetRange("Document Type", rSalesHeader."Document Type"::Order);
                rSalesHeader.SetRange("No.", rSalesShipment."Order No.");
                if rSalesHeader.FindFirst() then begin
                    NumeroPedido := rSalesHeader."No.";
                    FechaPedido := rSalesHeader."Order Date";
                end;
            end;
            if rSalesShipment."Warehose Ship No." <> '' then begin
                rPostedWhseShipment.Reset();
                rPostedWhseShipment.SetRange("Whse. Shipment No.", rSalesShipment."Warehose Ship No.");
                if rPostedWhseShipment.FindFirst() then begin
                    NumeroEnvio := rPostedWhseShipment."Whse. Shipment No.";
                    FechaEnvio := rPostedWhseShipment."Posting Date";
                end;
            end;
        end;
    end;
}