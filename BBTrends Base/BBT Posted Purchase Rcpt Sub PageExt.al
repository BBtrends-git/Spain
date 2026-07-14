PageExtension 50138 "BBT Posted Purchase Rcpt. Sub" extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        modify("Variant Code")
        {
            Visible = false;
        }
        modify("Return Reason Code")
        {
            Visible = false;
        }
        modify("Bin Code")
        {
            Visible = false;
        }
        modify("Unit of Measure Code")
        {
            Visible = false;
        }
        modify("Quantity Invoiced")
        {
            Visible = false;
        }
        modify("Qty. Rcd. Not Invoiced")
        {
            Visible = false;
        }
        modify("Requested Receipt Date")
        {
            Visible = false;
        }
        modify("Promised Receipt Date")
        {
            Visible = false;
        }
        modify("Planned Receipt Date")
        {
            Visible = false;
        }
        modify("Expected Receipt Date")
        {
            Visible = false;
        }
        modify("Order Date")
        {
            Visible = false;
        }
        modify("Lead Time Calculation")
        {
            Visible = false;
        }
        modify("Job No.")
        {
            Visible = false;
        }
        modify("Prod. Order No.")
        {
            Visible = false;
        }
        modify("Inbound Whse. Handling Time")
        {
            Visible = false;
        }
        modify("Appl.-to Item Entry")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = false;
        }
        modify(Correction)
        {
            Visible = false;
        }
        addfirst(Control1)
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = Basic;
            }
            field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
            {
                ApplicationArea = Basic;
            }
            field("Document No."; Rec."Document No.")
            {
                ApplicationArea = Basic;
            }
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
