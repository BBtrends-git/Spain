PageExtension 50166 "BBT Inventory Setup" extends "Inventory Setup"
{
    layout
    {
        addlast(General)
        {
            field("Depreciation Nos."; Rec."Depreciation Nos.")
            {
                ApplicationArea = All;
            }
            field("Item Depreciation No."; Rec."Item Depreciation No.")
            {
                ApplicationArea = All;
            }
            field("Inventory Depreciation No."; Rec."Inventory Depreciation No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Location Mandatory")
        {
            field("Raw Materials Location Code"; Rec."Raw Materials Location Code")
            {
                ApplicationArea = Basic;
            }
            field("Factory Location Code"; Rec."Factory Location Code")
            {
                ApplicationArea = Basic;
            }
            field("Logistic Location Code"; Rec."Logistic Location Code")
            {
                ApplicationArea = Basic;
            }
            field("Logistic Whse. Profile ID"; Rec."Logistic Whse. Profile ID")
            {
                ApplicationArea = Basic;
            }
        }
    }
}
