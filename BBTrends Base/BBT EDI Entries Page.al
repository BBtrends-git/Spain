Page 50034 "EDI - EDI Entries"
{
    Caption = 'EDI - Movs. EDI', Comment = 'ESP = "Movimientos EDI"';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "EDI - EDI Entry";
    UsageCategory = Documents;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Document type"; Rec."Document type")
                {
                    ApplicationArea = Basic;
                }
                field("Document Nos."; Rec."Document Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Inbound/Outbound"; Rec."Inbound/Outbound")
                {
                    ApplicationArea = Basic;
                }
                field("File name"; Rec."File name")
                {
                    ApplicationArea = Basic;
                    StyleExpr = StyleTxt;
                }
                field("Received/Sent at"; Rec."Received/Sent at")
                {
                    ApplicationArea = Basic;
                }
                field("Processed at"; Rec."Processed at")
                {
                    ApplicationArea = Basic;
                }
                field("Has error"; Rec."Has error")
                {
                    ApplicationArea = Basic;
                }
                field("Last error text"; Rec."Last error text")
                {
                    ApplicationArea = Basic;
                }
                field("Manually processed"; Rec."Manually processed")
                {
                    ApplicationArea = Basic;
                }
                field(Cliente; CustName)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    Enabled = false;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Sourde Id"; Rec."Sourde Id")
                {
                    ApplicationArea = Basic;
                }
                field("Source Name"; Rec."Source Name")
                {
                    ApplicationArea = Basic;
                }
                field(Uploaded; Rec.Uploaded)
                {
                    ApplicationArea = all;
                }
                field("Upload in progress"; Rec."Upload in progress")
                {
                    ApplicationArea = all;
                }
                field("PL Entry"; Rec."PL Entry")
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
            /* 01/07/2025. OBSOLETO... Para BORRAR
            action("Ver documento")
            {
                ApplicationArea = Basic;
                Caption = 'Ver documento';
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
                    //TESTFIELD("Processed at");
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
                                end
                                else
                                    Error('No se ha encontrado el documento relacionado');
                            end;
                        Rec."document type"::Shipment:
                            begin
                                SalesShipmentHeader.Reset;
                                if SalesShipmentHeader.Get(Rec."Document Nos.") then
                                    Page.Run(130, SalesShipmentHeader)
                                else
                                    Error('No se ha encontrado el documento relacionado');
                            end;
                        Rec."document type"::Invoice:
                            begin
                                finded := false;
                                SalesInvoiceHeader.Reset;
                                SalesInvoiceHeader.SetFilter("No.", Rec."Document Nos.");
                                if SalesInvoiceHeader.FindSet then begin
                                    finded := true;
                                    Page.Run(132, SalesInvoiceHeader)
                                end
                                else begin
                                    PurchaseHeader.Reset;
                                    PurchaseHeader.SetFilter("No.", Rec."Document Nos.");
                                    if PurchaseHeader.FindSet then begin
                                        finded := true;
                                        Page.Run(51, PurchaseHeader)
                                    end
                                    else begin
                                        SalesHeader.Reset;
                                        SalesHeader.SetFilter("No.", Rec."Document Nos.");
                                        if SalesHeader.FindSet then begin
                                            finded := true;
                                            if SalesHeader.Count = 1 then
                                                Page.Run(44, SalesHeader)
                                            else
                                                Page.Run(9302, SalesHeader);
                                        end;
                                        if not finded then Error('No se ha encontrado el documento relacionado');
                                    end;
                                end;
                            end;
                    end;
                end;
            }
            */
            action(DownloadFile)
            {
                ApplicationArea = All;
                Caption = 'Download file', comment = 'ESP="Descargar Fichero"';
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
            /* 01/07/2025. OBSOLETO .... para BORRAR
            action(Reintentar)
            {
                ApplicationArea = Basic;
                Caption = 'Reintentar';

                trigger OnAction()
                var
                    EDIEDIEntry: Record 50013;
                    EDIFileprocessing: Codeunit 50006;
                begin
                    Clear(EDIEDIEntry);
                    CurrPage.SetSelectionFilter(EDIEDIEntry);
                    EDIEDIEntry.SetRange("Manually processed", false);
                    //EDIEDIEntry.SETRANGE("Document No.",'');
                    if EDIEDIEntry.Count = 0 then exit;
                    if not Confirm('¿Desea reintentar el procesamiento de ' + Format(EDIEDIEntry.Count) + ' líneas?') then Error('');
                    EDIEDIEntry.FindSet;
                    repeat
                        if (EDIEDIEntry."Processed at" = 0DT) or (Rec."Has error") then begin
                            EDIEDIEntry.Validate("Has error", false);
                            EDIEDIEntry.Validate("Last error text", '');
                            EDIEDIEntry.Validate("Processed at", 0DT);
                            Clear(EDIFileprocessing);
                            EDIFileprocessing.SetRetry;
                            //EDIEDIEntry.Get(EDIEDIEntry."Entry No.");
                            if EDIFileprocessing.Run(EDIEDIEntry) then begin
                                EDIEDIEntry.Get(EDIEDIEntry."Entry No.");
                                EDIEDIEntry.Validate("Has error", false);
                                EDIEDIEntry.Validate("Last error text", '');
                                if EDIEDIEntry."Inbound/Outbound" = EDIEDIEntry."inbound/outbound"::Inbound then EDIEDIEntry.Validate("Document Nos.", EDIFileprocessing.GetDocumentNo);
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
            */
            action("Marcar procesado manualmente")
            {
                ApplicationArea = Basic;
                Caption = 'Mark processed manually', Comment = 'ESP = "Marcar procesado manualmente"';
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
            action(Procesardocumento)
            {
                ApplicationArea = Basic;
                Caption = 'Reprocess document manually', Comment = 'ESP = "Reprocesar documento"';
                Image = CoupledOrder;

                trigger OnAction()
                var
                    EDIEDIEntry: Record "EDI - EDI Entry";
                    EDIFileManagement: Codeunit "BBT EDI Files Management";
                    JobQueueManagement: Codeunit "Job Queue Management";
                    rJobQueueEntry: Record "Job Queue Entry";
                begin
                    Clear(EDIEDIEntry);
                    CurrPage.SetSelectionFilter(EDIEDIEntry);
                    //>> BBT 26/05/2025. Solo el primer registro seleccionado                    
                    //EDIEDIEntry.FindSet;
                    //repeat
                    if EDIEDIEntry.FindFirst() then begin
                        //<<
                        if EDIEDIEntry."Manually processed" = true then
                            Error('El registro %1 está marcado como procesado manualmente', EDIEDIEntry."Entry No.");

                        case EDIEDIEntry."Inbound/Outbound" of
                            // Registros de entrada se procesan con la cola de proyectos
                            EDIEDIEntry."Inbound/Outbound"::Inbound:
                                begin
                                    //Control de registro
                                    if EDIEDIEntry."Document Nos." <> '' then
                                        Error('El registro %1 tiene documentos procesados', EDIEDIEntry."Entry No.");

                                    //Reseteamos el error
                                    EDIEDIEntry.Validate("Has error", false);
                                    EDIEDIEntry.Validate("Last error text", '');
                                    EDIEDIEntry.Validate("Processed at", 0DT);
                                    EDIEDIEntry.Modify();

                                    //lanzamos el proceso de generación del documento
                                    rJobQueueEntry.Reset();
                                    rJobQueueEntry."Recurring Job" := false;
                                    rJobQueueEntry."Object Type to Run" := rJobQueueEntry."Object Type to Run"::Codeunit;
                                    rJobQueueEntry."Object ID to Run" := CODEUNIT::"BBT EDI Files Procesing";
                                    rJobQueueEntry."Parameter String" := 'PROCESSORDERS';
                                    rJobQueueEntry."Report Output Type" := rJobQueueEntry."Report Output Type"::"None (Processing only)";
                                    JobQueueManagement.RunJobQueueEntryOnce(rJobQueueEntry);
                                end;
                            // Registros de salida se procesan directamente.
                            EDIEDIEntry."Inbound/Outbound"::Outbound:
                                begin
                                    if (EDIEDIEntry."Processed at" = 0DT) and not (Rec."Has error") then begin
                                        if not Confirm('¿Desea reintentar el procesamiento de ' + Format(EDIEDIEntry.Count) + ' líneas?') then Error('');
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
                                end;
                        end;
                        //>> BBT 26/05/2025. Solo el registro seleccionado
                        //until EDIEDIEntry.Next = 0;
                        //<<
                    end;
                end;
            }
            action("VerDocumento")
            {
                ApplicationArea = Basic;
                Caption = 'See Document', comment = 'ESP = "Ver Documento"';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SalesShipmentHeader: Record "Sales Shipment Header";
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                    PurchaseHeader: Record "Purchase Header";
                begin
                    Rec.TestField("Document Nos.");
                    if Rec."Inbound/Outbound" = Rec."Inbound/Outbound"::Inbound then // Documentos de Entrada
                        case Rec."Document type" of
                            Rec."document type"::Order:         //Pedido de Venta PVs
                                begin
                                    SalesHeader.Reset;
                                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                                    SalesHeader.SetFilter("No.", Rec."Document Nos.");
                                    if SalesHeader.FindSet then begin
                                        if SalesHeader.Count = 1 then
                                            Page.Run(42, SalesHeader)
                                        else
                                            Page.Run(9305, SalesHeader);
                                    end else
                                        Error('No se ha encontrado el documento relacionado');
                                end;
                            Rec."document type"::Shipment:      //Albaran de Devolución DV's
                                begin
                                    SalesHeader.Reset;
                                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Return Order");
                                    SalesHeader.SetFilter("No.", Rec."Document Nos.");
                                    if SalesHeader.FindSet then begin
                                        if SalesHeader.Count = 1 then
                                            Page.Run(6630, SalesHeader)
                                        else
                                            Page.Run(9304, SalesHeader);
                                    end
                                    else
                                        Error('No se ha encontrado el documento relacionado');
                                end;
                            Rec."document type"::Invoice:       // Devoluciones de Cliente -Abonos de Cliente - Facturas de Proveedor
                                begin
                                    case true of
                                        CopyStr(Rec."Document Nos.", 1, 2) = 'DV':       // Devolución DV's
                                            begin
                                                SalesHeader.Reset;
                                                SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Return Order");
                                                SalesHeader.SetFilter("No.", Rec."Document Nos.");
                                                if SalesHeader.FindSet then begin
                                                    if SalesHeader.Count = 1 then
                                                        Page.Run(6630, SalesHeader)
                                                    else
                                                        Page.Run(9304, SalesHeader);
                                                end
                                                else
                                                    Error('No se ha encontrado el documento relacionado');
                                            end;
                                        CopyStr(Rec."Document Nos.", 1, 2) = 'AV':       // Abono de Cliente AV's
                                            begin
                                                SalesHeader.Reset;
                                                SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
                                                SalesHeader.SetFilter("No.", Rec."Document Nos.");
                                                if SalesHeader.FindSet then begin
                                                    if SalesHeader.Count = 1 then
                                                        Page.Run(44, SalesHeader)
                                                    else
                                                        Page.Run(9302, SalesHeader);
                                                end
                                                else
                                                    Error('No se ha encontrado el documento relacionado');
                                            end;
                                        CopyStr(Rec."Document Nos.", 1, 2) = 'FC':       // Factura de Proveedor (Cliente)
                                            begin
                                                PurchaseHeader.Reset;
                                                PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Invoice);
                                                PurchaseHeader.SetFilter("No.", Rec."Document Nos.");
                                                if PurchaseHeader.FindSet then begin
                                                    if PurchaseHeader.Count = 1 then
                                                        Page.Run(51, PurchaseHeader)
                                                    else
                                                        Page.Run(9308, PurchaseHeader);
                                                end
                                                else
                                                    Error('No se ha encontrado el documento relacionado');
                                            end;
                                        else
                                            Error('No se ha encontrado el documento relacionado');
                                    end;
                                end;
                            else
                                Error('No se ha encontrado el documento relacionado');
                        end
                    else     // Documentos de Salida
                        case Rec."Document type" of
                            Rec."document type"::Shipment:      // Albarán de venta registrado
                                begin
                                    SalesShipmentHeader.Reset;
                                    if SalesShipmentHeader.Get(Rec."Document Nos.") then
                                        Page.Run(130, SalesShipmentHeader)
                                    else
                                        Error('No se ha encontrado el documento relacionado');
                                end;
                            Rec."document type"::Invoice:       // Factura de venta registrada
                                begin
                                    SalesInvoiceHeader.Reset;
                                    if SalesInvoiceHeader.Get(Rec."Document Nos.") then
                                        Page.Run(132, SalesInvoiceHeader)
                                    else
                                        Error('No se ha encontrado el documento relacionado');
                                end;

                            else
                                Error('No se ha encontrado el documento relacionado');
                        end;
                end;
            }

        }
        area(navigation)
        {
            action("Ver con errores")
            {
                ApplicationArea = Basic;
                Caption = 'See with errors', Comment = 'ESP = "Ver con errores"';
                Image = CancelAllLines;
                Promoted = true;

                trigger OnAction()
                begin
                    Rec.SetRange("Processed at");
                    Rec.SetRange("Manually processed", false);
                    Rec.SetRange("Has error", true);
                end;
            }
            action("Ver sin procesar")
            {
                ApplicationArea = Basic;
                Caption = 'View without processing', Comment = 'ESP = "Ver sin procesar"';
                Image = JobLines;
                Promoted = true;

                trigger OnAction()
                begin
                    Rec.SetRange("Processed at", 0DT);
                    Rec.SetRange("Manually processed");
                    Rec.SetRange("Has error");
                end;
            }
            action("Ver procesados")
            {
                ApplicationArea = Basic;
                Caption = 'View processed', Comment = 'ESP = "Ver procesados"';
                Image = CompleteLine;
                Promoted = true;

                trigger OnAction()
                begin
                    Rec.SetFilter("Processed at", '<>%1', 0DT);
                    Rec.SetRange("Manually processed");
                    Rec.SetRange("Has error", false);
                end;
            }
            /* Test.
            action(Test)
            {
                ApplicationArea = Basic;
                Caption = 'Test';
                RunObject = Codeunit 50007;
            }
            */
        }
    }
    trigger OnAfterGetRecord()
    var
        CustNo: Code[20];
        rSalesShipment: Record "Sales Shipment Header";
        rSalesInvoice: Record "Sales Invoice Header";
    begin
        CalcStyle;
        //>> 01/07/2025. Obsoleto
        //FindCust;
        //<<
        if Rec."Source Type" = Rec."Source Type"::" " then begin
            if Rec."Inbound/Outbound" = rec."Inbound/Outbound"::Outbound then begin
                Case Rec."Document type" of
                    Rec."Document type"::Shipment:
                        if rSalesShipment.Get(Rec."Document Nos.") then begin
                            Rec."Source Type" := Rec."Source Type"::Customer;
                            Rec."Sourde Id" := rSalesShipment."Sell-to Customer No.";
                            Rec."Source Name" := rSalesShipment."Sell-to Customer Name";
                        end;
                    Rec."Document type"::Invoice:
                        if rSalesInvoice.Get(Rec."Document Nos.") then begin
                            Rec."Source Type" := Rec."Source Type"::Customer;
                            Rec."Sourde Id" := rSalesInvoice."Sell-to Customer No.";
                            Rec."Source Name" := rSalesInvoice."Sell-to Customer Name";
                        end;
                end;
            end;
            Rec.Modify();
        end;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if Rec."Document type" = Rec."document type"::Order then Error('No se puede borrar un pedido');
        if Rec."Processed at" <> 0DT then Error('No se puede borrar un documento procesado');
    end;

    var
        StyleTxt: Text;
        Cust: Record Customer;
        Vend: Record Vendor;
        SalesInvoice: Record "Sales Invoice Header";
        SalesShipment: Record "Sales Shipment Header";
        SalesOrder: Record "Sales Header";
        CustName: Text[50];
        PurchOrder: Record "Purchase Header";

    local procedure CalcStyle()
    begin
        if Rec."Processed at" = 0DT then
            StyleTxt := 'Ambiguous'
        else if Rec."Manually processed" or (not Rec."Has error") then
            StyleTxt := 'Favorable'
        else
            StyleTxt := 'Unfavorable';
    end;

    //>> 01/07/2025. OBSOLETO... Para BORRAR
    /*
    local procedure FindCust()
    var
        CustNo: Code[20];
        VendNo: Code[20];
    begin
        CustNo := '';
        VendNo := '';
        case Rec."Document type" of
            Rec."document type"::Invoice:
                begin
                    SalesInvoice.Reset;
                    SalesInvoice.SetFilter("No.", Rec."Document Nos.");
                    if SalesInvoice.FindFirst then
                        CustNo := SalesInvoice."Sell-to Customer No."
                    else begin
                        PurchOrder.Reset;
                        PurchOrder.SetFilter("No.", Rec."Document Nos.");
                        if PurchOrder.FindFirst then
                            VendNo := PurchOrder."Buy-from Vendor No."
                        else begin
                            SalesOrder.Reset;
                            SalesOrder.SetFilter("No.", Rec."Document Nos.");
                            if SalesOrder.FindFirst then CustNo := SalesOrder."Sell-to Customer No.";
                        end;
                    end;
                end;
            Rec."document type"::Shipment:
                if SalesShipment.Get(Rec."Document Nos.") then
                    CustNo := SalesShipment."Sell-to Customer No.";
            Rec."document type"::Order:
                begin
                    SalesOrder.Reset;
                    SalesOrder.SetFilter("No.", Rec."Document Nos.");
                    if SalesOrder.FindFirst then CustNo := SalesOrder."Sell-to Customer No.";
                end;
        end;
        if CustNo <> '' then begin
            Cust.Get(CustNo);
            CustName := Cust.Name;
        end
        else if VendNo <> '' then begin
            Vend.Get(VendNo);
            CustName := Vend.Name;
        end;
        if ((VendNo = '') and (CustName = '')) or (Rec."Document Nos." = '') then CustName := '';
    end;
    */
    //<<
}
