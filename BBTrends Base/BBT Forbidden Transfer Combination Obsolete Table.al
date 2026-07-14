Table 50022 "Forbidden Transfer Combination"
{
    ObsoleteState = Removed;    // BBT 01/07/2025

    fields
    {
        field(1; "Transfer-from Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(2; "Transfer-to Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
    }
    keys
    {
        key(Key1; "Transfer-from Code", "Transfer-to Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
}
