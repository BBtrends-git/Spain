Page 50008 "Transport Shipment List"
{
    Caption = 'Transport Shipment', comment = 'ESP="Albaranes de transporte"';
    CardPageID = "Transport Shipment";
    Editable = false;
    PageType = List;
    SourceTable = "Transport Shipment";
    UsageCategory = Documents;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Shipment No."; Rec."Shipment No.")
                {
                    ApplicationArea = Basic;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = Basic;
                }
                field("Transport Date"; Rec."Transport Date")
                {
                    ApplicationArea = Basic;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shipping Agent Name"; Rec."Shipping Agent Name")
                {
                    ApplicationArea = Basic;
                }
                field("Vehicle Registration No."; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                }
                field("Total Packages"; Rec."Total Packages")
                {
                    ApplicationArea = Basic;
                }
                field("Total Weight"; Rec."Total Weight")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1100234011; Notes)
            {
                Visible = false;
            }
            systempart(Control1100234012; Links)
            {
                Visible = false;
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
                Caption = 'Print', comment = 'ESP="&Imprimir"';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    TransportShipment: Record "Transport Shipment";
                begin
                    CurrPage.SetSelectionFilter(TransportShipment);
                    Report.RunModal(Report::"Transport Shipment", true, false, TransportShipment);
                end;
            }
            action("Create Carrier Shipment")
            {
                ApplicationArea = Basic;
                Caption = 'Create Carrier Shipment', comment = 'ESP="Crear albarán transportista"';
                Image = PostedOrder;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = Report "Create Transport Shipments";
            }
            action("CMR - Transport Notes")
            {
                ApplicationArea = Basic;
                Caption = 'CMR - Transport Notes', comment = 'ESP="CMR - Albaranes de transporte"';
                Image = Track;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    TransportShipment: Record "Transport Shipment";
                    repLTransportShipment: Report "Transport Shipment";
                begin
                    TransportShipment.Reset();
                    TransportShipment.SetRange("Shipment No.", Rec."Shipment No.");
                    TransportShipment.SetRange("Shipment Date", Rec."Shipment Date");
                    TransportShipment.SetRange("Transport Date", Rec."Transport Date");
                    TransportShipment.SetRange("Shipping Agent Code", Rec."Shipping Agent Code");
                    Clear(repLTransportShipment);
                    repLTransportShipment.SetTableView(TransportShipment);
                    repLTransportShipment.RunModal();
                end;
            }
            action("Export Fichero Transport.")
            {
                ApplicationArea = Basic;
                Caption = 'Export Carrier File', comment = 'ESP="Exportar fichero transportista"';
                Image = ExportFile;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = Report "Export Shipping Agent File";
            }
            action("Shipment Labels")
            {
                ApplicationArea = Basic;
                Caption = 'Shipment Labels', comment = 'ESP="Etiquetas albarán"';
                Image = SendTo;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = Report "Shipment Label";
            }
        }
    }
}
