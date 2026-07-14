PageExtension 50253 "BBT Production BOM List" extends "Production BOM List"
{
    layout
    {
        modify("Version Nos.")
        {
            Visible = false;
        }
        addafter("Description 2")
        {
            field(ActiveVersionCode; ActiveVersionCode)
            {
                ApplicationArea = Basic;
                Caption = 'Active Version';
            }
        }
    }
    var
        ActiveVersionCode: Code[20];
        VersionMgt: Codeunit VersionManagement;
}
