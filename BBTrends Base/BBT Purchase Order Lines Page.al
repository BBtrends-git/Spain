Page 50079 "Purchase Order Lines"
{
    // Caption = 'Líneas pedidos compra';
    Caption = 'Purchase Order Lines';
    Editable = true;
    PageType = List;
    SourceTable = "Purchase Line";
    SourceTableView = where("Document Type" = const(Order), "Buy-from Vendor No." = filter(<> ''), "Qty. to Receive" = filter(<> 0));
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Receipt Nr"; Rec."Receipt Nr")
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                field("Receipt Line Nr"; Rec."Receipt Line Nr")
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                field("Vendor Order No."; PurchaseHeaderAux."Vendor Order No.")
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                field("Posting Date"; PurchaseHeaderAux."Posting Date")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        PurchaseHeaderAux2.Reset;
                        PurchaseHeaderAux2.SetRange(PurchaseHeaderAux2."Document Type", Rec."Document Type");
                        PurchaseHeaderAux2.SetRange(PurchaseHeaderAux2."No.", Rec."Document No.");
                        if PurchaseHeaderAux2.FindFirst then begin
                            PurchaseHeaderAux2.Validate("Posting Date", PurchaseHeaderAux."Posting Date");
                            PurchaseHeaderAux2.Modify;
                        end;
                        // PurchaseLineAux2.RESET;
                        // PurchaseLineAux2.SETRANGE("Document Type","Document Type");
                        // PurchaseLineAux2.SETRANGE("Document No.","Document No.");
                        // PurchaseLineAux2.SETRANGE("Receipt Nr","Receipt Nr");
                        // PurchaseLineAux2.SETFILTER("Line No.",'<>%1',"Line No.");
                        // IF PurchaseLineAux2.FINDSET THEN
                        // REPEAT
                        //  PurchaseLineAux2."Posting Date" := "Posting Date";
                        //  PurchaseLineAux2.MODIFY;
                        // UNTIL PurchaseLineAux2.NEXT=0;
                        CurrPage.Update;
                    end;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                field("Qty. to Receive"; Rec."Qty. to Receive")
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                field("Currrency Code"; PurchaseHeaderAux."Currency Code")
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                field("Amount to Receive"; AmountToReceive)
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                field("Vendor Name"; VendorAux.Name)
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                field("Gross Weight to Receive"; GrossWeightToReceive)
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                field("Boxes to Receive"; BoxesToReceive)
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                field("Container Nr"; Rec."Container Nr")
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                field("Port - POL"; Rec."Port - POL")
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                field("Port - POD"; Rec."Port - POD")
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                field("ETD PO"; Rec."ETD PO")
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                    Visible = false;
                }
                field(ETA; Rec.ETA)
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                //>> Campo Obsoleto
                /*
                field("Expected Delivery Date"; Rec."Expected Delivery Date")
                {
                    ApplicationArea = Basic;
                    StyleExpr = IsReceived;
                }
                */
                //<<
                field("Exported to Suus"; Rec."Exported to Suus")
                {
                    ApplicationArea = Basic;
                }
                field("Exported to Suus Datetime"; Rec."Exported to Suus Datetime")
                {
                    ApplicationArea = Basic;
                }
                //>> Campo Obsoleto
                /*
                field("Container Code"; Rec."Container Code")
                {
                    ApplicationArea = All;
                }
                field("Container Size/Load"; Rec."Container Size/Load")
                {
                    ApplicationArea = All;
                }
                field("Forwarder Code"; Rec."Forwarder Code")
                {
                    ApplicationArea = All;
                }
                field("Forwarder Name"; Rec."Forwarder Name")
                {
                    ApplicationArea = All;
                }
                */
                //<<
                field("Customs Clearance"; Rec."Customs Clearance")
                {
                    ApplicationArea = All;
                }
                field("Docs. to Forwarder"; Rec."Docs. to Forwarder")
                {
                    ApplicationArea = All;
                }
                //>> Campo Obsoleto
                /* Obsoleto
                field(SANIDAD; Rec.SANIDAD)
                {
                    ApplicationArea = All;
                }
                field(LIBERADO; Rec.LIBERADO)
                {
                    ApplicationArea = All;
                }
                field("DEMORA LÍM."; Rec."DEMORA LÍM.")
                {
                    ApplicationArea = All;
                }
                field("Warehouse Upload Date"; Rec."Warehouse Upload Date")
                {
                    ApplicationArea = All;
                }
                */
                //<<
                field("Days in port"; Rec."Days in port")
                {
                    ApplicationArea = All;
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
                    ExportSelectedToCSV;
                end;
            }
            action("Exportar líneas a FTP")
            {
                ApplicationArea = Basic;
                Caption = 'Exportar líneas a FTP';
                Image = LaunchWeb;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ExportSelectedToFTP;
                end;
            }
            action("Create Receipt")
            {
                ApplicationArea = Basic;
                Caption = 'Create Receipt';
                Image = ReceiptLines;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Text50001: label 'There are not lines selected';
                    //>> Obsoleto V27
                    //NoSeriesManagement: Codeunit NoSeriesManagement;
                    NoSeries: Codeunit "No. Series";
                    //<<
                    recNr: Code[20];
                begin
                    PurchasesPayablesSetup.Get;
                    Cont := 0;
                    CurrPage.SetSelectionFilter(PurchLine);
                    if not PurchLine.FindSet then Error(Text50001);
                    //>> V27
                    //recNr := NoSeriesManagement.GetNextNo(PurchasesPayablesSetup."Warehouse Receipt Nos.", Today, true);
                    recNr := NoSeries.GetNextNo(PurchasesPayablesSetup."Warehouse Receipt Nos.", Today);
                    //<<
                    repeat
                        Cont := Cont + 1;
                        PurchLine."Receipt Nr" := recNr;
                        PurchLine."Receipt Line Nr" := Cont;
                        PurchLine.Modify;
                    until PurchLine.Next = 0;
                    Commit;
                end;
            }
            action("Show Order")
            {
                ApplicationArea = Basic;
                Caption = 'Show Order';
                Image = View;
                Promoted = true;
                RunObject = Page "Purchase Order";
                RunPageLink = "Document Type" = field("Document Type"), "No." = field("Document No.");

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SalesShipmentHeader: Record "Sales Shipment Header";
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                begin
                end;
            }
            action("Receive Lines")
            {
                ApplicationArea = Basic;
                Caption = 'Receive Lines';
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = true;

                trigger OnAction()
                begin
                    ReceiveLines;
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        UpdateData;
        IsReceived := 'Standard';
        if Rec."Exported to CSV" then begin
            if Rec."Qty. to Receive" <> 0 then
                IsReceived := 'Unfavorable'
            else
                IsReceived := 'Favorable'
        end;
    end;

    trigger OnOpenPage()
    begin
        //SETRANGE("Exported to CSV",FALSE);
        //ReceiveLinesVisible := COMPANYNAME = 'CRONUS Polska Sp. z o.o.';
    end;

    var
        VendorAux: Record Vendor;
        PurchaseHeaderAux: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        Cont: Integer;
        IsReceived: Text[30];
        ReceiveLinesVisible: Boolean;
        PurchaseHeaderAux2: Record "Purchase Header";
        BoxesToReceive: Decimal;
        ItemUnitofMeasure: Record "Item Unit of Measure";
        GrossWeightToReceive: Decimal;
        AmountToReceive: Decimal;
        PurchaseLineAux2: Record "Purchase Line";

    local procedure ExportSelectedToCSV()
    var
        TempBlob: Codeunit "Temp Blob";
        Location: Record Location;
        PurchaseHeader: Record "Purchase Header";
        FileManagement: Codeunit "File Management";
        OStream: OutStream;
        Text50000: label 'No lines selected to export';
        Text50001: label 'Do you want to export %1 lines?';
        Vendor: Record Vendor;
        FormatExportFile: Page "Sales Order Lines";
        BoxesToReceiveFile: Decimal;
        GrossWeightToReceiveFile: Decimal;
        AmountToReceiveFile: Decimal;
    begin
        CurrPage.SetSelectionFilter(PurchLine);
        PurchLine.SetRange("Exported to CSV", false);
        if not PurchLine.FindSet then Error(Text50000);
        if not Confirm('Do you want to export ' + Format(PurchLine.Count) + ' lines to CSV?') then Error('');
        CreateCSVFile(TempBlob, PurchLine.FieldNo("Exported to CSV"));
        FileManagement.BLOBExport(TempBlob, 'PO Lines ' + Rec."Receipt Nr" + '  ' + Format(Today, 0, '<Day,2><Month,2><Year,2>') + '.csv', true);
    end;

    local procedure ExportSelectedToFTP()
    var
        TempBlob: Codeunit "Temp Blob";
        Location: Record Location;
        PurchaseHeader: Record "Purchase Header";
        FileManagement: Codeunit "File Management";
        OStream: OutStream;
        Text50000: label 'No lines selected to export';
        Text50001: label 'Do you want to export %1 lines?';
        Vendor: Record Vendor;
        FormatExportFile: Page "Sales Order Lines";
        BoxesToReceiveFile: Decimal;
        GrossWeightToReceiveFile: Decimal;
        AmountToReceiveFile: Decimal;
    begin
        CurrPage.SetSelectionFilter(PurchLine);
        PurchLine.SetRange("Exported to Suus", false);
        if not PurchLine.FindSet then Error(Text50000);
        if not Confirm('Desea subir ' + Format(PurchLine.Count) + ' líneas al FTP?') then Error('');
        CreateCSVFile(TempBlob, PurchLine.FieldNo("Exported to Suus"));
        //FileManagement.BLOBExport(TempBlob,'PO Lines '+"Receipt Nr"+'  '+FORMAT(TODAY,0,'<Day,2><Month,2><Year,2>')+'.csv',TRUE);
        UploadFileFTP(TempBlob, 'PO Lines ' + Rec."Receipt Nr" + '  ' + Format(Today, 0, '<Day,2><Month,2><Year,2>') + '.csv');
    end;

    local procedure UpdateData()
    begin
        VendorAux.Reset;
        VendorAux.Get(Rec."Buy-from Vendor No.");
        PurchaseHeaderAux.Reset;
        PurchaseHeaderAux.SetRange("No.", Rec."Document No.");
        if PurchaseHeaderAux.FindFirst then;
        //CALCULATE BOXES
        if Rec.Type = Rec.Type::Item then begin
            //>> SDA 19/01/2023 Quitamos el error para Unidad <> 'UNID'
            //  IF "Unit of Measure Code"<>'UNID' THEN
            //    ERROR('Unit of Measure Code must be UNID')
            //  ELSE BEGIN
            //<<
            ItemUnitofMeasure.Reset;
            ItemUnitofMeasure.SetRange("Item No.", Rec."No.");
            ItemUnitofMeasure.SetRange(Code, 'CAJA');
            if not ItemUnitofMeasure.FindFirst then
                BoxesToReceive := 0
            else
                BoxesToReceive := ROUND(Rec."Qty. to Receive" / ItemUnitofMeasure."Qty. per Unit of Measure", 0.01);
            //>> SDA 19/01/2023
            //  END;
            //<<
            //CALCULATE GROSS WEIGHT
            ItemUnitofMeasure.Reset;
            ItemUnitofMeasure.SetRange(Code, Rec."Unit of Measure Code");
            ItemUnitofMeasure.SetRange("Item No.", Rec."No.");
            if ItemUnitofMeasure.FindFirst then
                GrossWeightToReceive := ItemUnitofMeasure.Weight * Rec."Qty. to Receive"
            else
                GrossWeightToReceive := 0;
            //CALCULATE GROSS WEIGHT
            AmountToReceive := Rec."Qty. to Receive" * Rec."Direct Unit Cost";
        end;
        //CALCULATE BOXES
    end;

    local procedure ReceiveLines()
    var
        PurchaseLine: Record "Purchase Line";
        TempPurchaseLine: Record "Purchase Line" temporary;
        PurchHeader: Record "Purchase Header";
        ReleasePurchDocument: Codeunit "Release Purchase Document";
        OrderNo: Code[20];
        MultipleOrdersErr: label 'You cannot select lines from multiple orders at the same time. Select lines from one order only to continue';
        NoLinesToPostErr: label 'There is nothing to post';
        ContinueMsg: label 'Do you wish to continue with posting?';
        OrdersPosted: label 'Order %1 posted';
    begin
        //ERROR('');
        if not Confirm(ContinueMsg) then Error('');
        Clear(PurchaseLine);
        if not TempPurchaseLine.IsTemporary then Error('Unknown error. Contact your system administrator');
        TempPurchaseLine.Reset;
        TempPurchaseLine.DeleteAll(false);
        CurrPage.SetSelectionFilter(PurchaseLine);
        PurchaseLine.SetFilter("Qty. to Receive", '<>0');
        if not PurchaseLine.FindSet then Error(NoLinesToPostErr);
        repeat
            if OrderNo = '' then OrderNo := PurchaseLine."Document No.";
            if OrderNo <> PurchaseLine."Document No." then Error(MultipleOrdersErr);
            Clear(TempPurchaseLine);
            TempPurchaseLine := PurchaseLine;
            TempPurchaseLine.Insert(false);
        until PurchaseLine.Next = 0;
        PurchaseLine.Reset;
        PurchaseLine.SetRange("Document Type", TempPurchaseLine."Document Type");
        PurchaseLine.SetRange("Document No.", TempPurchaseLine."Document No.");
        PurchaseLine.FindSet;
        repeat
            PurchHeader.Reset;
            PurchHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.");
            if PurchHeader.Status <> PurchHeader.Status::Open then ReleasePurchDocument.PerformManualReopen(PurchHeader);
            PurchaseLine.Validate("Qty. to Receive", 0);
            PurchaseLine.Modify;
        until PurchaseLine.Next = 0;
        TempPurchaseLine.Reset;
        TempPurchaseLine.FindSet;
        repeat
            PurchaseLine.Reset;
            PurchaseLine.Get(TempPurchaseLine."Document Type", TempPurchaseLine."Document No.", TempPurchaseLine."Line No.");
            PurchaseLine.Validate("Qty. to Receive", TempPurchaseLine."Qty. to Receive");
            PurchaseLine.Modify;
        until TempPurchaseLine.Next = 0;
        PurchHeader.Ship := false;
        PurchHeader.Invoice := false;
        PurchHeader.Receive := true;
        Codeunit.Run(Codeunit::"Purch.-Post", PurchHeader);
        Message(StrSubstNo(OrdersPosted, PurchHeader."No."));
    end;

    local procedure CreateCSVFile(var TempBlob: Codeunit "Temp Blob"; FieldToMark: Integer)
    var
        Location: Record Location;
        PurchaseHeader: Record "Purchase Header";
        FileManagement: Codeunit "File Management";
        OStream: OutStream;
        Vendor: Record Vendor;
        FormatExportFile: Page "Sales Order Lines";
        BoxesToReceiveFile: Decimal;
        GrossWeightToReceiveFile: Decimal;
        AmountToReceiveFile: Decimal;
    begin
        Clear(TempBlob);
        TempBlob.CreateOutstream(OStream, Textencoding::UTF8);
        // Cabecera
        OStream.WriteText('Reception Nr;Reception Line Nr;Order Nr;external doc;Item Number;' + 'Item Description;Location Code;Quantity;Unit Of Measure;' + 'Partner;Partner Description;Gross Weight;Ctns;' + 'Container;Port - POL;Port - POD;ETD;ETA;Expected Delivery Date;Unit Price;currency;total price;' + 'Exported to File Date');
        repeat
            PurchaseHeader.Reset;
            PurchaseHeader.SetRange("No.", PurchLine."Document No.");
            if PurchaseHeader.FindFirst then;
            Vendor.Reset;
            Vendor.Get(Rec."Buy-from Vendor No.");
            //CALCULATE BOXES
            if Rec.Type = Rec.Type::Item then begin
                if PurchLine."Unit of Measure Code" <> 'UNID' then
                    Error('Unit of Measure Code must be UNID')
                else begin
                    ItemUnitofMeasure.Reset;
                    ItemUnitofMeasure.SetRange("Item No.", PurchLine."No.");
                    ItemUnitofMeasure.SetRange(Code, 'CAJA');
                    if not ItemUnitofMeasure.FindFirst then
                        BoxesToReceiveFile := 0
                    else
                        BoxesToReceiveFile := ROUND(PurchLine."Qty. to Receive" / ItemUnitofMeasure."Qty. per Unit of Measure", 0.01);
                end;
                //CALCULATE GROSS WEIGHT
                ItemUnitofMeasure.Reset;
                ItemUnitofMeasure.SetRange(Code, PurchLine."Unit of Measure Code");
                ItemUnitofMeasure.SetRange("Item No.", PurchLine."No.");
                if ItemUnitofMeasure.FindFirst then
                    GrossWeightToReceiveFile := ItemUnitofMeasure.Weight * PurchLine."Qty. to Receive"
                else
                    GrossWeightToReceiveFile := 0;
                //CALCULATE GROSS WEIGHT
                AmountToReceiveFile := PurchLine."Qty. to Receive" * PurchLine."Direct Unit Cost";
            end;
            //CALCULATE BOXES
            OStream.WriteText();
            OStream.WriteText(PurchLine."Receipt Nr" + ';' + Format(PurchLine."Receipt Line Nr") + ';' + //Reception Line Nr
            PurchLine."Document No." + ';' + // PO
            PurchaseHeader."Vendor Order No." + ';' + // external doc
            PurchLine."No." + ';' + // Item Number
            PurchLine.Description + PurchLine."Description 2" + ';' + // Item Description
            PurchLine."Location Code" + ';' + //Location Code
            FormatExportFile.FormatAmountCSV(PurchLine."Qty. to Receive") + ';' + // Quantity
            PurchLine."Unit of Measure" + ';' + // Unit Of Measure
            Vendor."No." + ';' + // Partner
            Vendor.Name + ';' + // Partner Description
            FormatExportFile.FormatAmountCSV(GrossWeightToReceiveFile) + ';' + // Gross Weight
            FormatExportFile.FormatAmountCSV(BoxesToReceiveFile) + ';' + // Ctns
            PurchLine."Container Nr" + ';' + // Container Nr
            PurchLine."Port - POL" + ';' + // Port - POL
            PurchLine."Port - POD" + ';' + // Port - POD
            FormatExportFile.FormatDateCSV(PurchLine."ETD PO") + ';' + // ETD
            FormatExportFile.FormatDateCSV(PurchLine.ETA) + ';' + // ETA
            //>> Campo Obsoleto
            //FormatExportFile.FormatDateCSV(PurchLine."Expected Delivery Date") + ';' + //Expected Delivery Date
            FormatExportFile.FormatDateCSV(PurchLine."Expected Receipt Date") + ';' + //Expected Receipt Date
            //<<
            FormatExportFile.FormatAmountCSV(PurchLine."Unit Cost") + ';' + // Unit Cost
            Format('EUR') + ';' + // EUR
            FormatExportFile.FormatAmountCSV(AmountToReceiveFile) + ';' + // Amt
            FormatExportFile.FormatDateCSV(Today));
            case FieldToMark of
                PurchLine.FieldNo("Exported to CSV"):
                    begin
                        PurchLine.Validate("Exported to CSV", true);
                        PurchLine.Validate("Exported to CSV Date", Today);
                    end;
                PurchLine.FieldNo("Exported to Suus"):
                    begin
                        PurchLine.Validate("Exported to Suus", true);
                        PurchLine.Validate("Exported to Suus Datetime", CurrentDatetime);
                    end;
            end;
            PurchLine.Modify;
        until PurchLine.Next = 0;
        //FileManagement.BLOBExport(TempBlob,'PO Lines.csv',TRUE);
    end;

    procedure UploadFileFTP(var TempBlob: Codeunit "Temp Blob"; FileName: Text)
    var
    /*TODO FTP
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        FileManagement: Codeunit "File Management";
        FtpWebRequest: dotnet FtpWebRequest;
        FtpWebResponse: dotnet FtpWebResponse;
        NetworkCredential: dotnet NetworkCredential;
        Stream: dotnet Stream;
        SIOFile: dotnet File;
        StreamReader: dotnet StreamReader;
        StreamWriter: dotnet StreamWriter;
        MyText: dotnet String;
        Values: dotnet Array;
        Match: dotnet Array;
        Separator: dotnet String;
        Enumerator: dotnet IEnumerator;
        Value: Text;
        i: Integer;
        SiteAddress: Text;
        Username: Text;
        Password: Text;
        ServerPath: Text;
        ShowConfirmation: Boolean;
        LocalFile: Text;
        */
    begin
        /*
            SiteAddress
            Username
            Password
            ServerPath
            LocalFile
            ShowConfirmation
            */
        /*
        SalesReceivablesSetup.Reset;
        SalesReceivablesSetup.Get;
        SalesReceivablesSetup.TestField("Suus FTP Username");
        SalesReceivablesSetup.TestField("Suus FTP Password");
        SalesReceivablesSetup.TestField("Suus FTP Server Address");
        ShowConfirmation := false;

        SiteAddress := SalesReceivablesSetup."Suus FTP Server Address";
        ServerPath := SalesReceivablesSetup."Suus FTP Folder";
        Username := SalesReceivablesSetup."Suus FTP Username";
        Password := SalesReceivablesSetup."Suus FTP Password";
        LocalFile := 'C:\NAV\SUUS\' + FileName;
        FileManagement.DeleteServerFile(LocalFile);
        FileManagement.BLOBExportToServerFile(TempBlob, LocalFile);

        Clear(FtpWebRequest);
        FtpWebRequest := FtpWebRequest.Create(SiteAddress + ServerPath + FileName);
        FtpWebRequest.Credentials := NetworkCredential.NetworkCredential(Username, Password);
        FtpWebRequest.Method := 'STOR';
        FtpWebRequest.KeepAlive := false;
        FtpWebRequest.UseBinary := true;
        FtpWebRequest.EnableSsl := false;

        FtpWebRequest.ContentLength := SIOFile.ReadAllBytes(LocalFile).Length;
        Stream := FtpWebRequest.GetRequestStream;
        Stream.Write(SIOFile.ReadAllBytes(LocalFile), 0, FtpWebRequest.ContentLength);
        Stream.Close;

        FtpWebResponse := FtpWebRequest.GetResponse;
        FtpWebRequest.Abort;
        FtpWebResponse.Close;
    */
    end;
}
