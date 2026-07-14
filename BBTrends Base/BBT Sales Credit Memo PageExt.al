PageExtension 50118 "BBT Sales Credit Memo" extends "Sales Credit Memo"
{
    layout
    {
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Reason Code")
        {
            Importance = Standard;
            ShowMandatory = true;
        }
        addafter("Salesperson Code")
        {
            field("Service Zone Code"; Rec."Service Zone Code")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
        }
        addafter("Corrected Invoice No.")
        {
            field("Posting No. Series"; Rec."Posting No. Series")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
        }
        addfirst(Billing)
        {
            field("Ship-to Code"; Rec."Ship-to Code")
            {
                ApplicationArea = Basic;
                Importance = Promoted;
            }
        }
        addafter("Shipment Date")
        {
            field("Shipping Agent Code"; Rec."Shipping Agent Code")
            {
                ApplicationArea = Basic;
                Importance = Promoted;
            }
            field("Shipment Method Code"; Rec."Shipment Method Code")
            {
                ApplicationArea = Basic;
                Importance = Promoted;
            }
            field("Number of Packages"; Rec."Number of Packages")
            {
                ApplicationArea = Basic;
                Importance = Promoted;
            }
            field(Reference; Rec.Reference)
            {
                ApplicationArea = Basic;
                Importance = Promoted;
            }
        }
        addafter("Status")
        {
            field("EDI order"; Rec."EDI - EDI Order")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'EDI Document', Comment = 'ESP="Documento EDI"';
                Importance = Standard;
                Enabled = false;
            }
        }
        modify(Status)
        {
            trigger OnBeforeValidate()
            begin
                if rec."Reason Code" = '' then
                    Error('El código de auditoría es obligatorio');
            end;
        }
    }
}
