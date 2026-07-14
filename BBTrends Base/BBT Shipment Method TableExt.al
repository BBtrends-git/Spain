TableExtension 50105 "BBT Shipment Method" extends "Shipment Method"
{
    fields
    {
        field(50000; "Description CRM"; Text[50])
        {
            Caption = 'Description CRM';
            //>> BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
            ObsoleteState = Pending;
            //<<
        }
    }
}
