Page 51213 "RMAs Stock Package List"
{
    Caption = 'Stock Package List', Comment = 'ESP="RMA Bultos a Existencia"';
    Editable = false;
    PageType = List;
    SourceTable = "RMAs Stock Package";
    UsageCategory = Lists;
    ApplicationArea = all;
    CardPageId = "RMAs Stock Package Card";
    ModifyAllowed = true;

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
            }
        }
    }
    actions
    { }
}