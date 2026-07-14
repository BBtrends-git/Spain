page 51450 "SGA Setup Card"
{
    ApplicationArea = All;
    Caption = 'Warehouse Management System Setup', Comment = 'ESP="Configuración Sistema Gestión Almacén"';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "SGA Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Configuration)
            {
                Caption = 'Configuration', Comment = 'ESP="Configuración"';
                field("SGA Enabled"; Rec."SGA Enabled")
                {
                    ApplicationArea = All;
                }
                group(Units)
                {
                    Caption = 'Units of Measure', Comment = 'ESP="Unidades de Medida"';
                    Enabled = (Rec."SGA Enabled");
                    Visible = (Rec."SGA Enabled");

                    field("Box Unit"; Rec."Box Unit")
                    {
                        ApplicationArea = All;
                    }
                    field("Palet Unit"; Rec."Palet Unit")
                    {
                        ApplicationArea = All;
                    }
                }
                group("Diario Ajustes")
                {
                    Caption = 'Adjustment Journal', Comment = 'ESP="Diario Ajustes"';
                    Enabled = (Rec."SGA Enabled");
                    Visible = (Rec."SGA Enabled");

                    field("Journal Template Name"; Rec."Journal Template Name")
                    {
                        ApplicationArea = All;
                    }
                    field("Journal Batch Name"; Rec."Journal Batch Name")
                    {
                        ApplicationArea = All;
                    }
                }
                group("Diario Ajuste Inventario")
                {
                    Caption = 'Inventory Adjustment Journal', comment = 'ESP="Diario Ajuste Inventario"';
                    Enabled = (Rec."SGA Enabled");
                    Visible = (Rec."SGA Enabled");

                    field("Inv Journal Template Name"; Rec."Inv Journal Template Name")
                    {
                        ApplicationArea = All;
                    }
                    field("Inv Journal Batch Name"; Rec."Inv Journal Batch Name")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group(EndPoints)
            {
                Caption = 'EndPoints', Comment = 'ESP="EndPoints"';
                Enabled = (Rec."SGA Enabled");
                Visible = (Rec."SGA Enabled");

                field("SGA Document Block Endp"; Rec."SGA Document Block Endp")
                {
                    ApplicationArea = All;
                }
                field("SGA Insert Transfer Order Endp"; Rec."SGA Insert Transfer Order Endp")
                {
                    ApplicationArea = All;
                }
                field("SGA Insert Item Endp"; Rec."SGA Insert Item Endp")
                {
                    ApplicationArea = All;
                }
                field("SGA Purch Order Mngmnt Endp"; Rec."SGA Purch Order Mngmnt Endp")
                {
                    ApplicationArea = All;
                }
                field("SGA Insert Pur Return Ord Endp"; Rec."SGA Insert Pur Return Ord Endp")
                {
                    ApplicationArea = All;
                }
                field("SGA Insert SalesReturn Endp"; Rec."SGA Insert SalesReturn Endp")
                {
                    ApplicationArea = All;
                }
                field("SGA Insert Shipm Confirm Endp"; Rec."SGA Insert Shipm Confirm Endp")
                {
                    ApplicationArea = All;
                }
                field("SGA Purchase Order Recep Endp"; Rec."SGA Purchase Order Recep Endp")
                {
                    ApplicationArea = All;
                }
                field("SGA Read error fields Endp"; Rec."SGA Read error fields Endp")
                {
                    ApplicationArea = All;
                }
                field("SGA Read Err Fields Stock Endp"; Rec."SGA Read Err Fields Stock Endp")
                {
                    ApplicationArea = All;
                }
                field("SGA Read Exped Shipment Endp"; Rec."SGA Read Exped Shipment Endp")
                {
                    ApplicationArea = All;
                }
                field("SGA Read location entry Endp"; Rec."SGA Read location entry Endp")
                {
                    ApplicationArea = All;
                }

                field("SGA Read Pur Return Order Endp"; Rec."SGA Read Pur Return Order Endp")
                {
                    ApplicationArea = All;
                }
                field("SGA Read packing list Endp"; Rec."SGA Read packing list Endp")
                {
                    ApplicationArea = All;
                }
                field("SGA Read Recp SalesReturn Endp"; Rec."SGA Read Recp SalesReturn Endp")
                {
                    ApplicationArea = All;
                }
                field("SGA Read Shipment Confirm Endp"; Rec."SGA Read Shipment Confirm Endp")
                {
                    ApplicationArea = All;
                }
                field("SGA Read Stock Adjust Endp"; Rec."SGA Read Stock Adjust Endp")
                {
                    ApplicationArea = All;
                }
                field("SGA Read Transfer Order Endp"; Rec."SGA Read Transfer Order Endp")
                {
                    ApplicationArea = All;
                }
                field("SGA Shipment Document Endp"; Rec."SGA Shipment Document Endp")
                {
                    ApplicationArea = All;
                }
                field("SGA Shipment Sales Order Endp"; Rec."SGA Shipment Sales Order Endp")
                {
                    ApplicationArea = All;
                }
                field("SGA Update Document Endp"; Rec."SGA Update Document Endp")
                {
                    ApplicationArea = All;
                }
                field("SGA Update Exped shipment Endp"; Rec."SGA Update Exped shipment Endp")
                {
                    ApplicationArea = All;
                }
                field("SGA Update Stock Adjust Endp"; Rec."SGA Update Stock Adjust Endp")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}