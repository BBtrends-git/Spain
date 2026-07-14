PageExtension 50132 "BBT Posted Sales Shipment" extends "Posted Sales Shipment"
{
    layout
    {
        modify("Ship-to Address")
        {
            Editable = false;
        }
        modify("Ship-to Address 2")
        {
            Editable = false;
        }
        addafter("Salesperson Code")
        {
            field("RecPales.PesoBruto(""No."")"; RecPales.PesoBruto(Rec."No."))
            {
                ApplicationArea = Basic;
                Caption = 'Gross Weight';
                Editable = false;
            }
            field("RecPales.PesoNeto(""No."")"; RecPales.PesoNeto(Rec."No."))
            {
                ApplicationArea = Basic;
                Caption = 'Unit Net Weight';
                Editable = false;
            }
            field("RecPales.Cajas(""No."")"; RecPales.Cajas(Rec."No."))
            {
                ApplicationArea = Basic;
                Caption = 'Total Boxes';
                Editable = false;
            }
            field("RecPales.Palets(""No."")"; RecPales.Palets(Rec."No."))
            {
                ApplicationArea = Basic;
                Caption = 'Total Palets';
                Editable = false;
            }
            // field("Warehose Ship No.2"; Rec."Warehose Ship No.2")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the Warehouse Ship No. field.';
            //     Visible = false;
            // }
        }
        //>> BBT. 16/03/2026. Implantación de la extensión SMG.
        /*
        addafter("Shortcut Dimension 2 Code")
        {
            field("Purchase Group"; Rec."Purchase Group")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
        }
        */
        //<<
        addafter("Shipment Date")
        {
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
            field("Number of Packages"; Rec."Number of Packages")
            {
                ApplicationArea = Basic;
            }
            field(Reference; Rec.Reference)
            {
                ApplicationArea = Basic;
            }
            field("Request delivery appointment"; Rec."Request delivery appointment")
            {
                ApplicationArea = All;
            }
            field("Logistics conditions"; Rec."Logistics conditions")
            {
                ApplicationArea = All;
                MultiLine = true;
            }
        }
        addafter("Order No.")
        {
            field("Warehose Ship No."; Rec."Warehose Ship No.")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter(PrintCertificateofSupply)
        {
            separator(Action1100234001)
            {
            }
            action(PackingList)
            {
                ApplicationArea = Basic;
                Caption = 'Packing List';
                Ellipsis = true;
                Image = PrintReport;

                trigger OnAction()
                var
                    SalesShptHeader: Record "Sales Shipment Header";
                    WareHouseSetup: Record "Warehouse Setup";
                begin
                    CurrPage.SetSelectionFilter(SalesShptHeader);
                    WareHouseSetup.Get;
                    WareHouseSetup.TestField("Packing report");
                    Report.RunModal(WareHouseSetup."Packing report", true, false, SalesShptHeader);
                end;
            }
            action(PackingPlt)
            {
                ApplicationArea = Basic;
                Caption = 'Packing Palets';
                Image = PrintReport;

                trigger OnAction()
                var
                    SalesShptHeader: Record "Sales Shipment Header";
                begin
                    CurrPage.SetSelectionFilter(SalesShptHeader);
                    Report.RunModal(Report::"Packing List Palet", true, false, SalesShptHeader);
                end;
            }
            action(ShipmentLabel)
            {
                ApplicationArea = Basic;
                Caption = 'Shipment Label';
                Ellipsis = true;
                Image = PrintVoucher;

                trigger OnAction()
                var
                    SalesShptHeader: Record "Sales Shipment Header";
                begin
                    CurrPage.SetSelectionFilter(SalesShptHeader);
                    Report.RunModal(Report::"Shipment Label", true, false, SalesShptHeader);
                end;
            }
        }
        addafter("&Navigate")
        {
            action("&Exportar envio")
            {
                ApplicationArea = Basic;
                Caption = '&Exportar envio';
                Image = ExportShipment;

                trigger OnAction()
                var
                    XMLPalets: XmlPort "Export Posted Sales Shipment";
                begin
                    XMLPalets.Parametros(Rec."No.");
                    XMLPalets.Run;
                end;
            }
        }
    }
    var
        RecPales: Record "Sales Shipment Palet";
}
