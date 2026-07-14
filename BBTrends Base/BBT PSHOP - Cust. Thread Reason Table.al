Table 50039 "PSHOP - Cust. Thread Reason"
{
    Caption = 'Motivos hilos Prestashop';
    //DrillDownPageID = "PSHOP - Cust. Thread Reasons";
    //LookupPageID = "PSHOP - Cust. Thread Reasons";

    ObsoleteState = Removed;        // BBT 01/07/2025

    fields
    {
        field(1; id; Integer)
        { }
        field(2; "Site Code"; Code[10])
        {
            TableRelation = "PSHOP - Site".Code;
        }
        field(100; "Reason Code"; Code[20])
        {
            Caption = 'Cód. Motivo';
            TableRelation = "Reason Code".Code;
        }
    }
    keys
    {
        key(Key1; "Site Code", id)
        {
            Clustered = true;
        }
    }
}
