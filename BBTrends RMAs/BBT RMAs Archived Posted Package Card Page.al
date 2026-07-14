Page 51232 "RMAs Archived Package Card"
{
    Caption = 'Sales Return Archived Package Card', Comment = 'ESP="Bulto Archivado Devolución Ventas"';
    PageType = Document;
    SourceTable = "RMAs Posted Package";
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DelayedInsert = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ESP="General"';
                field("Posted Package No."; Rec."Posted Package No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Posted No."; Rec."Posted No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Creation Date"; Rec."Posted Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Package Type"; Rec."Package Type")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = false;
                }
                field("Numbers Packages"; Rec."Numbers Packages")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Return Category"; Rec."Return Category")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = false;
                }
            }
            part(PostedPackageSubform; "RMAs Archived Package Subform")
            {
                ApplicationArea = Basic, Suite;
                Enabled = true;
                SubPageLink = "Posted Package No." = field("Posted Package No."), "Posted No." = field("Posted No.");
                UpdatePropagation = Both;
                Editable = false;
            }

        }
    }
    actions
    { }
}