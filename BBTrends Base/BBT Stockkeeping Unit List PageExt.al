PageExtension 50184 "BBT Stockkeeping Unit List" extends "Stockkeeping Unit List"
{
    layout
    {
        modify("Assembly Policy")
        {
            Visible = false;
        }
        addafter("Location Code")
        {
            field("Components at Location"; Rec."Components at Location")
            {
                ApplicationArea = Basic;
            }
            field("Transfer-from Code"; Rec."Transfer-from Code")
            {
                ApplicationArea = Basic;
            }
            field("Vendor No."; Rec."Vendor No.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Maximum Inventory")
        {
            field("Reordering Policy"; Rec."Reordering Policy")
            {
                ApplicationArea = Basic;
            }
            field("Transfer-Level Code"; Rec."Transfer-Level Code")
            {
                ApplicationArea = Basic;
            }
            field("Safety Stock Quantity"; Rec."Safety Stock Quantity")
            {
                ApplicationArea = Basic;
            }
            field("Minimum Order Quantity"; Rec."Minimum Order Quantity")
            {
                ApplicationArea = Basic;
            }
            field("Maximum Order Quantity"; Rec."Maximum Order Quantity")
            {
                ApplicationArea = Basic;
            }
            field("Order Multiple"; Rec."Order Multiple")
            {
                ApplicationArea = Basic;
            }
            field("Lot Size"; Rec."Lot Size")
            {
                ApplicationArea = Basic;
            }
            field("Lot Accumulation Period"; Rec."Lot Accumulation Period")
            {
                ApplicationArea = Basic;
            }
            field("Lead Time Calculation"; Rec."Lead Time Calculation")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
