page 50105 "BBT Warranty Lines"
{
    ApplicationArea = All;
    Caption = 'Warranty List', comment = 'ESP="Lista Garantía"';
    PageType = List;
    SourceTable = "BBT Warranty Entry";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Warranty Code"; Rec."Warranty Code")
                {
                    ApplicationArea = All;
                }
                field("Warranty Description"; Rec."Warranty Description")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Item Description."; Rec."Item Description")
                {
                    ApplicationArea = All;
                }
                field("Date of Purchase"; Rec."Date of Purchase")
                {
                    ApplicationArea = All;
                }
                field("Warranty Type"; Rec."Warranty Type")
                {
                    ApplicationArea = All;
                }
                field("Duration"; Rec."Duration")
                {
                    ApplicationArea = All;
                }
                field("Warranty Starting Date"; Rec."Warranty Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Warranty Ending Date"; Rec."Warranty Ending Date")
                {
                    ApplicationArea = All;
                }
                field("Warranty State"; Rec."Warranty State")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    views
    {
        view(ActiveWarranties)
        {
            Caption = 'Active Warranties', comment = 'ESP="Garantías Activas"';
            Filters = where("Warranty State"=const(Active));
        }
        view(InactiveWarranties)
        {
            Caption = 'Inactive Warranties', comment = 'ESP="Garantías Inactivas"';
            Filters = where("Warranty State"=const(Inactive));
        }
    }
}
