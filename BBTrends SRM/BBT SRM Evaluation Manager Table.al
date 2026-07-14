table 51353 "SRM Evaluation Manager"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Evaluation Manager"; Text[50])
        {
            Caption = 'Evaluation Manager', Comment = 'ESP="Responsable Evaluación';
        }
    }

    keys
    {
        key(Key1; "Evaluation Manager")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Evaluation Manager")
        { }
    }
}