PageExtension 50218 "BBT Posted Whse. Shipment List" extends "Posted Whse. Shipment List"
{
    actions
    {
        addafter(Card)
        {
            action("Recuperar embalajes")
            {
                ApplicationArea = Basic;
                Caption = 'Recuperar embalajes';
                Visible = false;

                trigger OnAction()
                var
                    PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header";
                    InterfaceSGA: Codeunit 50000;
                begin
                    PostedWhseShipmentHeader.Reset;
                    PostedWhseShipmentHeader.Get(Rec."No.");
                    InterfaceSGA.GetPackagingLines(PostedWhseShipmentHeader);
                end;
            }
        }
    }
}
