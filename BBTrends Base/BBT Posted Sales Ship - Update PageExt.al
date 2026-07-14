PageExtension 50010 "BBT Posted Sales Ship - Update" extends "Posted Sales Shipment - Update"
{
    layout
    {
        addlast(General)
        {
            field("Requested Delivery Date"; Rec."Requested Delivery Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Requested Delivery Date field.';
            }
            field("External Document No."; rec."External Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the External Document No. field.';
            }
            field("Sell-to Phone No."; rec."Sell-to Phone No.")
            {
                ApplicationArea = All;
                Visible = true;
                Editable = true;
            }
            field("Sell-to E-Mail"; rec."Sell-to E-Mail")
            {
                ApplicationArea = All;
                Visible = true;
                Editable = true;
            }
            field("Ship-to Name"; rec."Ship-to Name")
            {
                ApplicationArea = All;
                Visible = true;
                Editable = true;
            }
            field("Ship-to Address"; rec."Ship-to Address")
            {
                ApplicationArea = All;
                Visible = true;
                Editable = true;
            }
            field("Ship-to Address 2"; rec."Ship-to Address 2")
            {
                ApplicationArea = All;
                Visible = true;
                Editable = true;
            }
            field("Ship-to Post Code"; Rec."Ship-to Post Code")
            {
                ApplicationArea = All;
                Visible = true;
                Editable = true;
            }
        }
        addafter("Package Tracking No.")
        {
            field("Sh. Agent - Status"; Rec."Sh. Agent - Status")
            {
                ApplicationArea = All;
                Visible = False;
                Editable = False;
            }
            field("Shipment Finished"; Rec."Shipment Finished")
            {
                ApplicationArea = All;
                Visible = False;
                Editable = False;
            }
            field(Reference; Rec.Reference)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Referencia field.';
            }
            field("Total Gross Weight (Actual)"; Rec."Total Gross Weight (Actual)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gross Weight field.';
            }
            field("Total Net Weight (Actual)"; Rec."Total Net Weight (Actual)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unit Net Weight field.';
            }
            field("Total Volume (Actual)"; Rec."Total Volume (Actual)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Volume field.';
            }
            field("Number of Packages"; Rec."Number of Packages")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Number of Packages field.';
            }
        }
    }
}
