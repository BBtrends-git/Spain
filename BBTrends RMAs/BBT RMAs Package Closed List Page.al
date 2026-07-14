Page 51236 "RMAs Package Closed List"
{
    Caption = 'Sales Return Closed Package List', Comment = 'ESP="RMA Bultos Cerrados Devolución Ventas"';
    Editable = false;
    PageType = List;
    SourceTable = "RMAs Package";
    UsageCategory = Lists;
    ApplicationArea = all;
    CardPageId = "RMAs Package Card";
    ModifyAllowed = true;
    SourceTableView = WHERE("Package Status" = const(Closed), "Registered Package" = const(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Package No."; Rec."Package No.")
                {
                    ApplicationArea = all;
                }
                field("Package Status"; Rec."Package Status")
                {
                    ApplicationArea = all;
                }
                field("Registered Package"; Rec."Registered Package")
                {
                    ApplicationArea = all;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = all;
                }
                field("Return Category"; Rec."Return Category")
                {
                    ApplicationArea = All;
                }
                field("Package Type"; Rec."Package Type")
                {
                    ApplicationArea = all;
                }
                field("Numbers Packages"; Rec."Numbers Packages")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    { }
}