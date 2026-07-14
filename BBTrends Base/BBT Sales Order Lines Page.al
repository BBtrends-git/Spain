Page 50081 "Sales Order Lines"
{
    Caption = 'Sales Order Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Sales Line";
    SourceTableView = where(Type = const(Item), "Document Type" = const(Order), "Qty. to Ship" = filter(<> 0));
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."Shipment Nr")
                {
                    ApplicationArea = Basic;
                }
                field("Line Nr."; Rec."Shipoment Line Nr")
                {
                    ApplicationArea = Basic;
                    Caption = 'Shipment Line Nr';
                }
                field("Source Document"; 'Sales Order')
                {
                    ApplicationArea = Basic;
                    Caption = 'Source Document';
                }
                field("Source Nr."; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source No.';
                }
                field("Posting Date"; SalesHeader."Posting Date")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        SalesHeader2.Reset;
                        SalesHeader2.SetRange("Document Type", Rec."Document Type");
                        SalesHeader2.SetRange("No.", Rec."Document No.");
                        if SalesHeader2.FindFirst then begin
                            SalesHeader2.Validate("Posting Date", SalesHeader."Posting Date");
                            SalesHeader2.Modify;
                        end;
                        CurrPage.Update;
                    end;
                }
                field("partner Nr"; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Partner No.';
                }
                field("partner name."; SalesHeader."Ship-to Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Partner Name';
                }
                field(Status; SalesHeader.Status)
                {
                    ApplicationArea = Basic;
                }
                field("External Document"; ExternalDocument)
                {
                    ApplicationArea = Basic;
                    Visible = true;
                    Editable = false;
                }
                field("Item No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item No.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("Exported to CSV"; Rec."Exported to CSV")
                {
                    ApplicationArea = Basic;
                    Visible = true;
                }
                field("Exported to CSV Date"; Rec."Exported to CSV Date")
                {
                    ApplicationArea = Basic;
                    Visible = true;
                }
                field("ShipmentDate"; ShipmentDate)
                {
                    Caption = 'Shipment Date';
                    ApplicationArea = Basic;
                    Visible = true;
                    Editable = not Rec."Exported to CSV";

                    trigger OnValidate()
                    begin
                        Rec."Shipment Date" := ShipmentDate;
                    end;
                }
                field("Shipment Comments"; Rec."Shipment Comments")
                {
                    ApplicationArea = Basic;
                }
                field("Delivery Date"; SalesHeader."Promised Delivery Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Delivery Time"; SalesHeader."Delivery Time")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Quantity units"; Rec."Qty. to Ship")
                {
                    ApplicationArea = Basic;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field("Qty cartns "; QtyCartons)
                {
                    ApplicationArea = Basic;
                    Caption = 'QtyCartons';
                    Editable = false;
                    StyleExpr = CartonDec;
                }
                field(EAN13; EAN13Code)
                {
                    ApplicationArea = Basic;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("Due Date"; SalesHeader."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(Adresss; SalesHeader."Ship-to Address" + ' ' + SalesHeader."Ship-to Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(City; SalesHeader."Ship-to City")
                {
                    ApplicationArea = Basic;
                }
                field(Contact; SalesHeader."Ship-to Contact")
                {
                    ApplicationArea = Basic;
                }
                field("Phone Numb"; Customer."Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(Country; SalesHeader."Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
                field("ZIP Code"; SalesHeader."Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(Province; SalesHeader."Ship-to County")
                {
                    ApplicationArea = Basic;
                }
                field("E-mail"; Customer."E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field("Inventoy Location Code"; Rec."Inventoy Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("Qty to Ship All Sales Orders"; Rec."Qty to Ship All Sales Orders")
                {
                    ApplicationArea = Basic;
                }
                //>> BBT. 16/03/2026. Implantación de la extensión SMG.
                /*
                field("Net Unit Price"; Rec."Net Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field("Amount to Ship"; Rec."Qty. to Ship" * Rec."Net Unit Price")
                {
                    ApplicationArea = Basic;
                }
                */
                field("Net Unit Price"; Rec."SMG Net Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field("Amount to Ship"; Rec."Qty. to Ship" * Rec."SMG Net Unit Price")
                {
                    ApplicationArea = Basic;
                }
                //<<
                field(Reference; CustomerRef)
                {
                    ApplicationArea = Basic;
                }
                field("Exported to Suus"; Rec."Exported to Suus")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Exported to Suus Datetime"; Rec."Exported to Suus Datetime")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action("Export to File")
            {
                ApplicationArea = Basic;
                Caption = 'Export to File';
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ExporSelectedToCSV;
                end;
            }
            action("Exportar líneas a FTP")
            {
                ApplicationArea = Basic;
                Caption = 'Export lines to FTP';
                Image = LaunchWeb;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ExportSelectedToFTP;
                end;
            }
            action("Create Shipment")
            {
                ApplicationArea = Basic;
                Caption = 'Create Shipment';
                Image = ReceiptLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Text50001: label 'There are not lines selected';
                    //>> Obsoleto V27
                    //NoSeriesManagement: Codeunit NoSeriesManagement;
                    NoSeries: Codeunit "No. Series";
                    //<<
                    SalesReceivablesSetup: Record "Sales & Receivables Setup";
                    Cont: Integer;
                    ShipNr: Code[20];
                begin
                    SalesReceivablesSetup.Get;
                    Cont := 0;
                    CurrPage.SetSelectionFilter(SalesLine);
                    if not SalesLine.FindSet then Error(Text50001);
                    //>> V27
                    //ShipNr := NoSeriesManagement.GetNextNo(SalesReceivablesSetup."Warehouse Sales Shipment Nos.", Today, true);
                    ShipNr := NoSeries.GetNextNo(SalesReceivablesSetup."Warehouse Sales Shipment Nos.", Today);
                    //<<
                    repeat
                        SalesHeader.Reset;
                        SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
                        if SalesHeader.Status <> SalesHeader.Status::Released then Error('Sales Order %1 not released', SalesHeader."No.");
                        Cont := Cont + 1;
                        SalesLine."Shipment Nr" := ShipNr;
                        SalesLine."Shipoment Line Nr" := Cont;
                        SalesLine.Modify;
                    until SalesLine.Next = 0;
                    //
                    //
                    // COMMIT;
                end;
            }
            action("Show Order")
            {
                ApplicationArea = Basic;
                Caption = 'Show Order';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Sales Order";
                RunPageLink = "Document Type" = field("Document Type"), "No." = field("Document No.");
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SalesShipmentHeader: Record "Sales Shipment Header";
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                begin
                end;
            }
            /*
            action("Ship Lines")
            {
                ApplicationArea = Basic;
                Caption = 'Ship Lines';
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = true;

                trigger OnAction()
                begin
                    ShipLines;
                end;
            }
            */
            action("Shipment Lines")
            {
                ApplicationArea = Basic;
                Caption = 'Shipment Line';
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = true;

                trigger OnAction()
                begin
                    ShipmentLines;
                end;
            }
        }
        area(Navigation)
        {
            action("ExportXBS")
            {
                ApplicationArea = Basic;
                Caption = 'Export to XBS';
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = true;

                trigger OnAction()
                begin
                    ExporSelectedToXBS;
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        UpdateData;

        ShipmentDate := Rec."Shipment Date";
        Clear(ExternalDocument);
        rSalesHeaderAux.Reset();
        If rSalesHeaderAux.Get(Rec."Document Type", Rec."Document No.") then
            ExternalDocument := rSalesHeaderAux."External Document No.";
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange("Location Code", 'STOCK PL');
    end;

    var
        EAN13Code: Code[20];
        ItemIdentifier: Record "Item Identifier";
        ItemCrossReference: Record "Item Reference";
        ItemCrossReferenceCust: Record "Item Reference";
        SalesHeader: Record "Sales Header";
        QtyCartons: Decimal;
        ItemUnitofMeasure: Record "Item Unit of Measure";
        Customer: Record Customer;
        SalesLine: Record "Sales Line";
        ShiptoAddress: Record "Ship-to Address";
        CartonDec: Text[30];
        ShipLinesVisible: Boolean;
        SalesHeader2: Record "Sales Header";
        CustomerRef: Code[20];
        ExternalDocument: Code[35];
        rSalesHeaderAux: Record "Sales Header";
        ShipmentDate: Date;

    local procedure ExporSelectedToCSV()
    var
        TempBlob: codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        OStream: OutStream;
        Text50000: label 'No lines selected to export';
        Text50001: label 'Do you want to export %1 lines?';
        Customer: Record Customer;
        FormatExportFile: Codeunit 50001;
    begin
        CurrPage.SetSelectionFilter(SalesLine);
        SalesLine.SetRange("Exported to CSV", false);
        if not SalesLine.FindSet then Error(Text50000);
        if not Confirm('Do you want to export ' + Format(SalesLine.Count) + ' lines to CSV?') then Error('');
        CreateCSVFile(TempBlob, SalesLine.FieldNo("Exported to CSV"));
        //FileManagement.BLOBExport(TempBlob,'PO Lines.csv',TRUE);
        FileManagement.BLOBExport(TempBlob, 'Order Sales ' + Rec."Shipment Nr" + '  ' + Format(Today, 0, '<Day,2><Month,2><Year,2>') + '.csv', true);
    end;

    local procedure ExportSelectedToFTP()
    var
        TempBlob: codeunit "Temp Blob";
        Text50000: label 'No lines selected to export';
        Text50001: label 'Do you want to export %1 lines?';
        PurchaseOrderLines: Page "Purchase Order Lines";
    begin
        Clear(SalesLine);
        CurrPage.SetSelectionFilter(SalesLine);
        SalesLine.SetRange("Exported to Suus", false);
        if not SalesLine.FindSet then Error(Text50000);
        if not Confirm('Desea subir ' + Format(SalesLine.Count) + ' líneas al FTP?') then Error('');
        CreateCSVFile(TempBlob, SalesLine.FieldNo("Exported to Suus"));
        PurchaseOrderLines.UploadFileFTP(TempBlob, 'Order Sales ' + Rec."Shipment Nr" + '  ' + Format(Today, 0, '<Day,2><Month,2><Year,2>') + '.csv');
    end;

    local procedure UpdateData()
    begin
        SalesHeader.SetRange(SalesHeader."No.", Rec."Document No.");
        if SalesHeader.FindFirst then;
        ItemUnitofMeasure.Reset;
        ItemUnitofMeasure.SetRange("Item No.", Rec."No.");
        ItemUnitofMeasure.SetRange(Code, 'CAJA');
        if ItemUnitofMeasure.FindFirst then
            QtyCartons := ROUND(Rec."Qty. to Ship" / ItemUnitofMeasure."Qty. per Unit of Measure")
        else
            QtyCartons := 0;
        CartonDec := 'Standard';
        if QtyCartons <> ROUND(QtyCartons, 1) then CartonDec := 'Unfavorable';
        ItemCrossReferenceCust.Reset;
        ItemCrossReferenceCust.SetRange("Item No.", Rec."No.");
        ItemCrossReferenceCust.SetRange("Unit of Measure", 'UNID');
        ItemCrossReferenceCust.SetRange(ItemCrossReferenceCust."Reference Type", ItemCrossReferenceCust."Reference Type"::Customer);
        ItemCrossReferenceCust.SetRange(ItemCrossReferenceCust."Reference Type No.", Rec."Sell-to Customer No.");
        if ItemCrossReferenceCust.FindFirst then
            CustomerRef := ItemCrossReferenceCust."Reference No."
        else
            CustomerRef := '';
        //>> 29/06/2023 EAN13 (Unidad de medidad = UNID) desde Item Identifier
        //ItemCrossReference.RESET;
        //ItemCrossReference.SETRANGE("Item No.","No.");
        //ItemCrossReference.SETRANGE("Unit of Measure",'UNID');
        //ItemCrossReference.SETRANGE(ItemCrossReference."Cross-Reference Type",ItemCrossReference."Cross-Reference Type"::"Bar Code");
        //IF ItemCrossReference.FINDFIRST THEN;
        CLEAR(EAN13Code);
        ItemIdentifier.RESET;
        ItemIdentifier.SETRANGE("Item No.", rec."No.");
        ItemIdentifier.SETRANGE("Unit of Measure Code", 'UNID');
        IF ItemIdentifier.FINDFIRST THEN EAN13Code := ItemIdentifier.Code;
        //<<
        Customer.Reset;
        Customer.SetRange("No.", SalesHeader."Ship-to Code");
        if Customer.FindFirst then;
    end;

    local procedure ShipLines()
    var
        SalesLine: Record "Sales Line";
        TempSalesLine: Record "Sales Line" temporary;
        SalesHeader: Record "Sales Header";
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        OrderNo: Code[20];
        MultipleOrdersErr: label 'You cannot select lines from multiple orders at the same time. Select lines from one order only to continue';
        NoLinesToPostErr: label 'There is nothing to post';
        ContinueMsg: label 'Do you wish to continue with posting?';
        OrdersPosted: label 'Order %1 posted';
    begin
        //ERROR('');
        if not Confirm(ContinueMsg) then Clear(SalesLine);
        // IF NOT TempSalesLine.ISTEMPORARY THEN
        //  ERROR('');
        //  ERROR('Unknown error. Contact your system administrator');
        TempSalesLine.Reset;
        TempSalesLine.DeleteAll(false);
        CurrPage.SetSelectionFilter(SalesLine);
        SalesLine.SetFilter("Qty. to Ship", '<>0');
        if not SalesLine.FindSet then Error(NoLinesToPostErr);
        repeat
            if COMPANYNAME = 'Eurogama Sp. z. o. o.' then begin
                SalesLine.CalcFields("Inventoy Location Code");
                if SalesLine."Inventoy Location Code" < SalesLine."Qty. to Ship" then Error('You have insufficient quantity of Item %1 on inventory.', SalesLine."No.");
            end;
            if OrderNo = '' then OrderNo := SalesLine."Document No.";
            if OrderNo <> SalesLine."Document No." then Error(MultipleOrdersErr);
            Clear(TempSalesLine);
            TempSalesLine := SalesLine;
            TempSalesLine.Insert(false);
        until SalesLine.Next = 0;
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", TempSalesLine."Document Type");
        SalesLine.SetRange("Document No.", TempSalesLine."Document No.");
        SalesLine.FindSet;
        repeat
            SalesHeader.Reset;
            SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
            if SalesHeader.Status <> SalesHeader.Status::Open then ReleaseSalesDocument.PerformManualReopen(SalesHeader);
            SalesLine.Validate("Qty. to Ship", 0);
            SalesLine.Modify;
        until SalesLine.Next = 0;
        TempSalesLine.Reset;
        TempSalesLine.FindSet;
        repeat
            SalesLine.Reset;
            SalesLine.Get(TempSalesLine."Document Type", TempSalesLine."Document No.", TempSalesLine."Line No.");
            SalesLine.Validate("Qty. to Ship", TempSalesLine."Qty. to Ship");
            SalesLine.Modify;
        until TempSalesLine.Next = 0;
        SalesHeader.Ship := true;
        SalesHeader.Invoice := false;
        SalesHeader.Receive := false;
        Codeunit.Run(Codeunit::"Sales-Post", SalesHeader);
        Message(StrSubstNo(OrdersPosted, SalesHeader."No."));
    end;

    procedure FormatAmountCSV(Amt: Decimal): Code[20]
    var
        AmountInTxt: Text[20];
        DecimalsTxt: Text;
    begin
        //AmountInTxt :=FORMAT(ROUND(Amt,0.01),0,'<Integer><Decimals>');
        DecimalsTxt := CopyStr(Format(ROUND(Amt, 0.01), 0, '<Decimals>'), 2);
        if DecimalsTxt <> '' then
            AmountInTxt := Format(Amt, 0, '<Integer>,') + DecimalsTxt
        else
            AmountInTxt := Format(Amt, 0, '<Integer>');
        exit(AmountInTxt);
    end;

    procedure FormatDateCSV(RecDate: Date): Code[14]
    var
        DateInTxt: Text[20];
    begin
        //DateInTxt := Format(RecDate, 0, '<Day,2>/<Month,2>/<Year4>');
        //DateInTxt :=FORMAT(RecDate,0,'<Year4><Month,2><Day,2>');
        DateInTxt := Format(RecDate, 0, '<Year4><Month,2><Day,2>') + '000000';
        exit(DateInTxt);
    end;

    procedure FormatTimeCSV(RecDate: Date; RecTime: Time): Code[14]
    var
        TimeInTxt: Text[20];
    begin
        TimeInTxt := Format(RecDate, 0, '<Year4><Month,2><Day,2>') + Format(RecTime, 0, '<Hour,2><Minutes,2>') + '00';
        exit(TimeInTxt);
    end;

    local procedure CreateCSVFile(var TempBlob: Codeunit "Temp Blob"; FieldToMark: Integer)
    var
        OStream: OutStream;
        Location: Record Location;
        FormatExportFile: Page "Sales Order Lines";
        ShippingInformation: Text;
    begin
        Clear(TempBlob);
        //>> RED 200325 LKA
        //TempBlob.Blob.CREATEOUTSTREAM(OStream);
        TempBlob.CreateOutstream(OStream, Textencoding::Windows);
        //<< RED 200325 LKA
        // Cabecera
        //OStream.WRITETEXT('PO;PO Line No;external doc;Partner;Partner Description;Partner Address;Partner Post Code;Partner Ciry;Partner County;Partner Country;Receipt Date;Item Number;Item Description;Quantity;Unit Of Measure');
        OStream.WriteText('Shipment Nr;Shipment Line Nr;Source Document;Sales Order;Customer;' + 'Customer name;Customer ref.;Item Nr.;Description;Shipment Comments;Units;Unit of Measure Code;QtyCartons;EAN CODE;' + 'Location Code;Shipment Date;Address;City;Contact;Phone Numb;Country;ZIP Code;Province;E-mail;' + 'Exported to CSV Date;Delivery Date;Vendor;Customer Order;Reference');
        //REPEAT
        CLEAR(ShippingInformation);
        SalesHeader.RESET;
        SalesHeader.SETRANGE("No.", SalesLine."Document No.");
        IF SalesHeader.FINDFIRST THEN BEGIN
            ShippingInformation := FORMAT(SalesHeader."Ship-to Address") + ';' + SalesHeader."Ship-to City" + ';' + SalesHeader."Ship-to Contact" + ';' + '' + ';' + //Telefono
            SalesHeader."Ship-to Country/Region Code" + ';' + SalesHeader."Ship-to Post Code" + ';' + SalesHeader."Ship-to County" + ';' + '' + ';' //E-Mail    
        END;
        ShiptoAddress.Reset;
        ShiptoAddress.SetRange("Customer No.", SalesHeader."Sell-to Customer No.");
        ShiptoAddress.SetRange(Code, SalesHeader."Ship-to Code");
        IF ShiptoAddress.FINDFIRST THEN BEGIN
            ShippingInformation := FORMAT(ShiptoAddress.Address) + ';' + ShiptoAddress.City + ';' + ShiptoAddress.Contact + ';' + FORMAT(ShiptoAddress."Phone No.") + ';' + ShiptoAddress."Country/Region Code" + ';' + ShiptoAddress."Post Code" + ';' + ShiptoAddress.County + ';' + ShiptoAddress."E-Mail" + ';';
        END;
        repeat //>> 29/06/2023 EAN13 (Unidad de medidad = UNID) desde Item Identifier
            //  ItemCrossReference.RESET;
            //  ItemCrossReference.SETRANGE("Item No.","No.");
            //  ItemCrossReference.SETRANGE("Unit of Measure",'UNID');
            //  ItemCrossReference.SETRANGE(ItemCrossReference."Cross-Reference Type",ItemCrossReference."Cross-Reference Type"::"Bar Code");
            //  IF ItemCrossReference.FINDFIRST THEN;
            ItemIdentifier.RESET;
            ItemIdentifier.SETRANGE("Item No.", SalesLine."No.");
            ItemIdentifier.SETRANGE("Unit of Measure Code", 'UNID');
            IF ItemIdentifier.FINDFIRST THEN //<<
                ItemCrossReferenceCust.Reset;
            ItemCrossReferenceCust.SetRange("Item No.", SalesLine."No.");
            ItemCrossReferenceCust.SetRange("Unit of Measure", 'UNID');
            ItemCrossReferenceCust.SetRange(ItemCrossReferenceCust."Reference Type", ItemCrossReferenceCust."reference type"::Customer);
            ItemCrossReferenceCust.SetRange("Reference Type No.", SalesLine."Sell-to Customer No.");
            if ItemCrossReferenceCust.FindFirst then;
            ItemUnitofMeasure.Reset;
            ItemUnitofMeasure.SetRange("Item No.", SalesLine."No.");
            ItemUnitofMeasure.SetRange(Code, 'CAJA');
            if ItemUnitofMeasure.FindFirst then
                QtyCartons := ROUND(SalesLine."Qty. to Ship" / ItemUnitofMeasure."Qty. per Unit of Measure")
            else
                QtyCartons := 0;
            Customer.Reset;
            Customer.Get(SalesHeader."Sell-to Customer No.");
            OStream.WriteText();
            OStream.WriteText(SalesLine."Shipment Nr" + ';' + Format(SalesLine."Shipoment Line Nr") + ';' + 'Sales Order' + ';' + SalesHeader."No." + ';' + SalesHeader."Sell-to Customer No." + ';' + //ShiptoAddress.Name +';'+
            Customer.Name + ';' + Format(ItemCrossReferenceCust."Reference No.") + ';' + SalesLine."No." + ';' + SalesLine.Description + SalesLine."Description 2" + ';' + SalesLine."Shipment Comments" + ';' + FormatAmountCSV(SalesLine."Qty. to Ship") + ';' + // Quantity
            SalesLine."Unit of Measure Code" + ';' + FormatAmountCSV(QtyCartons) + ';' +
            //Boxes
            //>> 29/06/2023 EAN13 (Unidad de medidad = UNID) desde Item Identifier
            //  ItemCrossReference."Cross-Reference No."+';'+
            ItemIdentifier.Code + ';' + //<<
            SalesLine."Location Code" + ';' + FormatDateCSV(TODAY) + ';' +
            // Today
            //<<
            //FORMAT(ShiptoAddress.Address)+';'+
            //ShiptoAddress.City+';'+
            //ShiptoAddress.Contact+';'+
            //FORMAT(ShiptoAddress."Phone No.") +';'+
            //ShiptoAddress."Country/Region Code" +';'+
            //ShiptoAddress."Post Code"+';'+
            //ShiptoAddress.County +';'+
            //ShiptoAddress."E-Mail"+';'+
            ShippingInformation + //<<
            FormatDateCSV(Today) + ';' + // Today
            FormatTimeCSV(SalesHeader."Promised Delivery Date", SalesHeader."Delivery Time") + ';' + // Delivery Date & Time
                        Customer."Our Account No." + ';' + SalesHeader."External Document No." + ';' + SalesHeader.Reference);
            case FieldToMark of
                SalesLine.FieldNo("Exported to CSV"):
                    begin
                        SalesLine.Validate("Exported to CSV", true);
                        SalesLine.Validate("Exported to CSV Date", Today); //"Expected Delivery Date
                    end;
                SalesLine.FieldNo("Exported to Suus"):
                    begin
                        SalesLine.Validate("Exported to Suus", true);
                        SalesLine.Validate("Exported to Suus Datetime", CurrentDatetime);
                    end;
            end;
            SalesLine.Modify;
        until SalesLine.Next = 0;
    end;

    local procedure ShipmentLines()
    var
        SalesLine: Record "Sales Line";
        TempSalesLine: Record "Sales Line" temporary;
        SalesHeader: Record "Sales Header";
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        OrderNo: Code[20];
        ContinueMsg: label 'Do you wish to continue with posting?';
        MultipleOrdersErr: label 'You cannot select lines from multiple orders at the same time. Select lines from one order only to continue';
        NoLinesToPostErr: label 'There is nothing to post';
        OrdersPosted: label 'Order %1 posted';
        NoReleased: Label 'The sales order has not been released';
    begin
        if not Confirm(ContinueMsg) then
            Clear(SalesLine);
        TempSalesLine.Reset;
        TempSalesLine.DeleteAll(false);

        CurrPage.SetSelectionFilter(SalesLine);
        SalesLine.SetFilter("Qty. to Ship", '<>0');
        if not SalesLine.FindSet then
            Error(NoLinesToPostErr);

        repeat
            if OrderNo = '' then
                OrderNo := SalesLine."Document No.";

            if OrderNo <> SalesLine."Document No." then
                Error(MultipleOrdersErr);

            Clear(TempSalesLine);
            TempSalesLine := SalesLine;
            TempSalesLine.Insert(false);
        until SalesLine.Next = 0;

        SalesHeader.Reset;
        SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
        if SalesHeader.Status <> SalesHeader.Status::Released then
            Error(NoReleased);

        SalesLine.Reset;
        SalesLine.SetRange("Document Type", TempSalesLine."Document Type");
        SalesLine.SetRange("Document No.", TempSalesLine."Document No.");
        SalesLine.FindSet;
        repeat
            SalesLine.Validate("Qty. to Ship", 0);
            SalesLine.Modify;
        until SalesLine.Next = 0;

        TempSalesLine.Reset;
        TempSalesLine.FindSet;
        repeat
            SalesLine.Reset;
            SalesLine.Get(TempSalesLine."Document Type", TempSalesLine."Document No.", TempSalesLine."Line No.");
            SalesLine.Validate("Qty. to Ship", TempSalesLine."Qty. to Ship");
            SalesLine.Modify;
        until TempSalesLine.Next = 0;

        SalesHeader.Ship := true;
        SalesHeader.Invoice := false;
        SalesHeader.Receive := false;

        Codeunit.Run(Codeunit::"Sales-Post", SalesHeader);

        Message(StrSubstNo(OrdersPosted, SalesHeader."No."));
    end;

    local procedure ExporSelectedToXBS()
    var
        TempBlob: codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        OStream: OutStream;
    begin
        CurrPage.SetSelectionFilter(Rec);
        Rec.SetRange("Exported to CSV", false);
        if not Rec.FindSet then
            Error('No lines selected to export');

        if not Confirm('Do you want to export the shipment Nr. ' + Format(Rec."Shipment Nr") + ' to XBS?') then
            Error('');

        CreateCSVFileXBS(Rec."Shipment Nr", TempBlob);

        FileManagement.BLOBExport(TempBlob, 'Order Sales XBS-' + Rec."Shipment Nr" + '  ' + Format(Today, 7, '<Day,2><Month,2><Year,2>') + '.csv', true);

    end;

    local procedure CreateCSVFileXBS(pShipmentNr: Code[20]; var TempBlob: Codeunit "Temp Blob")
    var
        rSalesHeader: Record "Sales Header";
        rSalesLine: Record "Sales Line";
        rSalesLineAux: Record "Sales Line";
        rShiptoAddress: Record "Ship-to Address";
        OStream: OutStream;
        FormatExportFile: Page "Sales Order Lines";
        TextAddress: Text;
        TextLine1: Text;
        TextLine2: Text;
        TextLine3: Text;
        ShippingInformation: Text;
        CrLf: text[2];
        ii: Integer;
        iItems: Integer;
        isFound: Boolean;
        iQuantity: Integer;
        CurrencyCode: Code[10];
        SalesOrdeAnt: Code[20];
        ShipmentDate: Date;
        ItemMatrix: array[200] of Text[20];
    begin
        Clear(ShipmentDate);
        Clear(ii);
        Clear(iItems);
        Clear(isFound);

        Clear(CrLf);    //Salto de linea
        CrLf[1] := 13;
        CrLf[2] := 10;

        Clear(TempBlob);
        TempBlob.CreateOutstream(OStream, Textencoding::Windows);

        //Leer la Selección de lineas del envío
        rSalesLine.Reset();
        rSalesLine.SetRange("Shipment Nr", pShipmentNr);
        rSalesLine.SetRange("Exported to CSV", false);
        If not rSalesLine.FindSet() then
            Error('No lines selected to export');

        // Comprobaciones previas
        rSalesLine.Reset();
        rSalesLine.SetRange("Shipment Nr", pShipmentNr);
        rSalesLine.SetRange("Exported to CSV", false);
        rSalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        if rSalesLine.FindSet() then
            repeat
                if format(ShipmentDate) = '' then   // Control de fechas de envio. unificadas para todos los pedidos/lineas
                    ShipmentDate := rSalesLine."Shipment Date"
                else
                    if ShipmentDate <> rSalesLine."Shipment Date" then
                        Error('Different shipmment dates in Shipment Nr. %1. The dates need to be unified.', pShipmentNr);

            until rSalesLine.Next() = 0
        else                                        // No existen lineas seleccionadas
            Error('No lines selected to export');

        //Leer la Selección de lineas del envío
        rSalesLine.Reset();
        rSalesLine.SetRange("Shipment Nr", pShipmentNr);
        rSalesLine.SetRange("Exported to CSV", false);
        If not rSalesLine.FindSet() then
            Error('No lines selected to export');

        // Montamos la cabecera 
        Clear(TextAddress);
        /*TextAddress := 'Order Number;Definition;Logical Warehouse;Contractor;Goods Owner;Shipping Method;' +
                    'Courier Service Name;Planned Shipping Date;Priority;External Identifier;' +
                    'Recipient Name;Street;House Number;Apartment Number;Postal Code;City;Country;Recipient Name;Recipient Surname;Recipient Email;Recipient Phone Number;' +
                    'Document Notes;Warehouse Notes;Application Notes;ROD;Saturday Delivery;Personal Collection;COD Amount;Insurance Amount;Currency symbol';*/
        TextAddress := 'Numer zamówienia;Definicja;Symbol magazynu logicznego;KONTRAHENT kod;Kod właściciela towaru;Kod sposobu wysyłki;' +
                    'Nazwa usługi kurierskiej;Planowana data wysyłki;Priorytet;Zewnętrzny identyfikator;' +
                    'Nazwa odbiorcy;Ulica;Numer domu;Numer lokalu;Kod pocztowy;Miasto;Kod kraju;Imię odbiorcy;Nazwisko odbiorcy;Email odbiorcy;Telefon kontaktowy odbiorcy;' +
                    'Uwagi do dokumentu;Uwagi dla magazynu;Uwagi do wysyłki;ROD;Dostawa w sobotę;Odbiór osobisty;Kwota ubezpieczenia;Kwota COD (Przesyłka pobraniowa);Symbol waluty';

        //Buscamos y contamos el pedido con más lineas
        /* VERSION ANTERIOR PARA BORRAR 
        Clear(iLines);
        rSalesLine.Reset();
        rSalesLine.SetRange("Shipment Nr", pShipmentNr);
        rSalesLine.SetRange("Exported to CSV", false);
        rSalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        if rSalesLine.FindSet() then
            repeat
                if SalesOrdeAnt <> rSalesLine."Document No." then begin
                    rSalesLineAux.Reset();
                    rSalesLineAux.SetRange("Shipment Nr", pShipmentNr);
                    rSalesLineAux.SetRange("Exported to CSV", false);
                    rSalesLineAux.SetRange("Document No.", rSalesLine."Document No.");
                    rSalesLineAux.SetCurrentKey("Document Type", "Document No.", "Line No.");
                    if rSalesLineAux.FindSet() then
                        repeat
                            if iLines < rSalesLineAux.Count then
                                iLines := rSalesLineAux.Count;
                        until rSalesLineAux.Next() = 0;
                    SalesOrdeAnt := rSalesLine."Document No.";
                end;
            until rSalesLine.Next() = 0;
        VERSION ANTERIOR PARA BORRAR  */

        //Buscamos los productos de las lineas de los pedidos y los anotamos en la matriz.
        rSalesLine.Reset();
        rSalesLine.SetRange("Shipment Nr", pShipmentNr);
        rSalesLine.SetRange("Exported to CSV", false);
        rSalesLine.SetRange(Type, rSalesLine.Type::Item);
        rSalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        if rSalesLine.FindSet() then
            repeat
                isFound := false;
                for ii := 1 to iItems do
                    if ItemMatrix[ii] = format(rSalesLine."No.") then
                        isFound := true;

                if not isFound then begin
                    iItems += 1;
                    ItemMatrix[iItems] := format(rSalesLine."No.");
                end;
            until rSalesLine.Next() = 0;

        // Se añaden tantas columnas como lineas del pedido que más tiene.
        for ii := 1 to iItems do
            /*TextAddress := TextAddress + ';Product Column ' + Format(ii);*/
            TextAddress := TextAddress + ';DANE_PIONOWO' + Format(ii);

        OStream.WriteText(TextAddress + CrLf);

        //Ciclo de las lineas con el código del producto
        Clear(TextLine1);   // Linea Producto
        Clear(TextLine2);   // Linea FIFO
        TextLine1 := ';;;;;;' + ';;;;' + ';;;;;;;;;;;' + ';;;;;;;;;';
        TextLine2 := TextLine1;

        for ii := 1 to iItems do begin
            TextLine1 := TextLine1 + ItemMatrix[ii] + ';';
            TextLine2 := TextLine2 + 'FIFO' + ';';
        end;

        OStream.WriteText(TextLine1 + CrLf);
        OStream.WriteText(TextLine2 + CrLf);

        //Ciclo de lineas para cada pedido diferente
        Clear(SalesOrdeAnt);
        rSalesLine.Reset();
        rSalesLine.SetRange("Shipment Nr", pShipmentNr);
        rSalesLine.SetRange("Exported to CSV", false);
        rSalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        if rSalesLine.FindSet() then
            repeat
                //Ruptura para cada pedido de venta
                if SalesOrdeAnt <> rSalesLine."Document No." then begin
                    // Formateamos la dirección de Entrega 
                    Clear(ShippingInformation);
                    rSalesHeader.Reset();
                    rSalesHeader.SetRange("No.", rSalesLine."Document No.");
                    if rSalesHeader.FindFirst() then begin
                        ShippingInformation := FormatTextCSV(rSalesHeader."Sell-to Customer Name") + ';' +
                                                FormatTextCSV(rSalesHeader."Sell-to Address") + ';' + ';;' +
                                                FormatTextCSV(rSalesHeader."Sell-to Post Code") + ';' +
                                                FormatTextCSV(rSalesHeader."Sell-to City") + ';' +
                                                FormatTextCSV(rSalesHeader."Sell-to Country/Region Code") + ';' +
                                                FormatTextCSV(rSalesHeader."Sell-to Customer Name") + ';' +
                                                FormatTextCSV(rSalesHeader."Sell-to Contact") + ';' +
                                                FormatTextCSV(rSalesHeader."Sell-to E-Mail") + ';' +
                                                FormatTextCSV(rSalesHeader."Sell-to Phone No.") + ';';
                    end;
                    rShiptoAddress.Reset;
                    rShiptoAddress.SetRange("Customer No.", rSalesHeader."Sell-to Customer No.");
                    rShiptoAddress.SetRange(Code, rSalesHeader."Ship-to Code");
                    if rShiptoAddress.FindFirst() then begin
                        ShippingInformation := FormatTextCSV(rSalesHeader."Sell-to Customer Name") + ';' +
                                                FormatTextCSV(rSalesHeader."Ship-to Address") + ';' + ';;' +
                                                FormatTextCSV(rSalesHeader."Ship-to Post Code") + ';' +
                                                FormatTextCSV(rSalesHeader."Ship-to City") + ';' +
                                                FormatTextCSV(rSalesHeader."Ship-to Country/Region Code") + ';' +
                                                FormatTextCSV(rSalesHeader."Ship-to Name") + ';' +
                                                FormatTextCSV(rSalesHeader."Ship-to Contact") + ';' +
                                                FormatTextCSV(rSalesHeader."Sell-to E-Mail") + ';' +
                                                FormatTextCSV(rSalesHeader."Ship-to Phone No.") + ';';
                    end;
                    // Moneda del pedido
                    CurrencyCode := rSalesHeader."Currency Code";
                    if Format(CurrencyCode) = '' then
                        CurrencyCode := 'EUR';

                    Clear(TextLine3);

                    // Datos del documento de Envio Almacén
                    TextLine3 := Format(rSalesLine."Document No.") + ';' + 'WZ;1111;1111_0001;1111_0001;DPD_Turkus;' +
                                Format(rSalesHeader."Shipment Method Code") + ';' + Format(ShipmentDate) + ';;' + Format(rSalesLine."Shipment Nr") + ';' +
                                ShippingInformation +
                                ';;;;;;;;' + Format(CurrencyCode) + ';';

                    // Ciclo para las cantidades del pedido
                    for ii := 1 to iItems do begin
                        clear(iQuantity);
                        rSalesLineAux.Reset();
                        rSalesLineAux.SetRange("Shipment Nr", pShipmentNr);
                        rSalesLineAux.SetRange("Exported to CSV", false);
                        rSalesLineAux.SetRange("Document No.", rSalesLine."Document No.");
                        rSalesLineAux.SetRange(Type, rSalesLine.Type::Item);
                        rSalesLineAux.SetRange("No.", Format(ItemMatrix[ii]));
                        rSalesLineAux.SetCurrentKey("Document Type", "Document No.", "Line No.");
                        if rSalesLineAux.FindSet() then
                            repeat
                                iQuantity := iQuantity + rSalesLineAux."Qty. to Ship";      // Se guarda la cantidad de ese producto en el pedido
                            until rSalesLineAux.Next() = 0;
                        if iQuantity <> 0 then
                            TextLine3 := TextLine3 + Format(iQuantity) + ';'
                        else
                            TextLine3 := TextLine3 + ';'
                    end;
                    OStream.WriteText(TextLine3 + CrLf);

                    SalesOrdeAnt := rSalesLine."Document No.";
                end;
            until rSalesLine.Next() = 0;


        /* VERSION ANTERIOR PARA BORRAR 
                Clear(SalesOrdeAnt);
                //Montamos las lineas del envío seleccionado
                rSalesLine.Reset();
                rSalesLine.SetRange("Shipment Nr", pShipmentNr);
                rSalesLine.SetRange("Exported to CSV", false);
                rSalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
                if rSalesLine.FindSet() then
                    repeat
                        //Ruptura para cada pedido de venta
                        if SalesOrdeAnt <> rSalesLine."Document No." then begin
                            // Formateamos la dirección de Entrega 
                            Clear(ShippingInformation);
                            rSalesHeader.Reset();
                            rSalesHeader.SetRange("No.", rSalesLine."Document No.");
                            if rSalesHeader.FindFirst() then begin
                                ShippingInformation := FormatTextCSV(rSalesHeader."Sell-to Customer Name") + ';' +
                                                        FormatTextCSV(rSalesHeader."Sell-to Address") + ';' + ';;' +
                                                        FormatTextCSV(rSalesHeader."Sell-to Post Code") + ';' +
                                                        FormatTextCSV(rSalesHeader."Sell-to City") + ';' +
                                                        FormatTextCSV(rSalesHeader."Sell-to Country/Region Code") + ';' +
                                                        FormatTextCSV(rSalesHeader."Sell-to Customer Name") + ';' +
                                                        FormatTextCSV(rSalesHeader."Sell-to Contact") + ';' +
                                                        FormatTextCSV(rSalesHeader."Sell-to E-Mail") + ';' +
                                                        FormatTextCSV(rSalesHeader."Sell-to Phone No.") + ';';
                            end;
                            rShiptoAddress.Reset;
                            rShiptoAddress.SetRange("Customer No.", rSalesHeader."Sell-to Customer No.");
                            rShiptoAddress.SetRange(Code, rSalesHeader."Ship-to Code");
                            if rShiptoAddress.FindFirst() then begin
                                ShippingInformation := FormatTextCSV(rSalesHeader."Sell-to Customer Name") + ';' +
                                                        FormatTextCSV(rSalesHeader."Ship-to Address") + ';' + ';;' +
                                                        FormatTextCSV(rSalesHeader."Ship-to Post Code") + ';' +
                                                        FormatTextCSV(rSalesHeader."Ship-to City") + ';' +
                                                        FormatTextCSV(rSalesHeader."Ship-to Country/Region Code") + ';' +
                                                        FormatTextCSV(rSalesHeader."Ship-to Name") + ';' +
                                                        FormatTextCSV(rSalesHeader."Ship-to Contact") + ';' +
                                                        FormatTextCSV(rSalesHeader."Sell-to E-Mail") + ';' +
                                                        FormatTextCSV(rSalesHeader."Ship-to Phone No.") + ';';
                            end;
                            // Moneda del pedido
                            CurrencyCode := rSalesHeader."Currency Code";
                            if Format(CurrencyCode) = '' then
                                CurrencyCode := 'EUR';

                            Clear(TextLine1);
                            Clear(TextLine2);
                            Clear(TextLine3);

                            // Datos del documento de Envio Almacén
                            TextLine1 := Format(rSalesLine."Document No.") + ';' + 'WZ;1111;1111_0001;1111_0001;DPD_Turkus;' +
                                            ';' + Format(ShipmentDate) + ';;' + Format(rSalesLine."Shipment Nr") + ';' +
                                            ShippingInformation +
                                            ';;;;;;;;' + Format(CurrencyCode) + ';';
                            TextLine2 := ';;;;;;' + ';;;;' + ';;;;;;;;;;;' + ';;;;;;;;;';
                            TextLine3 := TextLine2;

                            // Ciclo para las lineas del mismo pedido
                            rSalesLineAux.Reset();
                            rSalesLineAux.SetRange("Shipment Nr", pShipmentNr);
                            rSalesLineAux.SetRange("Exported to CSV", false);
                            rSalesLineAux.SetRange("Document No.", rSalesLine."Document No.");
                            rSalesLineAux.SetCurrentKey("Document Type", "Document No.", "Line No.");
                            if rSalesLineAux.FindSet() then
                                repeat
                                    //Datos de las lineas del pedido
                                    TextLine1 := TextLine1 + Format(rSalesLineAux."No.") + ';';
                                    TextLine2 := TextLine2 + 'FIFO' + ';';
                                    TextLine3 := TextLine3 + Format(rSalesLineAux."Qty. to Ship") + ';';
                                until rSalesLineAux.Next() = 0;

                            OStream.WriteText(TextLine1 + CrLf);
                            OStream.WriteText(TextLine2 + CrLf);
                            OStream.WriteText(TextLine3 + CrLf);

                            SalesOrdeAnt := rSalesLine."Document No.";
                        end;
                    until rSalesLine.Next() = 0;
         VERSION ANTERIOR PARA BORRAR */

        //Por último marcamos las lineas del envio seleccionado como ya exportadas
        rSalesLine.Reset();
        rSalesLine.SetRange("Shipment Nr", pShipmentNr);
        rSalesLine.SetRange("Exported to CSV", false);
        if rSalesLine.FindSet() then begin
            repeat
                rSalesLine.Validate("Exported to CSV", true);
                rSalesLine.Validate("Exported to CSV Date", Today);
            ///////rSalesLine.Modify();
            until rSalesLine.Next = 0;
        end;
    end;

    local procedure FormatTextCSV(pText: Text): Text
    begin
        exit(Format(ConvertStr(pText, ';', ',')));
    end;
}
