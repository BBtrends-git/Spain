page 51119 "BBT Purchase Import Entries"
{
    ApplicationArea = All;
    Caption = 'Import Purchase Order Product Entries', Comment = 'ESP="Entrada Producto Importación"';
    PageType = List;
    SourceTable = "Purchase Line";
    UsageCategory = ReportsAndAnalysis;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field(Quantity; Rec."Quantity")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Qty. to Receive"; Rec."Qty. to Receive")
                {
                    Editable = false;
                }
                field(AliasProveedor; AliasProveedor)
                {
                    Caption = 'Vendor Search Name', comment = 'ESP="Alias Proveedor"';
                    Editable = false;
                }
                field("BBT Line Status"; rec."BBT Line Status")
                {
                    Editable = false;
                    Visible = false;
                }
                field(PurchaserCode; PurchaserCode)
                {
                    Caption = 'Purchaser Code', comment = 'ESP="Comprador"';
                    Editable = false;
                    Visible = false;
                }
                field(ProductManager; ProductManager)
                {
                    Caption = 'product Manager', comment = 'ESP="Responsable Producto"';
                    Editable = false;
                    Visible = false;
                }
                field("BBT ETA Planning"; Rec."BBT ETA Planning")
                {
                    Editable = false;
                    Visible = false;
                }
                field("BBT Inspection"; Rec."BBT Inspection")
                {
                    Editable = false;
                    Visible = false;
                }
                field("BBT Cntr Type"; Rec."BBT Cntr Type")
                {
                    Editable = false;
                }
                field("Container Volume"; Rec."Container Volume")
                {
                    Editable = false;
                }
                field("Container Nr"; Rec."Container Nr")
                {
                    Editable = false;
                }
                field("ForwarderName"; "ForwarderName")
                {
                    Caption = 'Forwarder Name', comment = 'ESP="Nombre Forwarder"';
                    Editable = false;
                }
                field("Ship Name"; Rec."Ship Name")
                {
                    Editable = false;
                }
                field("Consolidation Reference"; Rec."Consolidation Reference")
                {
                    Editable = false;
                    Visible = false;
                }
                field("ENS"; Rec."BBT ENS")
                {
                    Editable = false;
                }
                field("ETD"; Rec."ETD PO")
                {
                    Editable = false;
                }
                field("ETA"; Rec."ETA")
                {
                    Editable = false;
                }
                field("Days on the Ship"; Rec."Days on the Ship")
                {
                    Editable = false;
                }
                field("Days in Port"; Rec."Days in Port")
                {
                    Editable = false;
                }
                field("Warehouse Upload DateTime"; Rec."Warehouse Upload DateTime")
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    var
        PurchaserCode: Text[100];
        ProductManager: Text[100];
        ForwarderName: Text[100];
        AliasProveedor: Text[100];
        rVendor: Record Vendor;
        rPurchaseHeader: Record "Purchase Header";

    trigger OnOpenPage()
    begin
        Rec.SetRange("Document Type", Rec."Document Type"::Order);
        Rec.SetRange(Type, Rec.Type::Item);
        Rec.SetFilter(Quantity, '<>%1', 0);
        Rec.SetFilter("Outstanding Quantity", '<>%1', 0);
        Rec.SetFilter(ETA, '<>%1', 0D);
        Rec.SetFilter("No.", '1???????|2???????|3???????|4???????|5???????|6???????|7???????|8???????');
        Rec.SetFilter("BBT Line Status", 'EMBARCADO');

        Rec.SetCurrentKey("ETA");
        Rec.Ascending(true);
    end;

    trigger OnAfterGetRecord()
    begin
        Clear(PurchaserCode);
        clear(ProductManager);
        Clear(rPurchaseHeader);
        if rPurchaseHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            PurchaserCode := rPurchaseHeader."Purchaser Code";
            ProductManager := rPurchaseHeader."Product Manager";
        end;

        Clear(ForwarderName);
        rVendor.Reset();
        if rVendor.Get(rec."BBT Forwarder") then begin
            ForwarderName := rVendor.Name;
        end;

        Clear(AliasProveedor);
        rVendor.Reset();
        if rVendor.Get(rec."Buy-from Vendor No.") then begin
            AliasProveedor := rVendor."Search Name";
        end;
    end;
}