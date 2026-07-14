PageExtension 50014 "BBT Sales Order List" extends "Sales Order List"
{
    layout
    {
        modify("Posting Date")
        {
            ApplicationArea = Basic;
            Visible = true;
        }
        addafter("No.")
        {
            field("Last Posting No."; Rec."Last Posting No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Last Posting No. field.';
            }
            field("Last Shipping No."; Rec."Last Shipping No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Last Shipping No. field.';
            }
        }
        addafter(Status)
        {
            field("Status SGA"; Rec."Status SGA")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Status SGA field.';
                Visible = SGAEnabled;
                Enabled = SGAEnabled;
            }
        }
        addbefore("Posting Date")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = Basic;
                Visible = true;
            }
        }
        addafter("Sell-to Customer Name")
        {
            field("Sell-to Customer Name 2"; Rec."Sell-to Customer Name 2")
            {
                ApplicationArea = Basic;
                Visible = true;
            }
        }
    }

    var
        _InfoCompany: Record "Company Information";
        SGAEnabled: Boolean;

    trigger OnOpenPage()

    begin
        // SGA
        _InfoCompany.Get;
        SGAEnabled := _InfoCompany.SGA;
    end;
}
