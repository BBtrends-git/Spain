Page 50025 "Summary sales shipments"
{
    Caption = 'Summary sales shipments';
    CardPageID = "Posted Sales Shipment";
    Editable = false;
    PageType = List;
    SourceTable = "Sales Shipment Header";
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field("Warehose Ship No."; Rec."Warehose Ship No.")
                {
                    ApplicationArea = Basic;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ApplicationArea = Basic;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to County"; Rec."Ship-to County")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Contact"; ShiptoContactAux)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-to Contact';
                }
                field("Ship-to Phone"; ShiptoPhone)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-to Phone';
                }
                field("Ship-to Email"; ShiptoEmail)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-to Email';
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Basic;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(Reference; Rec.Reference)
                {
                    ApplicationArea = Basic;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("No. Palets"; NumPalets)
                {
                    ApplicationArea = Basic;
                    Caption = 'No. Palets';
                }
                field("No. Bultos."; NumBultos)
                {
                    ApplicationArea = Basic;
                    Caption = 'No. Bultos';
                }
                field("Peso Bruto (Kg)"; PesoBruto)
                {
                    ApplicationArea = Basic;
                    Caption = 'Peso Bruto (Kg)';
                }
                field("Volumen (m3)"; Volumen)
                {
                    ApplicationArea = Basic;
                    Caption = 'Volumen (m3)';
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000022; "Sales Comment Line FactBox")
            {
                SubPageLink = "No."=field("No."), "Document Type"=const(Shipment);
            }
            systempart(Control1000000023; Notes)
            {
            }
        }
    }
    actions
    {
        area(processing)
        {
            action("&Print")
            {
                ApplicationArea = Basic;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    SalesShptHeader: Record "Sales Shipment Header";
                begin
                    CurrPage.SetSelectionFilter(SalesShptHeader);
                    SalesShptHeader.PrintRecords(true);
                end;
            }
            action("&Navigate")
            {
                ApplicationArea = Basic;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
            action("Co&mments")
            {
                ApplicationArea = Basic;
                Caption = 'Co&mments';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Sales Comment Sheet";
                RunPageLink = "Document Type"=const(Shipment), "No."=field("No.");
            }
            action(Pedido)
            {
                ApplicationArea = Basic;
                Image = "Order";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //
                    rSalesHeader.Reset;
                    rSalesHeader.SetRange(rSalesHeader."Document Type", rSalesHeader."document type"::Order);
                    rSalesHeader.SetRange(rSalesHeader."No.", Rec."Order No.");
                    if rSalesHeader.FindFirst then begin
                        Clear(PgOrder);
                        PgOrder.SetTableview(rSalesHeader);
                        PgOrder.Run;
                    end;
                //
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        // Datos de Pesos y Volumenes
        PesoBruto:=0;
        NumPalets:=0;
        Volumen:=0;
        NumBultos:=0;
        rSalesPalet.Reset();
        rSalesPalet.SetRange("Sales Shipment No.", Rec."No.");
        if rSalesPalet.FindSet()then repeat NumPalets:=NumPalets + 1;
                NumBultos:=NumBultos + rSalesPalet.Boxes;
                PesoBruto:=PesoBruto + rSalesPalet."PB with Pallet";
                Volumen:=Volumen + rSalesPalet.Volume;
            until rSalesPalet.Next = 0;
        // Datos del contacto de la dirección de Envío
        ShiptoEmail:='';
        ShiptoPhone:='';
        ShiptoContact:='';
        ShiptoContactAux:='';
        rShiptoAddress.SetRange("Customer No.", Rec."Sell-to Customer No.");
        rShiptoAddress.SetRange(Code, Rec."Ship-to Code");
        if rShiptoAddress.FindFirst then begin
            ShiptoEmail:=rShiptoAddress."E-Mail";
            ShiptoPhone:=rShiptoAddress."Phone No.";
            ShiptoContact:=rShiptoAddress.Contact;
        end;
        ShiptoContactAux:=Rec."Ship-to Contact";
        if ShiptoContactAux = '' then ShiptoContactAux:=ShiptoContact;
    end;
    trigger OnOpenPage()
    begin
        Rec.SetRange(Rec."Document Date", Today);
    end;
    var rSalesHeader: Record "Sales Header";
    PgOrder: Page "Sales Order";
    rSalesPalet: Record 50009;
    PesoBruto: Decimal;
    NumPalets: Decimal;
    NumBultos: Decimal;
    Volumen: Decimal;
    rShiptoAddress: Record "Ship-to Address";
    ShiptoPhone: Text[100];
    ShiptoEmail: Text[100];
    ShiptoContact: Text[100];
    ShiptoContactAux: Text[100];
}
