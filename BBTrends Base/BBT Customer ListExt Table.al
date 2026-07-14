table 50120 "CustomerListExt"
{
    fields
    {
        field(1; myfield; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; myfield)
        {
            clustered = true;
        }
    }
}
