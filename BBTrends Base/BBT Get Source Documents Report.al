Report 50036 "BBT Get Source Documents"
//fin - The application object identifier '5753' is not valid. It must be within the allowed ranges '[50000..90500]'.
//    - An application object of type 'Report' with name 'Get Source Documents' is already declared by the extension 'Base Application by Microsoft (18.0.23013.23795)'
{
    Caption = 'Get Source Documents', comment = 'ESP="Traer doc. origen"';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Warehouse Request"; "Warehouse Request")
        {
            DataItemTableView = where("Document Status" = const(Released), "Completely Handled" = filter(false));
            RequestFilterFields = "Source Document", "Source No.";

            column(ReportForNavId_9356; 9356)
            { }
            dataitem("Sales Header"; "Sales Header")
            {
                DataItemLink = "Document Type" = field("Source Subtype"), "No." = field("Source No.");
                DataItemTableView = sorting("Document Type", "No.");

                column(ReportForNavId_6640; 6640)
                {
                }
                dataitem("Sales Line"; "Sales Line")
                {
                    DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                    DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                    column(ReportForNavId_2844; 2844)
                    {
                    }
                    trigger OnAfterGetRecord()
                    var
                        _InfoCompany: Record "Company Information";
                    begin
                        VerifyItemNotBlocked("Sales Line"."No.");
                        if "Sales Line"."Location Code" = "Warehouse Request"."Location Code" then
                            case RequestType of
                                Requesttype::Receive:
                                    if SalesWarehouseMgt.CheckIfSalesLine2ReceiptLine("Sales Line") then begin
                                        if not OneHeaderCreated and not WhseHeaderCreated then CreateReceiptHeader;
                                        if not SalesWarehouseMgt.SalesLine2ReceiptLine(WhseReceiptHeader, "Sales Line") then ErrorOccured := true;
                                        LineCreated := true;
                                    end;
                                Requesttype::Ship:
                                    if SalesWarehouseMgt.CheckIfFromSalesLine2ShptLine("Sales Line") then begin
                                        if Cust.Blocked <> Cust.Blocked::" " then begin
                                            if not SalesHeaderCounted then begin
                                                SkippedSourceDoc += 1;
                                                SalesHeaderCounted := true;
                                            end;
                                            CurrReport.Skip;
                                        end;
                                        //SGA
                                        _InfoCompany.Get;
                                        //IF NOT OneHeaderCreated AND NOT WhseHeaderCreated THEN
                                        //   CreateShptHeader;
                                        if not OneHeaderCreated and not WhseHeaderCreated then begin
                                            CreateShptHeader;
                                            if _InfoCompany.SGA then MeterComentariosPedido(WhseShptHeader, "Sales Line");
                                        end;
                                        // Fin SGA
                                        if not SalesWarehouseMgt.FromSalesLine2ShptLine(WhseShptHeader, "Sales Line") then ErrorOccured := true;
                                        LineCreated := true;
                                    end;
                            end;
                    end;
                    /* NO se usa PRESTASHOP
                    trigger OnPostDataItem()
                    begin
                        //BBTRENDS>
                        if LineCreated then "Sales Header".UpdatePrestashopStatus(1);
                        //BBTRENDS<
                    end;
                    */
                    trigger OnPreDataItem()
                    begin
                        "Sales Line".SetRange("Sales Line".Type, "Sales Line".Type::Item);
                        if (("Warehouse Request".Type = "Warehouse Request".Type::Outbound) and ("Warehouse Request"."Source Document" = "Warehouse Request"."source document"::"Sales Order")) or (("Warehouse Request".Type = "Warehouse Request".Type::Inbound) and ("Warehouse Request"."Source Document" = "Warehouse Request"."source document"::"Sales Return Order")) then
                            "Sales Line".SetFilter("Sales Line"."Outstanding Quantity", '>0')
                        else
                            "Sales Line".SetFilter("Sales Line"."Outstanding Quantity", '<0');
                        "Sales Line".SetRange("Sales Line"."Drop Shipment", false);
                        "Sales Line".SetRange("Sales Line"."Job No.", '');
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    "Sales Header".TestField("Sales Header"."Sell-to Customer No.");
                    Cust.Get("Sales Header"."Sell-to Customer No.");
                    if not SkipBlockedCustomer then Cust.CheckBlockedCustOnDocs(Cust, "Sales Header"."Document Type", false, false);
                    SalesHeaderCounted := false;
                end;

                trigger OnPreDataItem()
                begin
                    if "Warehouse Request"."Source Type" <> Database::"Sales Line" then CurrReport.Break;
                end;
            }
            dataitem("Purchase Header"; "Purchase Header")
            {
                DataItemLink = "Document Type" = field("Source Subtype"), "No." = field("Source No.");
                DataItemTableView = sorting("Document Type", "No.");

                column(ReportForNavId_4458; 4458)
                {
                }
                dataitem("Purchase Line"; "Purchase Line")
                {
                    DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                    DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                    column(ReportForNavId_6547; 6547)
                    {
                    }
                    trigger OnAfterGetRecord()
                    begin
                        VerifyItemNotBlocked("Purchase Line"."No.");
                        if "Purchase Line"."Location Code" = "Warehouse Request"."Location Code" then
                            case RequestType of
                                Requesttype::Receive:
                                    if PurchaseWarehouseMgt.CheckIfPurchLine2ReceiptLine("Purchase Line") then begin
                                        if not OneHeaderCreated and not WhseHeaderCreated then CreateReceiptHeader;
                                        if not PurchaseWarehouseMgt.PurchLine2ReceiptLine(WhseReceiptHeader, "Purchase Line") then ErrorOccured := true;
                                        LineCreated := true;
                                    end;
                                Requesttype::Ship:
                                    if PurchaseWarehouseMgt.CheckIfFromPurchLine2ShptLine("Purchase Line") then begin
                                        if not OneHeaderCreated and not WhseHeaderCreated then CreateShptHeader;
                                        if not PurchaseWarehouseMgt.FromPurchLine2ShptLine(WhseShptHeader, "Purchase Line") then ErrorOccured := true;
                                        LineCreated := true;
                                    end;
                            end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        "Purchase Line".SetRange("Purchase Line".Type, "Purchase Line".Type::Item);
                        if (("Warehouse Request".Type = "Warehouse Request".Type::Inbound) and ("Warehouse Request"."Source Document" = "Warehouse Request"."source document"::"Purchase Order")) or (("Warehouse Request".Type = "Warehouse Request".Type::Outbound) and ("Warehouse Request"."Source Document" = "Warehouse Request"."source document"::"Purchase Return Order")) then
                            "Purchase Line".SetFilter("Purchase Line"."Outstanding Quantity", '>0')
                        else
                            "Purchase Line".SetFilter("Purchase Line"."Outstanding Quantity", '<0');
                        "Purchase Line".SetRange("Purchase Line"."Drop Shipment", false);
                        "Purchase Line".SetRange("Purchase Line"."Job No.", '');
                    end;
                }
                trigger OnPreDataItem()
                begin
                    if "Warehouse Request"."Source Type" <> Database::"Purchase Line" then CurrReport.Break;
                end;
            }
            dataitem("Transfer Header"; "Transfer Header")
            {
                DataItemLink = "No." = field("Source No.");
                DataItemTableView = sorting("No.");

                column(ReportForNavId_2957; 2957)
                {
                }
                dataitem("Transfer Line"; "Transfer Line")
                {
                    DataItemLink = "Document No." = field("No.");
                    DataItemTableView = sorting("Document No.", "Line No.");

                    column(ReportForNavId_9370; 9370)
                    {
                    }
                    trigger OnAfterGetRecord()
                    begin
                        case RequestType of
                            Requesttype::Receive:
                                if TransferWarehouseMgt.CheckIfTransLine2ReceiptLine("Transfer Line") then begin
                                    if not OneHeaderCreated and not WhseHeaderCreated then CreateReceiptHeader;
                                    if not TransferWarehouseMgt.TransLine2ReceiptLine(WhseReceiptHeader, "Transfer Line") then ErrorOccured := true;
                                    LineCreated := true;
                                end;
                            Requesttype::Ship:
                                if TransferWarehouseMgt.CheckIfFromTransLine2ShptLine("Transfer Line") then begin
                                    if not OneHeaderCreated and not WhseHeaderCreated then CreateShptHeader;
                                    if not TransferWarehouseMgt.FromTransLine2ShptLine(WhseShptHeader, "Transfer Line") then ErrorOccured := true;
                                    LineCreated := true;
                                end;
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        case "Warehouse Request"."Source Subtype" of
                            0:
                                "Transfer Line".SetFilter("Transfer Line"."Outstanding Quantity", '>0');
                            1:
                                "Transfer Line".SetFilter("Transfer Line"."Qty. in Transit", '>0');
                        end;
                    end;
                }
                trigger OnPreDataItem()
                begin
                    if "Warehouse Request"."Source Type" <> Database::"Transfer Line" then CurrReport.Break;
                end;
            }
            dataitem("Service Header"; "Service Header")
            {
                DataItemLink = "Document Type" = field("Source Subtype"), "No." = field("Source No.");
                DataItemTableView = sorting("Document Type", "No.");

                column(ReportForNavId_1634; 1634)
                {
                }
                dataitem("Service Line"; "Service Line")
                {
                    DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                    DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                    column(ReportForNavId_6560; 6560)
                    {
                    }
                    trigger OnAfterGetRecord()
                    begin
                        if "Service Line"."Location Code" = "Warehouse Request"."Location Code" then
                            case RequestType of
                                Requesttype::Ship:
                                    if ServiceWarehouseMgt.CheckIfFromServiceLine2ShptLine("Service Line") then begin
                                        if not OneHeaderCreated and not WhseHeaderCreated then CreateShptHeader;
                                        if not ServiceWarehouseMgt.FromServiceLine2ShptLine(WhseShptHeader, "Service Line") then ErrorOccured := true;
                                        LineCreated := true;
                                    end;
                            end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        "Service Line".SetRange("Service Line".Type, "Service Line".Type::Item);
                        if (("Warehouse Request".Type = "Warehouse Request".Type::Outbound) and ("Warehouse Request"."Source Document" = "Warehouse Request"."source document"::"Service Order")) then
                            "Service Line".SetFilter("Service Line"."Outstanding Quantity", '>0')
                        else
                            "Service Line".SetFilter("Service Line"."Outstanding Quantity", '<0');
                        "Service Line".SetRange("Service Line"."Job No.", '');
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    "Service Header".TestField("Service Header"."Bill-to Customer No.");
                    Cust.Get("Service Header"."Bill-to Customer No.");
                    if not SkipBlockedCustomer then
                        Cust.CheckBlockedCustOnDocs(Cust, "Service Header"."Document Type", false, false)
                    else if Cust.Blocked <> Cust.Blocked::" " then CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin
                    if "Warehouse Request"."Source Type" <> Database::"Service Line" then CurrReport.Break;
                end;
            }
            trigger OnAfterGetRecord()
            var
                WhseSetup: Record "Warehouse Setup";
            begin
                WhseHeaderCreated := false;
                case "Warehouse Request".Type of
                    "Warehouse Request".Type::Inbound:
                        begin
                            if not Location.RequireReceive("Warehouse Request"."Location Code") then begin
                                if "Warehouse Request"."Location Code" = '' then WhseSetup.TestField("Require Receive");
                                Location.Get("Warehouse Request"."Location Code");
                                Location.TestField("Require Receive");
                            end;
                            if not OneHeaderCreated then RequestType := Requesttype::Receive;
                        end;
                    "Warehouse Request".Type::Outbound:
                        begin
                            if not Location.RequireShipment("Warehouse Request"."Location Code") then begin
                                if "Warehouse Request"."Location Code" = '' then WhseSetup.TestField("Require Shipment");
                                Location.Get("Warehouse Request"."Location Code");
                                Location.TestField("Require Shipment");
                            end;
                            if not OneHeaderCreated then RequestType := Requesttype::Ship;
                        end;
                end;
            end;

            trigger OnPostDataItem()
            begin
                if WhseHeaderCreated or OneHeaderCreated then begin
                    WhseShptHeader.SortWhseDoc;
                    WhseReceiptHeader.SortWhseDoc;
                end;
            end;

            trigger OnPreDataItem()
            begin
                if OneHeaderCreated then begin
                    case RequestType of
                        Requesttype::Receive:
                            "Warehouse Request".Type := "Warehouse Request".Type::Inbound;
                        Requesttype::Ship:
                            "Warehouse Request".Type := "Warehouse Request".Type::Outbound;
                    end;
                    "Warehouse Request".SetRange("Warehouse Request".Type, "Warehouse Request".Type);
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', comment = 'ESP="Opciones"';

                    field(DoNotFillQtytoHandle; DoNotFillQtytoHandle)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Do Not Fill Qty. to Handle', comment = 'ESP="No rellene cdad. a manipular"';
                    }
                }
            }
        }
        actions
        {
        }
    }
    labels
    {
    }
    trigger OnPostReport()
    begin
        case RequestType of
            Requesttype::Receive:
                begin
                    if DoNotFillQtytoHandle then begin
                        WhseReceiptLine.Reset;
                        WhseReceiptLine.SetRange("No.", WhseReceiptHeader."No.");
                        WhseReceiptLine.DeleteQtyToReceive(WhseReceiptLine);
                    end;
                    if not HideDialog then ShowReceiptDialog;
                end;
            Requesttype::Ship:
                if not HideDialog then
                    ShowShipmentDialog;
        end;
        if SkippedSourceDoc > 0 then Message(CustomerIsBlockedMsg, SkippedSourceDoc);
        Completed := true;
    end;

    trigger OnPreReport()
    begin
        ActivitiesCreated := 0;
        LineCreated := false;
    end;

    var
        Text000: label 'There are no Warehouse Receipt Lines created.', comment = 'ESP="No existen líns. recep almacén creadas."';
        Text001: label '%1 %2 has been created.', comment = 'ESP="Se ha creado %1 %2."';
        WhseReceiptHeader: Record "Warehouse Receipt Header";
        WhseReceiptLine: Record "Warehouse Receipt Line";
        WhseShptHeader: Record "Warehouse Shipment Header";
        WhseShptLine: Record "Warehouse Shipment Line";
        Location: Record Location;
        Cust: Record Customer;
        //>> New Version 26
        //WhseActivityCreate: Codeunit "Whse.-Create Source Document";
        SalesWarehouseMgt: Codeunit "Sales Warehouse Mgt.";
        PurchaseWarehouseMgt: Codeunit "Purchases Warehouse Mgt.";
        TransferWarehouseMgt: Codeunit "Transfer Warehouse Mgt.";
        ServiceWarehouseMgt: Codeunit "Service Warehouse Mgt.";
        //<<<
        ActivitiesCreated: Integer;
        OneHeaderCreated: Boolean;
        Completed: Boolean;
        LineCreated: Boolean;
        WhseHeaderCreated: Boolean;
        DoNotFillQtytoHandle: Boolean;
        HideDialog: Boolean;
        SkipBlockedCustomer: Boolean;
        SkipBlockedItem: Boolean;
        RequestType: Option Receive,Ship;
        SalesHeaderCounted: Boolean;
        SkippedSourceDoc: Integer;
        Text002: label '%1 Warehouse Receipts have been created.', comment = 'ESP="Se han creado %1 líns. recep almacén."';
        Text003: label 'There are no Warehouse Shipment Lines created.', comment = 'ESP="No se han creado líneas de envío de almacén."';
        Text004: label '%1 Warehouse Shipments have been created.', comment = 'ESP="Se han creado %1 envíos de almacén."';
        ErrorOccured: Boolean;
        Text005: label 'One or more of the lines on this %1 require special warehouse handling. The %2 for such lines has been set to blank.', comment = 'ESP="Una o más de las líneas de este %1 requieren manipulación de almacén especial. El %2 para dichas líneas se ha establecido en blanco."';
        CustomerIsBlockedMsg: label '%1 source documents were not included because the customer is blocked.', comment = 'ESP="%1 documentos de origen no se incluyeron porque el cliente está bloqueado."';

    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;

    procedure SetOneCreatedShptHeader(WhseShptHeader2: Record "Warehouse Shipment Header")
    begin
        RequestType := Requesttype::Ship;
        WhseShptHeader := WhseShptHeader2;
        if WhseShptHeader.Find then OneHeaderCreated := true;
    end;

    procedure SetOneCreatedReceiptHeader(WhseReceiptHeader2: Record "Warehouse Receipt Header")
    begin
        RequestType := Requesttype::Receive;
        WhseReceiptHeader := WhseReceiptHeader2;
        if WhseReceiptHeader.Find then OneHeaderCreated := true;
    end;

    procedure SetDoNotFillQtytoHandle(DoNotFillQtytoHandle2: Boolean)
    begin
        DoNotFillQtytoHandle := DoNotFillQtytoHandle2;
    end;

    procedure GetLastShptHeader(var WhseShptHeader2: Record "Warehouse Shipment Header")
    begin
        RequestType := Requesttype::Ship;
        WhseShptHeader2 := WhseShptHeader;
    end;

    procedure GetLastReceiptHeader(var WhseReceiptHeader2: Record "Warehouse Receipt Header")
    begin
        RequestType := Requesttype::Receive;
        WhseReceiptHeader2 := WhseReceiptHeader;
    end;

    procedure NotCancelled(): Boolean
    begin
        exit(Completed);
    end;

    local procedure CreateShptHeader()
    begin
        WhseShptHeader.Init;
        WhseShptHeader."No." := '';
        WhseShptHeader."Location Code" := "Warehouse Request"."Location Code";
        if Location.Code = WhseShptHeader."Location Code" then WhseShptHeader."Bin Code" := Location."Shipment Bin Code";
        // SGA
        if "Sales Header"."No." <> '' then begin
            WhseShptHeader."Shipping Agent Code" := "Sales Header"."Shipping Agent Code";
            //WhseShptHeader."External Document No." :="Sales Header"."External Document No.";
            WhseShptHeader."Shipment Date" := "Sales Header"."Requested Delivery Date";
            WhseShptHeader."Shipping Agent Service Code" := "Sales Header"."Shipping Agent Service Code";
            WhseShptHeader."Shipment Method Code" := "Sales Header"."Shipment Method Code";
        end;
        // SGA
        WhseShptLine.LockTable;
        WhseShptHeader.Insert(true);
        ActivitiesCreated := ActivitiesCreated + 1;
        WhseHeaderCreated := true;
        Commit;
    end;

    local procedure CreateReceiptHeader()
    begin
        WhseReceiptHeader.Init;
        WhseReceiptHeader."No." := '';
        WhseReceiptHeader."Location Code" := "Warehouse Request"."Location Code";
        if Location.Code = WhseReceiptHeader."Location Code" then WhseReceiptHeader."Bin Code" := Location."Receipt Bin Code";
        WhseReceiptLine.LockTable;
        WhseReceiptHeader.Insert(true);
        ActivitiesCreated := ActivitiesCreated + 1;
        WhseHeaderCreated := true;
        Commit;
    end;

    procedure SetSkipBlocked(Skip: Boolean)
    begin
        SkipBlockedCustomer := Skip;
    end;

    procedure SetSkipBlockedItem(Skip: Boolean)
    begin
        SkipBlockedItem := Skip;
    end;

    local procedure VerifyItemNotBlocked(ItemNo: Code[20])
    var
        Item: Record Item;
    begin
        Item.Get(ItemNo);
        if SkipBlockedItem and Item.Blocked then CurrReport.Skip;
        Item.TestField(Blocked, false);
    end;

    procedure ShowReceiptDialog()
    var
        SpecialHandlingMessage: Text[1024];
    begin
        if not LineCreated then Error(Text000);
        if ErrorOccured then SpecialHandlingMessage := ' ' + StrSubstNo(Text005, WhseReceiptHeader.TableCaption, WhseReceiptLine.FieldCaption("Bin Code"));
        if (ActivitiesCreated = 0) and LineCreated and ErrorOccured then Message(SpecialHandlingMessage);
        if ActivitiesCreated = 1 then Message(StrSubstNo(Text001, ActivitiesCreated, WhseReceiptHeader.TableCaption) + SpecialHandlingMessage);
        if ActivitiesCreated > 1 then Message(StrSubstNo(Text002, ActivitiesCreated) + SpecialHandlingMessage);
    end;

    procedure ShowShipmentDialog()
    var
        SpecialHandlingMessage: Text[1024];
    begin
        if not LineCreated then Error(Text003);
        if ErrorOccured then SpecialHandlingMessage := ' ' + StrSubstNo(Text005, WhseShptHeader.TableCaption, WhseShptLine.FieldCaption("Bin Code"));
        if (ActivitiesCreated = 0) and LineCreated and ErrorOccured then Message(SpecialHandlingMessage);
        if ActivitiesCreated = 1 then Message(StrSubstNo(Text001, ActivitiesCreated, WhseShptHeader.TableCaption) + SpecialHandlingMessage);
        if ActivitiesCreated > 1 then Message(StrSubstNo(Text004, ActivitiesCreated) + SpecialHandlingMessage);
    end;

    local procedure MeterComentariosPedido(_WhseShpHeader: Record "Warehouse Shipment Header"; _Salesline: Record "Sales Line")
    var
        _SalesComent: Record "Sales Comment Line";
        _ShippingComment: Record "Warehouse Comment Line";
        _NumLineaComent: Integer;
    begin
        _SalesComent.SetRange("Document Type", _SalesComent."document type"::Order);
        _SalesComent.SetRange("No.", _Salesline."Document No.");
        _SalesComent.SetRange("Comment type", _SalesComent."comment type"::Ship);
        if _SalesComent.FindSet then begin
            _ShippingComment.SetRange("Table Name", _ShippingComment."table name"::"Whse. Shipment");
            _ShippingComment.SetRange(Type, _ShippingComment.Type::" ");
            _ShippingComment.SetRange("No.", _WhseShpHeader."No.");
            if _ShippingComment.FindLast then
                _NumLineaComent := _ShippingComment."Line No."
            else
                _NumLineaComent := 0;
            _ShippingComment.Reset;
            repeat
                _NumLineaComent += 10000;
                _ShippingComment.Init;
                _ShippingComment."Table Name" := _ShippingComment."table name"::"Whse. Shipment";
                _ShippingComment.Type := _ShippingComment.Type::" ";
                _ShippingComment."No." := _WhseShpHeader."No.";
                _ShippingComment."Line No." := _NumLineaComent;
                _ShippingComment.Date := _SalesComent.Date;
                _ShippingComment.Code := _SalesComent.Code;
                _ShippingComment.Comment := _SalesComent.Comment;
                _ShippingComment.Insert;
            until _SalesComent.Next = 0;
        end;
    end;
}
