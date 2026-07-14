Page 50049 "Sales Return Lines"
{
    Caption = 'Sales Return Lines';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Sales Line";
    SourceTableView = where(Type = const(Item), "Document Type" = filter("Return Order" | "Credit Memo"));
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Source Document"; 'Sales Return')
                {
                    ApplicationArea = Basic;
                    Caption = 'Source Document';
                }
                field("Source Nr."; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source No.';
                }
                field("Nº última recep. devol."; SalesHeader."Last Return Receipt No.")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date"; SalesHeader."Posting Date")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        SalesHeader2.Reset;
                        SalesHeader2.SetRange("Document Type", Rec."Document Type");
                        SalesHeader2.SetRange("No.", Rec."Document No.");
                        if SalesHeader2.FindFirst then begin
                            SalesHeader2.Validate("Posting Date", SalesHeader."Posting Date");
                            SalesHeader2.Modify;
                        end;
                        CurrPage.Update;
                    end;
                }
                field("Fecha pedido"; SalesHeader."Order Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Fecha pedido';
                }
                field("Fecha entrega requerida"; SalesHeader."Requested Delivery Date")
                {
                    ApplicationArea = Basic;
                }
                field(Estado; SalesHeader.Status)
                {
                    ApplicationArea = Basic;
                }
                field("partner Nr"; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Partner No.';
                }
                field("partner name."; SalesHeader."Ship-to Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Partner Name';
                }
                field("Item No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item No.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("Return Qty. to Receive"; Rec."Return Qty. to Receive")
                {
                    ApplicationArea = Basic;
                }
                field("Net Unit Price"; Rec."SMG Net Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field("Imprte dev. a recibir"; Rec."SMG Net Unit Price" * Rec."Return Qty. to Receive")
                {
                    ApplicationArea = Basic;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field("Qty cartns "; QtyCartons)
                {
                    ApplicationArea = Basic;
                    Caption = 'QtyCartons';
                }
                field(EAN13; ItemIdentifier.Code)
                {
                    ApplicationArea = Basic;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("Due Date"; SalesHeader."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(Adresss; SalesHeader."Ship-to Address" + ' ' + SalesHeader."Ship-to Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(City; SalesHeader."Ship-to City")
                {
                    ApplicationArea = Basic;
                }
                field(Contact; SalesHeader."Ship-to Contact")
                {
                    ApplicationArea = Basic;
                }
                field(Referencia; SalesHeader.Reference)
                {
                    ApplicationArea = Basic;
                }
                field("Phone Numb"; Customer."Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(Country; SalesHeader."Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
                field("ZIP Code"; SalesHeader."Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(Province; SalesHeader."Ship-to County")
                {
                    ApplicationArea = Basic;
                }
                field("E-mail"; Customer."E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field("Cód. transportista"; SalesHeader."Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Gross Weight"; Rec."Unit Gross Weight")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Volume"; Rec."Unit Volume")
                {
                    ApplicationArea = Basic;
                }
                field("Gross Weight"; Rec."Gross Weight")
                {
                    ApplicationArea = Basic;
                }
                field("Nº documento externo"; SalesHeader."External Document No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action("Export to File")
            {
                ApplicationArea = Basic;
                Caption = 'Export to File';
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
            }
            action("Show Return")
            {
                ApplicationArea = Basic;
                Caption = 'Show Return';
                Image = View;
                Promoted = true;
                RunObject = Page "Sales Return Order";
                RunPageLink = "Document Type" = field("Document Type"), "No." = field("Document No.");

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SalesShipmentHeader: Record "Sales Shipment Header";
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                begin
                end;
            }
            action("Receive Lines")
            {
                ApplicationArea = Basic;
                Caption = 'Receive Lines';
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = true;

                trigger OnAction()
                begin
                    ReceiveLines;
                end;
            }
            action("Cambiar almacén")
            {
                ApplicationArea = Basic;
                Caption = 'Cambiar almacén';

                trigger OnAction()
                var
                    Location: Record Location;
                    SalesHeader: Record "Sales Header";
                    SalesLine: Record "Sales Line";
                    ReleaseSalesDocument: Codeunit "Release Sales Document";
                    NeedsReopen: Boolean;
                begin
                    if not Confirm('Desea cambiar el código de almacén?') then Error('');
                    Location.Reset;
                    if Page.RunModal(0, Location) = Action::LookupOK then begin
                        Clear(SalesLine);
                        CurrPage.SetSelectionFilter(SalesLine);
                        if not SalesLine.FindSet then Error('Debe seleccionar líneas válidas');
                        repeat
                            if SalesLine."Return Qty. to Receive" <> 0 then begin
                                oldprice := Rec."Unit Price";
                                SalesHeader.Reset;
                                SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
                                NeedsReopen := SalesHeader.Status <> SalesHeader.Status::Open;
                                if NeedsReopen then ReleaseSalesDocument.PerformManualReopen(SalesHeader);
                                SalesLine.Validate("Location Code", Location.Code);
                                SalesLine.Validate("Unit Price", oldprice);
                                SalesLine.Modify;
                                if NeedsReopen then ReleaseSalesDocument.PerformManualRelease(SalesHeader);
                            end;
                        until SalesLine.Next = 0;
                    end;
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Customer."E-Mail" := '';
        Customer."Phone No." := '';
        UpdateData;
    end;

    var
        SalesHeader: Record "Sales Header";
        QtyCartons: Decimal;
        ItemUnitofMeasure: Record "Item Unit of Measure";
        Customer: Record Customer;
        SalesLine: Record "Sales Line";
        ItemIdentifier: Record "Item Identifier";
        SalesHeader2: Record "Sales Header";
        oldprice: Decimal;

    local procedure UpdateData()
    begin
        SalesHeader.SetRange(SalesHeader."No.", Rec."Document No.");
        if SalesHeader.FindFirst then;
        ItemUnitofMeasure.Reset;
        ItemUnitofMeasure.SetRange("Item No.", Rec."No.");
        ItemUnitofMeasure.SetRange(Code, 'BOX');
        if ItemUnitofMeasure.FindFirst then
            QtyCartons := ROUND(Rec."Return Qty. to Receive" / ItemUnitofMeasure."Qty. per Unit of Measure")
        else
            QtyCartons := 0;
        ItemIdentifier.Reset;
        ItemIdentifier.SetRange("Item No.", Rec."No.");
        ItemIdentifier.SetRange("Unit of Measure Code", 'UNID');
        //ItemIdentifier.SETRANGE(ItemCrossReference."Cross-Reference Type",ItemCrossReference."Cross-Reference Type"::"Bar Code");
        if ItemIdentifier.FindFirst then;
        Customer.Reset;
        Customer.SetRange("No.", SalesHeader."Ship-to Code");
        if Customer.FindFirst then;
    end;

    local procedure ReceiveLines()
    var
        SalesLine: Record "Sales Line";
        TempSalesLine: Record "Sales Line" temporary;
        SalesHeader: Record "Sales Header";
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        OrderNo: Code[20];
        MultipleOrdersErr: label 'You cannot select lines from multiple orders at the same time. Select lines from one order only to continue';
        NoLinesToPostErr: label 'There is nothing to post';
        ContinueMsg: label 'Do you wish to continue with posting?';
        OrdersPosted: label 'Order %1 posted';
    begin
        //ERROR('');
        if not Confirm(ContinueMsg) then Error('');
        Clear(SalesLine);
        if not TempSalesLine.IsTemporary then Error('Unknown error. Contact your system administrator');
        TempSalesLine.Reset;
        TempSalesLine.DeleteAll(false);
        CurrPage.SetSelectionFilter(SalesLine);
        SalesLine.SetFilter("Return Qty. to Receive", '<>0');
        if not SalesLine.FindSet then Error(NoLinesToPostErr);
        repeat
            if OrderNo = '' then OrderNo := SalesLine."Document No.";
            if OrderNo <> SalesLine."Document No." then Error(MultipleOrdersErr);
            Clear(TempSalesLine);
            TempSalesLine := SalesLine;
            TempSalesLine.Insert(false);
        until SalesLine.Next = 0;
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", TempSalesLine."Document Type");
        SalesLine.SetRange("Document No.", TempSalesLine."Document No.");
        SalesLine.FindSet;
        repeat
            SalesHeader.Reset;
            SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
            if SalesHeader.Status <> SalesHeader.Status::Open then ReleaseSalesDocument.PerformManualReopen(SalesHeader);
            SalesLine.Validate("Return Qty. to Receive", 0);
            SalesLine.Modify;
        until SalesLine.Next = 0;
        TempSalesLine.Reset;
        TempSalesLine.FindSet;
        repeat
            SalesLine.Reset;
            SalesLine.Get(TempSalesLine."Document Type", TempSalesLine."Document No.", TempSalesLine."Line No.");
            SalesLine.Validate("Return Qty. to Receive", TempSalesLine."Return Qty. to Receive");
            SalesLine.Modify;
        until TempSalesLine.Next = 0;
        SalesHeader.Ship := false;
        SalesHeader.Invoice := false;
        SalesHeader.Receive := true;
        Codeunit.Run(Codeunit::"Sales-Post", SalesHeader);
        Message(StrSubstNo(OrdersPosted, SalesHeader."No."));
    end;
}
