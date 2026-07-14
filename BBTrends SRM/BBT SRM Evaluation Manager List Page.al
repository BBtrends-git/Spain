page 51353 "SRM Evaluation Manager"
{
    ApplicationArea = All;
    Caption = 'Evaluation Manager', comment = 'ESP="Responsable Evaluación"';
    PageType = List;
    SourceTable = "SRM Evaluation Manager";
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

                field("Evaluation Manager"; Rec."Evaluation Manager")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}