Page 51212 "RMAs Archived Package List"
{
    Caption = 'Archived Sales Return Package List', Comment = 'ESP="RMA Bultos Archivados Devolución Ventas"';
    PageType = List;
    SourceTable = "RMAs Posted Package";
    UsageCategory = Lists;
    ApplicationArea = all;
    CardPageId = "RMAs Archived Package Card";
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = false;
    SourceTableView = sorting("Posted Package No.", "Posted No.") order(descending) where("Fully Transferred" = const(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posted Package No."; Rec."Posted Package No.")
                {
                    ApplicationArea = all;
                }
                field("Posted No."; Rec."Posted No.")
                {
                    ApplicationArea = all;
                }
                field("Creation Date"; Rec."Posted Date")
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