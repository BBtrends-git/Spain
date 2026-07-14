tableextension 50003 "BBT Sales Line Archive" extends "Sales Line Archive"
{
    fields
    {
        field(50061; "BBT Shipping Charge"; Boolean)
        {
            Caption = 'Shipping Charge', comment = 'ESP="Cargo portes"';
            Editable = false;
            DataClassification = ToBeClassified;
        }
    }
}
