page 51219 "RMAs Management Archives"
{
    Caption = 'Archives', Comment = 'ESP="Históricos"';
    PageType = CardPart;
    RefreshOnActivate = true;
    ApplicationArea = All;
    SourceTable = "RMAs Cue";
    Permissions = tabledata "RMAs Cue" = rm;

    layout
    {
        area(content)
        {
            cuegroup("PackagesArchived")
            {
                Caption = 'Packages Archived', Comment = 'ESP="Bultos Archivados"';
                field("Packages Archived"; rec."Package Archived")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "RMAs Archived Package List";
                }
            }
            cuegroup("PackagesTransferred")
            {
                Caption = 'Package Transferred', Comment = 'ESP="Bultos Transferidos"';
                field("Packages Transferred"; Rec."Package transferred")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "RMAs Transferred Package List";
                }
            }
        }
    }
}