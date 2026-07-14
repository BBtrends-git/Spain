Page 51222 "RMAs Transferred Package List"
{
    Caption = 'Transferred Package List', Comment = 'ESP="Bultos Trasferidos"';
    Editable = false;
    PageType = List;
    SourceTable = "RMAs Stock Package";
    UsageCategory = Lists;
    ApplicationArea = all;
    CardPageId = "RMAs Transferred Package Card";
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;

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
                field(Quality; Rec.Quality)
                {
                    ApplicationArea = All;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                }
                field("Return Resource"; Rec."Return Resource")
                {
                    ApplicationArea = All;
                }
                field("Package transferred"; Rec."Package transferred")
                {
                    ApplicationArea = All;
                }
                field("Transfer Order"; Rec."Transfer Order")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    { }

    trigger OnOpenPage()
    begin
        rec.Init();
        rec.SetRange("Package transferred", true);
    end;
}