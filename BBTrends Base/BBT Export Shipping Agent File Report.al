Report 50005 "Export Shipping Agent File"
{
    // //001 IBER AGI 12/05/16 - P14: Fichero de transportistas
    Caption = 'Export Shipping Agent File', comment = 'ESP="Exportar fichero transportistas"';
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(SalesShipmentFilters; "Sales Shipment Header")
        {
            DataItemTableView = SORTING("Shipping Agent Code", "Posting Date")WHERE("Shipping Agent Code"=filter(>''));
            RequestFilterFields = "Posting Date", "Shipping Agent Code";

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
                SalesSetup.Get;
                SalesSetup.TestField("Agent File Path");
                if SalesShipmentFilters.GetFilter(SalesShipmentFilters."Posting Date") = '' then Error(Text000, SalesShipmentFilters.FieldCaption(SalesShipmentFilters."Posting Date"));
                CurrReport.Break;
            end;
        }
        dataitem("Shipping Agent"; "Shipping Agent")
        {
            DataItemTableView = sorting(Code);

            //ini -  The application object or method 'XXXXXXX' has scope 'OnPrem' and cannot be used for 'Cloud' development.
            // trigger OnAfterGetRecord()
            // begin
            //     if GuiAllowed then
            //     begin
            //       Window.Update(1,"Shipping Agent".Code);
            //       Window.Update(2,'');
            //       Window.Update(3,0);
            //     end;
            //     SalesShipmentHdr.Reset;
            //     SalesShipmentHdr.SetCurrentkey("Shipping Agent Code","Posting Date");
            //     SalesShipmentHdr.CopyFilters(SalesShipmentFilters);
            //     SalesShipmentHdr.SetRange("Shipping Agent Code", "Shipping Agent".Code);
            //     if SalesShipmentHdr.FindSet then
            //     begin
            //       Clear(OutFile);
            //       Clear(ExternalFile);
            //       OutFile.TextMode := true;
            //       OutFile.WriteMode := true;
            //       ExternalFile := FileMgt.ServerTempFileName('');
            //       SilentModeFileName := SalesSetup."Agent File Path" + '\' + "Shipping Agent".Code + Format(Date2dmy(Today,3)) +
            //         PadStr('',2 - StrLen(Format(Date2dmy(Today,2))),'0') + Format(Date2dmy(Today,2)) +
            //         PadStr('',2 - StrLen(Format(Date2dmy(Today,1))),'0') + Format(Date2dmy(Today,1)) + '.txt';
            //       OutFile.Create(ExternalFile,Textencoding::Windows);
            //       CompanyName1 := SalesSetup."Agent File Company Name";
            //       if StrLen(CompanyName1) < MaxStrLen(CompanyName1) then
            //         CompanyName1 := CompanyName1 + PadStr('',MaxStrLen(CompanyName1) - StrLen(CompanyName1),' ');
            //       OutText1 :=  CabFileTxt + CompanyName1 + ExpText + PadStr('',20 - StrLen(ExpText),' ');
            //       OutFile.Write(OutText1);
            //       repeat
            //         if GuiAllowed then
            //         begin
            //           RecNo := 0;
            //           TotalRecNo := SalesShipmentLine.Count;
            //           Window.Update(2, SalesShipmentHdr."No.");
            //           Window.Update(3,0);
            //         end;
            //         TotalWeight := ROUND(SalesShipmentHdr."Total Gross Weight (Actual)",1,'=');
            //         SalesShipmentLine.Reset;
            //         SalesShipmentLine.SetRange("Document No.", SalesShipmentHdr."No.");
            //         SalesShipmentLine.SetRange(Type, SalesShipmentLine.Type::Item);
            //         SalesShipmentLine.SetFilter(Quantity, '>0');
            //         if SalesShipmentLine.FindSet then
            //         begin
            //           CompanyName2 := CopyStr(CompanyInfo.Name,1,MaxStrLen(CompanyName2));
            //           if StrLen(CompanyName2) < MaxStrLen(CompanyName2) then
            //             CompanyName2 := CompanyName2 + PadStr('',MaxStrLen(CompanyName2) - StrLen(CompanyName2),' ');
            //           CompanyAddress := CopyStr(CompanyInfo.Address,1,MaxStrLen(CompanyAddress));
            //           if StrLen(CompanyAddress) < MaxStrLen(CompanyAddress) then
            //             CompanyAddress := CompanyAddress + PadStr('',MaxStrLen(CompanyAddress) - StrLen(CompanyAddress),' ');
            //           CompanyCity := CompanyInfo.City;
            //           if StrLen(CompanyCity) < MaxStrLen(CompanyCity) then
            //             CompanyCity := CompanyCity + PadStr('',MaxStrLen(CompanyCity) - StrLen(CompanyCity),' ');
            //           CompanyPostCode := CopyStr(CompanyInfo."Post Code",1,MaxStrLen(CompanyPostCode));
            //           if StrLen(CompanyPostCode) < MaxStrLen(CompanyPostCode) then
            //             CompanyPostCode := CompanyPostCode + PadStr('',MaxStrLen(CompanyPostCode) - StrLen(CompanyPostCode),' ');
            //           CustomerNbr := CopyStr(SalesShipmentHdr."Sell-to Customer No.",1,MaxStrLen(CustomerNbr));
            //           if StrLen(CustomerNbr) < MaxStrLen(CustomerNbr) then
            //             CustomerNbr := CustomerNbr + PadStr('',MaxStrLen(CustomerNbr) - StrLen(CustomerNbr),' ');
            //           CustomerName := CopyStr(SalesShipmentHdr."Ship-to Name"+' '+ SalesShipmentHdr."Ship-to Name 2",1,MaxStrLen(CustomerName));
            //           if StrLen(CustomerName) < MaxStrLen(CustomerName) then
            //             CustomerName := CustomerName + PadStr('',MaxStrLen(CustomerName) - StrLen(CustomerName),' ');
            //           CustomerAddress := CopyStr(SalesShipmentHdr."Ship-to Address",1,MaxStrLen(CustomerAddress));
            //           if StrLen(CustomerAddress) < MaxStrLen(CustomerAddress) then
            //             CustomerAddress := CustomerAddress + PadStr('',MaxStrLen(CustomerAddress) - StrLen(CustomerAddress),' ');
            //           CustomerCity := SalesShipmentHdr."Ship-to City";
            //           if StrLen(CustomerCity) < MaxStrLen(CustomerCity) then
            //             CustomerCity := CustomerCity + PadStr('',MaxStrLen(CustomerCity) - StrLen(CustomerCity),' ');
            //           CustomerPostCode := CopyStr(SalesShipmentHdr."Ship-to Post Code",1,MaxStrLen(CustomerPostCode));
            //           if StrLen(CustomerPostCode) < MaxStrLen(CustomerPostCode) then
            //             CustomerPostCode := CustomerPostCode + PadStr('',MaxStrLen(CustomerPostCode) - StrLen(CustomerPostCode),' ');
            //           CustomerCountry := SalesShipmentHdr."Ship-to Country/Region Code";
            //           if StrLen(CustomerCountry) < MaxStrLen(CustomerCountry) then
            //             CustomerCountry := CustomerCountry + PadStr('',MaxStrLen(CustomerCountry) - StrLen(CustomerCountry),' ');
            //           CasesNbr := Format(ROUND(SalesShipmentHdr."Number of Packages",1,'<'));
            //           if StrLen(CasesNbr) < MaxStrLen(CasesNbr) then
            //               CasesNbr := PadStr('',MaxStrLen(CasesNbr) - StrLen(CasesNbr),'0') + CasesNbr;
            //           TotalWeightTxt := CopyStr(Format(TotalWeight),1,MaxStrLen(TotalWeightTxt));
            //           if StrLen(TotalWeightTxt) < MaxStrLen(TotalWeightTxt) then
            //               TotalWeightTxt := PadStr('',MaxStrLen(TotalWeightTxt) - StrLen(TotalWeightTxt),'0') + TotalWeightTxt;
            //           ShipmentNo := CopyStr(SalesShipmentHdr."No.",1,MaxStrLen(ShipmentNo));
            //           if StrLen(ShipmentNo) < MaxStrLen(ShipmentNo) then
            //               ShipmentNo := PadStr('',MaxStrLen(ShipmentNo) - StrLen(ShipmentNo),'0') + ShipmentNo;
            //           ReferenceText := CopyStr(SalesShipmentHdr.Reference,1,MaxStrLen(ReferenceText));
            //           if StrLen(ReferenceText) < MaxStrLen(ReferenceText) then
            //             ReferenceText := ReferenceText + PadStr('',MaxStrLen(ReferenceText) - StrLen(ReferenceText),' ');
            //           OutText2 := CompanyName2 + CompanyAddress + CompanyCity + CompanyPostCode + CustomerNbr + CustomerName + CustomerAddress +
            //             CustomerCity + CustomerPostCode + CustomerCountry + CasesNbr + UomText + TotalWeightTxt + ShipmentNo + PadStr('',27,' ') +
            //             EurText + 'P' + PadStr('',76,' ') + ReferenceText + EurText;
            //           OutFile.Write(OutText2);
            //         end;
            //         if GuiAllowed then
            //         begin
            //           RecNo := RecNo + 1;
            //           Window.Update(3,ROUND(RecNo / TotalRecNo * 10000,1));
            //         end;
            //       until SalesShipmentHdr.Next = 0;
            //       if "Shipping Agent".Code='SZENDEX' then
            //       begin
            //         OutText2 := EndFileTxt;
            //         OutFile.Write(OutText2);
            //       end;
            //       OutFile.Close;
            //       FileMgt.CopyServerFile(ExternalFile,SilentModeFileName,true);
            //       FilesExported += 1;
            //     end;
            // end;
            trigger OnAfterGetRecord()
            var
                Data: BigText;
                ins: InStream;
                outs: OutStream;
                TempBLOB: codeunit "Temp Blob";
                filename: Text;
            begin
                TempBLOB.CreateOutStream(outs);
                if GuiAllowed then begin
                    Window.Update(1, "Shipping Agent".Code);
                    Window.Update(2, '');
                    Window.Update(3, 0);
                end;
                SalesShipmentHdr.Reset;
                SalesShipmentHdr.SetCurrentkey("Shipping Agent Code", "Posting Date");
                SalesShipmentHdr.CopyFilters(SalesShipmentFilters);
                SalesShipmentHdr.SetRange("Shipping Agent Code", "Shipping Agent".Code);
                if SalesShipmentHdr.FindSet then begin
                    Clear(Data);
                    SilentModeFileName:="Shipping Agent".Code + Format(Date2dmy(Today, 3)) + PadStr('', 2 - StrLen(Format(Date2dmy(Today, 2))), '0') + Format(Date2dmy(Today, 2)) + PadStr('', 2 - StrLen(Format(Date2dmy(Today, 1))), '0') + Format(Date2dmy(Today, 1)) + '.txt';
                    CompanyName1:=SalesSetup."Agent File Company Name";
                    if StrLen(CompanyName1) < MaxStrLen(CompanyName1)then CompanyName1:=CompanyName1 + PadStr('', MaxStrLen(CompanyName1) - StrLen(CompanyName1), ' ');
                    OutText1:=CabFileTxt + CompanyName1 + ExpText + PadStr('', 20 - StrLen(ExpText), ' ');
                    outs.WriteText(OutText1);
                    outs.WriteText();
                    repeat if GuiAllowed then begin
                            RecNo:=0;
                            TotalRecNo:=SalesShipmentLine.Count;
                            Window.Update(2, SalesShipmentHdr."No.");
                            Window.Update(3, 0);
                        end;
                        TotalWeight:=ROUND(SalesShipmentHdr."Total Gross Weight (Actual)", 1, '=');
                        SalesShipmentLine.Reset;
                        SalesShipmentLine.SetRange("Document No.", SalesShipmentHdr."No.");
                        SalesShipmentLine.SetRange(Type, SalesShipmentLine.Type::Item);
                        SalesShipmentLine.SetFilter(Quantity, '>0');
                        if SalesShipmentLine.FindSet then begin
                            Clear(Data);
                            CompanyName2:=CopyStr(CompanyInfo.Name, 1, MaxStrLen(CompanyName2));
                            if StrLen(CompanyName2) < MaxStrLen(CompanyName2)then CompanyName2:=CompanyName2 + PadStr('', MaxStrLen(CompanyName2) - StrLen(CompanyName2), ' ');
                            CompanyAddress:=CopyStr(CompanyInfo.Address, 1, MaxStrLen(CompanyAddress));
                            if StrLen(CompanyAddress) < MaxStrLen(CompanyAddress)then CompanyAddress:=CompanyAddress + PadStr('', MaxStrLen(CompanyAddress) - StrLen(CompanyAddress), ' ');
                            CompanyCity:=CompanyInfo.City;
                            if StrLen(CompanyCity) < MaxStrLen(CompanyCity)then CompanyCity:=CompanyCity + PadStr('', MaxStrLen(CompanyCity) - StrLen(CompanyCity), ' ');
                            CompanyPostCode:=CopyStr(CompanyInfo."Post Code", 1, MaxStrLen(CompanyPostCode));
                            if StrLen(CompanyPostCode) < MaxStrLen(CompanyPostCode)then CompanyPostCode:=CompanyPostCode + PadStr('', MaxStrLen(CompanyPostCode) - StrLen(CompanyPostCode), ' ');
                            CustomerNbr:=CopyStr(SalesShipmentHdr."Sell-to Customer No.", 1, MaxStrLen(CustomerNbr));
                            if StrLen(CustomerNbr) < MaxStrLen(CustomerNbr)then CustomerNbr:=CustomerNbr + PadStr('', MaxStrLen(CustomerNbr) - StrLen(CustomerNbr), ' ');
                            CustomerName:=CopyStr(SalesShipmentHdr."Ship-to Name" + ' ' + SalesShipmentHdr."Ship-to Name 2", 1, MaxStrLen(CustomerName));
                            if StrLen(CustomerName) < MaxStrLen(CustomerName)then CustomerName:=CustomerName + PadStr('', MaxStrLen(CustomerName) - StrLen(CustomerName), ' ');
                            CustomerAddress:=CopyStr(SalesShipmentHdr."Ship-to Address", 1, MaxStrLen(CustomerAddress));
                            if StrLen(CustomerAddress) < MaxStrLen(CustomerAddress)then CustomerAddress:=CustomerAddress + PadStr('', MaxStrLen(CustomerAddress) - StrLen(CustomerAddress), ' ');
                            CustomerCity:=SalesShipmentHdr."Ship-to City";
                            if StrLen(CustomerCity) < MaxStrLen(CustomerCity)then CustomerCity:=CustomerCity + PadStr('', MaxStrLen(CustomerCity) - StrLen(CustomerCity), ' ');
                            CustomerPostCode:=CopyStr(SalesShipmentHdr."Ship-to Post Code", 1, MaxStrLen(CustomerPostCode));
                            if StrLen(CustomerPostCode) < MaxStrLen(CustomerPostCode)then CustomerPostCode:=CustomerPostCode + PadStr('', MaxStrLen(CustomerPostCode) - StrLen(CustomerPostCode), ' ');
                            CustomerCountry:=SalesShipmentHdr."Ship-to Country/Region Code";
                            if StrLen(CustomerCountry) < MaxStrLen(CustomerCountry)then CustomerCountry:=CustomerCountry + PadStr('', MaxStrLen(CustomerCountry) - StrLen(CustomerCountry), ' ');
                            CasesNbr:=Format(ROUND(SalesShipmentHdr."Number of Packages", 1, '<'));
                            if StrLen(CasesNbr) < MaxStrLen(CasesNbr)then CasesNbr:=PadStr('', MaxStrLen(CasesNbr) - StrLen(CasesNbr), '0') + CasesNbr;
                            TotalWeightTxt:=CopyStr(Format(TotalWeight), 1, MaxStrLen(TotalWeightTxt));
                            if StrLen(TotalWeightTxt) < MaxStrLen(TotalWeightTxt)then TotalWeightTxt:=PadStr('', MaxStrLen(TotalWeightTxt) - StrLen(TotalWeightTxt), '0') + TotalWeightTxt;
                            ShipmentNo:=CopyStr(SalesShipmentHdr."No.", 1, MaxStrLen(ShipmentNo));
                            if StrLen(ShipmentNo) < MaxStrLen(ShipmentNo)then ShipmentNo:=PadStr('', MaxStrLen(ShipmentNo) - StrLen(ShipmentNo), '0') + ShipmentNo;
                            ReferenceText:=CopyStr(SalesShipmentHdr.Reference, 1, MaxStrLen(ReferenceText));
                            if StrLen(ReferenceText) < MaxStrLen(ReferenceText)then ReferenceText:=ReferenceText + PadStr('', MaxStrLen(ReferenceText) - StrLen(ReferenceText), ' ');
                            OutText2:=CompanyName2 + CompanyAddress + CompanyCity + CompanyPostCode + CustomerNbr + CustomerName + CustomerAddress + CustomerCity + CustomerPostCode + CustomerCountry + CasesNbr + UomText + TotalWeightTxt + ShipmentNo + PadStr('', 27, ' ') + EurText + 'P' + PadStr('', 76, ' ') + ReferenceText + EurText;
                            outs.WriteText(OutText2);
                            outs.WriteText();
                        end;
                        if GuiAllowed then begin
                            RecNo:=RecNo + 1;
                            Window.Update(3, ROUND(RecNo / TotalRecNo * 10000, 1));
                        end;
                    until(SalesShipmentHdr.Next = 0);
                    if "Shipping Agent".Code = 'SZENDEX' then begin
                        outs.WriteText(EndFileTxt);
                    end;
                    //TempBLOB.CreateOutStream(outs);
                    Data.Write(outs);
                    TempBLOB.CreateInStream(ins);
                    DownloadFromStream(ins, // InStream to save
 '', // Not used in cloud
 '', // Not used in cloud
 '', // Not used in cloud
 SilentModeFileName); // Filename is browser download folder
                    FilesExported+=1;
                end;
            end;
            //fin -  The application object or method 'XXXXXXX' has scope 'OnPrem' and cannot be used for 'Cloud' development.
            trigger OnPostDataItem()
            begin
                if GuiAllowed then begin
                    Window.Close();
                    ShowMessage();
                end;
            end;
            trigger OnPreDataItem()
            begin
                "Shipping Agent".SetFilter("Shipping Agent".Code, SalesShipmentFilters.GetFilter("Shipping Agent Code"));
                if GuiAllowed then Window.Open(Text001 + Text002 + Text003);
            end;
        }
    }
    requestpage
    {
        layout
        {
        }
        actions
        {
        }
    }
    labels
    {
    }
    var CompanyInfo: Record "Company Information";
    Text000: label 'Specify a filter for %1 field', comment = 'ESP="Especifique un filtro para el campo %1"';
    Text001: label 'Ship. Agent     #1###################\', comment = 'ESP="Trasnportista     #1###################\"';
    Text002: label 'Shipment No.        #2###################\', comment = 'ESP="Nº albarán        #2###################\"';
    Text003: label '@3@@@@@@@@@@@@@@@@@@@@@@';
    ExpText: label 'EXPEDICIONES';
    SalesShipmentHdr: Record "Sales Shipment Header";
    SalesShipmentLine: Record "Sales Shipment Line";
    SalesSetup: Record "Sales & Receivables Setup";
    //ini -  The application object or method 'XXXXXXX' has scope 'OnPrem' and cannot be used for 'Cloud' development.
    // FileMgt: Codeunit "File Management";
    // OutFile: File;
    // ExternalFile: Text[1024];
    //fin -  The application object or method 'XXXXXXX' has scope 'OnPrem' and cannot be used for 'Cloud' development.
    SilentModeFileName: Text[1024];
    OutText1: Text[46];
    ArrayOutText: array[200]of text[672];
    OutTextEnd: Text[672];
    OutText3: Text[672];
    OutText2: Text[672];
    CompanyName1: Text[20];
    CompanyName2: Text[40];
    CompanyAddress: Text[48];
    CompanyCity: Text[40];
    CompanyPostCode: Text[6];
    CustomerNbr: Text[10];
    CustomerName: Text[40];
    CustomerAddress: Text[48];
    CustomerCity: Text[40];
    CustomerPostCode: Text[6];
    CustomerCountry: Text[103];
    CasesNbr: Text[6];
    TotalWeightTxt: Text[9];
    ShipmentNo: Text[12];
    ReferenceText: Text[128];
    TotalWeight: Decimal;
    FilesExported: Integer;
    Window: Dialog;
    UomText: label 'CAJ';
    EurText: label '00000000000EUR';
    CabFileTxt: label '@@CAB';
    EndFileTxt: label '@@FIN';
    TotalRecNo: Integer;
    RecNo: Integer;
    //ini -  The application object or method 'XXXXXXX' has scope 'OnPrem' and cannot be used for 'Cloud' development.
    // FileExportedMsg: label 'A file has been exported successfully in %1.';
    // FilesExportedMsg: label '%1 files has been exported successfully in %1.';
    FileExportedMsg: label 'A file has been exported successfully.', comment = 'ESP="Se ha exportado correctamente un fichero en %1."';
    FilesExportedMsg: label '%1 files has been exported successfully.', comment = 'ESP="Se han exportado correctamente %1 ficheros."';
    //fin -  The application object or method 'XXXXXXX' has scope 'OnPrem' and cannot be used for 'Cloud' development.
    NoRecordsFoundErr: label 'No records were found. No files have been created.', comment = 'ESP="No se han encontrado registros. No se ha creado ningún archivo."';
    local procedure ShowMessage()
    begin
        if FilesExported > 0 then begin
            //ini -  The application object or method 'XXXXXXX' has scope 'OnPrem' and cannot be used for 'Cloud' development.
            // if FilesExported = 1 then
            //     Message(FileExportedMsg, SalesSetup."Agent File Path")
            // else
            //     Message(FilesExportedMsg, FilesExported, SalesSetup."Agent File Path");
            if FilesExported = 1 then Message(FileExportedMsg)
            else
                Message(FilesExportedMsg, FilesExported);
        //fin -  The application object or method 'XXXXXXX' has scope 'OnPrem' and cannot be used for 'Cloud' development.
        end
        else
            Error(NoRecordsFoundErr);
    end;
}
