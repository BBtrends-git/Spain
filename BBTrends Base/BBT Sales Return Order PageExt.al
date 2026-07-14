PageExtension 50209 "BBT Sales Return Order" extends "Sales Return Order"
{
    layout
    {
        modify("No.")
        {
            Editable = doceditable;
        }
        modify("Sell-to Customer No.")
        {
            Editable = doceditable;
        }
        modify("Sell-to Contact No.")
        {
            Editable = doceditable;
        }
        modify("Sell-to Customer Name")
        {
            Editable = doceditable;
        }
        modify("Sell-to Address")
        {
            Editable = doceditable;
        }
        modify("Sell-to Address 2")
        {
            Editable = doceditable;
        }
        modify("Sell-to Post Code")
        {
            Editable = doceditable;
        }
        modify("Sell-to City")
        {
            Editable = doceditable;
        }
        modify("Sell-to Contact")
        {
            Editable = doceditable;
        }
        modify("Sell-to County")
        {
            Editable = doceditable;
        }
        modify("No. of Archived Versions")
        {
            Editable = doceditable;
        }
        modify("Campaign No.")
        {
            Editable = doceditable;
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Editable = doceditable;
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Editable = doceditable;
            Visible = false;
        }
        modify("Job Queue Status")
        {
            Editable = doceditable;
        }
        modify("Corrected Invoice No.")
        {
            Editable = doceditable;
        }
        modify("Foreign Trade")
        {
            Editable = doceditable;
        }
        modify("Your Reference")
        {
            visible = true;
            Importance = Standard;
        }
        modify("Shipping Agent Code")
        {
            Caption = 'Shipping Agent Code', Comment = 'ESP="Código Transportista"';
            ShowMandatory = true;
        }
        addafter("Shipping Agent Code")
        {
            field("Shipment Method Code"; Rec."Shipment Method Code")
            {
                ApplicationArea = All;
            }
        }

        addafter("Document Date")
        {
            field("Requested Delivery Date"; Rec."Requested Delivery Date")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Corrected Invoice No.")
        {
            field("Status SGA"; Rec."Status SGA")
            {
                ApplicationArea = Basic;
                Editable = doceditable;
                Visible = SGAVisible;
            }
            field("Grabado SGA"; Rec."Grabado SGA")
            {
                ApplicationArea = Basic;
                Editable = doceditable;
                Visible = SGAVisible;
            }
            field("Leido SGA"; Rec."Leido SGA")
            {
                ApplicationArea = Basic;
                Editable = doceditable;
                Visible = SGAVisible;
            }
            field("Document Type"; Rec."Document Type")
            {
                ApplicationArea = Basic;
                Enabled = false;
            }
            field("Posting No. Series"; Rec."Posting No. Series")
            {
                ApplicationArea = Basic;
            }
        }
        addfirst("Shipping and Billing")
        {
            field("Ship-to Code"; Rec."Ship-to Code")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Shipment Date")
        {
            field("Number of Packages"; Rec."Number of Packages")
            {
                ApplicationArea = Basic;
            }
            field(Reference; Rec.Reference)
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Your Reference")
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = Basic;
                Importance = Additional;
                ShowMandatory = true;
            }
        }
        addafter("Document Type")
        {
            field("EDI - EDI Order"; Rec."EDI - EDI Order")
            {
                Caption = 'EDI - Return Order', Comment = 'ESP="Devolución EDI"';
                ApplicationArea = Basic;
                Editable = false;
            }
        }
        modify(Status)
        {
            Editable = doceditable;
            trigger OnBeforeValidate()
            begin
                if rec.Status <> rec.Status::Open then begin
                    if rec."Reason Code" = '' then
                        Error('El código de auditoría es obligatorio');
                    if rec."Shipping Agent Code" = '' then
                        Error('El código del Agente de Transporte es obligatorio');
                end;
            end;
        }
    }
    actions
    {
        addafter("Co&mments")
        {
            action("Enviar SGA")
            {
                ApplicationArea = Basic;
                Caption = 'Enviar SGA';
                Enabled = SGAEnable;
                Image = SKU;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = SGAVisible;

                trigger OnAction()
                var
                    ProcesosSGA: Codeunit "Interface SGA";
                begin
                    if Rec."Status SGA" <> Rec."status sga"::" " then Error('Devolución ya enviada');
                    ProcesosSGA.GestionDevolucionVenta(Rec."No.");
                    Clear(ProcesosSGA);
                end;
            }
        }
    }
    var
        //SIIManagement: Codeunit "SII Management";
        _InfoCompany: Record "Company Information";
        DocEditable: Boolean;
        Text50000: label 'Esta devolución esta %1 por el SGA.';
        SGAEnable: Boolean;
        SGAVisible: Boolean;
        OperationDescription: Text[500];
        VendorInvoiceNoMandatory: Boolean;
        DocNoVisible: Boolean;
        ShowWorkflowStatus: Boolean;
        JobQueueVisible: Boolean;
        HasIncomingDocument: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(rec.RECORDID);
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance;
        // SGA
        SetDocEditable;
    end;

    trigger OnClosePage()
    var
        Proceso: Codeunit "Interface SGA";
        _InfoCompany: Record "Company Information";
    begin
        // SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN BEGIN
            CurrPage.UPDATE(FALSE);
            IF rec.ModificadoSGA THEN IF rec."Status SGA" <> rec."Status SGA"::" " THEN Proceso.GestionDevolucionVenta(rec."No.");
        END;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SAVERECORD;
        // + SGA
        _InfoCompany.GET;
        IF _InfoCompany.SGA THEN IF (rec."Status SGA" IN [rec."Status SGA"::"Enviado SGA", rec."Status SGA"::"Bloqueado SGA"]) AND (rec."Document Type" = rec."Document Type"::Order) THEN ERROR(Text50000, rec."Status SGA");
        // - SGA
        EXIT(rec.ConfirmDeletion);
    end;

    trigger OnOpenPage()
    begin
        //>> SGA
        SetDocEditable;
        SetEnabledSGA;
    end;

    local procedure SetDocEditable()
    var
        _InfoCompany: Record "Company Information";
    begin
        // SGA
        _InfoCompany.Get;
        DocEditable := (Rec."Status SGA" = Rec."status sga"::" ") or (not _InfoCompany.SGA);
    end;

    local procedure SetEnabledSGA()
    var
        _InfoCompany: Record "Company Information";
    begin
        // SGA
        _InfoCompany.Get;
        SGAENABLE := _InfoCompany.SGA;
        SGAVisible := _InfoCompany.SGA;
    end;

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

    procedure SetExtDocNoMandatoryCondition()
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        PurchasesPayablesSetup.GET;
        VendorInvoiceNoMandatory := PurchasesPayablesSetup."Ext. Doc. No. Mandatory";
    end;
}
