PageExtension 50155 "BBT Navigate" extends Navigate
{
    layout
    {
        addafter(PostingDateFilter)
        {
            field(CustomerServiceNo; CustomerServiceNo)
            {
                ApplicationArea = Basic;
                Caption = 'No servicio cliente';
            }
        }
    }
    var
        CustomerServiceNo: Code[20];
        CustomerServiceHeader: Record 50037;
        TextCustomerServiceHeader: label 'Servicio cliente';
    //Unsupported feature: Code Modification on "FindRecords(PROCEDURE 2)".
    //procedure FindRecords();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    Window.OPEN(Text002);
    RESET;
    DELETEALL;
    #4..6
      SalesShptHeader.RESET;
      SalesShptHeader.SETFILTER("No.",DocNoFilter);
      SalesShptHeader.SETFILTER("Posting Date",PostingDateFilter);
      InsertIntoDocEntry(
        DATABASE::"Sales Shipment Header",0,Text005,SalesShptHeader.COUNT);
    END;
    IF SalesInvHeader.READPERMISSION AND (CarteraDocNoFilter = '') THEN BEGIN
      SalesInvHeader.RESET;
      SalesInvHeader.SETFILTER("No.",DocNoFilter);
      SalesInvHeader.SETFILTER("Posting Date",PostingDateFilter);
      InsertIntoDocEntry(
        DATABASE::"Sales Invoice Header",0,Text003,SalesInvHeader.COUNT);
    END;
    IF ReturnRcptHeader.READPERMISSION THEN BEGIN
      ReturnRcptHeader.RESET;
      ReturnRcptHeader.SETFILTER("No.",DocNoFilter);
      ReturnRcptHeader.SETFILTER("Posting Date",PostingDateFilter);
      InsertIntoDocEntry(
        DATABASE::"Return Receipt Header",0,Text017,ReturnRcptHeader.COUNT);
    END;
    IF SalesCrMemoHeader.READPERMISSION AND (CarteraDocNoFilter = '') THEN BEGIN
      SalesCrMemoHeader.RESET;
      SalesCrMemoHeader.SETFILTER("No.",DocNoFilter);
      SalesCrMemoHeader.SETFILTER("Posting Date",PostingDateFilter);
      InsertIntoDocEntry(
        DATABASE::"Sales Cr.Memo Header",0,Text004,SalesCrMemoHeader.COUNT);
    END;
    IF ServShptHeader.READPERMISSION THEN BEGIN
      ServShptHeader.RESET;
      ServShptHeader.SETFILTER("No.",DocNoFilter);
    #37..356
      InsertIntoDocEntry(
        DATABASE::"Closed Payment Order",0,ClosedPmtOrd.TABLECAPTION,ClosedPmtOrd.COUNT);
    END;

    DocExists := FINDFIRST;

    SetSource(0D,'','',0,'');
    #364..523
    IF UpdateForm THEN
      UpdateFormAfterFindRecords;
    Window.CLOSE;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..9
      IF CustomerServiceNo<>'' THEN SalesShptHeader.SETRANGE("Customer Service No.",CustomerServiceNo); //MPA><
    #10..16
      IF CustomerServiceNo<>'' THEN SalesInvHeader.SETRANGE("Customer Service No.",CustomerServiceNo); //MPA><
    #17..23
      IF CustomerServiceNo<>'' THEN ReturnRcptHeader.SETRANGE("Customer Service No.",CustomerServiceNo); //MPA><
    #24..30
      IF CustomerServiceNo<>'' THEN SalesCrMemoHeader.SETRANGE("Customer Service No.",CustomerServiceNo); //MPA><
    #31..33
    IF CustomerServiceNo='' THEN BEGIN //MPA>
    #34..359
    END; //MPA<
    #361..526
    */
    //end;
    //Unsupported feature: Code Modification on "FindIncomingDocumentRecords(PROCEDURE 27)".
    //procedure FindIncomingDocumentRecords();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF IncomingDocument.READPERMISSION THEN BEGIN
      IncomingDocument.RESET;
      IncomingDocument.SETFILTER("Document No.",DocNoFilter);
      IncomingDocument.SETFILTER("Posting Date",PostingDateFilter);
      InsertIntoDocEntry(
        DATABASE::"Incoming Document",0,IncomingDocument.TABLECAPTION,IncomingDocument.COUNT);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IF CustomerServiceNo<>'' THEN EXIT; //BB><
    #1..7
    */
    //end;
    //Unsupported feature: Code Modification on "ShowRecords(PROCEDURE 6)".
    //procedure ShowRecords();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF ItemTrackingSearch THEN
      ItemTrackingNavigateMgt.Show("Table ID")
    ELSE
    #4..155
          PAGE.RUN(0,PostedPmtOrd);
        DATABASE::"Closed Payment Order":
          PAGE.RUN(0,ClosedPmtOrd);
      END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..158
        //MPA>
        DATABASE::"Customer Service Header":
          PAGE.RUN(0,CustomerServiceHeader);
        //MPA<
      END;
    */
    //end;
    //Unsupported feature: Code Modification on "FindRecordsOnOpen(PROCEDURE 21)".
    //procedure FindRecordsOnOpen();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF (NewDocNo = '') AND (NewPostingDate = 0D) AND (NewSerialNo = '') AND (NewLotNo = '') THEN BEGIN
      DELETEALL;
      ShowEnable := FALSE;
      PrintEnable := FALSE;
    #5..12
        ClearInfo;
        FindTrackingRecords;
      END ELSE BEGIN
        SETRANGE("Document No.",NewDocNo);
        SETRANGE("Posting Date",NewPostingDate);
        DocNoFilter := GETFILTER("Document No.");
        PostingDateFilter := GETFILTER("Posting Date");
    #20..22
        ClearTrackingInfo;
        FindRecords;
      END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //MPA>
    //IF (NewDocNo = '') AND (NewPostingDate = 0D) AND (NewSerialNo = '') AND (NewLotNo = '') THEN BEGIN
    IF (NewDocNo = '') AND (NewPostingDate = 0D) AND (NewSerialNo = '') AND (NewLotNo = '') AND (CustomerServiceNo='') THEN BEGIN//MPA<
    #2..15
        IF NewDocNo<>'' THEN //MPA><
        SETRANGE("Document No.",NewDocNo);
        IF NewPostingDate<>0D THEN //MPA><
    #17..25
    */
    //end;
    local procedure "//BB - F"()
    begin
    end;
    /*TODO
     local procedure FindCustomerServiceHeader()
    begin
        if CustomerServiceHeader.ReadPermission then begin
          CustomerServiceHeader.Reset;
          CustomerServiceHeader.SetFilter("No.",CustomerServiceNo);
          InsertIntoDocEntry(Database::"Customer Service Header",0,TextCustomerServiceHeader,CustomerServiceHeader.Count);
        end;
    end; */
    procedure SetCustomerServiceNo(CustomerServNo: Code[20])
    begin
        CustomerServiceNo := CustomerServNo;
    end;
}
