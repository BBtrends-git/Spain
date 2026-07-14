TableExtension 50174 "BBT Sales Price" extends "Sales Price"
{
    fields
    {
        field(50000; "ID CRM"; Code[40])
        {
            DataClassification = CustomerContent;
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50001; "Últ. Actualización"; DateTime)
        {
            DataClassification = CustomerContent;
            ObsoleteState = Pending;                // BBT. 22/05/2025. Intregración Custom CRM Obsoleta.
        }
        field(50002; "En promocion"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'On Promotion', comment = 'ESP="En promoción"';
        }
    }
}
