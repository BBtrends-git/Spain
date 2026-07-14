PageExtension 50217 "BBT Warehouse Shipment List" extends "Warehouse Shipment List"
{
    layout
    {
        addafter(Status)
        {
            field("Status SGA"; Rec."Status SGA")
            {
                ApplicationArea = Basic;
                Visible = EnabledSGA;
            }
        }
        addafter("Shipment Method Code")
        {
            field("Destination Type"; Rec."Destination Type")
            {
                ApplicationArea = Basic;
                Visible = EnabledSGA;
            }
            field("Destination No."; Rec."Destination No.")
            {
                ApplicationArea = Basic;
                Visible = EnabledSGA;
            }
            field(DestinantionName; DestinantionName)
            {
                ApplicationArea = Basic;
                Visible = EnabledSGA;
                Caption = 'Destination Name';
            }
            field("Source No."; Rec."Source No.")
            {
                Visible = EnabledSGA;
                ApplicationArea = Basic;
            }
            field("Source External Doc"; SourceExternalDoc)
            {
                ApplicationArea = Basic;
                Visible = EnabledSGA;
                Caption = 'Documento Externo';
            }
        }
    }
    var
        rCompayInformation: Record "Company Information";
        EnabledSGA: Boolean;

    trigger OnOpenPage()
    begin
        rCompayInformation.Reset();
        rCompayInformation.Get();
        EnabledSGA := rCompayInformation.SGA;
    end;

    trigger OnAfterGetRecord()
    var
        rSGABlockedDocuments: Record "BBT-IT SGA Blocked Documents";
    begin
        // BBT 24/11/2025. Si el TWO ya no lo tiene bloqueado lo modificamos.
        if EnabledSGA and (rec."Status SGA" = rec."Status SGA"::"Bloqueado SGA") then begin
            rSGABlockedDocuments.Reset();
            if not rSGABlockedDocuments.Get(rSGABlockedDocuments."Document Type"::Sales, rec."No.") then begin
                Rec."Status SGA" := Rec."Status SGA"::"Enviado SGA";
                Rec.Modify();
            end;
        end;

    end;

    local procedure DestinantionName(): Text[50]
    var
        RecCustomer: Record Customer;
        RecVendor: Record Vendor;
    begin
        // SGA
        case Rec."Destination Type" of
            Rec."destination type"::Customer:
                begin
                    RecCustomer.Get(Rec."Destination No.");
                    exit(RecCustomer.Name);
                end;
            Rec."destination type"::Vendor:
                begin
                    RecVendor.Get(Rec."Destination No.");
                    exit(RecVendor.Name);
                end;
        end;
    end;

    local procedure SourceExternalDoc(): Text[50]
    var
        rSalesHeader: Record "Sales Header";
    begin
        if EnabledSGA then
            case Rec."Destination Type" of
                Rec."destination type"::Customer:
                    begin
                        rSalesHeader.Reset;
                        rSalesHeader.SetRange("Document Type", rSalesHeader."document type"::Order);
                        rSalesHeader.SetRange("No.", Rec."Source No.");
                        if rSalesHeader.FindFirst then
                            exit(rSalesHeader."External Document No.")
                        else
                            exit('');
                    end;
                else
                    exit('');
            end;
    end;
}
