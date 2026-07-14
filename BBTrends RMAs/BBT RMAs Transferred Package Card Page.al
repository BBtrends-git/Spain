Page 51221 "RMAs Transferred Package Card"
{
    Caption = 'Transferred Package Card', Comment = 'ESP="Bulto Transferido"';
    PageType = Document;
    SourceTable = "RMAs Stock Package";
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ESP="General"';

                field("Package No."; Rec."Package No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quality; Rec.Quality)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = false;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = false;
                }
                field("Return Resource"; Rec."Return Resource")
                {
                    ApplicationArea = All;
                }
                field("Package transferred"; Rec."Package transferred")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Transfer Order"; Rec."Transfer Order")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part(PackageSubform; "RMAs Transferred Package Subf")
            {
                ApplicationArea = All;
                Editable = false;
                Enabled = true;
                SubPageLink = "Package No." = field("Package No.");
                UpdatePropagation = Both;
            }
        }
    }
    actions
    { }
}