Page 50006 "Transport Shipment"
{
    Caption = 'Transport Shipment', comment = 'ESP="Albarán de transporte"';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = 50003;
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Shipment No."; Rec."Shipment No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Transport Date"; Rec."Transport Date")
                {
                    ApplicationArea = Basic;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
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
            part(Docs; "Transport Shipment Subform")
            {
                SubPageLink = "Transport Shipment No."=FIELD("Shipment No.");
                SubPageView = sorting("Transport Shipment No.");
            }
        }
        area(factboxes)
        {
            systempart(Control1100234010; Notes)
            {
                Visible = false;
            }
            systempart(Control1100234011; Links)
            {
                Visible = false;
            }
        }
    }
    actions
    {
        area(processing)
        {
            action("&Imprimir")
            {
                ApplicationArea = Basic;
                Caption = '&Imprimir';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    TransportShipment: Record 50003;
                begin
                    CurrPage.SetSelectionFilter(TransportShipment);
                //REVISAR Report.RunModal(Report::"Transport Shipment", true, false, TransportShipment);
                end;
            }
        }
    }
}
