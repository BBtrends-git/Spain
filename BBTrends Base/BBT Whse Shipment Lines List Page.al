Page 50042 "Whse. Shipment Lines List"
{
    AutoSplitKey = true;
    Caption = 'Warehouse Shipment Lines', comment = 'ESP="Lineas pendientes de envios de almacen"';
    DelayedInsert = true;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "Warehouse Shipment Line";
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Estado; WarehouseShipmentHeader.Status)
                {
                    ApplicationArea = Basic;
                }
                field("Estado SGA"; WarehouseShipmentHeader."Status SGA")
                {
                    ApplicationArea = Basic;
                }
                field("Fecha registro"; WarehouseShipmentHeader."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Grabado SGA"; WarehouseShipmentHeader."Grabado SGA")
                {
                    ApplicationArea = Basic;
                }
                field("Tipo destino"; WarehouseShipmentHeader."Destination Type")
                {
                    ApplicationArea = Basic;
                }
                field("Nº destino"; WarehouseShipmentHeader."Destination No.")
                {
                    ApplicationArea = Basic;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field("Source Document"; Rec."Source Document")
                {
                    ApplicationArea = Basic;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Basic;
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Source External Document"; SourceExtDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'Source External Document', comment = 'ESP="No. Documento Externo"';
                }
                field("Destination Type"; Rec."Destination Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Destination No."; Rec."Destination No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Venta a-Nº cliente"; SalesHeader."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field("Venta a-Nombre"; SalesHeader."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Zone Code"; Rec."Zone Code")
                {
                    ApplicationArea = Basic;
                    Editable = DocEditable;
                    Visible = false;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = Basic;
                    Editable = DocEditable;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        BinCodeOnAfterValidate;
                    end;
                }
                field("Shelf No."; Rec."Shelf No.")
                {
                    ApplicationArea = Basic;
                    Editable = DocEditable;
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        QuantityOnAfterValidate;
                        //SGA
                        if Enviado_A_SGA then ActModifSGA;
                    end;
                }
                field("Qty. (Base)"; Rec."Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Qty. to Ship"; Rec."Qty. to Ship")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        //SGA
                        if Enviado_A_SGA then ActModifSGA;
                    end;
                }
                field("Qty. Shipped"; Rec."Qty. Shipped")
                {
                    ApplicationArea = Basic;
                }
                field("Qty. to Ship (Base)"; Rec."Qty. to Ship (Base)")
                {
                    ApplicationArea = Basic;
                    Editable = DocEditable;
                    Visible = false;
                }
                field("Qty. Shipped (Base)"; Rec."Qty. Shipped (Base)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Qty. Outstanding"; Rec."Qty. Outstanding")
                {
                    ApplicationArea = Basic;
                    Visible = true;
                }
                field("Qty. Outstanding (Base)"; Rec."Qty. Outstanding (Base)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Pick Qty."; Rec."Pick Qty.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Pick Qty. (Base)"; Rec."Pick Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Qty. Picked"; Rec."Qty. Picked")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Qty. Picked (Base)"; Rec."Qty. Picked (Base)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic;
                    Editable = DocEditable;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                }
                field(QtyCrossDockedUOM; QtyCrossDockedUOM)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. on Cross-Dock Bin', comment = 'ESP="Cdad. en ubic. tráns. directo"';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        CrossDockMgt.ShowBinContentsCrossDocked(Rec."Item No.", Rec."Variant Code", Rec."Unit of Measure Code", Rec."Location Code", true);
                    end;
                }
                field(QtyCrossDockedUOMBase; QtyCrossDockedUOMBase)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. on Cross-Dock Bin (Base)', comment = 'ESP="Cdad. ubic. tráns. dir. (Base)"';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        CrossDockMgt.ShowBinContentsCrossDocked(Rec."Item No.", Rec."Variant Code", Rec."Unit of Measure Code", Rec."Location Code", true);
                    end;
                }
                field(QtyCrossDockedAllUOMBase; QtyCrossDockedAllUOMBase)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. on Cross-Dock Bin (Base all UOM)', comment = 'ESP="Cdad. ubic. trán. dir. (Base todas UM)"';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        CrossDockMgt.ShowBinContentsCrossDocked(Rec."Item No.", Rec."Variant Code", Rec."Unit of Measure Code", Rec."Location Code", false);
                    end;
                }
                field(Control3; Rec."Assemble to Order")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Neto Unitario"; SalesLine."SMG Net Unit Price")
                {
                    ApplicationArea = Basic;
                    Caption = 'Neto Unitario';
                    DecimalPlaces = 2 : 2;
                }
                field("Importe línea"; SalesLine."SMG Net Unit Price" * Rec."Qty. Outstanding")
                {
                    ApplicationArea = Basic;
                    DecimalPlaces = 2 : 2;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line', comment = 'ESP="&Línea"';
                Image = Line;

                action("Source &Document Line")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source &Document Line', comment = 'ESP="Línea &documento origen"';
                    Image = SourceDocLine;

                    trigger OnAction()
                    begin
                        ShowSourceLine;
                    end;
                }
                action("&Bin Contents List")
                {
                    AccessByPermission = TableData "Bin Content" = R;
                    ApplicationArea = Basic;
                    Caption = '&Bin Contents List', comment = 'ESP="Lista &contenidos ubic."';
                    Image = BinContent;

                    trigger OnAction()
                    begin
                        ShowBinContents;
                    end;
                }
                action(ItemTrackingLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Lines', comment = 'ESP="Líns. se&guim. prod."';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        Rec.OpenItemTrackingLines;
                    end;
                }
                action("Assemble to Order")
                {
                    AccessByPermission = TableData "BOM Component" = R;
                    ApplicationArea = Basic;
                    Caption = 'Assemble to Order', comment = 'ESP="Ensamblar para pedido"';
                    Image = AssemblyBOM;

                    trigger OnAction()
                    var
                        ATOLink: Record "Assemble-to-Order Link";
                        ATOSalesLine: Record "Sales Line";
                    begin
                        Rec.TestField(Rec."Assemble to Order", true);
                        Rec.TestField(Rec."Source Type", Database::"Sales Line");
                        ATOSalesLine.Get(Rec."Source Subtype", Rec."Source No.", Rec."Source Line No.");
                        ATOLink.ShowAsm(ATOSalesLine);
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        CrossDockMgt.CalcCrossDockedItems(Rec."Item No.", Rec."Variant Code", Rec."Unit of Measure Code", Rec."Location Code", QtyCrossDockedUOMBase, QtyCrossDockedAllUOMBase);
        QtyCrossDockedUOM := 0;
        if Rec."Qty. per Unit of Measure" <> 0 then QtyCrossDockedUOM := ROUND(QtyCrossDockedUOMBase / Rec."Qty. per Unit of Measure", 0.00001);
        // SGA
        SetDocEditable;
        WarehouseShipmentHeader.Reset;
        WarehouseShipmentHeader.SetRange(WarehouseShipmentHeader."No.", Rec."No.");
        if WarehouseShipmentHeader.FindFirst then;
        SalesLine.Reset;
        SalesLine.SetRange(SalesLine."Document No.", Rec."Source No.");
        SalesLine.SetRange(SalesLine."Line No.", Rec."Source Line No.");
        if SalesLine.FindFirst then;
        SalesHeader.Reset;
        SalesHeader.SetRange(SalesHeader."No.", Rec."Source No.");
        if SalesHeader.FindFirst then SourceExtDocument := SalesHeader."External Document No.";
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if Enviado_A_SGA and (Rec."Qty. to Ship" <> 0) then Error('Envio en SGA.');
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // SGA
        if Enviado_A_SGA then Error('Envio en SGA.');
    end;

    trigger OnOpenPage()
    begin
        // SGA
        if not Rec.FindSet then
            DocEditable := true
        else
            SetDocEditable;
    end;

    var
        WMSMgt: Codeunit "WMS Management";
        CrossDockMgt: Codeunit "Whse. Cross-Dock Management";
        QtyCrossDockedUOM: Decimal;
        QtyCrossDockedAllUOMBase: Decimal;
        QtyCrossDockedUOMBase: Decimal;
        DocEditable: Boolean;
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        SourceExtDocument: Text[50];

    local procedure ShowSourceLine()
    begin
        WMSMgt.ShowSourceDocLine(Rec."Source Type", Rec."Source Subtype", Rec."Source No.", Rec."Source Line No.", 0);
    end;

    procedure PostShipmentYesNo()
    var
        WhseShptLine: Record "Warehouse Shipment Line";
        WhsePostShptShipInvoice: Codeunit "Whse.-Post Shipment (Yes/No)";
    begin
        WhseShptLine.Copy(Rec);
        WhsePostShptShipInvoice.Run(WhseShptLine);
        Rec.Reset;
        Rec.SetCurrentkey(Rec."No.", Rec."Sorting Sequence No.");
        CurrPage.Update(false);
    end;

    procedure PostShipmentPrintYesNo()
    var
        WhseShptLine: Record "Warehouse Shipment Line";
        WhsePostShptPrintShipInvoice: Codeunit "Whse.-Post Shipment + Print";
    begin
        WhseShptLine.Copy(Rec);
        WhsePostShptPrintShipInvoice.Run(WhseShptLine);
        Rec.Reset;
        Rec.SetCurrentkey(Rec."No.", Rec."Sorting Sequence No.");
        CurrPage.Update(false);
    end;

    procedure AutofillQtyToHandle()
    var
        WhseShptLine: Record "Warehouse Shipment Line";
    begin
        WhseShptLine.Copy(Rec);
        Rec.AutofillQtyToHandle(WhseShptLine);
    end;

    procedure DeleteQtyToHandle()
    var
        WhseShptLine: Record "Warehouse Shipment Line";
    begin
        WhseShptLine.Copy(Rec);
        Rec.DeleteQtyToHandle(WhseShptLine);
    end;

    local procedure ShowBinContents()
    var
        BinContent: Record "Bin Content";
    begin
        BinContent.ShowBinContents(Rec."Location Code", Rec."Item No.", Rec."Variant Code", Rec."Bin Code");
    end;

    procedure PickCreate()
    var
        WhseShptHeader: Record "Warehouse Shipment Header";
        WhseShptLine: Record "Warehouse Shipment Line";
        ReleaseWhseShipment: Codeunit "Whse.-Shipment Release";
    begin
        WhseShptLine.Copy(Rec);
        WhseShptHeader.Get(WhseShptLine."No.");
        if WhseShptHeader.Status = WhseShptHeader.Status::Open then ReleaseWhseShipment.Release(WhseShptHeader);
        Rec.CreatePickDoc(WhseShptLine, WhseShptHeader);
    end;

    local procedure OpenItemTrackingLines()
    begin
        Rec.OpenItemTrackingLines;
    end;

    local procedure BinCodeOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure QuantityOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure SetDocEditable()
    var
        _Cabenvio: Record "Warehouse Shipment Header";
        _InfoCompany: Record "Company Information";
    begin
        //SGA
        _InfoCompany.Get;
        _Cabenvio.Get(Rec."No.");
        DocEditable := (_Cabenvio."Status SGA" = _Cabenvio."status sga"::" ") or (not _InfoCompany.SGA);
    end;

    local procedure ActModifSGA()
    var
        _Cabenvio: Record "Warehouse Shipment Header";
        _InfoCompany: Record "Company Information";
    begin
        // SGA
        _InfoCompany.Get;
        if _InfoCompany.SGA then begin
            _Cabenvio.Get(Rec."No.");
            _Cabenvio.ModificadoSGA := true;
            _Cabenvio.Modify;
        end;
    end;

    local procedure Enviado_A_SGA(): Boolean
    var
        _CabEnvio: Record "Warehouse Shipment Header";
        _InfoCompany: Record "Company Information";
    begin
        // SGA
        _InfoCompany.Get;
        _CabEnvio.Get(Rec."No.");
        if _InfoCompany.SGA then
            exit(_CabEnvio."Status SGA" <> _CabEnvio."status sga"::" ")
        else
            exit(false);
    end;
}
