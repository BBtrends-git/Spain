PageExtension 50004 "BBT Sales Order" extends "Sales Order"
{
    layout
    {
        addafter("Ship-to Contact")
        {
            field("Sell-to Phone No. 2"; Rec."Sell-to Phone No.")
            {
                ApplicationArea = Basic;
                Importance = Standard;
                Caption = 'Nº de teléfono';
            }
        }
        //>> Obsoleto. PRECINTIA
        /*
        addafter("Sell-to Contact")
        {
            field("DIR Code"; Rec."DIR Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Dir Code field.';
            }
        }
        */
        //<<
        addafter(Status)
        {
            field("Status SGA"; Rec."Status SGA")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Status SGA field.';
                Visible = SGAEnable;
                Enabled = SGAEnable;
            }
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the document.';
            }
            field("EDI - EDI Order"; Rec."EDI - EDI Order")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the EDI - Pedido EDI field.';
                Enabled = false;
            }
            field("EDI - Do not send EDI"; Rec."EDI - Do not send EDI")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the EDI - No enviar por EDI field.';
                Visible = false;
                enabled = false;
            }
            field("Exclude packaging enforcement"; Rec."Exclude packaging enforcement")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Excluir obligatoriedad embalajes field.';
            }
        }
        addafter("Sell-to Contact")
        {
            field("Number of Packages"; Rec."Number of Packages")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Number of Packages field.';
            }
            field(Reference; Rec.Reference)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Referencia field.';
            }
            field("Posting No."; Rec."Posting No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the posted invoice that will be created if you post the sales invoice.';
            }
            field("Posting No. Series"; Rec."Posting No. Series")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting No. Series field.';
            }
        }
        addafter("Prepmt. Pmt. Discount Date")
        {
            group("EDI - Pedido")
            {
                Visible = false;

                field("EDI - Currency Code"; Rec."EDI - Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI - Cód. Moneda field.';
                }
                field("EDI - Total Amount"; Rec."EDI - Total Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI - Importe total neto field.';
                }
                field("EDI - Total discount/charges"; Rec."EDI - Total discount/charges")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI - Importe total dtos./cargos field.';
                }
                field("EDI - Amount Base"; Rec."EDI - Amount Base")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI - Base imponible field.';
                }
                field("EDI - Taxes amt."; Rec."EDI - Taxes amt.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI - Importe total impuestos field.';
                }
                field("EDI - Paying amt."; Rec."EDI - Paying amt.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI - Importe a pagar field.';
                }
                field("EDI - Gross amt."; Rec."EDI - Gross amt.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI - Importe total bruto field.';
                }
                field("EDI - Order Type"; Rec."EDI - Order Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI - Tipo pedido field.';
                }
                field("EDI - Additional ref type"; Rec."EDI - Additional ref type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI - Tipo referencia adicional field.';
                }
                field("EDI - Message function"; Rec."EDI - Message function")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI - Función mensaje field.';
                }
                field("EDI - Shipment cost payment"; Rec."EDI - Shipment cost payment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI - Método pago costes trans. field.';
                }
                field("EDI - Delivery condition"; Rec."EDI - Delivery condition")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI - Condiciones entrega field.';
                }
                field("EDI - Unique due date"; Rec."EDI - Unique due date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI - Fecha vto. único field.';
                }
                field("EDI - Additional info"; Rec."EDI - Additional info")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI - Información adicional field.';
                }
                field("EDI - Additional ref No."; Rec."EDI - Additional ref No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI - Nº referencia adicional field.';
                }
                field("EDI - Comments"; Rec."EDI - Comments")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI - Observaciones field.';
                }
            }
            group("EDI - Factura")
            {
                Visible = false;

                field("EDI - Invoice message function"; Rec."EDI - Invoice message function")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI - Función mensaje fra. field.';
                }
                field("EDI - Contract No."; Rec."EDI - Contract No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EDI - Nº Contrato/Acuerdo field.';
                }
            }
        }
        //>> BBT 01/07/2025.
        /*
        addlast("Shipping and Billing")
        {
            field("Request delivery appointment"; Rec."Request delivery appointment")
            {
                ApplicationArea = All;
            }
        }
        */
        //<<
        addlast(General)
        {
            field("Fecha ETD PI"; Rec."Fecha ETD PI")
            {
                ApplicationArea = All;
            }
            field("Fecha vencimiento ETD PI"; Rec."Fecha vencimiento ETD PI")
            {
                ApplicationArea = All;
            }
            field("Logistics conditions"; Rec."Logistics conditions")
            {
                ApplicationArea = All;
                MultiLine = true;
            }
            //>> BBT. 31/03/2025. SMG
            /*
            field("Blocked for Short Margin"; Rec."Blocked for Short Margin")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bloqueado por margen insuficiente field.';
            }
            */
        }
    }
    actions
    {
        addafter("Reject IC Sales Order")
        {
            action("Update Prices")
            {
                Caption = 'Update Prices', comment = 'ESP="Actualizar precios"';
                ApplicationArea = All;
                Image = UpdateUnitCost;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    UpdateSalesOrdersPrice: Report "BBT Update Sales Orders Prices";
                    LocalText000Lbl: Label 'The order prices will be updated. Do you wish to continue?', comment = 'ESP="Se van a actualizar los precios del pedido. ¿Desea continuar?"';
                    LocalText001Lbl: Label 'Process cancelled by the user', comment = 'ESP="Proceso cancelado por el usuario"';
                begin
                    if Confirm(LocalText000Lbl, true) then begin
                        SalesHeader.Reset();
                        SalesHeader.SetRange("Document Type", Rec."Document Type");
                        SalesHeader.SetRange("No.", Rec."No.");
                        SalesHeader.SetRange("Sell-to Customer No.", Rec."Sell-to Customer No.");
                        Clear(UpdateSalesOrdersPrice);
                        UpdateSalesOrdersPrice.SetTableView(SalesHeader);
                        UpdateSalesOrdersPrice.RunModal();
                    end
                    else
                        Error(LocalText001Lbl);
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref("Update Prices_Promoted"; "Update Prices")
            { }
        }
    }
    var
        _InfoCompany: Record "Company Information";
        SGAEnable: Boolean;

    trigger OnAfterGetRecord()
    begin
        SetEnabledSGA();
    end;

    local procedure SetEnabledSGA()
    begin
        // SGA
        SGAEnable := false;
        if _InfoCompany.Get then
            SGAEnable := _InfoCompany.SGA;
    end;
}
