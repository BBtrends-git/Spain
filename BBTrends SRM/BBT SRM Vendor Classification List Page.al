page 51352 "SRM Vendor Classification"
{
    ApplicationArea = All;
    Caption = 'Vendor Classification', comment = 'ESP="Clasificación Proveedores"';
    PageType = List;
    SourceTable = "SRM Vendor Classification";
    DeleteAllowed = true;
    ModifyAllowed = true;
    InsertAllowed = true;
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(Classif)
            {
                ShowCaption = false;

                field(Classification; Rec.Classification)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}