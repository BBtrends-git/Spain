PageExtension 50254 "BBT Production BOM Lines" extends "Production BOM Lines"
{
    layout
    {
        addafter("Ending Date")
        {
            field("Last Direct Cost"; Rec."Last Direct Cost")
            {
                ApplicationArea = Basic;
                DrillDown = false;
            }
        }
    }
    var
        ActiveVersionCode: Code[20];
        VersionMgt: Codeunit VersionManagement;
}
