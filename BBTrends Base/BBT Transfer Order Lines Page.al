Page 50080 "Transfer Order Lines"
{
    Caption = 'Transfer Order Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Transfer Line";
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    TableRelation = "Transfer Header" where("No."=field("Document No."));
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Item.Description)
                {
                    ApplicationArea = Basic;
                }
                field(EAN13; ItemCrossReference."Reference No.")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date"; TransferHeader."Posting Date")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        TransferHeader2.Reset;
                        TransferHeader2.SetRange("No.", Rec."Document No.");
                        if TransferHeader2.FindFirst then begin
                            TransferHeader2.Validate("Posting Date", TransferHeader."Posting Date");
                            TransferHeader2.Modify;
                        end;
                        CurrPage.Update;
                    end;
                }
                field("Qty. to Ship"; Rec."Qty. to Ship")
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
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    ApplicationArea = Basic;
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shipment Method"; ShipmentMethod.Description)
                {
                    ApplicationArea = Basic;
                }
                field("Exported to Suus"; Rec."Exported to Suus")
                {
                    ApplicationArea = Basic;
                }
                field("Exported to Suus Datetime"; Rec."Exported to Suus Datetime")
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
        }
    }
    trigger OnAfterGetRecord()
    begin
        UpdateData;
    end;
    var Item: Record Item;
    TransferHeader: Record "Transfer Header";
    ItemCrossReference: Record "Item Reference";
    ShipmentMethod: Record "Transport Method";
    TransferHeader2: Record "Transfer Header";
    QtyCartons: Decimal;
    ItemUnitofMeasure: Record "Item Unit of Measure";
    CartonDec: Text[30];
    TransferLine: Record "Transfer Line";
    local procedure UpdateData()
    begin
        ItemUnitofMeasure.Reset;
        ItemUnitofMeasure.SetRange("Item No.", Rec."Item No.");
        ItemUnitofMeasure.SetRange(Code, 'BOX');
        if ItemUnitofMeasure.FindFirst then QtyCartons:=ROUND(Rec."Qty. to Ship" / ItemUnitofMeasure."Qty. per Unit of Measure")
        else
            QtyCartons:=0;
        CartonDec:='Standard';
        if QtyCartons <> ROUND(QtyCartons, 1)then CartonDec:='Unfavorable';
        ItemCrossReference.Reset;
        ItemCrossReference.SetRange("Item No.", Rec."Item No.");
        ItemCrossReference.SetRange("Unit of Measure", 'PCS');
        ItemCrossReference.SetRange(ItemCrossReference."Reference Type", ItemCrossReference."reference type"::"Bar Code");
        if ItemCrossReference.FindFirst then;
        Item.SetRange("No.", Rec."Item No.");
        if Item.FindFirst then;
        TransferHeader.SetRange("No.", Rec."Document No.");
        if TransferHeader.FindFirst then;
        ShipmentMethod.Reset;
        ShipmentMethod.SetRange(Code, TransferHeader."Transport Method");
        if ShipmentMethod.FindFirst then;
    end;
    local procedure ExporSelectedToCSV()
    var
        TempBlob: codeunit "Temp Blob";
        Text50000: label 'No lines selected to export';
        Text50001: label 'Do you want to export %1 lines?';
        FileManagement: Codeunit "File Management";
    begin
        CurrPage.SetSelectionFilter(TransferLine);
        TransferLine.SetRange("Exported to CSV", false);
        if not TransferLine.FindSet then Error(Text50000);
        if not Confirm('Do you want to export ' + Format(TransferLine.Count) + ' lines to CSV?')then Error('');
        CreateCSVFile(TempBlob, TransferLine.FieldNo("Exported to CSV"));
        FileManagement.BLOBExport(TempBlob, 'Transfer Number' + TransferLine."Document No." + ' ' + Format(Today, 0, '<Day,2><Month,2><Year,2>') + '.csv', true);
    end;
    local procedure ExportSelectedToFTP()
    var
        TempBlob: Codeunit "Temp Blob";
        Text50000: label 'No lines selected to export';
        Text50001: label 'Do you want to export %1 lines?';
        PurchaseOrderLines: Page "Purchase Order Lines";
    begin
        CurrPage.SetSelectionFilter(TransferLine);
        TransferLine.SetRange("Exported to Suus", false);
        if not TransferLine.FindSet then Error(Text50000);
        if not Confirm('Desea subir ' + Format(TransferLine.Count) + ' líneas al FTP?')then Error('');
        CreateCSVFile(TempBlob, TransferLine.FieldNo("Exported to Suus"));
        //FileManagement.BLOBExport(TempBlob,'PO Lines '+"Receipt Nr"+'  '+FORMAT(TODAY,0,'<Day,2><Month,2><Year,2>')+'.csv',TRUE);
        PurchaseOrderLines.UploadFileFTP(TempBlob, 'Transfer Number' + TransferLine."Document No." + ' ' + Format(Today, 0, '<Day,2><Month,2><Year,2>') + '.csv');
    end;
    local procedure CreateCSVFile(var TempBlob: Codeunit "Temp Blob"; FieldToMark: Integer)
    var
        OStream: OutStream;
        Location: Record Location;
        FormatExportFile: Page "Sales Order Lines";
    begin
        Clear(TempBlob);
        //TempBlob.Blob.CREATEOUTSTREAM(OStream);
        TempBlob.CreateOutstream(OStream, Textencoding::UTF8);
        // Cabecera
        OStream.WriteText('Document No.;Item No.;Item Description;EAN13;reception date;Quantity pending;' + 'Transfer-from Code;Transfer-to Code;Place;Transfer-to Address;Transfer-to Post Code;' + 'Transfer-to City;Transfer-to County;Transfer-to Country/Region Code;Shipment Method;Exported to File Date');
        repeat ItemCrossReference.Reset;
            ItemCrossReference.SetRange("Item No.", Rec."Item No.");
            ItemCrossReference.SetRange("Unit of Measure", 'PCS');
            ItemCrossReference.SetRange(ItemCrossReference."Reference Type", ItemCrossReference."reference type"::"Bar Code");
            if ItemCrossReference.FindFirst then;
            TransferHeader.Reset;
            TransferHeader.SetRange("No.", TransferLine."Document No.");
            if TransferHeader.FindFirst then;
            ShipmentMethod.Reset;
            ShipmentMethod.SetRange(Code, TransferHeader."Transport Method");
            if ShipmentMethod.FindFirst then;
            Location.Reset;
            Location.SetRange(Location.Code, TransferLine."Transfer-to Code");
            if Location.FindFirst then;
            OStream.WriteText();
            OStream.WriteText(TransferLine."Document No." + ';' + TransferLine."Item No." + ';' + // Item Number
 TransferLine.Description + ';' + // Item Description
 ItemCrossReference."Reference No." + ';' + // EAN13
 FormatExportFile.FormatDateCSV(TransferHeader."Posting Date") + ';' + // Posting Date
 FormatExportFile.FormatAmountCSV(TransferLine."Qty. to Ship") + ';' + // Quantity
 TransferHeader."Transfer-from Code" + ';' + //Transfer-from Code
 TransferHeader."Transfer-to Code" + ';' + // Transfer-to Code
 Location.Place + ';' + TransferHeader."Transfer-to Address" + ' ' + TransferHeader."Transfer-to Address 2" + ';' + TransferHeader."Transfer-to Post Code" + ';' + TransferHeader."Transfer-to City" + ';' + TransferHeader."Transfer-to County" + ';' + TransferHeader."Trsf.-to Country/Region Code" + ';' + ShipmentMethod.Description + ';' + FormatExportFile.FormatDateCSV(Today)); // Today
            case FieldToMark of TransferLine.FieldNo("Exported to CSV"): begin
                TransferLine.Validate("Exported to CSV", true);
                TransferLine.Validate("Exported to CSV Date", Today); //"Expected Delivery Date
            end;
            TransferLine.FieldNo("Exported to Suus"): begin
                TransferLine.Validate("Exported to Suus", true);
                TransferLine.Validate("Exported to Suus Datetime", CurrentDatetime);
            end;
            end;
            TransferLine.Modify;
        until TransferLine.Next = 0;
    end;
}
