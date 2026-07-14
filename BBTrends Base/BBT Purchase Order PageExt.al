PageExtension 50121 "BBT Purchase Order" extends "Purchase Order"
{
    layout
    {
        modify(General)
        {
            Editable = DocEditable;
        }
        modify("Foreign Trade")
        {
            Editable = DocEditable;
        }
        modify(Prepayment)
        {
            Editable = DocEditable;
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Lead Time Calculation")
        {
            Visible = false;
        }
        modify("Purchaser Code")
        {
            Visible = true;
            ShowMandatory = true;
            Importance = Standard;
        }
        addafter("Purchaser Code")
        {
            field("Product Manager"; Rec."Product Manager")
            {
                ApplicationArea = all;
                Enabled = true;
                Visible = true;
            }
            field("Destination Country"; Rec."Destination Country")
            {
                ApplicationArea = all;
                Enabled = true;
                Visible = true;
            }
        }
        addafter("Shipment Method Code")
        {
            field("Total Container Volume"; Rec."Total Container Volume")
            {
                ApplicationArea = all;
                Enabled = true;
                Visible = true;
            }
        }
        addbefore("Shipment Method Code")
        {
            field("Vendor Bank Acc. Code 2"; Rec."Vendor Bank Acc. Code")
            {
                ApplicationArea = all;
            }
        }
        addafter("Buy-from Contact")
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Currency Code")
        {
            field("Currency Factor"; Rec."Currency Factor")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Currency Factor field.';
                Editable = true;
            }
        }
        addafter(Status)
        {
            //>> //>> SGA Obsoleto
            field("Status SGA"; Rec."Status SGA")
            {
                ApplicationArea = All;
                Visible = SGAEnabled;
            }
            field("Grabado SGA"; Rec."Grabado SGA")
            {
                ApplicationArea = All;
                Visible = SGAEnabled;
            }
            field("Leido SGA"; Rec."Leido SGA")
            {
                ApplicationArea = All;
                Visible = SGAEnabled;
            }
            //>> SGA Obsoleto
            field(Observations; Rec.Observations)
            {
                ApplicationArea = Basic;
                Importance = Additional;
                MultiLine = true;
            }
            field("Include Import Status"; Rec."Include Import Status")
            {
                ApplicationArea = Basic;
            }
        }
        //>> BBT. 01/06/2026. Obsoleto. No se está usando la tabla extendida de la Purchase Header
        /*
        addafter("Vendor Bank Acc. Code")
        {
            field("Payment Terms Code2"; Rec."Payment Terms Code")
            {
                ApplicationArea = Basic;
                Editable = false;
                Importance = Promoted;
                ShowMandatory = true;
            }
            field("Payment Method Code2"; Rec."Payment Method Code")
            {
                ApplicationArea = Basic;
                Editable = false;
                //Importance = Promoted;
                ShowMandatory = true;
            }
            //>> BBT. 01/06/2026. Obsoleto. No se está usando la tabla extendida de la Purchase Header
            /*
            field("Fecha apertura LC"; ExtendedHeader."Fecha apertura LC")
            {
                ApplicationArea = Basic;
                Editable = ActiveField;

                trigger OnValidate()
                begin
                    //RPC-02
                    ValidateExtended(Rec, ExtendedHeader);
                    //RPC-02
                end;
            }
            field("Fecha LC Recibida"; ExtendedHeader."Fecha LC Recibida")
            {
                ApplicationArea = Basic;
                Editable = ActiveField;

                trigger OnValidate()
                begin
                    //RPC-02
                    ValidateExtended(Rec, ExtendedHeader);
                    //RPC-02
                end;
            }
            field("Status LC"; ExtendedHeader."Status LC")
            {
                ApplicationArea = Basic;
                Editable = ActiveField;

                trigger OnValidate()
                begin
                    //RPC-02
                    ValidateExtended(Rec, ExtendedHeader);
                    //RPC-02
                end;
            }
            field("No. LC"; ExtendedHeader."No. LC")
            {
                ApplicationArea = Basic;
                Editable = ActiveField;

                trigger OnValidate()
                begin
                    //RPC-02
                    ValidateExtended(Rec, ExtendedHeader);
                    //RPC-02
                end;
            }
            field("Banco LC"; ExtendedHeader."Banco LC")
            {
                ApplicationArea = Basic;
                Editable = ActiveField;

                trigger OnValidate()
                begin
                    //RPC-02
                    ValidateExtended(Rec, ExtendedHeader);
                    //RPC-02
                end;
            }
            field("ETD LC"; ExtendedHeader."ETD LC")
            {
                ApplicationArea = Basic;
                Editable = ActiveField;

                trigger OnValidate()
                begin
                    //RPC-02
                    ValidateExtended(Rec, ExtendedHeader);
                    //RPC-02
                end;
            }

        }
        */
        //<<

        //>> BBT. 01/06/2026. Obsoleto. No se está usando la tabla extendida de la Purchase Header
        /*
        addafter(Prepayment)
        {
            group(Control1000000000)
            {
                Caption = 'Prepayment';
                Editable = DocEditable;
                Visible = false;
                Enabled = false;

                field(Recambio; ExtendedHeader.Recambio)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        //RPC-02
                        ValidateExtended(Rec, ExtendedHeader);
                        //RPC-02
                    end;
                }
                field(Proforma; ExtendedHeader.Proforma)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        //RPC-02
                        ValidateExtended(Rec, ExtendedHeader);
                        //RPC-02
                    end;
                }
            }

            group(Control1000000003)
            {
                Caption = 'Prepayment';
                Editable = DocEditable;
                Visible = false;
                Enabled = false;

                field("Inspección"; ExtendedHeader."Inspección")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        //RPC-02
                        ValidateExtended(Rec, ExtendedHeader);
                        //RPC-02
                    end;
                }
                field("Resultado Insp"; ExtendedHeader."Resultado Insp.")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        //RPC-02
                        ValidateExtended(Rec, ExtendedHeader);
                        //RPC-02
                    end;
                }
                field(Forwarder; ExtendedHeader.Forwarder)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        //RPC-02
                        ValidateExtended(Rec, ExtendedHeader);
                        //RPC-02
                    end;
                }
                field("F. Presentación ENS"; ExtendedHeader."F. Presentación ENS")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        //RPC-02
                        ValidateExtended(Rec, ExtendedHeader);
                        //RPC-02
                    end;
                }

                //>> Campo Obsoleto
                //field(ETA; Rec.ETA)
                //{
                //    ApplicationArea = Basic;
                //    Caption = 'ETA';
                //}
                //
                //<<

                field("F. Doc Originales"; ExtendedHeader."F. Doc Originales")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        //RPC-02
                        ValidateExtended(Rec, ExtendedHeader);
                        //RPC-02
                    end;
                }
                field("F. Despacho"; ExtendedHeader."F. Despacho")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        //RPC-02
                        ValidateExtended(Rec, ExtendedHeader);
                        //RPC-02
                    end;
                }
                field("Observ. Importación"; ExtendedHeader."Observ. Importación")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        //RPC-02
                        ValidateExtended(Rec, ExtendedHeader);
                        //RPC-02
                    end;
                }
            }
        }
        */
        //<<

        //>> Obsoleto
        /*
        addlast(content)
        {
            // - Estadísticos de CDI
            group(CDI)
            {
                Caption = 'CDI Documentary Credit', Comment = 'ESP="CDI Crédito Documentario"';
                Visible = false;
                Enabled = false;

                field("CDI Amount"; Rec."CDI Amount")
                {
                    ApplicationArea = All;
                }
                field("CDI Shipping date"; Rec."CDI Shipping date")
                {
                    ApplicationArea = All;
                }
                field("CDI Due Date"; Rec."CDI Due Date")
                {
                    ApplicationArea = All;
                }
                field("CDI Situation"; Rec."CDI Situation")
                {
                    ApplicationArea = All;
                }
                field("CDI Currency Code"; Rec."CDI Currency Code")
                {
                    ApplicationArea = All;
                }
                field("CDI Bank"; Rec."CDI Bank")
                {
                    ApplicationArea = All;
                }
                field("CDI Bank Ref"; Rec."CDI Bank Ref")
                {
                    ApplicationArea = All;
                }
            }
            // + Estadísticos de CDI
        }
        */
        //<<
        addlast(General)
        {
            field("Inspection status"; Rec."Inspection status")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
        addbefore("Foreign Trade")
        {
            group("Import Order")
            {
                Caption = 'Import Order', comment = 'ESP="Importación pedido"';

                field("BBT Status"; Rec."BBT Status")
                {
                    ApplicationArea = All;
                    Caption = 'Import Status', Comment = 'ESP="Estado Importación"';
                    Visible = false;
                }
                field("ETD PO"; Rec."ETD PO")
                {
                    ApplicationArea = Basic;
                    Caption = 'ETD PO';
                    //>> BBT 13/05/2026. IMPORT STATUS. Se utiliza el desglose de LeadTimes del Producto
                    trigger OnValidate()
                    begin
                        Rec.ReCalcDates(Rec);
                    end;
                    //<<
                }
                field("BBT ETA Planning"; Rec."BBT ETA Planning")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("BBT Proforma"; Rec."BBT Proforma")
                {
                    ApplicationArea = All;
                }
                field("BBT ETD PI"; Rec."BBT ETD PI")
                {
                    ApplicationArea = All;
                    //>> BBT 13/05/2026. IMPORT STATUS. Se utiliza el desglose de LeadTimes del Producto
                    trigger OnValidate()
                    begin
                        Clear(Rec."BBT LC Opening Date");
                        if Rec."BBT ETD PI" <> 0D then begin
                            // Cálculo de la fecha para abrir la carta de credito
                            Rec."BBT LC Opening Date" := CalcDate('-2M', Rec."BBT ETD PI");

                            //>> BBT 13/05/2026. IMPORT STATUS. Se utiliza el desglose de LeadTimes del Producto
                            Rec.ReCalcDates(Rec);
                            //<<
                        end;
                    end;
                }
                field("BBT LC Opening Date"; Rec."BBT LC Opening Date")
                {
                    ApplicationArea = All;
                }
                field("BBT LC Status"; Rec."BBT LC Status")
                {
                    ApplicationArea = All;
                }
                field("BBT LC Date Received"; Rec."BBT LC Date Received")
                {
                    ApplicationArea = All;
                }
                field("BBT LC No."; Rec."BBT LC No.")
                {
                    ApplicationArea = All;
                }
                field("BBT Bank"; Rec."BBT Bank")
                {
                    ApplicationArea = All;
                }
                field("BBT ETD LC"; Rec."BBT ETD LC")
                {
                    ApplicationArea = All;
                }
                field("BBT Due Date ETD PI"; Rec."BBT Due Date ETD PI")
                {
                    Caption = 'Date in Warehouse', Comment = 'ESP"En Almacén desde ETD-PI"';
                    ApplicationArea = All;
                }
                field("BBT Situation"; Rec."BBT Situation")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }
    actions
    {
        addlast("Print")
        {
            action("BBT Credit Letter")
            {
                ApplicationArea = All;
                Caption = 'Print Credit Letter', Comment = 'ESP="Imprimir carta de crédito"';
                Ellipsis = true;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category10;
                Image = PrintForm;
                ToolTip = 'View or print the Credit Letter.', Comment = 'ESP="Imprimir carta de crédito"';

                trigger OnAction()
                var
                    rlPurchaseHeader: Record "Purchase Header";
                begin
                    rlPurchaseHeader.Reset();
                    rlPurchaseHeader.SetRange("No.", Rec."No.");
                    Report.Run(Report::"BBT Credit Letter", true, true, rlPurchaseHeader);
                end;
            }
        }
        addafter("Co&mments")
        {
            action("Diario Consumos (subcontratación)")
            {
                ApplicationArea = Basic;
                Caption = 'Diario Consumos (subcontratación)';
                Image = ConsumptionJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Consumption Journal";
                Visible = false;
            }
            action("Enviar SGA")
            {
                ApplicationArea = Basic;
                Caption = 'Enviar SGA';
                Enabled = SGAEnabled;
                Visible = SGAEnabled;
                Image = SKU;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ProcesosSGA: Codeunit 50000;
                begin
                    if Rec."Status SGA" <> Rec."status sga"::" " then begin
                        if Confirm('LA MODIFICACION DEL ESTATUS, PUEDE PROVOCAR PROBLEMAS DE INCONSISTENCIA CON EL SGA. CONTINUAR?', false) then begin
                            Rec."Status SGA" := Rec."status sga"::" ";
                            Rec.Modify;
                        end;
                    end
                    else begin
                        Rec.ModificadoSGA := false;
                        Rec.Modify;
                        ProcesosSGA.GestionPedidoCompra(Rec."No.");
                        Clear(ProcesosSGA);
                    end;
                end;
            }
            action(Importación)
            {
                ApplicationArea = Suite;
                Caption = 'Import Status', Comment = 'ESP="Estado Importación"';
                Ellipsis = false;
                Image = OrderPromisingSetup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                Var
                    rPurchaseSetup: Record "Purchases & Payables Setup";
                    rPurchaseLineSelec: Record "Purchase Line";
                    rPurchaseHeaderSelec: Record "Purchase Header";
                    rImportOrderStatus: Record "BBT Import Order Status";
                begin
                    rImportOrderStatus.InitializeRecord(SessionId(), rImportOrderStatus);
                    rImportOrderStatus.Reset();

                    rPurchaseSetup.Get();
                    rPurchaseSetup.TestField("BBT Vend. Post. Gr. Imp. Ord.");


                    If not Rec."Include Import Status" then begin
                        //Selección estandar de lineas de pedidos de importación productos acabados (Item Category)
                        rPurchaseLineSelec.Reset();
                        rPurchaseLineSelec.SetRange("Document Type", Rec."Document Type");
                        rPurchaseLineSelec.SetRange("Document No.", Rec."No.");
                        rPurchaseLineSelec.SetRange(Type, rPurchaseLineSelec.Type::Item);
                        rPurchaseLineSelec.SetFilter("Item Category Code", '1*|2*|3*|4*|5*|6*|7*|8*');
                        rPurchaseLineSelec.SetFilter("Qty. to Receive", '<>%1', 0);
                        rPurchaseLineSelec.SetRange("Gen. Bus. Posting Group", rPurchaseSetup."BBT Vend. Post. Gr. Imp. Ord.");
                        if rPurchaseLineSelec.FindSet() then begin
                            repeat
                                //rImportOrderStatutes.MoveData(rImportOrderStatutes, rPurchaseLineSelec);
                                rImportOrderStatus.MoveData(SessionId(), rImportOrderStatus, rPurchaseLineSelec);
                            until rPurchaseLineSelec.Next() = 0
                        end;
                    end
                    else begin
                        //Selección Especial de lineas de pedidos de importación para productos diversos.
                        rPurchaseLineSelec.Reset();
                        rPurchaseLineSelec.SetRange("Document Type", Rec."Document Type");
                        rPurchaseLineSelec.SetRange("Document No.", Rec."No.");
                        rPurchaseLineSelec.SetRange(Type, rPurchaseLineSelec.Type::Item);
                        rPurchaseLineSelec.SetFilter("Qty. to Receive", '<>%1', 0);
                        //rPurchaseLineSelec.SetRange("Gen. Bus. Posting Group", rPurchaseSetup."BBT Vend. Post. Gr. Imp. Ord.");
                        if rPurchaseLineSelec.FindSet() then begin
                            repeat
                                //rImportOrderStatutes.MoveData(rImportOrderStatutes, rPurchaseLineSelec);
                                rImportOrderStatus.MoveData(SessionId(), rImportOrderStatus, rPurchaseLineSelec);
                            until rPurchaseLineSelec.Next() = 0
                        end;
                    end;

                    // SOLO los registros de la sesión actual
                    //rImportOrderStatus.Reset();
                    //rImportOrderStatus.SetRange("BBT Session Id", SessionId());
                    //if rImportOrderStatus.FindSet() then;

                    if rImportOrderStatus.IsEmpty then
                        Error('La selección no contiene pedidos con datos de importación')
                    else
                        Page.Run(Page::"BBT Import Order Status", rImportOrderStatus);
                end;
            }
        }
        addafter("&Print")
        {
            action("Email Confirmation")
            {
                ApplicationArea = Basic;
                Caption = 'Email Confirmation';
                Ellipsis = true;
                Image = Email;
                Visible = false;

                trigger OnAction()
                var
                    DocPrint: Codeunit "Document-Print";
                begin
                    //EmailPurchHeader(Rec);
                end;
            }
        }
    }
    var
        rPurchLines: Record "Purch. Rcpt. Line";
        //rItemLedger: Record "Item Ledger Entry";
        _PurchLine: Record "Purchase Line";
        _InfoCompany: Record "Company Information";
        //SIIManagement: Codeunit "SII Management";
        Text50000: label 'El pedido esta %1.';
        DocEditable: Boolean;
        SGAEnabled: Boolean;
        OperationDescription: Text[500];
        //>> Obsoleto
        //ExtendedHeader: Record 50041;
        //ActiveField: Boolean;
        //<<
        VendorInvoiceNoMandatory: Boolean;
        DocNoVisible: Boolean;
        ShowWorkflowStatus: Boolean;
        JobQueueVisible: Boolean;
        HasIncomingDocument: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;

    trigger OnOpenPage()
    begin
        SetDocNoVisible;
        // SGA
        SetDocEditable;

        //>> BBT. 01/06/2026. Obsoleto. No se está usando la tabla extendida de la Purchase Header
        /*
            //RPC-02
            IF ExtendedHeader.GET(rec."Document Type", rec."No.") THEN BEGIN
            END
            ELSE
                ExtendedHeader.RESET;
            //RPC-02
            */

        //>> BBT. 01/06/2026. Calculo de las fechas de entrega
        Rec.ReCalcDates(Rec);
        //<<

    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
        ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(rec.RECORDID);

        //>> BBT. 01/06/2026. Obsoleto. No se está usando la tabla extendida de la Purchase Header
        /*
        //RPC-02
        IF ExtendedHeader.GET(rec."Document Type", rec."No.") THEN BEGIN
        END
        ELSE
            ExtendedHeader.RESET;
        //RPC-02
        */
        //<<
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance;
        // SGA
        SetDocEditable;

        //>> BBT. 01/06/2026. Obsoleto. No se está usando la tabla extendida de la Purchase Header
        /*
        //RPC-02
        IF ExtendedHeader.GET(rec."Document Type", rec."No.") THEN BEGIN
        END
        ELSE
            ExtendedHeader.RESET;
        //RPC-02
        */
        //<<
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SAVERECORD;
        // + SGA
        IF (rec."Status SGA" IN [rec."Status SGA"::"Enviado SGA", rec."Status SGA"::"Bloqueado SGA"]) AND (rec."Document Type" = rec."Document Type"::Order) THEN BEGIN
            IF rec."Status SGA" = rec."Status SGA"::"Bloqueado SGA" THEN IF NOT CONFIRM('El documento se encuentra bloqueado por el SGA.¿Desea continuar?', FALSE) THEN ERROR('Documento no borrado');
            _PurchLine.RESET;
            _PurchLine.SETRANGE("Document Type", rec."Document Type");
            _PurchLine.SETRANGE("Document No.", rec."No.");
            _PurchLine.CALCSUMS("Outstanding Quantity");
            IF _PurchLine."Outstanding Quantity" <> 0 THEN ERROR(Text50000, rec."Status SGA");
        END;
        // - SGA
        EXIT(rec.ConfirmDeletion);
    end;



    //>> BBT. 01/06/2026. Obsoleto. No se está usando la tabla extendida de la Purchase Header
    /*
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //RPC-02
        IF ExtendedHeader.GET(rec."Document Type", rec."No.") THEN BEGIN
        END
        ELSE
            ExtendedHeader.RESET;
        //RPC-02
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        UserMgt: Codeunit "User Management";
    begin
        //RPC-02
        IF ExtendedHeader.GET(rec."Document Type", rec."No.") THEN BEGIN
        END
        ELSE
            ExtendedHeader.RESET;
        //RPC-02
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF ExtendedHeader.GET(rec."Document Type", rec."No.") THEN BEGIN
        END
        ELSE
            ExtendedHeader.RESET;
    end;
    */
    //<<

    procedure SetExtDocNoMandatoryCondition()
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        PurchasesPayablesSetup.GET;
        VendorInvoiceNoMandatory := PurchasesPayablesSetup."Ext. Doc. No. Mandatory";
    end;

    procedure SetDocEditable()
    var
        _InfoCompany: Record "Company Information";
    begin
        // SGA
        _InfoCompany.Get;
        DocEditable := (Rec."Document Type" <> Rec."document type"::Order) or (Rec."Status SGA" = Rec."status sga"::" ") or (not _InfoCompany.SGA);
        SGAEnabled := _InfoCompany.SGA;

        //>> BBT. 01/06/2026. Obsoleto. No se está usando la tabla extendida de la Purchase Header
        /*
        //RPC-02
        ActiveField := EnableFields(Rec);
        //RPC-02
        */
        //<<
    end;

    procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.PurchaseDocumentNoIsVisible(DocType::Order, rec."No.");
    end;

    //>> BBT. 01/06/2026. Obsoleto. No se está usando la tabla extendida de la Purchase Header
    /*
    local procedure ValidateExtended(PurchHeader: Record "Purchase Header"; ExtendedHead: Record 50041)
    var
        RecExtendHeader: Record 50041;
    begin
        //ExtendedHead.RESET;
        RecExtendHeader.SetRange("Document Type", PurchHeader."Document Type");
        RecExtendHeader.SetRange("No.", PurchHeader."No.");
        if RecExtendHeader.FindFirst then begin
            RecExtendHeader.Recambio := ExtendedHead.Recambio;
            RecExtendHeader.Proforma := ExtendedHead.Proforma;
            RecExtendHeader."ETD LC" := ExtendedHead."ETD LC";
            RecExtendHeader."Banco LC" := ExtendedHead."Banco LC";
            RecExtendHeader."No. LC" := ExtendedHead."No. LC";
            RecExtendHeader."Fecha LC Recibida" := ExtendedHead."Fecha LC Recibida";
            RecExtendHeader."Status LC" := ExtendedHead."Status LC";
            RecExtendHeader."Inspección" := ExtendedHead."Inspección";
            RecExtendHeader."Resultado Insp." := ExtendedHead."Resultado Insp.";
            RecExtendHeader.Forwarder := ExtendedHead.Forwarder;
            RecExtendHeader."F. Presentación ENS" := ExtendedHead."F. Presentación ENS";
            RecExtendHeader."F. Doc Originales" := ExtendedHead."F. Doc Originales";
            RecExtendHeader."F. Despacho" := ExtendedHead."F. Despacho";
            RecExtendHeader."Observ. Importación" := ExtendedHead."Observ. Importación";
            RecExtendHeader."Fecha apertura LC" := ExtendedHead."Fecha apertura LC";
            RecExtendHeader.Modify;
        end
        else begin
            RecExtendHeader.Init;
            RecExtendHeader."Document Type" := PurchHeader."Document Type";
            RecExtendHeader."No." := PurchHeader."No.";
            RecExtendHeader.Insert;
            RecExtendHeader.Recambio := ExtendedHead.Recambio;
            RecExtendHeader.Proforma := ExtendedHead.Proforma;
            RecExtendHeader."ETD LC" := ExtendedHead."ETD LC";
            RecExtendHeader."Banco LC" := ExtendedHead."Banco LC";
            RecExtendHeader."No. LC" := ExtendedHead."No. LC";
            RecExtendHeader."Fecha LC Recibida" := ExtendedHead."Fecha LC Recibida";
            RecExtendHeader."Status LC" := ExtendedHead."Status LC";
            RecExtendHeader."Inspección" := ExtendedHead."Inspección";
            RecExtendHeader."Resultado Insp." := ExtendedHead."Resultado Insp.";
            RecExtendHeader.Forwarder := ExtendedHead.Forwarder;
            RecExtendHeader."F. Presentación ENS" := ExtendedHead."F. Presentación ENS";
            RecExtendHeader."F. Doc Originales" := ExtendedHead."F. Doc Originales";
            RecExtendHeader."F. Despacho" := ExtendedHead."F. Despacho";
            RecExtendHeader."Observ. Importación" := ExtendedHead."Observ. Importación";
            RecExtendHeader."Fecha apertura LC" := ExtendedHead."Fecha apertura LC";
            RecExtendHeader.Modify;
        end;
    end;

    local procedure EnableFields(PurchHeader: Record "Purchase Header"): Boolean
    var
        PaymentMehtod: Record "Payment Method";
    begin
        PaymentMehtod.Reset;
        PaymentMehtod.SetRange(Code, Rec."Payment Method Code");
        PaymentMehtod.SetRange("Credit Letter", true);
        if PaymentMehtod.FindFirst then
            exit(true)
        else
            exit(false);
    end;
    */
    //<<

    local procedure EmailPurchHeader(PurchHeader: Record "Purchase Header")
    var
        DocPrint: Codeunit "Document-Print";
    begin
        //DocPrint.DoPrintPurchHeader(PurchHeader, TRUE);
    end;

    local procedure DoPrintPurchHeader(PurchHeader: Record "Purchase Header"; SendAsEmail: Boolean)
    var
        PurchSetup: Record "Purchases & Payables Setup";
        PurchLine: Record "Purchase Line";
        PurchCalcDisc: Codeunit "Purch - Calc Disc. By Type";
        ReportSelections: Record "Report Selections";
        CustomReportSelection: Record "Custom Report Selection";
        DocumentMailing: Codeunit "Document-Mailing";
        AttachmentFilePath: Text[250];
    begin
        PurchHeader.SETRANGE("No.", PurchHeader."No.");
        PurchSetup.GET;
        IF PurchSetup."Calc. Inv. Discount" THEN BEGIN
            PurchLine.RESET;
            PurchLine.SETRANGE("Document Type", PurchHeader."Document Type");
            PurchLine.SETRANGE("Document No.", PurchHeader."No.");
            PurchLine.FINDFIRST;
            PurchCalcDisc.RUN(PurchLine);
            PurchHeader.GET(PurchHeader."Document Type", PurchHeader."No.");
            COMMIT;
        END;
        CASE PurchHeader."Document Type" OF
            PurchHeader."Document Type"::Quote:
                ReportSelections.SETRANGE(Usage, ReportSelections.Usage::"P.Quote");
            PurchHeader."Document Type"::"Blanket Order":
                ReportSelections.SETRANGE(Usage, ReportSelections.Usage::"P.Blanket");
            PurchHeader."Document Type"::Order:
                ReportSelections.SETRANGE(Usage, ReportSelections.Usage::"P.Order");
            PurchHeader."Document Type"::"Return Order":
                ReportSelections.SETRANGE(Usage, ReportSelections.Usage::"P.Return");
            PurchHeader."Document Type"::Invoice:
                ReportSelections.SETRANGE(Usage, ReportSelections.Usage::"P.Invoice");
            PurchHeader."Document Type"::"Credit Memo":
                ReportSelections.SETRANGE(Usage, ReportSelections.Usage::"P.Cr.Memo");
            ELSE
                EXIT;
        END;
        //IF CustomReportSelection.PrintVendorReports(PurchHeader, SendAsEmail, FALSE) = 0 THEN BEGIN
        ReportSelections.SETFILTER("Report ID", '<>0');
        ReportSelections.FIND('-');
        REPEAT
            IF SendAsEmail THEN BEGIN
                ////>> BBT  Fix Compatibility With Extension 28.0
                //AttachmentFilePath := SavePurchHeaderReportAsPdf(PurchHeader, ReportSelections."Report ID");
                //DocumentMailing.EmailFileFromPurchHeader(PurchHeader, AttachmentFilePath, CustomReportSelection);
                //<<
            END
            ELSE
                REPORT.RUNMODAL(ReportSelections."Report ID", TRUE, FALSE, PurchHeader)
        UNTIL ReportSelections.NEXT = 0;
    END;

    procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        JobQueueVisible := rec."Job Queue Status" = rec."Job Queue Status"::"Scheduled for Posting";
        HasIncomingDocument := rec."Incoming Document Entry No." <> 0;
        SetExtDocNoMandatoryCondition;
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(rec.RECORDID);
    end;
}
