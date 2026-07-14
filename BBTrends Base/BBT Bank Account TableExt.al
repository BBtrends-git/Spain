TableExtension 50138 "BBT Bank Account" extends "Bank Account"
{
    fields
    {
        modify("Check Report ID")
        {
            TableRelation = AllObj."Object ID" where("Object Type" = const(Report));
        }
        field(50000; "Sufijo presentador"; Text[3])
        { }
        field(50001; "Contrato Confirming"; Text[30])
        { }
    }
}
