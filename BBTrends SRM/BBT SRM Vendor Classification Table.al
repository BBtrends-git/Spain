table 51352 "SRM Vendor Classification"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Classification"; Text[50])
        {
            Caption = 'Classification', Comment = 'ESP="Clasificación';
        }
    }

    keys
    {
        key(Key1; Classification)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Classification)
        { }
    }
}