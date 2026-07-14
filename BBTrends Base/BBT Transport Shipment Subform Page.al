Page 50007 "Transport Shipment Subform"
{
    Caption = 'Líneas';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Shipment Header";
    SourceTableView = sorting("Transport Shipment No.")where("Transport Shipment No."=filter(>''));
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
                field("Shipment Date"; Rec."Shipment Date")
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
                field("Ship-to County"; Rec."Ship-to County")
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
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                }
                field(Reference; Rec.Reference)
                {
                    ApplicationArea = Basic;
                }
                field("Number of Packages"; Rec."Number of Packages")
                {
                    ApplicationArea = Basic;
                }
                field("Total Gross Weight (Actual)"; Rec."Total Gross Weight (Actual)")
                {
                    ApplicationArea = Basic;
                }
                field("Total Net Weight (Actual)"; Rec."Total Net Weight (Actual)")
                {
                    ApplicationArea = Basic;
                }
                field("Total Volume (Actual)"; Rec."Total Volume (Actual)")
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
            group("&Albaranes")
            {
                Caption = '&Albaranes';

                action(Insert)
                {
                    ApplicationArea = Basic;
                    Caption = 'Insert';
                    Ellipsis = true;
                    Image = TransferToLines;

                    trigger OnAction()
                    begin
                        TransportShipment.InsertShipments(Rec."Transport Shipment No.");
                    end;
                }
                action(Remove)
                {
                    ApplicationArea = Basic;
                    Caption = 'Remove';
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        if Confirm(Text000)then RemoveShipments;
                    end;
                }
            }
            action(View)
            {
                ApplicationArea = Basic;
                Caption = 'Ver';
                Image = View;

                trigger OnAction()
                var
                    ShipmentPage: Page "Posted Sales Shipment";
                begin
                    SalesShipmentHdr.SetRange("No.", Rec."No.");
                    ShipmentPage.SetTableview(SalesShipmentHdr);
                    ShipmentPage.RunModal;
                end;
            }
        }
    }
    var TransportShipment: Record 50003;
    SalesShipmentHdr: Record "Sales Shipment Header";
    Text000: label 'Confirm that you want to delete the selected shipments?';
    local procedure RemoveShipments()
    begin
        CurrPage.SetSelectionFilter(SalesShipmentHdr);
        TransportShipment.RemoveSelectedShipments(SalesShipmentHdr, Rec."Transport Shipment No.");
    end;
}
