PageExtension 50001 "BBT Customer Card" extends "Customer Card"
{
    layout
    {
        modify(County)
        {
            Visible = true;
            ApplicationArea = all;
        }
        modify("Bill-to Customer No.")
        {
            Importance = Standard;
            ApplicationArea = all;
        }
        addafter(Address)
        {
            field(Abbreviation; Rec.Abbreviation)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Abbreviation field.';
            }
            field("Our Account No."; Rec."Our Account No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Our Account No. field.';
            }
            field("Contract No"; Rec."Contract No")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No contrato field.';
            }
        }
        addafter("Not in AEAT")
        {
            field("BBT Do Not Send Inv. To SII"; Rec."BBT Do Not Send Inv. To SII")
            {
                ApplicationArea = All;
            }
        }
        addafter(General)
        {
            group(EDI)
            {
                field("No EDI"; Rec."No EDI")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No EDI field.';
                }
                field("Send EDI Documents"; Rec."Send EDI Documents")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Enviar documentos EDI field.';
                }
                field("EDI Directory"; Rec."EDI Directory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Directory EDI field.';
                }
                field("EDI ID"; Rec."EDI ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Id. EDI field.';
                }
                field("Invoice EDI"; Rec."Invoice EDI")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Id. EDI Factura field.';
                }
                field("Cr Memo EDI"; Rec."Cr Memo EDI")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Id. EDI Abono field.';
                }
                field("Cód. Departamento"; Rec."Cód. Departamento")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cód. Departamento field.';
                }
                field("Cód. Sucursal"; Rec."Cód. Sucursal")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cód. Sucursal field.';
                }
                field("BBT EDI Invoice Sending Delay"; Rec."BBT EDI Invoice Sending Delay")
                {
                    ApplicationArea = All;
                }
            }
        }
        addafter("Bill-to Customer No.")
        {
            field("VAT PL"; Rec."VAT PL")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VAT PL field.';
            }
            //>> BBT 11/03/2026. Marcado como obsoleto
            /*
            field("Invoice Copies"; Rec."Invoice Copies")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Invoice Copies field.';
            }
            */
            field("Billing Period"; Rec."Billing Period")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Billing Period field.';
            }
            field("Risk Rating"; Rec."Risk Rating")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Risk Rating field.';
            }
            field("Active CyC"; Rec."Active CyC")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Active CyC field.';
            }
            field("CyC Policy"; Rec."CyC Policy")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CyC Policy field.';
            }
            field(Reference; Rec.Reference)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reference field.';
            }
            field("Valued Shipment"; Rec."Valued Shipment")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Valued shipment field.';
            }
        }
        addlast(Payments)
        {
            field("Collection Bank Account"; Rec."Collection Bank Account")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Collection Bank Account field.';
            }
        }
        addlast(Shipping)
        {
            //>> Obsolete
            //field("Customer Pool"; Rec."Customer Pool")
            //{
            //    ApplicationArea = All;
            //    ToolTip = 'Specifies the value of the Customer Pool field.';
            //}
            field("Request delivery appointment"; Rec."Request delivery appointment")
            {
                ApplicationArea = All;
            }
        }
        addlast(Invoicing)
        {
            field("Invoice Type"; Rec."Invoice Type")
            {
                ApplicationArea = All;
            }
        }
        addlast(Shipping)
        {
            field("Logistics conditions"; Rec."Logistics conditions")
            {
                ApplicationArea = All;
                MultiLine = true;
            }
        }
    }
    actions
    {
        addlast("&Customer")
        {
            action("Warranties")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Warranties', comment = 'ESP="Garantías"';
                Image = EditReminder;
                RunObject = Page "BBT Warranty Lines";
                RunPageLink = "Customer No." = FIELD("No.");
                ToolTip = 'View or set up the customer''s warranties. You can set up any number of warranties for each customer.',
                comment = 'ESP="Ver o configurar las garantías del cliente. Puede configurar cualquier cantidad de garantías para cada cliente."';
            }
        }
    }
}
