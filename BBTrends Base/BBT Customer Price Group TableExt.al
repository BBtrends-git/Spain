TableExtension 50102 "BBT Customer Price Group" extends "Customer Price Group"
{

    fields
    {
        field(50000; "Description CRM"; Text[50])
        {
            Caption = 'Description CRM';
            ObsoleteState = Pending;        // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50001; "Last CRM Update"; DateTime)
        {
            Caption = 'Last CRM Update';
            ObsoleteState = Pending;        // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50002; "CRM ID"; Text[100])
        {
            ObsoleteState = Pending;        // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
    }
}
