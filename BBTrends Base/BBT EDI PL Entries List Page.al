Page 51107 "BBT EDI PL Entries List"
{
    Caption = 'PL EDI Entries List';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = 50013;
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Caption = 'Nº Mov.';"; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                    ApplicationArea = Basic;
                }
                field("Document type"; Rec."Document type")
                {
                    Caption = 'Document type';
                    ApplicationArea = Basic;
                }
                field("Document Nos."; Rec."Document Nos.")
                {
                    Caption = 'Document Nos.';
                    ApplicationArea = Basic;
                }
                field("Inbound/Outbound"; Rec."Inbound/Outbound")
                {
                    Caption = 'Inbound/Outbound';
                    ApplicationArea = Basic;
                }
                field("File name"; Rec."File name")
                {
                    Caption = 'File Name';
                    ApplicationArea = Basic;
                    StyleExpr = StyleTxt;
                }
                field("Received/Sent at"; Rec."Received/Sent at")
                {
                    Caption = 'Received/Sent at';
                    ApplicationArea = Basic;
                }
                field("Processed at"; Rec."Processed at")
                {
                    Caption = 'Processed at';
                    ApplicationArea = Basic;
                }
                field("Has error"; Rec."Has error")
                {
                    Caption = 'Has error';
                    ApplicationArea = Basic;
                }
                field("Last error text"; Rec."Last error text")
                {
                    Caption = 'Last error text';
                    ApplicationArea = Basic;
                }
                field("Manually processed"; Rec."Manually processed")
                {
                    Caption = 'Manually processed';
                    ApplicationArea = Basic;
                }
                field("Source Type"; Rec."Source Type")
                {
                    Caption = 'Source Type';
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Sourde Id"; Rec."Sourde Id")
                {
                    Caption = 'Source Id';
                    ApplicationArea = Basic;
                }
                field(Cliente; SourceName)
                {
                    Caption = 'Source Name';
                    ApplicationArea = Basic;
                }
                field(Uploaded; Rec.Uploaded)
                {
                    Caption = 'Uploaded';
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Upload in progress"; Rec."Upload in progress")
                {
                    Caption = 'Upload in progress';
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("PL Entry"; Rec."PL Entry")
                {
                    Caption = 'PL Entry';
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
            action("See documento")
            {
                ApplicationArea = Basic;
                Caption = 'See documento';
                Image = View;
                Promoted = true;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SalesShipmentHeader: Record "Sales Shipment Header";
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                    PurchaseHeader: Record "Purchase Header";
                    finded: Boolean;
                begin
                    Rec.TestField("Document Nos.");
                    case Rec."Document type" of
                        Rec."document type"::Order:
                            begin
                                SalesHeader.Reset;
                                SalesHeader.SetFilter("No.", Rec."Document Nos.");
                                if SalesHeader.FindSet then begin
                                    if SalesHeader.Count = 1 then
                                        Page.Run(42, SalesHeader)
                                    else
                                        Page.Run(9305, SalesHeader);
                                end else
                                    Error('The related document was not found');
                            end;
                        Rec."document type"::Shipment:
                            begin
                                SalesShipmentHeader.Reset;
                                if SalesShipmentHeader.Get(Rec."Document Nos.") then
                                    Page.Run(130, SalesShipmentHeader)
                                else
                                    Error('The related document was not found');
                            end;
                        Rec."document type"::Invoice:
                            begin
                                finded := false;
                                SalesInvoiceHeader.Reset;
                                SalesInvoiceHeader.SetFilter("No.", Rec."Document Nos.");
                                if SalesInvoiceHeader.FindSet then begin
                                    finded := true;
                                    Page.Run(132, SalesInvoiceHeader)
                                end else begin
                                    PurchaseHeader.Reset;
                                    PurchaseHeader.SetFilter("No.", Rec."Document Nos.");
                                    if PurchaseHeader.FindSet then begin
                                        finded := true;
                                        Page.Run(51, PurchaseHeader)
                                    end else begin
                                        SalesHeader.Reset;
                                        SalesHeader.SetFilter("No.", Rec."Document Nos.");
                                        if SalesHeader.FindSet then begin
                                            finded := true;
                                            if SalesHeader.Count = 1 then
                                                Page.Run(44, SalesHeader)
                                            else
                                                Page.Run(9302, SalesHeader);
                                        end;
                                        if not finded then
                                            Error('The related document was not found');
                                    end;
                                end;
                            end;
                    end;
                end;
            }
            action(DownloadFile)
            {
                ApplicationArea = All;
                Caption = 'Download file';
                Image = Download;
                trigger OnAction()
                var
                    IStream: InStream;
                begin
                    rec.CalcFields("File Blob");
                    rec."File Blob".CreateInStream(IStream);
                    DownloadFromStream(IStream, '', '', '', Rec."File name");
                end;
            }
            action(ProcessDocument)
            {
                ApplicationArea = Basic;
                Caption = 'Reprocess document manually';
                Image = CoupledOrder;

                trigger OnAction()
                var
                    EDIEDIEntry: Record "EDI - EDI Entry";
                    EDIFileManagement: Codeunit "BBT EDI Files Management";
                begin
                    Clear(EDIEDIEntry);
                    CurrPage.SetSelectionFilter(EDIEDIEntry);
                    EDIEDIEntry.SetRange("Manually processed", false);
                    EDIEDIEntry.SetRange("Document Nos.", '');
                    if EDIEDIEntry.Count = 0 then exit;
                    if not Confirm('¿Do you want to retry processing ' + Format(EDIEDIEntry.Count) + ' lines?') then Error('');
                    EDIEDIEntry.FindSet;
                    repeat
                        if (EDIEDIEntry."Processed at" = 0DT) or (Rec."Has error") then begin
                            EDIEDIEntry.Validate("Has error", false);
                            EDIEDIEntry.Validate("Last error text", '');
                            EDIEDIEntry.Validate("Processed at", 0DT);
                            Clear(EDIFileManagement);
                            EDIFileManagement.SetRetry;
                            //EDIEDIEntry.Get(EDIEDIEntry."Entry No.");
                            if EDIFileManagement.Run(EDIEDIEntry) then begin
                                EDIEDIEntry.Get(EDIEDIEntry."Entry No.");
                                EDIEDIEntry.Validate("Has error", false);
                                EDIEDIEntry.Validate("Last error text", '');
                                if EDIEDIEntry."Inbound/Outbound" = EDIEDIEntry."inbound/outbound"::Inbound then EDIEDIEntry.Validate("Document Nos.", EDIFileManagement.GetDocumentNo);
                            end
                            else begin
                                EDIEDIEntry.Get(EDIEDIEntry."Entry No.");
                                EDIEDIEntry.Validate("Has error", true);
                                EDIEDIEntry.Validate("Last error text", GetLastErrorText);
                                if EDIEDIEntry."Inbound/Outbound" = EDIEDIEntry."inbound/outbound"::Inbound then EDIEDIEntry.Validate("Document Nos.", '');
                            end;
                            //EDIEDIEntry.Get(EDIEDIEntry."Entry No.");
                            EDIEDIEntry.Validate("Processed at", CurrentDatetime);
                            EDIEDIEntry.Validate(Uploaded, true);
                            EDIEDIEntry.Modify(true);
                            Commit;
                        end;
                    until EDIEDIEntry.Next = 0;
                end;
            }
            action("MarkProcessed")
            {
                ApplicationArea = Basic;
                Caption = 'Mark processed manually';
                Image = Approval;
                Promoted = true;

                trigger OnAction()
                begin
                    Rec.TestField("Document Nos.", '');
                    Rec.Validate("Manually processed", true);
                    Rec.Validate("Processed at", CurrentDatetime);
                    Rec.Modify;
                end;
            }
        }
        area(navigation)
        {
            action("ViewWithErrors.")
            {
                ApplicationArea = Basic;
                Caption = 'View with errors';
                Image = CancelAllLines;
                Promoted = true;

                trigger OnAction()
                begin
                    Rec.SetRange("Processed at");
                    Rec.SetRange("Manually processed", false);
                    Rec.SetRange("Has error", true);
                end;
            }
            action("ViewUnprocessed")
            {
                ApplicationArea = Basic;
                Caption = 'View unprocessed.';
                Image = JobLines;
                Promoted = true;

                trigger OnAction()
                begin
                    Rec.SetRange("Processed at", 0DT);
                    Rec.SetRange("Manually processed");
                    Rec.SetRange("Has error");
                end;
            }
            action("ViewProcessed")
            {
                ApplicationArea = Basic;
                Caption = 'View Processed';
                Image = CompleteLine;
                Promoted = true;

                trigger OnAction()
                begin
                    Rec.SetFilter("Processed at", '<>%1', 0DT);
                    Rec.SetRange("Manually processed");
                    Rec.SetRange("Has error", false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        rec.SetRange("PL Entry", true);
    end;

    trigger OnAfterGetRecord()
    var
        SourceId: Code[20];
    begin
        CalcStyle;
        FindSource;
    end;

    trigger OnDeleteRecord(): Boolean
    begin

    end;

    var
        StyleTxt: Text;
        rCustomer: Record Customer;
        rVendor: Record Vendor;
        SourceName: Text[50];

    local procedure CalcStyle()
    begin
        if Rec."Processed at" = 0DT then
            StyleTxt := 'Ambiguous'
        else
            if Rec."Manually processed" or (not Rec."Has error") then
                StyleTxt := 'Favorable'
            else
                StyleTxt := 'Unfavorable';
    end;

    local procedure FindSource()
    begin
        Clear(SourceName);
        case Rec."Source Type" of
            Rec."Source Type"::Customer:
                begin
                    if rCustomer.get(rec."Sourde Id") then
                        SourceName := rCustomer.Name;
                end;
            Rec."Source Type"::Vendor:
                begin
                    if rVendor.get(rec."Sourde Id") then
                        SourceName := rVendor.Name;
                end;
        end;
    end;
}
