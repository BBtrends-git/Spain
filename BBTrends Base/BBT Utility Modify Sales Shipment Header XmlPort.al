XmlPort 51999 "Modify Sales Shipment Header"
{
    FieldDelimiter = '<None>';
    FieldSeparator = ';';
    Format = VariableText;
    Permissions = tabledata "Sales Shipment Header" = rimd;
    Direction = Import;

    schema
    {
        textelement(root)
        {
            tableelement("Sales Shipment Header"; "Sales Shipment Header")
            {
                XmlName = 'SalesSHipmentHeader';
                UseTemporary = true;

                fieldelement(NoAlbaran; "Sales Shipment Header"."No.")
                { }
                fieldelement(PrintedLabel; "Sales Shipment Header"."Printed Label")
                { }
                fieldelement(TrackingECI; "Sales Shipment Header"."Tracking ECI")
                { }
                fieldelement(ShippingViaAgent; "Sales Shipment Header"."Shipping Via Agent")
                { }
                fieldelement(ShippingViaReference; "Sales Shipment Header"."Shipping Via Reference")
                { }
            }
        }
    }
    var
        rSalesShipmentHeader: Record "Sales Shipment Header";

    trigger OnInitXmlPort()
    begin
        "Sales Shipment Header".DeleteAll();
    end;

    trigger OnPostXmlPort()
    begin
        if "Sales Shipment Header".FindSet() then begin
            repeat
                rSalesShipmentHeader.Reset();
                rSalesShipmentHeader.SetRange("No.", "Sales Shipment Header"."No.");
                if rSalesShipmentHeader.FindFirst() then begin
                    rSalesShipmentHeader."Printed Label" := "Sales Shipment Header"."Printed Label";
                    rSalesShipmentHeader."Tracking ECI" := "Sales Shipment Header"."Tracking ECI";
                    rSalesShipmentHeader."Shipping Via Agent" := "Sales Shipment Header"."Shipping Via Agent";
                    rSalesShipmentHeader."Shipping Via Reference" := "Sales Shipment Header"."Shipping Via Reference";
                    rSalesShipmentHeader.Modify();
                end;
            until "Sales Shipment Header".Next() = 0;
            commit;
        end;
    end;
}


